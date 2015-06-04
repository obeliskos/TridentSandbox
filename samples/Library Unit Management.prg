{
  "progName": "Library Unit Management",
  "htmlText": "<style>\nselect.unitlist  {\n\twidth:100%;\n    font-size:20px;\n}\n\nfieldset { \n\tpadding: 1em;\n    font:80%/1 sans-serif;\n\tborder:1px solid black; \n}\nlabel.lb4 {\n\tfloat:left;\n    width:15%;\n    margin-right:0.5em;\n    padding-top:0.2em;\n    text-align:right;\n    font-weight:bold;\n}\n\nlegend {\n    padding: 0.2em 0.5em;\n    border:1px solid black;\n    color:black;\n    font-size:90%;\n    text-align:right;\n}\n\n</style>\n\n<ul class=\"tnavlist\">\n<li class=\"tnavli\"><a class=\"tnava\" onclick=\"showDiv(1);\" href=\"javascript:void(0)\"><i class=\"fa fa-home\"></i> Home</a></li>\n<li class=\"tnavli\"><a class=\"tnava\" onclick=\"showDiv(2);\" href=\"javascript:void(0)\"><i class=\"fa fa-code-fork\"></i> Script</a></li>\n<li class=\"tnavli\"><a class=\"tnava\" onclick=\"showDiv(3);\" href=\"javascript:void(0)\"><i class=\"fa fa-html5\"></i> Markup</a></li>\n<li class=\"tnavli\"><a class=\"tnava\" onclick=\"showDiv(4);\" href=\"javascript:void(0)\"><i class=\"fa fa-info-circle\"></i> About</a></li>\n</ul>\n\n\n<div id=\"divHome\">\n\t<h3>Welcome to the Library Unit Management Utility<h3>\n    \n    <p>Please select Script or Markup from the menu to administer those respective \n    Unit Libraries.</p>\n    \n</div>\n\n<div id=\"divScript\" style=\"display:none\">\n<h3>Script Units</h3>\n\t<table width='100%'>\n        <tr valign='top'>\n            <td>\n            \t<select id=\"selScriptUnits\" size=7 class=\"unitlist\" onchange=\"scriptChanged()\"></select>\n            </td>\n            <td width=\"140px\">\n            \t<button class=\"minimal\" onclick=\"addScript()\"><i class=\"fa fa-plus\"></i> Add</button><br/><br/>\n            \t<button class=\"minimal\" onclick=\"editScript()\"><i class=\"fa fa-pencil-square-o\"></i> Edit</button><br/><br/>\n            \t<button class=\"minimal\" onclick=\"deleteScript()\"><i class=\"fa fa-trash-o\"></i> Delete</button><br/>\n            </td>\n        </tr>\n    </table>\n    <br/>\n    <div id=\"divScriptEdit\" style=\"display:none\">\n    \t<fieldset>\n            <legend>Script Unit Settings :</legend>\n            <i>(Note: If you name a script <b>autorun</b> it will run on page load unless a <b>SkipAutorun</b> hash param is added)</i><br/><br/>\n            <input id=\"hfScriptId\" type=\"hidden\" />\n        \t<label class=\"lb4\" for=\"txtScriptName\">Script Name : </label>\n            <input id=\"txtScriptName\" style=\"width:240px\"/>&nbsp;<br/><br/>\n        \t<label class=\"lb4\" for=\"txtScriptText\">Script Text : </label>\n            <textarea id=\"txtScriptText\" spellcheck='false' style=\"width:80%; height:200px;\"></textarea>\n            <br/><br/>\n        \t<span style=\"float:right; margin-right:100px\">\n\t            <button class=\"minimal\" onclick=\"saveScript()\"><i class=\"fa fa-save\"></i> Save</button>\n    \t        <button class=\"minimal\" onclick=\"$('#divScriptEdit').hide();\"><i class=\"fa fa-ban\"></i> Cancel</button>\n            </span>\n        </fieldset>\n    </div>\n</div>\n\n<div id=\"divMarkup\" style=\"display:none\">\n<h3>Markup Units</h3>\n\t<table width='100%'>\n    \t<tr valign='top'>\n        \t<td>\n            \t<select id=\"selMarkupUnits\" size=7 class=\"unitlist\" onchange=\"markupChanged()\"></select>\n            </td>\n            <td width='140px'>\n            \t<button class=\"minimal\" onclick=\"addMarkup()\"><i class=\"fa fa-plus\"></i> Add</button><br/><br/>\n            \t<button class=\"minimal\" onclick=\"editMarkup()\"><i class=\"fa fa-pencil-square-o\"></i> Edit</button><br/><br/>\n\t\t\t\t<button class=\"minimal\" onclick=\"deleteMarkup()\"><i class=\"fa fa-trash-o\"></i> Delete</button>\n            </td>\n\t\t</tr>\n\t</table>\n    \n    <br/>\n    \n    <div id=\"divMarkupEdit\" style=\"display:none\">\n    \t<fieldset>\n            <legend>Markup Unit Settings :</legend>\n            <input id=\"hfMarkupId\" type=\"hidden\" />\n        \t<label class=\"lb4\" for=\"txtMarkupName\">Markup Name : </label>\n            <input id=\"txtMarkupName\" style=\"width:240px\"/><br/><br/>\n        \t<label class=\"lb4\" for=\"txtMarkupText\">Markup Text : </label>\n            <textarea id=\"txtMarkupText\" spellcheck='false' style=\"width:80%; height:200px;\"></textarea>\n            <br/><br/>\n        \t<span style=\"float:right; margin-right:100px\">\n\t            <button class=\"minimal\" onclick=\"saveMarkup()\"><i class=\"fa fa-save\"></i> Save</button>\n    \t        <button class=\"minimal\" onclick=\"$('#divMarkupEdit').hide();\"><i class=\"fa fa-ban\"></i> Cancel</button>\n            </span>\n        </fieldset>\n    </div>\n</div>\n\n<div id=\"divAbout\" style=\"display:none\">\n<h3>About Library Unit Management</h3>\n\n<p>\nUnit Libraries are 'units' of javascript or html markup which you can store within the database to be recalled (imported) within other programs.  \nThis functionality is meant to allow hosted/appcached installations a degree of expandibility and reusability since you cannot alter the \nmain page to add new scripts.\n</p>\n\n<p>\nThis Utility Program provides a user interface to help manage these Script and Markup Unit Libraries.  \nYou might use this to quickly paste the contents of a javascript file and save it to the library.\n</p> \n\n<p>To utilize a stored script unit library you can use the API function <b>API_ImportScriptUnit(unitName)</b> \nto import a script unit into an invisible container whose purpose it solely for adding scripts to.  The clearFirst \nparam will determine if you are replacing or appending, however most javascript libraries will \n'linger' throughout the page load since the variables and functions they define are subject to the \nsame behavior as what prompted the EVT_CleanSandbox and stub variable process defined in 'How to be a good Trident \nSandbox Citizen' in the Help files.   This is usually not a big concern other than awareness of affects it might have \non other programs run within the same 'page load'.\n</p>\n\n<p>Markup Units are a little different, and you might use them to store fragments of html to use as a \nsort of 'User Control'.   These units/fragments can be imported as text (for you to manually add), using \nthe API function <b>API_GetMarkupUnit(unitName, callback)</b> where your callback is passed a string containing \nthe markup text.  From there you can set the dump the HTML into a div container within your program (such as <i>$(\"#myDiv\").html(markupString);</i> )\n</p>\n\n<p><b><i>Obsolete / Compatibility Warning</i></b>\nThe other markup API function <b>API_ImportMarkupUnit(unitName, clearFirst)</b> is somewhat obsolete.  \nIt only works if you use 'Run' and not 'Launch' in new window.  The Launch in new window functionality has no tabs \nat all and allows you full control over the page layout therefore any attempts to 'Import' it will \nnot do anything since there is no Log (HTML) tab.  You might instead utilized a paged-view approach similar to this app \nwith a menu to swap between 'pages' (divs) and dump your html into one of those divs using the API_GetMarkupUnit function.  \n</p>\n</div>\n\n",
  "scriptText": "// Recommended practice is to place variables in this object and then delete in cleanup\nvar sbv = {\n    myVar : null,\n    myVar2 : 2\n};\n\nsandbox.events.clean = function () {\n    delete sbv.myVar;\n    delete sbv.myVar2;\n};\n\nfunction showDiv(divIndex) {\n    $(\"#divHome\").hide();\n    $(\"#divScript\").hide();\n    $(\"#divMarkup\").hide();\n    $(\"#divAbout\").hide();\n\n    switch(divIndex) {\n        case 1: $(\"#divHome\").show(); break;\n        case 2: $(\"#divScript\").show(); break;\n        case 3: $(\"#divMarkup\").show(); break;\n        case 4: $(\"#divAbout\").show(); break;\n    }\n}\n\nfunction loadMarkupUnits()\n{\n    $(\"#selMarkupUnits\").empty();\n\n    sandbox.db.getAppKeys(\"SandboxMarkupUnits\", function(result) {\n        for (var idx = 0; idx < result.length; idx++) {\n            $('#selMarkupUnits').append($('<option>', {\n                value: result[idx].id,\n                text: result[idx].key\n            }));          \n        }\n    });\n}\n\nfunction loadScriptUnits()\n{\n    $(\"#selScriptUnits\").empty();\n\n    sandbox.db.getAppKeys(\"SandboxScriptUnits\", function(result) {\n        for (var idx = 0; idx < result.length; idx++) {\n            $('#selScriptUnits').append($('<option>', {\n                value: result[idx].id,\n                text: result[idx].key\n            }));          \n        }\n    });\n}\n\nfunction markupChanged() {\n    var key = $(\"#selMarkupUnits option:selected\").val();\n\n    sandbox.db.getAppKeyById(parseInt(key), function (result) {\n        $(\"#txtMarkupText\").val(result.val);\n    });\n}\n\nfunction addMarkup() {\n    $(\"#txtMarkupText\").text(\"\");\n    $(\"#hfMarkupId\").val(\"\");\n    $(\"#divMarkupEdit\").show();\n}\n\nfunction editMarkup() {\n    var objId = $(\"#selMarkupUnits option:selected\").val();\n\n    sandbox.db.getAppKeyById(parseInt(objId), function (result) {\n        $(\"#hfMarkupId\").val(objId);\n        $(\"#txtMarkupText\").val(result.val);\n        $(\"#txtMarkupName\").val(result.key);\n\n        $(\"#divMarkupEdit\").show();\n    });\n}\n\nfunction deleteMarkup() {\n    var objId = $(\"#selMarkupUnits option:selected\").val();\n\n    alertify.confirm(\"Are you sure you want to delete this markup unit?\", function (e) {\n        if (e) {\n\n            sandbox.db.DeleteAppKey(parseInt(objId), function(result) {\n                if (result) {\n                    loadMarkupUnits();\n                    $(\"#divMarkupEdit\").hide();\n                }\n                else {\n                    alertify.log(\"Error deleting markup unit\");\n                }\n            });\n        } \n    });\n}\n\nfunction saveMarkup() {\n    var key = $(\"#hfMarkupId\").val();\n\n    var markupName = $(\"#txtMarkupName\").val();\n    var markupText = $(\"#txtMarkupText\").text();\n\n    if (markupName === \"\") {\n        alertify.error(\"Markup Name is required\");\n        return;\n    }\n\n    sandbox.db.setAppKey(\"SandboxMarkupUnits\", markupName, markupText, function(result) {\n        if (result.success) {\n            loadMarkupUnits();\n            $(\"#divMarkupEdit\").hide();\n        }\n        else {\n            alert(\"error calling SetKey()\");\n        }\n    });\n\n}\n\nfunction scriptChanged() {\n    $('#divScriptEdit').hide();\n}\n\nfunction addScript() {\n    $(\"#txtScriptText\").text(\"\");\n    $(\"#hfScriptId\").val(\"\");\n    $(\"#divScriptEdit\").show();\n}\n\nfunction editScript() {\n    var objId = $(\"#selScriptUnits option:selected\").val();\n\n    sandbox.db.getAppKeyById(parseInt(objId), function (result) {\n        $(\"#hfScriptId\").val(objId);\n        $(\"#txtScriptText\").val(result.val);\n        $(\"#txtScriptName\").val(result.key);\n\n        $(\"#divScriptEdit\").show();\n    });\n}\n\nfunction deleteScript() {\n    var objId = $(\"#selScriptUnits option:selected\").val();\n\n    alertify.confirm(\"Are you sure you want to delete this script unit?\", function (e) {\n        if (e) {\n\n            sandbox.db.deleteAppKey(parseInt(objId), function(result) {\n                if (result) {\n                    loadScriptUnits();\n                    $(\"#divScriptEdit\").hide();\n                }\n                else {\n                    alertify.log(\"Error deleting markup unit\");\n                }\n            });\n        } \n    });\n}\n\nfunction saveScript() {\n    var key = $(\"#hfScriptId\").val();\n\n    var scriptName = $(\"#txtScriptName\").val();\n    var scriptText = $(\"#txtScriptText\").text();\n\n    if (scriptName === \"\") {\n        alertify.error(\"Script Name is required\");\n        return;\n    }\n\n    sandbox.db.SetAppKey(\"SandboxScriptUnits\", scriptName, scriptText, function(result) {\n        if (result.success) {\n            loadScriptUnits();\n            $(\"#divScriptEdit\").hide();\n        }\n        else {\n            alert(\"error calling SetKey()\");\n        }\n    });\n}\n\nloadMarkupUnits();\nloadScriptUnits();"
}