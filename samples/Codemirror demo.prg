{
  "progName": "Codemirror demo",
  "htmlText": "<h3>Codemirror demo</h3>\n\n<div id=\"divEditors\">\n<p>Javascript (F11 for fullscreen) : </p>\n\n<button class=\"minimal\" onclick=\"setJS()\">Set</button>\n<button class=\"minimal\" onclick=\"getJS()\">Get</button><br/>\n\n<textarea id=\"jsedit\"></textarea><br/>\n\n\n</div>",
  "scriptText": "// Recommended practice is to place variables in this object and then delete in cleanup\nvar sbv = {\n    editorJS : null,\n    editorCS : null\n}\n\nsandbox.events.clean = function() {\n\t$(\"#divEditors\").empty();\n\tdelete sbv.editorJS;\n    delete sbv.editorCS;\n}\n\nfunction setJS() {\n\tsbv.editorJS.setValue(\"// some javascript\\r\\nalertify.log('hello');\");\n}\n\nfunction getJS() {\n\tsandbox.logger.log(sbv.editorJS.getValue());\n}\n\nfunction setupEditors() {\n\t\n    // To change language try the following modes :\n    // \t'clike'\t: for generic 'c' like code\n    //\t\t'text/x-csharp'\t: for csharp\n    //\t\t'text/x-java'\t: for java\n    //\t\t'text/x-c++src' : for c++\n    //\t\t'text/x-csrc' : for specifically c\n    //\t'htmlmixed', 'css', 'xml', 'markdown', 'dtd', 'coffeescript', \n    //\t'python', 'cypher' are other main modes i have script-linked in\n\n\t// This example includes code folding, themes, and hotkeys\n\tsbv.editorJS = CodeMirror.fromTextArea(document.getElementById(\"jsedit\"), {\n\t\t\tsmartIndent: false,\n\t\t\tlineNumbers: true,\n\t\t\ttheme: \"pastel-on-dark\",\n\t\t\tmode: \"javascript\",\n\t\t\tfoldGutter: true,\n\t\t\tgutters: [\"CodeMirror-linenumbers\", \"CodeMirror-foldgutter\"],\n\t\t\textraKeys: {\n\t\t\t\t\"Ctrl-Q\": function(cm) { \n\t\t\t\t\tcm.foldCode(cm.getCursor()); \n\t\t\t\t},\n\t\t\t\t\"F11\": function(cm) {\n\t\t\t\t\tcm.setOption(\"fullScreen\", !cm.getOption(\"fullScreen\"));\n\t\t\t\t},\n\t\t\t\t\"Esc\": function(cm) {\n\t\t\t\t\tif (cm.getOption(\"fullScreen\")) cm.setOption(\"fullScreen\", false);\n\t\t\t\t}\n\t\t\t}\n\t});\n}\n\nsetupEditors();\n"
}