/*
 * Scripts needed to support all versions of TridentSandbox (WinJS, Regular, and loaders)
 * 
 * @author - Dave Easterday
 * 
 * https://github.com/obeliskos/TridentSandbox
 */

//#region logger

var sbxLogger = {
    log: function (msg) {
        if (sandbox.volatile.env === "IDE" || sandbox.volatile.env === "IDE WJS") {
            $("#UI_TxtLogText").val($("#UI_TxtLogText").val() + msg + "\r\n");

            // Using flag variable to prevent multiple consecutive logmessage calls from overloading the flash effect
            // Will only flash once every 4 seconds
            if (!sandbox.volatile.flashTextTab) {
                sandbox.volatile.flashTextTab = true;

                // not sure if there is a more elegant jquery selector but this will flash the text log tab header to indicate activity on that tab
                $($($("#UI_TabsOutput").find("ul")[0]).find("li")[1]).find("a").effect("pulsate", {}, 1000);

                setTimeout(function () { sandbox.volatile.flashTextTab = false; }, 4000);
            }
        }
        else {
            console.log(msg)
        }
    },
    logObject: function (objToLog, objName) {
        if (objName != null && (typeof (objName) == "string"))
            this.log(objName + " = ");

        if (sandbox.volatile.env === "SBL" || sandbox.volatile.env == "SBL WJS") {
            console.dir(objToLog);
        }
        else {
            this.log(JSON.stringify(objToLog, null, '\t'));
        }
        
    },
    clearLog: function() {
        if (sandbox.volatile.env === "SBL" || sandbox.volatile.env == "SBL WJS") {
            return;
        }

        $("#UI_TxtLogText").val("");
    },
    trace: function () {
        var stack;

        try {
            throw new Error('');
        }
        catch (error) {
            stack = error.stack || '';
        }

        stack = stack.split('\n').map(function (line) { return line.trim(); });
        //API_Inspect(stack);

        var result = stack.splice(stack[0] == 'Error' ? 2 : 1);
        this.log(result);
        return result;
        //return stack.splice(stack[0] == 'Error' ? 2 : 1);

        //console.trace();
    },
    inspect: function (objVar, caption) {
        caption = caption || "Trident Object Inspector";

        var tbl = prettyPrint(objVar, { /* options such as maxDepth, etc. */ });
        $(tbl).dialog({ title: caption, width: 'auto', maxHeight: ($(window).height() - 50) });
    },
    notify: function (msg, caption) {
        alertify.log(msg);
    },
    notifySuccess: function (msg, caption) {
        alertify.success(msg);
    },
    notifyError: function (msg, caption) {
        alertify.error(msg);
    }
}

var sandboxMedia = {
    playAudio: function (uri) {
        var aud = new Audio();
        aud.src = uri;
        aud.load();
        aud.play();
    },
    speak: function (msgText) {
        if (!this.isSpeechAvailable) {
            sandbox.logger.notifyError("Speech API is not supported by this browser");
            return;
        }

        var msg = new SpeechSynthesisUtterance(msgText);
        window.speechSynthesis.speak(msg);
    },
    isSpeechAvailable: (typeof (SpeechSynthesisUtterance) !== "undefined")
}

//#endregion logger

//#region memstats
var sandboxMemstats = {
    on: function () {
        sandbox.volatile.memStats = new MemoryStats();

        sandbox.volatile.memStats.domElement.style.position = 'fixed';
        sandbox.volatile.memStats.domElement.style.left = '210px';
        sandbox.volatile.memStats.domElement.style.top = '5px';

        document.body.appendChild(sandbox.volatile.memStats.domElement);

        sandbox.volatile.memStatsRequestId = requestAnimationFrame(function rAFloop() {
            sandbox.volatile.memStats.update();
            sandbox.volatile.memStatsRequestId = requestAnimationFrame(rAFloop);
        });

    },
    off: function () {
        if (sandbox.volatile.memStats == null) return;

        window.cancelAnimationFrame(sandbox.volatile.memStatsRequestId);

        document.body.removeChild(sandbox.volatile.memStats.domElement);
        sandbox.volatile.memStats = null;
        sandbox.volatile.memStatsRequestId = null;
    }
}
//#endregion

//#region files

var sandboxFiles = {
    programPicked: function () {
        // use most thorough method for cleaning sandbox
        sb_clean_sandbox();

        var file = document.getElementById('sb_file').files[0];
        if (file) {
            var reader = new FileReader();

            reader.readAsText(file, "UTF-8");

            // Handle progress, success, and errors
            //reader.onprogress = updateProgress;
            reader.onload = sandbox.files.programLoaded;
            reader.onerror = sandbox.files.genericLoadError;
        }
    },
    programLoaded: function (evt) {
        //        if (sandbox.volatile.env == "SBL" || sandbox.volatile.env == "SBL WJS") {
        //            console.log("ignoring call to sb_loaded");
        //            return;
        //        }

        var filestring = evt.target.result;

        var sandboxObject = JSON.parse(filestring);

        $("#sb_txt_ProgramName").val(sandboxObject.progName);

        sandbox.volatile.markupHash = CryptoJS.SHA1(sandboxObject.htmlText).toString();
        sandbox.volatile.scriptHash = CryptoJS.SHA1(sandboxObject.scriptText).toString();

        sandbox.volatile.editorMarkup.setValue(sandboxObject.htmlText);
        sandbox.volatile.editorScript.setValue(sandboxObject.scriptText);

        // IE's HTML 5 file control seems to place a lock on the last loaded file which
        // was interfering with the saving and overwriting of that same file.
        // So i will reset it by destroying and recreating, allowing the GC to release
        // any old file locks.
        var control = $("#sb_file");
        control.replaceWith(control = control.clone(true));
    },
    programSave: function () {
        if (sandbox.volatile.env == "SBL" || sandbox.volatile.env == "SBL WJS") {
            console.log("ignoring call to sb_save");
            return;
        }

        var prgName = $("#sb_txt_ProgramName").val();
        if (prgName == "") {
            alertify.error("You need to enter a program name first");
            return;
        }

        // The File Loaders seem to place a lock on the file so, in the event they are saving to the same filename,
        // lets clear out the old file control so that (if they save to the same filename as they last loaded) it will work.
        // The actual save still waits on user input to handle the save, so no need to setTimeout
        var control = $("#sb_file");
        control.replaceWith(control = control.clone(true));

        var progNameString = prgName;
        var htmlTextString = sandbox.volatile.editorMarkup.getValue();
        var scriptTextString = sandbox.volatile.editorScript.getValue();

        sandbox.volatile.markupHash = CryptoJS.SHA1(htmlTextString).toString();
        sandbox.volatile.scriptHash = CryptoJS.SHA1(scriptTextString).toString();

        var sandboxObject = { progName: progNameString, htmlText: htmlTextString, scriptText: scriptTextString };

        var json_text = JSON.stringify(sandboxObject, null, 2);

        // Both IE and polyfill methods seem to rely on blobs
        if (typeof Blob == "undefined") {
            alert('no blobs available (incompatible browser?)');
            return;
        }

        // if ms specific (ie) method msSaveBlob is not present then use the polyfill filesaver.js functionality
        if (window.navigator.msSaveBlob === undefined) {
            var blob = new Blob([json_text], { type: "application/octet-stream" });
            saveAs(blob, progNameString + ".prg");
        }
        else {
            var blob1 = new Blob([json_text]);
            window.navigator.msSaveBlob(blob1, progNameString + ".prg");
        }

    },
    genericLoadError: function (evt) {
        alertify.error('load error');
    },
    userfileHide: function () {
        $("#sb_div_userfile").hide();
    },
    userfilePicked: function() {
        var file = document.getElementById('sb_user_file').files[0];
        if (file) {
            var reader = new FileReader();

            reader.readAsText(file, "UTF-8");

            // Handle progress, success, and errors
            //reader.onprogress = updateProgress;
            reader.onload = sandbox.files.userfileLoaded;
            reader.onerror = sandbox.files.genericLoadError;
        }
    },
    userfileLoaded: function (evt) {
        var filename = $("#sb_user_file").val().replace(/^.*[\\\/]/, '');

        var filestring = evt.target.result;

        // IE's HTML 5 file control seems to place a lock on the last loaded file which
        // was interfering with the saving and overwriting of that same file.
        // So I will reset it by destroying and recreating, allowing the GC to release
        // any old file locks.
        var control = $("#sb_user_file");
        control.replaceWith(control = control.clone(true));

        sandbox.files.userfileHide();

        // If user has registered a callback function (for when load is completed), call it
        if (typeof (EVT_UserLoadCallback) == typeof (Function)) {
            // Give time for the file control replace (done above) to complete
            // before giving the user a chance to interfere with that process
            setTimeout(function () {
                EVT_UserLoadCallback(filestring, filename);
            }, 250);
        }

    },
    userdataPicked: function () {
        var file = document.getElementById('sb_user_datafile').files[0];
        if (file) {
            var reader = new FileReader();

            reader.readAsDataURL(file, "UTF-8");

            // Handle progress, success, and errors
            //reader.onprogress = updateProgress;
            reader.onload = sandbox.files.userdataLoaded;
            reader.onerror = sandbox.files.genericLoadError;
        }
    },
    userdataLoaded: function (evt) {
        var filename = $("#sb_user_datafile").val().replace(/^.*[\\\/]/, '');

        // IE's HTML 5 file control seems to place a lock on the last loaded file which
        // was interfering with the saving and overwriting of that same file.
        // So I will reset it by destroying and recreating, allowing the GC to release
        // any old file locks.

        var control = $("#sb_user_datafile");
        control.replaceWith(control = control.clone(true));

        API_HideUserDataLoader();

        // If user has registered a callback function (for when load is completed), call it
        if (typeof (EVT_UserDataLoadCallback) == typeof (Function)) {
            // Give time for the file control replace (done above) to complete
            // before giving the user a chance to interfere with that process
            setTimeout(function () {
                EVT_UserDataLoadCallback(evt.target.result, filename);
            }, 250);
        }
    },
    templatePrompt: function () {
        alertify.confirm("This will un-hide a file picker you use to pick the the SandboxLoader.htm file at the root of your Trident Sandbox Installation.  Once you do this it will generate and prompt to save a standalone htm version of the program currently loaded.  Continue?", function (e) {
            if (e) {
                // user clicked "ok"
                $("#sb_div_compile_standalone").show();
            }
        });

    },
    templatePicked: function () {
        var file = document.getElementById('sb_file_template').files[0];
        if (file) {
            var reader = new FileReader();

            reader.readAsText(file, "UTF-8");

            // Handle progress, success, and errors
            //reader.onprogress = updateProgress;
            reader.onload = sandbox.files.templateLoaded;
            reader.onerror = sandbox.files.genericLoadError;
        }

    },
    templateLoaded: function (evt) {
        if (sandbox.volatile.env == "SBL" || sandbox.volatile.env == "SBL WJS") {
            console.log("ignoring call to sandbox.files.templateLoaded");
            return;
        }

        var templateString = evt.target.result;
        var htmlString = sandbox.volatile.editorMarkup.getValue();
        var scriptString = sandbox.volatile.editorScript.getValue();

        templateString = templateString.replace("<!--TRIDENT_HTML-->", htmlString);
        templateString = templateString.replace("/*TRIDENT_SCRIPT*/", scriptString);

        if (typeof Blob == "undefined") {
            alert('no blobs available (incompatible browser?)');
        }
        else {
            var blob1 = new Blob([templateString]);
            window.navigator.msSaveBlob(blob1, $("#sb_txt_ProgramName").val() + ".htm");
        }

        var control = $("#sb_file_template");
        control.replaceWith(control = control.clone(true));

        setTimeout(function () {
            $("#sb_div_compile_standalone").hide();
        }, 200);
    }
}

//#endregion files

//#region units

// UNIT LIBRARY I/O
// This collection of functions support the ability for you to modularize your code into
// Markup and/or Script fragments called 'Units'.  With this functionality you can move fragments of html or
// javascript into a unit to be called up from other programs.  So you might fine tune your units
// in the editors and run them to test them, and then use console commands to save them with a name to be
// recalled programmatically within a real prg.
// Initial Implementation will be invoking these functions via the Text Console calling these commands :

