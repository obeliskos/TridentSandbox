{
  "progName": "HieroCryptes-WJS",
  "htmlText": "<style>\nspan.dynatree-node a {\n  font-size: 12pt;\n}\n.content,\n#app {\n    height: 100%;\n}\n\n    /* SplitView pane content style*/\n    #app .header {\n        white-space: nowrap;\n    }\n\n    #app .title {\n        font-size: 25px;\n        left: 50px;\n        margin-top: 0px;\n        vertical-align: middle;\n        display: inline-block;\n    }\n\n    #app .nav-commands {\n        margin-top: 20px;\n    }\n\n.win-navbarcommand-button {\n    background-color: transparent;\n}\n\n#app .win-splitview-pane-hidden .win-navbarcommand-button {\n    width: 46px;\n}\n\n#app .win-splitview-pane-hidden .win-navbarcommand-label {\n    /* Workaround: Make sure pane doesn't scroll if ContentDialog restores focus to\n       NavBarCommand's label\n    */\n    visibility: hidden;\n}\n\n/*SplitView content style*/\n/*#app .win-splitview-content {\n    background-color: rgb(112,112,112);\n}\n*/\n#app .contenttext {\n    margin-left: 20px;\n    margin-top: 6px;\n}\n\n/*SplitView pane show button style*/\nbutton.win-splitview-button {\n    float: left;\n    box-sizing: border-box;\n    height: 48px;\n    width: 48px;\n    min-height: 0;\n    min-width: 0;\n    padding: 0;\n    border: 1px dotted transparent;\n    margin: 0;\n    outline: none;\n    background-color: transparent;\n}\n\nhtml.win-hoverable button.win-splitview-button:hover {\n    background-color: rgba(255,255,255, 0.1);\n}\n\nbutton.win-splitview-button.win-splitview-button:active,\nbutton.win-splitview-button.win-splitview-button:hover:active {\n    background-color: rgba(255,255,255, 0.2);\n}\n\nbutton.win-splitview-button.win-keyboard:focus {\n    border-color: rgb(255, 255, 255);\n}\n\nbutton.win-splitview-button:after {\n    font-size: 24px;\n    font-family: 'Segoe MDL2 Assets', 'Symbols';\n    content: \"\\E700\";\n}\n</style>\n<div id=\"dialogElement\" data-win-control=\"WinJS.UI.ContentDialog\" data-win-options=\"{\n\ttitle: 'Enter Password',\n\tprimaryCommandText: 'Accept',\n\tsecondaryCommandText: 'Cancel'\n\t}\">\n\t<div id=\"divPassword\">\n\t\t<input id=\"hfTaskId\" type=\"hidden\" />\n\t\t<input id=\"txtDialogPassword\" type=\"password\" style=\"border:1px solid #000\"\n\t\t\tonkeydown=\"if (event.keyCode == 13) $('.win-contentdialog-primarycommand').click()\"/>\n\t</div>\n</div>\n\n<div class=\"box\">\n<div id=\"promptDialog\" data-win-control=\"WinJS.UI.ContentDialog\" data-win-options=\"{\n\ttitle: 'Prompt Dialog',\n\tprimaryCommandText: 'Accept',\n\tsecondaryCommandText: 'Cancel'\n\t}\">\n\t<div id=\"divEntry\">\n\t\t<input id=\"txtPromptedValue\" type=\"text\" style=\"border:1px solid #000\"\n\t\t\tonkeydown=\"if (event.keyCode == 13) $('.win-contentdialog-primarycommand').click()\"/>\n\t</div>\n</div>\n</div>\n\n<div id=\"app\">\n    <div id=\"divSplitView\" class=\"splitView\" data-win-control=\"WinJS.UI.SplitView\">\n        <!-- Pane area -->\n        <div>\n            <div class=\"header\">\n                <button type=\"button\" class=\"win-splitview-button\" onclick=\"HieroApp.togglePane();\"></button>\n                <div class=\"title\">\n                \tHierocryptes Notepad \n\t\t\t\t</div>\n            </div>\n\n            <div class=\"nav-commands\">\n                <div data-win-control=\"WinJS.UI.NavBarCommand\" data-win-options=\"{ id:'cmdFullscreen', label: 'Fullscreen', icon: 'fullscreen', onclick: HieroApp.fullscreenCommand }\"></div>\n                <div data-win-control=\"WinJS.UI.NavBarCommand\" data-win-options=\"{ id:'cmdSave', label: 'Save', icon: 'save', onclick: HieroApp.saveCommand }\"></div>\n                <div data-win-control=\"WinJS.UI.NavBarCommand\" data-win-options=\"{ id:'cmdAddNode', label: 'Add Node', icon: 'contact', onclick: HieroApp.addNodeCommand }\"></div>\n                <div data-win-control=\"WinJS.UI.NavBarCommand\" data-win-options=\"{ id:'cmdAddChild', label: 'Add Child', icon: 'people', onclick: HieroApp.addChildCommand }\"></div>\n                <div data-win-control=\"WinJS.UI.NavBarCommand\" data-win-options=\"{ id:'cmdRenameNode', label: 'Rename Node', icon: 'tag', onclick: HieroApp.renameNodeCommand }\"></div>\n                <div data-win-control=\"WinJS.UI.NavBarCommand\" data-win-options=\"{ id:'cmdDelete', label: 'Delete', icon: 'delete', onclick: HieroApp.deleteNodeCommand }\"></div>\n                <div data-win-control=\"WinJS.UI.NavBarCommand\" data-win-options=\"{ id:'cmdFontSize', label: 'Cycle through font sizes', icon: 'fontsize', onclick: HieroApp.fontSizeCommand }\"></div>\n                <div data-win-control=\"WinJS.UI.NavBarCommand\" data-win-options=\"{ id:'cmdAbout', label: 'About', icon: 'help', onclick: HieroApp.aboutCommand }\"></div>\n                <div data-win-control=\"WinJS.UI.NavBarCommand\" data-win-options=\"{ id:'cmdExport', label: 'Export', icon: 'download', onclick: HieroApp.exportCommand }\"></div>\n                <div data-win-control=\"WinJS.UI.NavBarCommand\" data-win-options=\"{ id:'cmdImport', label: 'Import', icon: 'upload', onclick: HieroApp.importCommand }\"></div>\n            </div>\n        </div>\n\n        <!-- Content area -->\n        <div class=\"contenttext\">\n          <div id=\"divHeader\" align=\"center\" style=\"padding-top:14px; padding-bottom:14px; width:100%;\">\n              <div style=\"display: inline-block; padding:4px; color:#ff9; text-shadow: 0px 0px 9px rgba(0,0,0,0.75); border: 2px solid; border-radius: 5px; width:140px\">\n              <label style=\"font-family:Garamond, Sans; font-size:20pt;\">\n              <i style=\"color:#ada\" class=\"fa fa-sitemap\"></i>&nbsp;\n              <i style=\"color:#ada\" class=\"fa fa-key\"></i>&nbsp;\n              <i style=\"color:#ada\" class=\"fa fa-edit\"></i> \n              </label>\n              </div>&nbsp;\n              <label style=\"text-shadow: 0px 0px 9px rgba(0,0,0,0.75); font-family:Garamond, Sans; font-size:24pt; color:#ff9;\">\n                  Hierocryptes Notepad\n              </label>\n          </div>\n\n          <div id=\"divMain\">\n              <table style='width:100%;background-color:#aaa;display:none'>\n                  <tr style='background-color:#aaa'>\n                      <td style='padding:5px; width:400px'>\n                          <button style=\"height:34px\" onclick='addNode()' title='Add Node'><i class=\"fa fa-plus-circle\"></i> Node</button>\n                          <button style=\"height:34px\" onclick='addChild()' title='Add Child Node'><i class=\"fa fa-plus-circle\"></i> Child</button>\n                          <button style=\"height:34px\" onclick='renameNode()' title='Rename Node'><i class=\"fa fa-tag\"></i> Rename</button>\n                          <button style=\"height:34px\" onclick='deleteNode()' title='Delete Node'><i class=\"fa fa-minus-circle\"></i> Delete</button>\n                      </td>\n                      <td>\n                          <div id='divDbActions' style='display:inline'>\n                              <button style=\"height:34px\" id='btnSave' title='Save to Trident DB' onclick='saveTrident()'><i class=\"fa fa-floppy-o\"></i> Save TDB</button>&nbsp;\n                              <button style=\"height:34px\" title='Export / Save Locally' onclick='exportNote()'><i class=\"fa fa-download\"></i> Export</button>&nbsp;\n                              <button style=\"height:34px\" title='Import / Load Local File' onclick='importNote()'><i class=\"fa fa-arrow-up\"></i> Import</button>\n                          </div>\n                      </td>\n                  </tr>\n              </table>\n\n              <table width='100%'>\n              <tr valign='top'>\n                  <td style=\"min-width:200px\">\n                      <div id=\"tree1\"></div>\n                  </td>\n                  <td>\n                      <textarea id=\"txtNoteContent\" name=\"divContent\" style=\"width:100%; height:400px\"></textarea>\n                  </td>\n              </tr>\n              </table>\n\n              <div id='divPassword' style='display:none'>\n              <i class=\"fa fa-key\"></i> Enter Password : \n              <input id='txtDialogPassword'  onKeyDown=\"if (event.keyCode==13) sandboxVars.dlgOkButton.focus()\" type='password'/>\n              </div>\n          </div>\n\n        </div>\n    </div> \n</div>\n\n<div id=\"divOuter\" style=\"display:none\">\n\n    <div id=\"renameFlyout\" data-win-control=\"WinJS.UI.Flyout\" aria-label=\"{Confirm purchase flyout}\">\n        <div>Enter new node name : <br/><input id=\"txtNodeRename\" style=\"width:120px\"></div>\n        <button id=\"dismissButton\" onclick=\"doRenameNode()\">Ok</button>\n    </div>\n\n<div class=\"box\">\n\n    <div id=\"dialogAbout\" data-win-control=\"WinJS.UI.ContentDialog\" data-win-options=\"{\n             title: 'About Hierocryptes Notepad',\n             primaryCommandText: 'Close'\n        }\">\n\t    \t<div align='center' style=\"display: inline-block; padding:4px; color:#494; width:160px\">\n    \t\t<label style=\"font-family:Garamond, Sans; font-size:20pt;\">\n    \t\t<i class=\"fa fa-sitemap\"></i>&nbsp;\n    \t\t<i class=\"fa fa-key\"></i>&nbsp;\n    \t\t<i class=\"fa fa-edit\"></i> \n    \t\t</label>\n    \t\t</div>&nbsp;\n    \t\t<p>App Version : <span id=\"spnVersion\"></span><br/>\n            TridentSandbox Version : <span id=\"spnTridentVersion\"></span></p>\n            <p><i>HieroCryptes Notepad</i> is an encrypted, hierarchical notepad.<br/><br/>\n            It can run offline and it encrypts and saves \n            your notepad into your browser's client storage (indexed db)... not on a server.<br/><br/>\n            You can also import and export \n            your notepad to an external, encrypted file for emailing or storing in the cloud.</p>\n\n            <p>This program was developed in, and is distributed as part of the <a href=\"https://github.com/obeliskos/TridentSandbox\" target=\"_blank\">TridentSandbox project</a>.</p>\n\n            <p>You can edit the source code of this program using the included <a href=\"TridentSandboxWJS.htm#EditApp=HieroCryptes-WJS\" target=\"_blank\">TridentSandbox IDE</a>.</p>\n        <div style=\"height: 50px; width: 1px;\"></div>\n    </div>\n</div>\n\n\n\n\n</div>\n\n",
  "scriptText": "API_SetBackgroundColor(\"#334\");\n\nvar sbv = {\n    db : new loki('HieroCrypt Notepad'),\n    notes : null,\n    tmce : null,\n    tree : null,\n    isImport : false,\n    lastsel : null,\n    newsel: null,\n    cachedPass: null, \n    ver : \"2.0\",\n    fontSize: 0\n}\n\n$(\"#spnVersion\").text(sbv.ver);\n$(\"#spnTridentVersion\").text(sandbox.volatile.version);\n\nfunction EVT_CleanSandbox() {\n    tinymce.remove();\n    delete sbv.db;\n    delete sbv.tmce;\n    delete sbv.isImport;\n    sbv.cachedPass = \"asldfj\";\n    delete sbv.cachedPass;\n    delete sbv.tree;\n    \n    EVT_CleanSandbox = null;\n}\n\nfunction EVT_WindowResize() {\n    var resizeHeight = 350;\n    var hdrHeight = $(\"#divHeader\").height();\n    \n    switch (sandbox.volatile.env) {\n        case \"IDE\" : resizeHeight = $(window).height() - 520; \n\t\t\t$(\"#divSplitView\").height($(window).height()-300); \n\t\t\tbreak;\n        case \"IDE WJS\" : resizeHeight = $(window).height() - 520; \n        \t$(\"button\").css(\"min-width\", \"0px\"); \n\t\t\t$(\"#divSplitView\").height($(window).height()-300); \n            break;\n        case \"SBL\" : resizeHeight = $(window).height() - 230; \n\t\t\t$(\"#divSplitView\").height($(window).height()-5); \n        \tbreak;\n        case \"SBL WJS\" : resizeHeight = $(window).height() - 180 - hdrHeight; $(\"button\").css(\"min-width\", \"0px\"); \n\t\t\t$(\"#divSplitView\").height($(window).height()-5); \n        \tbreak;\n        case \"STANDALONE\" : resizeHeight = $(window).height() - 340; break;\n        default : break;\n    }\n    \n\ttinyMCE.get('txtNoteContent').theme.resizeTo(\"400px\", resizeHeight);\n    $(\"#tree1\").css(\"height\", resizeHeight+109);\n}\n\n//setTimeout(function() {\n//$(\"#divSplitView\").height($(window).height()-300); \n//}, 1000);\n\nfunction showDiv(divIndex) {\n\t$(\"#divMain\").hide();\n\t$(\"#divAbout\").hide();\n\n\tswitch(divIndex) {\n        case 1: $(\"#divMain\").show(); break;\n        case 2: $(\"#divAbout\").show(); break;\n    }\n}\n\nfunction initTree() {\n\t//var treeData = [{title: \"Notes\", key: 21 }];\n\n    sbv.tree = $(\"#tree1\").dynatree({\n        checkbox: false,\n        // Override class name for checkbox icon:\n        classNames: {checkbox: \"dynatree-radio\"},\n        selectMode: 1,\n        children: [], //treeData,\n        onActivate: function(node) {\n        \t//alertify.log(\"activate\");\n\t\t\t// switching nodes, save old node first\n\t\t\tif (sbv.lastsel != null) {\n            \tvar htmlText = tinyMCE.get('txtNoteContent').getContent(); \t\n                \n                var prevNote = sbv.notes.get(parseInt(sbv.lastsel));\n                prevNote.html = htmlText;\n            }\n            \n            var note = sbv.notes.get(parseInt(node.data.key));\n            tinyMCE.get('txtNoteContent').setContent(note.html);\n            \n            sbv.lastsel = note.$loki.toString();\n        },\n        onSelect: function(select, node) {\n        },\n        onDblClick: function(node, event) {\n            //node.toggleSelect();\n        },\n        onKeydown: function(node, event) {\n            if( event.which == 32 ) {\n                node.toggleSelect();\n                return false;\n            }\n        },\n    });\n\n\tsbv.tree = $(\"#tree1\").dynatree(\"getTree\");\n}\n\nfunction initMCE(size) {\n\ttinymce.EditorManager.execCommand('mceRemoveEditor',true, \"txtNoteContent\");\n    \n    setTimeout(EVT_WindowResize, 500);\n    \n    \n    sbv.tmce = tinymce.init({\n        setup : function(ed)\n        {\n            ed.on('init', function() \n            {\n            \tswitch(sbv.fontSize) {\n                \tcase 0 :\n                    \tbreak;\n                    case 1 :\n                \t\tthis.getDoc().body.style.fontSize = '24px';\n                \t\tthis.getDoc().body.style.fontFamily = 'Helvetica';\n                    \tbreak;\n                    case 2 :\n                \t\tthis.getDoc().body.style.fontSize = '32px';\n                \t\tthis.getDoc().body.style.fontFamily = 'Helvetica';\n                    \tbreak;\n                    default :\n                    \tbreak;\n                }\n            });\n        },\n        selector: \"#txtNoteContent\",\n        theme: \"modern\",\n        plugins: [\n            \"advlist autolink lists link image charmap print preview hr anchor pagebreak\",\n            \"searchreplace wordcount visualblocks visualchars code fullscreen\",\n            \"insertdatetime media nonbreaking save table contextmenu directionality\",\n            \"emoticons template paste textcolor moxiemanager\"\n        ],\n        toolbar1: \"undo styleselect bold italic underline alignleft aligncenter bullist numlist outdent indent forecolor fullscreen\",\n        image_advtab: true,\n        toolbar_items_size : 'large'\n    });\n}\n\ninitMCE();\nsetTimeout(function() {\n\tinitProgram();\n}, 500);\n\nfunction initProgram() {\n\n\tinitTree();\n    \n\tsetTimeout(function() { \n    \t$(\"#divOuter\").show();\n    \tEVT_WindowResize(); \n    }, 200);\n\n    if (!window.indexedDB) {\n        $(\"#btnSave\").hide();\n    }\n\n\t// if running local filesystem\n\tif (!indexedDB) {\n\t\tsbv.notes = sbv.db.addCollection('notes'); \n\t\tvar note = sbv.notes.insert({ name:'Default', parentId : null, html : 'Welcome to <i>HieroCryptes</i> Notepad' });\n\t\tRefreshTree();\n        \n    \treturn;\n    }\n    \n\n    // Using new Trident API so i can (optionally) persist to network service of mine\n\tVAR_TRIDENT_API.GetAppKey('HieroCryptes Notepad', 'NotepadData', function (result) {\n    \tif (result == null || result.id == 0) {\n        \t// Nothing saved yet, initialize a new loki db with single note\n            sbv.notes = sbv.db.addCollection('notes'); \n            var note = sbv.notes.insert({ name:'Default', parentId : null, html : 'Welcome to <i>HieroCryptes</i> Notepad' });\n\t\t\tRefreshTree();\n        }\n        else {\n\t\t\tvar contentDialog = document.querySelector(\"#dialogElement\").winControl; //document.querySelector(\".win-contentdialog\").winControl;\n\t\t\tcontentDialog.show().then(function (info) {\n              if (info.result == \"primary\") {\n                  var pass = $(\"#txtDialogPassword\").val();\n                  // using multipass decryption on notepad saved in TridentDB                \n                  var decresult = multiPassDec(result.val, pass)\n\n                  sbv.db.loadJSON(decresult);\n\n                  // update our shortcut reference to collection\n                  sbv.notes = sbv.db.getCollection(\"notes\");\n\n                  RefreshTree();\n              }\n            });\n        }\n\t});\n}\n\n// obsolete\nfunction addNode() {\n\talertify.prompt(\"Enter note name\", function (e, str) {\n\t\tif (e) {\n\t\t\tvar note = sbv.notes.insert({ name:str, parentId : null, html : 'New note' });\n\t\t\tsbv.tree.options.children.push({ title: str, key: note.$loki.toString()});\n            \n            sbv.newsel = note.$loki.toString();\n            \n\t\t\tRefreshTree();\n\t\t} \n\t}, \"\");\n}\n\n// obsolete\nfunction addChild() {\n\tif (sbv.lastsel == null) {\n    \talertify.log(\"Select a node first\");\n        return;\n    }\n    \n\tvar currNode = sbv.tree.getNodeByKey(sbv.lastsel);\n    var currNote = sbv.notes.get(parseInt(currNode.data.key));\n    \n\talertify.prompt(\"Enter note name\", function (e, str) {\n\t\tif (e) {\n\t\t\tvar note = sbv.notes.insert({ name:str, parentId : currNote.$loki, html : 'New child note' });\n\t\t\tcurrNode.addChild({\n\t\t\t\ttitle: str,\n\t\t\t\tkey: note.$loki\n\t\t\t});\n\t\t\tcurrNode.expand(true);\n            \n\t\t\tsbv.tree.activateKey(note.$loki.toString());\n\t\t} \n\t}, \"\");\n    \n}\n\n// obsolete\nfunction renameNode() {\n\tif (sbv.lastsel == null) {\n    \talertify.log(\"Select a node first\");\n        return;\n    }\n    \n\tvar currNode = sbv.tree.getNodeByKey(sbv.lastsel);\n    var currNote = sbv.notes.get(parseInt(currNode.data.key));\n    \n\talertify.prompt(\"Enter new note name\", function (e, str) {\n\t\tif (e) {\n\t\t\tcurrNote.name = str;\n            \n\t\t\tcurrNode.data.title = str;\n            currNode.render();\n\t\t} \n\t}, currNote.name);\n}\n\n// obsolete\nfunction doRenameNode() {\n\tif (sbv.lastsel == null) {\n    \talertify.log(\"Select a node first\");\n        return;\n    }\n    \n\tsbv.appBar.hide();\n    \n\tvar currNode = sbv.tree.getNodeByKey(sbv.lastsel);\n    var currNote = sbv.notes.get(parseInt(currNode.data.key));\n    var newName = $(\"#txtNodeRename\").val();\n    \n\tcurrNote.name = newName;\n\tcurrNode.data.title = newName;\n    currNode.render();\n    \n    document.getElementById(\"renameFlyout\").winControl.hide();\n    \n}\n\nfunction deleteBranch(note, depth) {\n\tif (depth > 10) return;\n\n\tvar childNodes = sbv.notes.find({'parentId':{ '$eq' : note.$loki }});\n    \n\tfor(var idx = 0; idx < childNodes.length; idx++) {\n\t\tdeleteBranch(childNodes[idx], depth+1);\n\t\tsbv.notes.remove(childNodes[idx]);\n\t}\n    \n\tsbv.notes.remove(note);\n}\n\nfunction deleteNode() {\n\tif (sbv.lastsel == null) {\n    \talertify.log(\"Select a node first\");\n        return;\n    }\n\n\tvar currNode = sbv.tree.getNodeByKey(sbv.lastsel);\n    \n\talertify.confirm(\"Are you sure you want to delete branch \" + currNode.data.title, function (e) {\n\t\tif (e) {\n    \t\tvar currNote = sbv.notes.get(parseInt(currNode.data.key));\n    \n    \t\tdeleteBranch(currNote, 0);\n    \n    \t\tsbv.lastsel = null;\n    \n    \t\tRefreshTree();\n\t\t} \n\t});\n}\n\nfunction addBranch(nodeId, depth) {\n\t// prevent bad or user hacked data from causing infinite loop\n\tif (depth > 10) return;\n\n\tvar currNode = sbv.tree.getNodeByKey(nodeId.toString());\n    \n\tvar childNodes = sbv.notes.find({'parentId':{ '$eq' : nodeId }});\n    for(var idx = 0; idx < childNodes.length; idx++) {\n    \t// opting to use dynamic add for all non-root nodes\n        currNode.addChild({\n    \t\ttitle: childNodes[idx].name,\n            key: childNodes[idx].$loki.toString()\n\t\t});\n\n\t\tcurrNode.expand(true);\n        \n    \taddBranch(childNodes[idx].$loki, depth+1);\n    }\n}\n\nfunction RefreshTree() {\n\tvar rootNodes = sbv.notes.find({'parentId':{ '$eq' : null }});\n    //rootNodes = rootNodes.slice(0);\n    rootNodes = rootNodes.sort(function (x, y) { \n    \t\tif (x.$loki > y.$loki) return 1;\n    \t\tif (x.$loki < y.$loki) return -1;\n    \t\treturn 0;\n    \t});\n \n    sbv.tree.options.children = [];\n    \n    for(var idx = 0; idx < rootNodes.length; idx++) {\n    \tsbv.tree.options.children.push({ title: rootNodes[idx].name, key: rootNodes[idx].$loki});\n    }\n    \n    sbv.tree.reload();\n    \n    for(var idx = 0; idx < rootNodes.length; idx++) {\n    \taddBranch(rootNodes[idx].$loki, 0);\n    }\n    \n    if (sbv.newsel != null) {\n    \tsbv.tree.activateKey(sbv.newsel);\n        sbv.newsel = null;\n    } \n    else {\n\t    if (sbv.lastsel != null) {\n    \t    sbv.tree.activateKey(sbv.lastsel);\n    \t}\n    \telse {\n\t    \tif (rootNodes.length > 0) sbv.tree.activateKey(rootNodes[0].$loki.toString());\n\t    }\n    }\n    \n}\n\n// Multiple Pass Encryption\nfunction multiPassEnc(src, origPass) {\n\tvar revpass = origPass.split(\"\").reverse().join(\"\");\n\n\tvar enc1 = CryptoJS.AES.encrypt(src, origPass).toString();\n    var enc2 = enc1.split(\"\").reverse().join(\"\");    enc1 = null;\n\tvar enc3 = CryptoJS.AES.encrypt(enc2, revpass).toString();    enc2 = null;\n    var enc4 = enc3.split(\"\").reverse().join(\"\"); \n    \n    return enc4;\n}\n\n// Multiple Pass Decryption\nfunction multiPassDec(src, origPass) {\n\tvar revpass = origPass.split(\"\").reverse().join(\"\");\n                \n\t// Two passes\n    var dec1 = src.split(\"\").reverse().join(\"\");\n\tvar dec2 = CryptoJS.AES.decrypt(dec1, revpass).toString(CryptoJS.enc.Utf8); dec1=null;\n    var dec3 = dec2.split(\"\").reverse().join(\"\");  dec2=null;\n\tvar dec4 = CryptoJS.AES.decrypt(dec3, origPass).toString(CryptoJS.enc.Utf8); \n    \n    return dec4;\n}\n\nfunction saveTridentAction() \n{\n    var contentDialog = document.querySelector(\"#dialogElement\").winControl; //document.querySelector(\".win-contentdialog\").winControl;\n    contentDialog.show().then(function (info) {\n    \tif (info.result == \"primary\") saveTrident();\n    });\n}\n\nfunction saveTrident() {\n\t// save any changes pending to selected node first\n\tif (sbv.lastsel != null) {\n\t\tvar htmlText = tinyMCE.get('txtNoteContent').getContent(); \t\n                \n\t\tvar prevNote = sbv.notes.get(parseInt(sbv.lastsel));\n\t\tprevNote.html = htmlText;\n\t}\n\n\tif (sbv.cachedPass == null) {\n        var contentDialog = document.querySelector(\"#dialogElement\").winControl; //document.querySelector(\".win-contentdialog\").winControl;\n        contentDialog.show().then(function (info) {\n            if (info.result == \"primary\") {\n            \tvar pass = $(\"#txtDialogPassword\").val();\n                if (pass.length < 6) {\n                    alertify.error(\"Password must be at least six characters\");\n                    return;\n                }\n\n                sbv.cachedPass = pass;\n\n                var result = multiPassEnc(JSON.stringify(sbv.db), pass);\n\n                // Using new Trident API so i can (optionally) persist to network service of mine\n                VAR_TRIDENT_API.SetAppKey('HieroCryptes Notepad', \"NotepadData\", result, function(result) {\n                    if (result.success) {\n                        alertify.success(\"saved\");\n                    }\n                    else {\n                        alertify.error(\"error saving notepad\");\n                    }\n                });\n            }\n        });\n    }\n    else {\n\t\tvar result = multiPassEnc(JSON.stringify(sbv.db), sbv.cachedPass);\n\n            \n        // Using new Trident API so i can (optionally) persist to network service of mine\n   \t\tVAR_TRIDENT_API.SetAppKey('HieroCryptes Notepad', \"NotepadData\", result, function(result) {\n                if (result.success) {\n                    alertify.success(\"saved\");\n                }\n                else {\n                    alertify.error(\"error saving notepad\");\n                }\n        });\n    }\n}\n\n//\n// IMPORT EXPORT FUNCTIONS\n//\n\nfunction exportNote() {\n\tvar contentDialog = document.querySelector(\"#dialogElement\").winControl; //document.querySelector(\".win-contentdialog\").winControl;\n\tcontentDialog.show().then(function (info) {\n\t\tif (info.result == \"primary\") {\n\t\t\tvar pass = $(\"#txtDialogPassword\").val();\n\n\t\t\tif (pass.length < 6) {\n\t\t\t\talertify.alert(\"Password must be at least six characters\");\n\t\t\t\treturn;\n\t\t\t}\n\n\t\t\tsbv.cachedPass = pass;\n\n\t\t\tvar result = multiPassEnc(JSON.stringify(sbv.db), pass);\n\n\t\t\t// user can set their own filename in the save dialog\n\t\t\tAPI_SaveTextFile('Notepad.hcn', result)\t\n\t\t}\n\t});\n}\n\n// obsolete\nfunction importNote() {\n\tAPI_ShowLoad();\n}\n\nfunction EVT_UserLoadCallback(filestring, filename) {\n\tAPI_HideUserLoader();\n    \n\tvar contentDialog = document.querySelector(\"#dialogElement\").winControl; //document.querySelector(\".win-contentdialog\").winControl;\n\tcontentDialog.show().then(function (info) {\n\t\tif (info.result == \"primary\") {\n\t\t\tvar pass = $(\"#txtDialogPassword\").val();\n\t\t\tsbv.cachedPass = pass;\n        \n\t\t\tvar result = multiPassDec(filestring, pass)\n\n\t\t\tsbv.db.loadJSON(result);\n\n\t\t\t// update our shortcut reference to collection\n\t\t\tsbv.notes = sbv.db.getCollection(\"notes\");\n                \n\t\t\tsbv.lastsel = null;\n            \n\t\t\tRefreshTree();\n        }\n\t});\n}\n\nfunction log(msg) {\n    alertify.log(msg);\n}\n\n// Command button functions\nfunction doClickAddNode() {\n    $(\"#txtPromptedValue\").val(\"\");\n\tvar contentDialog = document.querySelector(\"#promptDialog\").winControl; //document.querySelector(\".win-contentdialog\").winControl;\n    contentDialog.title = \"Enter node name :\";\n\tcontentDialog.show().then(function (info) {\n\t\tif (info.result == \"primary\") {\n        \tvar nn = $(\"#txtPromptedValue\").val();\n\t\t\tvar note = sbv.notes.insert({ name:nn, parentId : null, html : 'New note' });\n            \n\t\t\tsbv.tree.options.children.push({ title: nn, key: note.$loki.toString()});\n            sbv.newsel = note.$loki.toString();\n            \n\t\t\tRefreshTree();\n    \t}\n  \t});\n}\n\nfunction doClickAddChild() {\n\tif (sbv.lastsel == null) {\n    \talertify.log(\"Select a node first\");\n        return;\n    }\n    \n\tvar currNode = sbv.tree.getNodeByKey(sbv.lastsel);\n    var currNote = sbv.notes.get(parseInt(currNode.data.key));\n\n    $(\"#txtPromptedValue\").val(\"\");\n\tvar contentDialog = document.querySelector(\"#promptDialog\").winControl; //document.querySelector(\".win-contentdialog\").winControl;\n    contentDialog.title = \"Enter child node name :\";\n\tcontentDialog.show().then(function (info) {\n\t\tif (info.result == \"primary\") {\n        \tvar nn = $(\"#txtPromptedValue\").val();\n\t\t\tvar note = sbv.notes.insert({ name:nn, parentId : currNote.$loki, html : 'New child note' });\n\t\t\tcurrNode.addChild({\n\t\t\t\ttitle: nn,\n\t\t\t\tkey: note.$loki\n\t\t\t});\n\t\t\tcurrNode.expand(true);\n            \n\t\t\tsbv.tree.activateKey(note.$loki.toString());\n    \t}\n  \t});\n}\n\nfunction doClickRename() {\n\tif (sbv.lastsel == null) {\n    \talertify.log(\"Select a node first\");\n        return;\n    }\n\n\tvar currNode = sbv.tree.getNodeByKey(sbv.lastsel);\n    var currNote = sbv.notes.get(parseInt(currNode.data.key));\n    $(\"#txtPromptedValue\").val(currNote.name);\n    \n    // set cursor in entry text field to end of text\n    $('#txtPromptedValue').focus(function() {\n        setTimeout((function(el) {\n            var strLength = el.value.length;\n            return function() {\n                if(el.setSelectionRange !== undefined) {\n                    el.setSelectionRange(strLength, strLength);\n                } else {\n                    $(el).val(el.value);\n                }\n        }}(this)), 0);\n    });\n\n\tvar contentDialog = document.querySelector(\"#promptDialog\").winControl; //document.querySelector(\".win-contentdialog\").winControl;\n    contentDialog.title = \"Rename Node\";\n\tcontentDialog.show().then(function (info) {\n\t\tif (info.result == \"primary\") {\n        \tvar pv = $(\"#txtPromptedValue\").val();\n      \t\tcurrNote.name = pv;\n\t\t\tcurrNode.data.title = pv;\n\t\t\tcurrNode.render();\n    \t}\n  \t});\n}\n\nfunction doClickDelete() {\n    deleteNode();\n}\n\nfunction doClickSave() {\n    saveTrident();\n}\n\nfunction doClickImport() {\n    importNote();\n}\n\nfunction doClickExport() {\n    exportNote();\n}\n\nfunction doClickAbout() {\n    var contentDialog = document.getElementById(\"dialogAbout\").winControl;\n    contentDialog.show();\n}\n\nfunction doFullscreen() {\n\tAPI_UserFullToggle();\n}\n\nWinJS.Namespace.define(\"HieroApp\", {\n    splitView: null,\n    fullscreenCommand : WinJS.UI.eventHandler(function (ev) {\n    \tdoFullscreen();\n    }),\n    saveCommand: WinJS.UI.eventHandler(function (ev) {\n    \tdoClickSave();\n    }),\n    addNodeCommand: WinJS.UI.eventHandler(function(ev) {\n    \tdoClickAddNode();\n    }),\n    addChildCommand: WinJS.UI.eventHandler(function(ev) {\n    \tdoClickAddChild();\n    }),\n    renameNodeCommand: WinJS.UI.eventHandler(function(ev) {\n    \tdoClickRename();\n    }),\n    deleteNodeCommand: WinJS.UI.eventHandler(function(ev) {\n    \tdoClickDelete();\n    }),\n    aboutCommand: WinJS.UI.eventHandler(function(ev) {\n    \tdoClickAbout();\n    }),\n    exportCommand: WinJS.UI.eventHandler(function(ev) {\n    \tdoClickExport();\n    }),\n    importCommand: WinJS.UI.eventHandler(function(ev) {\n    \tdoClickImport();\n    }),\n    fontSizeCommand: WinJS.UI.eventHandler(function(ev) {\n    \tif (++sbv.fontSize > 2) sbv.fontSize = 0;\n        switch(sbv.fontSize) {\n        \tcase 0: $(\"span.dynatree-node a\").css(\"font-size\", \"12pt\"); break;\n            case 1: $(\"span.dynatree-node a\").css(\"font-size\", \"15pt\"); break;\n            case 2: $(\"span.dynatree-node a\").css(\"font-size\", \"18pt\"); break;\n        }\n    \tinitMCE();\n    }),\n    togglePane: WinJS.UI.eventHandler(function (ev) {\n        if (HieroApp.splitView) {\n            HieroApp.splitView.paneOpened = !HieroApp.splitView.paneOpened;\n        }\n    })\n});\n\nWinJS.Binding.processAll(null, HieroApp).then(function () {\n    WinJS.UI.processAll().done(function () {\n        HieroApp.splitView = document.querySelector(\".splitView\").winControl;\n        new WinJS.UI._WinKeyboard(HieroApp.splitView.paneElement); // Temporary workaround: Draw keyboard focus visuals on NavBarCommands\n    });\n})"
}