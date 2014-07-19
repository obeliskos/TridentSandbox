importScripts("cryptojs/components/core.js");
importScripts("cryptojs/components/lib-typedarrays.js");
importScripts("cryptojs/components/enc-base64-min.js");
importScripts("cryptojs/components/enc-utf16-min.js");
importScripts("cryptojs/rollups/sha1.js");
importScripts("cryptojs/rollups/aes.js");
importScripts("cryptojs/rollups/md5.js");
importScripts("cryptojs/rollups/hmac-sha1.js");

// Fix for IE 10 and possibly IE 11 (on 8.1 update 0, or win7)
// Needed for Crypto.JS to work properly with typearray lib
if (typeof Uint8ClampedArray == "undefined") {
	Uint8ClampedArray = Uint8Array;
}

self.addEventListener("message", function(e) {
    // the passed-in data is available via e.data
	var result = {
		id: e.data.id,
		val : "",
		algorithm : e.data.algorithm,
		action : e.data.action
	};
	
	// Operations simple enough that I won't bother breaking out into helper functions
	
	// Handle Encryption 
	if (e.data.algorithm == "aes") {
		if (e.data.action == "encrypt") {
			result.val = CryptoJS.AES.encrypt(e.data.val, e.data.password).toString();
		}
		
		if (e.data.action == "decrypt") {
			result.val = CryptoJS.AES.decrypt(e.data.val, e.data.password).toString(CryptoJS.enc.Utf8);
		}
		
		// multipass encrypt - stack issues... use with caution (probably ok with small data < 1MB)
		if (e.data.action == "mpencrypt") {
			var revpass = e.data.password.split("").reverse().join("");

			result.val = CryptoJS.AES.encrypt(CryptoJS.AES.encrypt(e.data.val, e.data.password).toString(), revpass).toString();
		}
		
		if (e.data.action == "mpdecrypt") {
			var revpass = e.data.password.split("").reverse().join("");
                
			result.val = CryptoJS.AES.decrypt(CryptoJS.AES.decrypt(e.data.val, revpass).toString(CryptoJS.enc.Utf8), e.data.password).toString(CryptoJS.enc.Utf8); 
		}
	}
	
	if (e.data.algorithm == "md5") {
		var warray = CryptoJS.lib.WordArray.create(e.data.val);
        result.val = CryptoJS.MD5(warray).toString();
	}
	
	if (e.data.algorithm == "sha1") {
		var warray = CryptoJS.lib.WordArray.create(e.data.val);
		result.val = CryptoJS.SHA1(warray).toString();
	}
	
	postMessage(result);
	
    self.close();

}, false);