var sandboxUnits = {
    logMarkupUnits: function () {
        sandbox.db.GetAppKeys("SandboxMarkupUnits", function (result) {
            for (var idx = 0; idx < result.length; idx++) {
                sandbox.logger.log(result[idx].key);
            }
        });
    },
    saveMarkupUnit: function (unitName) {
        if (sandbox.volatile.env === "SBL" || sandbox.volatile.env == "SBL WJS") {
            return;
        }

        var htmlTextString = sandbox.volatile.editorMarkup.getValue();

        sandbox.db.SetAppKey("SandboxMarkupUnits", unitName, htmlTextString, function (result) {
            if (result.success) return true;

            alertify.error("Error calling SetAppKey()");
            return false;
        });
    },
    loadMarkupUnit: function (unitName) {
        if (sandbox.volatile.env === "SBL" || sandbox.volatile.env == "SBL WJS") {
            return;
        }


        sandbox.db.GetAppKey("SandboxMarkupUnits", unitName, function (result) {
            if (result == null || result.id == 0) {
                alertify.error("No markup unit by that name");
                return false;
            }

            sandbox.volatile.markupHash = CryptoJS.SHA1(result.val).toString();
            sandbox.volatile.editorMarkup.setValue(result.val);
        });
    },
    getMarkupUnit: function (unitName, callback) {
        sandbox.db.GetAppKey("SandboxMarkupUnits", unitName, function (result) {
            if (result == null || result.id == 0) {
                alertify.error("No markup unit by that name");
                return false;
            }

            callback(result.val);
        });
    },
    logScriptUnits: function () {
        sandbox.db.GetAppKeys("SandboxScriptUnits", function (result) {
            for (var idx = 0; idx < result.length; idx++) {
                sandbox.logger.log(result[idx].key);
            }
        });

    },
    saveScriptUnit: function (unitName) {
        if (sandbox.volatile.env === "SBL" || sandbox.volatile.env == "SBL WJS") {
            return;
        }

        var scriptTextString = sandbox.volatile.editorScript.getValue();

        sandbox.db.SetAppKey("SandboxScriptUnits", unitName, scriptTextString, function (result) {
            if (result.success) return true;

            alertify.error("Error calling SetAppKey()");
            return false;
        });
    },
    loadScriptUnit: function (unitName) {
        if (sandbox.volatile.env === "SBL" || sandbox.volatile.env == "SBL WJS") {
            return;
        }


        sandbox.db.GetAppKey("SandboxScriptUnits", unitName, function (result) {
            if (result == null || result.id == 0) {
                alertify.error("No script unit by that name");
                return false;
            }

            sandbox.volatile.scriptHash = CryptoJS.SHA1(result.val).toString();
            sandbox.volatile.editorScript.setValue(result.val);
        });
    },
    importScriptUnit: function (unitName, callback) {
        sandbox.db.GetAppKey("SandboxScriptUnits", unitName, function (result) {
            if (result == null || result.id == 0) {
                alertify.error("No script unit by that name");
                return false;
            }

            this.appendScriptUnit(result.val, callback);
        });
    },
    appendScriptUnit: function (scriptText, callback) {
        var s = document.createElement("script");
        s.innerHTML = scriptText;

        document.getElementById("UI_LibUnitPlaceholder").appendChild(s);

        if (typeof (callback) == "function") {
            setTimeout(function () {
                callback();
            }, 200);
        }
    },
    clearScriptUnits: function () {
        $("#UI_LibUnitPlaceholder").empty();
    }
}

//#endregion units

//#region appcache

var sandboxAppCache = {
    progressAC: function (e) {
        sandbox.volatile.appCacheProgress++;

        // hardcoding total # files
        switch (sandbox.volatile.env) {
            case "IDE": $("#sb_spn_appcache_progress").text("(" + Math.floor(sandbox.volatile.appCacheProgress * 100 / 147) + "%)"); break;
            case "IDE WJS": $("#sb_spn_appcache_progress").text("(" + Math.floor(sandbox.volatile.appCacheProgress * 100 / 147) + "%)"); break;
            case "SBL": $("#sb_spn_ac_progress").text("(" + Math.floor(sandbox.volatile.appCacheProgress * 100 / 147) + "%)"); break;
            case "SBL WJS": $("#sb_spn_ac_progress").text("(" + Math.floor(sandbox.volatile.appCacheProgress * 100 / 147) + "%)"); break;
            case "SA": $("#sb_spn_ac_progress").text("(" + Math.floor(sandbox.volatile.appCacheProgress * 100 / 147) + "%)"); break;
        }
    },
    logACEvent: function (e) {
        sandbox.volatile.appCached = true;  // if any of the events fire we will assume it is successful and running in appcached mode

        // Update diagnostic panel
        var statusString = sandbox.appcache.getACStatus();

        if (statusString == "Update ready") {
            $("#sb_spn_appcache_progress").text("");
            setTimeout(function () {
                sandbox.appcache.promptUpdate();
            }, 200);
        }

        if (sandbox.volatile.env === "SBL" || sandbox.volatile.env == "SBL WJS") {
            if (statusString == "Idle") {
                setTimeout(function () {
                    $("#divAppCache").hide(500);
                }, 1000);
            }

            $("#sb_spn_ac_status").text(statusString);
        }
        else {
            $("#sb_spn_appcache_status").text(statusString);
        }
    },
    getACStatus: function () {
        try {
            var sCacheStatus = "Not supported";
            if (window.applicationCache) {
                var oAppCache = window.applicationCache;
                switch (oAppCache.status) {
                    case oAppCache.UNCACHED: sCacheStatus = "Not cached"; break;
                    case oAppCache.IDLE:
                        sCacheStatus = "Idle"; $("#sb_spn_appcache_progress").text("");
                        if (sandbox.volatile.env == "IDE" || sandbox.volatile.env == "IDE WJS") {
                            sb_fit_editors();
                        }
                        break;
                    case oAppCache.CHECKING: sCacheStatus = "Checking"; break;
                    case oAppCache.DOWNLOADING: sCacheStatus = "Downloading"; break;
                    case oAppCache.UPDATEREADY: sCacheStatus = "Update ready"; break;
                    case oAppCache.OBSOLETE: sCacheStatus = "Obsolete"; break;
                    default: sCacheStatus = "Unexpected Status ( " + oAppCache.status.toString() + ")"; break;
                }
            }
            return sCacheStatus;
        }
        catch (e) {
            alertify.log(e);
            API_LogMessage(e);
        }
    },
    promptUpdate: function () {
        alertify.confirm("An update exists to your AppCache install.  Do you want to install it and reload this page?", function (e) {
            if (e) {
                // user clicked "ok"
                try {
                    applicationCache.swapCache();
                }
                catch (err) { }

                location.reload();
            }
        });
    }
}

//#endregion appcache

//#region ide
var sandboxIDE = {
    refreshSlots: function (callback) {
        // clear out slots select
        $("#sb_sel_trident_slot").html("<option></option>");

        sandbox.db.GetAppKeys("SandboxSaveSlots", function (result) {
            if (result != null) {
                for (var idx = 0; idx < result.length; idx++) {
                    $("#sb_sel_trident_slot").append($("<option></option>").attr("value", result[idx].id).text(result[idx].key));
                }

                var my_options = $("#sb_sel_trident_slot option");
                my_options.sort(function (a, b) {
                    if (a.text > b.text) return 1;
                    else if (a.text < b.text) return -1;
                    else return 0
                })
                $("#sb_sel_trident_slot").empty().append(my_options);

                // in case editor toolbar wrapped or flattened due to wider/thinner save slot select
                sb_fit_editors();

                if (typeof (callback) === "function") callback();
            }
            else {
                alertify.error("check database configuration");
            }
        });
    }
}

//#endregion ide

// aliases for backwards compatibility (set in sandbox.initialize())
var API_GetURLParameter,
    API_PlaySoundURI,
    API_LogMessage,
    API_LogObject,
    API_ClearLog,
    VAR_TRIDENT_API,
    VAR_TRIDENT_VERSION;

//#region sandbox obejct

