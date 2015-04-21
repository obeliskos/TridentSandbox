{
  "progName": "HieroCryptes-Mobile",
  "htmlText": "<style>\nspan.dynatree-node a {\n  font-size: 18pt;\n}\n</style>\n<br/>\n<div id=\"dialogElement\" data-win-control=\"WinJS.UI.ContentDialog\" data-win-options=\"{\ntitle: 'Enter Password',\nprimaryCommandText: 'Accept',\nsecondaryCommandText: 'Cancel'\n}\">\n  <div id=\"divPassword\">\n      <input id=\"hfTaskId\" type=\"hidden\" />\n      <input id=\"txtDialogPassword\" type=\"password\" style=\"border:1px solid #000\"\n      \t onkeydown=\"if (event.keyCode == 13) $('.win-contentdialog-primarycommand').click()\"/>\n  </div>\n</div>\n\n<div id=\"divHeader\" align=\"center\" style=\"padding-top:14px; padding-bottom:14px; width:100%;\">\n    <div style=\"display: inline-block; padding:4px; color:#ff9; text-shadow: 0px 0px 9px rgba(0,0,0,0.75); border: 2px solid; border-radius: 5px; width:140px\">\n    <label style=\"font-family:Garamond, Sans; font-size:20pt;\">\n    <i style=\"color:#ada\" class=\"fa fa-sitemap\"></i>&nbsp;\n    <i style=\"color:#ada\" class=\"fa fa-key\"></i>&nbsp;\n    <i style=\"color:#ada\" class=\"fa fa-edit\"></i> \n    </label>\n    </div>&nbsp;\n\t<label style=\"text-shadow: 0px 0px 9px rgba(0,0,0,0.75); font-family:Garamond, Sans; font-size:24pt; color:#ff9;\">\n    Hierocryptes Mobile</label>\n    </div>\n\n<div id=\"divOuter\" style=\"display:none\">\n    <div id=\"createAppBar\" data-win-control=\"WinJS.UI.AppBar\" data-win-options=\"{sticky: true, placement: 'top'}\">\n        <button data-win-control=\"WinJS.UI.AppBarCommand\" data-win-options=\"{id:'cmdFullscreen',label:'Toggle Fullscreen',icon:'fullscreen',section:'selection',tooltip:'Toggle fullscreen'}\"></button>\n        <button data-win-control=\"WinJS.UI.AppBarCommand\" data-win-options=\"{id:'cmdSave',label:'Save',icon:'save',section:'selection',tooltip:'Save'}\"></button>\n        <hr data-win-control=\"WinJS.UI.AppBarCommand\" data-win-options=\"{type:'separator',section:'selection'}\" />\n        <button data-win-control=\"WinJS.UI.AppBarCommand\" data-win-options=\"{id:'cmdAddNode',label:'Add Node',icon:'add',section:'selection',tooltip:'Add new top-level node'}\"></button>\n        <button data-win-control=\"WinJS.UI.AppBarCommand\" data-win-options=\"{id:'cmdAddChild',label:'Add Child',icon:'add',section:'selection',tooltip:'Add child below selected node'}\"></button>\n        <button data-win-control=\"WinJS.UI.AppBarCommand\" data-win-options=\"{id:'cmdRenameNode',label:'Rename Node',icon:'tag',section:'selection',tooltip:'Rename the selected node', type:'flyout', flyout: select('#renameFlyout')}\"></button>\n        <button data-win-control=\"WinJS.UI.AppBarCommand\" data-win-options=\"{id:'cmdDelete',label:'Delete Node',icon:'delete',section:'selection',tooltip:'Delete Node'}\"></button>\n        <button data-win-control=\"WinJS.UI.AppBarCommand\" data-win-options=\"{id:'cmdAbout',label:'About...',icon:'help',section:'selection',tooltip:'About Hierocryptes Notepad'}\"></button>\n    </div>\n    <div id=\"renameFlyout\" data-win-control=\"WinJS.UI.Flyout\" aria-label=\"{Confirm purchase flyout}\">\n        <div>Enter new node name : <br/><input id=\"txtNodeRename\" style=\"width:120px\"></div>\n        <button id=\"dismissButton\" onclick=\"doRenameNode()\">Ok</button>\n    </div>\n\n<div class=\"box\">\n\n    <div id=\"dialogAbout\" data-win-control=\"WinJS.UI.ContentDialog\" data-win-options=\"{\n             title: 'About Hierocryptes Notepad',\n             primaryCommandText: 'Close'\n        }\">\n\t    \t<div align='center' style=\"display: inline-block; padding:4px; color:#494; width:160px\">\n    \t\t<label style=\"font-family:Garamond, Sans; font-size:20pt;\">\n    \t\t<i class=\"fa fa-sitemap\"></i>&nbsp;\n    \t\t<i class=\"fa fa-key\"></i>&nbsp;\n    \t\t<i class=\"fa fa-edit\"></i> \n    \t\t</label>\n    \t\t</div>&nbsp;\n    \t\t<p>App Version : <span id=\"spnVersion\"></span><br/>\n            TridentSandbox Version : <span id=\"spnTridentVersion\"></span></p>\n            <p><i>HieroCryptes Mobile</i> is a high dpi version of Hierocryptes Notepad, an encrypted, hierarchical notepad.&nbsp; It can run offline and it saves \n            your notepad in your browser's client storage (indexed db)... not on any server.&nbsp; You can also import and export \n            your notepad to an external, encrypted file for emailing or storing in the cloud.</p>\n\n            <p>This program was developed in, and is distributed as part of the <a href=\"https://github.com/obeliskos/TridentSandbox\" target=\"_blank\">TridentSandbox project</a>.</p>\n\n            <p>You can edit the source code of this program using the included <a href=\"TridentSandboxWJS.htm#EditApp=HieroCryptes-WJS\" target=\"_blank\">TridentSandbox IDE</a>.</p>\n        <div style=\"height: 50px; width: 1px;\"></div>\n    </div>\n</div>\n\n\n\n<div id=\"divMain\">\n    <table style='width:100%;background-color:#aaa;display:none'>\n        <tr style='background-color:#aaa'>\n            <td style='padding:5px; width:400px'>\n                <button style=\"height:34px\" onclick='addNode()' title='Add Node'><i class=\"fa fa-plus-circle\"></i> Node</button>\n                <button style=\"height:34px\" onclick='addChild()' title='Add Child Node'><i class=\"fa fa-plus-circle\"></i> Child</button>\n                <button style=\"height:34px\" onclick='renameNode()' title='Rename Node'><i class=\"fa fa-tag\"></i> Rename</button>\n                <button style=\"height:34px\" onclick='deleteNode()' title='Delete Node'><i class=\"fa fa-minus-circle\"></i> Delete</button>\n            </td>\n            <td>\n                <div id='divDbActions' style='display:inline'>\n                    <button style=\"height:34px\" id='btnSave' title='Save to Trident DB' onclick='saveTrident()'><i class=\"fa fa-floppy-o\"></i> Save TDB</button>&nbsp;\n                    <button style=\"height:34px\" title='Export / Save Locally' onclick='exportNote()'><i class=\"fa fa-download\"></i> Export</button>&nbsp;\n                    <button style=\"height:34px\" title='Import / Load Local File' onclick='importNote()'><i class=\"fa fa-arrow-up\"></i> Import</button>\n                </div>\n            </td>\n        </tr>\n    </table>\n\n    <table width='100%'>\n    <tr valign='top'>\n        <td style=\"min-width:200px\">\n            <div id=\"tree1\"></div>\n        </td>\n        <td>\n            <textarea id=\"txtNoteContent\" name=\"divContent\" style=\"width:100%; height:400px\"></textarea>\n        </td>\n    </tr>\n    </table>\n\n    <div id='divPassword' style='display:none'>\n    <i class=\"fa fa-key\"></i> Enter Password : \n    <input id='txtDialogPassword'  onKeyDown=\"if (event.keyCode==13) sandboxVars.dlgOkButton.focus()\" type='password'/>\n    </div>\n</div>\n</div>\n\n",
  "scriptText": "API_SetBackgroundColor(\"#334\");\n\nvar sbv = {\n    db : new loki('HieroCrypt Notepad'),\n    notes : null,\n    tmce : null,\n    tree : null,\n    isImport : false,\n    lastsel : null,\n    newsel: null,\n    cachedPass: null, \n    ver : \"1.0\"\n}\n\n$(\"#spnVersion\").text(sbv.ver);\n$(\"#spnTridentVersion\").text(VAR_TRIDENT_VERSION);\n\nfunction EVT_CleanSandbox() {\n    tinymce.remove();\n    delete sbv.db;\n    delete sbv.tmce;\n    delete sbv.isImport;\n    sbv.cachedPass = \"asldfj\";\n    delete sbv.cachedPass;\n    delete sbv.tree;\n    \n    EVT_CleanSandbox = null;\n}\n\nfunction EVT_WindowResize() {\n    var resizeHeight = 350;\n    var hdrHeight = $(\"#divHeader\").height();\n    \n    switch (VAR_TRIDENT_ENV_TYPE) {\n        case \"IDE\" : resizeHeight = $(window).height() - 520; break;\n        case \"IDE WJS\" : resizeHeight = $(window).height() - 520; $(\"button\").css(\"min-width\", \"0px\"); break;\n        case \"SBL\" : resizeHeight = $(window).height() - 230; break;\n        case \"SBL WJS\" : resizeHeight = $(window).height() - 180 - hdrHeight; $(\"button\").css(\"min-width\", \"0px\"); break;\n        case \"STANDALONE\" : resizeHeight = $(window).height() - 340; break;\n        default : break;\n    }\n    \n\ttinyMCE.get('txtNoteContent').theme.resizeTo(\"400px\", resizeHeight);\n    $(\"#tree1\").css(\"height\", resizeHeight+109);\n}\n\nfunction showDiv(divIndex) {\n\t$(\"#divMain\").hide();\n\t$(\"#divAbout\").hide();\n\n\tswitch(divIndex) {\n        case 1: $(\"#divMain\").show(); break;\n        case 2: $(\"#divAbout\").show(); break;\n    }\n}\n\nfunction initTree() {\n\t//var treeData = [{title: \"Notes\", key: 21 }];\n\n    sbv.tree = $(\"#tree1\").dynatree({\n        checkbox: false,\n        // Override class name for checkbox icon:\n        classNames: {checkbox: \"dynatree-radio\"},\n        selectMode: 1,\n        children: [], //treeData,\n        onActivate: function(node) {\n        \t//alertify.log(\"activate\");\n\t\t\t// switching nodes, save old node first\n\t\t\tif (sbv.lastsel != null) {\n            \tvar htmlText = tinyMCE.get('txtNoteContent').getContent(); \t\n                \n                var prevNote = sbv.notes.get(parseInt(sbv.lastsel));\n                prevNote.html = htmlText;\n            }\n            \n            var note = sbv.notes.get(parseInt(node.data.key));\n            tinyMCE.get('txtNoteContent').setContent(note.html);\n            \n            sbv.lastsel = note.$loki.toString();\n        },\n        onSelect: function(select, node) {\n        },\n        onDblClick: function(node, event) {\n            //node.toggleSelect();\n        },\n        onKeydown: function(node, event) {\n            if( event.which == 32 ) {\n                node.toggleSelect();\n                return false;\n            }\n        },\n    });\n\n\tsbv.tree = $(\"#tree1\").dynatree(\"getTree\");\n}\n\nfunction initMCE() {\n    sbv.tmce = tinymce.init({\n        setup : function(ed)\n        {\n            ed.on('init', function() \n            {\n                this.getDoc().body.style.fontSize = '32px';\n                this.getDoc().body.style.fontFamily = 'Helvetica';\n\n                \n            });\n        },\n        selector: \"#txtNoteContent\",\n        theme: \"modern\",\n        plugins: [\n            \"advlist autolink lists link image charmap print preview hr anchor pagebreak\",\n            \"searchreplace wordcount visualblocks visualchars code fullscreen\",\n            \"insertdatetime media nonbreaking save table contextmenu directionality\",\n            \"emoticons template paste textcolor moxiemanager\"\n        ],\n        toolbar1: \"undo redo styleselect bold italic underline alignleft aligncenter bullist numlist outdent indent forecolor fullscreen\",\n        image_advtab: true,\n        toolbar_items_size : 'large'\n    });\n}\n\ninitMCE();\nsetTimeout(function() {\n\tinitProgram();\n}, 500);\n\nfunction initProgram() {\n\n\tinitTree();\n    \n\tsetTimeout(function() { \n    \t$(\"#divOuter\").show();\n    \tEVT_WindowResize(); \n    }, 200);\n\n    if (!window.indexedDB) {\n        $(\"#btnSave\").hide();\n    }\n\n\t// if running local filesystem\n\tif (!indexedDB) {\n\t\tsbv.notes = sbv.db.addCollection('notes'); \n\t\tvar note = sbv.notes.insert({ name:'Default', parentId : null, html : 'Welcome to <i>HieroCryptes</i> Notepad' });\n\t\tRefreshTree();\n        \n    \treturn;\n    }\n    \n\n    // Using new Trident API so i can (optionally) persist to network service of mine\n\tVAR_TRIDENT_API.GetAppKey('HieroCryptes Notepad', 'NotepadData', function (result) {\n    \tif (result == null || result.id == 0) {\n        \t// Nothing saved yet, initialize a new loki db with single note\n            sbv.notes = sbv.db.addCollection('notes'); \n            var note = sbv.notes.insert({ name:'Default', parentId : null, html : 'Welcome to <i>HieroCryptes</i> Notepad' });\n\t\t\tRefreshTree();\n        }\n        else {\n\t\t\tvar contentDialog = document.querySelector(\"#dialogElement\").winControl; //document.querySelector(\".win-contentdialog\").winControl;\n\t\t\tcontentDialog.show().then(function (info) {\n              if (info.reason == \"primary\") {\n                  var pass = $(\"#txtDialogPassword\").val();\n                  // using multipass decryption on notepad saved in TridentDB                \n                  var decresult = multiPassDec(result.val, pass)\n\n                  sbv.db.loadJSON(decresult);\n\n                  // update our shortcut reference to collection\n                  sbv.notes = sbv.db.getCollection(\"notes\");\n\n                  RefreshTree();\n              }\n            });\n        }\n\t});\n}\n\nfunction addNode() {\n\talertify.prompt(\"Enter note name\", function (e, str) {\n\t\tif (e) {\n\t\t\tvar note = sbv.notes.insert({ name:str, parentId : null, html : 'New note' });\n\t\t\tsbv.tree.options.children.push({ title: str, key: note.$loki.toString()});\n            \n            sbv.newsel = note.$loki.toString();\n            \n\t\t\tRefreshTree();\n\t\t} \n\t}, \"\");\n}\n\nfunction addChild() {\n\tif (sbv.lastsel == null) {\n    \talertify.log(\"Select a node first\");\n        return;\n    }\n    \n\tvar currNode = sbv.tree.getNodeByKey(sbv.lastsel);\n    var currNote = sbv.notes.get(parseInt(currNode.data.key));\n    \n\talertify.prompt(\"Enter note name\", function (e, str) {\n\t\tif (e) {\n\t\t\tvar note = sbv.notes.insert({ name:str, parentId : currNote.$loki, html : 'New child note' });\n\t\t\tcurrNode.addChild({\n\t\t\t\ttitle: str,\n\t\t\t\tkey: note.$loki\n\t\t\t});\n\t\t\tcurrNode.expand(true);\n            \n\t\t\tsbv.tree.activateKey(note.$loki.toString());\n\t\t} \n\t}, \"\");\n    \n}\n\nfunction renameNode() {\n\tif (sbv.lastsel == null) {\n    \talertify.log(\"Select a node first\");\n        return;\n    }\n    \n\tvar currNode = sbv.tree.getNodeByKey(sbv.lastsel);\n    var currNote = sbv.notes.get(parseInt(currNode.data.key));\n    \n\talertify.prompt(\"Enter new note name\", function (e, str) {\n\t\tif (e) {\n\t\t\tcurrNote.name = str;\n            \n\t\t\tcurrNode.data.title = str;\n            currNode.render();\n\t\t} \n\t}, currNote.name);\n}\n\nfunction doRenameNode() {\n\tif (sbv.lastsel == null) {\n    \talertify.log(\"Select a node first\");\n        return;\n    }\n    \n\tsbv.appBar.hide();\n    \n\tvar currNode = sbv.tree.getNodeByKey(sbv.lastsel);\n    var currNote = sbv.notes.get(parseInt(currNode.data.key));\n    var newName = $(\"#txtNodeRename\").val();\n    \n\tcurrNote.name = newName;\n\tcurrNode.data.title = newName;\n    currNode.render();\n    \n    document.getElementById(\"renameFlyout\").winControl.hide();\n    \n}\n\nfunction deleteBranch(note, depth) {\n\tif (depth > 10) return;\n\n\tvar childNodes = sbv.notes.find({'parentId':{ '$eq' : note.$loki }});\n    \n\tfor(var idx = 0; idx < childNodes.length; idx++) {\n\t\tdeleteBranch(childNodes[idx], depth+1);\n\t\tsbv.notes.remove(childNodes[idx]);\n\t}\n    \n\tsbv.notes.remove(note);\n}\n\nfunction deleteNode() {\n\tif (sbv.lastsel == null) {\n    \talertify.log(\"Select a node first\");\n        return;\n    }\n\n\tvar currNode = sbv.tree.getNodeByKey(sbv.lastsel);\n    \n\talertify.confirm(\"Are you sure you want to delete branch \" + currNode.data.title, function (e) {\n\t\tif (e) {\n    \t\tvar currNote = sbv.notes.get(parseInt(currNode.data.key));\n    \n    \t\tdeleteBranch(currNote, 0);\n    \n    \t\tsbv.lastsel = null;\n    \n    \t\tRefreshTree();\n\t\t} \n\t});\n}\n\nfunction addBranch(nodeId, depth) {\n\t// prevent bad or user hacked data from causing infinite loop\n\tif (depth > 10) return;\n\n\tvar currNode = sbv.tree.getNodeByKey(nodeId.toString());\n    \n\tvar childNodes = sbv.notes.find({'parentId':{ '$eq' : nodeId }});\n    for(var idx = 0; idx < childNodes.length; idx++) {\n    \t// opting to use dynamic add for all non-root nodes\n        currNode.addChild({\n    \t\ttitle: childNodes[idx].name,\n            key: childNodes[idx].$loki.toString()\n\t\t});\n\n\t\tcurrNode.expand(true);\n        \n    \taddBranch(childNodes[idx].$loki, depth+1);\n    }\n}\n\nfunction RefreshTree() {\n\tvar rootNodes = sbv.notes.find({'parentId':{ '$eq' : null }});\n    //rootNodes = rootNodes.slice(0);\n    rootNodes = rootNodes.sort(function (x, y) { \n    \t\tif (x.$loki > y.$loki) return 1;\n    \t\tif (x.$loki < y.$loki) return -1;\n    \t\treturn 0;\n    \t});\n \n    sbv.tree.options.children = [];\n    \n    for(var idx = 0; idx < rootNodes.length; idx++) {\n    \tsbv.tree.options.children.push({ title: rootNodes[idx].name, key: rootNodes[idx].$loki});\n    }\n    \n    sbv.tree.reload();\n    \n    for(var idx = 0; idx < rootNodes.length; idx++) {\n    \taddBranch(rootNodes[idx].$loki, 0);\n    }\n    \n    if (sbv.newsel != null) {\n    \tsbv.tree.activateKey(sbv.newsel);\n        sbv.newsel = null;\n    } \n    else {\n\t    if (sbv.lastsel != null) {\n    \t    sbv.tree.activateKey(sbv.lastsel);\n    \t}\n    \telse {\n\t    \tif (rootNodes.length > 0) sbv.tree.activateKey(rootNodes[0].$loki.toString());\n\t    }\n    }\n    \n}\n\n// Multiple Pass Encryption\nfunction multiPassEnc(src, origPass) {\n\tvar revpass = origPass.split(\"\").reverse().join(\"\");\n\n\tvar enc1 = CryptoJS.AES.encrypt(src, origPass).toString();\n    var enc2 = enc1.split(\"\").reverse().join(\"\");    enc1 = null;\n\tvar enc3 = CryptoJS.AES.encrypt(enc2, revpass).toString();    enc2 = null;\n    var enc4 = enc3.split(\"\").reverse().join(\"\"); \n    \n    return enc4;\n}\n\n// Multiple Pass Decryption\nfunction multiPassDec(src, origPass) {\n\tvar revpass = origPass.split(\"\").reverse().join(\"\");\n                \n\t// Two passes\n    var dec1 = src.split(\"\").reverse().join(\"\");\n\tvar dec2 = CryptoJS.AES.decrypt(dec1, revpass).toString(CryptoJS.enc.Utf8); dec1=null;\n    var dec3 = dec2.split(\"\").reverse().join(\"\");  dec2=null;\n\tvar dec4 = CryptoJS.AES.decrypt(dec3, origPass).toString(CryptoJS.enc.Utf8); \n    \n    return dec4;\n}\n\nfunction saveTridentAction() \n{\n    var contentDialog = document.querySelector(\"#dialogElement\").winControl; //document.querySelector(\".win-contentdialog\").winControl;\n    contentDialog.show().then(function (info) {\n    \tif (info.reason == \"primary\") saveTrident();\n    });\n}\n\nfunction saveTrident() {\n\t// save any changes pending to selected node first\n\tif (sbv.lastsel != null) {\n\t\tvar htmlText = tinyMCE.get('txtNoteContent').getContent(); \t\n                \n\t\tvar prevNote = sbv.notes.get(parseInt(sbv.lastsel));\n\t\tprevNote.html = htmlText;\n\t}\n\n\tif (sbv.cachedPass == null) {\n        var contentDialog = document.querySelector(\"#dialogElement\").winControl; //document.querySelector(\".win-contentdialog\").winControl;\n        contentDialog.show().then(function (info) {\n            if (info.reason == \"primary\") {\n            \tvar pass = $(\"#txtDialogPassword\").val();\n                if (pass.length < 6) {\n                    alertify.error(\"Password must be at least six characters\");\n                    return;\n                }\n\n                sbv.cachedPass = pass;\n\n                var result = multiPassEnc(JSON.stringify(sbv.db), pass);\n\n                // Using new Trident API so i can (optionally) persist to network service of mine\n                VAR_TRIDENT_API.SetAppKey('HieroCryptes Notepad', \"NotepadData\", result, function(result) {\n                    if (result.success) {\n                        alertify.success(\"saved\");\n                    }\n                    else {\n                        alertify.error(\"error saving notepad\");\n                    }\n                });\n            }\n        });\n    }\n    else {\n\t\tvar result = multiPassEnc(JSON.stringify(sbv.db), sbv.cachedPass);\n\n            \n        // Using new Trident API so i can (optionally) persist to network service of mine\n   \t\tVAR_TRIDENT_API.SetAppKey('HieroCryptes Notepad', \"NotepadData\", result, function(result) {\n                if (result.success) {\n                    alertify.success(\"saved\");\n                }\n                else {\n                    alertify.error(\"error saving notepad\");\n                }\n        });\n    }\n}\n\n//\n// IMPORT EXPORT FUNCTIONS\n//\n\nfunction exportNote() {\n\tAPI_ShowPasswordDialog(function(pass) {\n\t\tif (pass.length < 6) {\n\t\t\talertify.alert(\"Password must be at least six characters\");\n\t\t\treturn;\n\t\t}\n    \n \t\tsbv.cachedPass = pass;\n    \t\t\n\t\tvar result = multiPassEnc(JSON.stringify(sbv.db), pass);\n\n\t\t// user can set their own filename in the save dialog\n\t\tAPI_SaveTextFile('Notepad.hcn', result)\t\n\t});\n}\n\nfunction importNote() {\n\tAPI_ShowLoad();\n}\n\nfunction EVT_UserLoadCallback(filestring, filename) {\n\tAPI_HideUserLoader();\n    \n\tAPI_ShowPasswordDialog(function(pass) {\n    \tsbv.cachedPass = pass;\n        \n\t\tvar result = multiPassDec(filestring, pass)\n\n\t\tsbv.db.loadJSON(result);\n\n\t\t// update our shortcut reference to collection\n\t\tsbv.notes = sbv.db.getCollection(\"notes\");\n                \n        sbv.lastsel = null;\n        \n\t\tRefreshTree();\n\t});\n}\n\nfunction log(msg) {\n    alertify.log(msg);\n}\n\n// Command button functions\nfunction doClickAddNode() {\n    addNode()\n}\n\nfunction doClickAddChild() {\n\tsbv.appBar.hide();\n    addChild();\n}\n\nfunction doClickRename() {\n\tif (sbv.lastsel == null) {\n    \talertify.log(\"Select a node first\");\n        return;\n    }\n    \n\tvar currNode = sbv.tree.getNodeByKey(sbv.lastsel);\n    var currNote = sbv.notes.get(parseInt(currNode.data.key));\n    \n    $(\"#txtNodeRename\").val(currNote.name);\n}\n\nfunction doClickDelete() {\n\tsbv.appBar.hide();\n    deleteNode();\n}\n\nfunction doClickSave() {\n\tsbv.appBar.hide();\n    saveTrident();\n}\n\nfunction doClickImport() {\n\tsbv.appBar.hide();\n    importNote();\n}\n\nfunction doClickExport() {\n\tsbv.appBar.hide();\n    exportNote();\n}\n\nfunction doClickAbout() {\n\tsbv.appBar.hide();\n    var contentDialog = document.getElementById(\"dialogAbout\").winControl;\n    contentDialog.show();\n}\n\nfunction doFullscreen() {\n\tsbv.appBar.hide();\n\tAPI_UserFullToggle();\n}\n\nWinJS.UI.processAll().done(function () {\n    sbv.appBar = document.getElementById(\"createAppBar\").winControl;\n    sbv.appBar.getCommandById(\"cmdAddNode\").addEventListener(\"click\", doClickAddNode, false);\n    sbv.appBar.getCommandById(\"cmdAddChild\").addEventListener(\"click\", doClickAddChild, false);\n    sbv.appBar.getCommandById(\"cmdRenameNode\").addEventListener(\"click\", doClickRename, false);\n    sbv.appBar.getCommandById(\"cmdDelete\").addEventListener(\"click\", doClickDelete, false);\n    sbv.appBar.getCommandById(\"cmdAbout\").addEventListener(\"click\", doClickAbout, false);\n    sbv.appBar.getCommandById(\"cmdSave\").addEventListener(\"click\", doClickSave, false);\n    sbv.appBar.getCommandById(\"cmdFullscreen\").addEventListener(\"click\", doFullscreen, false);\n    \n    if (!VAR_TRIDENT_DB) sbv.appBar.hideCommands([\"cmdSave\"]);\n});\n\n"
}