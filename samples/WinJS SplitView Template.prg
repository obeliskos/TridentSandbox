{
  "progName": "WinJS SplitView Template",
  "htmlText": "<style>\n    .divider{\n        width:25px;\n        height:auto;\n        display:inline-block;\n    }\n    \n    .content,\n    #app {\n        height: 100%;\n    }\n\n    #app .win-splitviewpanetoggle {\n        float: left;\n    }\n\n    /* SplitView pane content style*/\n    #app .header {\n        white-space: nowrap;\n    }\n\n    #app .title {\n        font-size: 25px;\n        left: 50px;\n        margin-top: 6px;\n        vertical-align: middle;\n        display: inline-block;\n    }\n\n    #app .nav-commands {\n        margin-top: 20px;\n    }\n\n    .win-splitviewcommand-button {\n        background-color: transparent;\n    }\n\n    #app .win-splitview-pane-closed .win-splitviewcommand-label {\n    /*  Make sure pane content doesn't scroll if \n    SplitViewCommand label receives focus while pane is closed.\n    */\n        visibility: hidden;\n    }\n\n    /*SplitView content style : Change main background color here */\n    #app .win-splitview-content {\n        background-color: rgb(40,40,40);\n    }\n\n    #app .contenttext {\n        margin-left: 20px;\n        margin-top: 6px;\n    }\n\n</style>\n\n<div id=\"app\">\n    <!-- Main WinJS SplitView control -->\n    <div class=\"splitView\" data-win-control=\"WinJS.UI.SplitView\">\n        <!-- Pane area -->\n        <div style=\"min-height:800px\">\n            <div class=\"header\">\n                <button\n                    class=\"win-splitviewpanetoggle\"\n                    data-win-control=\"WinJS.UI.SplitViewPaneToggle\"\n                    data-win-options=\"{ splitView: select('.splitView') }\"\n                ></button>\n                <div class=\"title\">Template Commands</div>\n            </div>\n\n            <div class=\"nav-commands\">\n                <!-- The icons referenced in these commands are WinJS icons, google for list of all available WinJS icon names -->\n                <div data-win-control=\"WinJS.UI.SplitViewCommand\" data-win-options=\"{ id:'cmdFullscreen', label: 'Fullscreen', icon: 'fullscreen', onclick: TemplateApp.fullscreenCommand }\"></div>\n                <div data-win-control=\"WinJS.UI.SplitViewCommand\" data-win-options=\"{ label: 'Home', icon: 'home', onclick: TemplateApp.homeCommand }\"></div>\n                <div data-win-control=\"WinJS.UI.SplitViewCommand\" data-win-options=\"{ label: 'Edit', icon: 'list', onclick: TemplateApp.editCommand }\"></div>\n                <div data-win-control=\"WinJS.UI.SplitViewCommand\" data-win-options=\"{ label: 'File', icon: 'save', onclick: TemplateApp.fileCommand }\"></div>\n                <div data-win-control=\"WinJS.UI.SplitViewCommand\" data-win-options=\"{ label: 'Settings', icon: 'settings', onclick: TemplateApp.settingsCommand }\"></div>\n                <div data-win-control=\"WinJS.UI.SplitViewCommand\" data-win-options=\"{ id:'cmdAbout', label: 'About', icon: 'help', onclick: TemplateApp.aboutCommand }\"></div>\n            </div>\n        </div>\n\n        <!-- Content area -->\n        <div class=\"contenttext\">\n            <div id=\"divHome\">\n                <h3>\n                    Welcome to the WinJS SplitView Template Home Screen\n                </h3>\n                \n                <p>\n                    This template can be used to quickly create your own SplitView style \n                    Trident Sandbox program. It consists of :\n                    \n                </p>\n                <ul>\n                    <li>WinJS SplitView</li>\n                    <li>WinJS ContentDialog</li>\n                    <li>WinJS Toggle control</li>\n                    <li>Establishes a sample 'About' dialog</li>\n                    <li>Establishes a sample editable content dialog</li>\n                    <li>Adds fullscreen SplitView command</li>\n                </ul>\n                <p>\n                    Within the javascript, we also establish a WinJS 'namespace' which contains the events we want our WinJS controls to be able to invoke.\n                    Replace the sample content on this 'content page' (as well as the other content pages) with your own content. <br/>\n                    If you want different icons than the ones I have picked, you can google 'winjs icons' to find out the icons available and their names.\n                </p>\n            </div>\n            <div id=\"divEdit\" style=\"display:none\">\n                Edit Screen<br/><br/>\n                This screen might be used for editing your program data, or anything else.  \n                Your data might be displayed in a list, and if a user wants to edit an item in the list,\n                you might invoke a WinJS ContentDialog such as the below button triggers.\n                <br/><br/>\n                <button class=\"minimal\" style=\"width:240px\" onclick=\"showDialog()\">\n                    Show Content Dialog\n                </button>\n            </div>\n            <div id=\"divFile\" style=\"display:none\">\n                File Screen<br/><br/>\n                \n                <ul>\n                    <li>If your program has no need to save data, you can get rid of this screen (which is a simple html div).</li>\n                    <li>If your program only needs to save a single file, you can alter the splitview command to call a save event off of the TemplateApp namespace (rather than an event to show this div)</li>\n                    <li>If your program needs to load/save, import/export multiple ways, this screen can contain the presentation logic to do so.</li>\n                </ul>\n                \n                \n            </div>\n            <div id=\"divSettings\" style=\"display:none\">\n                Settings<br/><br/>\n                If your program has any settings, you might manage those here.  If not, remove this div, remove the splitview command from the SplitView markup, and remove the settingsCommand event handler from the 'TemplateApp' WinJS namespace (in javascript).\n                <div id=\"wifiToggle\" data-win-control=\"WinJS.UI.ToggleSwitch\" data-win-options=\"{title: 'WiFi', checked: true, onchange: toggleWifi}\">\n                </div>\n            </div>\n        </div>\n    </div> \n    \n    <!-- This is a template about box, which is rendered as a WinJS Content Dialog -->\n    <div class=\"box\">\n        <div id=\"dialogAbout\" \n             data-win-control=\"WinJS.UI.ContentDialog\" \n             data-win-options=\"{\n                               title: 'About SplitView Template',\n                               primaryCommandText: 'Close'\n                               }\">\n\n            <div align='center' style=\"display: inline-block; padding:4px; color:#494; width:160px\">\n            </div>&nbsp;\n            <p>App Version : <span id=\"spnVersion\"></span><br/>\n                TridentSandbox Version : <span id=\"spnTridentVersion\"></span></p>\n\n            <p>\n                <i style=\"color:#ff9\">SplitView Template App</i> is a starter template program for creating a WinJS SplitView application.<br/><br/>\n                \n            </p>\n\n            <div style=\"height: 50px; width: 1px;\"></div>\n        </div>\n    </div>\n\n<!-- \nThis represents a WinJS content dialog you can add your own controls to.\nAlthough this is a WinJS control, the html inside is regular html.\nThe icons i am utilizing in the radio button area are Font Awesome icons.\n-->\n    <div class=\"box\">\n        <div id=\"dialogStationEdit\" data-win-control=\"WinJS.UI.ContentDialog\" data-win-options=\"{title: 'Station Info',primaryCommandText: 'Save', secondaryCommandText: 'Cancel' }\">\n            <input type=\"hidden\" id=\"hfStationId\">\n            <br/>\n            <table>\n                <tr>\n                    <td align=\"center\" width=\"120\"><label>Name</label></td>\n                    <td><input id=\"txtStationName\" type=\"text\" style=\"width:320px\"/></td>\n                </tr>\n                <tr>\n                    <td align=\"center\"><label>Url</label></td>\n                    <td><input type=\"text\" id=\"txtStationUrl\" style=\"width:320px\"/></td>\n                </tr>\n                <tr>\n                    <td>&nbsp;</td>\n                    <td></td>\n                </tr>\n                <tr>\n                    <td align=\"center\"><label>Icon</label></td>\n                    <td>\n                        <div class=\"divider\"></div>\n                        <input type=\"radio\" name=\"stationtype\" id=\"rdoVolume\" value=\"volume\" checked><i class=\"fa fa-volume-up fa-2x\"></i>\n                        <div class=\"divider\"></div>\n                        <input type=\"radio\" name=\"stationtype\" id=\"rdoCloud\" value=\"download\"><i class=\"fa fa-cloud-download fa-2x\"></i>\n                        <div class=\"divider\"></div>\n                        <input type=\"radio\" name=\"stationtype\" id=\"rdoTalk\" value=\"comment\"><i class=\"fa fa-comment-o fa-2x\"></i>\n\n                    </td>\n                </tr>\n            </table>\n        </div>\n    </div>\n\n</div>\n\n\n",
  "scriptText": "// go ahead and set version fields within the about dialog\n$(\"#spnVersion\").text(\"0.1 (alpha)\");\n$(\"#spnTridentVersion\").text(sandbox.volatile.version);\n\n// listen to window resize events and handle here\nsandbox.events.windowResize = function() {\n    var resizeHeight = 350;\n\n    switch (sandbox.volatile.env) {\n        case \"IDE\" : resizeHeight = $(window).height() - 520; \n            $(\"#app\").height($(window).height()-300); \n            break;\n        case \"IDE WJS\" : resizeHeight = $(window).height() - 520; \n            $(\"#app\").height($(window).height()-300); \n            break;\n        case \"SBL\" : resizeHeight = $(window).height() - 230; \n            $(\"#app\").height($(window).height()-5); \n            break;\n        case \"SBL WJS\" : resizeHeight = $(window).height() - 180; $(\"button\").css(\"min-width\", \"0px\"); \n            $(\"#app\").height($(window).height()-5); \n            break;\n        case \"STANDALONE\" : resizeHeight = $(window).height() - 340; break;\n        default : break;\n    }\n};\n\n// Since this 'event' is triggered from (non-winjs) button we just use regular function\nfunction showDialog() {\n    dialog = document.getElementById(\"dialogStationEdit\").winControl;\n    dialog.show().then(function (info) {\n        if (info.result == \"primary\") {\n            alertify.log(\"Station Name : \" + $(\"#txtStationName\").val());\n            alertify.log(\"Url : \" + $(\"#txtStationUrl\").val());\n\n            var icon = $(\"input[name=stationtype]:checked\").val();\n            switch (icon) {\n                case \"volume\" : alertify.log(\"volume icon\"); break;\n                case \"download\" : alertify.log(\"download icon\"); break;\n                case \"comment\" : alertify.log(\"comment icon\"); break;\n            }\n        }\n    });\n}\n\nvar toggleWifi = function() {\n    var obj = document.getElementById(\"wifiToggle\").winControl;\n    alertify.log(\"Wifi toggled. Current status: \" + (obj.checked ? \"on\" : \"off\"));\n};\n\n// To protect against untrusted code execution, all functions are required to be marked as supported for processing before they can be used inside a data-win-options attribute in HTML markup.\nWinJS.Utilities.markSupportedForProcessing(toggleWifi);\n\nWinJS.Namespace.define(\"TemplateApp\", {\n    fullscreenCommand : WinJS.UI.eventHandler(function (ev) {\n        var sv = document.querySelector(\".splitView\").winControl;\n        sv.paneOpened = false;\n        \n        sandbox.ui.fullscreenToggle();\n    }),\n    aboutCommand: WinJS.UI.eventHandler(function(ev) {\n        var sv = document.querySelector(\".splitView\").winControl;\n        sv.paneOpened = false;\n        \n        var contentDialog = document.getElementById(\"dialogAbout\").winControl;\n        contentDialog.show();\n    }),\n    homeCommand: WinJS.UI.eventHandler(function(ev) {\n        var sv = document.querySelector(\".splitView\").winControl;\n        sv.paneOpened = false;\n        \n        $(\"#divEdit\").hide();\n        $(\"#divFile\").hide();\n        $(\"#divSettings\").hide();\n        $(\"#divHome\").show();\n    }),\n    editCommand: WinJS.UI.eventHandler(function(ev) {\n        var sv = document.querySelector(\".splitView\").winControl;\n        sv.paneOpened = false;\n        \n        $(\"#divHome\").hide();\n        $(\"#divFile\").hide();\n        $(\"#divSettings\").hide();\n        $(\"#divEdit\").show();\n    }),\n    fileCommand: WinJS.UI.eventHandler(function(ev) {\n        var sv = document.querySelector(\".splitView\").winControl;\n        sv.paneOpened = false;\n        \n        $(\"#divHome\").hide();\n        $(\"#divEdit\").hide();\n        $(\"#divSettings\").hide();\n        $(\"#divFile\").show();\n    }),\n    settingsCommand: WinJS.UI.eventHandler(function(ev) {\n        var sv = document.querySelector(\".splitView\").winControl;\n        sv.paneOpened = false;\n        \n        $(\"#divHome\").hide();\n        $(\"#divEdit\").hide();\n        $(\"#divFile\").hide();\n        $(\"#divSettings\").show();\n    })\n});\n\nWinJS.UI.processAll().done(function () {\n    var splitView = document.querySelector(\".splitView\").winControl;\n    new WinJS.UI._WinKeyboard(splitView.paneElement); // Temporary workaround: Draw keyboard focus visuals on NavBarCommands\n    \n    // now that splitview has rendered, fit it to screen height\n    sandbox.events.windowResize();\n});\n"
}