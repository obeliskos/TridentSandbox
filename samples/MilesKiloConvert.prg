{
  "progName": "MilesKiloConvert",
  "htmlText": "<h3>Convert miles to kilometers</h3>\n\nEnter Number of Miles :\n<input id='txtMiles'></input>\n\n<br/>\n<br/>\n<button id=\"btnCalcKilo\" onclick=\"calcKilo()\">Calculate</button>\n<br/><br/>\n<span id=\"spanKilo\"></span> ",
  "scriptText": "function calcKilo()\n{\n\tvar miles = $(\"#txtMiles\").val();\n\tvar kilo = miles*1.60934;\n\t$(\"#spanKilo\").text(kilo + \" kilometers\");\n}\n"
}