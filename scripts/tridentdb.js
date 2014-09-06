// TridentDatabase - a reusable keystore database which supports
//   indexeddb and web service backstores, as well as switching between them.
// 
// Part of TridentSandbox project hosted at GitHub :
// https://github.com/obeliskos/TridentSandbox
//
// This can serve as a basis for implementing your own service-based
// app/key/value keystore in whatever web/database environment you choose.

var TridentDatabase = function(tridentDb, settingsChangeCallback) {
	this.tridentDb = null;
	this.baseUrl = ""; 
	this.mode = "trident";		// 'trident' = use trident, 'service' = use svc api at baseurl

	// settingsCallback : (optional) fires when the user calls UpdateSettings()
	this.settingsCallback = null;
	if (typeof(settingsChangeCallback) == "function") {
		this.settingsCallback = settingsChangeCallback;
	}
	
	// use previous stored settings if they exist
	if (localStorage) {
		var svcurl = localStorage["TridentService"]; 
		if (svcurl != null && svcurl != "") {
			this.baseUrl = svcurl;
		}
		
		var apimode = localStorage["TridentMode"];
		if (apimode != null && apimode != "") {
			if (apimode == "trident" || apimode == "service") this.mode = apimode;
		}
	}
	
	// If the user passed in (an initialized) TridentDb, use it... otherwise, open/create it ourselves.
	if (typeof(tridentDb) != "undefined" && tridentDb != null) {
		this.tridentDb = tridentDb;
	}
	else {
		this.InitializeTridentDb();
	}
}

// Eventually this will be the default method for opening/creating the TridentDatabase.
// For now I still do this in the main .htm page due to need to trigger ui events
// In your own projects, if you create a TridentDatabase() class and pass it no parameters, it will 
//   use this nonintrusive code to setup the object store.
TridentDatabase.prototype.InitializeTridentDb = function()
{
	var openRequest = indexedDB.open("TridentSandboxDB", 1);

	// If database doesnt exist yet or its version is lower than our version specified above (2nd param in line above)
	openRequest.onupgradeneeded = function(e) {
		var thisDB = e.target.result;
		if (thisDB.objectStoreNames.contains("TridentSandboxKVP")) {
			thisDB.deleteObjectStore("TridentSandboxKVP");
		}
		
		if(!thisDB.objectStoreNames.contains("TridentSandboxKVP")) {
			var objectStore = thisDB.createObjectStore("TridentSandboxKVP", { keyPath: "id", autoIncrement:true });
			objectStore.createIndex("app","app", {unique:false});
			objectStore.createIndex("key","key", {unique:false});
			// hack to simulate composite key since overhead is low (main size should be in val field)
			// user (me) required to duplicate the app and key into comma delimited appkey field off object
			// This will allow retrieving single record with that composite key as well as 
			// still supporting opening cursors on app or key alone
			objectStore.createIndex("appkey", "appkey", {unique:true});
		}
	}

	openRequest.onsuccess = function(e) {
		this.tridentDb = e.target.result;
	}

	openRequest.onerror = function(e) {
	}
}

TridentDatabase.prototype.UpdateSettings = function(tridentDb, baseUrl, mode) {
	if (mode != this.mode) {
		this.mode = mode;
		if (localStorage) {
			localStorage["TridentMode"] = mode; 
		}
	}
	
	if (typeof(tridentDb) != "undefined" && tridentDb != null) {
		this.tridentDb = tridentDb;
	}
	
	if (typeof(baseUrl) != undefined && baseUrl != null) {
		this.baseUrl = baseUrl;
		if (localStorage) {
			localStorage["TridentService"] = baseUrl; 
		}
	}
	
	if (this.settingsCallback != null) this.settingsCallback();
}

TridentDatabase.prototype.SwitchMode = function(mode) {
	if (mode != this.mode) {
		this.mode = mode;
		if (localStorage) {
			localStorage["TridentMode"] = mode; 
		}
	}
	if (this.settingsCallback != null) this.settingsCallback();
}

TridentDatabase.prototype.SetServiceLocation = function(baseUrl) {
	if (typeof(baseUrl) != undefined && baseUrl != null) {
		this.baseUrl = baseUrl;
		if (localStorage) {
			localStorage["TridentService"] = baseUrl; 
		}
	}
	if (this.settingsCallback != null) this.settingsCallback();
}

// GET APP KEY BY APP,KEY
TridentDatabase.prototype.GetAppKey = function (app, key, callback) {
	if (this.mode == "service") return this.GetAppKeyService(app, key, callback);
	
	return this.GetAppKeyIndexed(app, key, callback);
}

