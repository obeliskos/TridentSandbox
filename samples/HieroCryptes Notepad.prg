{
  "progName": "HieroCryptes Notepad",
  "htmlText": "<ul class=\"tnavlist\">\n<li class=\"tnavli\"><a class=\"tnava\" onclick=\"showDiv(1);\" href=\"javascript:void(0)\"><i class=\"fa fa-pencil-square-o\"></i> HieroCryptes Notepad</a></li>\n<li class=\"tnavli\"><a class=\"tnava\" onclick=\"showDiv(2);\" href=\"javascript:void(0)\"><i class=\"fa fa-info-circle\"></i> About</a></li>\n</ul>\n<div id=\"divMain\">\n    <table style='width:100%;background-color:#aaa'>\n        <tr style='background-color:#aaa'>\n            <td style='padding:5px; width:400px'>\n                <button style=\"height:34px\" onclick='addNode()' title='Add Node'><i class=\"fa fa-plus-circle\"></i> Node</button>\n                <button style=\"height:34px\" onclick='addChild()' title='Add Child Node'><i class=\"fa fa-plus-circle\"></i> Child</button>\n                <button style=\"height:34px\" onclick='renameNode()' title='Rename Node'><i class=\"fa fa-tag\"></i> Rename</button>\n                <button style=\"height:34px\" onclick='deleteNode()' title='Delete Node'><i class=\"fa fa-minus-circle\"></i> Delete</button>\n            </td>\n            <td>\n                <div id='divDbActions' style='display:inline'>\n                    <button style=\"height:34px\" id='btnSave' title='Save to Trident DB' onclick='saveTrident()'><i class=\"fa fa-floppy-o\"></i> Save TDB</button>&nbsp;\n                    <button style=\"height:34px\" title='Export / Save Locally' onclick='exportNote()'><i class=\"fa fa-download\"></i> Export</button>&nbsp;\n                    <button style=\"height:34px\" title='Import / Load Local File' onclick='importNote()'><i class=\"fa fa-arrow-up\"></i> Import</button>\n                </div>\n            </td>\n        </tr>\n    </table>\n\n    <table width='100%'>\n    <tr valign='top'>\n        <td style=\"min-width:200px\">\n            <div id=\"tree1\"></div>\n        </td>\n        <td>\n            <textarea id=\"txtNoteContent\" name=\"divContent\" style=\"width:100%; height:400px\"></textarea>\n        </td>\n    </tr>\n    </table>\n\n    <div id='divPassword' style='display:none'>\n    <i class=\"fa fa-key\"></i> Enter Password : \n    <input id='txtDialogPassword'  onKeyDown=\"if (event.keyCode==13) sandboxVars.dlgOkButton.focus()\" type='password'/>\n    </div>\n</div>\n\n<div id=\"divAbout\" style=\"display:none\">\n<h3>About HieroCryptes Notepad</h3>\n<p><i>HieroCryptes Notepad</i> is an encrypted, hierarchical notepad.&nbsp; It supports both FileAPI and \nTridentDB so it will work in both hosted and non-hosted Trident Sandbox installations.</p>\n\n<p>When running hosted, this program supports one saved 'tree', but that tree is hierarchical \nso you should be able to grow it to accomodate all of your notes.  This approach was chosen \nfor simplicity... if i find i need the versatility of multiple trees stored in the TridentDB, I \nmay support multiple 'notepads' in the future.</p>\n\n<p>When using import/export functionality (either when running locally or hosted), you can \nsave and import many different trees, each with their own unique password.</p>\n\n</div>\n",
  "scriptText": "var sbv = {\n    db : new loki('HieroCrypt Notepad'),\n    notes : null,\n    tmce : null,\n    tree : null,\n    isImport : false,\n    lastsel : null,\n    newsel: null,\n    cachedPass: null\n}\n\nfunction EVT_CleanSandbox() {\n    tinymce.remove();\n    delete sbv.db;\n    delete sbv.tmce;\n    delete sbv.isImport;\n    sbv.cachedPass = \"asldfj\";\n    delete sbv.cachedPass;\n    delete sbv.tree;\n    \n    EVT_CleanSandbox = null;\n}\n\nfunction EVT_WindowResize() {\n    var resizeHeight = 350;\n    switch (VAR_TRIDENT_ENV_TYPE) {\n        case \"IDE\" : resizeHeight = $(window).height() - 530; break;\n        case \"IDE WJS\" : resizeHeight = $(window).height() - 530; $(\"button\").css(\"min-width\", \"0px\"); break;\n        case \"SBL\" : resizeHeight = $(window).height() - 240; break;\n        case \"SBL WJS\" : resizeHeight = $(window).height() - 240; $(\"button\").css(\"min-width\", \"0px\"); break;\n        case \"STANDALONE\" : resizeHeight = $(window).height() - 350; break;\n        default : break;\n    }\n    \n\ttinyMCE.get('txtNoteContent').theme.resizeTo(\"400px\", resizeHeight);\n}\n\nfunction showDiv(divIndex) {\n\t$(\"#divMain\").hide();\n\t$(\"#divAbout\").hide();\n\n\tswitch(divIndex) {\n        case 1: $(\"#divMain\").show(); break;\n        case 2: $(\"#divAbout\").show(); break;\n    }\n}\n\nfunction initTree() {\n\t//var treeData = [{title: \"Notes\", key: 21 }];\n\n    sbv.tree = $(\"#tree1\").dynatree({\n        checkbox: false,\n        // Override class name for checkbox icon:\n        classNames: {checkbox: \"dynatree-radio\"},\n        selectMode: 1,\n        children: [], //treeData,\n        onActivate: function(node) {\n        \t//alertify.log(\"activate\");\n\t\t\t// switching nodes, save old node first\n\t\t\tif (sbv.lastsel != null) {\n            \tvar htmlText = tinyMCE.get('txtNoteContent').getContent(); \t\n                \n                var prevNote = sbv.notes.get(parseInt(sbv.lastsel));\n                prevNote.html = htmlText;\n            }\n            \n            var note = sbv.notes.get(parseInt(node.data.key));\n            tinyMCE.get('txtNoteContent').setContent(note.html);\n            \n            sbv.lastsel = note.$loki.toString();\n        },\n        onSelect: function(select, node) {\n        },\n        onDblClick: function(node, event) {\n            //node.toggleSelect();\n        },\n        onKeydown: function(node, event) {\n            if( event.which == 32 ) {\n                node.toggleSelect();\n                return false;\n            }\n        },\n    });\n\n\tsbv.tree = $(\"#tree1\").dynatree(\"getTree\");\n}\n\nfunction initMCE() {\n    sbv.tmce = tinymce.init({\n        selector: \"#txtNoteContent\",\n        theme: \"modern\",\n        plugins: [\n            \"advlist autolink lists link image charmap print preview hr anchor pagebreak\",\n            \"searchreplace wordcount visualblocks visualchars code fullscreen\",\n            \"insertdatetime media nonbreaking save table contextmenu directionality\",\n            \"emoticons template paste textcolor moxiemanager\"\n        ],\n        toolbar1: \"code searchreplace undo redo | styleselect | bold italic underline strikethrough | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | link image | print preview | forecolor backcolor emoticons | fullscreen\",\n        image_advtab: true\n\n    });\n}\n\ninitMCE();\nsetTimeout(function() {\n\tinitProgram();\n}, 500);\n\nfunction initProgram() {\n\n\tinitTree();\n    \n\tsetTimeout(function() { \n    \tEVT_WindowResize(); \n    }, 200);\n\n    if (!window.indexedDB) {\n        $(\"#btnSave\").hide();\n    }\n\n\t// if running local filesystem\n\tif (!indexedDB) {\n\t\tsbv.notes = sbv.db.addCollection('notes'); \n\t\tvar note = sbv.notes.insert({ name:'Default', parentId : null, html : 'Welcome to <i>HieroCryptes</i> Notepad' });\n\t\tRefreshTree();\n        \n    \treturn;\n    }\n    \n\n    // Using new Trident API so i can (optionally) persist to network service of mine\n\tVAR_TRIDENT_API.GetAppKey('HieroCryptes Notepad', 'NotepadData', function (result) {\n    \tif (result == null || result.id == 0) {\n        \t// Nothing saved yet, initialize a new loki db with single note\n            sbv.notes = sbv.db.addCollection('notes'); \n            var note = sbv.notes.insert({ name:'Default', parentId : null, html : 'Welcome to <i>HieroCryptes</i> Notepad' });\n\t\t\tRefreshTree();\n        }\n        else {\n\t\t\tAPI_ShowPasswordDialog(function(pass) {\n\t\t\t\t// using multipass decryption on notepad saved in TridentDB                \n\t\t\t\tvar decresult = multiPassDec(result.val, pass)\n                \n\t\t\t\tsbv.db.loadJSON(decresult);\n\n\t\t\t\t// update our shortcut reference to collection\n\t\t\t\tsbv.notes = sbv.db.getCollection(\"notes\");\n                \n\t\t\t\tRefreshTree();\n\t\t\t});\n        }\n\t});\n}\n\nfunction addNode() {\n\talertify.prompt(\"Enter note name\", function (e, str) {\n\t\tif (e) {\n\t\t\tvar note = sbv.notes.insert({ name:str, parentId : null, html : 'New note' });\n\t\t\tsbv.tree.options.children.push({ title: str, key: note.$loki.toString()});\n            \n            sbv.newsel = note.$loki.toString();\n            \n\t\t\tRefreshTree();\n\t\t} \n\t}, \"\");\n}\n\nfunction addChild() {\n\tif (sbv.lastsel == null) {\n    \talertify.log(\"Select a node first\");\n        return;\n    }\n    \n\tvar currNode = sbv.tree.getNodeByKey(sbv.lastsel);\n    var currNote = sbv.notes.get(parseInt(currNode.data.key));\n    \n\talertify.prompt(\"Enter note name\", function (e, str) {\n\t\tif (e) {\n\t\t\tvar note = sbv.notes.insert({ name:str, parentId : currNote.$loki, html : 'New child note' });\n\t\t\tcurrNode.addChild({\n\t\t\t\ttitle: str,\n\t\t\t\tkey: note.$loki\n\t\t\t});\n\t\t\tcurrNode.expand(true);\n            \n\t\t\tsbv.tree.activateKey(note.$loki.toString());\n\t\t} \n\t}, \"\");\n    \n}\n\nfunction renameNode() {\n\tif (sbv.lastsel == null) {\n    \talertify.log(\"Select a node first\");\n        return;\n    }\n    \n\tvar currNode = sbv.tree.getNodeByKey(sbv.lastsel);\n    var currNote = sbv.notes.get(parseInt(currNode.data.key));\n    \n\talertify.prompt(\"Enter new note name\", function (e, str) {\n\t\tif (e) {\n\t\t\tcurrNote.name = str;\n            \n\t\t\tcurrNode.data.title = str;\n            currNode.render();\n\t\t} \n\t}, currNote.name);\n}\n\nfunction deleteBranch(note, depth) {\n\tif (depth > 10) return;\n\n\tvar childNodes = sbv.notes.find({'parentId':{ '$eq' : note.$loki }});\n    \n\tfor(var idx = 0; idx < childNodes.length; idx++) {\n\t\tdeleteBranch(childNodes[idx], depth+1);\n\t\tsbv.notes.remove(childNodes[idx]);\n\t}\n    \n\tsbv.notes.remove(note);\n}\n\nfunction deleteNode() {\n\tif (sbv.lastsel == null) {\n    \talertify.log(\"Select a node first\");\n        return;\n    }\n\n\tvar currNode = sbv.tree.getNodeByKey(sbv.lastsel);\n    \n\talertify.confirm(\"Are you sure you want to delete branch \" + currNode.data.title, function (e) {\n\t\tif (e) {\n    \t\tvar currNote = sbv.notes.get(parseInt(currNode.data.key));\n    \n    \t\tdeleteBranch(currNote, 0);\n    \n    \t\tsbv.lastsel = null;\n    \n    \t\tRefreshTree();\n\t\t} \n\t});\n}\n\nfunction addBranch(nodeId, depth) {\n\t// prevent bad or user hacked data from causing infinite loop\n\tif (depth > 10) return;\n\n\tvar currNode = sbv.tree.getNodeByKey(nodeId.toString());\n    \n\tvar childNodes = sbv.notes.find({'parentId':{ '$eq' : nodeId }});\n    for(var idx = 0; idx < childNodes.length; idx++) {\n    \t// opting to use dynamic add for all non-root nodes\n        currNode.addChild({\n    \t\ttitle: childNodes[idx].name,\n            key: childNodes[idx].$loki.toString()\n\t\t});\n\n\t\tcurrNode.expand(true);\n        \n    \taddBranch(childNodes[idx].$loki, depth+1);\n    }\n}\n\nfunction RefreshTree() {\n\tvar rootNodes = sbv.notes.find({'parentId':{ '$eq' : null }});\n    //rootNodes = rootNodes.slice(0);\n    rootNodes = rootNodes.sort(function (x, y) { \n    \t\tif (x.$loki > y.$loki) return 1;\n    \t\tif (x.$loki < y.$loki) return -1;\n    \t\treturn 0;\n    \t});\n \n    sbv.tree.options.children = [];\n    \n    for(var idx = 0; idx < rootNodes.length; idx++) {\n    \tsbv.tree.options.children.push({ title: rootNodes[idx].name, key: rootNodes[idx].$loki});\n    }\n    \n    sbv.tree.reload();\n    \n    for(var idx = 0; idx < rootNodes.length; idx++) {\n    \taddBranch(rootNodes[idx].$loki, 0);\n    }\n    \n    if (sbv.newsel != null) {\n    \tsbv.tree.activateKey(sbv.newsel);\n        sbv.newsel = null;\n    } \n    else {\n\t    if (sbv.lastsel != null) {\n    \t    sbv.tree.activateKey(sbv.lastsel);\n    \t}\n    \telse {\n\t    \tif (rootNodes.length > 0) sbv.tree.activateKey(rootNodes[0].$loki.toString());\n\t    }\n    }\n    \n}\n\n// Multiple Pass Encryption\nfunction multiPassEnc(src, origPass) {\n\tvar revpass = origPass.split(\"\").reverse().join(\"\");\n\n\tvar enc1 = CryptoJS.AES.encrypt(src, origPass).toString();\n    var enc2 = enc1.split(\"\").reverse().join(\"\");    enc1 = null;\n\tvar enc3 = CryptoJS.AES.encrypt(enc2, revpass).toString();    enc2 = null;\n    var enc4 = enc3.split(\"\").reverse().join(\"\"); \n    \n    return enc4;\n}\n\n// Multiple Pass Decryption\nfunction multiPassDec(src, origPass) {\n\tvar revpass = origPass.split(\"\").reverse().join(\"\");\n                \n\t// Two passes\n    var dec1 = src.split(\"\").reverse().join(\"\");\n\tvar dec2 = CryptoJS.AES.decrypt(dec1, revpass).toString(CryptoJS.enc.Utf8); dec1=null;\n    var dec3 = dec2.split(\"\").reverse().join(\"\");  dec2=null;\n\tvar dec4 = CryptoJS.AES.decrypt(dec3, origPass).toString(CryptoJS.enc.Utf8); \n    \n    return dec4;\n}\n\nfunction saveTrident() {\n\t\n\t// save any changes pending to selected node first\n\tif (sbv.lastsel != null) {\n\t\tvar htmlText = tinyMCE.get('txtNoteContent').getContent(); \t\n                \n\t\tvar prevNote = sbv.notes.get(parseInt(sbv.lastsel));\n\t\tprevNote.html = htmlText;\n\t}\n\n\tif (sbv.cachedPass == null) {\n\t\tAPI_ShowPasswordDialog(function(pass) {\n\t\t\tif (pass.length < 6) {\n\t\t\t\talertify.alert(\"Password must be at least six characters\");\n\t\t\t\treturn;\n\t\t\t}\n            \n            sbv.cachedPass = pass;\n            \n            var result = multiPassEnc(JSON.stringify(sbv.db), pass);\n            \n        \t// Using new Trident API so i can (optionally) persist to network service of mine\n       \t\tVAR_TRIDENT_API.SetAppKey('HieroCryptes Notepad', \"NotepadData\", result, function(result) {\n                if (result.success) {\n                    alertify.success(\"saved\");\n                }\n                else {\n                    alertify.error(\"error saving notepad\");\n                }\n\t        });\n\t\t});\n    }\n    else {\n\t\tvar result = multiPassEnc(JSON.stringify(sbv.db), sbv.cachedPass);\n\n            \n        // Using new Trident API so i can (optionally) persist to network service of mine\n   \t\tVAR_TRIDENT_API.SetAppKey('HieroCryptes Notepad', \"NotepadData\", result, function(result) {\n                if (result.success) {\n                    alertify.success(\"saved\");\n                }\n                else {\n                    alertify.error(\"error saving notepad\");\n                }\n        });\n    }\n}\n\n//\n// IMPORT EXPORT FUNCTIONS\n//\n\nfunction exportNote() {\n\tAPI_ShowPasswordDialog(function(pass) {\n\t\tif (pass.length < 6) {\n\t\t\talertify.alert(\"Password must be at least six characters\");\n\t\t\treturn;\n\t\t}\n    \n \t\tsbv.cachedPass = pass;\n    \t\t\n\t\tvar result = multiPassEnc(JSON.stringify(sbv.db), pass);\n\n\t\t// user can set their own filename in the save dialog\n\t\tAPI_SaveTextFile('Notepad.hcn', result)\t\n\t});\n}\n\nfunction importNote() {\n\tAPI_ShowLoad();\n}\n\nfunction EVT_UserLoadCallback(filestring, filename) {\n\tAPI_HideUserLoader();\n    \n\tAPI_ShowPasswordDialog(function(pass) {\n    \tsbv.cachedPass = pass;\n        \n\t\tvar result = multiPassDec(filestring, pass)\n\n\t\tsbv.db.loadJSON(result);\n\n\t\t// update our shortcut reference to collection\n\t\tsbv.notes = sbv.db.getCollection(\"notes\");\n                \n        sbv.lastsel = null;\n        \n\t\tRefreshTree();\n\t});\n}\n\n"
}