{
  "progName": "Trident Backup Restore",
  "htmlText": "<style>\n\t.container {\n    \tborder: 2px solid #ccc;\n        width: 600px;\n        height: 200px;\n        overflow-y: scroll; \n\t}\n    \n    .largecheck {\n    }\n</style>\n\n<ul class=\"tnavlist\">\n<li class=\"tnavli\"><a class=\"tnava\" onclick=\"showDiv(1);\" href=\"javascript:void(0)\"><i class=\"fa fa-suitcase\"></i> Backup</a></li>\n<li class=\"tnavli\"><a class=\"tnava\" onclick=\"showDiv(2);\" href=\"javascript:void(0)\"><i class=\"fa fa-medkit\"></i> Restore</a></li>\n<li class=\"tnavli\"><a class=\"tnava\" onclick=\"showDiv(3);\" href=\"javascript:void(0)\"><i class=\"fa fa-info-circle\"></i> About</a></li>\n</ul>\n\n<div id=\"divBackup\">\n\t<h3>TridentDB Backup</h3>\n    \n    Filename to save backup as : <br/>\n    <input id=\"txtBackupName\" value=\"TridentDB.backup\"/><br/><br/>\n    \n    Select the App/Key(s) you want to include in the backup : <br/>\n    <div class=\"container\" id=\"divFiles\">\n    </div><br/>\n\t<button class=\"minimal\" onclick=\"doBackup()\">Backup</button> \n</div>\n\n<div id=\"divRestore\" style=\"display:none\">\n\t<h3>TridentDB Restore</h3>\n    \n    <p>\n    Choosing this will invoke the API_RestoreDatabase and take you to the Log Tab to pick the \n    restore file.  In the future it may allow selective import.\n    </p>\n    \n    <button class=\"minimal\" onclick=\"doRestore()\">Pick Restore File</button>\n</div>\n\n<div id=\"divAbout\" style=\"display:none\">\n\t<h3>About TridentDB Backup and Restore Utility</h3>\n    \n    <p>\n    This Utility allows you to do a selective backup of your TridentDB contents and restore \n    them at a later date or on different machine.  \n    </p>\n    <p>\n    In the current Hosted/AppCache Trident Sandbox environment, the TridentDB can be used \n    for a variety of things such as Save Slots, Unit Libraries, program data, files, etc.  \n    As programs 'spread out' into the TridentDB they become entrenched within their own \n    sandbox storage.  Unless you have roaming profiles this storage is specific to your \n    machine.  This utility allows you to backup all they keys you are interested in to a \n    single file, to be restored later.  \n    </p>\n</div>",
  "scriptText": "// Recommended practice is to place variables in this object and then delete in cleanup\nvar sbv = {\n\ttotalSize : null,\n    filesDiv : document.getElementById(\"divFiles\")\n}\n\nfunction EVT_CleanSandbox()\n{\n\tdelete sbv.totalSize;\n    delete sbv.filesDiv;\n}\n\nfunction showAllKeys() {\n\t// clear old contents\n\t$(\"#divFiles\").html(\"\");\n    \n\tAPI_GetCursor(function(e) {\n\t\tvar cursor = e.target.result;\n\t\tif(cursor) {\n\t\t\tvar currObject = cursor.value;\n\t\t\t\t  \n            var checkbox = document.createElement('input');\n\t\t\tcheckbox.type = \"checkbox\";\n            checkbox.className = \"tfilechk\";\n\t\t\tcheckbox.name = \"file\" + currObject.id;\n\t\t\t//checkbox.value = \"value\";\n\t\t\tcheckbox.id = \"file\" + currObject.id;\n\n\t\t\tvar label = document.createElement('label')\n\t\t\tlabel.htmlFor = \"file\" + currObject.id;\n            label.style.fontSize = \"20px\";\n\n\t\t\tlabel.appendChild(document.createTextNode(currObject.app + \";\" + currObject.key));\n            label.click = function() {\n            };\n\n\t\t\tsbv.filesDiv.appendChild(checkbox);\n\t\t\tsbv.filesDiv.appendChild(label);\n            sbv.filesDiv.appendChild(document.createElement('br'));\n\t\t\t\t  \n\t\t\tvar keySize = currObject.val.length;\n\t\t\tsbv.totalSize += keySize;\n\t\t\t\t\t\n\t\t\tcursor.continue();\n\t\t}\n\t});\n}\n\nfunction showDiv(divId) {\n\t$(\"#divBackup\").hide();\n\t$(\"#divRestore\").hide();\n    $(\"#divAbout\").hide();\n    \n\tswitch (divId) {\n    \tcase 1 : $(\"#divBackup\").show(); break;\n        case 2 : $(\"#divRestore\").show(); break;\n        case 3 : $(\"#divAbout\").show(); break;\n    }\n}\n\nfunction doBackup() {\n\tvar selectedFiles = $(\".tfilechk:checked\");\n    \n    var keyArray = [];\n    \n    for(var i=0; i<selectedFiles.length; i++) {\n    \tvar strId = selectedFiles[i].name;\n        strId = strId.replace(\"file\", \"\");\n       \tvar objId = parseInt(strId);\n\t\tvar isLast = (i==(selectedFiles.length-1));\n        \n        // Added optional data param to this API call so we could \n        // pass extra data to process in the async callback\n        // We are passing boolean isLast to determine whether we are done\n        // and can go ahead and save\n        API_GetIndexedAppKeyById(objId, function(e, isLastItem) {\n\t\t\tvar res = e.target.result;\n      \t\tkeyArray.push(res);\n\n\t\t\t// If this is the last item to be processed then trigger file download \n            if (isLastItem) {\n              var filename = $(\"#txtBackupName\").val();\n\n              API_SaveTextFile(filename, JSON.stringify(keyArray));\n            }\n        }, isLast);\n    }\n}\n\nfunction doRestore() {\n\tAPI_SetActiveTab(2);\n\tAPI_Restore_TridentDB();\n}\n\nshowAllKeys();"
}