var sandbox = {
    db: null,
    logger: sbxLogger,
    media: sandboxMedia,
    files: sandboxFiles,
    units: sandboxUnits,
    ide: sandboxIDE,
    appcache: sandboxAppCache,
    memstats: sandboxMemstats,
    editorModeEnum: Object.freeze({ "Markup": 1, "Split": 2, "Script": 3 }),
    volatile: {
        version: "2.02",
        env: '',    // page should set this in document.ready to 'WJS IDE', 'IDE', 'SBL', 'SBL WJS', or 'SA'
        online: function () { return navigator.onLine; },
        markupHash: null,
        scriptHash: null,
        isHosted: (document.URL.indexOf("file://") === -1),
        markupHash: null,
        scriptHash: null,
        editorMarkup: null,
        editorScript: null,
        editorMode: 2,
        windowMode: 2,
        flashTextTab: false,
        lastConsoleCommand: "",
        appCacheProgress: 0,
        appCached: false,
        onlineSamples: true,
        memStats: null,
        memStatsRequestId: null,
        splitMode: 0, // determines if split mode for editors is side-by-side (0) or top-bottom (1)
        envTest: function (envs) {
            return (envs.indexOf(this.env) !== -1);
        }
    },
    settings: {
        headerText: "Trident Sandbox Development Environment",
        headerTextWJS: "Trident Sandbox with WinJS framework",
        headerFont: "Heorot",
        editorTheme: "vibrant-ink",
        autorunSlot: "",
        skipAutorun: "false",   // interpret all properties as strings for dashboard editor
        errorPopups: "true",
        pendingChangesWarning: "true",
        ideMode: "desktop",
        databaseAdapter: "trident",
        databaseServiceLocation: "",
        load: function () {
            if (!localStorage) return;

            var p;

            // for each property defined in our settings object
            for (p in this) {
                // if its not a function
                if (typeof (this[p]) != "function") {
                    // see if local storage has a value for that setting defined
                    if (typeof (localStorage[p]) != "undefined") {
                        // if so, override our default
                        this[p] = localStorage[p];
                    }
                    else {
                        localStorage[p] = this[p];
                    }
                }
            }
        },
        set: function (setting, value) {
            this[setting] = value;
            localStorage[setting] = value;
        }
    },
    hashparams: {
        Theme: "",
        memstats: "",
        LoadSlot: "",
        RunSlot: "",
        RunApp: "",
        EditApp: "",
        SkipAutorun: "false",
        load: function () {
            var p, val;

            // for each property defined in our settings object
            for (p in this) {
                // if its not a function
                if (typeof (this[p]) != "function") {
                    val = this.getParameter(p);
                    // see if hash param has a value for that setting defined
                    if (typeof (val) != "undefined") {
                        // if so, override our default
                        this[p] = val;
                    }
                    else {
                        this[p] = val;
                    }
                }
            }

        },
        getParameter: function (sParam) {
            var sPageURL = window.location.hash.substring(1);

            var sURLVariables = sPageURL.split('&');
            for (var i = 0; i < sURLVariables.length; i++) {
                var sParameterName = sURLVariables[i].split('=');
                if (sParameterName[0] == sParam) {
                    return decodeURIComponent(sParameterName[1]);
                }
            }
        }

    },
    dbInit: function () {
        if (sandbox.volatile.envTest(["IDE", "IDE WJS"])) {
            $("#sb_div_ls_slots").css("display", "inline-block");
        }

        // Check for indexed db support and set up new TridentSandbox DB with simple app/key/value Object Store (Table) for internal and api use
        // For good tutorial on indexedDB, see http://code.tutsplus.com/tutorials/working-with-indexeddb--net-34673
        if (indexedDB || sandbox.settings.databaseServiceLocation != "") {
            switch (sandbox.settings.databaseAdapter) {
                case "trident":
                    sandbox.db = new TridentIndexedAdapter({
                        upgradeCallback: function () { API_LogMessage("Upgrading"); },
                        successCallback: function () {
                            API_LogMessage("Trident indexedDB adapter initialized successfully.");

                            if (sandbox.volatile.env === "IDE" || sandbox.volatile.env == "IDE WJS") {
                                $("#sb_spn_indexeddb_status").text("Yes");

                                // load slots now that db is initialized and then do post init
                                sandbox.ide.refreshSlots(function () {
                                    sandbox.postInit();
                                });
                            }
                            else {
                                sandbox.postInit();
                            }
                        },
                        errorCallback: function () { API_LogMessage("Error opening TridentSandboxDB (indexedDB)."); }

                    });
                    // allow legacy variable support for a version or two
                    VAR_TRIDENT_API = sandbox.db;

                    break;

                case "service":
                    sandbox.db = new TridentServiceAdapter({
                        serviceLocation: sandbox.settings.databaseServiceLocation,
                        successCallback: function () {
                            API_LogMessage("Trident service adapter initialized successfully.")
                            if (sandbox.volatile.env === "IDE" || sandbox.volatile.env == "IDE WJS") {
                                $("#sb_spn_indexeddb_status").html("Yes <span style='font-family:Symbol'>Å</span>");

                                // load slots now and do post init
                                sandbox.ide.refreshSlots(function () {
                                    sandbox.postInit();
                                });
                            }
                            else {
                                sandbox.postInit();
                            }
                        }
                    });
                    VAR_TRIDENT_API = sandbox.db;

                    break;
                case "":
                    sandbox.db = new TridentNullAdapter();
                    API_LogMessage("No default database adapter was specified");
                    break;
                default:
                    sandbox.db = new window[sandbox.settings.databaseAdapter]({
                        successCallback: function () {
                            $("#sb_spn_indexeddb_status").text("Yes");

                            if (sandbox.volatile.env === "IDE" || sandbox.volatile.env == "IDE WJS") {
                                // load slots now that db is initialized and then do post init
                                sandbox.ide.refreshSlots(function () {
                                    sandbox.postInit();
                                });
                            }
                        },
                        errorCallback: function () { API_LogMessage("Error opening adapter " + sandbox.settings.databaseAdapter); }
                    });
                    VAR_TRIDENT_API = sandbox.db;

                    break;
            }
        }
    },
    dbAdapterChanged: function() {
        if (sandbox.db.adapter.name == "indexedDB") {
            $("#sb_spn_indexeddb_status").text("Yes");
        }
        else {
            $("#sb_spn_indexeddb_status").html("Yes <span style='font-family:Symbol'>Å</span>");
        }

        // Now that not only is indexed db available but the Trident database is opened, handle url LoadSlot/RunSlot hash params
        sandbox.ide.refreshSlots();

    },
    initialize: function (options) {
        // aliases for (temporary) backwards compatibility
        API_LogMessage = this.logger.log;
        API_LogObject = this.logger.logObject;
        API_GetURLParameter = sandbox.hashparams.getParameter;
        API_PlaySoundURI = sandbox.media.playAudio;
        API_ClearLog = sandbox.logger.clearLog;
        VAR_TRIDENT_API = sandbox.db;
        VAR_TRIDENT_VERSION = sandbox.volatile.version;

        options = options || {};

        // begin normal initialization

        if (options.hasOwnProperty("env")) {
            this.volatile.env = options.env;
        }

        // Help user quickly identify errors in their code by displaying alert with msg, line and col
        window.onerror = function (msg, url, line, col, error) {
            if (!sandbox.settings.errorPopups) return;

            alertify.error(msg + " (line " + line + " col " + col + ")");
            sandbox.logger.log(msg + " (line " + line + " col " + col + ")");

            return true;
        };

        alertify.set({ buttonReverse: true });

        // Fix for IE 10 and possibly IE 11 (on 8.1 update 0)
        // Needed for Crypto.JS to work properly with typearray lib
        if (typeof Uint8ClampedArray == "undefined") {
            Uint8ClampedArray = Uint8Array;
        }

        sandbox.settings.load();
        sandbox.hashparams.load();

        // For IDE versions, set up some keyboard shortcuts
        if (sandbox.volatile.env === "IDE" || sandbox.volatile.env === "IDE WJS") {
            shortcut.add("Alt+R", function () { sb_run(); });
            shortcut.add("Alt+S", function () { if (indexedDB) { sb_save_slot(); } else { sandbox.files.programSave(); } });
            shortcut.add("Alt+Q", function () { if (sandbox.volatile.editorMode == sandbox.editorModeEnum.Markup) sb_toggle_split(); else sb_toggle_markup(); });
            shortcut.add("Alt+W", function () { if (sandbox.volatile.editorMode == sandbox.editorModeEnum.Script) sb_toggle_split(); else sb_toggle_script(); });
            shortcut.add("Alt+I", function () { sb_inspect(); });
            shortcut.add("Alt+1", function () { API_SetWindowMode(1); });
            shortcut.add("Alt+2", function () { API_SetWindowMode(2); });
            shortcut.add("Alt+3", function () { API_SetWindowMode(3); });

            // For some reason IE sometimes 'remembers' this val across loads
            $("#sb_txt_ProgramName").val("");

            // While waiting for user to click the allow scripts button, we hid some ugly UI elements,
            // so now scripts are enabled un-hide the code elements and clear our warning/notice log message.
            $("#divCode").css("display", "block");
            $("#UI_TabsOutput").tabs();
            $("#UI_TabsDashboard").tabs();
            $("#sb_radioset").buttonset();

            sandbox.logger.clearLog();

            if (sandbox.volatile.env === "IDE") {
                document.title = "Trident Sandbox v" + sandbox.volatile.version;
                $("#sb_txt_Markup").val("<!-- \r\nWelcome to TridentSandbox v" + sandbox.volatile.version + "\r\n\r\nF11 : (while in an editor) will toggle fullscreen editing.\r\nESC : will also exit fullscreen mode. \r\nAlt+R : Run\r\nAlt+L : If Hosted/AppCached, Save and Launch in new Window\r\nAlt+S : Save\r\nAlt+Q : Toggle Markup\r\nAlt+W : Toggle Script\r\nAlt+I : Inspect\r\nAlt+1/2/3 : Switch between the three window modes\r\nCtrl+Q : Within an editor (on a code fold line) will toggle fold\r\nCtrl-F : Find text (In editor this will do basic search)\r\nCtrl-G : Find next\r\nShift-Ctrl-F : Replace\r\nShift-Ctrl-R : Replace All\r\n-->");
            }
            else {
                document.title = "Trident Sandbox WJS v" + sandbox.volatile.version;
                $("#sb_txt_Markup").val("<!-- \r\nWelcome to TridentSandbox v" + sandbox.volatile.version + "\r\n\r\nF11 : (while in an editor) will toggle fullscreen editing.\r\nESC : will also exit fullscreen mode. \r\nAlt+R : Run\r\nAlt+L : If Hosted/AppCached, Save and Launch in new Window\r\nAlt+S : Save\r\nAlt+Q : Toggle Markup\r\nAlt+W : Toggle Script\r\nAlt+I : Inspect\r\nAlt+1/2/3 : Switch between the three window modes\r\nCtrl+Q : Within an editor (on a code fold line) will toggle fold\r\nCtrl-F : Find text (In editor this will do basic search)\r\nCtrl-G : Find next\r\nShift-Ctrl-F : Replace\r\nShift-Ctrl-R : Replace All\r\n-->");
            }

            $('#UI_TabsDashboard').on('tabsactivate', function (event, ui) {
                var newIndex = ui.newTab.index();
                switch (newIndex) {
                    case 0: sb_dashboard.calcSummaryUsage(); break;
                    case 1: sb_dashboard.calcLocalStorageUsage(); break;
                    case 2: sb_dashboard.calcTridentDbUsage(); break;
                    case 3: sb_dashboard.calcTridentDbUsage(); break;
                }
            });

            // ugly but lenient feature detection for Displaying Browse Samples button
            // if served up from anywhere other than filesystem ... show
            // if served up from filesystem and localStorage is available... show
            // Mozilla supports ajax calls under filesystem
            if (document.URL.indexOf("file://") == -1 || localStorage || indexedDB) {
                $(".ui_show_dashboard").show();
                $(".ui_btn_launch").show();
                $(".ui_gen_sa").hide();	// no need to generate standalone if hosted/appcached
                shortcut.add("Alt+L", function () { sb_launch(); });
            }
            else {
                $("#sb_div_diagnostic").hide();
            }

            // We are keeping track of whether the user has pending changes via a Crypto.JS hash on the markup and script
            // This will now calculate the initial value based on our Welcome text above
            sandbox.volatile.markupHash = CryptoJS.SHA1($("#sb_txt_Markup").val()).toString();
            sandbox.volatile.scriptHash = CryptoJS.SHA1("").toString();

            // We are using xml mode for markup so that if we add style tag it wont mess up rendering
            // hopefully in the future we can implement mixed rendering or add separate css
            sandbox.volatile.editorMarkup = CodeMirror.fromTextArea(document.getElementById("sb_txt_Markup"), {
                smartIndent: false,
                autoCloseTags: true,
                lineNumbers: true,
                theme: sandbox.settings.editorTheme,
                mode: "htmlmixed",
                foldGutter: true,
                gutters: ["CodeMirror-linenumbers", "CodeMirror-foldgutter"],
                extraKeys: {
                    "Ctrl-Q": function (cm) {
                        cm.foldCode(cm.getCursor());
                    },
                    "F11": function (cm) {
                        cm.setOption("fullScreen", !cm.getOption("fullScreen"));
                    },
                    "Esc": function (cm) {
                        if (cm.getOption("fullScreen")) cm.setOption("fullScreen", false);
                    }
                }
            });

            sandbox.volatile.editorScript = CodeMirror.fromTextArea(document.getElementById("sb_txt_Script"), {
                smartIndent: false,
                lineNumbers: true,
                theme: sandbox.settings.editorTheme,
                mode: "javascript",
                foldGutter: true,
                gutters: ["CodeMirror-linenumbers", "CodeMirror-foldgutter"],
                extraKeys: {
                    "Ctrl-Q": function (cm) {
                        cm.foldCode(cm.getCursor());
                    },
                    "F11": function (cm) {
                        cm.setOption("fullScreen", !cm.getOption("fullScreen"));
                    },
                    "Esc": function (cm) {
                        if (cm.getOption("fullScreen")) cm.setOption("fullScreen", false);
                    }
                }
            });

            if (sandbox.settings.editorTheme && sandbox.settings.editorTheme !== "") {
                $("#selTheme option").filter(function () {
                    return $(this).text() == sandbox.settings.editorTheme;
                }).prop('selected', true);

                sandbox.volatile.editorMarkup.setOption("theme", sandbox.settings.editorTheme);
                sandbox.volatile.editorScript.setOption("theme", sandbox.settings.editorTheme);
            }

            if (sandbox.settings.headerFont) {
                $('#sb_header_caption').css("font-family", sandbox.settings.headerFont);
                $('#sb_header_caption2').css("font-family", sandbox.settings.headerFont);
            }

            if (sandbox.volatile.env == "IDE") {
                if (sandbox.settings.headerText) {
                    $('#sb_header_caption').text(sandbox.settings.headerText);
                    $('#sb_header_caption2').text(sandbox.settings.headerText);
                }
            }
            else {
                if (sandbox.settings.headerTextWJS) {
                    $('#sb_header_caption').text(sandbox.settings.headerTextWJS);
                    $('#sb_header_caption2').text(sandbox.settings.headerTextWJS);
                }
            }

            $('.tlt').textillate();	// need to run effect after text is set

            sb_fit_log();
            sb_fit_editors();

            if (localStorage) {
                $("#sb_spn_localstorage_status").text("Yes");
                $("#ui_show_dashboard").show();
            }

            // only had memstats in wjs version?
            if (sandbox.hashparams.getParameter("memstats")) {
                sandbox.memstats.on();
            }

            if (sandbox.settings.ideMode === 'mobile') {
                sb_mode_mobile();
            }

            if (indexedDB) {
                $("#sb_spn_indexeddb_status").text("Yes");
            }
            else {
                $("#sb_help_link").prop("href", "docs/Welcome.htm");
            }
        }

        $(window).resize(function () {
            if (sandbox.volatile.envTest(["IDE", "IDE WJS"])) {
                sb_fit_log();
                sb_fit_editors();
            }

            // Allow User Programs to receive window resize events
            // by implementing this callback
            if (typeof (EVT_WindowResize) == typeof (Function)) EVT_WindowResize();
        });

        if (sandbox.volatile.envTest(["SBL", "SBL WJS"])) {
            // Detect Hash Param changes for loadslot/runslot;
            window.onhashchange = function () {
                // Probably better (cleaner) to just clean slate and force page reload
                location.reload();
            }
        }
        else {
            // Detect Hash Param changes for loadslot/runslot; (compare to txtProgramName or SaveSlotSelect?)
            window.onhashchange = function () {
                var loadSlot = sandbox.hashparams.getParameter("LoadSlot");
                if (loadSlot != null && loadSlot != $("#txtProgramName").val()) {
                    sb_clean_sandbox();

                    $("#sb_sel_trident_slot").val(loadSlot);

                    // let sandbox finish cleaning then load
                    setTimeout(function () {
                        sb_load_slot();
                    }, 250);
                }
                else {
                    var runSlot = sandbox.hashparams.getParameter("RunSlot");
                    if (runSlot != null && runSlot != $("#txtProgramName").val()) {
                        sb_clean_sandbox();

                        $("#sb_sel_trident_slot").val(runSlot);

                        // let sandbox finish cleaning then run
                        setTimeout(function () {
                            sb_load_slot(true);
                        }, 250);
                    }
                    else {
                        var runSample = sandbox.hashparams.getParameter("RunApp");
                        if (runSample != null) {
                            sb_clean_sandbox();

                            setTimeout(function () {
                                sb_run_app(runSample);
                            }, 200);
                        }
                        else {
                            var runProgram = sandbox.hashparams.getParameter("EditApp");

                            if (runProgram != null) {
                                sb_clean_sandbox();

                                setTimeout(function () {
                                    sb_edit_app(runProgram);
                                }, 200);
                            }
                        }
                    }

                }
            }
        }

        sandbox.dbInit();

        // If served up from a website then we should bother to monitor possible appcache events
        // for diagnostics.  If not appcaching the events will just not fire.
        if (sandbox.volatile.isHosted) {
            // Determine if we are connecting or running from an appcache site
            var appCache = window.applicationCache;
            if (window.applicationCache) {
                appCache.addEventListener('error', sandbox.appcache.logACEvent, false);
                appCache.addEventListener('checking', sandbox.appcache.logACEvent, false);
                appCache.addEventListener('noupdate', sandbox.appcache.logACEvent, false);
                appCache.addEventListener('downloading', sandbox.appcache.logACEvent, false);
                appCache.addEventListener('progress', sandbox.appcache.progressAC, false);
                appCache.addEventListener('updateready', sandbox.appcache.logACEvent, false);
                appCache.addEventListener('cached', sandbox.appcache.logACEvent, false);
            }
        }

        if (sandbox.volatile.envTest(["SBL", "SBL WJS"])) {
            // if loading from the web (not sa template), clear out the template placeholders
            if (document.URL.indexOf("file://") == -1) $("#UI_MainPlaceholder").empty();
        }

        if (sandbox.volatile.envTest(["IDE", "IDE WJS"])) {
            // Register Event Handler to warn if leaving page
            window.onbeforeunload = function (e) {
                // API_ClearOuput will call EVT_CleanSandbox() is the user has one defined.
                // will allow synchronous shutdown activities to complete, async activities may not complete (tridentdb)
                // local storage should be ok.
                sandbox.logger.clearLog();

                // Get Hash of current editor contents to compare with last 'load' or 'new
                // If they are different (user made changes) then warm them when they are leaving the page.
                var htmlHash = CryptoJS.SHA1(sandbox.volatile.editorMarkup.getValue()).toString();
                var scriptHash = CryptoJS.SHA1(sandbox.volatile.editorScript.getValue()).toString();

                if ((htmlHash != sandbox.volatile.markupHash || scriptHash != sandbox.volatile.scriptHash) && sandbox.settings.pendingChangesWarning == "true") {
                    return 'You have unsaved changes, are you sure you want to leave this page?';
                }
            };

        }

    },
    postInit: function () {
        if (sandbox.hashparams.getParameter("LoadSlot")) {
            if (sandbox.volatile.envTest(["IDE", "IDE WJS"])) {
                sb_clean_sandbox();

                $("#sb_sel_trident_slot").val(sandbox.hashparams.getParameter("LoadSlot"));

                // let sandbox finish cleaning then load
                setTimeout(function () {
                    sb_load_slot();
                }, 200);
            }

            return;
        }

        if (sandbox.hashparams.getParameter("RunSlot")) {
            if (sandbox.volatile.env == "IDE" || sandbox.volatile.env == "IDE WJS") {
                sb_clean_sandbox();

                //if (localrun != null) $("#sb_sel_trident_slot").val(localrun);
                $("#sb_sel_trident_slot").val(sandbox.hashparams.getParameter("RunSlot"));

                // let sandbox finish cleaning then run
                setTimeout(function () {
                    sb_load_slot(true);
                }, 200);
            }
            else {
                sb_run_slot(runSlot);
            }

            return;
        }

        if (sandbox.hashparams.getParameter("RunApp")) {
            if (sandbox.volatile.env == "IDE" || sandbox.volatile.env == "IDE WJS") {
                sb_clean_sandbox();
            }

            setTimeout(function () {
                sb_run_app(sandbox.hashparams.getParameter("RunApp"));
            }, 200);

            return;
        }

        if (sandbox.hashparams.getParameter("EditApp")) {
            if (sandbox.volatile.env == "IDE" || sandbox.volatile.env == "IDE WJS") {
                sb_clean_sandbox();

                setTimeout(function () {
                    sb_edit_app(sandbox.hashparams.getParameter("EditApp"));
                }, 200);
            }

            return;
        }


        //if (!sandbox.hashparams.getParameter("SkipAutorun")) {
        //    sb_run_autorun();
        //}

        // Sandbox Loaders : if no runslot/runapp then load SandboxLoader prog
        if (sandbox.volatile.env === "SBL" || sandbox.volatile.env === "SBL WJS") {
            if (!sandbox.hashparams.getParameter("RunSlot") && !sandbox.hashparams.getParameter("RunApp")) {
                sb_run_app("SandboxLanding");
            }
        }
    }
}

