{
  "progName": "Samples Browser WJS",
  "htmlText": "<style>\n\n    .userIcon {\n        width: 48px;\n        height: 48px;\n        float: left;\n        margin-right: 12px;\n    }\n\n    .sampleContent {\n        width: calc(100% - 60px);\n        height: 48px;\n        float: left;\n    }\n\n    .sampleName {\n        height: 16px;\n        float: left;\n        font-weight: 600;\n        font-size: 15px;\n        line-height: 15px;\n    }\n\n    .sampleDesc {\n        width: 100%;\n        height: 32px;\n        font-size: 16px;\n        line-height: 16px;\n        padding-top: 10px;\n        overflow: hidden;\n        color: rgba(255, 255, 255, .4);\n    }\n\n    .sampleInformation {\n        width: 100%;\n        height: 17px;\n    }\n\n    .smallListIconTextItem\n    {\n        width: calc(100% - 48px);\n        min-width: 312px;\n        height: 48px;\n        margin-bottom: 1px;\n        padding: 16px 24px;\n    }\n\n    /* Override the background color for even/odd win-containers */\n    .listView .win-container.win-container-odd {\n        background-color: #333;\n    }\n\n    .listView .win-container.win-container-even {\n        background-color: #222;\n    }\n\n</style>\n\n<br/>\n<h2>Samples Browser</h2>\n\n<!-- Simple template for the ListView instantiation  -->\n<div class=\"smallListIconTextTemplate\" data-win-control=\"WinJS.Binding.Template\">\n    <div class=\"smallListIconTextItem\">\n        <div class=\"userIcon\"><i data-win-bind=\"className: icon\" /></div>\n        <div class=\"sampleContent\">\n            <div class=\"sampleInformation\">\n                <div class=\"sampleName\" data-win-bind=\"textContent: name\"></div>\n            </div>\n            <div class=\"sampleDesc\" data-win-bind=\"textContent: desc;\"></div>\n            <div class=\"progclass\" style=\"display:none\" data-win-bind=\"textContent: progName\"></div>\n        </div>\n    </div>\n</div>\n\n<div id=\"samplePivot\" class=\"wide\" data-win-control=\"WinJS.UI.Pivot\" data-win-options=\"{ selectedIndex: 0 }\">\n    <div class=\"pivotItem\" data-win-control=\"WinJS.UI.PivotItem\" data-win-options=\"{ 'header': 'Samples' }\">\n        <div id=\"sampleList\" class=\"listView win-selectionstylefilled\"\n             data-win-control=\"WinJS.UI.ListView\"\n             data-win-options=\"{\n                               itemDataSource: Sample.Samples.dataSource,\n                               itemTemplate: select('.smallListIconTextTemplate'),\n                               selectionMode: 'single',\n                               tapBehavior: 'directSelect',\n                               layout: { type: WinJS.UI.ListLayout }}\">\n        </div>\n    </div>\n\n    <div class=\"pivotItem\" data-win-control=\"WinJS.UI.PivotItem\" data-win-options=\"{ 'header': 'Utilities' }\">\n        <div id=\"utilList\" class=\"listView win-selectionstylefilled\"\n             data-win-control=\"WinJS.UI.ListView\"\n             data-win-options=\"{\n                               itemDataSource: Sample.Utils.dataSource,\n                               itemTemplate: select('.smallListIconTextTemplate'),\n                               selectionMode: 'single',\n                               tapBehavior: 'directSelect',\n                               layout: { type: WinJS.UI.ListLayout }}\">\n        </div>\n    </div>\n\n    <div class=\"pivotItem\" data-win-control=\"WinJS.UI.PivotItem\" data-win-options=\"{ 'header': 'Apps' }\">\n        <div id=\"appList\" class=\"listView win-selectionstylefilled\"\n             data-win-control=\"WinJS.UI.ListView\"\n             data-win-options=\"{\n                               itemDataSource: Sample.Apps.dataSource,\n                               itemTemplate: select('.smallListIconTextTemplate'),\n                               selectionMode: 'single',\n                               tapBehavior: 'directSelect',\n                               layout: { type: WinJS.UI.ListLayout }}\">\n        </div>\n    </div>\n</div>\n\n<br/>\n<button style=\"height:40px\" onclick=\"runSample()\">Run Sample</button>\n<input type=\"checkbox\" id=\"chkNewWindow\">in new window",
  "scriptText": "sandbox.events.windowResize = function() {\n    switch (sandbox.volatile.env) {\n        case \"IDE\" : \n            alertify.log(\"This app only displays properly with a WinJS version\");\n            break;\n        case \"IDE WJS\" : \n            $(\"#samplePivot\").height($(window).height() - 440);\n            $(\".listView\").height($(window).height()-460);\n            break;\n        case \"SBL\" : \n            alertify.log(\"This app only displays properly with a WinJS version\");\n            break;\n        case \"SBL WJS\" : \n            $(\"#samplePivot\").height($(window).height() - 200); \n            $(\".listView\").height($(window).height()-220);\n\n            break;\n        case \"STANDALONE\" : \n            $(\"#samplePivot\").height($(window).height() - 200); \n            $(\".listView\").height($(window).height()-220);\n            break;\n        default : break;\n    }\n};\n\nvar sampData = [\n    { name: \"Alertify Demo\", icon: \"fa fa-flask fa-2x\", desc: \"Demonstration of using the Alertify.js library for prompts/notifications.\", progName: \"Alertify Demo.prg\" },\n    { name: \"Codemirror Demo\", icon: \"fa fa-flask fa-2x\", desc: \"Add syntax highlighting code/data editors to your programs\", progName: \"Codemirror demo.prg\" },\n    { name: \"CryptoJS\", icon: \"fa fa-flask fa-2x\", desc: \"Rough demo of basic Crypto.JS operations\", progName: \"CryptoJS.prg\" },\n    { name: \"CryptoWorker Demo\", icon: \"fa fa-flask fa-2x\", desc: \"Show how to use the crypto_worker.js multithreaded web worker\", progName: \"CryptoWorker Demo.prg\" },\n    { name: \"D3.js Sample\", icon: \"fa fa-flask fa-2x\", desc: \"D3.js is a visualization toolkit way more powerful than this example can show\", progName: \"D3 sample.prg\" },\n    { name: \"Dynatree Demo\", icon: \"fa fa-flask fa-2x\", desc: \"Demonstration of using the Dynatree third party TreeView control\", progName: \"Dynatree Demo.prg\" },\n    { name: \"EaselJS Demo\", icon: \"fa fa-flask fa-2x\", desc: \"A simple tutorial of using the EaselJS graphics library\", progName: \"EaselJS Demo.prg\" },\n    { name: \"Font Awesome\", icon: \"fa fa-flask fa-2x\", desc: \"Shows how you might use this font-based vector icon library\", progName: \"Font Awesome.prg\" },\n    { name: \"Geolocation Coordinates\", icon: \"fa fa-flask fa-2x\", desc: \"Gets raw coordinates from Geolocation API\", progName: \"Geolocation Coordinates.prg\" },\n    { name: \"Geolocation GetMap\", icon: \"fa fa-flask fa-2x\", desc: \"Uses geolocation to get location, and then fetches a google map\", progName: \"Geolocation GetMap.prg\" },\n    { name: \"Geolocation Track\", icon: \"fa fa-flask fa-2x\", desc: \"Supposedly real time tracking of location\", progName: \"Geolocation Track.prg\" },\n    { name: \"jqPlot Demo\", icon: \"fa fa-flask fa-2x\", desc: \"Pie, Bar, and Line graph demo using jplot library\", progName: \"jqPlot Demo.prg\" },\n    { name: \"JsonEditor Forms Sample\", icon: \"fa fa-flask fa-2x\", desc: \"JSON Editor library sample takes a JSON Schema and uses it to generate an HTML form\", progName: \"JsonEditor Forms Sample.prg\" },\n    { name: \"Knockout.js sample\", icon: \"fa fa-flask fa-2x\", desc: \"This sample demonstrates how to use this Model/View framework for databinding\", progName: \"hello knockout.prg\" },\n    { name: \"Loki.js examples\", icon: \"fa fa-flask fa-2x\", desc: \"Sample showing loki.js usage\", progName: \"loki examples.prg\" },\n    { name: \"React.js example\", icon: \"fa fa-flask fa-2x\", desc: \"Sample showing how to use React.js within Trident Sandbox\", progName: \"React Sample.prg\" },\n    { name: \"SandboxIO\", icon: \"fa fa-flask fa-2x\", desc: \"Shows how to do simple FileAPI with TridentSandbox file pickers\", progName: \"SandboxIO.prg\" },\n    { name: \"Springy Demo\", icon: \"fa fa-flask fa-2x\", desc: \"Demo of the Springy force directed graph control\", progName: \"Springy Demo.prg\" },\n    { name: \"TinyMCE Demo\", icon: \"fa fa-flask fa-2x\", desc: \"Simple example showing how to create a TinyMCE Wysiwyg HTML editor\", progName: \"TinyMCE Demo.prg\" },\n    { name: \"WebGL Spinning Crate\", icon: \"fa fa-flask fa-2x\", desc: \"A simple -textured- WebGL spinning cube using three.js\", progName: \"WebGL Spinning Crate.prg\" },\n    { name: \"Babylon.JS Spinning Crate\", icon: \"fa fa-flask fa-2x\", desc: \"A WebGL spinning crate with lighting and mouse using Babylon.js\", progName: \"BabylonJS Sample WebGL.prg\" },\n    { name: \"WinJS Promises\", icon: \"fa fa-flask fa-2x\", desc: \"WinJS Promises sample (chaining methods with error handling)\", progName: \"WinJS Promises.prg\" },\n    { name: \"WinJS Scheduler\", icon: \"fa fa-flask fa-2x\", desc: \"WinJS Scheduler sample (lets you queue javascript work items with priorities)\", progName: \"WinJS Scheduler.prg\" }\n];\n\nif (sandbox.volatile.isWebkit) {\n    sampData.push({ name: \"Node Webkit Crypto\", icon: \"fa fa-flask fa-2x\", desc: \"Node Webkit Crypto Sample\", progName: \"node crypto.prg\" });\n    sampData.push({ name: \"Node Webkit Filesystem\", icon: \"fa fa-flask fa-2x\", desc: \"Node Webkit Filesystem Sample\", progName: \"node fs sample.prg\" });\n    sampData.push({ name: \"Node Webkit OS Module\", icon: \"fa fa-flask fa-2x\", desc: \"Node Webkit OS Module Sample\", progName: \"node os module.prg\" });\n}\nvar samples = new WinJS.Binding.List(sampData);\n\n\nvar utils = new WinJS.Binding.List([\n    { name: \"Library Unit Management\", icon: \"fa fa-wrench fa-2x\", desc: \"A Utility for Managing the Markup and Script Unit Libraries stored in the TridentDB\", progName: \"Library Unit Management.prg\" },\n    { name: \"Trident Files Database\", icon: \"fa fa-wrench fa-2x\", desc: \"Maintain a library of small/medium files in the TridentDB\", progName: \"Hosted Files Database.prg\" },\n    { name: \"Trident DB Usage\", icon: \"fa fa-wrench fa-2x\", desc: \"Demonstrates basic use of TridentDB API functions\", progName: \"Trident DB Usage.prg\" },\n    { name: \"Keystore Finder\", icon: \"fa fa-wrench fa-2x\", desc: \"If you run a keystore service but its ip address changes, this can find it.\", progName: \"KeystoreBeacon.prg\" }\n]);\n\nvar apps = new WinJS.Binding.List([\n    { name: \"HTML 5 Starfield Fullscreen\", icon: \"fa fa-cogs fa-2x\", desc: \"A nice fullscreen canvas starfield simulator\", progName: \"HTML 5 Starfield Fullscreen.prg\" },\n    { name: \"HieroCryptes Notepad (WinJS version)\", icon: \"fa fa-cogs fa-2x\", desc: \"An Encrypted, Hierarchical, Wysiwyg HTML Editor Notepad\", progName: \"HieroCryptes-WJS.prg\" },\n    { name: \"Sandbox Radio\", icon: \"fa fa-cogs fa-2x\", desc: \"A streaming radio player app.  Uses cross platform HTML 5 audio to handle streaming.\", progName: \"Sandbox Radio WJS.prg\" },\n    { name: \"Antikythera (WinJS version)\", icon: \"fa fa-cogs fa-2x\", desc: \"A 'Days Since / Days Until' up for single or recurring tasks (Hosted/AppCache)\", progName: \"Antikythera-WJS.prg\" },\n    { name: \"PixiJS Morph Demo\", icon: \"fa fa-cogs fa-2x\", desc: \"Graphic Demo of pixi.js : a 2d WebGL graphics library with canvas fallback.\", progName: \"PixiJS Morph Demo.prg\" },\n    { name: \"CryptoJS File Hasher\", icon: \"fa fa-cogs fa-2x\", desc: \"Drag and drop files to generate SHA1 and MD5 hashes\", progName: \"CryptoJS File Hasher.prg\" },\n    { name: \"JSON Databank (WinJS version)\", icon: \"fa fa-cogs fa-2x\", desc: \"A dynamic datafiler app using loki and jsoneditor\", progName: \"JSONDatabank-WJS.prg\" },\n    { name: \"Loki Continuum\", icon: \"fa fa-cogs fa-2x\", desc: \"A financial simulation engine port from c#\", progName: \"LokiContinuum.prg\" },\n    { name: \"Trident Binary Encryptor\", icon: \"fa fa-cogs fa-2x\", desc: \"Encrypt/Decrypt binary files\", progName: \"Trident Binary Encryptor.prg\" }\n]);\n\nfunction runSample() {\n    var listRef = null;\n\n    var pivot = document.getElementById(\"samplePivot\").winControl;\n    switch(pivot.selectedIndex) {\n        case 0: \n            listRef = document.getElementById(\"sampleList\").winControl;\n            listRef.selection.getItems().then(function(items) {\n                loadSample(items[0].data.progName);\n            });\n            break;\n        case 1: \n            listRef = document.getElementById(\"utilList\").winControl;\n            listRef.selection.getItems().then(function(items) {\n                loadSample(items[0].data.progName);\n            });\n            break;\n        case 2: \n            listRef = document.getElementById(\"appList\").winControl;\n            listRef.selection.getItems().then(function(items) {\n                loadSample(items[0].data.progName);\n            });\n            break;\n    }\n}\n\nfunction loadSample(progName) {\n    var url = \"\";\n\n    progName = progName.replace(\".prg\", \"\");\n\n    if ($(\"#chkNewWindow\").is(\":checked\")) {\n        window.open(\"SandboxLoaderWJS.htm#RunApp=\"+ progName, \"_blank\");\n        return;\n    }\n\n    sandbox.ide.runApp(progName);\n}\n\nWinJS.Namespace.define(\"Sample\", {\n    Samples: samples,\n    Utils: utils,\n    Apps: apps,\n    sampleList : null,\n    utilList : null,\n    appList : null\n});\n\nWinJS.Utilities.ready(function () {\n    WinJS.Binding.processAll(null, Sample).then(function () {\n        WinJS.UI.processAll().done(function () {\n            sandbox.events.windowResize();\n\n            /*\n            Sample.sampleList = document.getElementById('sampleList');\n            WinJS.UI.processAll(Sample.sampleList).then(function() {\n                Sample.sampleList.winControl.oniteminvoked = function(e) {\n                    e.detail.itemPromise.then(function(item) {\n                        alertify.log(\"sample : \" + item.data.progName);\n                    });\n                };\n            });\n            */\n        });\n    })\n});\n\n"
}