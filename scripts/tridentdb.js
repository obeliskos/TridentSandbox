/*
    TridentDatabase - a reusable keystore database which supports
    indexeddb and web service backstores, as well as switching between them.
 
    Part of TridentSandbox project hosted at GitHub :
    https://github.com/obeliskos/TridentSandbox

    This can serve as a basis for implementing your own service-based
    app/key/value keystore in whatever web/database environment you choose.
*/

function nullFunction () {
}

//#region In-Memory Adapter

function TridentMemoryAdapter(options) {
    var self = this;

    this.name = "memory adapter";

    this.successCallback = nullFunction;
    this.errorCallback = nullFunction;

    if (options.hasOwnProperty("successCallback")) this.successCallback = options.successCallback;
    if (options.hasOwnProperty("errorCallback")) this.errorCallback = options.errorCallback;

    this.db = new loki("trident memory");
    this.kvpColl = this.db.addCollection("kvp");

    setTimeout(function () {
        self.successCallback();
    }, 1);
}

TridentMemoryAdapter.prototype.getAllKeys = function (callback) {
    var result = this.kvpColl.find();
    if (!result) result = [];
    result = result.map(function (obj) {
        return {
            id: obj.$loki,
            app: obj.app,
            key: obj.key,
            size: obj.app.length + obj.key.length + obj.val.length
        };
    });

    if (typeof (callback) === "function") callback(result);
};

TridentMemoryAdapter.prototype.getAppKeys = function (app, callback) {
    var result = this.kvpColl.find({ 'app': app });
    if (!result) result = [];
    result = result.map(function (obj) {
        return {
            id: obj.$loki,
            app: obj.app,
            key: obj.key,
            size: obj.app.length + obj.key.length + obj.val.length
        };
    });

    if (typeof (callback) === "function") callback(result);
};

TridentMemoryAdapter.prototype.getAppKey = function (app, key, callback) {
    var result = this.kvpColl.findOne({ '$and': [{ 'app': app }, { 'key': key }] });

    if (typeof (callback) === "function") {
        if (!result) {
            callback(result);
            return;
        }

        callback({
            id: result.$loki,
            app: result.app,
            key: result.key,
            val: result.val
        });
    };
};

TridentMemoryAdapter.prototype.getAppKeyById = function (id, callback) {
    var result = this.kvpColl.get(id);

    if (typeof (callback) === "function") {
        if (!result) {
            callback(null);
            return;
        }

        callback({
            id: result.$loki,
            app: result.app,
            key: result.key,
            val: result.val
        });
    }
};

TridentMemoryAdapter.prototype.setAppKey = function (app, key, val, callback) {
    var result = this.kvpColl.findOne({ '$and': [{ 'app': app }, { 'key': key }] });

    if (result) {
        result.val = val;
        this.kvpColl.update(result);
    }
    else {
        this.kvpColl.insert({
            app: app,
            key: key,
            val: val
        });
    }

    if (typeof (callback) === "function") callback({ success: true });
};

TridentMemoryAdapter.prototype.deleteAppKey = function (id, callback) {
    var result = this.kvpColl.get(id);

    if (!result) {
        if (typeof (callback) === "function") callback({ success: false });
        return;
    }

    this.kvpColl.remove(id);

    if (typeof (callback) === "function") callback({ success: true });
};

//#endregion

//#region IndexedDB Adapter

/*
 * A persistence adapter for trident app/key/value database, implemented as indexedDB store
 */
function TridentIndexedAdapter(options) {
    this.name = "indexedDB";
    this.db = null;
    this.upgradeCallback = nullFunction;
    this.successCallback = nullFunction;
    this.errorCallback = nullFunction;

    if (options.hasOwnProperty("upgradeCallback")) this.upgradeCallback = options.upgradeCallback;
    if (options.hasOwnProperty("successCallback")) this.successCallback = options.successCallback;
    if (options.hasOwnProperty("errorCallback")) this.errorCallback = options.errorCallback;

    this.initializeDatabase();
}

TridentIndexedAdapter.prototype.initializeDatabase = function () {
    var openRequest = indexedDB.open("TridentSandboxDB", 1);

    var self = this;

    // If database doesnt exist yet or its version is lower than our version specified above (2nd param in line above)
    openRequest.onupgradeneeded = function (e) {
        self.db = e.target.result;
        if (self.db.objectStoreNames.contains("TridentSandboxKVP")) {
            self.db.deleteObjectStore("TridentSandboxKVP");
        }

        if (!self.db.objectStoreNames.contains("TridentSandboxKVP")) {
            var objectStore = self.db.createObjectStore("TridentSandboxKVP", { keyPath: "id", autoIncrement: true });
            objectStore.createIndex("app", "app", { unique: false });
            objectStore.createIndex("key", "key", { unique: false });
            // hack to simulate composite key since overhead is low (main size should be in val field)
            // user (me) required to duplicate the app and key into comma delimited appkey field off object
            // This will allow retrieving single record with that composite key as well as 
            // still supporting opening cursors on app or key alone
            objectStore.createIndex("appkey", "appkey", { unique: true });
        }

        self.upgradeCallback();
    };

    openRequest.onsuccess = function (e) {
        self.db = e.target.result;

        self.successCallback(self);
    };

    openRequest.onerror = function (e) {
        self.errorCallback();
    };
};

