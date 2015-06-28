{
  "progName": "Library Unit Management",
  "htmlText": "<style>\n    select.unitlist  {\n        width:100%;\n        font-size:20px;\n    }\n\n    fieldset { \n        padding: 1em;\n        font:80%/1 sans-serif;\n        border:1px solid #888; \n        \n    }\n    label.lb4 {\n        float:left;\n        width:15%;\n        margin-right:0.5em;\n        padding-top:0.2em;\n        text-align:right;\n        font-weight:bold;\n    }\n\n    legend {\n        padding: 0.2em 0.5em;\n        border:1px solid #888;\n        color:#888;\n        font-size:90%;\n        text-align:right;\n    }\n\n</style>\n\n<ul class=\"tnavlist\">\n    <li class=\"tnavli\"><a class=\"tnava\" onclick=\"showDiv(1);\" href=\"javascript:void(0)\"><i class=\"fa fa-home\"></i> Home</a></li>\n    <li class=\"tnavli\"><a class=\"tnava\" onclick=\"showDiv(2);\" href=\"javascript:void(0)\"><i class=\"fa fa-code-fork\"></i> Script</a></li>\n    <li class=\"tnavli\"><a class=\"tnava\" onclick=\"showDiv(3);\" href=\"javascript:void(0)\"><i class=\"fa fa-html5\"></i> Markup</a></li>\n    <li class=\"tnavli\"><a class=\"tnava\" onclick=\"showDiv(4);\" href=\"javascript:void(0)\"><i class=\"fa fa-info-circle\"></i> About</a></li>\n</ul>\n\n\n<div id=\"divHome\">\n    <h3>Welcome to the Library Unit Management Utility</h3>\n\n    <p>\n        Please select Script or Markup from the menu to administer those respective \n        Unit Libraries.\n    </p>\n\n</div>\n\n<div id=\"divScript\" style=\"display:none\">\n    <h3>Script Units</h3>\n    <table width='100%'>\n        <tr valign='top'>\n            <td>\n                <select id=\"selScriptUnits\" size=7 class=\"unitlist\" onchange=\"scriptChanged()\"></select><br/>\n                <button class=\"minimal\" onclick=\"addScript()\" style=\"width:50px\"><i class=\"fa fa-plus\"></i></button>\n                <button class=\"minimal\" onclick=\"deleteScript()\" style=\"width:50px\"><i class=\"fa fa-trash-o\"></i></button>\n            </td>\n            <td>\n                <div id=\"divScriptEdit\" style=\"display:none; width:600px\">\n                    <fieldset style=\"color:#fff\" width=\"100%\">\n                        <legend>Script Unit Settings :</legend>\n                        <i>(Note: If you name a script <b>autorun</b> it will run on page load unless a <b>SkipAutorun</b> hash param is added)</i><br/><br/>\n                        <input id=\"hfScriptId\" type=\"hidden\" />\n                        <label>Script Name : </label><br/>\n                        <input id=\"txtScriptName\" style=\"width:240px\"/>&nbsp;<br/><br/>\n                        <label>Script Text : (Hit F11 Key to fullscreen the editor) </label><br/>\n                        <textarea id=\"txtScriptText\" spellcheck='false' style=\"width:80%; height:240px;\"></textarea>\n                        <br/><br/>\n                        <span style=\"float:right; margin-right:100px\">\n                            <button class=\"minimal\" onclick=\"saveScript()\"><i class=\"fa fa-save\"></i> Save</button>\n                            <button class=\"minimal\" onclick=\"$('#divScriptEdit').hide();\"><i class=\"fa fa-ban\"></i> Cancel</button>\n                        </span>\n                    </fieldset>\n                </div>\n            </td>\n        </tr>\n    </table>\n    </div>\n\n<div id=\"divMarkup\" style=\"display:none\">\n    <h3>Markup Units</h3>\n    <table width='100%'>\n        <tr valign='top'>\n            <td>\n                <select id=\"selMarkupUnits\" size=7 class=\"unitlist\" onchange=\"markupChanged()\"></select><br/>\n                <button class=\"minimal\" onclick=\"addMarkup()\" style=\"width:50px\"><i class=\"fa fa-plus\"></i></button>\n                <button class=\"minimal\" onclick=\"deleteMarkup()\" style=\"width:50px\"><i class=\"fa fa-trash-o\"></i></button>\n            </td>\n            <td>\n                <div id=\"divMarkupEdit\" style=\"display:none; width:600px\">\n                    <fieldset>\n                        <legend>Markup Unit Settings :</legend>\n                        <input id=\"hfMarkupId\" type=\"hidden\" />\n                        <label>Markup Name : </label><br/>\n                        <input id=\"txtMarkupName\" style=\"width:240px\"/><br/><br/>\n                        <label>Markup Text : (Hit F11 Key to fullscreen the editor) </label><br/>\n                        <textarea id=\"txtMarkupText\" spellcheck='false' style=\"width:80%; height:200px;\"></textarea>\n                        <br/><br/>\n                        <span style=\"float:right; margin-right:100px\">\n                            <button class=\"minimal\" onclick=\"saveMarkup()\"><i class=\"fa fa-save\"></i> Save</button>\n                            <button class=\"minimal\" onclick=\"$('#divMarkupEdit').hide();\"><i class=\"fa fa-ban\"></i> Cancel</button>\n                        </span>\n                    </fieldset>\n                </div>\n            </td>\n        </tr>\n    </table>\n</div>\n\n<div id=\"divAbout\" style=\"display:none\">\n    <h3>About Library Unit Management</h3>\n\n    <p>\n        Unit Libraries are 'units' of javascript or html markup which you can store within the database to be recalled (imported) within other programs.  \n        This functionality is meant to allow hosted/appcached installations a degree of expandibility and reusability since you cannot alter the \n        main page to add new scripts.\n    </p>\n\n    <p>\n        This Utility Program provides a user interface to help manage these Script and Markup Unit Libraries.  \n        You might use this to quickly paste the contents of a javascript file and save it to the library.\n    </p> \n\n    <p>To utilize a stored script unit library you can use the API function <b>API_ImportScriptUnit(unitName)</b> \n        to import a script unit into an invisible container whose purpose it solely for adding scripts to.  The clearFirst \n        param will determine if you are replacing or appending, however most javascript libraries will \n        'linger' throughout the page load since the variables and functions they define are subject to the \n        same behavior as what prompted the EVT_CleanSandbox and stub variable process defined in 'How to be a good Trident \n        Sandbox Citizen' in the Help files.   This is usually not a big concern other than awareness of affects it might have \n        on other programs run within the same 'page load'.\n    </p>\n\n    <p>Markup Units are a little different, and you might use them to store fragments of html to use as a \n        sort of 'User Control'.   These units/fragments can be imported as text (for you to manually add), using \n        the API function <b>API_GetMarkupUnit(unitName, callback)</b> where your callback is passed a string containing \n        the markup text.  From there you can set the dump the HTML into a div container within your program (such as <i>$(\"#myDiv\").html(markupString);</i> )\n    </p>\n\n    <p><b><i>Obsolete / Compatibility Warning</i></b>\n        The other markup API function <b>API_ImportMarkupUnit(unitName, clearFirst)</b> is somewhat obsolete.  \n        It only works if you use 'Run' and not 'Launch' in new window.  The Launch in new window functionality has no tabs \n        at all and allows you full control over the page layout therefore any attempts to 'Import' it will \n        not do anything since there is no Log (HTML) tab.  You might instead utilized a paged-view approach similar to this app \n        with a menu to swap between 'pages' (divs) and dump your html into one of those divs using the API_GetMarkupUnit function.  \n    </p>\n</div>\n\n",
  "scriptText": "// Recommended practice is to place variables in this object and then delete in cleanup\nvar sbv = {\n    myVar : null,\n    myVar2 : 2,\n    editorJS : null,\n    editorMarkup : null\n};\n\nsandbox.events.clean = function () {\n    delete sbv.myVar;\n    delete sbv.myVar2;\n};\n\nfunction initEditors() {\n    sbv.editorJS = CodeMirror.fromTextArea(document.getElementById(\"txtScriptText\"), {\n        smartIndent: true,\n        indentUnit: 4,\n        tabSize: 4,\n        lineNumbers: true,\n        theme: \"pastel-on-dark\",\n        mode: \"javascript\",\n        foldGutter: true,\n        gutters: [\"CodeMirror-linenumbers\", \"CodeMirror-foldgutter\"],\n        extraKeys: {\n            \"Ctrl-Q\": function(cm) { \n                cm.foldCode(cm.getCursor()); \n            },\n            \"F11\": function(cm) {\n                cm.setOption(\"fullScreen\", !cm.getOption(\"fullScreen\"));\n            },\n            \"Esc\": function(cm) {\n                if (cm.getOption(\"fullScreen\")) cm.setOption(\"fullScreen\", false);\n            }\n        }\n    });\n    \n    sbv.editorMarkup = CodeMirror.fromTextArea(document.getElementById(\"txtMarkupText\"), {\n        smartIndent: true,\n        indentUnit: 4,\n        tabSize: 4,\n        lineNumbers: true,\n        theme: \"pastel-on-dark\",\n        mode: \"htmlmixed\",\n        foldGutter: true,\n        gutters: [\"CodeMirror-linenumbers\", \"CodeMirror-foldgutter\"],\n        extraKeys: {\n            \"Ctrl-Q\": function(cm) { \n                cm.foldCode(cm.getCursor()); \n            },\n            \"F11\": function(cm) {\n                cm.setOption(\"fullScreen\", !cm.getOption(\"fullScreen\"));\n            },\n            \"Esc\": function(cm) {\n                if (cm.getOption(\"fullScreen\")) cm.setOption(\"fullScreen\", false);\n            }\n        }\n    });\n    \n}\n\nfunction fitEditors() {\n    \n}\n\ninitEditors();\n\nfunction showDiv(divIndex) {\n    $(\"#divHome\").hide();\n    $(\"#divScript\").hide();\n    $(\"#divMarkup\").hide();\n    $(\"#divAbout\").hide();\n\n    switch(divIndex) {\n        case 1: $(\"#divHome\").show(); break;\n        case 2: $(\"#divScript\").show(); break;\n        case 3: $(\"#divMarkup\").show(); break;\n        case 4: $(\"#divAbout\").show(); break;\n    }\n}\n\nfunction loadMarkupUnits()\n{\n    $(\"#selMarkupUnits\").empty();\n\n    sandbox.db.getAppKeys(\"SandboxMarkupUnits\", function(result) {\n        for (var idx = 0; idx < result.length; idx++) {\n            $('#selMarkupUnits').append($('<option>', {\n                value: result[idx].id,\n                text: result[idx].key\n            }));          \n        }\n    });\n}\n\nfunction loadScriptUnits()\n{\n    $(\"#selScriptUnits\").empty();\n\n    sandbox.db.getAppKeys(\"SandboxScriptUnits\", function(result) {\n        for (var idx = 0; idx < result.length; idx++) {\n            $('#selScriptUnits').append($('<option>', {\n                value: result[idx].id,\n                text: result[idx].key\n            }));          \n        }\n    });\n}\n\nfunction markupChanged() {\n    var key = $(\"#selMarkupUnits option:selected\").val();\n\n    //sandbox.db.getAppKeyById(parseInt(key), function (result) {\n    //    sbv.editorMarkup.setValue(result.val); //$(\"#txtMarkupText\").val(result.val);\n    //});\n    \n    editMarkup();\n}\n\nfunction addMarkup() {\n    //$(\"#txtMarkupText\").text(\"\");\n    sbv.editorMarkup.setValue(\"\");\n    $(\"#hfMarkupId\").val(\"\");\n    $(\"#divMarkupEdit\").show();\n}\n\nfunction editMarkup() {\n    var objId = $(\"#selMarkupUnits option:selected\").val();\n\n    $(\"#divMarkupEdit\").show();\n    sandbox.db.getAppKeyById(parseInt(objId), function (result) {\n\n        $(\"#hfMarkupId\").val(objId);\n        //$(\"#txtMarkupText\").text(result.val);\n        sbv.editorMarkup.setValue(result.val);\n        $(\"#txtMarkupName\").val(result.key);\n        \n        sbv.editorMarkup.refresh();\n    });\n}\n\nfunction deleteMarkup() {\n    var objId = $(\"#selMarkupUnits option:selected\").val();\n\n    alertify.confirm(\"Are you sure you want to delete this markup unit?\", function (e) {\n        if (e) {\n\n            sandbox.db.DeleteAppKey(parseInt(objId), function(result) {\n                if (result) {\n                    loadMarkupUnits();\n                    $(\"#divMarkupEdit\").hide();\n                }\n                else {\n                    alertify.log(\"Error deleting markup unit\");\n                }\n            });\n        } \n    });\n}\n\nfunction saveMarkup() {\n    var key = $(\"#hfMarkupId\").val();\n\n    var markupName = $(\"#txtMarkupName\").val();\n    var markupText = sbv.editorMarkup.getValue(); //$(\"#txtMarkupText\").text();\n\n    if (markupName === \"\") {\n        alertify.error(\"Markup Name is required\");\n        return;\n    }\n\n    sandbox.db.setAppKey(\"SandboxMarkupUnits\", markupName, markupText, function(result) {\n        if (result.success) {\n            loadMarkupUnits();\n            $(\"#divMarkupEdit\").hide();\n        }\n        else {\n            alert(\"error calling SetKey()\");\n        }\n    });\n\n}\n\nfunction scriptChanged() {\n    $('#divScriptEdit').hide();\n    \n    editScript();\n}\n\nfunction addScript() {\n    //$(\"#txtScriptText\").text(\"\");\n    sbv.editorJS.setValue(\"\");\n    $(\"#hfScriptId\").val(\"\");\n    $(\"#divScriptEdit\").show();\n}\n\nfunction editScript() {\n    var objId = $(\"#selScriptUnits option:selected\").val();\n    $(\"#divScriptEdit\").show();\n\n    sandbox.db.getAppKeyById(parseInt(objId), function (result) {\n        $(\"#hfScriptId\").val(objId);\n        //$(\"#txtScriptText\").text(result.val);\n        sbv.editorJS.setValue(result.val);\n        $(\"#txtScriptName\").val(result.key);\n        \n        sbv.editorJS.refresh();\n    });\n}\n\nfunction deleteScript() {\n    var objId = $(\"#selScriptUnits option:selected\").val();\n\n    alertify.confirm(\"Are you sure you want to delete this script unit?\", function (e) {\n        if (e) {\n\n            sandbox.db.deleteAppKey(parseInt(objId), function(result) {\n                if (result) {\n                    loadScriptUnits();\n                    $(\"#divScriptEdit\").hide();\n                }\n                else {\n                    alertify.log(\"Error deleting markup unit\");\n                }\n            });\n        } \n    });\n}\n\nfunction saveScript() {\n    var key = $(\"#hfScriptId\").val();\n\n    var scriptName = $(\"#txtScriptName\").val();\n    var scriptText = sbv.editorJS.getValue(); //$(\"#txtScriptText\").text();\n\n    if (scriptName === \"\") {\n        alertify.error(\"Script Name is required\");\n        return;\n    }\n\n    sandbox.db.setAppKey(\"SandboxScriptUnits\", scriptName, scriptText, function(result) {\n        if (result.success) {\n            loadScriptUnits();\n            $(\"#divScriptEdit\").hide();\n        }\n        else {\n            alert(\"error calling SetKey()\");\n        }\n    });\n}\n\nloadMarkupUnits();\nloadScriptUnits();"
}