//#endregion sandbox object

//	legacy API VARIABLES - will be removed at some point soon
//var VAR_UserFileValue = "";
//var VAR_WindowMode = 2;
//var VAR_TRIDENT_HOSTED = false;
//var VAR_TRIDENT_APPCACHED = false;
//var VAR_TRIDENT_ONLINE = sandbox.volatile.online;
//var VAR_TRIDENT_ENV_TYPE = function () { return sandbox.volatile.env; };
//var VAR_ForceOnlineSamples = true;


function sb_restore_load() {
    var file = document.getElementById('sb_restore_file').files[0];
    if (file) {
        var reader = new FileReader();

        reader.readAsText(file, "UTF-8");

        // IE's HTML 5 file control seems to place a lock on the last loaded file which
        // was interfering with the saving and overwriting of that same file.
        // So I will reset it by destroying and recreating, allowing the GC to release
        // any old file locks.
        var control = $("#sb_restore_file");
        control.replaceWith(control = control.clone(true));

        // Handle progress, success, and errors
        //reader.onprogress = updateProgress;
        reader.onload = function (evt) {
            var loadString = evt.target.result;

            var keyArray = JSON.parse(loadString);
            for (i = 0; i < keyArray.length; i++) {
                var app = keyArray[i].app;
                var key = keyArray[i].key;
                var val = keyArray[i].val;

                sandbox.db.SetAppKey(app, key, val);
            }

            // In case the restore contained new Trident Save Slots, refresh the list
            sandbox.ide.refreshSlots();

            alertify.success("Restore Completed");
        };
        reader.onerror = sandbox.files.genericLoadError;
    }
};

function API_Backup_TridentDB(filename) {
    filename = filename || "TridentDB.backup";

    var keyArray = [];
    var idx, cnt = 0, obj;

    sandbox.db.GetAllKeys(function (result) {
        if (result.length == 0) {
            alertify.log("Nothing to backup, TridentDB is empty");
        }

        for (idx = 0; idx < result.length; idx++) {
            obj = result[idx];

            sandbox.db.GetAppKey(obj.app, obj.key, function (akv) {
                keyArray.push(akv);
                if (++cnt == result.length) {
                    API_SaveTextFile(filename, JSON.stringify(keyArray));
                };
            });
        }
    });
};

function API_Restore_TridentDB() {
    $("#sb_div_restorefile").show();
};

// IDE/TOOLING REGION / OBJECT

// CACHING - REVISIT/REDECIDE WHETHER TO TURN ON OF OFF
function sb_run_app(progname) {
    progname = progname.replace("%20", " ");	// handle encoded spaces
    progname = progname.replace(/[^a-zA-Z 0-9\-]+/g, ""); // whitelist alphanumeric
    progname = "samples\\" + progname + ".prg";	// force extension

    if (sandbox.volatile.env === "SBL WJS") {
        API_SetDarkTheme();
    }
    
    jQuery.ajax({
        type: "GET",
        url: progname,
        //cache: false,
        dataType: "json",

        success: function (response) {
            var sandboxObject = response;

            if (sandbox.volatile.env === "IDE" || sandbox.volatile.env == "IDE WJS") {
                $("#sb_txt_ProgramName").val(sandboxObject.progName + " Copy");

                sandbox.volatile.editorMarkup.setValue(sandboxObject.htmlText);
                sandbox.volatile.editorScript.setValue(sandboxObject.scriptText);

                sandbox.volatile.markupHash = CryptoJS.SHA1(sandboxObject.htmlText).toString();
                sandbox.volatile.scriptHash = CryptoJS.SHA1(sandboxObject.scriptText).toString();

                // IE's HTML 5 file control seems to place a lock on the last loaded file which
                // was interfering with the saving and overwriting of that same file.
                // So I will reset it by destroying and recreating, allowing the GC to release
                // any old file locks.
                var control = $("#sb_file");
                control.replaceWith(control = control.clone(true));

                // if editors dont reflect current source when we change back to a source visible window mode
                // then we may need to setTimeout on the following two lines to give editors a chance to update display
                API_SetWindowMode(3);

                sb_run();
            }
            else {
                $("#UI_MainPlaceholder").append(sandboxObject.htmlText);

                document.title = sandboxObject.progName;

                var s = document.createElement("script");
                s.innerHTML = sandboxObject.scriptText;

                // give dom a chance to parse html into dom
                setTimeout(function () {
                    document.getElementById("UI_MainPlaceholder").appendChild(s);
                }, 350);
            }

        },
        error: function (xhr, ajaxOptions, thrownError) {
            API_LogMessage("If you are hosting this on your own server, make sure to add mime type for .prg files as text/json");
            API_LogMessage(xhr.status + " : " + xhr.statusText);
            alertify.log(xhr.status + " : " + xhr.statusText);
            alertify.log("See user log for more info");
        }
    });
    
};

// 'borrowed from sandbox loader, not used for ide - maybe merge with sb_load_slot & sb_load_slot_action
function sb_run_slot(appName) {
    API_SetDarkTheme();

    sandbox.db.GetAppKey("SandboxSaveSlots", appName, function (result) {
        if (result == null || result.id == 0) {
            alertify.error("No save at that slot");
            return;
        }

        var sandboxObject = JSON.parse(result.val);

        document.title = sandboxObject.progName;

        if (sandboxObject.scriptText.substring(0, 250).indexOf("FLAG_StartPrgFullscreen") != -1) document.getElementById("UI_Tab_Main").msRequestFullscreen();

        setTimeout(function () {
            // HTML needs to go first so script will work if they have code outside functions
            $("#UI_MainPlaceholder").append(sandboxObject.htmlText);

            var s = document.createElement("script");
            s.innerHTML = sandboxObject.scriptText;

            // give dom a chance to clean out by waiting a bit?
            setTimeout(function () {
                document.getElementById("UI_MainPlaceholder").appendChild(s);
            }, 150);
        }, (tridentVars.isAutorun) ? 600 : 250);		// if autorun script unit is involved, give it more time
    });
};


// apps may link to main page with #EditApp= hash param to 'fork' an appcache app into trident save slot
// in general i am working toward methods using appcache calling things apps and methods using trident calling them slots
function sb_edit_app(appname) {
    if (sandbox.volatile.env == "SBL" || sandbox.volatile.env == "SBL WJS") {
        console.log("ignoring call to sb_edit_app");
        return;
    }

    appname = appname.replace("%20", " ");	// handle encoded spaces
    appname = appname.replace(/[^a-zA-Z 0-9\-]+/g, ""); // whitelist alphanumeric
    appname = "samples\\" + appname + ".prg";	// force extension

    jQuery.ajax({
        type: "GET",
        url: appname,
        cache: false,
        dataType: "json",

        success: function (response) {
            var sandboxObject = response;

            $("#sb_txt_ProgramName").val(sandboxObject.progName + " Copy");

            sandbox.volatile.editorMarkup.setValue(sandboxObject.htmlText);
            sandbox.volatile.editorScript.setValue(sandboxObject.scriptText);

            sandbox.volatile.markupHash = CryptoJS.SHA1(sandboxObject.htmlText).toString();
            sandbox.volatile.scriptHash = CryptoJS.SHA1(sandboxObject.scriptText).toString();

            var control = $("#sb_file");
            control.replaceWith(control = control.clone(true));

            API_SetWindowMode(2);
        },
        error: function (xhr, ajaxOptions, thrownError) {
            API_LogMessage("If you are hosting this on your own server, make sure to add mime type for .prg files as text/json");
            API_LogMessage(xhr.status + " : " + xhr.statusText);
            alertify.log(xhr.status + " : " + xhr.statusText);
            alertify.log("See user log for more info");
        }
    });
};

function sb_browse_samples_action() {
    var baseUrl = "";

    if (sandbox.volatile.env == "SBL" || sandbox.volatile.env == "SBL WJS") {
        console.log("ignoring call to sb_browse_samples_action");
        return;
    }

    if (sandbox.volatile.onlineSamples) {
        baseUrl = "http://www.obeliskos.com/TridentSandbox/";
        alertify.log("Accessing Online Samples Browser");
    }
    setTimeout(function () {
        var sburl = baseUrl;
        switch (sandbox.volatile.env) {
            case "IDE": sburl += "samples/Hosted Samples Browser.prg"; break;
            case "IDE WJS": sburl += "samples/Samples Browser WJS.prg"; break;
        }

        jQuery.ajax({
            type: "GET",
            url: sburl,
            //cache: false,
            dataType: "json",

            success: function (response) {
                var sandboxObject = response;

                $("#sb_txt_ProgramName").val(sandboxObject.progName);

                sandbox.volatile.editorMarkup.setValue(sandboxObject.htmlText);
                sandbox.volatile.editorScript.setValue(sandboxObject.scriptText);

                sandbox.volatile.markupHash = CryptoJS.SHA1(sandboxObject.htmlText).toString();
                sandbox.volatile.scriptHash = CryptoJS.SHA1(sandboxObject.scriptText).toString();

                // IE's HTML 5 file control seems to place a lock on the last loaded file which
                // was interfering with the saving and overwriting of that same file.
                // So I will reset it by destroying and recreating, allowing the GC to release
                // any old file locks.
                var control = $("#sb_file");
                control.replaceWith(control = control.clone(true));

                // if editors dont reflect current source when we change back to a source visible window mode
                // then we may need to setTimeout on the following two lines to give editors a chance to update display
                API_SetWindowMode(3);

                sb_run();
            },
            error: function (xhr, ajaxOptions, thrownError) {
                API_LogMessage("If you are hosting this on your own server, make sure to add mime type for .prg files as text/json");
                API_LogMessage(xhr.status + " : " + xhr.statusText);
                alertify.log(xhr.status + " : " + xhr.statusText);
                alertify.log("See user log for more info");
            }
        });
    }, 250);
};

