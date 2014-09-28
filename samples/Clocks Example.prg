{
  "progName": "Clocks Example",
  "htmlText": "<!-- IE seems to allow styles here, ideally i would have another css editor -->\n<style>                         /* A CSS stylesheet for the clock */\n#clock {                        /* Style apply to element with id=\"clock\" */\n  font: bold 24pt sans;         /* Use a big bold font */\n  background: #dfd;             /* On a light bluish-gray background */\n  padding: 10px;                /* Surround it with some space */\n  border: solid black 2px;      /* And a solid black border */\n  border-radius: 10px;          /* Round the corners (where supported) */\n}\n</style>\n<h2>Digital Clock</h2>    <!-- Display a title -->\n<div style=\"height:60px\">\n\t<span id=\"clock\"></span>  <!-- The time gets inserted here -->\n</div>\n\n<h2>Analog Clocks (script embedded in external .svg file)</h2>\nLocal :\n<embed src=\"images_ide/local.svg\">\nUTC :\n<embed src=\"images_ide/utc.svg\">",
  "scriptText": "var sandboxVars = {\n  secInterval : null,\n  stopTimer : false\n}\n\ndisplayTime();\n\nfunction EVT_CleanSandbox() {\n    sandboxVars.stopTimer = true;\n\tclearInterval(sandboxVars.secInterval);\n  \n  \tdelete sandboxVars.secInterval;\n  \tdelete sandboxVars.stopTimer;\n}\n\nfunction displayTime() {\n    var elt = document.getElementById(\"clock\");  // Find element with id=\"clock\"\n    var now = new Date();                        // Get current time\n    elt.innerHTML = now.toLocaleTimeString();    // Make elt display it\n\n  \tif (sandboxVars.stopTimer) return;\n  \n  \tsandboxVars.secInterval = setTimeout(displayTime, 1000);  // Run again in 1 second\n}\n"
}