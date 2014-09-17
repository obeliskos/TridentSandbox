{
  "progName": "MetroJS Demo",
  "htmlText": "<img onmouseover=\"this.style.opacity=0.6;\" onmouseout=\"this.style.opacity=1.0;\" onclick=\"API_RestoreLayout()\" src=\"images_ide/metro-back.png\"/>\n<h1>Animate on Click</h1>\n<div class=\"tiles red\">\n    <div class=\"live-tile\" id=\"tile1\" data-mode=\"flip\">        \n        <div>\n            <a class=\"full\" href=\"#\">front</a>\n            <span class=\"tile-title\">front title</span>\n        </div>\n        <div>\n            <p>this tile flips once vertically when clicked using a repeat count of 0</p>\n            <span class=\"tile-title\">back title</span>\n        </div>\n    </div>\n    <div class=\"live-tile  cobalt two-wide\" id=\"tile2\" data-direction=\"horizontal\" data-mode=\"flip\">     \n        <div>front\n              <span class=\"tile-title\">front title</span>\n        </div>\n        <div>\n            <p>this tile flips horizontally on an interval or when when clicked\n               <span class=\"tile-title\">back title</span>\n            </p>\n        </div>\n    </div>\n   <div class=\"live-tile green\" id=\"tile3\" data-direction=\"horizontal\" data-mode=\"flip\">     \n        <div>Trident Sandbox Live Tile Demo\n              <span class=\"tile-title\">Metro.JS Tile Demo</span>\n        </div>\n        <div>\n            <p>this tile flips horizontally on an interval or when when clicked\n               <span class=\"tile-title\">Metro.JS Tile Demo</span>\n            </p>\n        </div>\n    </div>\n   <div class=\"live-tile mango two-wide two-tall\" id=\"tile4\" data-direction=\"horizontal\" data-mode=\"flip\">     \n        <div>Trident Sandbox Live Tile Demo\n              <span class=\"tile-title\">Metro.JS Tile Demo</span>\n        </div>\n        <div>\n            <p>this tile flips horizontally on an interval or when when clicked\n               <span class=\"tile-title\">Metro.JS Tile Demo</span>\n            </p>\n        </div>\n    </div>\n    \n </div>\n\n<!-- Table used to fill out parent divs so main output tab is big enough to hold tiles -->\n<table height='200px'></table>",
  "scriptText": "// The first 250 chars let you specify FLAG directives\n// The following appears to be a comment but it is actually a flag directive\n// to start the app in fullscreen mode.\n\n// F LAG_StartPrgFullscreen\n\nAPI_SetBackgroundColor(\"#cdc\");\n\nfunction EVT_CleanSandbox() {\n  $tile1.liveTile('stop');\n  $tile2.liveTile('stop');\n  $tile3.liveTile('stop');\n  $tile4.liveTile('stop');\n  \n  EVT_CleanSandbox = null;\n}\n\n//animate on click\nvar $tile1 = $(\"#tile1\").liveTile({ repeatCount: 0, delay:0 });\n$(\"#tile1\").click(function(){\n    $(this).liveTile('play');\n    alertify.log(\"tile 1 clicked\");\n});\n\nvar $tile2 = $(\"#tile2\").liveTile();\n$(\"#tile2\").on(\"click\", function(){\n    $(\"#tile2\").liveTile(\"play\", 0);\n  \talertify.log(\"tile 2 clicked\");\n});\n\nvar $tile3 = $(\"#tile3\").liveTile( { delay: 4000 } );\n$(\"#tile3\").on(\"click\", function(){\n    $(\"#tile3\").liveTile(\"play\", 0);\n  \talertify.log(\"tile 3 clicked\");\n});\n\nvar $tile4 = $(\"#tile4\").liveTile( { delay: 3500 } );\n$(\"#tile4\").on(\"click\", function(){\n    $(\"#tile4\").liveTile(\"play\", 0);\n  \talertify.log(\"tile 4 clicked\");\n});\n\n"
}