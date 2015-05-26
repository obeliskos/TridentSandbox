{
  "progName": "Samples Browser WJS",
  "htmlText": "<style>\n.win-pivot .win-pivot-header {\n    height:40px;\n    vertical-align:top;\n}\n\n.win-pivot .win-pivot-header  {\n    font-size: 24px;\n}\n\n.win-pivot .win-pivot-header-selected.win-pivot-header{\n    font-size: 24px;\n}\n.win-pivot-item .win-pivot-item-content {\n\tpadding: 0 0 0 14px;\n}\n\n.userIcon {\n\twidth: 48px;\n\theight: 48px;\n\tfloat: left;\n\tmargin-right: 12px;\n}\n\n.sampleContent {\n\twidth: calc(100% - 60px);\n\theight: 48px;\n\tfloat: left;\n}\n\n.sampleName {\n\theight: 16px;\n\tfloat: left;\n\tfont-weight: 600;\n\tfont-size: 15px;\n\tline-height: 15px;\n}\n\n.sampleDesc {\n\twidth: 100%;\n\theight: 32px;\n\tfont-size: 16px;\n\tline-height: 16px;\n    padding-top: 10px;\n\toverflow: hidden;\n\tcolor: rgba(255, 255, 255, .4);\n}\n\n.sampleInformation {\n\twidth: 100%;\n\theight: 17px;\n}\n\n.smallListIconTextItem\n{\n\twidth: calc(100% - 48px);\n\tmin-width: 312px;\n\theight: 48px;\n\tmargin-bottom: 1px;\n\tpadding: 16px 24px;\n}\n\n/* Override the background color for even/odd win-containers */\n.listView .win-container.win-container-odd {\n    background-color: #333;\n}\n\n.listView .win-container.win-container-even {\n    background-color: #222;\n}\n\n</style>\n\n<br/>\n<h2>Samples Browser</h2>\n\n<!-- Simple template for the ListView instantiation  -->\n<div class=\"smallListIconTextTemplate\" data-win-control=\"WinJS.Binding.Template\">\n\t<div class=\"smallListIconTextItem\">\n        <div class=\"userIcon\"><i data-win-bind=\"className: icon\" /></div>\n        <div class=\"sampleContent\">\n            <div class=\"sampleInformation\">\n                <div class=\"sampleName\" data-win-bind=\"textContent: name\"></div>\n            </div>\n            <div class=\"sampleDesc\" data-win-bind=\"textContent: desc;\"></div>\n            <div class=\"progclass\" style=\"display:none\" data-win-bind=\"textContent: progName\"></div>\n        </div>\n\t</div>\n</div>\n\n<div id=\"samplePivot\" class=\"wide\" data-win-control=\"WinJS.UI.Pivot\" data-win-options=\"{ selectedIndex: 0 }\">\n    <div class=\"pivotItem\" data-win-control=\"WinJS.UI.PivotItem\" data-win-options=\"{ 'header': 'Samples' }\">\n\t\t<div id=\"sampleList\" class=\"listView win-selectionstylefilled\"\n\t\t\tdata-win-control=\"WinJS.UI.ListView\"\n\t\t\tdata-win-options=\"{\n\t\t\t\titemDataSource: Sample.Samples.dataSource,\n\t\t\t\titemTemplate: select('.smallListIconTextTemplate'),\n\t\t\t\tselectionMode: 'single',\n\t\t\t\ttapBehavior: 'directSelect',\n\t\t\t\tlayout: { type: WinJS.UI.ListLayout }}\">\n\t\t</div>\n    </div>\n\n    <div class=\"pivotItem\" data-win-control=\"WinJS.UI.PivotItem\" data-win-options=\"{ 'header': 'Utilities' }\">\n\t\t<div id=\"utilList\" class=\"listView win-selectionstylefilled\"\n\t\t\tdata-win-control=\"WinJS.UI.ListView\"\n\t\t\tdata-win-options=\"{\n\t\t\t\titemDataSource: Sample.Utils.dataSource,\n\t\t\t\titemTemplate: select('.smallListIconTextTemplate'),\n\t\t\t\tselectionMode: 'single',\n\t\t\t\ttapBehavior: 'directSelect',\n\t\t\t\tlayout: { type: WinJS.UI.ListLayout }}\">\n\t\t</div>\n    </div>\n\n    <div class=\"pivotItem\" data-win-control=\"WinJS.UI.PivotItem\" data-win-options=\"{ 'header': 'Apps' }\">\n\t\t<div id=\"appList\" class=\"listView win-selectionstylefilled\"\n\t\t\tdata-win-control=\"WinJS.UI.ListView\"\n\t\t\tdata-win-options=\"{\n\t\t\t\titemDataSource: Sample.Apps.dataSource,\n\t\t\t\titemTemplate: select('.smallListIconTextTemplate'),\n\t\t\t\tselectionMode: 'single',\n\t\t\t\ttapBehavior: 'directSelect',\n\t\t\t\tlayout: { type: WinJS.UI.ListLayout }}\">\n\t\t</div>\n    </div>\n</div>\n\n<br/>\n<button style=\"height:40px\" onclick=\"runSample()\">Run Sample</button>\n<input type=\"checkbox\" id=\"chkNewWindow\" checked>in new window",
  "scriptText": "function EVT_WindowResize() {\n    switch (sandbox.volatile.env) {\n        case \"IDE\" : \n        \talertify.log(\"This app only displays properly with a WinJS version\");\n        \t//$(\"#samplePivot\").height($(\"#UI_MainPlaceholder\").height - 100); \n\t\t\t//$(\".listView\").height($(\"#UI_MainPlaceholder\").height - 120);\n            //break;\n        case \"IDE WJS\" : \n            $(\"#samplePivot\").height($(window).height() - 440);\n\t\t\t$(\".listView\").height($(window).height()-460);\n            break;\n        case \"SBL\" : \n        \talertify.log(\"This app only displays properly with a WinJS version\");\n        \t//$(\"#samplePivot\").height($(window).height() - 200); \n\t\t\t//$(\".listView\").height($(window).height()-220);\n            break;\n        case \"SBL WJS\" : \n        \t$(\"#samplePivot\").height($(window).height() - 200); \n\t\t\t$(\".listView\").height($(window).height()-220);\n\n            break;\n        case \"STANDALONE\" : \n        \t$(\"#samplePivot\").height($(window).height() - 200); \n\t\t\t$(\".listView\").height($(window).height()-220);\n            break;\n        default : break;\n    }\n           // $(\"#samplePivot\").height(500);\n}\n\nvar samples = new WinJS.Binding.List([\n\t{ name: \"Alertify Demo\", icon: \"fa fa-flask fa-2x\", desc: \"Demonstration of using the Alertify.js library for prompts/notifications.\", progName: \"Alertify Demo.prg\" },\n\t{ name: \"Codemirror Demo\", icon: \"fa fa-flask fa-2x\", desc: \"Add syntax highlighting code/data editors to your programs\", progName: \"Codemirror demo.prg\" },\n\t{ name: \"CryptoJS\", icon: \"fa fa-flask fa-2x\", desc: \"Rough demo of basic Crypto.JS operations\", progName: \"CryptoJS.prg\" },\n\t{ name: \"CryptoWorker Demo\", icon: \"fa fa-flask fa-2x\", desc: \"Show how to use the crypto_worker.js multithreaded web worker\", progName: \"CryptoWorker Demo.prg\" },\n\t{ name: \"D3.js Sample\", icon: \"fa fa-flask fa-2x\", desc: \"D3.js is a visualization toolkit way more powerful than this example can show\", progName: \"D3 sample.prg\" },\n\t{ name: \"Dynatree Demo\", icon: \"fa fa-flask fa-2x\", desc: \"Demonstration of using the Dynatree third party TreeView control\", progName: \"Dynatree Demo.prg\" },\n\t{ name: \"EaselJS Demo\", icon: \"fa fa-flask fa-2x\", desc: \"A simple tutorial of using the EaselJS graphics library\", progName: \"EaselJS Demo.prg\" },\n\t{ name: \"Font Awesome\", icon: \"fa fa-flask fa-2x\", desc: \"Shows how you might use this font-based vector icon library\", progName: \"Font Awesome.prg\" },\n\t{ name: \"Geolocation Coordinates\", icon: \"fa fa-flask fa-2x\", desc: \"Gets raw coordinates from Geolocation API\", progName: \"Geolocation Coordinates.prg\" },\n\t{ name: \"Geolocation GetMap\", icon: \"fa fa-flask fa-2x\", desc: \"Uses geolocation to get location, and then fetches a google map\", progName: \"Geolocation GetMap.prg\" },\n\t{ name: \"Geolocation Track\", icon: \"fa fa-flask fa-2x\", desc: \"Supposedly real time tracking of location\", progName: \"Geolocation Track.prg\" },\n\t{ name: \"jqPlot Demo\", icon: \"fa fa-flask fa-2x\", desc: \"Pie, Bar, and Line graph demo using jplot library\", progName: \"jqPlot Demo.prg\" },\n\t{ name: \"JsonEditor Forms Sample\", icon: \"fa fa-flask fa-2x\", desc: \"JSON Editor library sample takes a JSON Schema and uses it to generate an HTML form\", progName: \"JsonEditor Forms Sample.prg\" },\n\t{ name: \"Knockout.js sample\", icon: \"fa fa-flask fa-2x\", desc: \"This sample demonstrates how to use this Model/View framework for databinding\", progName: \"hello knockout.prg\" },\n\t{ name: \"Loki.js examples\", icon: \"fa fa-flask fa-2x\", desc: \"Sample showing loki.js usage\", progName: \"loki examples.prg\" },\n\t{ name: \"SandboxIO\", icon: \"fa fa-flask fa-2x\", desc: \"Shows how to do simple FileAPI with TridentSandbox file pickers\", progName: \"SandboxIO.prg\" },\n\t{ name: \"Springy Demo\", icon: \"fa fa-flask fa-2x\", desc: \"Demo of the Springy force directed graph control\", progName: \"Springy Demo.prg\" },\n\t{ name: \"TinyMCE Demo\", icon: \"fa fa-flask fa-2x\", desc: \"Simple example showing how to create a TinyMCE Wysiwyg HTML editor\", progName: \"TinyMCE Demo.prg\" },\n\t{ name: \"Trident API Demo\", icon: \"fa fa-flask fa-2x\", desc: \"Demonstrates how to use the new Trident API via the VAR_TRIDENT_API object/class\", progName: \"Trident API Demo.prg\" },\n\t{ name: \"WebGL Spinning Crate\", icon: \"fa fa-flask fa-2x\", desc: \"A simple -textured- WebGL spinning cube using three.js\", progName: \"WebGL Spinning Crate.prg\" },\n\t{ name: \"Babylon.JS Spinning Crate\", icon: \"fa fa-flask fa-2x\", desc: \"A WebGL spinning crate with lighting and mouse using Babylon.js\", progName: \"Babylon.JS Sample (WebGL).prg\" },\n\t{ name: \"WinJS Promises\", icon: \"fa fa-flask fa-2x\", desc: \"WinJS Promises sample (chaining methods with error handling)\", progName: \"WinJS Promises.prg\" },\n\t{ name: \"WinJS Scheduler\", icon: \"fa fa-flask fa-2x\", desc: \"WinJS Scheduler sample (lets you queue javascript work items with priorities)\", progName: \"WinJS Scheduler.prg\" }\n]);\n\nvar utils = new WinJS.Binding.List([\n\t{ name: \"Library Unit Management\", icon: \"fa fa-wrench fa-2x\", desc: \"A Utility for Managing the Markup and Script Unit Libraries stored in the TridentDB\", progName: \"Library Unit Management.prg\" },\n\t{ name: \"Trident Backup / Restore\", icon: \"fa fa-wrench fa-2x\", desc: \"Backup and Restore items in the TridentDB\", progName: \"Trident Backup Restore.prg\" },\n\t{ name: \"Trident Files Database\", icon: \"fa fa-wrench fa-2x\", desc: \"Maintain a library of small/medium files in the TridentDB\", progName: \"Hosted Files Database.prg\" },\n\t{ name: \"Trident DB Usage\", icon: \"fa fa-wrench fa-2x\", desc: \"Demonstrates basic use of TridentDB API functions\", progName: \"Trident DB Usage.prg\" },\n\t{ name: \"Keystore Finder\", icon: \"fa fa-wrench fa-2x\", desc: \"If you run a keystore service but its ip address changes, this can find it.\", progName: \"KeystoreBeacon.prg\" }\n]);\n\nvar apps = new WinJS.Binding.List([\n\t{ name: \"HTML 5 Starfield Fullscreen\", icon: \"fa fa-cogs fa-2x\", desc: \"A nice fullscreen canvas starfield simulator\", progName: \"HTML 5 Starfield Fullscreen.prg\" },\n\t{ name: \"PixiJS Morph Demo\", icon: \"fa fa-cogs fa-2x\", desc: \"Graphic Demo of pixi.js : a 2d WebGL graphics library with canvas fallback.\", progName: \"PixiJS Morph Demo.prg\" },\n\t{ name: \"Antikythera (WinJS version)\", icon: \"fa fa-cogs fa-2x\", desc: \"A 'Days Since / Days Until' up for single or recurring tasks (Hosted/AppCache)\", progName: \"Antikythera-WJS.prg\" },\n\t{ name: \"CryptoJS File Hasher\", icon: \"fa fa-cogs fa-2x\", desc: \"Drag and drop files to generate SHA1 and MD5 hashes\", progName: \"CryptoJS File Hasher.prg\" },\n\t{ name: \"HieroCryptes Notepad (WinJS version)\", icon: \"fa fa-cogs fa-2x\", desc: \"An Encrypted, Hierarchical, Wysiwyg HTML Editor Notepad\", progName: \"HieroCryptes-WJS.prg\" },\n\t{ name: \"JSON Databank (WinJS version)\", icon: \"fa fa-cogs fa-2x\", desc: \"A dynamic datafiler app using loki and jsoneditor\", progName: \"JSONDatabank-WJS.prg\" },\n\t{ name: \"Loki Continuum\", icon: \"fa fa-cogs fa-2x\", desc: \"A financial simulation engine port from c#\", progName: \"LokiContinuum.prg\" },\n\t{ name: \"Trident Binary Encryptor\", icon: \"fa fa-cogs fa-2x\", desc: \"Encrypt/Decrypt binary files\", progName: \"Trident Binary Encryptor.prg\" },\n\t{ name: \"Sandbox Radio\", icon: \"fa fa-cogs fa-2x\", desc: \"A streaming radio player app.  Uses cross platform HTML 5 audio to handle streaming.\", progName: \"Sandbox Radio WJS.prg\" }\n]);\n\nfunction runSample() {\n\tvar listRef = null;\n    \n\tvar pivot = document.getElementById(\"samplePivot\").winControl;\n    switch(pivot.selectedIndex) {\n    \tcase 0: \n            listRef = document.getElementById(\"sampleList\").winControl;\n            listRef.selection.getItems().then(function(items) {\n                loadSample(items[0].data.progName);\n            });\n            break;\n        case 1: \n            listRef = document.getElementById(\"utilList\").winControl;\n            listRef.selection.getItems().then(function(items) {\n                loadSample(items[0].data.progName);\n            });\n            break;\n        case 2: \n            listRef = document.getElementById(\"appList\").winControl;\n            listRef.selection.getItems().then(function(items) {\n                loadSample(items[0].data.progName);\n            });\n            break;\n    }\n}\n\nfunction loadSample(progName) {\n\tvar url = \"\";\n    \n    if ($(\"#chkNewWindow\").is(\":checked\")) {\n    \twindow.open(\"SandboxLoaderWJS.htm#RunApp=\"+ progName.replace(\".prg\", \"\"), \"_blank\");\n    \treturn;\n    }\n    //if (VAR_ForceOnlineSamples) url = \"http://www.obeliskos.com/TridentSandbox/\";\n    \n   \turl += \"samples/\" + progName;\n    \n\tjQuery.ajax({\n\t\ttype: \"GET\",\n\t\turl: url,\n\t\t//cache: false,\n\t\tdataType: \"json\",\n\n\t\tsuccess: function (response) {\n\t\t\tvar sandboxObject = response;\n\t\t\n\t\t\t$(\"#sb_txt_ProgramName\").val(sandboxObject.progName);\n\n\t\t\t\teditorMarkup.setValue(sandboxObject.htmlText);\n\t\t\t\teditorScript.setValue(sandboxObject.scriptText);\n\n\t\t\t\tsb_markup_hash = CryptoJS.SHA1(sandboxObject.htmlText).toString();\n\t\t\t\tsb_script_hash = CryptoJS.SHA1(sandboxObject.scriptText).toString();\n                \n\t\t\t\t// IE's HTML 5 file control seems to place a lock on the last loaded file which\n\t\t\t\t// was interfering with the saving and overwriting of that same file.\n\t\t\t\t// So i will reset it by destroying and recreating, allowing the GC to release\n\t\t\t\t// any old file locks.\n\t\t\t\tvar control = $(\"#sb_file\");\n\t\t\t\tcontrol.replaceWith( control = control.clone( true ) );\n                \n                // Not going through API for this ajax load of prg, so \n                // we will do our own housecleaning\n                EVT_WindowResize = null;\n                \n                sb_run();\n      \t\t},\n\t\t\terror: function (xhr, ajaxOptions, thrownError) {\n\t\t\t\tAPI_LogMessage(\"If you are hosting this on your own server, make sure to add mime type for .prg files as text/json\");\n\n\t\t\t\talertify.log(xhr.status + \" : \" + xhr.statusText);\n      \t\t}\n\t});\n\n}\n\nWinJS.Namespace.define(\"Sample\", {\n\tSamples: samples,\n\tUtils: utils,\n\tApps: apps,\n    sampleList : null,\n    utilList : null,\n    appList : null\n});\n\nfunction itemClicked(obj) {\n\tvar pc = $(obj).find(\".progclass\").text();\n  API_Inspect(pc);\n}\n\n//WinJS.UI.processAll().then(function () {\n//});\n\nWinJS.Utilities.ready(function () {\n    WinJS.Binding.processAll(null, Sample).then(function () {\n        WinJS.UI.processAll().done(function () {\n            EVT_WindowResize();\n            \n            // Using button to trigger sample 'load'\n            // If rather do on list click, there seems to be issue with \n            // pivot's listviews not being ready after processAll.\n            // If we need this event we need to processAll for each listView\n            \n            /*\n            Sample.sampleList = document.getElementById('sampleList');\n            WinJS.UI.processAll(Sample.sampleList).then(function() {\n                Sample.sampleList.winControl.oniteminvoked = function(e) {\n                    e.detail.itemPromise.then(function(item) {\n                        alertify.log(\"sample : \" + item.data.progName);\n                    });\n                };\n            });\n            \n            Sample.utilList = document.getElementById('utilList');\n            WinJS.UI.processAll(Sample.utilList).then(function() {\n                Sample.utilList.winControl.oniteminvoked = function(e) {\n                    e.detail.itemPromise.then(function(item) {\n                        alertify.log(\"util : \" + item.data.progName);\n                    });\n                };\n            });\n            \n            Sample.appList = document.getElementById('appList');\n            WinJS.UI.processAll(Sample.appList).then(function() {\n                Sample.appList.winControl.oniteminvoked = function(e) {\n                    e.detail.itemPromise.then(function(item) {\n                        alertify.log(\"app : \" + item.data.progName);\n                    });\n                };\n            });\n            */\n        });\n    })\n});\n\n"
}