TridentIndexedAdapter.prototype.getAllKeys = function (callback) {
    var transaction = this.db.transaction(["TridentSandboxKVP"], "readonly");
    var store = transaction.objectStore("TridentSandboxKVP");
    var cursor = store.openCursor();

    // because of cursoring our onsuccess callback will fire many times pushing results into function scoped array
    var localdata = [];

    cursor.onsuccess = (function (data, callback) {
        return function (e) {
            var cursor = e.target.result;
            if (cursor) {
                var currObject = cursor.value;
                var summObject = {
                    id: currObject.id,
                    app: currObject.app,
                    key: currObject.key,
                    size : currObject.app.length * 2 + currObject.key.length * 2 + currObject.val.length + 1
                };

                data.push(summObject);

                cursor.continue();
            }
            else {
                if (typeof (callback) === "function") callback(data);
            }
        };
    })(localdata, callback);

    cursor.onerror = (function (usercallback) {
        return function (e) {
            if (typeof (usercallback) === "function") usercallback(null);
        };
    })(callback);

};


// GET APP KEYS BY ID, RETURN ARRAY
// Hide 'cursoring' and return array of { id: id, key: key }
TridentIndexedAdapter.prototype.getAppKeys = function (app, callback) {
    var transaction = this.db.transaction(["TridentSandboxKVP"], "readonly");
    var store = transaction.objectStore("TridentSandboxKVP");
    var index = store.index("app");

    // We want to cursor all values matching our (single) app param
    var singleKeyRange = IDBKeyRange.only(app);
    var cursor = index.openCursor(singleKeyRange);

    // cursor internally, pushing results into this.data[] and return 
    // this.data[] when done (similar to service)
    var localdata = [];

    cursor.onsuccess = (function (data, callback) {
        return function (e) {
            var cursor = e.target.result;
            if (cursor) {
                var currObject = cursor.value;
                var summObject = {
                    id: currObject.id,
                    app: currObject.app,
                    key: currObject.key,
                    size: currObject.app.length * 2 + currObject.key.length * 2 + currObject.val.length + 1
                };

                data.push(summObject);

                cursor.continue();
            }
            else {
                if (typeof (callback) === "function") callback(data);
            }
        };
    })(localdata, callback);

    cursor.onerror = (function (usercallback) {
        return function (e) {
            if (typeof (usercallback) === "function") usercallback(null);
        };
    })(callback);

};

TridentIndexedAdapter.prototype.getAppKey = function (app, key, callback) {
    var transaction = this.db.transaction(["TridentSandboxKVP"], "readonly");
    var store = transaction.objectStore("TridentSandboxKVP");
    var index = store.index("appkey");
    var appkey = app + "," + key;
    var request = index.get(appkey);

    request.onsuccess = (function (usercallback) {
        return function (e) {
            if (typeof (usercallback) === "function") {
                var lres = e.target.result;
                if (typeof (lres) === "undefined") lres = { id: 0, success: false };

                usercallback(lres);
            }
        };
    })(callback);

    request.onerror = (function (usercallback) {
        return function (e) {
            if (typeof (usercallback) === "function") usercallback({ id: 0, success: false });
        };
    })(callback);
};

TridentIndexedAdapter.prototype.getAppKeyById = function (id, callback) {
    var transaction = this.db.transaction(["TridentSandboxKVP"], "readonly");
    var store = transaction.objectStore("TridentSandboxKVP");
    var request = store.get(id);

    request.onsuccess = (function (usercallback) {
        return function (e) {
            if (typeof (usercallback) === "function") usercallback(e.target.result);
        };
    })(callback);
};

// SET APP KEY
TridentIndexedAdapter.prototype.setAppKey = function (app, key, val, callback) {
    var transaction = this.db.transaction(["TridentSandboxKVP"], "readwrite");
    var store = transaction.objectStore("TridentSandboxKVP");
    var index = store.index("appkey");
    var appkey = app + "," + key;
    var request = index.get(appkey);

    // first try to retrieve an existing object by that key
    // need to do this because to update an object you need to have id in object, otherwise it will append id with new autocounter and clash the unique index appkey
    request.onsuccess = function (e) {
        var res = e.target.result;

        if (!res) {
            res = {
                app: app,
                key: key,
                appkey: app + ',' + key,
                val: val
            };
        }
        else {
            res.val = val;
        }

        var requestPut = store.put(res);

        requestPut.onerror = (function (usercallback) {
            return function (e) {
                if (typeof (usercallback) === "function") usercallback({ success: false });
            };
        })(callback);

        requestPut.onsuccess = (function (usercallback) {
            return function (e) {
                if (typeof (usercallback) === "function") usercallback({ success: true });	// e.target.result has id?
            };
        })(callback);
    };

    request.onerror = (function (usercallback) {
        return function (e) {
            if (typeof (usercallback) === "function") usercallback({ success: false });
        };
    })(callback);
};