TridentDatabase.prototype.GetAppKeyIndexed = function(app, key, callback) {
	var transaction = this.tridentDb.transaction(["TridentSandboxKVP"],"readonly");
	var store = transaction.objectStore("TridentSandboxKVP");
	var index = store.index("appkey");
  	var appkey = app + "," + key;
  	var request = index.get(appkey);

  	request.onsuccess = (function(usercallback) {
		return function(e) {
			if (typeof(usercallback) == "function") {
				var lres = e.target.result;
				if (typeof(lres) == "undefined") lres = { id: 0, success: false };
				
				usercallback(lres);
			}
		}
	})(callback);
	
	request.onerror = (function(usercallback) {
		return function(e) {
			if (typeof(usercallback) == "function") usercallback({ id: 0, success: false });
		}
	})(callback);
}

TridentDatabase.prototype.GetAppKeyService = function(app, key, callback) {
	var params = { "App": app, "Key": key };

	$.ajax({
		url: this.baseUrl + 'GetKey',
		type: "POST",
		data: params,
		cache: false,
		dataType: 'json',
		usercallback: callback,
		success: function (result) {
			if (typeof(this.usercallback) == "function") this.usercallback(result);
		},
		error: function (req, status, error) {
			//alert(error);
			if (typeof(this.usercallback) == "function") this.usercallback(null);
		}
	});
}

// GET APP KEY BY ID
TridentDatabase.prototype.GetAppKeyById = function (id, callback, data) {
	if (this.mode == "service") return this.GetAppKeyByIdService(id, callback, data);
	
	return this.GetAppKeyByIdIndexedDb(id, callback, data);
}

TridentDatabase.prototype.GetAppKeyByIdIndexedDb = function (id, callback, data) {
	var transaction = this.tridentDb.transaction(["TridentSandboxKVP"],"readonly");
	var store = transaction.objectStore("TridentSandboxKVP");
  	var request = store.get(id);

	request.onsuccess = (function(data, usercallback){
		return function(e) { 
			if (typeof(usercallback) == "function") usercallback(e.target.result, data) 
		};
	})(data, callback);   
}

TridentDatabase.prototype.GetAppKeyByIdService = function(id, callback, data) {
	var params = { "id": id };

	$.ajax({
		url: this.baseUrl + 'GetKeyById',
		type: "POST",
		data: params,
		cache: false,		
		dataType: 'json',
		usercallback: callback,
		userdata: data,
        success: function (result) {
			if (typeof(this.usercallback) == "function") this.usercallback(result, this.userdata);
        },
        error: function (req, status, error) {
			if (typeof(this.usercallback) == "function") this.usercallback(null, this.userdata);
        }
	});
}

// SET APP KEY
TridentDatabase.prototype.SetAppKey = function(app, key, val, callback) {
	if (this.mode == "service") return this.SetAppKeyService(app, key, val, callback);
	
	return this.SetAppKeyIndexedDb(app, key, val, callback);
}

TridentDatabase.prototype.SetAppKeyIndexedDb = function (app, key, val, callback) {
	var transaction = this.tridentDb.transaction(["TridentSandboxKVP"],"readwrite");
    var store = transaction.objectStore("TridentSandboxKVP");
	var index = store.index("appkey");
  	var appkey = app + "," + key;
  	var request = index.get(appkey);

	// first try to retrieve an existing object by that key
	// need to do this because to update an object you need to have id in object, otherwise it will append id with new autocounter and clash the unique index appkey
	request.onsuccess = function(e) {
		var res = e.target.result;
		
		if (res == null) {
			res = {
				app:app,
				key:key,
				appkey: app + ',' + key,
				val:val
			}
		}
		else {
			res.val = val;
		}
		
		var requestPut = store.put(res);
 
		requestPut.onerror = (function(usercallback) {
			return function(e) {
				if (typeof(usercallback) == "function") usercallback({ success: false });
			}
		})(callback);
		
		requestPut.onsuccess = (function(usercallback) {
			return function(e) {
				if (typeof(usercallback) == "function") usercallback({ success: true });	// e.target.result has id?
			}
		})(callback);
	};
	
	request.onerror = (function(usercallback) {
		return function(e) {
			if (typeof(usercallback) == "function") usercallback({ success: false });
		}
	})(callback);
}

TridentDatabase.prototype.SetAppKeyService = function (app, key, val, callback) {
	var params = { "app": app, "key": key, "val": val };

	$.ajax({
		url: this.baseUrl + 'SetKey',
		type: "POST",
		data: params,
		cache: false,
		dataType: 'json',
		usercallback: callback,
		success: function (result) {
			if (typeof(this.usercallback) == "function") this.usercallback(result);
		},
		error: function (req, status, error) {
			if (typeof(this.usercallback) == "function") this.usercallback(null);
		}
	});
}

// DELETE APP KEY BY ID
TridentDatabase.prototype.DeleteAppKey = function (id, callback) {
	if (this.mode == "service") return this.DeleteAppKeyService(id, callback);
	
	return this.DeleteAppKeyIndexedDb(id, callback);
}

TridentDatabase.prototype.DeleteAppKeyIndexedDb = function (id, callback) {	
	var transaction = this.tridentDb.transaction(["TridentSandboxKVP"],"readwrite");
	var store = transaction.objectStore("TridentSandboxKVP");
	
	var request = store.delete(id);
	
	request.onsuccess = (function(usercallback) {
		return function(evt) {
			if (typeof(usercallback) == "function") usercallback({ success: true });
		};
	})(callback);
	
	request.onerror = (function(usercallback) {
		return function(evt) {
			if (typeof(usercallback) == "function") usercallback(false);
		}
	})(callback);
}

