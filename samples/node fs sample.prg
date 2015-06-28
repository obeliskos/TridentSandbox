{
  "progName": "node fs sample",
  "htmlText": "<h3>Node Filesystem Module Sample</h3>\n\n<p>\n    The node 'fs' module is far too extensive to adequately demonstrate in this sample so this sample will just show a few capabilities.\n</p>\n\n<h4>\n    Read contents of Kheiron root directory\n</h4>\n\n<select size=8 onclick=\"readFile()\" id=\"select-files\" onselect=\"viewFile\"></select>\n\n<textarea id=\"txt-filecontents\" rows=8 cols=60></textarea>",
  "scriptText": "sandbox.ide.setWindowMode(2);\n\nvar nwgui = require(\"nw.gui\");\nvar fs = require(\"fs\");\nvar path = require(\"path\");\nvar cwd = process.cwd();\n\nfs.readdir(cwd, function(err, files) {\n    $(\"#select-files\").html(\"\");\n\n    files.forEach(function(entry) {\n        var absPath = path.join(cwd, entry);\n        var isFile = fs.statSync(absPath).isFile();\n\n        if (isFile) {\n            $(\"#select-files\").append($(\"<option></option>\").attr(\"value\", entry).text(entry));\n        }\n    });\n});\n\nfunction readFile()\n{\n    var absPath = path.join(cwd, $(\"#select-files\").val());\n\n    $(\"#txt-filecontents\").text(\"\");\n\n    fs.readFile(absPath, function (err, data) {\n        if (err) throw err;\n        $(\"#txt-filecontents\").text(data);\n    });    \n}\n"
}