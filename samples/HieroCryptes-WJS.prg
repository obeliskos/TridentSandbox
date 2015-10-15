{
  "progName": "HieroCryptes-WJS",
  "htmlText": "<style>\n    span.dynatree-node a {\n        font-size: 12pt;\n    }\n    .content,\n    #app {\n        height: 100%;\n    }\n\n    /* SplitView pane content style*/\n    #app .header {\n        white-space: nowrap;\n    }\n\n    #app .title {\n        font-size: 25px;\n        left: 50px;\n        margin-top: 0px;\n        vertical-align: middle;\n        display: inline-block;\n    }\n\n    #app .nav-commands {\n        margin-top: 20px;\n    }\n\n    .win-navbarcommand-button {\n        background-color: transparent;\n    }\n\n    #app .win-splitview-pane-hidden .win-navbarcommand-button {\n        width: 46px;\n    }\n\n    #app .win-splitview-pane-hidden .win-navbarcommand-label {\n        /* Workaround: Make sure pane doesn't scroll if ContentDialog restores focus to\n        NavBarCommand's label\n        */\n        visibility: hidden;\n    }\n\n    /*SplitView content style*/\n    /*#app .win-splitview-content {\n    background-color: rgb(112,112,112);\n    }\n    */\n    #app .contenttext {\n        margin-left: 20px;\n        margin-top: 6px;\n    }\n\n    /*SplitView pane show button style*/\n    button.win-splitview-button {\n        float: left;\n        box-sizing: border-box;\n        height: 48px;\n        width: 48px;\n        min-height: 0;\n        min-width: 0;\n        padding: 0;\n        border: 1px dotted transparent;\n        margin: 0;\n        outline: none;\n        background-color: transparent;\n    }\n\n    html.win-hoverable button.win-splitview-button:hover {\n        background-color: rgba(255,255,255, 0.1);\n    }\n\n    button.win-splitview-button.win-splitview-button:active,\n    button.win-splitview-button.win-splitview-button:hover:active {\n        background-color: rgba(255,255,255, 0.2);\n    }\n\n    button.win-splitview-button.win-keyboard:focus {\n        border-color: rgb(255, 255, 255);\n    }\n\n    button.win-splitview-button:after {\n        font-size: 24px;\n        font-family: 'Segoe MDL2 Assets', 'Symbols';\n        content: \"\\E700\";\n    }\n</style>\n\n<div id=\"app\" style=\"display:none\" >\n    <div id=\"dialogElement\"\n         data-win-control=\"WinJS.UI.ContentDialog\" \n         data-win-options=\"{\n                           title: 'Enter Password',\n                           primaryCommandText: 'Accept',\n                           secondaryCommandText: 'Cancel'\n                           }\">\n\n        <div id=\"divPassword\">\n            <input id=\"hfTaskId\" type=\"hidden\" />\n            <input id=\"txtDialogPassword\" style=\"width:300px; font-size:20px\" type=\"password\" style=\"border:1px solid #000\"\n                   onkeydown=\"if (event.keyCode == 13) $('.win-contentdialog-primarycommand').click()\"/>\n        </div>\n    </div>\n\n    <div id=\"promptDialog\" \n         data-win-control=\"WinJS.UI.ContentDialog\" \n         data-win-options=\"{\n                           title: 'Prompt Dialog',\n                           primaryCommandText: 'Accept',\n                           secondaryCommandText: 'Cancel'\n                           }\">\n\n        <div id=\"divEntry\">\n            <input id=\"txtPromptedValue\" type=\"text\" style=\"width:300px; font-size:20px\"\n                   onkeydown=\"if (event.keyCode == 13) $('.win-contentdialog-primarycommand').click()\"/>\n        </div>\n    </div>\n\n    <div id=\"renameFlyout\" data-win-control=\"WinJS.UI.Flyout\" aria-label=\"{Confirm purchase flyout}\">\n        <div>Enter new node name : <br/><input id=\"txtNodeRename\" style=\"width:120px\"></div>\n        <button id=\"dismissButton\" onclick=\"doRenameNode()\">Ok</button>\n    </div>\n\n    <div class=\"box\">\n\n        <div id=\"dialogAbout\" \n             data-win-control=\"WinJS.UI.ContentDialog\" \n             data-win-options=\"{\n                               title: 'About Hierocryptes Notepad',\n                               primaryCommandText: 'Close'\n                               }\">\n\n            <div align='center' style=\"display: inline-block; padding:4px; color:#494; width:160px\">\n                <label style=\"font-family:Garamond, Sans; font-size:20pt;\">\n                    <i class=\"fa fa-sitemap\"></i>&nbsp;\n                    <i class=\"fa fa-key\"></i>&nbsp;\n                    <i class=\"fa fa-edit\"></i> \n                </label>\n            </div>&nbsp;\n            <p>App Version : <span id=\"spnVersion\"></span><br/>\n                TridentSandbox Version : <span id=\"spnTridentVersion\"></span></p>\n\n            <p><i>HieroCryptes Notepad</i> is an encrypted, hierarchical notepad.<br/><br/>\n                It can run offline and it encrypts and saves \n                your notepad into your browser's client storage (indexed db)... not on a server.<br/><br/>\n                You can also import and export \n                your notepad to an external, encrypted file for emailing or storing in the cloud.</p>\n\n            <p>This program was developed in, and is distributed as part of the <a class=\"TridentLinkSmall\" href=\"https://github.com/obeliskos/TridentSandbox\" target=\"_blank\">TridentSandbox project</a>.</p>\n\n            <p>You can edit the source code of this program using the included <a class=\"TridentLinkSmall\" href=\"TridentSandboxWJS.htm#EditApp=HieroCryptes-WJS\" target=\"_blank\">TridentSandbox IDE</a>.</p>\n            <div style=\"height: 50px; width: 1px;\"></div>\n        </div>\n    </div>\n\n    <div id=\"divSplitView\" class=\"splitView\" data-win-control=\"WinJS.UI.SplitView\">\n        <!-- Pane area -->\n        <div>\n            <div class=\"header\">\n                <button\n                        class=\"win-splitviewpanetoggle\"\n                        data-win-control=\"WinJS.UI.SplitViewPaneToggle\"\n                        data-win-options=\"{ splitView: select('.splitView') }\"\n                        ></button>\n                <div class=\"title\">Hierocryptes Notepad</div>\n            </div>\n\n            <div class=\"nav-commands\">\n                <div data-win-control=\"WinJS.UI.NavBarCommand\" data-win-options=\"{ id:'cmdFullscreen', label: 'Fullscreen', icon: 'fullscreen', onclick: HieroApp.fullscreenCommand }\"></div>\n                <div data-win-control=\"WinJS.UI.NavBarCommand\" data-win-options=\"{ id:'cmdSave', label: 'Save', icon: 'save', onclick: HieroApp.saveCommand }\"></div>\n                <div data-win-control=\"WinJS.UI.NavBarCommand\" data-win-options=\"{ id:'cmdAddNode', label: 'Add Node', icon: 'contact', onclick: HieroApp.addNodeCommand }\"></div>\n                <div data-win-control=\"WinJS.UI.NavBarCommand\" data-win-options=\"{ id:'cmdAddChild', label: 'Add Child', icon: 'people', onclick: HieroApp.addChildCommand }\"></div>\n                <div data-win-control=\"WinJS.UI.NavBarCommand\" data-win-options=\"{ id:'cmdRenameNode', label: 'Rename Node', icon: 'tag', onclick: HieroApp.renameNodeCommand }\"></div>\n                <div data-win-control=\"WinJS.UI.NavBarCommand\" data-win-options=\"{ id:'cmdDelete', label: 'Delete', icon: 'delete', onclick: HieroApp.deleteNodeCommand }\"></div>\n                <div data-win-control=\"WinJS.UI.NavBarCommand\" data-win-options=\"{ id:'cmdFontSize', label: 'Cycle through font sizes', icon: 'fontsize', onclick: HieroApp.fontSizeCommand }\"></div>\n                <div data-win-control=\"WinJS.UI.NavBarCommand\" data-win-options=\"{ id:'cmdAbout', label: 'About', icon: 'help', onclick: HieroApp.aboutCommand }\"></div>\n                <div data-win-control=\"WinJS.UI.NavBarCommand\" data-win-options=\"{ id:'cmdExport', label: 'Export', icon: 'download', onclick: HieroApp.exportCommand }\"></div>\n                <div data-win-control=\"WinJS.UI.NavBarCommand\" data-win-options=\"{ id:'cmdImport', label: 'Import', icon: 'upload', onclick: HieroApp.importCommand }\"></div>\n            </div>\n        </div>\n\n        <!-- Content area -->\n        <div class=\"contenttext\">\n            <div id=\"divHeader\" align=\"center\" style=\"padding-top:14px; padding-bottom:14px; width:100%;\">\n                <div style=\"display: inline-block; padding:4px; color:#ff9; text-shadow: 0px 0px 9px rgba(0,0,0,0.75); border: 2px solid; border-radius: 5px; width:140px\">\n                    <label style=\"font-family:Garamond, Sans; font-size:20pt;\">\n                        <i style=\"color:#ada\" class=\"fa fa-sitemap\"></i>&nbsp;\n                        <i style=\"color:#ada\" class=\"fa fa-key\"></i>&nbsp;\n                        <i style=\"color:#ada\" class=\"fa fa-edit\"></i> \n                    </label>\n                </div>&nbsp;\n                <label style=\"text-shadow: 0px 0px 9px rgba(0,0,0,0.75); font-family:Garamond, Sans; font-size:24pt; color:#ff9;\">\n                    Hierocryptes Notepad\n                </label>\n            </div>\n\n            <div id=\"divMain\">\n                <table width='100%'>\n                    <tr valign='top'>\n                        <td style=\"min-width:200px\">\n                            <div id=\"tree1\"></div>\n                        </td>\n                        <td>\n                            <textarea id=\"txtNoteContent\" name=\"divContent\" style=\"width:100%; height:400px\"></textarea>\n                        </td>\n                    </tr>\n                </table>\n            </div>\n\n        </div>\n    </div> \n</div>\n\n\n\n",
  "scriptText": "sandbox.ui.setBackgroundColor(\"#334\");\n$(\"#UI_MainPlaceholder\").css(\"height\", 800);\n\nvar sbv = {\n    db : new loki('HieroCrypt Notepad'),\n    notes : null,\n    tmce : null,\n    tree : null,\n    isImport : false,\n    lastsel : null,\n    newsel: null,\n    cachedPass: null, \n    ver : \"2.0\",\n    fontSize: 0\n};\n\nsandbox.events.clean = function() {\n    //tinymce.remove();\n    tinymce.EditorManager.execCommand('mceRemoveEditor',true, \"txtNoteContent\");\n\n    delete sbv.db;\n    delete sbv.tmce;\n    delete sbv.isImport;\n    sbv.cachedPass = \"\";\n    delete sbv.cachedPass;\n    delete sbv.tree;\n};\n\nsandbox.events.windowResize = function() {\n    var resizeHeight = 350;\n    var hdrHeight = $(\"#divHeader\").height();\n\n    switch (sandbox.volatile.env) {\n        case \"IDE\" : resizeHeight = $(window).height() - 520; \n            $(\"#divSplitView\").height($(window).height()-300); \n            break;\n        case \"IDE WJS\" : resizeHeight = $(window).height() - 520; \n            $(\"button\").css(\"min-width\", \"0px\"); \n            $(\"#divSplitView\").height($(window).height()-300); \n            break;\n        case \"SBL\" : resizeHeight = $(window).height() - 230; \n            $(\"#divSplitView\").height($(window).height()-5); \n            break;\n        case \"SBL WJS\" : resizeHeight = $(window).height() - 180 - hdrHeight; $(\"button\").css(\"min-width\", \"0px\"); \n            $(\"#divSplitView\").height($(window).height()-5); \n            break;\n        case \"STANDALONE\" : resizeHeight = $(window).height() - 340; break;\n        default : break;\n    }\n\n    tinyMCE.get('txtNoteContent').theme.resizeTo(\"400px\", resizeHeight);\n    $(\"#tree1\").css(\"height\", resizeHeight+109);\n};\n\nfunction showDiv(divIndex) {\n    $(\"#divMain\").hide();\n    $(\"#divAbout\").hide();\n\n    switch(divIndex) {\n        case 1: $(\"#divMain\").show(); break;\n        case 2: $(\"#divAbout\").show(); break;\n    }\n}\n\nfunction initTree() {\n    sbv.tree = $(\"#tree1\").dynatree({\n        checkbox: false,\n        // Override class name for checkbox icon:\n        classNames: {checkbox: \"dynatree-radio\"},\n        selectMode: 1,\n        children: [], //treeData,\n        onActivate: function(node) {\n            // switching nodes, save old node first\n            if (sbv.lastsel) {\n                var htmlText = tinyMCE.get('txtNoteContent').getContent();\n\n                var prevNote = sbv.notes.get(parseInt(sbv.lastsel));\n                prevNote.html = htmlText;\n            }\n\n            var note = sbv.notes.get(parseInt(node.data.key));\n            tinyMCE.get('txtNoteContent').setContent(note.html);\n\n            sbv.lastsel = note.$loki.toString();\n        },\n        onSelect: function(select, node) {\n        },\n        onDblClick: function(node, event) {\n            //node.toggleSelect();\n        },\n        onKeydown: function(node, event) {\n            if( event.which == 32 ) {\n                node.toggleSelect();\n                return false;\n            }\n        }\n    });\n\n    sbv.tree = $(\"#tree1\").dynatree(\"getTree\");\n}\n\nfunction initMCE(size) {\n    tinymce.EditorManager.execCommand('mceRemoveEditor',true, \"txtNoteContent\");\n\n    setTimeout(sandbox.events.windowResize, 500);\n\n    //setTimeout(function() {\n    sbv.tmce = tinymce.init({\n        setup : function(ed)\n        {\n            ed.on('init', function() \n                  {\n                switch(sbv.fontSize) {\n                    case 0 :\n                        this.getDoc().body.style.fontSize = '16px';\n                        this.getDoc().body.style.fontFamily = 'Helvetica';\n                        break;\n                    case 1 :\n                        this.getDoc().body.style.fontSize = '24px';\n                        this.getDoc().body.style.fontFamily = 'Helvetica';\n                        break;\n                    case 2 :\n                        this.getDoc().body.style.fontSize = '32px';\n                        this.getDoc().body.style.fontFamily = 'Helvetica';\n                        break;\n                    default :\n                        break;\n                }\n            });\n        },\n        selector: \"#txtNoteContent\",\n        theme: \"modern\",\n        plugins: [\n            \"advlist autolink lists link image charmap print preview hr anchor pagebreak\",\n            \"searchreplace wordcount visualblocks visualchars code fullscreen\",\n            \"insertdatetime media nonbreaking save table contextmenu directionality\",\n            \"emoticons template paste textcolor moxiemanager\"\n        ],\n        toolbar1: \"undo styleselect bold italic underline alignleft aligncenter bullist numlist outdent indent forecolor fullscreen\",\n        image_advtab: true,\n        toolbar_items_size : 'large'\n    });\n    //}, 100);\n}\n\nfunction initProgram() {\n    $(\"#spnVersion\").text(sbv.ver);\n    $(\"#spnTridentVersion\").text(sandbox.volatile.version);\n\n    initTree();\n\n    setTimeout(function() { \n        $(\"#app\").show();\n        sandbox.events.windowResize(); \n    }, 200);\n\n    if (!sandbox.db) {\n        $(\"#btnSave\").hide();\n        sbv.notes = sbv.db.addCollection('notes'); \n        var note = sbv.notes.insert({ name:'Default', parentId : null, html : 'Welcome to <i>HieroCryptes</i> Notepad' });\n        RefreshTree();\n\n        return;\n    }\n\n    // Using new Trident API so i can (optionally) persist to network service of mine\n    sandbox.db.getAppKey('HieroCryptes Notepad', 'NotepadData', function (result) {\n        if (result === null || typeof(result) === 'undefined' || result.id === 0) {\n            // Nothing saved yet, initialize a new loki db with single note\n            sbv.notes = sbv.db.addCollection('notes'); \n            var note = sbv.notes.insert({ name:'Default', parentId : null, html : 'Welcome to <i>HieroCryptes</i> Notepad' });\n            RefreshTree();\n        }\n        else {\n            var contentDialog = document.querySelector(\"#dialogElement\").winControl; //document.querySelector(\".win-contentdialog\").winControl;\n            contentDialog.show().then(function (info) {\n                if (info.result == \"primary\") {\n                    var pass = $(\"#txtDialogPassword\").val();\n                    // using multipass decryption on notepad saved in TridentDB                \n                    var decresult = multiPassDec(result.val, pass);\n\n                    sbv.db.loadJSON(decresult);\n\n                    // update our shortcut reference to collection\n                    sbv.notes = sbv.db.getCollection(\"notes\");\n\n                    RefreshTree();\n                }\n            });\n            $(\"#txtDialogPassword\").focus();\n\n        }\n    });\n}\n\n// obsolete\nfunction addNode() {\n    alertify.prompt(\"Enter note name\", function (e, str) {\n        if (e) {\n            var note = sbv.notes.insert({ name:str, parentId : null, html : 'New note' });\n            sbv.tree.options.children.push({ title: str, key: note.$loki.toString()});\n\n            sbv.newsel = note.$loki.toString();\n\n            RefreshTree();\n        } \n    }, \"\");\n}\n\n// obsolete\nfunction addChild() {\n    if (sbv.lastsel === null || typeof(sbv.lastsel) === 'undefined') {\n        alertify.log(\"Select a node first\");\n        return;\n    }\n\n    var currNode = sbv.tree.getNodeByKey(sbv.lastsel);\n    var currNote = sbv.notes.get(parseInt(currNode.data.key));\n\n    alertify.prompt(\"Enter note name\", function (e, str) {\n        if (e) {\n            var note = sbv.notes.insert({ name:str, parentId : currNote.$loki, html : 'New child note' });\n            currNode.addChild({\n                title: str,\n                key: note.$loki\n            });\n            currNode.expand(true);\n\n            sbv.tree.activateKey(note.$loki.toString());\n        } \n    }, \"\");\n\n}\n\n// obsolete\nfunction renameNode() {\n    if (sbv.lastsel === null || typeof(sbv.lastsel) === 'undefined') {\n        alertify.log(\"Select a node first\");\n        return;\n    }\n\n    var currNode = sbv.tree.getNodeByKey(sbv.lastsel);\n    var currNote = sbv.notes.get(parseInt(currNode.data.key));\n\n    alertify.prompt(\"Enter new note name\", function (e, str) {\n        if (e) {\n            currNote.name = str;\n\n            currNode.data.title = str;\n            currNode.render();\n        } \n    }, currNote.name);\n}\n\n// obsolete\nfunction doRenameNode() {\n    if (sbv.lastsel === null || typeof(sbv.lastsel) === 'undefined') {\n        alertify.log(\"Select a node first\");\n        return;\n    }\n\n    sbv.appBar.hide();\n\n    var currNode = sbv.tree.getNodeByKey(sbv.lastsel);\n    var currNote = sbv.notes.get(parseInt(currNode.data.key));\n    var newName = $(\"#txtNodeRename\").val();\n\n    currNote.name = newName;\n    currNode.data.title = newName;\n    currNode.render();\n\n    document.getElementById(\"renameFlyout\").winControl.hide();\n\n}\n\nfunction deleteBranch(note, depth) {\n    if (depth > 10) return;\n\n    var childNodes = sbv.notes.find({'parentId':{ '$eq' : note.$loki }});\n\n    for(var idx = 0; idx < childNodes.length; idx++) {\n        deleteBranch(childNodes[idx], depth+1);\n        sbv.notes.remove(childNodes[idx]);\n    }\n\n    sbv.notes.remove(note);\n}\n\nfunction deleteNode() {\n    if (sbv.lastsel === null || typeof(sbv.lastsel) === 'undefined') {\n        alertify.log(\"Select a node first\");\n        return;\n    }\n\n    var currNode = sbv.tree.getNodeByKey(sbv.lastsel);\n\n    alertify.confirm(\"Are you sure you want to delete branch \" + currNode.data.title, function (e) {\n        if (e) {\n            var currNote = sbv.notes.get(parseInt(currNode.data.key));\n\n            deleteBranch(currNote, 0);\n\n            sbv.lastsel = null;\n\n            RefreshTree();\n        } \n    });\n}\n\nfunction addBranch(nodeId, depth) {\n    // prevent bad or user hacked data from causing infinite loop\n    if (depth > 10) return;\n\n    var currNode = sbv.tree.getNodeByKey(nodeId.toString());\n\n    var childNodes = sbv.notes.find({'parentId':{ '$eq' : nodeId }});\n    for(var idx = 0; idx < childNodes.length; idx++) {\n        // opting to use dynamic add for all non-root nodes\n        currNode.addChild({\n            title: childNodes[idx].name,\n            key: childNodes[idx].$loki.toString()\n        });\n\n        currNode.expand(true);\n\n        addBranch(childNodes[idx].$loki, depth+1);\n    }\n}\n\nfunction RefreshTree() {\n    var rootNodes = sbv.notes.find({'parentId':{ '$eq' : null }});\n    var idx;\n\n    rootNodes = rootNodes.sort(function (x, y) { \n        if (x.$loki > y.$loki) return 1;\n        if (x.$loki < y.$loki) return -1;\n        return 0;\n    });\n\n    sbv.tree.options.children = [];\n\n    for(idx = 0; idx < rootNodes.length; idx++) {\n        sbv.tree.options.children.push({ title: rootNodes[idx].name, key: rootNodes[idx].$loki});\n    }\n\n    sbv.tree.reload();\n\n    for(idx = 0; idx < rootNodes.length; idx++) {\n        addBranch(rootNodes[idx].$loki, 0);\n    }\n\n    if (sbv.newsel !== null && typeof(sbv.newsel) !== 'undefined') {\n        sbv.tree.activateKey(sbv.newsel);\n        sbv.newsel = null;\n    } \n    else {\n        if (sbv.lastsel !== null && typeof(sbv.lastsel) !== 'undefined') {\n            sbv.tree.activateKey(sbv.lastsel);\n        }\n        else {\n            if (rootNodes.length > 0) sbv.tree.activateKey(rootNodes[0].$loki.toString());\n        }\n    }\n\n}\n\n// Multiple Pass Encryption\nfunction multiPassEnc(src, origPass) {\n    var revpass = origPass.split(\"\").reverse().join(\"\");\n\n    var enc1 = CryptoJS.AES.encrypt(src, origPass).toString();\n    var enc2 = enc1.split(\"\").reverse().join(\"\");    enc1 = null;\n    var enc3 = CryptoJS.AES.encrypt(enc2, revpass).toString();    enc2 = null;\n    var enc4 = enc3.split(\"\").reverse().join(\"\"); \n\n    return enc4;\n}\n\n// Multiple Pass Decryption\nfunction multiPassDec(src, origPass) {\n    var revpass = origPass.split(\"\").reverse().join(\"\");\n\n    // Two passes\n    var dec1 = src.split(\"\").reverse().join(\"\");\n    var dec2 = CryptoJS.AES.decrypt(dec1, revpass).toString(CryptoJS.enc.Utf8); dec1=null;\n    var dec3 = dec2.split(\"\").reverse().join(\"\");  dec2=null;\n    var dec4 = CryptoJS.AES.decrypt(dec3, origPass).toString(CryptoJS.enc.Utf8); \n\n    return dec4;\n}\n\nfunction saveTridentAction() {\n    var contentDialog = document.querySelector(\"#dialogElement\").winControl; //document.querySelector(\".win-contentdialog\").winControl;\n    contentDialog.show().then(function (info) {\n        if (info.result == \"primary\") saveTrident();\n    });\n}\n\nfunction saveTrident() {\n    // save any changes pending to selected node first\n    if (sbv.lastsel !== null && sbv.lastsel !== 'undefined') {\n        var htmlText = tinyMCE.get('txtNoteContent').getContent();\n\n        var prevNote = sbv.notes.get(parseInt(sbv.lastsel));\n        prevNote.html = htmlText;\n    }\n\n    if (sbv.cachedPass === null) {\n        var contentDialog = document.querySelector(\"#dialogElement\").winControl; //document.querySelector(\".win-contentdialog\").winControl;\n        contentDialog.show().then(function (info) {\n            if (info.result == \"primary\") {\n                var pass = $(\"#txtDialogPassword\").val();\n                if (pass.length < 6) {\n                    alertify.error(\"Password must be at least six characters\");\n                    return;\n                }\n\n                sbv.cachedPass = pass;\n\n                var result = multiPassEnc(JSON.stringify(sbv.db), pass);\n\n                // Using new Trident API so i can (optionally) persist to network service of mine\n                sandbox.db.setAppKey('HieroCryptes Notepad', \"NotepadData\", result, function(result) {\n                    if (result.success) {\n                        alertify.success(\"saved\");\n                    }\n                    else {\n                        alertify.error(\"error saving notepad\");\n                    }\n                });\n            }\n        });\n    }\n    else {\n        var result = multiPassEnc(JSON.stringify(sbv.db), sbv.cachedPass);\n\n\n        // Using new Trident API so i can (optionally) persist to network service of mine\n        sandbox.db.setAppKey('HieroCryptes Notepad', \"NotepadData\", result, function(result) {\n            if (result.success) {\n                alertify.success(\"saved\");\n            }\n            else {\n                alertify.error(\"error saving notepad\");\n            }\n        });\n    }\n}\n\n//\n// IMPORT EXPORT FUNCTIONS\n//\n\nfunction exportNote() {\n    var contentDialog = document.querySelector(\"#dialogElement\").winControl; //document.querySelector(\".win-contentdialog\").winControl;\n    contentDialog.show().then(function (info) {\n        if (info.result == \"primary\") {\n            var pass = $(\"#txtDialogPassword\").val();\n\n            if (pass.length < 6) {\n                alertify.alert(\"Password must be at least six characters\");\n                return;\n            }\n\n            sbv.cachedPass = pass;\n\n            var result = multiPassEnc(JSON.stringify(sbv.db), pass);\n\n            // user can set their own filename in the save dialog\n            sandbox.files.saveTextFile('Notepad.hcn', result);\n        }\n    });\n}\n\n// obsolete\nfunction importNote() {\n    sandbox.files.userfileShow();\n}\n\nsandbox.events.userLoadCallback = function(filestring, filename) {\n    sandbox.files.userfileHide();\n\n    var contentDialog = document.querySelector(\"#dialogElement\").winControl; //document.querySelector(\".win-contentdialog\").winControl;\n    contentDialog.show().then(function (info) {\n        if (info.result == \"primary\") {\n            var pass = $(\"#txtDialogPassword\").val();\n            sbv.cachedPass = pass;\n\n            var result = multiPassDec(filestring, pass);\n\n            sbv.db.loadJSON(result);\n\n            // update our shortcut reference to collection\n            sbv.notes = sbv.db.getCollection(\"notes\");\n\n            sbv.lastsel = null;\n\n            RefreshTree();\n        }\n    });\n};\n\nfunction log(msg) {\n    alertify.log(msg);\n}\n\n// Command button functions\nfunction doClickAddNode() {\n    $(\"#txtPromptedValue\").val(\"\");\n    var contentDialog = document.querySelector(\"#promptDialog\").winControl; //document.querySelector(\".win-contentdialog\").winControl;\n    contentDialog.title = \"Enter node name :\";\n    contentDialog.show().then(function (info) {\n        if (info.result == \"primary\") {\n            var nn = $(\"#txtPromptedValue\").val();\n            var note = sbv.notes.insert({ name:nn, parentId : null, html : 'New note' });\n\n            sbv.tree.options.children.push({ title: nn, key: note.$loki.toString()});\n            sbv.newsel = note.$loki.toString();\n\n            RefreshTree();\n        }\n    });\n}\n\nfunction doClickAddChild() {\n    if (sbv.lastsel === null || typeof(sbv.lastsel) === 'undefined') {\n        alertify.log(\"Select a node first\");\n        return;\n    }\n\n    var currNode = sbv.tree.getNodeByKey(sbv.lastsel);\n    var currNote = sbv.notes.get(parseInt(currNode.data.key));\n\n    $(\"#txtPromptedValue\").val(\"\");\n    var contentDialog = document.querySelector(\"#promptDialog\").winControl; //document.querySelector(\".win-contentdialog\").winControl;\n    contentDialog.title = \"Enter child node name :\";\n    contentDialog.show().then(function (info) {\n        if (info.result == \"primary\") {\n            var nn = $(\"#txtPromptedValue\").val();\n            var note = sbv.notes.insert({ name:nn, parentId : currNote.$loki, html : 'New child note' });\n            currNode.addChild({\n                title: nn,\n                key: note.$loki\n            });\n            currNode.expand(true);\n\n            sbv.tree.activateKey(note.$loki.toString());\n        }\n    });\n}\n\nfunction doClickRename() {\n    if (sbv.lastsel === null || typeof(sbv.lastsel) === 'undefined') {\n        alertify.log(\"Select a node first\");\n        return;\n    }\n\n    var currNode = sbv.tree.getNodeByKey(sbv.lastsel);\n    var currNote = sbv.notes.get(parseInt(currNode.data.key));\n    $(\"#txtPromptedValue\").val(currNote.name);\n\n    // set cursor in entry text field to end of text\n    $('#txtPromptedValue').focus(function() {\n        setTimeout(\n            (function(el) {\n                var strLength = el.value.length;\n                return function() {\n                    if(el.setSelectionRange !== undefined) {\n                        el.setSelectionRange(strLength, strLength);\n                    } else {\n                        $(el).val(el.value);\n                    }\n                };\n            }(this)), 0); //linter error incorrect?\n    });\n\n    var contentDialog = document.querySelector(\"#promptDialog\").winControl; //document.querySelector(\".win-contentdialog\").winControl;\n    contentDialog.title = \"Rename Node\";\n    contentDialog.show().then(function (info) {\n        if (info.result == \"primary\") {\n            var pv = $(\"#txtPromptedValue\").val();\n            currNote.name = pv;\n            currNode.data.title = pv;\n            currNode.render();\n        }\n    });\n}\n\nfunction doClickDelete() {\n    deleteNode();\n}\n\nfunction doClickSave() {\n    saveTrident();\n}\n\nfunction doClickImport() {\n    importNote();\n}\n\nfunction doClickExport() {\n    exportNote();\n}\n\nfunction doClickAbout() {\n    var contentDialog = document.getElementById(\"dialogAbout\").winControl;\n    contentDialog.show();\n}\n\nfunction doFullscreen() {\n    sandbox.ui.fullscreenToggle();\n}\n\nWinJS.Namespace.define(\"HieroApp\", {\n    splitView: null,\n    fullscreenCommand : WinJS.UI.eventHandler(function (ev) {\n        doFullscreen();\n    }),\n    saveCommand: WinJS.UI.eventHandler(function (ev) {\n        doClickSave();\n    }),\n    addNodeCommand: WinJS.UI.eventHandler(function(ev) {\n        doClickAddNode();\n    }),\n    addChildCommand: WinJS.UI.eventHandler(function(ev) {\n        doClickAddChild();\n    }),\n    renameNodeCommand: WinJS.UI.eventHandler(function(ev) {\n        doClickRename();\n    }),\n    deleteNodeCommand: WinJS.UI.eventHandler(function(ev) {\n        doClickDelete();\n    }),\n    aboutCommand: WinJS.UI.eventHandler(function(ev) {\n        doClickAbout();\n    }),\n    exportCommand: WinJS.UI.eventHandler(function(ev) {\n        doClickExport();\n    }),\n    importCommand: WinJS.UI.eventHandler(function(ev) {\n        doClickImport();\n    }),\n    fontSizeCommand: WinJS.UI.eventHandler(function(ev) {\n        if (++sbv.fontSize > 2) sbv.fontSize = 0;\n        switch(sbv.fontSize) {\n            case 0: $(\"span.dynatree-node a\").css(\"font-size\", \"12pt\"); break;\n            case 1: $(\"span.dynatree-node a\").css(\"font-size\", \"15pt\"); break;\n            case 2: $(\"span.dynatree-node a\").css(\"font-size\", \"18pt\"); break;\n        }\n        initMCE();\n    }),\n    togglePane: WinJS.UI.eventHandler(function (ev) {\n        if (HieroApp.splitView) {\n            HieroApp.splitView.paneOpened = !HieroApp.splitView.paneOpened;\n        }\n    })\n});\n\nWinJS.Binding.processAll(null, HieroApp).then(function () {\n    WinJS.UI.processAll().done(function () {\n        $(\"#app\").show();\n        initMCE();\n        setTimeout(function() {\n            initProgram();\n        }, 500);\n\n        HieroApp.splitView = document.querySelector(\".splitView\").winControl;\n        new WinJS.UI._WinKeyboard(HieroApp.splitView.paneElement); // Temporary workaround: Draw keyboard focus visuals on NavBarCommands\n    });\n});"
}