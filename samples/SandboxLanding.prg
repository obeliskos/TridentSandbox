{
  "progName": "SandboxLanding",
  "htmlText": "<style>\na.wjslink {\n   color: rgba(156, 114, 255, 0.47);\n}\na.wjslink:hover {\n   color: rgba(156, 114, 255, 0.87);\n}\n\n.fullScreen {\n    width: 100%;\n    height: 100%;\n    position: absolute;\n    top: 0;\n    left: 0;\n}\n\n/*width of each section*/\n.section1.win-hub-section {\n    width: 650px;\n    overflow: hidden;\n}\n\n.section2.win-hub-section {\n    width: 650px; \n}\n\n.section3.win-hub-section {\n    width: 900px;\n}\n\n.section4.win-hub-section {\n    width: 630px;\n}\n\n/*Images in a FlexBox*/\n.imagesFlexBox {\n    display: flex;\n    flex-flow: row wrap;\n    flex-direction: column;\n    width: calc(100% + 10px);\n    height: 100%;\n    overflow: hidden;\n    margin-left: -5px;\n    margin-right: -5px;\n}\n\n    .imagesFlexBox .imageItem {\n        margin: 5px;\n    }\n\n#insertListView {\n    height: 100%;\n}\n\n.horizontallistview {\n    height: 100%;\n}\n\n/*ListView style inside section container*/\n#listView.win-listview {\n    height: calc(100% - 150px);\n    width: 100%;\n}\n\n\n#listView.win-listview .win-container {\n    width: 242px;\n    height: 60px;\n}\n\n/*App Header Styles*/\n#appHeader {\n    position: absolute;\n    z-index: 1;\n    top: 20px;\n    left: 50px;\n}\n\n    #appHeader .win-navigation-backbutton {\n        margin-right: 20px;\n    }\n\n    #appHeader h1 {\n        display: inline;\n    }\n\n/*styles when app is in the portrait mode*/\n@media all and (min-height: 1280px) {\n    .section2.win-hub-section {\n        overflow: hidden;\n    }\n}\n\n/*styles for larger screens*/\n@media (min-width: 1920px) {\n    .section2.win-hub-section {\n        overflow: hidden;\n    }\n\n    /*change the width of the form control to cover only one input box*/\n    .section4.win-hub-section {\n        width: 300px;\n    }\n\n}\n\n</style>\n\n<div id=\"divMainFS\" class=\"fullScreen\" style=\"display:none\">\n\n    <!-- app header and backbutton-->\n    <div id=\"appHeader\">\n        <button data-win-control=\"WinJS.UI.BackButton\"></button>\n        <h2>Welcome to the TridentSandbox Sandbox Landing page</h2>\n    </div>\n\n    <!-- Template for ListView in section 2 -->\n    <div class=\"smallListIconTextTemplate\" data-win-control=\"WinJS.Binding.Template\">\n        <div class=\"smallListIconTextItem\">\n            <img src=\"#\" class=\"smallListIconTextItem-Image\" data-win-bind=\"src: picture\" />\n            <div class=\"smallListIconTextItem-Detail\">\n                <h4 data-win-bind=\"textContent: title\"></h4>\n                <h6 data-win-bind=\"textContent: text\"></h6>\n            </div>\n        </div>\n    </div>\n\n    <!-- Hub Control -->\n    <div data-win-control=\"WinJS.UI.Hub\">\n        <div class=\"section1\" data-win-control=\"WinJS.UI.HubSection\" data-win-options=\"{header: 'Trident Sandbox', isHeaderStatic: true}\">\n            <div>\n            <p>TridentSandbox is a browser-app development environment.&nbsp; It allows you to build browser apps, within a browser itself.&nbsp; It uses HTML5 appcache to allow you \n            to use the environment even if you have no internet connection.&nbsp; It takes advantage of your browser's sandbox storage capabillities like local storage and indexeddb to let \n            you store an run your programs within your browser, even when offline.  Your apps are still sandboxed, but they have persistence and can input/output via IndexedDb, local storage, FileAPI (load/save dialogs), AJAX, and copy/paste.</p>\n            <p>The entire TridentSandbox environment has probably already been installed and \n            uses up about 8 megs of browser storage.  A typical browser may also provide \n            TridentSandbox with about 120 Megs of storage for storing your apps and data.  This can be monitored with \n            the 'Storage Summary' feature within the IDE.</p>\n            \n            <p>You will see mention of WinJS alot.  It is an open source javascript library written by Microsoft which allows browser programs to behave like 'apps'.\n            As a general rule, if you intend to target 'touch' devices, you might use the 'WinJS Version' of the Trident Sandbox IDE and if your program solely targets the desktop browser, you might use the 'Regular Version' of the Trident Sandbox IDE.</p>\n\n            </div>\n        </div>\n        <div id=\"list\" class=\"section2\" data-win-control=\"WinJS.UI.HubSection\" data-win-options=\"{header: 'Popular Links / Apps', isHeaderStatic: true}\">\n            <div>\n            \n                <div class=\"live-tile  cobalt two-wide\" id=\"tileIDE\" data-direction=\"horizontal\" data-mode=\"flip\">     \n                <div><h3>Trident Sandbox IDE</h3>\n                          <span class=\"tile-title\">Trident Sandbox IDE</span>\n                    </div>\n                    <div>\n                        <p>Click here to visit the main Trident Sandbox development IDE.&nbsp; From there you can browse all samples or start developing your own app.</p>\n                           <span class=\"tile-title\">Trident Sandbox IDE</span>\n                        \n                    </div>\n                </div>\n            \n               <div class=\"live-tile mango \" id=\"tileHelp\" data-direction=\"horizontal\" data-mode=\"flip\">     \n                    <div><h3>Trident Sandbox Help pages</h3>\n                          <span class=\"tile-title\">Trident Sandbox Help</span>\n                    </div>\n                    <div>\n                        <p>Click here to view the in-depth help documentation.  \n                           <span class=\"tile-title\">Trident Sandbox Help</span>\n                        </p>\n                    </div>\n                </div>\n\n                <div class=\"live-tile red\" id=\"tileGithub\" data-mode=\"flip\">        \n                    <div>\n                        <h3>Trident Sandbox GitHub page</h3>\n                        <span class=\"tile-title\">GitHub Project Site</span>\n                    </div>\n                    <div>\n                        <p>Click here to view or download the source code to TridentSandbox.</p>\n                        <span class=\"tile-title\">GitHub Project Site</span>\n                    </div>\n                </div>\n    \n               <div class=\"live-tile green\" id=\"tileHCN\" data-direction=\"horizontal\" data-mode=\"flip\">     \n                    <div><span style=\"padding:10px; font-size:32px\"><i style=\"color:#ddd\" class=\"fa fa-sitemap\"></i>&nbsp;<i style=\"color:#ddd\" class=\"fa fa-key\"></i>&nbsp;<i style=\"color:#ddd\" class=\"fa fa-edit\"></i> </span>\n                          <span class=\"tile-title\">HieroCryptes Notepad</span>\n                    </div>\n                    <div>\n                        <p>Click here to use this Hierarchical, Encrypted Notepad app.</p>\n                           <span class=\"tile-title\">HieroCryptes Notepad</span>\n                    </div>\n                </div>\n                \n               <div class=\"live-tile green\" id=\"tileATK\" data-direction=\"horizontal\" data-mode=\"flip\">     \n                    <div>\n                    \t<span style=\"padding:10px; font-size:16px\">\n                        Keep track of how many days until or since certain dates which you enter\n                    \t</span>\n                          <span class=\"tile-title\">Antikythera</span>\n                    </div>\n                    <div>\n                    \t<p>\n                        \tClick here to run this DaysSince / DaysUntil app\n                            <span class=\"tile-title\">Antikythera</span>\n                        </p>\n                    </div>\n                </div>\n                \n               <div class=\"live-tile green\" id=\"tileJDB\" data-direction=\"horizontal\" data-mode=\"flip\">     \n                    <div>\n                    \t<span style=\"padding:10px; font-size:16px\">\n                        A data-filer type databank app for creating and editing custom data\n                    \t</span>\n                          <span class=\"tile-title\">JSON Databank</span>\n                    </div>\n                    <div>\n                    \t<p>\n                        \tClick here to run this databank app\n                            <span class=\"tile-title\">JSON Databank</span>\n                        </p>\n                    </div>\n                </div>\n                \n    \n            </div>\n        </div>\n\n        <div class=\"section3\" data-win-control=\"WinJS.UI.HubSection\" data-win-options=\"{header: 'WinJS Information', isHeaderStatic: true}\">\n        \t<table width=\"100%\">\n            <tr>\n                <td style=\"padding:5px\"><iframe width=\"560\" height=\"315\" src=\"//www.youtube.com/embed/26N2O5SLK3s\" frameborder=\"0\" allowfullscreen></iframe></td>\n            \t<td style=\"padding:5px\"><iframe width=\"560\" height=\"315\" src=\"//www.youtube.com/embed/nAzW8y7pt_w\" frameborder=\"0\" allowfullscreen></iframe></td>\n            </tr>\n            </table>\n        </div>\n    </div>\n</div>\n\n",
  "scriptText": "$(\"#UI_MainPlaceholder\").css(\"height\", \"600px\");\nAPI_SetBackgroundColor(\"#222\");\n\n    var $tileIDE = $(\"#tileIDE\").liveTile({ delay: 3500 });\n    $(\"#tileIDE\").click(function(){\n        $(this).liveTile('play', 0);\n        location.href = \"TridentSandboxWJS.htm\";\n    });\n\n    var $tileHelp = $(\"#tileHelp\").liveTile({ delay: 3750 });\n    $(\"#tileHelp\").click(function(){\n        $(this).liveTile('play', 0);\n        location.href = \"./docs/Welcome.htm\";\n    });\n\n    var $tileGithub = $(\"#tileGithub\").liveTile({ delay: 4250 });\n    $(\"#tileGithub\").click(function(){\n        $(this).liveTile('play', 0);\n        location.href = \"https://github.com/obeliskos/TridentSandbox\";\n    });\n\n    var $tileHCN = $(\"#tileHCN\").liveTile({ delay: 4000 });\n    $(\"#tileHCN\").click(function(){\n        $(this).liveTile('play', 0);\n        location.href = \"SandboxLoaderWJS.htm#RunApp=HieroCryptes-WJS\";\n    });\n\n    var $tileATK = $(\"#tileATK\").liveTile({ delay: 4100 });\n    $(\"#tileATK\").click(function(){\n        $(this).liveTile('play', 0);\n        location.href = \"SandboxLoaderWJS.htm#RunApp=Antikythera-WJS\";\n    });\n\n    var $tileJDB = $(\"#tileJDB\").liveTile({ delay: 4200 });\n    $(\"#tileJDB\").click(function(){\n        $(this).liveTile('play', 0);\n        location.href = \"SandboxLoaderWJS.htm#RunApp=JSONDatabank-WJS\";\n    });\n\nfunction EVT_CleanSandbox()\n{\n  $tileIDE.liveTile('stop');\n  $tileHCN.liveTile('stop');\n  $tileATK.liveTile('stop');\n  $tileJDB.liveTile('stop');\n  $tileHelp.liveTile('stop');\n  $tileGithub.liveTile('stop');\n  \n  EVT_CleanSandbox = null;\n}\n\nvar pageURI = \"\";\n\nswitch (VAR_TRIDENT_ENV_TYPE) {\n\tcase \"IDE WJS\" : pageURI = \"./TridentSandboxWJS.htm\"; break;\n    case \"SBL WJS\" : pageURI = location.href; break;\n\tdefault : break;    \n}\n\nWinJS.UI.Pages.define(pageURI, {\n    ready: function (element, options) {\n    \t$(\"#divMainFS\").show();\n\t},\n    \n    unload: function () {\n        // TODO: Respond to navigations away from this page.\n    },\n    \n});\n\n"
}