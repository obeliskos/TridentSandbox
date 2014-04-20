{
  "progName": "nicEdit demo",
  "htmlText": "<textarea rows='10' cols='80' style=\"width:'600px'; height:'300px'\" id=\"area1\"></textarea>\n\n<button onclick=\"getEditorText()\">Get Text</button>\n<button onclick=\"setEditorText()\">Set Text</button>",
  "scriptText": "var area1var = new nicEditor({fullPanel : true}).panelInstance('area1');\n\n\nfunction getEditorText() {\n\tvar nicE = new nicEditors.findEditor('area1');\n\tvar htmlEditText = nicE.getContent();\n  \n  \tAPI_LogMessage(htmlEditText);\n}\n\nfunction setEditorText() {\n\tvar nicE = new nicEditors.findEditor('area1');\n\tvar htmlSceneText = nicE.setContent(\"Hello nicEdit control!\");\n}"
}