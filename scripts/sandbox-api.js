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
            console.log(msg);
        }
    },
    logObject: function (objToLog, objName) {
        if (objName && (typeof (objName) === "string"))
            this.log(objName + " = ");

        if (sandbox.volatile.env === "SBL" || sandbox.volatile.env === "SBL WJS") {
            console.dir(objToLog);
        }
        else {
            this.log(JSON.stringify(objToLog, null, '\t'));
        }

    },
    clearLog: function () {
        if (sandbox.volatile.env === "SBL" || sandbox.volatile.env === "SBL WJS") {
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

        var result = stack.splice(stack[0] === 'Error' ? 2 : 1);
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
};

//#endregion logger

//#region media

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
};

//#endregion media

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
};

//#endregion

//#region files

var sandboxFiles = {
    programPicked: function () {
        // use most thorough method for cleaning sandbox
        sandbox.ide.clean();

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
        if (sandbox.volatile.env === "SBL" || sandbox.volatile.env === "SBL WJS") {
            console.log("ignoring call to sb_save");
            return;
        }

        var prgName = $("#sb_txt_ProgramName").val();
        if (prgName === "") {
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
        if (typeof Blob === "undefined") {
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
    userfileShow: function () {
        $("#sb_div_userfile").show();
    },
    userfileHide: function () {
        $("#sb_div_userfile").hide();
    },
    userfilePicked: function () {
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
        if (typeof (sandbox.events.userLoadCallback) === typeof (Function)) {
            // Give time for the file control replace (done above) to complete
            // before giving the user a chance to interfere with that process
            setTimeout(function () {
                sandbox.events.userLoadCallback(filestring, filename);
            }, 250);
        }

    },
    userdataShow: function () {
        $("#sb_div_userdatafile").show();
    },
    userdataHide: function () {
        $("#sb_div_userdatafile").hide();
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

        sandbox.files.userdataHide();

        // If user has registered a callback function (for when load is completed), call it
        if (typeof (sandbox.events.userdataLoadCallback) === typeof (Function)) {
            // Give time for the file control replace (done above) to complete
            // before giving the user a chance to interfere with that process
            setTimeout(function () {
                sandbox.events.userdataLoadCallback(evt.target.result, filename);
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
        if (sandbox.volatile.env === "SBL" || sandbox.volatile.env === "SBL WJS") {
            console.log("ignoring call to sandbox.files.templateLoaded");
            return;
        }

        var templateString = evt.target.result;
        var htmlString = sandbox.volatile.editorMarkup.getValue();
        var scriptString = sandbox.volatile.editorScript.getValue();

        templateString = templateString.replace("<!--TRIDENT_HTML-->", htmlString);
        templateString = templateString.replace("/*TRIDENT_SCRIPT*/", scriptString);

        if (typeof Blob === "undefined") {
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
    },
    exportDatabaseKeys: function (filename) {
        filename = filename || "TridentDB.backup";

        var keyArray = [];
        var idx, cnt = 0, obj;

        sandbox.db.getAllKeys(function (result) {
            if (result.length === 0) {
                alertify.log("Nothing to backup, TridentDB is empty");
            }

            for (idx = 0; idx < result.length; idx++) {
                obj = result[idx];

                sandbox.db.getAppKey(obj.app, obj.key, function (akv) {
                    keyArray.push(akv);
                    if (++cnt === result.length) {
                        sandbox.files.saveTextFile(filename, JSON.stringify(keyArray));
                    }
                });
            }
        });
    },
    dataUrlToBlob: function (dataURL) {
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
    },
    saveTextFile: function (fileName, saveString) {
        // The File Loaders seem to place a lock on the file so, in the event they are saving to the same filename,
        // lets clear out the old file control so that (if they save to the same filename as they last loaded) it will work.
        var control = $("#sb_user_file");
        control.replaceWith(control = control.clone(true));

        if (typeof Blob === "undefined") {
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
    },
    saveDataURL: function (fileName, dataURL) {
        var fileBlob = sandbox.files.dataUrlToBlob(dataURL);

        // if not using internet explorer then fallback to filesaver.js polyfill method
        if (window.navigator.msSaveBlob === undefined) {
            saveAs(fileBlob, fileName);
        }
        else {
            window.navigator.msSaveOrOpenBlob(fileBlob, fileName);
        }
    },
    saveOrOpenTextFile: function (fileName, saveString) {
        // The File Loaders seem to place a lock on the file so, in the event they are saving to the same filename,
        // lets clear out the old file control so that (if they save to the same filename as they last loaded) it will work.
        var control = $("#sb_user_file");
        control.replaceWith(control = control.clone(true));

        if (typeof Blob === "undefined") {
            alert('no blobs available (incompatible browser?)');
        }
        else {
            var blob1 = new Blob([saveString]);
            window.navigator.msSaveOrOpenBlob(blob1, fileName);
        }
    }
};

//#endregion files

//#region dashboard

var sandboxDashboard = {
    tdbplot: null,
    lsplot: null,
    gaugeLS: null,
    gaugeTDB: null,

    adapterSet: function (name) {
        var baseUri, adapterClass;

        switch(name) {
            case "memory":
                sandbox.settings.set("databaseAdapter", "memory");
                sandbox.dbInit();
                alertify.log("adapter changed");
                break;
            case "trident":
                sandbox.settings.set("databaseAdapter", "trident");
                sandbox.dbInit();
                alertify.log("adapter changed");
                break;
            case "service":
                baseUri = $("#sb_txt_adapter_service_loc").val();
                sandbox.settings.set("databaseAdapter", "service");
                sandbox.settings.set("databaseServiceLocation", baseUri);
                sandbox.dbInit();
                alertify.log("adapter changed");
                break;
            case "user":
                adapterClass = $("#sb_txt_adapter_user").val();
                sandbox.settings.set("databaseAdapter", adapterClass);
                sandbox.dbInit();
                alertify.log("adapter changed");
                break;
        }
    },

    show: function () {
        $("#sb_txt_adapter_service_loc").val(sandbox.settings.databaseServiceLocation);

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
                if ($("#UI_TabsDashboard").tabs("option", "active") !== 0) {
                    $("#UI_TabsDashboard").tabs("option", "active", 0);
                }
                else {
                    sandbox.dashboard.calcSummaryUsage();
                }
            },
            buttons: {
                Ok: function () {
                    $(this).dialog("destroy");

                    if (sandbox.db != null) {
                        if (sandbox.db.name === "indexedDB") {
                            $("#sb_spn_indexeddb_status").text("Yes");
                        }
                        else {
                            $("#sb_spn_indexeddb_status").html("Yes <span style='font-family:Symbol'>Å</span>");
                        }
                    }

                    sandbox.ide.refreshSlots();
                },
                Cancel: function () {
                    $(this).dialog("destroy");
                }
            }
        });
    },

    calcSummaryUsage: function () {
        $("#spn_TridentDatabaseUsage").text("");
        $("#ui_gaugeTDBspin").show();

        setTimeout(function () { sandbox.dashboard.calcSummaryUsageAction(); }, 100);
    },

    calcSummaryUsageAction: function () {
        var totalSizeTDB = 0;

        if (sandbox.dashboard.gaugeLS) { sandbox.dashboard.gaugeLS.destroy(); }
        if (sandbox.dashboard.gaugeTDB) { sandbox.dashboard.gaugeTDB.destroy(); }

        var totalSizeLS = 0;

        if (localStorage) {
            for (var i = 0; i < localStorage.length; i++) {
                var keySize = localStorage[localStorage.key(i)].length;
                totalSizeLS += keySize;
            }
        }

        $("#spn_LocalStorageUsage").text(totalSizeLS + " bytes (" + Math.round((totalSizeLS / 1024) / 1024 * 100) / 100 + "MB)");

        var s1 = [(totalSizeLS / 1024) / 1024];

        sandbox.dashboard.gaugeLS = $.jqplot('ui_gaugeLS', [s1], {
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

        if ($("#UI_TabsDashboard").tabs("option", "active") !== 0) return;

        $("#ui_gaugeTDBspin").hide();

        sandbox.db.getAllKeys(function (results) {
            var idx;
            for (idx = 0; idx < results.length; idx++) {
                totalSizeTDB += results[idx].size;
            }

            $("#spn_TridentDatabaseUsage").text(totalSizeTDB + " bytes (" + Math.round((totalSizeTDB / 1024) / 1024 * 100) / 100 + "MB)");

            var s2 = [(totalSizeTDB / 1024) / 1024];

            sandbox.dashboard.gaugeLS = $.jqplot('ui_gaugeTDB', [s2], {
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

    doBackup: function () {
        var selectedFiles = $(".tfilechk:checked");

        var keyArray = [];

        for (var i = 0; i < selectedFiles.length; i++) {
            var strId = selectedFiles[i].name;
            strId = strId.replace("file", "");
            var objId = parseInt(strId);
            var isLastItem = (i === (selectedFiles.length - 1));

            // Added optional data param to this API call so we could 
            // pass extra data to process in the async callback
            // We are passing boolean isLast to determine whether we are done
            // and can go ahead and save
            sandbox.db.getAppKeyById(objId, function (result) {
                if (result == null || result.id === 0) {
                    alertify.log("GetAppKeyById failed");
                    return;
                }

                keyArray.push(result);

                // If this is the last item to be processed then trigger file download 
                if (keyArray.length === selectedFiles.length) {
                    var filename = $("#txtBackupName").val();

                    sandbox.files.saveTextFile($("#sb_database_backup_filename").val(), JSON.stringify(keyArray));
                }
            });
        }
    },

    calcTridentDbUsage: function () {
        $("#ui_tdb_spnTotalSize").text("");
        $("#ui_chartTDBspin").show();

        setTimeout(function () { sandbox.dashboard.calcTridentDbUsageAction(); }, 100);
    },

    calcTridentDbUsageAction: function () {

        $("#ui_tdb_txtAppName").val("");
        $("#ui_tdb_txtKeyName").val("");
        $("#ui_tdb_txtKeySize").val("");

        // if already plotted, destroy old plot before replotting
        if (sandbox.dashboard.tdbplot) { sandbox.dashboard.tdbplot.destroy(); }

        // clear array of [key,sizes]
        var arrayTDB = [];
        var tdbu_counter = null;

        // repopulate the listbox while simultaneously building the arrayTDB data for plot
        $("#ui_tdb_selTridentDB").html("");

        var totalSize = 0;

        sandbox.db.getAllKeys(function (result) {
            tdbu_counter = result.length;
            if (result.length === 0) {
                $("#ui_chartTDBspin").hide();
                $("#ui_tdb_spnTotalSize").text("0 bytes.");
            }

            for (var idx = 0; idx < result.length; idx++) {
                var currObject = result[idx];

                $('#ui_tdb_selTridentDB').append($('<option>', {
                    value: currObject.id,
                    text: currObject.app + ";" + currObject.key
                }));

                totalSize += currObject.size;

                arrayTDB.push([currObject.key.slice(0, 20), currObject.size]);

                if (--tdbu_counter === 0) {
                    if ($("#UI_TabsDashboard").tabs("option", "active") !== 2) return;

                    if (totalSize === 0) $("#ui_div_trident_usage").hide();
                    else $("#ui_div_trident_usage").show();

                    $("#ui_tdb_spnTotalSize").text(
                        totalSize + " bytes (" + Math.round((totalSize / 1024) / 1024 * 100) / 100 + "MB) " + sandbox.db.name + " adapter"
                    );

                    $("#ui_chartTDBspin").hide();

                    if (arrayTDB.length === 0) return;

                    sandbox.dashboard.tdbplot = jQuery.jqplot('ui_tdb_chartTridentUsage', [arrayTDB],
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

    activateAdapterTab: function() {
        $("#sb_lbl_adapter_name").text(sandbox.db.name);
    },

    populateBackupTab: function () {
        sandbox.db.getAllKeys(function (result) {
            var clElement = document.getElementById("sb_backup_keys");
            $("#sb_backup_keys").empty();

            for (var idx = 0; idx < result.length; idx++) {
                var currObject = result[idx];

                var checkbox = document.createElement('input');
                checkbox.type = "checkbox";
                checkbox.className = "tfilechk";
                checkbox.name = "file" + currObject.id;
                checkbox.id = "file" + currObject.id;
                checkbox.style.color = "#000";

                var label = document.createElement('label');
                label.htmlFor = "file" + currObject.id;
                label.style.fontSize = "20px";

                label.appendChild(document.createTextNode(currObject.app + ";" + currObject.key));
                label.click = function () {
                };


                clElement.appendChild(checkbox);
                clElement.appendChild(label);
                clElement.appendChild(document.createElement('br'));
            }
        });
    },

    restoreData: null,

    restoreFilePicked: function () {
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
                var clElement = document.getElementById("sb_restore_keys");
                $("#sb_restore_keys").empty();

                var loadString = evt.target.result;

                var keyArray = JSON.parse(loadString);

                // retain all keys to iterate later, when 'checked' keys are to be restored
                sandbox.dashboard.restoreData = keyArray;

                for (i = 0; i < keyArray.length; i++) {
                    var currObject = keyArray[i];

                    var checkbox = document.createElement('input');
                    checkbox.type = "checkbox";
                    checkbox.className = "trfilechk";
                    checkbox.name = "file" + currObject.id;
                    checkbox.id = "file" + currObject.id;
                    checkbox.style.color = "#000";
                    checkbox.checked = true;

                    var label = document.createElement('label');
                    label.htmlFor = "file" + currObject.id;
                    label.style.fontSize = "20px";

                    label.appendChild(document.createTextNode(currObject.app + ";" + currObject.key));
                    label.click = function () {
                    };

                    clElement.appendChild(checkbox);
                    clElement.appendChild(label);
                    clElement.appendChild(document.createElement('br'));
                    //sandbox.db.SetAppKey(app, key, val);
                }

                // In case the restore contained new Trident Save Slots, refresh the list
                //sandbox.ide.refreshSlots();
            };
            reader.onerror = sandbox.files.genericLoadError;
        }
    },

    doRestore: function () {
        if (sandbox.dashboard.restoreData == null || sandbox.dashboard.restoreData.length === 0) {
            alertify.log("nothing selected to restore");
            return;
        }

        var selectedFiles = $(".trfilechk:checked");

        // scan the checklist and store all checked item ids into an array
        var idArray = [];
        for (var i = 0; i < selectedFiles.length; i++) {
            var strId = selectedFiles[i].name;
            strId = strId.replace("file", "");
            var objId = parseInt(strId);

            idArray.push(objId);
        }

        var currentObject;

        // now iterate the entire cached set of import keys and import those which were visually checked
        for (i = 0; i < sandbox.dashboard.restoreData.length; i++) {
            currentObject = sandbox.dashboard.restoreData[i];

            if (idArray.indexOf(currentObject.id) !== -1) {
                sandbox.db.setAppKey(currentObject.app, currentObject.key, currentObject.val);
            }
        }

        // ideally we would async this on last call to SetAppKey
        setTimeout(function () {
            sandbox.ide.refreshSlots();
            sandbox.logger.notifySuccess("Restore Completed.", "Trident Database");
        }, 300);
    },

    deleteTridentKey: function () {
        var objId = $("#ui_tdb_selTridentDB option:selected").val();

        sandbox.db.deleteAppKey(parseInt(objId), function (result) {
            sandbox.dashboard.calcTridentDbUsage();
        });
    },

    selTdbChanged: function () {
        var keyId = $("#ui_tdb_selTridentDB option:selected").val();

        sandbox.db.getAppKeyById(parseInt(keyId), function (result) {
            if (result.app === "TridentFiles") $("#ui_tdb_download").show();
            else $("#ui_tdb_download").hide();

            $("#ui_tdb_txtAppName").val(result.app);
            $("#ui_tdb_txtKeyName").val(result.key);
            $("#ui_tdb_txtKeySize").val(result.val.length + " bytes");
        });
    },

    downloadTridentFile: function () {
        var objId = $("#ui_tdb_selTridentDB option:selected").val();

        sandbox.db.getAppKeyById(parseInt(objId), function (result) {
            var fileName = result.key.replace("TridentFiles;", "");
            var dataURL = result.val;
            sandbox.files.saveDataURL(fileName, dataURL);
        });
    },

    renameTridentKey: function () {
        var objId = $("#ui_tdb_selTridentDB option:selected").val();

        sandbox.db.getAppKeyById(parseInt(objId), function (result) {
            sandbox.db.setAppKey(result.app, $("#ui_tdb_txtKeyName").val(), result.val, function (setres) {
                if (setres.success) {
                    sandbox.db.deleteAppKey(parseInt(objId), function (delres) {
                        sandbox.dashboard.calcTridentDbUsage();
                    });
                }
            });
        });
    },

    calcLocalStorageUsage: function () {
        if (!localStorage) return;

        if (sandbox.dashboard.lsplot) { sandbox.dashboard.lsplot.destroy(); }

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
            else return 0;
        });
        $("#ui_ldb_selLocalStorage").empty().append(my_options);

        if (totalSize === 0) $("#ui_div_local_usage").hide();
        else $("#ui_div_local_usage").show();

        $("#ui_ldb_spnTotalSize").text("Total Size of Local Storage : " + totalSize + " bytes (" + Math.round((totalSize / 1024) / 1024 * 100) / 100 + "MB)");

        if (arrayLS.length === 0) return;

        // now (re) plot the data we just accumulated
        sandbox.dashboard.lsplot = jQuery.jqplot('ui_ldb_chartLocalUsage', [arrayLS],
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

        sandbox.settings.set(key, val)
        //localStorage[key] = val;
        sandbox.dashboard.calcLocalStorageUsage();
    },

    selectLSKey: function () {
        var key = $("#ui_ldb_selLocalStorage option:selected").text();

        $("#ui_ls_txtKeyName").val(key);
        $("#ui_ls_txtKeySize").val(localStorage[key].length + " bytes");
        $("#ui_ls_txtLocalStorageValue").val(localStorage[key]);
    },

    deleteLSKey: function () {
        var key = $("#ui_ldb_selLocalStorage option:selected").text();
        if (key === "") {
            alertify.error("You need to select key from the list before deleting");
            return;
        }

        // user clicked "ok"
        localStorage.removeItem(key);
        sandbox.dashboard.calcLocalStorageUsage();
    }
};

//#endregion

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
        sandbox.db.getAppKeys("SandboxMarkupUnits", function (result) {
            for (var idx = 0; idx < result.length; idx++) {
                sandbox.logger.log(result[idx].key);
            }
        });
    },
    saveMarkupUnit: function (unitName) {
        if (sandbox.volatile.env === "SBL" || sandbox.volatile.env === "SBL WJS") {
            return;
        }

        var htmlTextString = sandbox.volatile.editorMarkup.getValue();

        sandbox.db.setAppKey("SandboxMarkupUnits", unitName, htmlTextString, function (result) {
            if (result.success) return true;

            alertify.error("Error calling SetAppKey()");
            return false;
        });
    },
    loadMarkupUnit: function (unitName) {
        if (sandbox.volatile.env === "SBL" || sandbox.volatile.env === "SBL WJS") {
            return;
        }


        sandbox.db.getAppKey("SandboxMarkupUnits", unitName, function (result) {
            if (result == null || result.id === 0) {
                alertify.error("No markup unit by that name");
                return false;
            }

            sandbox.volatile.markupHash = CryptoJS.SHA1(result.val).toString();
            sandbox.volatile.editorMarkup.setValue(result.val);
        });
    },
    getMarkupUnit: function (unitName, callback) {
        sandbox.db.getAppKey("SandboxMarkupUnits", unitName, function (result) {
            if (result === null || result.id === 0) {
                alertify.error("No markup unit by that name");
                return false;
            }

            callback(result.val);
        });
    },
    logScriptUnits: function () {
        sandbox.db.getAppKeys("SandboxScriptUnits", function (result) {
            for (var idx = 0; idx < result.length; idx++) {
                sandbox.logger.log(result[idx].key);
            }
        });

    },
    saveScriptUnit: function (unitName) {
        if (sandbox.volatile.env === "SBL" || sandbox.volatile.env === "SBL WJS") {
            return;
        }

        var scriptTextString = sandbox.volatile.editorScript.getValue();

        sandbox.db.setAppKey("SandboxScriptUnits", unitName, scriptTextString, function (result) {
            if (result.success) return true;

            alertify.error("Error calling SetAppKey()");
            return false;
        });
    },
    loadScriptUnit: function (unitName) {
        if (sandbox.volatile.env === "SBL" || sandbox.volatile.env === "SBL WJS") {
            return;
        }


        sandbox.db.getAppKey("SandboxScriptUnits", unitName, function (result) {
            if (result == null || result.id === 0) {
                alertify.error("No script unit by that name");
                return false;
            }

            sandbox.volatile.scriptHash = CryptoJS.SHA1(result.val).toString();
            sandbox.volatile.editorScript.setValue(result.val);
        });
    },
    getScriptUnit: function(unitName, callback) {
        sandbox.db.getAppKey("SandboxScriptUnits", unitName, function (result) {
            if (result === null || result.id === 0) {
                alertify.error("No script unit by that name");
                return false;
            }

            callback(result.val);
        });
    },
    importScriptUnit: function (unitName, callback) {
        var self = this;

        sandbox.db.getAppKey("SandboxScriptUnits", unitName, function (result) {
            if (result == null || result.id === 0) {
                alertify.error("No script unit by that name");
                return false;
            }

            self.appendScriptUnit(result.val, callback);
        });
    },
    appendScriptUnit: function (scriptText, callback) {
        var s = document.createElement("script");
        s.innerHTML = scriptText;

        document.getElementById("UI_LibUnitPlaceholder").appendChild(s);

        if (typeof (callback) === "function") {
            setTimeout(function () {
                callback();
            }, 200);
        }
    },
    clearScriptUnits: function () {
        $("#UI_LibUnitPlaceholder").empty();
    }
};

//#endregion units

//#region appcache

var sandboxAppCache = {
    progressAC: function (e) {
        sandbox.volatile.appCacheProgress++;

        // hardcoding total # files
        switch (sandbox.volatile.env) {
            case "IDE": $("#sb_spn_appcache_progress").text("(" + Math.floor(sandbox.volatile.appCacheProgress * 100 / 149) + "%)"); break;
            case "IDE WJS": $("#sb_spn_appcache_progress").text("(" + Math.floor(sandbox.volatile.appCacheProgress * 100 / 149) + "%)"); break;
            case "SBL": $("#sb_spn_ac_progress").text("(" + Math.floor(sandbox.volatile.appCacheProgress * 100 / 149) + "%)"); break;
            case "SBL WJS": $("#sb_spn_ac_progress").text("(" + Math.floor(sandbox.volatile.appCacheProgress * 100 / 149) + "%)"); break;
            case "SA": $("#sb_spn_ac_progress").text("(" + Math.floor(sandbox.volatile.appCacheProgress * 100 / 149) + "%)"); break;
        }
    },
    logACEvent: function (e) {
        sandbox.volatile.appCached = true;  // if any of the events fire we will assume it is successful and running in appcached mode

        if (sandbox.volatile.envTest(["SBL", "SBL WJS"])) {
            $("#divAppCache").show();
        }

        // Update diagnostic panel
        var statusString = sandbox.appcache.getACStatus();

        if (statusString === "Update ready") {
            $("#sb_spn_appcache_progress").text("");
            setTimeout(function () {
                sandbox.appcache.promptUpdate();
            }, 200);
        }

        if (sandbox.volatile.env === "SBL" || sandbox.volatile.env === "SBL WJS") {
            if (statusString === "Idle") {
                setTimeout(function () {
                    $("#divAppCache").hide(500);
                }, 1000);
            }

            if (statusString === "Not cached") {
                setTimeout(function () {
                    $("#divAppCache").hide(1000);
                }, 4000);
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
                        if (sandbox.volatile.env === "IDE" || sandbox.volatile.env === "IDE WJS") {
                            sandbox.ide.fitEditors();
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
            sandbox.logger.log(e);
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
};

//#endregion appcache

//#region ui
var sandboxUI = {
    setDarkTheme: function () {
        sandbox.ui.setBackgroundColor("#444");
        $("#UI_MainPlaceholder").css("color", "#fff");
    },
    setLightTheme: function () {
        sandbox.ui.setBackgroundColor("#fff");
        $("#UI_MainPlaceholder").css("color", "#000");
    },
    setBackgroundColor: function (colorCode) {
        if (sandbox.volatile.env === "SBL" || sandbox.volatile.env === "SBL WJS") {
            $("body").css("background-color", colorCode);
            $("#UI_MainPlaceholder").css("background-color", colorCode);
        }
        else {
            $("#UI_Tab_Main").css("background-color", colorCode);
            $("#UI_MainPlaceholder").css("background-color", colorCode);
        }
    },
    clearMain: function () {
        $("#UI_MainPlaceholder").empty();
    },
    // fs main placeholder (ide)
    fullscreen: function (elem) {
        if (!elem) elem = document.getElementById("UI_MainPlaceholder");

        if (elem.requestFullscreen) {
            elem.requestFullscreen();
        } else if (elem.msRequestFullscreen) {
            elem.msRequestFullscreen();
        } else if (elem.mozRequestFullScreen) {
            elem.mozRequestFullScreen();
        } else if (elem.webkitRequestFullscreen) {
            elem.webkitRequestFullscreen();
        }
    },
    fullscreenExit: function () {
        if (document.exitFullscreen) { document.exitFullscreen(); }
        else if (document.msExitFullscreen) { document.msExitFullscreen(); }
        else if (document.mozCancelFullScreen) { document.mozCancelFullScreen(); }
        else if (document.webkitExitFullscreen) { document.webkitExitFullscreen(); }
    },
    // whole page (loaders)
    fullscreenToggle: function () {
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
    },
    showPasswordDialog: function (callback) {
        if (typeof (callback) !== "function") sandbox.logger.log("Call to sandbox.ide.showPasswordDialog() with invalid callback param.");

        $("#UI_PasswordDialog").show();
        $("#sb_password_text").focus();
        $("#sb_password_ok").unbind("click");
        $("#sb_password_ok").bind("click", function () { callback($("#sb_password_text").val()); });
    }
};

//#endregion

//#region events

var sandboxEvents = {
    windowResize: null,
    databaseChanged: null,
    userLoadCallback: null,
    userdataLoadCallback: null,
    clean: null
};

//#endregion

//#region ide

var sandboxIDE = {
    run: function () {
        if (sandbox.volatile.env === "SBL" || sandbox.volatile.env === "SBL WJS") {
            console.log("ignoring call to sandbox.ide.run");
            return;
        }

        // Make Output visible
        if ($("#divMobileWindowMode").is(":visible")) {
            sandbox.ide.setMobileMode(3);
        }
        else {
            if (sandbox.volatile.windowMode === 1) {
                sandbox.ide.setWindowMode(2);
            }
        }

        sandbox.ide.clearOutput();

        var markupString = sandbox.volatile.editorMarkup.getValue();
        var scriptString = sandbox.volatile.editorScript.getValue();

        // In order to give the user the option to start their app up in fullscreen mode I am having to implement
        // this hack.  The msRequestFullscreen is very particular about only working when called from a 'user-initiated' action
        // like a button press.  This (sandbox.ide.run) method is called from a button click but the 'user-initiated' seems to get lost
        // if it runs in a setTimeout or when executing your code (which i will add later in this method).  So the hack is to 'peek' into
        // the script and if a text string match exists : FLAG_StartPrgFullscreen (even if it is in a comment), i will automatically
        // fullscreen the UI_MainPlaceholder div.  Esc key will exist or you should provide your own means of 'unfullscreen'-ing it.
        if (scriptString.substring(0, 250).indexOf("FLAG_StartPrgFullscreen") !== -1) document.getElementById("UI_MainPlaceholder").msRequestFullscreen();

        // The timeouts are probably not necessary but lets give dom
        // time between our clearing (above), loading html, and loading scripts
        // delay also allows sandbox.ide.clearOutput to wait for user sandbox.events.clean to run
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
    },
    launch: function () {
        if (sandbox.volatile.env === "SBL" || sandbox.volatile.env === "SBL WJS") {
            console.log("ignoring call to sandbox.ide.launch");
            return;
        }

        var progName = $("#sb_txt_ProgramName").val();
        if (progName === "") {
            alertify.log("Load a program or give this one a program name");
            return;
        }

        var htmlHash = CryptoJS.SHA1(sandbox.volatile.editorMarkup.getValue()).toString();
        var scriptHash = CryptoJS.SHA1(sandbox.volatile.editorScript.getValue()).toString();

        var selSlot = $("#sb_sel_trident_slot").find(":selected").text();

        // if no pending changes have been made to the editors then skip save
        if (progName === selSlot && htmlHash === sandbox.volatile.markupHash && scriptHash === sandbox.volatile.scriptHash) {
            // ideally we would target progName instead of _blank to reuse existing window
            // but due to hash params they dont refresh correctly and need full reload
            // if you need to side by side dev you will just save in ide and manually refresh sandbox loader page
            if (sandbox.volatile.env === "IDE") {
                window.open('SandboxLoader.htm#RunSlot=' + $("#sb_txt_ProgramName").val(), '_blank');
            }

            if (sandbox.volatile.env === "IDE WJS") {
                window.open('SandboxLoaderWJS.htm#RunSlot=' + $("#sb_txt_ProgramName").val(), '_blank');
            }

            return;
        }

        sandbox.ide.saveSlot(function () {
            if (sandbox.volatile.env === "IDE") {
                window.open('SandboxLoader.htm#RunSlot=' + $("#sb_txt_ProgramName").val(), '_blank');
            }

            if (sandbox.volatile.env === "IDE WJS") {
                window.open('SandboxLoaderWJS.htm#RunSlot=' + $("#sb_txt_ProgramName").val(), '_blank');
            }
        });
    },
    clean: function () {
        if (sandbox.volatile.env === "SBL" || sandbox.volatile.env === "SBL WJS") {
            console.log("ignoring call to sandbox.ide.clean");
            return;
        }

        // clear any old passwords and password handlers
        $("#sb_password_text").val("");
        $("#sb_password_ok").unbind("click");

        // clear source code
        var markupText = "<h3>My Sandbox Program</h3>\r\n";
        if (sandbox.volatile.env === "IDE WJS") {
            markupText = "<h3>My Sandbox WinJS Program</h3>\r\n";
        }
        var scriptText = "// Recommended practice is to place variables in this object and then delete in cleanup\r\nvar sbv = {\r\n\tmyVar : null,\r\n\tmyVar2 : 2\r\n};\r\n\r\nsandbox.events.clean = function()\r\n{\r\n\tdelete sbv.myVar;\r\n\tdelete sbv.myVar2;\r\n};\r\n";

        sandbox.volatile.editorMarkup.setValue(markupText);
        sandbox.volatile.editorScript.setValue(scriptText);

        sandbox.volatile.markupHash = CryptoJS.SHA1(sandbox.volatile.editorMarkup.getValue()).toString();
        sandbox.volatile.scriptHash = CryptoJS.SHA1(sandbox.volatile.editorScript.getValue()).toString();

        $("#sb_txt_ProgramName").val('New Program');

        // clear out the MainOutput and Log divs and let client do any cleanup if they registered callback
        sandbox.ide.clearOutput();
    },
    clearOutput: function () {
        if (sandbox.volatile.env === "SBL" || sandbox.volatile.env === "SBL WJS") {
            return;
        }

        // Null out old event handlers
        sandbox.events.windowResize = null;
        sandbox.events.databaseChanged = null;
        sandbox.events.userLoadCallback = null;
        sandbox.events.userdataLoadCallback = null;

        sandbox.volatile.markupCursor = null;
        sandbox.volatile.scriptCursor = null;

        sandbox.logger.clearLog();
        sandbox.files.userfileHide();

        // allow user to do any cleanup they might want to do
        if (typeof (sandbox.events.clean) === typeof (Function)) {
            try {
                try {
                    sandbox.events.clean();
                }
                catch (ex) {
                    sandbox.logger.notifyError(ex, "sandbox.events.clean");
                    sandbox.logger.log(ex);
                }

                sandbox.events.clean = null;
            }
            catch (err) {
                alertify.error("sandbox.events.clean: " + err);
            }
        }


        document.title = "Trident Sandbox " + sandbox.volatile.env + "v" + sandbox.volatile.version;

        // clear any old passwords and password handlers
        $("#sb_password_text").val("");
        $("#sb_password_ok").unbind("click");
        $("#sb_div_restorefile").hide();

        switch (sandbox.volatile.env) {
            case "IDE": sandbox.ui.setLightTheme(); break;
            case "IDE WJS": sandbox.ui.setDarkTheme(); break;
        }

        // No longer clearing unit scripts, they are likely already attached to window
        // and i am establishing an autorun script which could affect ui or load other scripts to be used
        // for the duration of the page load.

        //API_ClearUnitScripts();

        // main includes div with script so hopefully sandbox.events.clean has completed
        setTimeout(function () {
            sandbox.ui.clearMain();

            // now that user cleanup has run, clear out sandbox.volatile.vars if they used it
            sandbox.volatile.vars = null;
        }, 100);

        sandbox.ide.setActiveTab(0);
    },
    inspectSelection: function () {
        if (sandbox.volatile.env === "SBL" || sandbox.volatile.env === "SBL WJS") {
            console.log("ignoring call to sandbox.ide.inspectSelection");
            return;
        }

        var scriptSelection = sandbox.volatile.editorScript.getSelection();

        if (scriptSelection === "") {
            sandbox.showProtos();
            return;
        }

        var objResult;
        try {
            objResult = eval(scriptSelection);
        }
        catch (exc) {
            alertify.error("malformed inspection selection");
            return;
        }

        var tbl = prettyPrint(objResult, { /* options such as maxDepth, etc. */ });
        $(tbl).dialog({ title: 'Trident Object/Variable Inspector', width: 'auto', maxHeight: ($(window).height() - 50) });
    },
    refreshSlots: function (callback) {
        // clear out slots select
        $("#sb_sel_trident_slot").html("<option></option>");

        sandbox.db.getAppKeys("SandboxSaveSlots", function (result) {
            if (result != null) {
                for (var idx = 0; idx < result.length; idx++) {
                    $("#sb_sel_trident_slot").append($("<option></option>").attr("value", result[idx].id).text(result[idx].key));
                }

                var my_options = $("#sb_sel_trident_slot option");
                my_options.sort(function (a, b) {
                    if (a.text > b.text) return 1;
                    else if (a.text < b.text) return -1;
                    else return 0;
                });
                $("#sb_sel_trident_slot").empty().append(my_options);

                // in case editor toolbar wrapped or flattened due to wider/thinner save slot select
                sandbox.ide.fitEditors();

                if (typeof (callback) === "function") callback();
            }
            else {
                alertify.error("check database configuration");
            }
        });
    },
    toggleLint: function() {
        if (sandbox.settings.useLinter === "true") {
            sandbox.settings.set("useLinter", "false");
            sandbox.volatile.editorScript.setOption("lint", false);
        }
        else {
            sandbox.settings.set("useLinter", "true");
            sandbox.volatile.editorScript.setOption("lint", true);
        }
    },
    runApp: function (progname) {
        var baseUrl = "";

        progname = progname.replace("%20", " ");	// handle encoded spaces
        progname = progname.replace(/[^a-zA-Z 0-9\-]+/g, ""); // whitelist alphanumeric
        progname = "samples\\" + progname + ".prg";	// force extension

        if (sandbox.volatile.env === "SBL WJS") {
            sandbox.ui.setDarkTheme();
        }

        if (sandbox.volatile.onlineSamples) {
            baseUrl = "http://www.obeliskos.com/TridentSandbox/";
            sandbox.settings.set("cacheSamples", "false");
            alertify.log("Accessing Online Sample");
        }

        jQuery.ajax({
            type: "GET",
            url: baseUrl + progname,
            cache: (sandbox.settings.cacheSamples === "true" || !navigator.onLine),
            dataType: "json",

            success: function (response) {
                var sandboxObject = response;

                if (sandbox.volatile.env === "IDE" || sandbox.volatile.env === "IDE WJS") {
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
                    //sandbox.ide.setWindowMode(3);

                    sandbox.ide.run();
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
                sandbox.logger.log("If you are hosting this on your own server, make sure to add mime type for .prg files as text/json");
                sandbox.logger.log(xhr.status + " : " + xhr.statusText);
                alertify.log(xhr.status + " : " + xhr.statusText);
                alertify.log("See user log for more info");
            }
        });
    },
    runSlot: function (appName) {
        if (sandbox.volatile.env === "SBL WJS") {
            sandbox.ui.setDarkTheme();
        }

        sandbox.db.getAppKey("SandboxSaveSlots", appName, function (result) {
            if (result == null || result.id === 0) {
                alertify.error("No save at that slot");
                return;
            }

            var sandboxObject = JSON.parse(result.val);

            document.title = sandboxObject.progName;

            if (sandboxObject.scriptText.substring(0, 250).indexOf("FLAG_StartPrgFullscreen") !== -1) document.getElementById("UI_Tab_Main").msRequestFullscreen();

            setTimeout(function () {
                // HTML needs to go first so script will work if they have code outside functions
                $("#UI_MainPlaceholder").append(sandboxObject.htmlText);

                var s = document.createElement("script");
                s.innerHTML = sandboxObject.scriptText;

                // give dom a chance to clean out by waiting a bit?
                setTimeout(function () {
                    document.getElementById("UI_MainPlaceholder").appendChild(s);
                }, 150);
            }, (sandbox.volatile.autorunActive) ? 500 : 250);		// if autorun script unit is involved, give it more time
        });
    },
    editApp: function (appname) {
        if (sandbox.volatile.env === "SBL" || sandbox.volatile.env === "SBL WJS") {
            console.log("ignoring call to sandbox.ide.editApp");
            return;
        }

        appname = appname.replace("%20", " ");	// handle encoded spaces
        appname = appname.replace(/[^a-zA-Z 0-9\-]+/g, ""); // whitelist alphanumeric
        appname = "samples\\" + appname + ".prg";	// force extension

        jQuery.ajax({
            type: "GET",
            url: appname,
            cache: (sandbox.settings.cacheSamples === "true" || !navigator.onLine),
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

                sandbox.ide.setWindowMode(2);
            },
            error: function (xhr, ajaxOptions, thrownError) {
                sandbox.logger.log("If you are hosting this on your own server, make sure to add mime type for .prg files as text/json");
                sandbox.logger.log(xhr.status + " : " + xhr.statusText);
                alertify.log(xhr.status + " : " + xhr.statusText);
                alertify.log("See user log for more info");
            }
        });
    },
    browseSamples: function () {
        if (typeof (sandbox.events.clean) === typeof (Function)) {
            try {
                sandbox.events.clean();
                sandbox.events.clean = null;
            }
            catch (err) {
            }
        }

        // Let Local Filesystem version use samples browser as an 'online' only feature for convenience.
        // If running local filesystem ask them if they want to AJAX to online web samples,
        // otherwise attempt to ajax to local filesystem which works on firefox (and possibly others?)
        if (!sandbox.volatile.isHosted && !sandbox.volatile.isWebkit) {
            alertify.confirm("Go online to access samples?", function (e) {
                if (e) {
                    sandbox.volatile.onlineSamples = true;
                    sandbox.ide.browseSamplesAction();
                } else {
                    sandbox.volatile.onlineSamples = false;
                    sandbox.logger.log("Since you chose not to go online you may encounter permissions errors attempting to load samples using this browser.  You can always use the file pickers to manually load each sample individually offline from your samples folder.");
                    sandbox.ide.browseSamplesAction();
                }
            });
        }
        else {
            sandbox.volatile.onlineSamples = false;
            sandbox.ide.browseSamplesAction();
        }
    },
    browseSamplesAction: function () {
        var baseUrl = "";

        if (sandbox.volatile.env === "SBL" || sandbox.volatile.env === "SBL WJS") {
            console.log("ignoring call to sandbox.ide.browseSamplesAction");
            return;
        }

        if (sandbox.volatile.onlineSamples) {
            baseUrl = "http://www.obeliskos.com/TridentSandbox/";
            sandbox.settings.set("cacheSamples", "false");
            alertify.log("Accessing Online Samples Browser");
        }

        setTimeout(function () {
            var sburl = baseUrl;
            switch (sandbox.volatile.env) {
                case "IDE": sburl += "samples/Hosted Samples Browser.prg"; break;
                case "IDE WJS": sburl += "samples/Samples Browser WJS.prg"; break;
            }

            // ajax caching is weird thing, if i cache always the samples are sometime old.
            // to ensure freshness of sample only visit server if online and they dont have setting set

            jQuery.ajax({
                type: "GET",
                url: sburl,
                cache: (sandbox.settings.cacheSamples === "true" || !navigator.onLine),
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
                    //sandbox.ide.setWindowMode(3);

                    sandbox.ide.run();
                },
                error: function (xhr, ajaxOptions, thrownError) {
                    sandbox.logger.log("If you are hosting this on your own server, make sure to add mime type for .prg files as text/json");
                    sandbox.logger.log(xhr.status + " : " + xhr.statusText);
                    alertify.log(xhr.status + " : " + xhr.statusText);
                    alertify.log("See user log for more info");
                }
            });
        }, 250);
    },
    runAutorun: function () {
        sandbox.volatile.autorunActive = false;

        sandbox.db.getAppKey("SandboxScriptUnits", "autorun", function (result) {
            if (result == null || result.id === 0) return;

            sandbox.volatile.autorunActive = true;
            sandbox.units.appendScriptUnit(result.val);
        });
    },
    loadSlot: function (runAfterLoad) {
        if (sandbox.volatile.env === "SBL" || sandbox.volatile.env === "SBL WJS") {
            console.log("ignoring call to sb_load_run");
            return;
        }

        var htmlHash = CryptoJS.SHA1(sandbox.volatile.editorMarkup.getValue()).toString();
        var scriptHash = CryptoJS.SHA1(sandbox.volatile.editorScript.getValue()).toString();

        if (htmlHash !== sandbox.volatile.markupHash || scriptHash !== sandbox.volatile.scriptHash) {
            alertify.confirm("You have pending changes, are you sure?", function (e) {
                // user clicked "ok"
                if (e) { sandbox.ide.loadSlotAction(runAfterLoad); }
                else {
                    // The chose to abort load of selected slot, attempt to re-select the program
                    // by the name they have entered in the Program Name slot if it exists
                    $("#sb_sel_trident_slot").val($("#sb_txt_ProgramName").val());
                }
            });

            return;
        }

        sandbox.ide.loadSlotAction(runAfterLoad);
    },
    loadSlotAction: function (runAfterLoad) {
        if (sandbox.volatile.env === "SBL" || sandbox.volatile.env === "SBL WJS") {
            console.log("ignoring call to sandbox.ide.loadSlotAction");
            return;
        }

        var selText = $("#sb_sel_trident_slot").find(":selected").text();

        if (selText === "") return;

        sandbox.db.getAppKey("SandboxSaveSlots", selText, function (result) {
            var sandboxObject = JSON.parse(result.val);

            sandbox.volatile.markupHash = CryptoJS.SHA1(sandboxObject.htmlText).toString();
            sandbox.volatile.scriptHash = CryptoJS.SHA1(sandboxObject.scriptText).toString();

            $("#sb_txt_ProgramName").val(sandboxObject.progName);

            sandbox.volatile.editorMarkup.setValue(sandboxObject.htmlText);
            sandbox.volatile.editorScript.setValue(sandboxObject.scriptText);

            if (typeof (autorun) !== "undefined" && autorun) sandbox.ide.run();

        });
    },
    saveSlot: function (callback) {
        if (sandbox.volatile.env === "SBL" || sandbox.volatile.env === "SBL WJS") {
            console.log("ignoring call to sandbox.ide.saveSlot");
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

        if (selText !== progNameString) {
            alertify.confirm("Are you sure you want to save into slot " + progNameString, function (e) {
                if (e) {
                    try {
                        //API_SetIndexedAppKey("SandboxSaveSlots", progNameString, json_text);
                        sandbox.db.setAppKey("SandboxSaveSlots", progNameString, json_text, function (result) {
                            if (result.success) {
                                sandbox.ide.refreshSlots(function () {
                                    // todo: make SetAppKey (both trident and service) return id so i could select by that
                                    $("#sb_sel_trident_slot option").filter(function () {
                                        return $(this).text() === progNameString;
                                    }).prop('selected', true);
                                });

                                if (typeof (callback) === "function") callback();
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
            sandbox.db.setAppKey("SandboxSaveSlots", progNameString, json_text, function (result) {
                if (result.success) {
                    alertify.success("saved");
                    if (typeof (callback) === "function") callback();
                }
                else {
                    alertify.error("Error encountered during save");
                }
            });
        }
    },
    deleteSlot: function () {
        var selText = $("#sb_sel_trident_slot").find(":selected").text();

        if (selText === "") return;

        alertify.confirm("Are you sure you want to delete Trident Program Slot : " + selText, function (e) {
            if (e) {

                sandbox.db.getAppKey("SandboxSaveSlots", selText, function (result) {

                    sandbox.db.deleteAppKey(result.id, function (result) {
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
    },
    toggleHeaderFont: function () {
        var fontName = $('#sb_header_caption').css("font-family");

        if (fontName.indexOf('Heorot') !== -1) {
            $('#sb_header_caption').css("font-family", "Sans");
            $('#sb_header_caption2').css("font-family", "Sans");
        }
        else {
            $('#sb_header_caption').css("font-family", "Heorot");
            $('#sb_header_caption2').css("font-family", "Heorot");
        }
    },
    newProgram: function () {
        if (sandbox.volatile.env === "SBL" || sandbox.volatile.env === "SBL WJS") {
            console.log("ignoring call to sandbox.ide.newProgram");
            return;
        }

        var htmlHash = CryptoJS.SHA1(sandbox.volatile.editorMarkup.getValue()).toString();
        var scriptHash = CryptoJS.SHA1(sandbox.volatile.editorScript.getValue()).toString();

        if (sandbox.settings.pend_changes_warn) {
            if (htmlHash !== sandbox.volatile.markupHash || scriptHash !== sandbox.volatile.scriptHash) {
                alertify.confirm("You have pending changes, are you sure?", function (e) {
                    // user clicked "ok"
                    if (e) {
                        if (sandbox.volatile.windowMode === 3) sandbox.ide.setWindowMode(2);
                        sandbox.ide.clean();
                        return;
                    }
                });
                return;
            }
            else {
                if (sandbox.volatile.windowMode === 3) sandbox.ide.setWindowMode(2);
                sandbox.ide.clean();
                return;
            }
        }

        if (sandbox.volatile.windowMode === 3) sandbox.ide.setWindowMode(2);
        sandbox.ide.clean();
    },
    toggleMarkup: function () {
        sandbox.volatile.scriptCursor = sandbox.volatile.editorScript.getCursor();

        sandbox.volatile.editorMode = sandbox.editorModeEnum.Markup;

        sandbox.ide.fitEditors();

        if (sandbox.volatile.markupCursor) {
            sandbox.volatile.editorMarkup.setCursor(sandbox.volatile.markupCursor);
            sandbox.volatile.editorMarkup.refresh();
        }

        sandbox.volatile.editorMarkup.focus();
    },
    toggleScript: function () {
        sandbox.volatile.markupCursor = sandbox.volatile.editorMarkup.getCursor();

        sandbox.volatile.editorMode = sandbox.editorModeEnum.Script;

        sandbox.ide.fitEditors();

        if (sandbox.volatile.scriptCursor) {
            sandbox.volatile.editorScript.setCursor(sandbox.volatile.scriptCursor);
            sandbox.volatile.editorScript.refresh();
        }

        sandbox.volatile.editorScript.focus();
    },
    toggleSplit: function () {
        if (sandbox.volatile.editorMode === sandbox.editorModeEnum.Split) {
            sandbox.volatile.splitMode = (sandbox.volatile.splitMode === 0) ? 1 : 0;
        }

        sandbox.volatile.editorMode = sandbox.editorModeEnum.Split;

        sandbox.ide.fitEditors();
    },
    foldMarkup: function() {
        sandbox.volatile.editorMarkup.operation(function() { 
            for (var l = sandbox.volatile.editorMarkup.firstLine(); l <= sandbox.volatile.editorMarkup.lastLine(); ++l) 
                sandbox.volatile.editorMarkup.foldCode({line: l, ch: 0}, null, "fold"); 
        }); 
    },
    unfoldMarkup: function() {
        sandbox.volatile.editorMarkup.operation(function() { 
            for (var l = sandbox.volatile.editorMarkup.firstLine(); l <= sandbox.volatile.editorMarkup.lastLine(); ++l) 
                sandbox.volatile.editorMarkup.foldCode({line: l, ch: 0}, null, "unfold"); 
        }); 
    },
    foldScript: function() {
        sandbox.volatile.editorScript.operation(function() { 
            for (var l = sandbox.volatile.editorScript.firstLine(); l <= sandbox.volatile.editorScript.lastLine(); ++l) 
                sandbox.volatile.editorScript.foldCode({line: l, ch: 0}, null, "fold"); 
        }); 
    },
    unfoldScript: function() {
        sandbox.volatile.editorScript.operation(function() { 
            for (var l = sandbox.volatile.editorScript.firstLine(); l <= sandbox.volatile.editorScript.lastLine(); ++l) 
                sandbox.volatile.editorScript.foldCode({line: l, ch: 0}, null, "unfold"); 
        }); 
    },
    fitLog: function () {
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
                if (element.id === "divCode") isDevbarVisible = false;
            }
        }

        // subtract height of tab strip itself (low width might wrap tabs)
        used += $("#UI_TabsOutput").find(".ui-tabs-nav").height();

        if (isCaptionVisible || isLoaderVisible || isDevbarVisible) {
            if (isCaptionVisible) used += ($("#sb_div_caption").height());
            if (isLoaderVisible) used += ($("#sb_div_mainloader").height() + 4);
        }

        if (sandbox.volatile.env === "IDE WJS") {
            used += ($("#UI_TxtLogConsole").height() + 70); // 14 compensate for padding?
        }

        $("#UI_TxtLogText").height($(window).height() - used);
    },
    fitEditors: function () {
        if (sandbox.volatile.env === "SBL" || sandbox.volatile.env === "SBL WJS") {
            console.log("ignoring call to sandbox.ide.fitEditors");
            console.trace();
            return;
        }

        //if ($(window).width() < 1100) {
        //    $(".divWideButtons").hide();
        //    $(".divTinyButtons").show();
        //}
        //else {
        //    $(".divWideButtons").show();
        //    $(".divTinyButtons").hide();
        //}

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
                if (element.id === "divCode") isDevbarVisible = false;
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

                if (sandbox.volatile.splitMode === 0) {
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
    },
    consoleEval: function () {
        sandbox.volatile.lastConsoleCommand = $("#UI_TxtLogConsole").val();
        sandbox.logger.log("=> " + sandbox.volatile.lastConsoleCommand);

        // For some reason API_Inspect calls were not invoking the jquery dialog
        // Not really sure why but adding small delay allows this to work
        setTimeout(function () {
            try {
                var res = eval(sandbox.volatile.lastConsoleCommand);

                if (res != null) sandbox.logger.log("result: " + res);
            }
            catch (err) {
                sandbox.logger.log("Error : " + err.message);
            }
        }, 100);

        $("#UI_TxtLogConsole").val("");
    },
    fullscreenDevArea: function () {
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
    },
    setActiveTab: function (tabId) {
        if (sandbox.volatile.env === "SBL" || sandbox.volatile.env === "SBL WJS") {
            return;
        }

        $("#UI_TabsOutput").tabs("option", "active", tabId);
    },
    toggleMaximize: function () {
        if (sandbox.volatile.env === "SBL" || sandbox.volatile.env === "SBL WJS") {
            return;
        }

        var isCaptionVisible = $("#sb_div_caption").is(":visible");

        if (isCaptionVisible) {
            $("#sb_div_caption").hide();
        }
        else {
            $("#sb_div_caption").show();
        }

        sandbox.ide.fitEditors();
        sandbox.ide.fitLog();
    },
    setToolbarMode: function (showCaption, showLoader) {
        if (sandbox.volatile.env === "SBL" || sandbox.volatile.env === "SBL WJS") {
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

        sandbox.ide.fitLog();
        sandbox.ide.fitEditors();
    },
    setWindowMode: function (mode) {
        if (sandbox.volatile.env === "SBL" || sandbox.volatile.env === "SBL WJS") {
            return;
        }

        // Code Only
        if (mode === 1) {
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
        if (mode === 2) {
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
        if (mode === 3) {
            sandbox.volatile.windowMode = mode;
            //showMarkup = true;
            //showScript = true;
            $('#tdCode').attr('width', '0%');
            $('#tdOutput').attr('width', '100%');
            $('#divCode').hide();
            $('#tblCode').css('table-layout', '');

            $("#UI_TabsOutput").show();
        }
    },
    setMobileMode: function (mode) {
        if (sandbox.volatile.env === "SBL" || sandbox.volatile.env === "SBL WJS") {
            return;
        }

        // Markup Only
        if (mode === 1) {
            sandbox.volatile.windowMode = mode;
            $('#tdOutput').attr('width', '0%');
            $('#tdCode').attr('width', '100%');
            $('#divCode').show();
            $('#tblCode').css('table-layout', '');

            $("#UI_TabsOutput").hide();

            sandbox.volatile.editorMode = sandbox.editorModeEnum.Markup;
            sandbox.ide.fitEditors();

            $('.CodeMirror').each(function (i, el) {
                el.CodeMirror.refresh();
            });
        }

        // Code Only
        if (mode === 2) {
            sandbox.volatile.windowMode = mode;
            $('#tdOutput').attr('width', '0%');
            $('#tdCode').attr('width', '100%');
            $('#divCode').show();
            $('#tblCode').css('table-layout', '');

            $("#UI_TabsOutput").hide();

            sandbox.volatile.editorMode = sandbox.editorModeEnum.Script;
            sandbox.ide.fitEditors();

            $('.CodeMirror').each(function (i, el) {
                el.CodeMirror.refresh();
            });
        }

        // Show Output only
        if (mode === 3) {
            sandbox.volatile.windowMode = mode;
            $('#tdCode').attr('width', '0%');
            $('#tdOutput').attr('width', '100%');
            $('#divCode').hide();
            $('#tblCode').css('table-layout', '');

            $("#UI_TabsOutput").show();
        }
    },
    restoreLayout: function () {
        if (sandbox.volatile.env === "SBL" || sandbox.volatile.env === "SBL WJS") {
            return;
        }

        sandbox.ui.fullscreenExit();
        sandbox.ide.setToolbarMode(true, true);
        sandbox.ide.setWindowMode(2);
    },
    selectTheme: function () {
        if (sandbox.volatile.env === "SBL" || sandbox.volatile.env === "SBL WJS") {
            return;
        }

        var theme = $("#selTheme option:selected").val();
        if (localStorage) {
            sandbox.settings.set("editorTheme", theme);
        }

        sandbox.volatile.editorMarkup.setOption("theme", theme);
        sandbox.volatile.editorScript.setOption("theme", theme);
    },
    applyMobileMode: function (persist) {
        if (sandbox.volatile.env === "SBL" || sandbox.volatile.env === "SBL WJS") {
            return;
        }

        if (localStorage && persist) {
            sandbox.settings.set("ideMode", "mobile");
        }

        $("#divMobileWindowMode").css('display', 'inline');
        $("#divDesktopEditorMode").hide();
        $("#divDesktopWindowMode").hide();

        sandbox.ide.setMobileMode(1);
    },
    applyDesktopMode: function () {
        if (sandbox.volatile.env === "SBL" || sandbox.volatile.env === "SBL WJS") {
            return;
        }

        if (localStorage) {
            sandbox.settings.set("ideMode", "desktop");
        }

        $("#divMobileWindowMode").hide();
        $("#divDesktopEditorMode").show();
        $("#divDesktopWindowMode").show();

        sandbox.ide.setWindowMode(2);
        sandbox.volatile.editorMode = sandbox.editorModeEnum.Split;
        sandbox.ide.fitEditors();
    }
};

//#endregion ide

//#region sandboxUtil

var sandboxUtil = {
    addDate: function (unixDate, offset, offsetType) {
        var oldDate = new Date();
        oldDate.setTime(unixDate);
        var year = parseInt(oldDate.getFullYear());
        var month = parseInt(oldDate.getMonth());
        var date = parseInt(oldDate.getDate());
        var hour = parseInt(oldDate.getHours());
        var newDate;

        switch (offsetType) {
            case "years":
            case "Y":
            case "y":
                newDate = new Date(year + offset, month, date, hour);
                break;
            case "months":
            case "M":
            case "m":
                newDate = new Date(year, month + offset, date, hour);
                break;
            case "days":
            case "D":
            case "d":
                newDate = new Date(year, month, date + offset, hour);
                break;
            case "weeks":
            case "W":
            case "w":
                newDate = new Date(year, month, date + offset * 7, hour);
                break;
            case "hours":
            case "H":
            case "h":
                newDate = new Date(year, month, date, hour + offset);
                break;
        }

        return newDate.getTime();
    }
};

//#endregion

//#region sandboxProtos

var sandboxProtos = [
    {
        title: "sandbox",
        isFolder: true,
        key: "id3",
        hideCheckbox: true,
        tooltip: "sandbox namespace root.  Wraps all the sandbox specific functionality and convenience methods into this namespace-like hierarchy.  It is a singleton and most methods are heavily ui-bound but it provides a common engine used by all page variations and adds cleanliness to sandbox and user program code.",
        expand: true,
        children: [
            {
                title: "db",
                isFolder: true,
                key: "db",
                hideCheckbox: true,
                tooltip: "This object reference may point to any number of database adapters such as TridentMemoryAdapter, TridentIndexedAdapter, TridentServiceAdapter.  The sandbox environment uses this as the primary location for saving programs.",
                children: [
                    { title: "getAllKeys(callback)", key: "getAllKeys", hideCheckbox: true, tooltip: "(adapter interface function) This will pass into your callback an array of objects representing all database keys (minus the val property and adding a size property)." },
                    { title: "getAppKeys(app, callback)", key: "getAppKeys", hideCheckbox: true, tooltip: "(adapter interface function) This will pass into your callback an array of objects representing all keys for the specified application (minus the val property and adding a size property)." },
                    { title: "getAppKey(app, key, callback)", key: "getAppKey", hideCheckbox: true, tooltip: "(adapter interface function) This will retrieve a single key with that app/key combination, returning an object representing it to your callback.  The object returned will contain app, key, val, and id properties." },
                    { title: "getAppKeyById(id, callback)", key: "getAppKeyById", hideCheckbox: true, tooltip: "(adapter interface function) This will retrieve a single key with the id provided and return to your callback an object representing it." },
                    { title: "setAppKey(app, key, val, callback)", key: "setAppKey", hideCheckbox: true, tooltip: "(adapter interface function) This will add or update a single key within the database.  You supply app, key, and val, and can optionally implement a callback to be notified when it completes." },
                    { title: "deleteAppKey(id, callback)", key: "deleteAppKey", hideCheckbox: true, tooltip: "(adapter interface function) This will allow you to delete a database key by providing its 'id'.  You may implement a callback to be notified when it completes." }
                ]
            },
            {
                title: "events",
                isFolder: true,
                key: "events",
                hideCheckbox: true,
                tooltip: "This object placeholder allows you to attach, intercept, and respond to sandbox generated events.  Your program may override these to be notified.  These are cleared out when sandbox is cleared.",
                children: [
                    { title: "clean()", key: "clean", hideCheckbox: true, tooltip: "You may optionally attach a function to this location (sandbox.events.clean) to be notified when the sandbox is clearing out your program." },
                    { title: "windowResize", key: "windowResize", hideCheckbox: true, tooltip: "You may optionally attach a function to this location to be notified when the browser is resized." },
                    { title: "databaseChanged", key: "databaseChanged", hideCheckbox: true, tooltip: "Attach an event to this if you want to be notified of when the database adapter has changed.  Hopefully that won't happen while your program is running." },
                    { title: "userLoadCallback(filestring, filename)", key: "userLoadCallback", hideCheckbox: true, tooltip: "If you use the user file loader (in files namespace), this event will be fired upon the user picking a file to load.  Your callback will be passed two variables, the first containing the string contents of the text file, and the second containing the file name of the picked file." },
                    { title: "userdataLoadCallback(dataUrl, filename)", key: "userdataLoadCallback", hideCheckbox: true, tooltip: "If you use the user binary file loader (in files namespace), this event will be fired upon the user picking and loading the file. Your callback will be passed two variables, the first containing a binaryUri representation of the binary data, and the second containing the file name of the picked file." }
                ]
            },
            {
                title: "files",
                isFolder: true,
                hideCheckbox: true,
                tooltip: "This is the sandbox interface to ease the use of the File API for importing and exporting files.",
                children: [
                    { title: "userfileShow()", key: "userfileShow", hideCheckbox: true, tooltip: "Displays a file picker for the user to easily load text files from.  Requires you to implement and attach a callback to sandbox.events.userLoadCallback to receive the loaded text." },
                    { title: "userfileHide()", key: "userfileHide", hideCheckbox: true, tooltip: "Hides the user file picker." },
                    { title: "userdataShow()", key: "userdataShow", hideCheckbox: true, tooltip: "Displays a file picker for the user to easily load binary files from.  Requires you to implement and attach a callback to sandbox.events.userdataLoadCallback to receive the dataUri formatted binary file as a string." },
                    { title: "userdataHide()", key: "userdataHide", hideCheckbox: true, tooltip: "Hides the user data (binary) file picker" },
                    { title: "exportDatabaseKeys()", key: "exportDatabaseKeys", hideCheckbox: true, tooltip: "Invokes a download containing all of the keys in the database for archival.  More functionality is available from the dashboard but this was left available." },
                    { title: "dataUrlToBlob(dataURL)", key: "dataUrlToBlob", hideCheckbox: true, tooltip: "Passing this function a dataUri/dataUrl string will convert it into a binary blob format." },
                    { title: "saveTextFile(fileName, saveString)", key: "saveTextFile", hideCheckbox: true, tooltip: "Pass in a filename and a string containing text to put in a file and this method will invoke a download of that file." },
                    { title: "saveDataURL(fileName, dataURL)", key: "saveDataURL", hideCheckbox: true, tooltip: "Pass in a filename and a dataUrl/dataUri string and this will invoke a download to save that as a binary file." },
                    { title: "saveOrOpenTextFile(fileName, saveString)", key: "saveOrOpenTextFile", hideCheckbox: true, tooltip: "Similar to saveTextFile, except it offers the option to open along with save and cancel options." }
                ]
            },
            {
                title: "ide",
                isFolder: true,
                key: "ide",
                hideCheckbox: true,
                tooltip: "This contains methods for controlling the sandbox ide environment itself.",
                children: [
                    { title: "run()", key: "run", hideCheckbox: true, tooltip: "Identical to pressing the 'run' toolbar button.  Clears sandbox and starts program cleanly." },
                    { title: "launch()", key: "launch", hideCheckbox: true, tooltip: "Identical to pressing the 'launch' toolbar button.  Runs the program in a new window without an ide." },
                    { title: "clean()", key: "clean", hideCheckbox: true, tooltip: "Identical to pressing 'new' toolbar button.  Clears editors and output and defaults to new program template." },
                    { title: "clearOutput()", key: "clearOutput", hideCheckbox: true, tooltip: "Identical to pressing 'clear output' toolbar button.  Clears output and runs clean event but leaves editor text intact for subsequent runs." },
                    { title: "runApp(progname)", key: "runApp", hideCheckbox: true, tooltip: "Will issue an ajax call to load a sample program.  Used by samples browsers." },
                    { title: "runSlot(appName)", key: "runSlot", hideCheckbox: true, tooltip: "Will load a program from a save slot in the trident database.  Used by the program save dropdown list." },
                    { title: "runAutorun()", key: "runAutorun", hideCheckbox: true, tooltip: "Will manually re-run the autorun save slot.  Might be useful if autorun is available but disabled, this would manually run it." },
                    { title: "setActiveTab(tabId)", key: "setActiveTab", hideCheckbox: true, tooltip: "Switch the active tab to main output (0) or text log (1) " },
                    { title: "setWindowMode(mode)", key: "setWindowMode", hideCheckbox: true, tooltip: "Switch between window modes : code only (1) code and output (2) or output only (3)" }
                ]
            },
            {
                title: "logger",
                isFolder: true,
                key: "logger",
                hideCheckbox: true,
                tooltip: "This contains methods for controlling logging, tracing, and visual inspection of data for diagnostic purposes.",
                children: [
                    { title: "log(msg)", key: "log", hideCheckbox: true, tooltip: "The default method for sending text to the text log tab (in IDE).  In sandbox loaders the text will be sent to the console." },
                    { title: "logObject(objToLog, objName)", key: "logObject", hideCheckbox: true, tooltip: "Dumps an object to the text log tab with formatted indentation." },
                    { title: "clearLog()", key: "clearLog", hideCheckbox: true, tooltip: "Clears the text log output tab." },
                    { title: "trace()", key: "trace", hideCheckbox: true, tooltip: "Invokes a browser trace which dumps stack.  Currently goes to browser console." },
                    { title: "inspect(objVar, caption)", key: "inspect", hideCheckbox: true, tooltip: "Use this method to send an object to the trident variable inspector.  This utilizes the prettyprint.js library to create a dialog which you can drill down into simple or deeply hierarchical objects." },
                    { title: "notify(msg, caption)", key: "notify", hideCheckbox: true, tooltip: "Alternative to alertify.log() in case i switch to another notification library in the future.  Provided for future proofing, caption is not currently being used." },
                    { title: "notifySuccess(msg, caption)", key: "notifySuccess", hideCheckbox: true, tooltip: "Alternative to alertify.success() in case i switch to another notification library in the future.  Provided for future proofing, caption is not currently being used." },
                    { title: "notifyError(msg, caption)", key: "notifyError", hideCheckbox: true, tooltip: "Alternative to alertify.error() in case i switch to another notification library in the future.  Provided for future proofing, caption is not currently being used." }
                ]
            },
            {
                title: "media",
                isFolder: true,
                hideCheckbox: true,
                tooltip: "Contains methods relevant to playing media.",
                children: [
                    { title: "playAudio(uri)", key: "playAudio", hideCheckbox: true, tooltip: "Plays an audio file invisibly, given an internet url or dataUri." },
                    { title: "speak(msgText)", key: "speak", hideCheckbox: true, tooltip: "If your browser supports the Speech API, this is a convenience method for simply speaking a message." },
                    { title: "isSpeechAvailable", key: "isSpeechAvailable", hideCheckbox: true, tooltip: "(boolean) indicates if the Speech API is supported by your browser" }
                ]
            },
            {
                title: "ui",
                isFolder: true,
                hideCheckbox: true,
                tooltip: "This contains methods for controlling your program's user interface.",
                children: [
                    { title: "setDarkTheme()", key: "setDarkTheme", hideCheckbox: true, tooltip: "This will set background color to dark grey and text color to white." },
                    { title: "setLightTheme()", key: "setLightTheme", hideCheckbox: true, tooltip: "This will set background color to white and text color to black." },
                    { title: "setBackgroundColor(colorCode)", key: "setBackgroundColor", hideCheckbox: true, tooltip: "Use this to change background color." },
                    { title: "clearMain()", key: "clearMain", hideCheckbox: true, tooltip: "Clears the main tab of all UI/DOM elements." },
                    { title: "fullscreen(elem)", key: "fullscreen", hideCheckbox: true, tooltip: "Requests that the browser go fullscreen.  If you pass in an optional DOM element, it will just fullscreen that element.  Most browsers require this to be executed during a button click event." },
                    { title: "fullscreenExit()", key: "fullscreenExit", hideCheckbox: true, tooltip: "Exits fullscreen mode via code.  ESC key should always escape fullscreen but this method might be additional convenience." },
                    { title: "fullscreenToggle()", key: "fullscreenToggle", hideCheckbox: true, tooltip: "Toggles fullscreen." },
                    { title: "showPasswordDialog(callback)", key: "showPasswordDialog", hideCheckbox: true, tooltip: "Brings up a dialog for password entry.  When the user enters a password and clicks ok, this dialog will call your provided callback function, passing the password into it as a string." }
                ]
            },
            {
                title: "units",
                isFolder: true,
                hideCheckbox: true,
                tooltip: "This contains methods for interacting with the Library Unit subsystem.  This subsystem allows reusability of scripts or markup by saving them into the trident database, to be recalled within your programs.  While there is a 'utility sample' which performs much of this maintenance, these methods allow you to recall within your programs. ",
                children: [
                    { title: "logMarkupUnits()", key: "logMarkupUnits", hideCheckbox: true, tooltip: "Mostly for console use.  This will dump a list of markup units in the trident database to the text log." },
                    { title: "saveMarkupUnit(unitName)", key: "saveMarkupUnit", hideCheckbox: true, tooltip: "Mostly for console use.  This will save the contents of the Markup editor as a markup unit within the trident database." },
                    { title: "loadMarkupUnit(unitName)", key: "loadMarkupUnit", hideCheckbox: true, tooltip: "Mostly for console use.  This will load the markup unit from the trident database into the Markup editor of the IDE." },
                    { title: "getMarkupUnit(unitName, callback)", key: "getMarkupUnit", hideCheckbox: true, tooltip: "Use this within you programs to recall markup units as a string which you can then insert into your web pages.  Your callback is passed a string value containing the markup unit text." },
                    { title: "logScriptUnits()", key: "logScriptUnits", hideCheckbox: true, tooltip: "Mostly for console use.  This will dump a list of script units in the trident database to the text log." },
                    { title: "saveScriptUnit(unitName)", key: "saveScriptUnit", hideCheckbox: true, tooltip: "Mostly for console use.  This will save the contents of the Script editor as a script unit within the trident database." },
                    { title: "loadScriptUnit(unitName)", key: "loadScriptUnit", hideCheckbox: true, tooltip: "Mostly for console use.  This will load the script unit from the trident database into the Script editor of the IDE." },
                    { title: "importScriptUnit(unitName, callback)", key: "importScriptUnit", hideCheckbox: true, tooltip: "This command will load your script unit from the trident database and automatically add it to the page for use.  Pass in a callback to be notified when this is done." },
                    { title: "appendScriptUnit(scriptText, callback)", key: "appendScriptUnit", hideCheckbox: true, tooltip: "If you already have the script text and do not need to load it from the trident database, this will just append it for use.  Pass in a callback to be notified when this is done." },
                    { title: "clearScriptUnits()", key: "clearScriptUnits", hideCheckbox: true, tooltip: "Can be used to clear out old scripts but scripts often get attached to the DOM via the window object and will remain until page is reloaded, so do not depend too much on this." }
                ]
            },
            {
                title: "util",
                isFolder: true,
                hideCheckbox: true,
                tooltip: "Contains miscellaneous utility functions.",
                children: [
                    { title: "addDate(unixDate, offset, offsetType)", key: "addDate", hideCheckbox: true, tooltip: "Utility function for date management. unixDate (number) unixms date format returned by javascript date's getTime() method.  offset (number) # of days/weeks/months/years to add to input date.  offsetType (string) : 'years', 'months', 'days', 'weeks', 'hours', 'y', 'm', 'd', 'w', 'h'. Returns (number) unixms formatted adjusted date. "}
                ]
            },
            {
                title: "volatile",
                isFolder: true,
                hideCheckbox: true,
                tooltip: "This contains properties which are either hardcoded or just not saved or loaded.",
                children: [
                    { title: "version", key: "version", hideCheckbox: true, tooltip: "(string) variable containing the version label of the trident sandbox environment, such as \"2.1.0\"" },
                    { title: "env", key: "env", hideCheckbox: true, tooltip: "(string) variable containing either \"IDE\", \"IDE WJS\", \"SBL\", or \"SBL WJS\".  This indiciates which trident sandbox page your program is running under." }
                ]
            }
        ]
    }
];

//#endregion sandboxProtos

//#region sandbox obejct

var sandbox = {
    db: null,
    protos: sandboxProtos,
    showProtos: function() {
        $("#div-sbx-api").dialog({
            title: 'Sandbox Library Reference',
            width: 500,
            height: 600,
            open: function () {
                $("#sandboxTree").dynatree({
                    checkbox: true,
                    // Override class name for checkbox icon:
                    classNames: { checkbox: "dynatree-radio" },
                    selectMode: 1,
                    children: sandbox.protos,
                    onActivate: function (node) {
                        $("#nodeInfo").text(node.data.tooltip);
                    },
                    onKeydown: function (node, event) {
                    },
                    // The following options are only required, if we have more than one tree on one page:
                    //initId: "treeData",
                    cookieId: "dynatree-Cb1",
                    idPrefix: "dynatree-Cb1-"
                });
            },
            beforeClose: function () {
                $("#sandboxTree").dynatree("destroy");
                $("#sandboxTree").empty();
                $("#nodeInfo").empty();
            }
        });
    },
    logger: sbxLogger,
    media: sandboxMedia,
    files: sandboxFiles,
    units: sandboxUnits,
    util: sandboxUtil,
    ide: sandboxIDE,
    ui: sandboxUI,
    events: sandboxEvents,
    appcache: sandboxAppCache,
    memstats: sandboxMemstats,
    dashboard: sandboxDashboard,
    editorModeEnum: Object.freeze({ "Markup": 1, "Split": 2, "Script": 3 }),
    volatile: {
        version: "2.17",
        env: '',    // page should set this in document.ready to 'WJS IDE', 'IDE', 'SBL', 'SBL WJS', or 'SA'
        online: function () { return navigator.onLine; },
        vars: null,
        markupHash: null,
        scriptHash: null,
        isHosted: (document.URL.indexOf("file://") === -1),
        isWebkit: (typeof(process) === "object" && typeof(require) === "function" && typeof(window) === "object"),
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
        autorunActive: false,
        onlineSamples: false,
        memStats: null,
        memStatsRequestId: null,
        markupCursor: null,
        scriptCursor: null,
        splitMode: 0, // determines if split mode for editors is side-by-side (0) or top-bottom (1)
        envTest: function (envs) {
            return (envs.indexOf(this.env) !== -1);
        }
    },
    settings: {
        headerText: "Trident Sandbox Development Environment",
        headerTextWJS: "Trident Sandbox with WinJS framework",
        headerFont: "Heorot",
        editorTheme: "liquibyte",
        autorunSlot: "",
        skipAutorun: "true",   // interpret all properties as strings for dashboard editor
        useLinter: "true",
        errorPopups: "true",
        pendingChangesWarning: "true",
        ideMode: "desktop",
        databaseAdapter: "trident",
        databaseServiceLocation: "",
        cacheSamples: "false",
        keybindRun: "Alt+R",
        keybindSave: "Alt+S",
        keybindInspect: "Alt+I",
        keybindToggleMarkup: "Alt+Q",
        keybindToggleScript: "Alt+W",
        keybindWinMode1: "Alt+1",
        keybindWinMode2: "Alt+2",
        keybindWinMode3: "Alt+3",
        keybindMarkupFold: "Ctrl+Alt+Z",
        keybindMarkupUnfold: "Ctrl+Alt+X",
        keybindScriptFold: "Ctrl+Alt+M",
        keybindScriptUnfold: "Ctrl+Alt+N",
        keybindLaunch: "Alt+L",
        keybindToggleLint: "Ctrl+Alt+G",
        load: function () {
            if (!localStorage) return;

            var p;

            // for each property defined in our settings object
            for (p in this) {
                // if its not a function
                if (typeof (this[p]) !== "function") {
                    // see if local storage has a value for that setting defined
                    if (typeof (localStorage[p]) !== "undefined") {
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
            sandbox.settings[setting] = value;

            if (localStorage) {
                localStorage[setting] = value;
            }
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
                if (typeof (this[p]) !== "function") {
                    val = this.getParameter(p);
                    // see if hash param has a value for that setting defined
                    if (typeof (val) !== "undefined") {
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
                if (sParameterName[0] === sParam) {
                    return decodeURIComponent(sParameterName[1]);
                }
            }
        }

    },
    nullFunction: function() {
    },
    dbInit: function (callback) {
        var dbChanged = sandbox.events.databaseChanged || sandbox.nullFunction;

        callback = callback || this.nullFunction;

        if (sandbox.volatile.envTest(["IDE", "IDE WJS"])) {
            $("#sb_div_ls_slots").css("display", "inline-block");
        }

        // if running off local filesystem -and- indexeddb is not available -and- they arent using service or other adapter, use memory adapter
        if (!indexedDB && !sandbox.volatile.isHosted && sandbox.settings.databaseAdapter === "trident") {
            sandbox.settings.databaseAdapter = "memory";
        }

        switch (sandbox.settings.databaseAdapter) {
            case "trident":
                sandbox.db = new TridentIndexedAdapter({
                    upgradeCallback: function () { sandbox.logger.log("Upgrading"); },
                    successCallback: function () {
                        sandbox.logger.log("Trident indexedDB adapter initialized successfully.");

                        if (sandbox.volatile.env === "IDE" || sandbox.volatile.env === "IDE WJS") {
                            $("#sb_spn_indexeddb_status").text("IndexedDB");

                            // load slots now that db is initialized and then do post init
                            sandbox.ide.refreshSlots(callback);
                            dbChanged();
                        }
                        else {
                            callback();
                            dbChanged();
                        }
                    },
                    errorCallback: function () { sandbox.logger.log("Error opening TridentSandboxDB (indexedDB)."); }

                });
                // allow legacy variable support for a version or two

                break;

            case "service":
                sandbox.db = new TridentServiceAdapter({
                    serviceLocation: sandbox.settings.databaseServiceLocation,
                    successCallback: function () {
                        sandbox.logger.log("Trident service adapter initialized successfully.");

                        if (sandbox.volatile.env === "IDE" || sandbox.volatile.env === "IDE WJS") {
                            $("#sb_spn_indexeddb_status").html("Service");

                            // load slots now and do post init
                            sandbox.ide.refreshSlots(callback);
                            dbChanged();
                        }
                        else {
                            callback();
                            dbChanged();
                        }
                    }
                });

                break;
            case "":
            case "memory":
                sandbox.db = new TridentMemoryAdapter({
                    successCallback: function () {
                        $("#sb_spn_indexeddb_status").html("Memory");
                        sandbox.logger.log("In-memory database adapter initialized.");
                        sandbox.logger.log("You may use database backup and restore to save keys to a file, if needed.");

                        if (sandbox.volatile.envTest(["IDE", "IDE WJS"])) {
                            sandbox.ide.refreshSlots(callback);
                            dbChanged();
                        }
                        else {
                            callback();
                            dbChanged();
                        }
                    }
                });
                break;
            default:
                sandbox.db = new window[sandbox.settings.databaseAdapter]({
                    successCallback: function () {
                        $("#sb_spn_indexeddb_status").text(sandbox.settings.databaseAdapter);

                        if (sandbox.volatile.env === "IDE" || sandbox.volatile.env === "IDE WJS") {
                            // load slots now that db is initialized and then do post init
                            sandbox.ide.refreshSlots(callback);
                            dbChanged();
                        }
                    },
                    errorCallback: function () { sandbox.logger.log("Error opening adapter " + sandbox.settings.databaseAdapter); }
                });

                break;
        }
    },
    dbAdapterChanged: function () {
        if (sandbox.db.adapter.name === "indexedDB") {
            $("#sb_spn_indexeddb_status").text("Yes");
        }
        else {
            $("#sb_spn_indexeddb_status").html("Yes <span style='font-family:Symbol'>Å</span>");
        }

        // Now that not only is indexed db available but the Trident database is opened, handle url LoadSlot/RunSlot hash params
        sandbox.ide.refreshSlots();

    },
    initialize: function (options) {
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
        if (typeof Uint8ClampedArray === "undefined") {
            Uint8ClampedArray = Uint8Array;
        }

        sandbox.settings.load();
        sandbox.hashparams.load();

        // For IDE versions, set up some keyboard shortcuts
        if (sandbox.volatile.env === "IDE" || sandbox.volatile.env === "IDE WJS") {
            shortcut.add(sandbox.settings.keybindRun, function () { sandbox.ide.run(); });
            shortcut.add(sandbox.settings.keybindSave, function () { if (indexedDB) { sandbox.ide.saveSlot(); } else { sandbox.files.programSave(); } });
            shortcut.add(sandbox.settings.keybindToggleMarkup, function () { if (sandbox.volatile.editorMode === sandbox.editorModeEnum.Markup) sandbox.ide.toggleSplit(); else sandbox.ide.toggleMarkup(); });
            shortcut.add(sandbox.settings.keybindToggleScript, function () { if (sandbox.volatile.editorMode === sandbox.editorModeEnum.Script) sandbox.ide.toggleSplit(); else sandbox.ide.toggleScript(); });
            shortcut.add(sandbox.settings.keybindInspect, function () { sandbox.ide.inspectSelection(); });
            shortcut.add(sandbox.settings.keybindWinMode1, function () { sandbox.ide.setWindowMode(1); });
            shortcut.add(sandbox.settings.keybindWinMode2, function () { sandbox.ide.setWindowMode(2); });
            shortcut.add(sandbox.settings.keybindWinMode3, function () { sandbox.ide.setWindowMode(3); });
            shortcut.add(sandbox.settings.keybindMarkupFold, sandbox.ide.foldMarkup);
            shortcut.add(sandbox.settings.keybindMarkupUnfold, sandbox.ide.unfoldMarkup);
            shortcut.add(sandbox.settings.keybindScriptFold, sandbox.ide.foldScript);
            shortcut.add(sandbox.settings.keybindScriptUnfold, sandbox.ide.unfoldScript);
            shortcut.add(sandbox.settings.keybindToggleLint, sandbox.ide.toggleLint);


            // For some reason IE sometimes 'remembers' this val across loads
            $("#sb_txt_ProgramName").val("");

            // While waiting for user to click the allow scripts button, we hid some ugly UI elements,
            // so now scripts are enabled un-hide the code elements and clear our warning/notice log message.
            $("#divCode").css("display", "block");
            $("#UI_TabsOutput").tabs();
            $("#UI_TabsDashboard").tabs();
            $("#sb_radioset").buttonset();

            sandbox.logger.clearLog();

            if (sandbox.volatile.envTest(["IDE", "IDE WJS"])) {
                document.title = "Trident Sandbox " + ((sandbox.volatile.env === "IDE WJS")?"WJS":"") + " v" + sandbox.volatile.version;
                var markupInitText = "";
                markupInitText += "<!-- Welcome to TridentSandbox v" + sandbox.volatile.version + "\r\n\r\nCtrl-Space : Bring up code completion list\r\nF11 : (while in an editor) will toggle fullscreen editing.\r\nESC : will also exit fullscreen mode. \r\nCtrl+Q : Within an editor (on a code fold line) will toggle fold\r\nCtrl-F : Find text (In editor this will do basic search)\r\nCtrl-G : Find next\r\nShift-Ctrl-F : Replace\r\nShift-Ctrl-R : Replace All\r\n\r\n";
                markupInitText += "Rebindable in dashboard (make sure that your browser's own shortcuts don't conflict) :\r\n";
                markupInitText += sandbox.settings.keybindRun + " : Run\r\n";
                markupInitText += sandbox.settings.keybindLaunch + " : Run/Launch Program in new window\r\n";
                markupInitText += sandbox.settings.keybindSave + " : Save\r\n";
                markupInitText += sandbox.settings.keybindToggleMarkup + " : Toggle Markup\r\n";
                markupInitText += sandbox.settings.keybindToggleScript + " : Toggle Script\r\n";
                markupInitText += sandbox.settings.keybindInspect + " : Inspect Selection / API Reference\r\n";
                markupInitText += sandbox.settings.keybindWinMode1 + " : Window Mode 1\r\n";
                markupInitText += sandbox.settings.keybindWinMode2 + " : Window Mode 2\r\n";
                markupInitText += sandbox.settings.keybindWinMode3 + " : Window Mode 3\r\n";
                markupInitText += sandbox.settings.keybindMarkupFold + " : Fold All (Markup)\r\n";
                markupInitText += sandbox.settings.keybindMarkupUnfold + " : Unfold All (Markup)\r\n";
                markupInitText += sandbox.settings.keybindScriptFold + " : Fold All (Script)\r\n";
                markupInitText += sandbox.settings.keybindScriptUnfold + " : Unfold All (Script)\r\n";
                markupInitText += sandbox.settings.keybindToggleLint + " : Toggle Linting\r\n";

                markupInitText += "-->";
                $("#sb_txt_Markup").val(markupInitText);
            }

            $("#sb_txt_Script").val("// script editor tips : \r\n// autoindenting is turned on\r\n// the horizontal slashes indicate forced tabs (instead of smart indenting)\r\n// use shift-tab to use auto-indention for a line instead (cleans up tab slashes)\r\n// use ctrl-a or select multiple lines and then press shift-tab to smart indent them\r\n// the javascript linter may notify you of issues with your code, such as : \r\n\r\nfunction badCode() {\r\n\tvar test=[]\r\n\r\n\tvar test = 'a';\r\n}");

            $('#UI_TabsDashboard').on('tabsactivate', function (event, ui) {
                var newIndex = ui.newTab.index();
                switch (newIndex) {
                    case 0: sandbox.dashboard.calcSummaryUsage(); break;
                    case 1: sandbox.dashboard.calcLocalStorageUsage(); break;
                    case 2: sandbox.dashboard.calcTridentDbUsage(); break;
                    case 3: sandbox.dashboard.populateBackupTab(); break;
                    case 5: sandbox.dashboard.activateAdapterTab(); break;
                }
            });

            // ugly but lenient feature detection for Displaying Browse Samples button
            // if served up from anywhere other than filesystem ... show
            // if served up from filesystem and localStorage is available... show
            // Mozilla supports ajax calls under filesystem
            if (document.URL.indexOf("file://") === -1 || localStorage || indexedDB) {
                //$(".ui_show_dashboard").show();
                $("#ui_btn_launch").show();
                $("#ui_gen_sa").hide();	// no need to generate standalone if hosted/appcached
                shortcut.add(sandbox.settings.keybindLaunch, function () { sandbox.ide.launch(); });
            }

            // We are keeping track of whether the user has pending changes via a Crypto.JS hash on the markup and script
            // This will now calculate the initial value based on our Welcome text above
            sandbox.volatile.markupHash = CryptoJS.SHA1($("#sb_txt_Markup").val()).toString();
            sandbox.volatile.scriptHash = CryptoJS.SHA1($("#sb_txt_Script").val()).toString();

            var useLinter = (sandbox.settings.useLinter === "true");

            // We are using xml mode for markup so that if we add style tag it wont mess up rendering
            // hopefully in the future we can implement mixed rendering or add separate css
            sandbox.volatile.editorMarkup = CodeMirror.fromTextArea(document.getElementById("sb_txt_Markup"), {
                smartIndent: true,
                autoCloseTags: true,
                lineNumbers: true,
                theme: sandbox.settings.editorTheme,
                mode: "htmlmixed",
                matchTags: true,
                foldGutter: true,
                showCursorWhenSelecting: true,
                gutters: ["CodeMirror-linenumbers", "CodeMirror-foldgutter"],
                indentUnit: 4,
                tabSize: 4,
                extraKeys: {
                    "Ctrl-Q": function (cm) {
                        cm.foldCode(cm.getCursor());
                    },
                    "Ctrl-Space": "autocomplete",
                    "F11": function (cm) {
                        cm.setOption("fullScreen", !cm.getOption("fullScreen"));
                    },
                    "Esc": function (cm) {
                        if (cm.getOption("fullScreen")) cm.setOption("fullScreen", false);
                    }
                }
            });

            sandbox.volatile.editorScript = CodeMirror.fromTextArea(document.getElementById("sb_txt_Script"), {
                smartIndent: true,
                lineNumbers: true,
                theme: sandbox.settings.editorTheme,
                mode: { name:"javascript", globalVars: true},
                matchBrackets: true,
                foldGutter: true,
                showCursorWhenSelecting: true,
                gutters: (useLinter)?["CodeMirror-linenumbers", "CodeMirror-lint-markers", "CodeMirror-foldgutter"]:["CodeMirror-linenumbers", "CodeMirror-foldgutter"],
                lint: useLinter,
                indentUnit: 4,
                tabSize: 4,
                extraKeys: {
                    "Ctrl-Q": function (cm) {
                        cm.foldCode(cm.getCursor());
                    },
                    "Ctrl-Space": "autocomplete",
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
                    return $(this).text() === sandbox.settings.editorTheme;
                }).prop('selected', true);

                sandbox.volatile.editorMarkup.setOption("theme", sandbox.settings.editorTheme);
                sandbox.volatile.editorScript.setOption("theme", sandbox.settings.editorTheme);
            }

            if (sandbox.settings.headerFont) {
                $('#sb_header_caption').css("font-family", sandbox.settings.headerFont);
                $('#sb_header_caption2').css("font-family", sandbox.settings.headerFont);
            }

            if (sandbox.volatile.env === "IDE") {
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

            sandbox.ide.fitLog();
            sandbox.ide.fitEditors();

            if (localStorage) {
                $("#sb_spn_localstorage_status").text("Yes");
                $("#ui_show_dashboard").show();
            }

            // only had memstats in wjs version?
            if (sandbox.hashparams.getParameter("memstats")) {
                sandbox.memstats.on();
            }

            if (sandbox.settings.ideMode === 'mobile') {
                sandbox.ide.applyMobileMode();
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
                sandbox.ide.fitLog();
                sandbox.ide.fitEditors();
            }

            // Allow User Programs to receive window resize events
            // by implementing this callback
            if (typeof (sandbox.events.windowResize) === typeof (Function)) sandbox.events.windowResize();
        });

        if (sandbox.volatile.envTest(["SBL", "SBL WJS"])) {
            // Detect Hash Param changes for loadslot/runslot;
            window.onhashchange = function () {
                // Probably better (cleaner) to just clean slate and force page reload
                location.reload();
            };
        }
        else {
            // Detect Hash Param changes for loadslot/runslot; (compare to txtProgramName or SaveSlotSelect?)
            window.onhashchange = function () {
                var loadSlot = sandbox.hashparams.getParameter("LoadSlot");
                if (loadSlot != null && loadSlot !== $("#txtProgramName").val()) {
                    sandbox.ide.clean();

                    $("#sb_sel_trident_slot").val(loadSlot);

                    // let sandbox finish cleaning then load
                    setTimeout(function () {
                        sandbox.ide.loadSlot();
                    }, 250);
                }
                else {
                    var runSlot = sandbox.hashparams.getParameter("RunSlot");
                    if (runSlot != null && runSlot !== $("#txtProgramName").val()) {
                        sandbox.ide.clean();

                        $("#sb_sel_trident_slot").val(runSlot);

                        // let sandbox finish cleaning then run
                        setTimeout(function () {
                            sandbox.ide.loadSlot(true);
                        }, 250);
                    }
                    else {
                        var runSample = sandbox.hashparams.getParameter("RunApp");
                        if (runSample != null) {
                            sandbox.ide.clean();

                            setTimeout(function () {
                                sandbox.ide.runApp(runSample);
                            }, 200);
                        }
                        else {
                            var runProgram = sandbox.hashparams.getParameter("EditApp");

                            if (runProgram != null) {
                                sandbox.ide.clean();

                                setTimeout(function () {
                                    sandbox.ide.editApp(runProgram);
                                }, 200);
                            }
                        }
                    }

                }
            };
        }

        sandbox.dbInit(function () {
            sandbox.postInit();
        });

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
            if (document.URL.indexOf("file://") === -1) $("#UI_MainPlaceholder").empty();
        }

        if (sandbox.volatile.envTest(["IDE", "IDE WJS"])) {
            // Register Event Handler to warn if leaving page
            window.onbeforeunload = function (e) {
                // API_ClearOuput will call sandbox.events.clean() is the user has one defined.
                // will allow synchronous shutdown activities to complete, async activities may not complete (tridentdb)
                // local storage should be ok.
                sandbox.logger.clearLog();

                // Get Hash of current editor contents to compare with last 'load' or 'new
                // If they are different (user made changes) then warm them when they are leaving the page.
                var htmlHash = CryptoJS.SHA1(sandbox.volatile.editorMarkup.getValue()).toString();
                var scriptHash = CryptoJS.SHA1(sandbox.volatile.editorScript.getValue()).toString();

                if ((htmlHash !== sandbox.volatile.markupHash || scriptHash !== sandbox.volatile.scriptHash) && sandbox.settings.pendingChangesWarning === "true") {
                    return 'You have unsaved changes, are you sure you want to leave this page?';
                }
            };

        }

    },
    postInit: function () {
        if (sandbox.hashparams.getParameter("LoadSlot")) {
            if (sandbox.volatile.envTest(["IDE", "IDE WJS"])) {
                sandbox.ide.clean();

                $("#sb_sel_trident_slot").val(sandbox.hashparams.getParameter("LoadSlot"));

                // let sandbox finish cleaning then load
                setTimeout(function () {
                    sandbox.ide.loadSlot();
                }, 200);
            }

            return;
        }

        if (sandbox.hashparams.getParameter("RunSlot")) {
            if (sandbox.volatile.env === "IDE" || sandbox.volatile.env === "IDE WJS") {
                sandbox.ide.clean();

                //if (localrun != null) $("#sb_sel_trident_slot").val(localrun);
                $("#sb_sel_trident_slot").val(sandbox.hashparams.getParameter("RunSlot"));

                // let sandbox finish cleaning then run
                setTimeout(function () {
                    sandbox.ide.loadSlot(true);
                }, 200);
            }
            else {
                sandbox.ide.runSlot(sandbox.hashparams.getParameter("RunSlot"));
            }

            return;
        }

        if (sandbox.hashparams.getParameter("RunApp")) {
            if (sandbox.volatile.env === "IDE" || sandbox.volatile.env === "IDE WJS") {
                sandbox.ide.clean();
            }

            setTimeout(function () {
                sandbox.ide.runApp(sandbox.hashparams.getParameter("RunApp"));
            }, 200);

            return;
        }

        if (sandbox.hashparams.getParameter("EditApp")) {
            if (sandbox.volatile.env === "IDE" || sandbox.volatile.env === "IDE WJS") {
                sandbox.ide.clean();

                setTimeout(function () {
                    sandbox.ide.editApp(sandbox.hashparams.getParameter("EditApp"));
                }, 200);
            }

            return;
        }


        if (sandbox.settings.skipAutorun !== "true" && sandbox.hashparams.getParameter("SkipAutorun") !== 'true') {
            sandbox.ide.runAutorun();
        }

        // Sandbox Loaders : if no runslot/runapp then load SandboxLoader prog
        if (sandbox.volatile.env === "SBL" || sandbox.volatile.env === "SBL WJS") {
            if (!sandbox.hashparams.getParameter("RunSlot") && !sandbox.hashparams.getParameter("RunApp")) {
                sandbox.ide.runApp("SandboxLanding");
            }
        }
    }
};

//#endregion sandbox object

//	legacy API VARIABLES - will be removed at some point soon
//var VAR_UserFileValue = "";
//var VAR_WindowMode = 2;
//var VAR_TRIDENT_HOSTED = false;
//var VAR_TRIDENT_APPCACHED = false;
//var VAR_TRIDENT_ONLINE = sandbox.volatile.online;
//var VAR_TRIDENT_ENV_TYPE = function () { return sandbox.volatile.env; };
//var VAR_ForceOnlineSamples = true;