function sb_browse_samples() {

    if (typeof (EVT_CleanSandbox) == typeof (Function)) {
        try {
            EVT_CleanSandbox();
            EVT_CleanSandbox = null;
        }
        catch (err) {
        }
    }

    // Let Local Filesystem version use samples browser as an 'online' only feature for convenience.
    // If running local filesystem ask them if they want to AJAX to online web samples,
    // otherwise attempt to ajax to local filesystem which works on firefox (and possibly others?)
    if (!sandbox.volatile.isHosted) {
        alertify.confirm("Go online to access samples?", function (e) {
            if (e) {
                sandbox.volatile.onlineSamples = true;
                sb_browse_samples_action();
            } else {
                sandbox.volatile.onlineSamples = false;
                API_LogMessage("Since you chose not to go online you may encounter permissions errors attempting to load samples using this browser.  You can always use the file pickers to manually load each sample individually offline from your samples folder.");
                sb_browse_samples_action();
            }
        });
    }
    else {
        sandbox.volatile.onlineSamples = false;
        sb_browse_samples_action();
    }
};

function sb_run_autorun() {
    sandbox.db.GetAppKey("SandboxScriptUnits", "autorun", function (result) {
        if (result == null || result.id == 0) return;

        API_AppendUnitScript(result.val);
    });
};

function sb_load_slot_action(autorun) {
    if (sandbox.volatile.env == "SBL" || sandbox.volatile.env == "SBL WJS") {
        console.log("ignoring call to sb_load_slot_action");
        return;
    }

    var selText = $("#sb_sel_trident_slot").find(":selected").text();

    if (selText == "") return;

    sandbox.db.GetAppKey("SandboxSaveSlots", selText, function (result) {
        var sandboxObject = JSON.parse(result.val);

        sandbox.volatile.markupHash = CryptoJS.SHA1(sandboxObject.htmlText).toString();
        sandbox.volatile.scriptHash = CryptoJS.SHA1(sandboxObject.scriptText).toString();

        $("#sb_txt_ProgramName").val(sandboxObject.progName);

        sandbox.volatile.editorMarkup.setValue(sandboxObject.htmlText);
        sandbox.volatile.editorScript.setValue(sandboxObject.scriptText);

        if (typeof (autorun) != "undefined" && autorun) sb_run();

    });
};

function sb_load_slot(autoRun) {
    if (sandbox.volatile.env == "SBL" || sandbox.volatile.env == "SBL WJS") {
        console.log("ignoring call to sb_load_run");
        return;
    }

    var htmlHash = CryptoJS.SHA1(sandbox.volatile.editorMarkup.getValue()).toString();
    var scriptHash = CryptoJS.SHA1(sandbox.volatile.editorScript.getValue()).toString();

    if (htmlHash != sandbox.volatile.markupHash || scriptHash != sandbox.volatile.scriptHash) {
        alertify.confirm("You have pending changes, are you sure?", function (e) {
            // user clicked "ok"
            if (e) { sb_load_slot_action(autoRun); }
            else {
                // The chose to abort load of selected slot, attempt to re-select the program
                // by the name they have entered in the Program Name slot if it exists
                $("#sb_sel_trident_slot").val($("#sb_txt_ProgramName").val());
            }
        });

        return;
    }

    sb_load_slot_action(autoRun);
};

// If local storage is available (Hosted or AppCache)
// then this will let you load a program from a save slot
function sb_save_slot(callback) {
    if (sandbox.volatile.env == "SBL" || sandbox.volatile.env == "SBL WJS") {
        console.log("ignoring call to sb_save_slot");
        return;
    }

    var selText = $("#sb_sel_trident_slot").find(":selected").text();

    var progNameString = $("#sb_txt_ProgramName").val();
    var htmlTextString = sandbox.volatile.editorMarkup.getValue();
    var scriptTextString = sandbox.volatile.editorScript.getValue();

    sandbox.volatile.markupHash = CryptoJS.SHA1(htmlTextString).toString();
    sandbox.volatile.scriptHash = CryptoJS.SHA1(scriptTextString).toString();

    var sandboxObject = { progName: progNameString, htmlText: htmlTextString, scriptText: scriptTextString };

    var json_text = JSON.stringify(sandboxObject, null, 2);

    if (selText != progNameString) {
        alertify.confirm("Are you sure you want to save into slot " + progNameString, function (e) {
            if (e) {
                try {
                    //API_SetIndexedAppKey("SandboxSaveSlots", progNameString, json_text);
                    sandbox.db.SetAppKey("SandboxSaveSlots", progNameString, json_text, function (result) {
                        if (result.success) {
                            sandbox.ide.refreshSlots(function () {
                                // todo: make SetAppKey (both trident and service) return id so i could select by that
                                $("#sb_sel_trident_slot option").filter(function () {
                                    return $(this).text() == progNameString;
                                }).prop('selected', true);
                            });

                            if (typeof (callback) == "function") callback();
                        }
                        else {
                            alertify.error("error calling SetKey()");
                        }
                    });
                }
                catch (e) {
                    alertify.error("Error encountered during save to TridentDB : " + e.message);
                }
            }
        });
    }
    else {
        sandbox.db.SetAppKey("SandboxSaveSlots", progNameString, json_text, function (result) {
            if (result.success) {
                alertify.success("saved");
                if (typeof (callback) == "function") callback();
            }
            else {
                alertify.error("Error encountered during save");
            }
        });
    }
};

function sb_del_slot() {
    var selText = $("#sb_sel_trident_slot").find(":selected").text();

    if (selText == "") return;

    alertify.confirm("Are you sure you want to delete Trident Program Slot : " + selText, function (e) {
        if (e) {

            sandbox.db.GetAppKey("SandboxSaveSlots", selText, function (result) {

                sandbox.db.DeleteAppKey(result.id, function (result) {
                    if (result) {
                        sandbox.ide.refreshSlots();
                    }
                    else {
                        alertify.log("Error encountered during delete");
                    }
                });
            });
        }
        else {
            alertify.error("No save at that slot");
        }
    });
};

// END SANDBOX I/O ROUTINES

// Make clicking on the Header Caption toggle its font between Heorot (Greek looking) and normal
function sb_toggle_header_font() {
    var fontName = $('#sb_header_caption').css("font-family");

    if (fontName.indexOf('Heorot') != -1) {
        $('#sb_header_caption').css("font-family", "Sans");
        $('#sb_header_caption2').css("font-family", "Sans");
        if (localStorage) localStorage["header-font"] = "Sans";
    }
    else {
        $('#sb_header_caption').css("font-family", "Heorot");
        $('#sb_header_caption2').css("font-family", "Heorot");
        if (localStorage) localStorage["header-font"] = "Heorot";
    }
};

function sb_new_program() {
    if (sandbox.volatile.env == "SBL" || sandbox.volatile.env == "SBL WJS") {
        console.log("ignoring call to sb_new_program");
        return;
    }

    var htmlHash = CryptoJS.SHA1(sandbox.volatile.editorMarkup.getValue()).toString();
    var scriptHash = CryptoJS.SHA1(sandbox.volatile.editorScript.getValue()).toString();

    if (sandbox.settings.pend_changes_warn) {
        if (htmlHash != sandbox.volatile.markupHash || scriptHash != sandbox.volatile.scriptHash) {
            alertify.confirm("You have pending changes, are you sure?", function (e) {
                // user clicked "ok"
                if (e) {
                    if (sandbox.volatile.windowMode == 3) API_SetWindowMode(2);
                    sb_clean_sandbox();
                    return;
                }
            });
            return;
        }
        else {
            if (sandbox.volatile.windowMode == 3) API_SetWindowMode(2);
            sb_clean_sandbox();
            return;
        }
    }

    if (sandbox.volatile.windowMode == 3) API_SetWindowMode(2);
    sb_clean_sandbox();
};

function API_SetDarkTheme() {
    API_SetBackgroundColor("#444");
    $("#UI_MainPlaceholder").css("color", "#fff");
};

function API_SetLightTheme() {
    API_SetBackgroundColor("#fff");
    $("#UI_MainPlaceholder").css("color", "#000");
};

// Clear Environment
// Ideally this would clear out the sandbox entirely
function sb_clean_sandbox() {
    if (sandbox.volatile.env == "SBL" || sandbox.volatile.env == "SBL WJS") {
        console.log("ignoring call to sb_clean_sandbox");
        return;
    }

    // clear any old passwords and password handlers
    $("#sb_password_text").val("");
    $("#sb_password_ok").unbind("click");

    // clear source code
    var markupText = "<h3>My Sandbox Program</h3>\r\n";
    if (sandbox.volatile.env == "IDE WJS") {
        markupText = "<h3>My Sandbox WinJS Program</h3>\r\n";
    }
    var scriptText = "// Recommended practice is to place variables in this object and then delete in cleanup\r\nvar sbv = {\r\n\tmyVar : null,\r\n\tmyVar2 : 2\r\n}\r\n\r\nfunction EVT_CleanSandbox()\r\n{\r\n\tdelete sbv.myVar;\r\n\tdelete sbv.myVar2;\r\n}\r\n";

    sandbox.volatile.editorMarkup.setValue(markupText);
    sandbox.volatile.editorScript.setValue(scriptText);

    sandbox.volatile.markupHash = CryptoJS.SHA1(sandbox.volatile.editorMarkup.getValue()).toString();
    sandbox.volatile.scriptHash = CryptoJS.SHA1(sandbox.volatile.editorScript.getValue()).toString();

    $("#sb_txt_ProgramName").val('New Program');

    // clear out the MainOutput and Log divs and let client do any cleanup if they registered callback
    API_ClearOutput();
};

function toggleVisibility(id) {
    var e = document.getElementById(id);
    if (e.style.display == 'block')
        e.style.display = 'none';
    else
        e.style.display = 'block';
};

var hookScripts = function (url, src) {
    var s = document.createElement("script");
    s.type = "text/javascript";
    //s.id = 'scriptDynamic';
    s.src = url || null;
    s.innerHTML = src || null;
    document.getElementsByTagName("head")[0].appendChild(s);
};

// Trying to code a more elegant solution to this 'run' process
// Older method hacked together a string with script first
// and added entire string at once, since parsed at same time all ran fine.
// This implementation works with DOM to add the script element after
// appending the html
function sb_run() {
    if (sandbox.volatile.env == "SBL" || sandbox.volatile.env == "SBL WJS") {
        console.log("ignoring call to sb_run");
        return;
    }

    // Make Output visible
    if ($("#divMobileWindowMode").is(":visible")) {
        API_SetMobileMode(3);
    }
    else {
        if (sandbox.volatile.windowMode == 1) {
            API_SetWindowMode(2);
        }
    }

    API_ClearOutput();

    var markupString = sandbox.volatile.editorMarkup.getValue();
    var scriptString = sandbox.volatile.editorScript.getValue();

    // In order to give the user the option to start their app up in fullscreen mode I am having to implement
    // this hack.  The msRequestFullscreen is very particular about only working when called from a 'user-initiated' action
    // like a button press.  This (sb_run) method is called from a button click but the 'user-initiated' seems to get lost
    // if it runs in a setTimeout or when executing your code (which i will add later in this method).  So the hack is to 'peek' into
    // the script and if a text string match exists : FLAG_StartPrgFullscreen (even if it is in a comment), i will automatically
    // fullscreen the UI_MainPlaceholder div.  Esc key will exist or you should provide your own means of 'unfullscreen'-ing it.
    if (scriptString.substring(0, 250).indexOf("FLAG_StartPrgFullscreen") != -1) document.getElementById("UI_MainPlaceholder").msRequestFullscreen();

    // The timeouts are probably not necessary but lets give dom
    // time between our clearing (above), loading html, and loading scripts
    // delay also allows API_ClearOutput to wait for user EVT_CleanSandbox to run
    setTimeout(function () {
        // HTML needs to go first so script will work if they have code outside functions
        $("#UI_MainPlaceholder").append(markupString);

        var s = document.createElement("script");
        s.innerHTML = scriptString;

        // give dom a chance to clean out by waiting a bit?
        setTimeout(function () {
            document.getElementById("UI_MainPlaceholder").appendChild(s);
        }, 150);
    }, 250);
};