TridentDatabase.prototype.DeleteAppKeyService = function (id, callback) {
	var params = { "id": id };

	$.ajax({
		url: this.baseUrl + 'RemoveKey',
		type: "POST",
		data: params,
		cache: false,
		dataType: 'json',
		usercallback: callback,
		success: function (result) {
			if (typeof(this.usercallback) == "function") this.usercallback(result);
		},
		error: function (req, status, error) {
			if (typeof(this.usercallback) == "function") this.usercallback({ success: false });
		}
	});
}

// GET APP KEYS BY ID, RETURN ARRAY
TridentDatabase.prototype.GetAppKeys = function (app, callback) {
	if (this.mode == "service") return this.GetAppKeysService(app, callback);
	
	return this.GetAppKeysIndexedDb(app, callback);
}

// Hide 'cursoring' and return array of { id: id, key: key }
TridentDatabase.prototype.GetAppKeysIndexedDb = function(app, callback) {
	var transaction = this.tridentDb.transaction(["TridentSandboxKVP"], "readonly");
	var store = transaction.objectStore("TridentSandboxKVP");
	var index = store.index("app");
 
	// We want cursor to all values matching our (single) app param
	var singleKeyRange = IDBKeyRange.only(app);

	// Match anything past "Bill", including "Bill"
	//var lowerBoundKeyRange = IDBKeyRange.lowerBound("Bill");

	// Match anything past "Bill", but don't include "Bill"
	//var lowerBoundOpenKeyRange = IDBKeyRange.lowerBound("Bill", true);

	// Match anything up to, but not including, "Donna"
	//var upperBoundOpenKeyRange = IDBKeyRange.upperBound("Donna", true);

	// Match anything between "Bill" and "Donna", but not including "Donna"
	//var boundKeyRange = IDBKeyRange.bound("Bill", "Donna", false, true);

	// To use one of the key ranges, pass it in as the first argument of openCursor()/openKeyCursor()
	var cursor = index.openCursor(singleKeyRange);
 
	// cursor internally, pushing results into this.data[] and return 
	// this.data[] when done (similar to service)
	var localdata = [];
 
	cursor.onsuccess = (function(data, callback) {
		return function(e) {
			var cursor = e.target.result;
			if (cursor) {
				var currObject = cursor.value;
				
				data.push(currObject);
				
				cursor.continue();
			}
			else {
				if (typeof(callback) == "function") callback(data);
			}
		}
	})(localdata, callback);
	
	cursor.onerror = (function(usercallback) {
		return function(e) {
			if (typeof(usercallback) == "function") usercallback(null);
		}
	})(callback);

}

TridentDatabase.prototype.GetAppKeysService = function(app, callback) {
	var params = { "App": app };

	$.ajax({
		url: this.baseUrl + 'GetAppKeys',
		type: "POST",
		data: params,
		cache: false,
		usercallback: callback,
		dataType: 'json',
		success: function (result) {
			if (typeof(this.usercallback) == "function") this.usercallback(result);
		},
		error: function (req, status, error) {
			if (typeof(this.usercallback) == "function") this.usercallback(null);
		}
	});
}

// GET ALL KEYS, RETURN ARRAY
TridentDatabase.prototype.GetAllKeys = function (callback) {
	if (this.mode == "service") return this.GetAllKeysService(callback);
	
	return this.GetAllKeysIndexedDb(callback);
}

// Hide 'cursoring' and return array of { id: id, key: key }
TridentDatabase.prototype.GetAllKeysIndexedDb = function (callback) {
	var transaction = this.tridentDb.transaction(["TridentSandboxKVP"], "readonly");
	var store = transaction.objectStore("TridentSandboxKVP");
	var cursor = store.openCursor();
 
	var localdata = [];
 
	cursor.onsuccess = (function(data, callback) {
		return function(e) {
			var cursor = e.target.result;
			if (cursor) {
				var currObject = cursor.value;
				
				data.push(currObject);
				
				cursor.continue();
			}
			else {
				if (typeof(callback) == "function") callback(data);
			}
		}
	})(localdata, callback);
	
	cursor.onerror = (function(usercallback) {
		return function(e) {
			if (typeof(usercallback) == "function") usercallback(null);
		}
	})(callback);

}

TridentDatabase.prototype.GetAllKeysService = function(callback) {
	$.ajax({
		url: this.baseUrl + 'GetAllKeys',
		type: "POST",
		//data: params,
		cache: false,
		dataType: 'json',
		usercallback: callback,
		success: function (result) {
			if (typeof(this.usercallback) == "function") this.usercallback(result);
		},
		error: function (req, status, error) {
			if (typeof(this.usercallback) == "function") this.usercallback(null);
		}
	});
}

