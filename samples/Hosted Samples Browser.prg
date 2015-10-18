{
  "progName": "Hosted Samples Browser",
  "htmlText": "<ul class=\"tnavlist\">\n    <li class=\"tnavli\"><a class=\"tnava\" onclick=\"showDiv(1);\" href=\"javascript:void(0)\"><i class=\"fa fa-flask\"></i> Samples </a></li>\n    <li class=\"tnavli\"><a class=\"tnava\" onclick=\"showDiv(2);\" href=\"javascript:void(0)\"><i class=\"fa fa-wrench\"></i> Utilities</a></li>\n    <li class=\"tnavli\"><a class=\"tnava\" onclick=\"showDiv(3);\" href=\"javascript:void(0)\"><i class=\"fa fa-cogs\"></i> Apps</a></li>\n</ul>\n<br/>\n<div id=\"divMain\">\n    <h3>Trident Sandbox Samples</h3>\n\n    <table width=\"100%\">\n        <tr>\n            <td>\n                <ul id=\"samplesListView\" class=\"tlist\" style=\"min-height:300px\"></ul>\n            </td>\n            <td valign='top'>\n                <button class=\"skip\" onclick=\"loadSample('samples')\">Load</button><br/><br/>\n            </td>\n        </tr>\n    </table>\n\n</div>\n\n<div id=\"divUtil\" style=\"display:none\">\n    <h3>Trident Sandbox Utilities</h3>\n\n    <table width=\"100%\">\n        <tr>\n            <td>\n                <ul id=\"utilsListView\" class=\"tlist\" style=\"min-height:300px\"></ul>\n            </td>\n            <td valign='top'>\n                <button class=\"skip\" onclick=\"loadSample('utils')\">Load</button><br/><br/>\n            </td>\n        </tr>\n    </table>\n\n</div>\n\n<div id=\"divApps\" style=\"display:none\">\n    <h3>Trident Sandbox Apps</h3>\n\n    <table width=\"100%\">\n        <tr>\n            <td>\n                <ul id=\"appsListView\" class=\"tlist\" style=\"min-height:300px\"></ul>\n            </td>\n            <td valign='top'>\n                <button class=\"skip\" onclick=\"loadSample('apps')\">Load</button><br/><br/>\n            </td>\n        </tr>\n    </table>\n\n\n</div>",
  "scriptText": "var sbv = {\n    tlv : null,\n    tlvUtil : null,\n    tlvApps : null\n};\n\n// rough sizing estimates\n\nsandbox.events.windowResize = function() {\n    switch (sandbox.volatile.env) {\n        case \"IDE\" : $(\".tlist-bright\").height($(window).height() - 400); break;\n        case \"IDE WJS\" : $(\".tlist\").height($(window).height() - 360); break;\n        case \"SBL\" : $(\".tlist-bright\").height($(window).height() - 200); break;\n        case \"STANDALONE\" : $(\".tlist-bright\").height($(window).height() - 200); break;\n        default : break;\n    }\n};\n\nfunction showDiv(divId) {\n    $(\".tnava\").css(\"border\", \"none\");\n\n    $(\"#divMain\").hide();\n    $(\"#divUtil\").hide();\n    $(\"#divApps\").hide();\n\n    switch (divId) {\n        case 1 : $(\"#divMain\").show(); $(\".tnava\").eq(0).css(\"border\", \"3px solid white\"); break;\n        case 2 : $(\"#divUtil\").show(); $(\".tnava\").eq(1).css(\"border\", \"3px solid white\"); break;\n        case 3 : $(\"#divApps\").show(); $(\".tnava\").eq(2).css(\"border\", \"3px solid white\"); break;\n    }\n}\n\nfunction loadSample(source) {\n    var progName = \"\";\n\n    if (source == \"utils\") {\n        if (!sbv.tlvUtil.listSettings.selectedId) return;\n        progName = sbv.tlvUtil.listSettings.selectedId;\n    }\n    if (source == \"samples\") {\n        if (!sbv.tlv.listSettings.selectedId) return;\n        if (sbv.tlv.listSettings.selectedId === \"\") return;\n\n        progName = sbv.tlv.listSettings.selectedId;\n    }\n    if (source == \"apps\") {\n        if (!sbv.tlvApps.listSettings.selectedId) return;\n        progName = sbv.tlvApps.listSettings.selectedId;\n    }\n\n    sandbox.ide.runApp(progName.replace(\".prg\", \"\"));\n}\n\nfunction loadList() {\n    sbv.tlv = new TridentList(\"samplesListView\");\n    sbv.tlv.clearList();\n    if (sandbox.volatile.env == \"IDE\") sbv.tlv.makeBright();\n\n    sbv.tlvUtil = new TridentList(\"utilsListView\");\n    sbv.tlvUtil.clearList();\n    if (sandbox.volatile.env == \"IDE\") sbv.tlvUtil.makeBright();\n\n    sbv.tlvApps = new TridentList(\"appsListView\");\n    sbv.tlvApps.clearList();\n    if (sandbox.volatile.env == \"IDE\") sbv.tlvApps.makeBright();\n\n    sbv.tlvUtil.addListItem(\"Library Unit Management.prg\", \"Library Unit Management\", \"A Utility for Managing the Markup and Script Unit Libraries stored in the TridentDB\");\n    sbv.tlvUtil.addListItem(\"Hosted Files Database.prg\", \"Trident Files Database\", \"Maintain a library of small/medium files in the TridentDB\");\n    sbv.tlvUtil.addListItem(\"Local Storage Usage.prg\", \"Local Storage Usage\", \"Shows basic operations dealing with local storage\");\n    sbv.tlvUtil.addListItem(\"Trident DB Usage.prg\", \"Trident DB Usage\", \"Demonstrates basic use of TridentDB API functions\");\n    sbv.tlvUtil.addListItem(\"ProgramClipboard.prg\", \"Program Clipboard\", \"If your browser has no filesystem to import and export from, use this for copy/paste access.\");\n    sbv.tlvUtil.addListItem(\"KeystoreBeacon.prg\", \"Keystore Finder\", \"If you run a keystore service but its ip address changes, this can find it.\");\n\n    if (sandbox.volatile.env == \"IDE WJS\") {\n        sbv.tlvApps.addListItem(\"Antikythera-WJS.prg\", \"Antikythera (WinJS version)\", \"A 'Days Since / Days Until' up for single or recurring tasks (Hosted/AppCache)\");\n    }\n    else {\n        sbv.tlvApps.addListItem(\"Antikythera.prg\", \"Antikythera\", \"A 'Days Since / Days Until' up for single or recurring tasks (Hosted/AppCache)\");\n    }\n\n    sbv.tlvApps.addListItem(\"CryptoJS File Hasher.prg\", \"CryptoJS File Hasher\", \"Drag and drop files to generate SHA1 and MD5 hashes\");\n    sbv.tlvApps.addListItem(\"HTML 5 Starfield Fullscreen.prg\", \"HTML 5 Starfield Fullscreen\", \"A nice fullscreen canvas starfield simulator\");\n    if (sandbox.volatile.env == \"IDE WJS\") {\n        sbv.tlvApps.addListItem(\"HieroCryptes-WJS.prg\", \"HieroCryptes Notepad (WinJS version)\", \"An Encrypted, Hierarchical, Wysiwyg HTML Editor Notepad\");\n        sbv.tlvApps.addListItem(\"JSONDatabank-WJS.prg\", \"JSON Databank (WinJS version) \", \"A dynamic datafiler app using loki and jsoneditor\");\n        sbv.tlvApps.addListItem(\"LokiContinuum.prg\", \"Loki Continuum\", \"A financial simulation engine port from c#\");\n    }\n    else {\n        sbv.tlvApps.addListItem(\"HieroCryptes Notepad.prg\", \"HieroCryptes Notepad\", \"An Encrypted, Hierarchical, Wysiwyg HTML Editor Notepad\");\n        sbv.tlvApps.addListItem(\"JSON Databank.prg\", \"JSON Databank\", \"A dynamic datafiler app using loki and jsoneditor\");\n        sbv.tlvApps.addListItem(\"LokiContinuum.prg\", \"Loki Continuum\", \"A financial simulation engine port from c#\");\n    }\n    sbv.tlvApps.addListItem(\"Trident Binary Encryptor.prg\", \"Trident Binary Encryptor\", \"Encrypt/Decrypt binary files\");\n    sbv.tlvApps.addListItem(\"Trident Sandbox Radio.prg\", \"Trident Sandbox Radio\", \"A streaming radio player.  Now uses cross platform HTML 5 audio to handle streaming.\");\n\n\n    sbv.tlv.addListItem(\"Alertify Demo.prg\", \"Alertify Demo\", \"Demonstration of using the Alertify.js library for prompts/notifications.\");\n    sbv.tlv.addListItem(\"Codemirror demo.prg\", \"Codemirror Demo\", \"Add syntax highlighting code/data editors to your programs\");\n\n    sbv.tlv.addListItem(\"CryptoJS.prg\", \"CryptoJS\", \"Rough demo of basic Crypto.JS operations\");\n    sbv.tlv.addListItem(\"CryptoWorker Demo.prg\", \"CryptoWorker Demo\", \"Show how to use the crypto_worker.js multithreaded web worker\");\n    sbv.tlv.addListItem(\"D3 sample.prg\", \"D3.js Sample\", \"D3.js is a visualization toolkit way more powerful than this example can show\");\n    sbv.tlv.addListItem(\"Dynatree Demo.prg\", \"Dynatree Demo\", \"Demonstration of using the Dynatree third party TreeView control\");\n    sbv.tlv.addListItem(\"EaselJS Demo.prg\", \"EaselJS Demo\", \"A simple tutorial of using the EaselJS graphics library\");\n    sbv.tlv.addListItem(\"Font Awesome.prg\", \"Font Awesome\", \"Shows how you might use this font-based vector icon library\");\n    sbv.tlv.addListItem(\"Geolocation Coordinates.prg\", \"Geolocation Coordinates\", \"Gets raw coordinates from Geolocation API\");\n    sbv.tlv.addListItem(\"Geolocation GetMap.prg\", \"Geolocation GetMap\", \"Uses geolocation to get location, and then fetches a google map\");\n    sbv.tlv.addListItem(\"Geolocation Track.prg\", \"Geolocation Track\", \"Supposedly real time tracking of location\");\n    sbv.tlv.addListItem(\"jqPlot Demo.prg\", \"jqPlot Demo\", \"Pie, Bar, and Line graph demo using jplot library\");\n    sbv.tlv.addListItem(\"jQuery UI Demo.prg\", \"jQuery UI Demo\", \"Some basic jquery UI controls\");\n    sbv.tlv.addListItem(\"JsonEditor Forms Sample.prg\", \"JsonEditor Forms Sample\", \"JSON Editor library sample takes a JSON Schema and uses it to generate an HTML form\");\n    sbv.tlv.addListItem(\"hello knockout.prg\", \"Knockout.js sample\", \"This sample demonstrates how to use this Model/View framework for databinding\");\n    sbv.tlv.addListItem(\"loki examples.prg\", \"Loki.js examples\", \"Sample showing loki.js usage\");\n    sbv.tlv.addListItem(\"MetroJS Demo.prg\", \"MetroJS Demo\", \"Demo of basic Metro.JS library to simulate 'live tile' in web pages\");\n    sbv.tlv.addListItem(\"ObeliskJS Demo.prg\", \"ObeliskJS Demo\", \"Obelisk.js is a JavaScript Engine for building isometric pixel objects\");\n    sbv.tlv.addListItem(\"PixiJS Morph Demo.prg\", \"PixiJS Morph Demo\", \"Graphic Demo of pixi.js : a 2d WebGL graphics library with canvas fallback.\");\n    sbv.tlv.addListItem(\"Proper Cleanup Method.prg\", \"Proper Cleanup Method\", \"Example of how you might organize your code to clean up well\");\n    sbv.tlv.addListItem(\"React Sample.prg\", \"React.js Sample\", \"Sample showing how to use React.js within Trident Sandbox\");\n    sbv.tlv.addListItem(\"SandboxIO.prg\", \"SandboxIO\", \"Shows how to do simple FileAPI with TridentSandbox file pickers\");\n    sbv.tlv.addListItem(\"SpeechSynthesisAPI Safari.prg\", \"SpeechSynthesisAPI\", \"Supported only in Chrome/Opera/Safari/IOS7, this sample lets you enter text to speak\");\n    sbv.tlv.addListItem(\"Springy Demo.prg\", \"Springy Demo\", \"Demo of the Springy force directed graph control\");\n    sbv.tlv.addListItem(\"TinyMCE Demo.prg\", \"TinyMCE Demo\", \"Simple example showing how to create a TinyMCE Wysiwyg HTML editor\");\n    sbv.tlv.addListItem(\"Trident UI Demo.prg\", \"Trident UI Demo\", \"Demonstrates some TridentSandbox controls for touch friendly apps\");\n    sbv.tlv.addListItem(\"WebGL Spinning Box.prg\", \"WebGL Spinning Box\", \"A simple WebGL spinning cube using three.js library\");\n    sbv.tlv.addListItem(\"WebGL Spinning Crate.prg\", \"WebGL Spinning Crate\", \"A simple -textured- WebGL spinning cube using three.js\");\n    sbv.tlv.addListItem(\"BabylonJS Sample WebGL.prg\", \"Babylon.JS Spinning Crate\", \"A WebGL spinning crate with lighting and mouse using Babylon.js\");\n    if (sandbox.volatile.isWebkit) {\n        sbv.tlv.addListItem(\"node crypto.prg\", \"Node Webkit Crypto Sample\", \"Example demonstrating the Node Crypto library\");\n        sbv.tlv.addListItem(\"node fs sample.prg\", \"Node Webkit Filesystem Sample\", \"Example demonstrating the Node filesystem access\");\n        sbv.tlv.addListItem(\"node os module.prg\", \"Node Webkit OS Module Sample\", \"Example demonstrating the Node OS library\");\n    }\n    \n    if (sandbox.volatile.env == \"IDE WJS\") {\n        sbv.tlv.addListItem(\"WinJS AppBar.prg\", \"WinJS AppBar\", \"WinJS AppBar sample (like a toolbar that hides itself)\");\n        sbv.tlv.addListItem(\"WinJS FlipView.prg\", \"WinJS FlipView\", \"WinJS FlipView sample (an image carousel flip view)\");\n        sbv.tlv.addListItem(\"WinJS Hub.prg\", \"WinJS Hub\", \"WinJS AppBar sample (hub layout sample with regions)\");\n        sbv.tlv.addListItem(\"WinJS ListView.prg\", \"WinJS ListView\", \"WinJS AppBar sample (a scrollable list)\");\n        sbv.tlv.addListItem(\"WinJS Menu.prg\", \"WinJS Menu\", \"WinJS Menu sample (Context Menus which pop out)\");\n        sbv.tlv.addListItem(\"WinJS NavBar.prg\", \"WinJS NavBar\", \"WinJS NavBar sample (Scrollable Toolbar which hides itself)\");\n        sbv.tlv.addListItem(\"WinJS Pivot.prg\", \"WinJS Pivot\", \"WinJS Pivot sample (like a windows phone inbox)\");\n    }\n\n    sbv.tlv.addListItem(\"WinJS Promises.prg\", \"WinJS Promises\", \"WinJS Promises sample (chaining methods with error handling)\");\n    sbv.tlv.addListItem(\"WinJS Scheduler.prg\", \"WinJS Scheduler\", \"WinJS Scheduler sample (lets you queue javascript work items with priorities)\");\n\n    if (sandbox.volatile.env == \"IDE\") {\n        sbv.tlv.addListItem(\"\", \"More WinJS Samples\", \"To see WinJS UI samples click on WinJS Version link under help\");\n    }\n\n\n    sandbox.events.windowResize();\n\n}\n\nloadList();"
}