function sb_launch() {
    if (sandbox.volatile.env == "SBL" || sandbox.volatile.env == "SBL WJS") {
        console.log("ignoring call to sb_launch");
        return;
    }

    var progName = $("#sb_txt_ProgramName").val();
    if (progName == "") {
        alertify.log("Load a program or give this one a program name");
        return;
    }

    var htmlHash = CryptoJS.SHA1(sandbox.volatile.editorMarkup.getValue()).toString();
    var scriptHash = CryptoJS.SHA1(sandbox.volatile.editorScript.getValue()).toString();

    var selSlot = $("#sb_sel_trident_slot").find(":selected").text();

    // if no pending changes have been made to the editors then skip save
    if (progName == selSlot && htmlHash == sandbox.volatile.markupHash && scriptHash == sandbox.volatile.scriptHash) {
        // ideally we would target progName instead of _blank to reuse existing window
        // but due to hash params they dont refresh correctly and need full reload
        // if you need to side by side dev you will just save in ide and manually refresh sandbox loader page
        if (sandbox.volatile.env == "IDE") {
            window.open('SandboxLoader.htm#RunSlot=' + $("#sb_txt_ProgramName").val(), '_blank');
        }

        if (sandbox.volatile.env == "IDE WJS") {
            window.open('SandboxLoaderWJS.htm#RunSlot=' + $("#sb_txt_ProgramName").val(), '_blank');
        }

        return;
    }

    sb_save_slot(function () {
        if (sandbox.volatile.env == "IDE") {
            window.open('SandboxLoader.htm#RunSlot=' + $("#sb_txt_ProgramName").val(), '_blank');
        }

        if (sandbox.volatile.env == "IDE WJS") {
            window.open('SandboxLoaderWJS.htm#RunSlot=' + $("#sb_txt_ProgramName").val(), '_blank');
        }
    });
};

function sb_toggle_markup() {
    sandbox.volatile.editorMode = sandbox.editorModeEnum.Markup;

    sb_fit_editors();
};

function sb_toggle_script() {
    sandbox.volatile.editorMode = sandbox.editorModeEnum.Script;

    sb_fit_editors();
};

function sb_toggle_split() {
    if (sandbox.volatile.editorMode == sandbox.editorModeEnum.Split) {
        sandbox.volatile.splitMode = (sandbox.volatile.splitMode == 0) ? 1 : 0;
    }

    sandbox.volatile.editorMode = sandbox.editorModeEnum.Split;

    sb_fit_editors();
};

function sb_fit_log() {
    var used = 80;
    var isCaptionVisible = $("#sb_div_caption").is(":visible");
    var isLoaderVisible = $("#sb_div_mainloader").is(":visible");
    var isDevbarVisible = true;

    var isfullscreen = (!window.screenTop && !window.screenY);

    // fix for metro ie fullscreen or f11 desktop ie fullscreen; if the fullscreen element is not null
    // then we are in dev fullscreen and caption and loader should not be
    // calculated even if they are visible (yet outside fullscreen element)
    if (isfullscreen) {
        var element = document.fullscreenElement || document.msFullscreenElement || document.mozFullScreenElement;
        if (element) {
            isCaptionVisible = false;
            isLoaderVisible = false;
            if (element.id == "divCode") isDevbarVisible = false;
        }
    }

    // subtract height of tab strip itself (low width might wrap tabs)
    used += $("#UI_TabsOutput").find(".ui-tabs-nav").height();

    if (isCaptionVisible || isLoaderVisible || isDevbarVisible) {
        if (isCaptionVisible) used += ($("#sb_div_caption").height());
        if (isLoaderVisible) used += ($("#sb_div_mainloader").height() + 4);
    }

    if (sandbox.volatile.env == "IDE WJS") {
        used += $("#UI_TxtLogConsole").height() + 4 + 14; // 14 compensate for padding?
    }

    $("#UI_TxtLogText").height($(window).height() - used);
};

function sb_fit_editors() {
    if (sandbox.volatile.env == "SBL" || sandbox.volatile.env == "SBL WJS") {
        console.log("ignoring call to sb_fit_editors");
        console.trace();
        return;
    }

    if ($(window).width() < 1100) {
        $(".divWideButtons").hide();
        $(".divTinyButtons").show();
    }
    else {
        $(".divWideButtons").show();
        $(".divTinyButtons").hide();
    }

    var used = $("#ui_editor_toolbar").height() + 12;
    var isCaptionVisible = $("#sb_div_caption").is(":visible");
    var isLoaderVisible = $("#sb_div_mainloader").is(":visible");
    var isDevbarVisible = true;

    var isfullscreen = (!window.screenTop && !window.screenY);

    // fix for metro ie fullscreen or f11 desktop ie fullscreen; if the fullscreen element is not null
    // then we are in dev fullscreen and caption and loader should not be
    // calculated even if they are visible (yet outside fullscreen element)
    if (isfullscreen) {
        var element = document.fullscreenElement || document.msFullscreenElement || document.mozFullScreenElement;
        if (element) {
            isCaptionVisible = false;
            isLoaderVisible = false;
            if (element.id == "divCode") isDevbarVisible = false;
        }
    }

    if (isCaptionVisible || isLoaderVisible || isDevbarVisible) {
        if (isCaptionVisible) used += ($("#sb_div_caption").height());
        if (isLoaderVisible) used += ($("#sb_div_mainloader").height() + 4);
    }

    switch (sandbox.volatile.editorMode) {
        case sandbox.editorModeEnum.Markup:
            $("#ui_div_markup").css("width", "100%");
            $("#ui_div_script").css("width", "100%");

            // this is how we go about hiding and resizing editors
            sandbox.volatile.editorMarkup.getWrapperElement().style.display = "block";
            sandbox.volatile.editorScript.getWrapperElement().style.display = "none";
            sandbox.volatile.editorMarkup.setSize("100%", $(window).height() - used);

            // we have hid the script editor so disable its buttons
            $("#sb_btn_markup_fs").prop('disabled', '');
            $("#sb_btn_script_fs").prop('disabled', 'disabled');
            break;
        case sandbox.editorModeEnum.Split:
            // this is how we go about hiding and resizing editors
            sandbox.volatile.editorMarkup.getWrapperElement().style.display = "block";
            sandbox.volatile.editorScript.getWrapperElement().style.display = "block";

            var editorSize = ($(window).height() - used) / 2;

            if (sandbox.volatile.splitMode == 0) {
                $("#ui_div_markup").css("width", "100%");
                $("#ui_div_script").css("width", "100%");
                sandbox.volatile.editorMarkup.setSize("100%", editorSize);
                sandbox.volatile.editorScript.setSize("100%", editorSize);
            }
            else {
                $("#ui_div_markup").css("width", "50%");
                $("#ui_div_script").css("width", "50%");
                sandbox.volatile.editorMarkup.setSize("100%", $(window).height() - used);
                sandbox.volatile.editorScript.setSize("100%", $(window).height() - used);
            }


            $("#sb_btn_markup_fs").prop('disabled', '');
            $("#sb_btn_script_fs").prop('disabled', '');
            break;
        case sandbox.editorModeEnum.Script:
            $("#ui_div_markup").css("width", "100%");
            $("#ui_div_script").css("width", "100%");

            // this is how we go about hiding and resizing editors
            sandbox.volatile.editorMarkup.getWrapperElement().style.display = "none";
            sandbox.volatile.editorScript.getWrapperElement().style.display = "block";
            sandbox.volatile.editorScript.setSize("100%", $(window).height() - used);

            $("#sb_btn_markup_fs").prop('disabled', 'disabled');
            $("#sb_btn_script_fs").prop('disabled', '');
            break;
    }
};

function sb_console_eval() {
    sandbox.volatile.lastConsoleCommand = $("#UI_TxtLogConsole").val();
    API_LogMessage("=> " + sandbox.volatile.lastConsoleCommand);

    // For some reason API_Inspect calls were not invoking the jquery dialog
    // Not really sure why but adding small delay allows this to work
    setTimeout(function () {
        try {
            var res = eval(sandbox.volatile.lastConsoleCommand);

            if (res != null) API_LogMessage("result: " + res);
        }
        catch (err) {
            API_LogMessage("Error : " + err.message);
        }
    }, 100);

    $("#UI_TxtLogConsole").val("");
};

function fsMarkup() {
    if (sandbox.volatile.env == "SBL" || sandbox.volatile.env == "SBL WJS") {
        console.log("ignoring call to fsMarkup");
        return;
    }

    sandbox.volatile.editorMarkup.setOption("fullScreen", !sandbox.volatile.editorMarkup.getOption("fullScreen"));
};

function fsScript() {
    if (sandbox.volatile.env == "SBL" || sandbox.volatile.env == "SBL WJS") {
        console.log("ignoring call to fsScript");
        return;
    }

    sandbox.volatile.editorScript.setOption("fullScreen", !sandbox.volatile.editorScript.getOption("fullScreen"));
};

function sb_fs_code() {
    var inFullScreenMode = document.fullscreenElement ||
    document.mozFullScreenElement || document.webkitFullscreenElement || document.msFullscreenElement;

    if (inFullScreenMode) {
        if (document.exitFullscreen) { document.exitFullscreen(); }
        else if (document.msExitFullscreen) { document.msExitFullscreen(); }
        else if (document.mozCancelFullScreen) { document.mozCancelFullScreen(); }
        else if (document.webkitExitFullscreen) { document.webkitExitFullscreen(); }
    }
    else {
        var docElm = tblCode;
        if (docElm.requestFullscreen) {
            docElm.requestFullscreen();
        } else if (docElm.msRequestFullscreen) {
            docElm.msRequestFullscreen();
        } else if (docElm.mozRequestFullScreen) {
            docElm.mozRequestFullScreen();
        } else if (docElm.webkitRequestFullscreen)
            docElm.webkitRequestFullscreen();
    }
};

// function to inspect a variable/expression highlighted in a script or markup editor
function sb_inspect() {
    if (sandbox.volatile.env == "SBL" || sandbox.volatile.env == "SBL WJS") {
        console.log("ignoring call to sb_inspect");
        return;
    }

    var strSelection;
    var scriptSelection = sandbox.volatile.editorScript.getSelection();
    var markupSelection = sandbox.volatile.editorMarkup.getSelection();

    if (scriptSelection != "" && markupSelection != "") alertify.error("Ambiguous selection; Highlighted code exists in both editors; using Script selection", "", 0);

    if (scriptSelection == "" && markupSelection == "") {
        alertify.alert("This feature requires you to select a variable or object in the script editor before clicking 'Inspect'.");
        return;
    }

    if (scriptSelection != "") strSelection = scriptSelection;
    else strSelection = markupSelection;

    var objResult;
    try {
        objResult = eval(strSelection);
    }
    catch (exc) {
        alertify.error("malformed inspection selection");
        return;
    }

    var tbl = prettyPrint(objResult, { /* options such as maxDepth, etc. */ });
    $(tbl).dialog({ title: 'Trident Object/Variable Inspector', width: 'auto', maxHeight: ($(window).height() - 50) });
};


function API_ClearOutput() {
    if (sandbox.volatile.env === "SBL" || sandbox.volatile.env == "SBL WJS") {
        return;
    }


    // Null out old event handlers
    EVT_WindowResize = null;
    EVT_TridentChanged = null;
    EVT_UserLoadCallback = null;
    EVT_UserDataLoadCallback = null;

    // allow user to do any cleanup they might want to do
    if (typeof (EVT_CleanSandbox) == typeof (Function)) {
        try {
            EVT_CleanSandbox();
            EVT_CleanSandbox = null;
        }
        catch (err) {
            alertify.error("EVT_CleanSandbox: " + err);
        }
    }

    document.title = "Trident Sandbox " + sandbox.volatile.env + "v" + sandbox.volatile.version;

    // clear any old passwords and password handlers
    $("#sb_password_text").val("");
    $("#sb_password_ok").unbind("click");
    $("#sb_div_restorefile").hide();

    API_SetBackgroundColor("#444");

    if (sandbox.volatile.env == "IDE WJS" || sandbox.volatile.env == "SBL WJS") {
        $("#UI_MainPlaceholder").css("color", "white");
    }

    sandbox.files.userfileHide();
    sandbox.logger.clearLog();

    // No longer clearing unit scripts, they are likely already attached to window
    // and i am establishing an autorun script which could affect ui or load other scripts to be used
    // for the duration of the page load.

    //API_ClearUnitScripts();

    // main includes div with script so hopefully EVT_CleanSandbox has completed
    setTimeout(function () {
        API_ClearMain();
    }, 100);

    API_SetActiveTab(0);
};

function API_LogMain(msg) {
    $("#UI_MainPlaceholder").append(msg + "<br/>");
};

function API_ClearMain() {
    $("#UI_MainPlaceholder").empty();
};

function API_SetActiveTab(tabId) {
    if (sandbox.volatile.env === "SBL" || sandbox.volatile.env == "SBL WJS") {
        return;
    }

    $("#UI_TabsOutput").tabs("option", "active", tabId);
};

// Make Developer area fullscreen (Editors, output, and run bar)
function API_MetalFullscreen() {
    if (sandbox.volatile.env === "SBL" || sandbox.volatile.env == "SBL WJS") {
        return;
    }

    var elem = document.getElementById("sb_div_metalFullscreen");
    if (elem.requestFullscreen) {
        elem.requestFullscreen();
    } else if (elem.msRequestFullscreen) {
        elem.msRequestFullscreen();
    } else if (elem.mozRequestFullScreen) {
        elem.mozRequestFullScreen();
    }
};