// DELETE APP KEY BY ID
TridentIndexedAdapter.prototype.deleteAppKey = function (id, callback) {
    var transaction = this.db.transaction(["TridentSandboxKVP"], "readwrite");
    var store = transaction.objectStore("TridentSandboxKVP");

    var request = store.delete(id);

    request.onsuccess = (function (usercallback) {
        return function (evt) {
            if (typeof (usercallback) === "function") usercallback({ success: true });
        };
    })(callback);

    request.onerror = (function (usercallback) {
        return function (evt) {
            if (typeof (usercallback) === "function") usercallback(false);
        };
    })(callback);
};

//#endregion

//#region Ajax WebService Adapter

function TridentServiceAdapter(options) {
    this.name = "service";

    this.serviceLocation = "";
    this.successCallback = nullFunction;
    this.errorCallback = nullFunction;

    if (options.hasOwnProperty("serviceLocation")) {
        this.serviceLocation = options.serviceLocation;
    }

    if (typeof (options.successCallback) === "function") {
        this.successCallback = options.successCallback;
    }

    if (typeof (options.errorCallback) === "function") {
        this.errorCallback = options.errorCallback;
    }

    // for now, we wont bother to check if base url is valid by making ficticious service call, so we will just return true.
    // errors can be determined upon actual use.
    setTimeout(this.successCallback, 1);
    //this.successCallback();
}

TridentServiceAdapter.prototype.getAllKeys = function (callback) {
    $.ajax({
        url: this.serviceLocation + 'GetAllKeys',
        type: "POST",
        cache: false,
        dataType: 'json',
        usercallback: callback,
        success: function (result) {
            if (typeof (this.usercallback) === "function") this.usercallback(result);
        },
        error: function (req, status, error) {
            if (typeof (this.usercallback) === "function") this.usercallback(null);
        }
    });
};

TridentServiceAdapter.prototype.getAppKeys = function (app, callback) {
    var params = { "App": app };

    $.ajax({
        url: this.serviceLocation + 'GetAppKeys',
        type: "POST",
        data: params,
        cache: false,
        usercallback: callback,
        dataType: 'json',
        success: function (result) {
            if (typeof (this.usercallback) === "function") this.usercallback(result);
        },
        error: function (req, status, error) {
            if (typeof (this.usercallback) === "function") this.usercallback(null);
        }
    });
};

TridentServiceAdapter.prototype.getAppKey = function (app, key, callback) {
    var params = { "App": app, "Key": key };

    $.ajax({
        url: this.serviceLocation + 'GetKey',
        type: "POST",
        data: params,
        cache: false,
        dataType: 'json',
        usercallback: callback,
        success: function (result) {
            if (typeof (this.usercallback) === "function") this.usercallback(result);
        },
        error: function (req, status, error) {
            //alert(error);
            if (typeof (this.usercallback) === "function") this.usercallback(null);
        }
    });
};

// GET APP KEY BY ID
TridentServiceAdapter.prototype.getAppKeyById = function (id, callback) {
    var params = { "id": id };

    $.ajax({
        url: this.serviceLocation + 'GetKeyById',
        type: "POST",
        data: params,
        cache: false,
        dataType: 'json',
        usercallback: callback,
        success: function (result) {
            if (typeof (this.usercallback) === "function") this.usercallback(result);
        },
        error: function (req, status, error) {
            if (typeof (this.usercallback) === "function") this.usercallback(null);
        }
    });
};

TridentServiceAdapter.prototype.setAppKey = function (app, key, val, callback) {
    var params = { "app": app, "key": key, "val": val };

    $.ajax({
        url: this.serviceLocation + 'SetKey',
        type: "POST",
        data: params,
        cache: false,
        dataType: 'json',
        usercallback: callback,
        success: function (result) {
            if (typeof (this.usercallback) === "function") this.usercallback(result);
        },
        error: function (req, status, error) {
            if (typeof (this.usercallback) === "function") this.usercallback(null);
        }
    });
};

TridentServiceAdapter.prototype.deleteAppKey = function (id, callback) {
    var params = { "id": id };

    $.ajax({
        url: this.serviceLocation + 'RemoveKey',
        type: "POST",
        data: params,
        cache: false,
        dataType: 'json',
        usercallback: callback,
        success: function (result) {
            if (typeof (this.usercallback) === "function") this.usercallback(result);
        },
        error: function (req, status, error) {
            if (typeof (this.usercallback) === "function") this.usercallback({ success: false });
        }
    });
};

//#endregion