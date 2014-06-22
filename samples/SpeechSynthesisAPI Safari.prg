{
  "progName": "SpeechSynthesisAPI Safari",
  "htmlText": "<h3>Speech Synthesis API Demo</h3>\n\n<h4>Enter text to speak here (works only with IOS7/Opera/Safari at the moment) :</h4>\n<textarea id=\"txtMessage\" rows='14' cols='120'>Hello Speech API</textarea>\n<br/><br/>\n<button class=\"download-itunes\" style=\"height:34px\" onclick=\"speak()\">Speak</button>",
  "scriptText": "function speak() {\n\tvar msgText = $(\"#txtMessage\").val();\n    \n    alertify.log(msgText);\n    \n\tvar msg = new SpeechSynthesisUtterance(msgText);\n\twindow.speechSynthesis.speak(msg);\n}"
}