function API_UserFullscreen(elem) {
    //if (elem == null) elem = UI_TabsOutput;
    if (elem == null) elem = document.getElementById("UI_MainPlaceholder");

    if (elem.requestFullscreen) {
        elem.requestFullscreen();
    } else if (elem.msRequestFullscreen) {
        elem.msRequestFullscreen();
    } else if (elem.mozRequestFullScreen) {
        elem.mozRequestFullScreen();
    } else if (elem.webkitRequestFullscreen) {
        elem.webkitRequestFullscreen();
    }
};

function API_UserFullscreenExit() {
    if (document.exitFullscreen) { document.exitFullscreen(); }
    else if (document.msExitFullscreen) { document.msExitFullscreen(); }
    else if (document.mozCancelFullScreen) { document.mozCancelFullScreen(); }
    else if (document.webkitExitFullscreen) { document.webkitExitFullscreen(); }
};

function API_UserFullToggle() {
    var inFullScreenMode = document.fullscreenElement ||
    document.mozFullScreenElement || document.webkitFullscreenElement || document.msFullscreenElement;

    if (inFullScreenMode) {
        if (document.exitFullscreen) { document.exitFullscreen(); }
        else if (document.msExitFullscreen) { document.msExitFullscreen(); }
        else if (document.mozCancelFullScreen) { document.mozCancelFullScreen(); }
        else if (document.webkitExitFullscreen) { document.webkitExitFullscreen(); }
    }
    else {
        var docElm = document.documentElement;
        if (docElm.requestFullscreen) {
            docElm.requestFullscreen();
        } else if (docElm.msRequestFullscreen) {
            docElm.msRequestFullscreen();
        } else if (docElm.mozRequestFullScreen) {
            docElm.mozRequestFullScreen();
        } else if (docElm.webkitRequestFullscreen) {
            docElm.webkitRequestFullscreen();
        }
    }
};

// Display the User Area file loader
function API_ShowLoad() {
    $("#sb_div_userfile").show();
};

function API_ShowDataLoad() {
    $("#sb_div_userdatafile").show();
};

function API_HideUserDataLoader() {
    $("#sb_div_userdatafile").hide();
};

// Handling Blobs is somewhat browser specific
// As such this seems to work on IE 11 and firefox
function API_DataUrlToBlob(dataURL) {
    // convert base64 to raw binary data held in a string
    var byteString = atob(dataURL.split(',')[1]);

    // separate out the mime component
    var mimeString = dataURL.split(',')[0].split(':')[1].split(';')[0];

    // write the bytes of the string to an ArrayBuffer
    var arrayBuffer = new ArrayBuffer(byteString.length);
    //var _ia = new Uint8Array(arrayBuffer);
    var _ia = new Int8Array(arrayBuffer);
    for (var i = 0; i < byteString.length; i++) {
        _ia[i] = byteString.charCodeAt(i) & 0xff;
    }

    //var dataView = new DataView(arrayBuffer);
    //var blobResult = new Blob([dataView], { type: mimeString });
    var blobResult = new Blob([_ia], { type: mimeString });
    return blobResult;
};

// Pass in a filename and some text to save and this will 'serve' up that text as a download
function API_SaveTextFile(fileName, saveString) {
    // The File Loaders seem to place a lock on the file so, in the event they are saving to the same filename,
    // lets clear out the old file control so that (if they save to the same filename as they last loaded) it will work.
    var control = $("#sb_user_file");
    control.replaceWith(control = control.clone(true));

    if (typeof Blob == "undefined") {
        alert('no blobs available (incompatible browser?)');
    }
    else {
        // if not using internet explorer then fallback to filesaver.js polyfill method
        if (window.navigator.msSaveBlob === undefined) {
            var blob = new Blob([saveString], { type: "application/octet-stream" });
            saveAs(blob, fileName);
        }
        else {
            var blob1 = new Blob([saveString]);
            window.navigator.msSaveBlob(blob1, fileName);
        }
    }
};

// API_SaveDataURL will take a dataURL string (representing a binary object),
// and save it as a binary file
function API_SaveDataURL(fileName, dataURL) {
    var fileBlob = API_DataUrlToBlob(dataURL);

    // if not using internet explorer then fallback to filesaver.js polyfill method
    if (window.navigator.msSaveBlob === undefined) {
        saveAs(fileBlob, fileName);
    }
    else {
        window.navigator.msSaveOrOpenBlob(fileBlob, fileName);
    }
};

// Pass in a filename and some text to save and this will 'serve' up that text as a download
function API_SaveOrOpenTextFile(fileName, saveString) {
    // The File Loaders seem to place a lock on the file so, in the event they are saving to the same filename,
    // lets clear out the old file control so that (if they save to the same filename as they last loaded) it will work.
    var control = $("#sb_user_file");
    control.replaceWith(control = control.clone(true));

    if (typeof Blob == "undefined") {
        alert('no blobs available (incompatible browser?)');
    }
    else {
        var blob1 = new Blob([saveString]);
        window.navigator.msSaveOrOpenBlob(blob1, fileName);
    }
};

function ToggleMaximize() {
    if (sandbox.volatile.env === "SBL" || sandbox.volatile.env == "SBL WJS") {
        return;
    }

    var isCaptionVisible = $("#sb_div_caption").is(":visible");
    //var isLoaderVisible = $("#sb_div_mainloader").is(":visible");

    // If mode 3 (dev bar only), then transition to mode 1 (all visible)
    //if (isLoaderVisible == false) {
    //	$("#sb_div_caption").show();
    //	$("#sb_div_mainloader").show();
    //}
    //else {
    // if all are visible then switch to mode 2 (hide caption only)
    if (isCaptionVisible) {
        $("#sb_div_caption").hide();
    }
        // else was in mode 2 (loader+dev bar), switch to mode 3 (dev bar only)
    else {
        $("#sb_div_caption").show();
    }
    //}

    sb_fit_editors();
    sb_fit_log();
};

function API_SetToolbarMode(showCaption, showLoader) {
    if (sandbox.volatile.env === "SBL" || sandbox.volatile.env == "SBL WJS") {
        return;
    }

    if (showCaption) {
        $("#sb_div_caption").show();
    }
    else {
        $("#sb_div_caption").hide();
    }

    if (showLoader) {
        $("#sb_div_mainloader").show();
    }
    else {
        $("#sb_div_mainloader").hide();
    }

    sb_fit_log();
    sb_fit_editors();
};

// Determines whether the Code or the Output areas get full width or if they split 50/50
function API_SetWindowMode(mode) {
    if (sandbox.volatile.env === "SBL" || sandbox.volatile.env == "SBL WJS") {
        return;
    }

    // Code Only
    if (mode == 1) {
        sandbox.volatile.windowMode = mode;
        //showMarkup = true;
        //showScript = true;
        $('#tdOutput').attr('width', '0%');
        $('#tdCode').attr('width', '100%');
        $('#divCode').show();
        $('#tblCode').css('table-layout', '');

        $("#UI_TabsOutput").hide();

        $('.CodeMirror').each(function (i, el) {
            el.CodeMirror.refresh();
        });
    }

    // Show Code and Output areas
    if (mode == 2) {
        sandbox.volatile.windowMode = mode;
        //showMarkup = true;
        //showScript = true;
        $('#tdCode').attr('width', '50%');
        $('#tdOutput').attr('width', '50%');
        $('#divCode').show();
        $('#tblCode').css('table-layout', 'fixed');

        $("#UI_TabsOutput").show();

        $('.CodeMirror').each(function (i, el) {
            el.CodeMirror.refresh();
        });

    }

    // Show Output only
    if (mode == 3) {
        sandbox.volatile.windowMode = mode;
        //showMarkup = true;
        //showScript = true;
        $('#tdCode').attr('width', '0%');
        $('#tdOutput').attr('width', '100%');
        $('#divCode').hide();
        $('#tblCode').css('table-layout', '');

        $("#UI_TabsOutput").show();
    }
};

// Determines whether the Code or the Output areas get full width or if they split 50/50
function API_SetMobileMode(mode) {
    if (sandbox.volatile.env === "SBL" || sandbox.volatile.env == "SBL WJS") {
        return;
    }

    // Code Only
    if (mode == 1) {
        sandbox.volatile.windowMode = mode;
        //showMarkup = true;
        //showScript = false;
        $('#tdOutput').attr('width', '0%');
        $('#tdCode').attr('width', '100%');
        $('#divCode').show();
        $('#tblCode').css('table-layout', '');

        $("#UI_TabsOutput").hide();

        sandbox.volatile.editorMode = sandbox.editorModeEnum.Markup;
        sb_fit_editors();

        $('.CodeMirror').each(function (i, el) {
            el.CodeMirror.refresh();
        });
    }

    // Show Code and Output areas
    if (mode == 2) {
        sandbox.volatile.windowMode = mode;
        //showMarkup = false;
        //showScript = true;
        $('#tdOutput').attr('width', '0%');
        $('#tdCode').attr('width', '100%');
        $('#divCode').show();
        $('#tblCode').css('table-layout', '');

        $("#UI_TabsOutput").hide();

        sandbox.volatile.editorMode = sandbox.editorModeEnum.Script;
        sb_fit_editors();

        $('.CodeMirror').each(function (i, el) {
            el.CodeMirror.refresh();
        });
    }

    // Show Output only
    if (mode == 3) {
        sandbox.volatile.windowMode = mode;
        //showMarkup = true;
        //showScript = true;
        $('#tdCode').attr('width', '0%');
        $('#tdOutput').attr('width', '100%');
        $('#divCode').hide();
        $('#tblCode').css('table-layout', '');

        $("#UI_TabsOutput").show();
    }
};

function API_RestoreLayout() {
    if (sandbox.volatile.env === "SBL" || sandbox.volatile.env == "SBL WJS") {
        return;
    }

    API_UserFullscreenExit();
    API_SetToolbarMode(true, true);
    API_SetWindowMode(2);
};

function API_SetBackgroundColor(colorCode) {
    if (sandbox.volatile.env === "SBL" || sandbox.volatile.env == "SBL WJS") {
        $("body").css("background-color", colorCode);
        $("#UI_MainPlaceholder").css("background-color", colorCode);
    }
    else {
        $("#UI_Tab_Main").css("background-color", colorCode);
        $("#UI_MainPlaceholder").css("background-color", colorCode);
    }
};

function API_Inspect(objVar, caption) {
    caption = caption || "Trident Object Inspector";

    var tbl = prettyPrint(objVar, { /* options such as maxDepth, etc. */ });
    $(tbl).dialog({ title: caption, width: 'auto', maxHeight: ($(window).height() - 50) });
};

function selectTheme() {
    if (sandbox.volatile.env === "SBL" || sandbox.volatile.env == "SBL WJS") {
        return;
    }

    var theme = $("#selTheme option:selected").val();
    if (localStorage) {
        sandbox.settings.set("editorTheme", theme);
        //localStorage["editor-theme"] = theme;
    }

    sandbox.volatile.editorMarkup.setOption("theme", theme);
    sandbox.volatile.editorScript.setOption("theme", theme);
};

function API_ShowPasswordDialog(callback) {
    if (typeof (callback) != "function") API_LogMessage("Call to API_ShowPasswordDialog() with invalid callback param.");

    $("#UI_PasswordDialog").show();
    $("#sb_password_text").focus();
    $("#sb_password_ok").unbind("click");
    $("#sb_password_ok").bind("click", function () { callback($("#sb_password_text").val()); });
};

//#region Storage Summary dashboard object

