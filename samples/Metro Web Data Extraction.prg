{
  "progName": "Metro Web Data Extraction",
  "htmlText": "<h1 style=\"padding-left:30px; text-shadow: 0px 0px 5px rgba(0,0,0,0.75); color:#FFFF99;\">Web Data Extraction Demo</h1>\n<span style=\"display:none; color:black; font-size:22px\" id=\"spnNotSupportedWarning\">This demo may require the 'Making Internet Requests' workaround described in help when using hosted or appcache version.<br/><br/></span>\n<div class=\"tiles red\" style=\"padding-left:30px\">\n    <div id=\"tileCam\" class=\"live-tile two-wide two-tall\" data-speed=\"750\" data-delay=\"3000\">\n        \n        <div><span class=\"tile-title\">Stadt Ettingen Markplatz</span><img class=\"full\" src=\"http://service.ka-news.de/camimage.php?cam=16\" alt=\"1\" /></div>\n        <div><span class=\"tile-title\">Puerto Vallarta, Jalisco</span><img class=\"full\" src=\"http://webcamsdemexico.net/puertovallarta1/live.jpg\" alt=\"2\" /></div>\n    </div>\n    <div class=\"live-tile cobalt two-wide\" id=\"tile4\" data-direction=\"horizontal\" data-mode=\"flip\">     \n      \t<div ><span id='spnWeather-front'>Loading...</span>\n              <span class=\"tile-title\">NOAA Weather Info</span>\n        </div>\n        <div>\n            <p><span id='spnWeather-back'>Loading...</span>\n               <span class=\"tile-title\"></span>\n            </p>\n        </div>\n    </div>\n    <div class=\"live-tile\" data-speed=\"750\" data-delay=\"3000\">\n        <span class=\"tile-title\">usno navy moon phase</span>\n        <div><img class=\"full\" src=\"http://api.usno.navy.mil/imagery/moon.png?sequence=1\" alt=\"1\" /></div>\n        <div><img class=\"full\" src=\"http://api.usno.navy.mil/imagery/moon.png?sequence=1\" alt=\"2\" /></div>\n    </div>\n    <div class=\"live-tile\" id=\"tile1\" data-mode=\"flip\">        \n        <div>\n            <a class=\"full\" href=\"#\">front</a>\n            <span class=\"tile-title\">front title</span>\n        </div>\n        <div>\n            <p>this tile flips once vertically when clicked using a repeat count of 0</p>\n            <span class=\"tile-title\">back title</span>\n        </div>\n    </div>\n    <div class=\"live-tile blue\" id=\"tile2\" data-direction=\"horizontal\" data-mode=\"flip\">     \n        <div>front\n              <span class=\"tile-title\">front title</span>\n        </div>\n        <div>\n            <p>this tile flips horizontally on an interval or when when clicked\n               <span class=\"tile-title\">back title</span>\n            </p>\n        </div>\n    </div>\n   <div class=\"live-tile green\" id=\"tile3\" data-direction=\"horizontal\" data-mode=\"flip\">     \n     <div><span id='spnIP-front'>Loading...</span>\n              <span class=\"tile-title\">DynDns Ip Checker</span>\n        </div>\n        <div>\n          <p><span id='spnIP-back'>Loading...</span>\n               <span class=\"tile-title\">DynDns Ip Checker</span>\n            </p>\n        </div>\n    </div>\n</div>\n\n<!-- Table used to fill out parent divs so main output tab is big enough to hold tiles -->\n<table height='400px'></table>",
  "scriptText": "// The first 250 chars let you specify FLAG directives\n// The following appears to be a comment but it is actually a flag directive\n// to start the app in fullscreen mode.\n\n// F LAG_StartPrgFullscreen (Delete space between f and l to activate)\n\nAPI_SetBackgroundColor(\"#787\");\n\nvar sandboxVars = {\n  autoCheck: null\n}\n\nfunction EVT_CleanSandbox() {\n\tclearInterval(sandboxVars.autoCheck);\n  \tstopTiles();\n    EVT_CleanSandbox = null;\n}\n\nif (VAR_TRIDENT_ONLINE && !VAR_TRIDENT_HOSTED) {\n\t// 900000 delay is equal to every 15mins\n\tsandboxVars.autoCheck =  setInterval(function(){ refreshTiles() }, 900000);\n\n\trefreshTiles();\n}\nelse {\n  $(\"#spnNotSupportedWarning\").show();\n}\n\nfunction stopTiles()\n{\n  $tile1.liveTile('stop');\n  $tile2.liveTile('stop');\n  $tile4.liveTile('stop');\n  $tileCam.liveTile('stop');\n}\n\nvar $tileCam = $(\"#tileCam\").liveTile();\n\n//animate on click\nvar $tile1 = $(\"#tile1\").liveTile({ repeatCount: 0, delay:0 });\n$(\"#tile1\").click(function(){\n    $(this).liveTile('play');\n    alertify.log(\"tile 1 clicked\");\n});\n\nvar $tile2 = $(\"#tile2\").liveTile();\n$(\"#tile2\").on(\"click\", function(){\n    $(\"#tile2\").liveTile(\"play\", 0);\n  \talertify.log(\"tile 2 clicked\");\n});\n\n//var $tile3 = $(\"#tile3\").liveTile( { delay: 4000 } );\n//$(\"#tile3\").on(\"click\", function(){\n//    $(\"#tile3\").liveTile(\"play\", 0);\n//  \talertify.log(\"tile 3 clicked\");\n//});\n\nvar $tile4 = $(\"#tile4\").liveTile( { delay: 4000 } );\n$(\"#tile4\").on(\"click\", function(){\n    $(\"#tile3\").liveTile(\"play\", 0);\n  \talertify.log(\"tile 4 clicked\");\n});\n\n// No need to refresh this every 15 so ill keep it outside the timer loop\nrefreshIP();\nrefreshWeatherTile();\n\nfunction refreshTiles() \n{\n  API_LogMessage(\"RefreshingTiles\");\n  \n  refreshWeatherTile();\n}\n\nfunction refreshIP()\n{\n  \tvar ipurl =\"http://checkip.dyndns.com/\";\n  \t\n\t$.ajax({\n  \t\turl: ipurl,\n  \t\t//cache: false,    \n  \t\tsuccess: function(data){\n\t\t\t$(\"#spnIP-front\").html($(data)[1].data);\n\t\t\t$(\"#spnIP-back\").html($(data)[1].data);\n  \t\t}\n\t});\t\n}\n\n// In this function we will make heavy use of jQuery selectors to 'query' the html\n// returned from our ajax request.  Our ability to query this is based on looking at the\n// source code of the page and seeing how it is laid out.  Ideally they would flag \n// each important field with a unique id or attribute we could query on but sometimes\n// you have to just look for sections and then within that section for other sections, etc.\nfunction refreshWeatherTile()\n{\n  \tvar wxurl =\"http://forecast.weather.gov/MapClick.php?lat=33.4483771&lon=-112.07403729999998&site=all&smap=1&searchresult=Phoenix%2C%20AZ%2C%20USA\";\n \n\t$.ajax({\n  \t\turl: wxurl,\n  \t\tcache: false,\n        error: function(xhr, status, err) {\n          \t$(\"#spnWeather-front\").html(err);\n        },\n  \t\tsuccess: function(data){\n\t\t\tvar currentdate = new Date(); \n\t\t\tvar options = {\n    \t\t\t\tweekday: \"long\", year: \"numeric\", month: \"short\",\n\t\t\t\tday: \"numeric\", hour: \"2-digit\", minute: \"2-digit\"\n\t\t\t};\n\n\t\t\tAPI_LogMessage(\"Last Check : \" + currentdate.toLocaleTimeString(\"en-us\", options));\n\n          \t// search for area displaying location name\n          \t//var locText = $(data).find(\"div .three-fifth-first\")[1].innerText;\n\t\t\tvar locText = $($(data).find(\"div .three-fifth-first\")[1]).find(\"h1\")[0].innerText;\n          \t//locText = locText.substring(0,25);\n          \n          \tvar area1 = $(data).find(\"div .div-half-right\").find(\"p\");\n          \n          \tvar cond = area1[0].innerHTML;\n          \tvar tempF = area1[1].innerHTML;\n          \tvar tempC = $(area1[2]).find(\"span\")[0].innerHTML;\n\n          \t$(\"#spnWeather-front\").html(locText + \"<br/><br/>\" + \"<strong>\" + cond + \"</strong>\" + \"<br/>\" + tempF + \"<br/>\" + tempC);\n\n          \t//debugger;\n          \tvar tileBackText = \"\";\n          \tvar area2 = $(data).find(\"div .one-third-first\")[1];\n          \tvar area2items = $(area2).find(\"li\");\n          \tfor(i=0; i<area2items.length; i++) {\n              \tvar elem = $(area2items[i]);\n              \tvar elemSpan = $(elem).find(\"span\");\n              \n              \tvar detailName = elemSpan[0].innerText;\n              \tvar detailVal = elem[0].innerHTML.replace(elemSpan[0].outerHTML, \"\");\n              \n              \ttileBackText += detailName + \":\" + detailVal + \"<br/>\";\n          \t}\n          \n\t\t\t$(\"#spnWeather-back\").html(\"<font size=3>\" + tileBackText + \"</font>\");\n  \t\t}\n\t});\t\n}"
}