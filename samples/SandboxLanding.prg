{
  "progName": "SandboxLanding",
  "htmlText": "<style>\n.divider{\n    width:25px;\n    height:auto;\n    display:inline-block;\n}\n\n.win-app-surface {\n\tmargin-top: 100px !important;\n}\n/*App Header Styles*/\n#appHeader {\n    position: absolute;\n    z-index: 1;\n    top: 45px;\n    left: 50px;\n}\n\n#appHeader h1 {\n\tdisplay: inline;\n}\n\na.wjslink {\n   color: rgba(156, 114, 255, 0.47);\n}\na.wjslink:hover {\n   color: rgba(156, 114, 255, 0.87);\n}\n\n.fullScreen {\n    width: 100%;\n    height: 100%;\n    position: absolute;\n    top: 0;\n    left: 0;\n}\n\n/*width of each section*/\n.section1.win-hub-section {\n    width: 650px;\n    overflow: hidden;\n}\n\n.section2.win-hub-section {\n    width: 650px; \n}\n\n.section3.win-hub-section {\n    width: 500px;\n}\n\n.section4.win-hub-section {\n    width: 630px;\n}\n\n\n/*App Header Styles*/\n#appHeader {\n    position: absolute;\n    z-index: 1;\n    top: 20px;\n    left: 50px;\n}\n\n#appHeader .win-navigation-backbutton {\n\tmargin-right: 20px;\n}\n\n#appHeader h1 {\n\tdisplay: inline;\n}\n\n/*styles when app is in the portrait mode*/\n@media all and (min-height: 1280px) {\n    .section2.win-hub-section {\n        overflow: hidden;\n    }\n}\n\n/*styles for larger screens*/\n@media (min-width: 1920px) {\n    .section2.win-hub-section {\n        overflow: hidden;\n    }\n}\n\n.win-pivot .win-pivot-header {\n    height:30px;\n    vertical-align:top;\n}\n\n.win-pivot .win-pivot-header  {\n    font-size: 18px;\n}\n\n.win-pivot .win-pivot-header-selected.win-pivot-header{\n    font-size: 18px;\n}\n.win-pivot-item .win-pivot-item-content {\n\tpadding: 0 0 0 14px;\n}\n\n.userIcon {\n\twidth: 48px;\n\theight: 48px;\n\tfloat: left;\n\tmargin-right: 12px;\n}\n\n.sampleContent {\n\twidth: calc(100% - 60px);\n\theight: 48px;\n\tfloat: left;\n}\n\n.sampleName {\n\theight: 16px;\n\tfloat: left;\n\tfont-weight: 600;\n\tfont-size: 15px;\n\tline-height: 15px;\n}\n\n.sampleDesc {\n\twidth: 100%;\n\theight: 32px;\n\tfont-size: 16px;\n\tline-height: 16px;\n    padding-top: 10px;\n\toverflow: hidden;\n\tcolor: rgba(255, 255, 255, .4);\n}\n\n.sampleInformation {\n\twidth: 100%;\n\theight: 17px;\n}\n\n.smallListIconTextItem\n{\n\twidth: calc(100% - 48px);\n\tmin-width: 312px;\n\theight: 48px;\n\tmargin-bottom: 1px;\n\tpadding: 16px 24px;\n}\n\n/* Override the background color for even/odd win-containers */\n.listView .win-container.win-container-odd {\n    background-color: #333;\n}\n\n.listView .win-container.win-container-even {\n    background-color: #222;\n\n\n</style>\n\n<div id=\"divMainFS\" class=\"fullScreen\" style=\"display:none\">\n\n    <!-- app header and backbutton-->\n    <div id=\"appHeader\">\n        <h2>Welcome to the TridentSandbox Sandbox Landing page</h2>\n    </div>\n\n\n\t<div class=\"smallListIconTextTemplate\" data-win-control=\"WinJS.Binding.Template\">\n\t\t<div class=\"smallListIconTextItem\">\n\t\t\t<div class=\"userIcon\"><i data-win-bind=\"className: icon\" /></div>\n\t\t\t<div class=\"sampleContent\">\n\t\t\t\t<div class=\"sampleInformation\">\n\t\t\t\t\t<div class=\"sampleName\" data-win-bind=\"textContent: name\"></div>\n\t\t\t\t</div>\n\t\t\t\t<div class=\"sampleDesc\" data-win-bind=\"textContent: desc\"></div>\n\t\t\t\t<div class=\"progclass\" style=\"display:none\" data-win-bind=\"textContent: progName\"></div>\n\t\t\t</div>\n\t\t</div>\n\t</div>\n  \n    <!-- Hub Control -->\n    <div style=\"top:70px\" data-win-control=\"WinJS.UI.Hub\">\n        <div id=\"list\" class=\"section1\" data-win-control=\"WinJS.UI.HubSection\" data-win-options=\"{header: 'Popular Links / Apps', isHeaderStatic: true}\">\n            <div>\n            \n                <div class=\"live-tile  cobalt two-wide\" id=\"tileIDE\" data-direction=\"horizontal\" data-mode=\"flip\">     \n                <div><h3>Trident Sandbox IDE</h3>\n                          <span class=\"tile-title\">Trident Sandbox IDE</span>\n                    </div>\n                    <div>\n                        <p>Click here to visit the main Trident Sandbox development IDE.&nbsp; From there you can browse all samples or start developing your own app.</p>\n                           <span class=\"tile-title\">Trident Sandbox IDE</span>\n                        \n                    </div>\n                </div>\n            \n               <div class=\"live-tile mango \" id=\"tileHelp\" data-direction=\"horizontal\" data-mode=\"flip\">     \n                    <div><h3>Trident Sandbox Help pages</h3>\n                          <span class=\"tile-title\">Trident Sandbox Help</span>\n                    </div>\n                    <div>\n                        <p>Click here to view the in-depth help documentation.  \n                           <span class=\"tile-title\">Trident Sandbox Help</span>\n                        </p>\n                    </div>\n                </div>\n\n                <div class=\"live-tile red\" id=\"tileGithub\" data-mode=\"flip\">        \n                    <div>\n                        <h3>Trident Sandbox GitHub page</h3>\n                        <span class=\"tile-title\">GitHub Project Site</span>\n                    </div>\n                    <div>\n                        <p>Click here to view or download the source code to TridentSandbox.</p>\n                        <span class=\"tile-title\">GitHub Project Site</span>\n                    </div>\n                </div>\n    \n               <div class=\"live-tile green\" id=\"tileHCN\" data-direction=\"horizontal\" data-mode=\"flip\">     \n                    <div><span style=\"padding:10px; font-size:32px\"><i style=\"color:#ddd\" class=\"fa fa-sitemap\"></i>&nbsp;<i style=\"color:#ddd\" class=\"fa fa-key\"></i>&nbsp;<i style=\"color:#ddd\" class=\"fa fa-edit\"></i> </span>\n                          <span class=\"tile-title\">HieroCryptes Notepad</span>\n                    </div>\n                    <div>\n                        <p>Click here to use this Hierarchical, Encrypted Notepad app.</p>\n                           <span class=\"tile-title\">HieroCryptes Notepad</span>\n                    </div>\n                </div>\n                \n               <div class=\"live-tile green\" id=\"tileATK\" data-direction=\"horizontal\" data-mode=\"flip\">     \n                    <div>\n                    \t<span style=\"padding:10px; font-size:16px\">\n                        Keep track of how many days until or since certain dates which you enter\n                    \t</span>\n                          <span class=\"tile-title\">Antikythera</span>\n                    </div>\n                    <div>\n                    \t<p>\n                        \tClick here to run this DaysSince / DaysUntil app\n                            <span class=\"tile-title\">Antikythera</span>\n                        </p>\n                    </div>\n                </div>\n                \n               <div class=\"live-tile green\" id=\"tileJDB\" data-direction=\"horizontal\" data-mode=\"flip\">     \n                    <div>\n                    \t<span style=\"padding:10px; font-size:16px\">\n                        A data-filer type databank app for creating and editing custom data\n                    \t</span>\n                          <span class=\"tile-title\">JSON Databank</span>\n                    </div>\n                    <div>\n                    \t<p>\n                        \tClick here to run this databank app\n                            <span class=\"tile-title\">JSON Databank</span>\n                        </p>\n                    </div>\n                </div>\n                \n               <div class=\"live-tile green\" id=\"tileSR\" data-direction=\"horizontal\" data-mode=\"flip\">     \n                    <div>\n                    \t<span style=\"padding:10px; font-size:16px\">\n                        Streaming Radio App\n                    \t</span>\n                          <span class=\"tile-title\">Sandbox Radio</span>\n                    </div>\n                    <div>\n                    \t<p>\n                        \tClick here to run this radio streaming app.\n                            <span class=\"tile-title\">Sandbox Radio</span>\n                        </p>\n                    </div>\n                </div>\n    \n            </div>\n        </div>\n\n\t\t<div class=\"section2\" data-win-control=\"WinJS.UI.HubSection\" data-win-options=\"{header: 'Library', isHeaderStatic: true}\">\n        \n            <div id=\"divList\">\n\n                <div id=\"samplePivot\" class=\"wide\" data-win-control=\"WinJS.UI.Pivot\" data-win-options=\"{ selectedIndex: 0 }\">\n                    <div class=\"pivotItem\" data-win-control=\"WinJS.UI.PivotItem\" data-win-options=\"{ 'header': 'Apps' }\">\n                        <div id=\"appList\" class=\"listView win-selectionstylefilled\"\n                            data-win-control=\"WinJS.UI.ListView\"\n                            data-win-options=\"{\n                                itemDataSource: Landing.Apps.dataSource,\n                                itemTemplate: select('.smallListIconTextTemplate'),\n                                selectionMode: 'single',\n                                tapBehavior: 'directSelect',\n                                layout: { type: WinJS.UI.ListLayout }}\">\n                        </div>\n                    </div>\n                    \n                    <div class=\"pivotItem\" data-win-control=\"WinJS.UI.PivotItem\" data-win-options=\"{ 'header': 'Utilities' }\">\n                        <div id=\"utilList\" class=\"listView win-selectionstylefilled\"\n                            data-win-control=\"WinJS.UI.ListView\"\n                            data-win-options=\"{\n                                itemDataSource: Landing.Utils.dataSource,\n                                itemTemplate: select('.smallListIconTextTemplate'),\n                                selectionMode: 'single',\n                                tapBehavior: 'directSelect',\n                                layout: { type: WinJS.UI.ListLayout }}\">\n                        </div>\n                    </div>\n\n                    <div class=\"pivotItem\" data-win-control=\"WinJS.UI.PivotItem\" data-win-options=\"{ 'header': 'Samples' }\">\n                        <div id=\"sampleList\" class=\"listView win-selectionstylefilled\"\n                            data-win-control=\"WinJS.UI.ListView\"\n                            data-win-options=\"{\n                                itemDataSource: Landing.Samples.dataSource,\n                                itemTemplate: select('.smallListIconTextTemplate'),\n                                selectionMode: 'single',\n                                tapBehavior: 'directSelect',\n                                layout: { type: WinJS.UI.ListLayout }}\">\n                        </div>\n                    </div>\n\n                    <div class=\"pivotItem\" data-win-control=\"WinJS.UI.PivotItem\" data-win-options=\"{ 'header': 'User Programs' }\">\n                        <div id=\"userList\" class=\"listView win-selectionstylefilled\"\n                            data-win-control=\"WinJS.UI.ListView\"\n                            data-win-options=\"{\n                                itemDataSource: Landing.User.dataSource,\n                                itemTemplate: select('.smallListIconTextTemplate'),\n                                selectionMode: 'single',\n                                tapBehavior: 'directSelect',\n                                layout: { type: WinJS.UI.ListLayout }}\">\n                        </div>\n                    </div>\n\n                </div>\n\n\n\t\t\t\t<br/>\n\t\t\t\t<div class=\"divider\"></div>\n                <button onclick=\"runSample()\">Launch Program</button>\n\t\t\t\t<div class=\"divider\"></div>\n                <input type=\"checkbox\" id=\"chkNewWindow\" checked>In new window\n            </div>\n        </div>\n        \n        <div class=\"section3\" data-win-control=\"WinJS.UI.HubSection\" data-win-options=\"{header: 'About Trident Sandbox', isHeaderStatic: true}\">\n            <div>\n            <p>TridentSandbox is a browser-app development environment.&nbsp; It allows you to build browser apps, within a browser itself.&nbsp; It uses HTML5 appcache to allow you \n            to use the environment even if you have no internet connection.&nbsp; It takes advantage of your browser's sandbox storage capabillities like local storage and indexeddb to let \n            you store an run your programs within your browser, even when offline.  Your apps are still sandboxed, but they have persistence and can input/output via IndexedDb, local storage, FileAPI (load/save dialogs), AJAX, and copy/paste.</p>\n            <p>The entire TridentSandbox environment has probably already been installed and \n            uses up about 8 megs of browser storage.  A typical browser may also provide \n            TridentSandbox with about 120 Megs of storage for storing your apps and data.  This can be monitored with \n            the 'Storage Summary' feature within the IDE.</p>\n            \n            <p>You will see mention of WinJS alot.  It is an open source javascript library written by Microsoft which allows browser programs to behave like 'apps'.\n            As a general rule, if you intend to target 'touch' devices, you might use the 'WinJS Version' of the Trident Sandbox IDE and if your program solely targets the desktop browser, you might use the 'Regular Version' of the Trident Sandbox IDE.</p>\n\n            </div>\n        </div>\n\n\t</div>\n\n\n</div>\n\n",
  "scriptText": "$(\"#UI_MainPlaceholder\").css(\"height\", \"600px\");\nAPI_SetBackgroundColor(\"#222\");\n\nfunction EVT_WindowResize() {\n\t// should only run this in SandboxLoader WJS environment\n\t$(\"#samplePivot\").height($(window).height() - 260); \n\t$(\".listView\").height($(window).height()-280);\n}\n\n\nvar samples = new WinJS.Binding.List([\n\t{ name: \"Alertify Demo\", icon: \"fa fa-flask fa-2x\", desc: \"Demonstration of using the Alertify.js library for prompts/notifications.\", progName: \"Alertify Demo.prg\" },\n\t{ name: \"Codemirror Demo\", icon: \"fa fa-flask fa-2x\", desc: \"Add syntax highlighting code/data editors to your programs\", progName: \"Codemirror demo.prg\" },\n\t{ name: \"CryptoJS\", icon: \"fa fa-flask fa-2x\", desc: \"Rough demo of basic Crypto.JS operations\", progName: \"CryptoJS.prg\" },\n\t{ name: \"CryptoWorker Demo\", icon: \"fa fa-flask fa-2x\", desc: \"Show how to use the crypto_worker.js multithreaded web worker\", progName: \"CryptoWorker Demo.prg\" },\n\t{ name: \"D3.js Sample\", icon: \"fa fa-flask fa-2x\", desc: \"D3.js is a visualization toolkit way more powerful than this example can show\", progName: \"D3 sample.prg\" },\n\t{ name: \"Dynatree Demo\", icon: \"fa fa-flask fa-2x\", desc: \"Demonstration of using the Dynatree third party TreeView control\", progName: \"Dynatree Demo.prg\" },\n\t{ name: \"EaselJS Demo\", icon: \"fa fa-flask fa-2x\", desc: \"A simple tutorial of using the EaselJS graphics library\", progName: \"EaselJS Demo.prg\" },\n\t{ name: \"Font Awesome\", icon: \"fa fa-flask fa-2x\", desc: \"Shows how you might use this font-based vector icon library\", progName: \"Font Awesome.prg\" },\n\t{ name: \"Geolocation Coordinates\", icon: \"fa fa-flask fa-2x\", desc: \"Gets raw coordinates from Geolocation API\", progName: \"Geolocation Coordinates.prg\" },\n\t{ name: \"Geolocation GetMap\", icon: \"fa fa-flask fa-2x\", desc: \"Uses geolocation to get location, and then fetches a google map\", progName: \"Geolocation GetMap.prg\" },\n\t{ name: \"Geolocation Track\", icon: \"fa fa-flask fa-2x\", desc: \"Supposedly real time tracking of location\", progName: \"Geolocation Track.prg\" },\n\t{ name: \"jqPlot Demo\", icon: \"fa fa-flask fa-2x\", desc: \"Pie, Bar, and Line graph demo using jplot library\", progName: \"jqPlot Demo.prg\" },\n\t{ name: \"JsonEditor Forms Sample\", icon: \"fa fa-flask fa-2x\", desc: \"JSON Editor library sample takes a JSON Schema and uses it to generate an HTML form\", progName: \"JsonEditor Forms Sample.prg\" },\n\t{ name: \"Knockout.js sample\", icon: \"fa fa-flask fa-2x\", desc: \"This sample demonstrates how to use this Model/View framework for databinding\", progName: \"hello knockout.prg\" },\n\t{ name: \"Loki.js examples\", icon: \"fa fa-flask fa-2x\", desc: \"Sample showing loki.js usage\", progName: \"loki examples.prg\" },\n\t{ name: \"SandboxIO\", icon: \"fa fa-flask fa-2x\", desc: \"Shows how to do simple FileAPI with TridentSandbox file pickers\", progName: \"SandboxIO.prg\" },\n\t{ name: \"Springy Demo\", icon: \"fa fa-flask fa-2x\", desc: \"Demo of the Springy force directed graph control\", progName: \"Springy Demo.prg\" },\n\t{ name: \"TinyMCE Demo\", icon: \"fa fa-flask fa-2x\", desc: \"Simple example showing how to create a TinyMCE Wysiwyg HTML editor\", progName: \"TinyMCE Demo.prg\" },\n\t{ name: \"Trident API Demo\", icon: \"fa fa-flask fa-2x\", desc: \"Demonstrates how to use the new Trident API via the VAR_TRIDENT_API object/class\", progName: \"Trident API Demo.prg\" },\n\t{ name: \"WebGL Spinning Crate\", icon: \"fa fa-flask fa-2x\", desc: \"A simple -textured- WebGL spinning cube using three.js\", progName: \"WebGL Spinning Crate.prg\" },\n\t{ name: \"Babylon.JS Spinning Crate\", icon: \"fa fa-flask fa-2x\", desc: \"A WebGL spinning crate with lighting and mouse using Babylon.js\", progName: \"Babylon.JS Sample (WebGL).prg\" },\n\t{ name: \"WinJS Promises\", icon: \"fa fa-flask fa-2x\", desc: \"WinJS Promises sample (chaining methods with error handling)\", progName: \"WinJS Promises.prg\" },\n\t{ name: \"WinJS Scheduler\", icon: \"fa fa-flask fa-2x\", desc: \"WinJS Scheduler sample (lets you queue javascript work items with priorities)\", progName: \"WinJS Scheduler.prg\" }\n]);\n\nvar utils = new WinJS.Binding.List([\n\t{ name: \"Library Unit Management\", icon: \"fa fa-wrench fa-2x\", desc: \"A Utility for Managing the Markup and Script Unit Libraries stored in the TridentDB\", progName: \"Library Unit Management.prg\" },\n\t{ name: \"Trident Backup / Restore\", icon: \"fa fa-wrench fa-2x\", desc: \"Backup and Restore items in the TridentDB\", progName: \"Trident Backup Restore.prg\" },\n\t{ name: \"Trident Files Database\", icon: \"fa fa-wrench fa-2x\", desc: \"Maintain a library of small/medium files in the TridentDB\", progName: \"Hosted Files Database.prg\" },\n\t{ name: \"Trident DB Usage\", icon: \"fa fa-wrench fa-2x\", desc: \"Demonstrates basic use of TridentDB API functions\", progName: \"Trident DB Usage.prg\" },\n\t{ name: \"Keystore Finder\", icon: \"fa fa-wrench fa-2x\", desc: \"If you run a keystore service but its ip address changes, this can find it.\", progName: \"KeystoreBeacon.prg\" }\n]);\n\nvar apps = new WinJS.Binding.List([\n\t{ name: \"Sandbox Radio\", icon: \"fa fa-cogs fa-2x\", desc: \"A streaming radio player app.  Uses cross platform HTML 5 audio to handle streaming.\", progName: \"Sandbox Radio WJS.prg\" },\n\t{ name: \"HieroCryptes Notepad WinJS\", icon: \"fa fa-cogs fa-2x\", desc: \"An Encrypted, Hierarchical, Wysiwyg HTML Editor Notepad\", progName: \"HieroCryptes-WJS.prg\" },\n\t{ name: \"Antikythera WinJS\", icon: \"fa fa-cogs fa-2x\", desc: \"A 'Days Since / Days Until' up for single or recurring tasks (Hosted/AppCache)\", progName: \"Antikythera-WJS.prg\" },\n\t{ name: \"JSON Databank WinJS\", icon: \"fa fa-cogs fa-2x\", desc: \"A dynamic datafiler app using loki and jsoneditor\", progName: \"JSONDatabank-WJS.prg\" },\n\t{ name: \"Loki Continuum\", icon: \"fa fa-cogs fa-2x\", desc: \"A financial simulation engine port from c#\", progName: \"LokiContinuum.prg\" },\n\t{ name: \"HTML 5 Starfield Fullscreen\", icon: \"fa fa-cogs fa-2x\", desc: \"A nice fullscreen canvas starfield simulator\", progName: \"HTML 5 Starfield Fullscreen.prg\" },\n\t{ name: \"PixiJS Morph Demo\", icon: \"fa fa-cogs fa-2x\", desc: \"Graphic Demo of pixi.js : a 2d WebGL graphics library with canvas fallback.\", progName: \"PixiJS Morph Demo.prg\" },\n\t{ name: \"CryptoJS File Hasher\", icon: \"fa fa-cogs fa-2x\", desc: \"Drag and drop files to generate SHA1 and MD5 hashes\", progName: \"CryptoJS File Hasher.prg\" },\n\t{ name: \"Trident Binary Encryptor\", icon: \"fa fa-cogs fa-2x\", desc: \"Encrypt/Decrypt binary files\", progName: \"Trident Binary Encryptor.prg\" }\n]);\n\n\n\n    var $tileIDE = $(\"#tileIDE\").liveTile({ delay: 3500 });\n    $(\"#tileIDE\").click(function(){\n        $(this).liveTile('play', 0);\n        location.href = \"TridentSandboxWJS.htm\";\n    });\n\n    var $tileHelp = $(\"#tileHelp\").liveTile({ delay: 3750 });\n    $(\"#tileHelp\").click(function(){\n        $(this).liveTile('play', 0);\n        location.href = \"./docs/Welcome.htm\";\n    });\n\n    var $tileGithub = $(\"#tileGithub\").liveTile({ delay: 4250 });\n    $(\"#tileGithub\").click(function(){\n        $(this).liveTile('play', 0);\n        location.href = \"https://github.com/obeliskos/TridentSandbox\";\n    });\n\n    var $tileHCN = $(\"#tileHCN\").liveTile({ delay: 4000 });\n    $(\"#tileHCN\").click(function(){\n        $(this).liveTile('play', 0);\n        location.href = \"SandboxLoaderWJS.htm#RunApp=HieroCryptes-WJS\";\n    });\n\n    var $tileATK = $(\"#tileATK\").liveTile({ delay: 4100 });\n    $(\"#tileATK\").click(function(){\n        $(this).liveTile('play', 0);\n        location.href = \"SandboxLoaderWJS.htm#RunApp=Antikythera-WJS\";\n    });\n\n    var $tileJDB = $(\"#tileJDB\").liveTile({ delay: 4200 });\n    $(\"#tileJDB\").click(function(){\n        $(this).liveTile('play', 0);\n        location.href = \"SandboxLoaderWJS.htm#RunApp=JSONDatabank-WJS\";\n    });\n\n    var $tileSR = $(\"#tileSR\").liveTile({ delay: 4300 });\n    $(\"#tileSR\").click(function(){\n        $(this).liveTile('play', 0);\n        location.href = \"SandboxLoaderWJS.htm#RunApp=Sandbox Radio WJS\";\n    });\n    \nfunction runSample() {\n\tvar listRef = null;\n    \n\tvar pivot = document.getElementById(\"samplePivot\").winControl;\n    switch(pivot.selectedIndex) {\n        case 0: \n            listRef = document.getElementById(\"appList\").winControl;\n            listRef.selection.getItems().then(function(items) {\n                loadSample(items[0].data.progName);\n            });\n            break;\n        case 1: \n            listRef = document.getElementById(\"utilList\").winControl;\n            listRef.selection.getItems().then(function(items) {\n                loadSample(items[0].data.progName);\n            });\n            break;\n    \tcase 2: \n            listRef = document.getElementById(\"sampleList\").winControl;\n            listRef.selection.getItems().then(function(items) {\n                loadSample(items[0].data.progName);\n            });\n            break;\n        case 3:\n            listRef = document.getElementById(\"userList\").winControl;\n            listRef.selection.getItems().then(function(items) {\n                var pname = items[0].data.name;\n\t\t\t\twindow.open(\"SandboxLoaderWJS.htm#RunSlot=\"+ pname, \"_blank\");\n            });\n            break;\n    }\n}\n\nfunction loadSample(progName) {\n\tvar url = \"\";\n    \n    if ($(\"#chkNewWindow\").is(\":checked\")) {\n    \twindow.open(\"SandboxLoaderWJS.htm#RunApp=\" + progName.replace(\".prg\", \"\"), \"_blank\");\n    \treturn;\n    }\n    \n   \tlocation.href = \"SandboxLoaderWJS.htm#RunApp=\" + progName.replace(\".prg\", \"\");\n}\n    \nfunction EVT_CleanSandbox()\n{\n  $tileIDE.liveTile('stop');\n  $tileHCN.liveTile('stop');\n  $tileATK.liveTile('stop');\n  $tileJDB.liveTile('stop');\n  $tileHelp.liveTile('stop');\n  $tileGithub.liveTile('stop');\n  \n  EVT_CleanSandbox = null;\n}\n\nvar pageURI = \"\";\n\nswitch (sandbox.volatile.env) {\n\tcase \"IDE WJS\" : pageURI = \"./TridentSandboxWJS.htm\"; break;\n    case \"SBL WJS\" : pageURI = location.href; break;\n\tdefault : break;    \n}\n\nfunction refreshProgList() {\n\tsandbox.db.GetAppKeys(\"SandboxSaveSlots\", function (result) {\n\t\tif (result != null) {\n\t\t\tfor (var idx = 0; idx < result.length; idx++) {\n                Landing.User.push({\n                \tname: result[idx].key,\n                    icon: \"fa fa-smile-o fa-2x\",\n                    desc: \"\",\n                    progName: result[idx].key\n                });\n\t\t\t}\n            \n            Landing.User.sort(function(a, b) {\n\t\t\t\tif (a.name > b.name) return 1;\n\t\t\t\telse if (a.name < b.name) return -1;\n\t\t\t\telse return 0\n            });\n\t\t}\n  });\n}\n\nWinJS.Namespace.define(\"Landing\", {\n\tSamples: samples,\n\tUtils: utils,\n\tApps: apps,\n    User: new WinJS.Binding.List(),\n    sampleList : null,\n    utilList : null,\n    appList : null\n});\n\nWinJS.UI.Pages.define(pageURI, {\n    ready: function (element, options) {\n    \t$(\"#divMainFS\").show();\n\t},\n    \n    unload: function () {\n        // TODO: Respond to navigations away from this page.\n    },\n    \n});\n\nWinJS.Utilities.ready(function () {\n    WinJS.Binding.processAll(null, Landing).then(function () {\n        WinJS.UI.processAll().done(function () {\n            EVT_WindowResize();\n            refreshProgList();\n        });\n    })\n});\n\n\n\n\n\n"
}