var sb_dashboard = {
    tdbplot: null,
    lsplot: null,
    gaugeLS: null,
    gaugeTDB: null,

    calcSummaryUsage: function () {
        $("#spn_TridentDatabaseUsage").text("");
        $("#ui_gaugeTDBspin").show();

        setTimeout(function () { sb_dashboard.calcSummaryUsageAction() }, 100);
    },

    calcSummaryUsageAction: function () {
        var totalSizeTDB = 0;

        if (sb_dashboard.gaugeLS) { sb_dashboard.gaugeLS.destroy(); }
        if (sb_dashboard.gaugeTDB) { sb_dashboard.gaugeTDB.destroy(); }

        var totalSizeLS = 0;

        for (var i = 0; i < localStorage.length; i++) {
            var keySize = localStorage[localStorage.key(i)].length;
            totalSizeLS += keySize;
        }

        $("#spn_LocalStorageUsage").text(totalSizeLS + " bytes (" + Math.round((totalSizeLS / 1024) / 1024 * 100) / 100 + "MB)");

        var s1 = [(totalSizeLS / 1024) / 1024];

        sb_dashboard.gaugeLS = $.jqplot('ui_gaugeLS', [s1], {
            seriesDefaults: {
                renderer: $.jqplot.MeterGaugeRenderer,
                rendererOptions: {
                    label: '(Actual) Usage in MB',
                    labelPosition: 'bottom',
                    min: 0,
                    max: 5,
                    intervals: [1.25, 2.5, 3.5, 5],
                    intervalColors: ['#66cc66', '#93b75f', '#E7E658', '#cc6666']
                }
            }
        });

        if ($("#UI_TabsDashboard").tabs("option", "active") != 0) return;

        $("#ui_gaugeTDBspin").hide();

        sandbox.db.GetAllKeys(function (results) {
            var idx;
            for (idx = 0; idx < results.length; idx++) {
                totalSizeTDB += results[idx].size;
            }

            $("#spn_TridentDatabaseUsage").text(totalSizeTDB + " bytes (" + Math.round((totalSizeTDB / 1024) / 1024 * 100) / 100 + "MB)");

            var s2 = [(totalSizeTDB / 1024) / 1024];

            sb_dashboard.gaugeLS = $.jqplot('ui_gaugeTDB', [s2], {
                seriesDefaults: {
                    renderer: $.jqplot.MeterGaugeRenderer,
                    rendererOptions: {
                        label: '(Actual) Usage in MB',
                        labelPosition: 'bottom',
                        min: 0,
                        max: 120,
                        intervals: [30, 60, 90, 120],
                        intervalColors: ['#66cc66', '#93b75f', '#E7E658', '#cc6666']
                    }
                }
            });

        });

    },

    doRestore: function () {
        $("#sb_trident_usage").dialog("destroy");
        API_SetActiveTab(2);
        API_Restore_TridentDB();
    },

    doBackup: function () {
        var selectedFiles = $(".tfilechk:checked");

        var keyArray = [];

        for (var i = 0; i < selectedFiles.length; i++) {
            var strId = selectedFiles[i].name;
            strId = strId.replace("file", "");
            var objId = parseInt(strId);
            var isLastItem = (i == (selectedFiles.length - 1));

            // Added optional data param to this API call so we could 
            // pass extra data to process in the async callback
            // We are passing boolean isLast to determine whether we are done
            // and can go ahead and save
            sandbox.db.GetAppKeyById(objId, function (result) {
                if (result == null || result.id == 0) {
                    alertify.log("GetAppKeyById failed");
                    return;
                }

                keyArray.push(result);

                // If this is the last item to be processed then trigger file download 
                if (keyArray.length == selectedFiles.length) {
                    var filename = $("#txtBackupName").val();

                    API_SaveTextFile($("#sb_database_backup_filename").val(), JSON.stringify(keyArray));
                }
            });
        }
    },
    calcTridentDbUsage: function () {
        $("#ui_tdb_spnTotalSize").text("");
        $("#ui_chartTDBspin").show();

        setTimeout(function () { sb_dashboard.calcTridentDbUsageAction() }, 100);
    },

    calcTridentDbUsageAction: function () {

        $("#ui_tdb_txtAppName").val("");
        $("#ui_tdb_txtKeyName").val("");
        $("#ui_tdb_txtKeySize").val("");

        // if already plotted, destroy old plot before replotting
        if (sb_dashboard.tdbplot) { sb_dashboard.tdbplot.destroy(); }

        // clear array of [key,sizes]
        var arrayTDB = [];
        var tdbu_counter = null;

        // repopulate the listbox while simultaneously building the arrayTDB data for plot
        $("#ui_tdb_selTridentDB").html("");

        var totalSize = 0;

        sandbox.db.GetAllKeys(function (result) {
            tdbu_counter = result.length;
            if (result.length == 0) {
                $("#ui_chartTDBspin").hide();
                $("#ui_tdb_spnTotalSize").text("0 bytes.");
            }

            var clElement = document.getElementById("sb_backup_keys");
            $("#sb_backup_keys").empty();

            for (var idx = 0; idx < result.length; idx++) {
                //sandbox.db.GetAppKeyById(result[idx].id, function (result) {
                var currObject = result[idx];

                $('#ui_tdb_selTridentDB').append($('<option>', {
                    value: currObject.id,
                    text: currObject.app + ";" + currObject.key
                }));

                // refresh backup tab 'checklist'
                var checkbox = document.createElement('input');
                checkbox.type = "checkbox";
                checkbox.className = "tfilechk";
                checkbox.name = "file" + currObject.id;
                checkbox.id = "file" + currObject.id;
                checkbox.style.color = "#000";

                var label = document.createElement('label')
                label.htmlFor = "file" + currObject.id;
                label.style.fontSize = "20px";

                label.appendChild(document.createTextNode(currObject.app + ";" + currObject.key));
                label.click = function () {
                };


                clElement.appendChild(checkbox);
                clElement.appendChild(label);
                clElement.appendChild(document.createElement('br'));


                totalSize += currObject.size;

                arrayTDB.push([currObject.key.slice(0, 20), currObject.size]);

                if (--tdbu_counter == 0) {
                    if ($("#UI_TabsDashboard").tabs("option", "active") != 2) return;

                    if (totalSize == 0) $("#ui_div_trident_usage").hide();
                    else $("#ui_div_trident_usage").show();

                    $("#ui_tdb_spnTotalSize").text(
                        totalSize + " bytes (" + Math.round((totalSize / 1024) / 1024 * 100) / 100 + "MB) " + sandbox.db.name + " adapter"
                    );

                    $("#ui_chartTDBspin").hide();

                    if (arrayTDB.length == 0) return;

                    sb_dashboard.tdbplot = jQuery.jqplot('ui_tdb_chartTridentUsage', [arrayTDB],
                    {
                        seriesDefaults: {
                            // Make this a pie chart.
                            renderer: jQuery.jqplot.PieRenderer,
                            rendererOptions: {
                                // Put data labels on the pie slices.
                                // By default, labels show the percentage of the slice.
                                showDataLabels: true
                                //dataLabels: ['label']
                            }
                        },
                        legend: { show: false, location: 'e' },
                        highlighter: {
                            show: true,
                            formatString: '%s',
                            tooltipLocation: 'sw',
                            useAxesFormatters: false
                        }
                    });
                }
                //});
            }
        });

    },

    deleteTridentKey: function () {
        var objId = $("#ui_tdb_selTridentDB option:selected").val();

        sandbox.db.DeleteAppKey(parseInt(objId), function (result) {
            sb_dashboard.calcTridentDbUsage();
        });
    },

    selTdbChanged: function () {
        var keyId = $("#ui_tdb_selTridentDB option:selected").val();

        sandbox.db.GetAppKeyById(parseInt(keyId), function (result) {
            if (result.app == "TridentFiles") $("#ui_tdb_download").show();
            else $("#ui_tdb_download").hide();

            $("#ui_tdb_txtAppName").val(result.app);
            $("#ui_tdb_txtKeyName").val(result.key);
            $("#ui_tdb_txtKeySize").val(result.val.length + " bytes");
        });
    },

    downloadTridentFile: function () {
        var objId = $("#ui_tdb_selTridentDB option:selected").val();

        sandbox.db.GetAppKeyById(parseInt(objId), function (result) {
            var fileName = result.key.replace("TridentFiles;", "");
            var dataURL = result.val;
            API_SaveDataURL(fileName, dataURL);
        });
    },

    renameTridentKey: function () {
        var objId = $("#ui_tdb_selTridentDB option:selected").val();

        sandbox.db.GetAppKeyById(parseInt(objId), function (result) {
            sandbox.db.SetAppKey(result.app, $("#ui_tdb_txtKeyName").val(), result.val, function (setres) {
                if (setres.success) {
                    sandbox.db.DeleteAppKey(parseInt(objId), function (delres) {
                        sb_dashboard.calcTridentDbUsage();
                    });
                }
            });
        });
    },

    calcLocalStorageUsage: function () {
        if (sb_dashboard.lsplot) { sb_dashboard.lsplot.destroy(); }

        var arrayLS = [];

        $("#ui_ls_txtKeyName").val("");
        $("#ui_ls_txtKeySize").val("");
        $("#ui_ls_txtLocalStorageValue").val("");

        // repopulate the listbox while simultaneously building the arrayLS data for plot
        $("#ui_ldb_selLocalStorage").html("");

        var totalSize = 0;

        for (var i = 0; i < localStorage.length; i++) {
            var keyName = localStorage.key(i);
            var keySize = localStorage[localStorage.key(i)].length;

            arrayLS.push([keyName, keySize]);

            totalSize += keySize;

            $('#ui_ldb_selLocalStorage').append($('<option>', {
                value: localStorage.key(i),
                text: localStorage.key(i)
            }));
        }

        var my_options = $("#ui_ldb_selLocalStorage option");
        my_options.sort(function (a, b) {
            if (a.text > b.text) return 1;
            else if (a.text < b.text) return -1;
            else return 0
        })
        $("#ui_ldb_selLocalStorage").empty().append(my_options);

        if (totalSize == 0) $("#ui_div_local_usage").hide();
        else $("#ui_div_local_usage").show();

        $("#ui_ldb_spnTotalSize").text("Total Size of Local Storage : " + totalSize + " bytes (" + Math.round((totalSize / 1024) / 1024 * 100) / 100 + "MB)");

        if (arrayLS.length == 0) return;

        // now (re) plot the data we just accumulated
        sb_dashboard.lsplot = jQuery.jqplot('ui_ldb_chartLocalUsage', [arrayLS],
        {
            seriesDefaults: {
                // Make this a pie chart.
                renderer: jQuery.jqplot.PieRenderer,
                rendererOptions: {
                    // Put data labels on the pie slices.
                    // By default, labels show the percentage of the slice.
                    showDataLabels: true
                    //dataLabels: ['label']

                }
            },
            highlighter: {
                show: true,
                formatString: '%s',
                tooltipLocation: 'sw',
                useAxesFormatters: false
            },
            legend: { show: false, location: 'e' }
        });
    },

    saveLSKey: function () {
        var key = $("#ui_ls_txtKeyName").val();
        var val = $("#ui_ls_txtLocalStorageValue").val();

        localStorage[key] = val;
        sb_dashboard.calcLocalStorageUsage();
    },

    selectLSKey: function () {
        var key = $("#ui_ldb_selLocalStorage option:selected").text();

        $("#ui_ls_txtKeyName").val(key);
        $("#ui_ls_txtKeySize").val(localStorage[key].length + " bytes");
        $("#ui_ls_txtLocalStorageValue").val(localStorage[key]);
    },

    deleteLSKey: function () {
        var key = $("#ui_ldb_selLocalStorage option:selected").text();
        if (key == "") {
            alertify.error("You need to select key from the list before deleting");
            return;
        }

        // user clicked "ok"
        localStorage.removeItem(key);
        sb_dashboard.calcLocalStorageUsage();
    }
}

//#endregion Storage Summary dashboard object

function sb_show_dashboard() {
    // no reason to call this under sandbox loaders
    if (sandbox.volatile.env === "SBL" || sandbox.volatile.env === "SBL WJS") {
        return;
    }

    var dlgWidth = 1024;

    if ($(window).width() < 1044) dlgWidth = $(window).width() - 20;

    $("#sb_trident_usage").dialog({
        modal: true,
        width: dlgWidth,
        title: 'Trident Sandbox Storage Summary',
        open: function () {
            if ($("#UI_TabsDashboard").tabs("option", "active") != 0) {
                $("#UI_TabsDashboard").tabs("option", "active", 0);
            }
            else {
                sb_dashboard.calcSummaryUsage();
            }
        },
        buttons: {
            Ok: function () {
                $(this).dialog("destroy");

                if (sandbox.db != null) {
                    if (sandbox.db.name == "indexedDB") {
                        $("#sb_spn_indexeddb_status").text("Yes");
                    }
                    else {
                        $("#sb_spn_indexeddb_status").html("Yes <span style='font-family:Symbol'>Å</span>");
                    }
                }

                if (stats == null && localStorage["memstats"].toLowerCase() == "true") {
                    sandbox.memstats.on();
                }
                else {
                    if (stats != null && localStorage["memstats"].toLowerCase() != "true") {
                        sandbox.memstats.off();
                    }
                }

                sandbox.ide.refreshSlots();
            },
            Cancel: function () {
                $(this).dialog("destroy");
            }
        }
    });
};

function sb_mode_mobile(persist) {
    if (sandbox.volatile.env === "SBL" || sandbox.volatile.env == "SBL WJS") {
        return;
    }

    if (localStorage && persist) {
        localStorage['ide-mode'] = 'mobile';
    }

    $("#divMobileWindowMode").css('display', 'inline');
    $("#divDesktopEditorMode").hide();
    $("#divDesktopWindowMode").hide();

    API_SetMobileMode(1);
};

function sb_mode_desktop() {
    if (sandbox.volatile.env === "SBL" || sandbox.volatile.env == "SBL WJS") {
        return;
    }

    if (localStorage) {
        localStorage['ide-mode'] = 'desktop';
    }

    $("#divMobileWindowMode").hide();
    $("#divDesktopEditorMode").show();
    $("#divDesktopWindowMode").show();

    API_SetWindowMode(2);
    sandbox.volatile.editorMode = sandbox.editorModeEnum.Split;
    sb_fit_editors();
};

// END API/HELPER ROUTINES
