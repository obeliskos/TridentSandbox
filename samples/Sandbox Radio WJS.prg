{
  "progName": "Sandbox Radio WJS",
  "htmlText": "<style>\n.divider{\n    width:25px;\n    height:auto;\n    display:inline-block;\n}\n\n/* Most of these styles were brought over from listview samples on try.buildwinjs.com */\n\n#content {\n\ttext-align: center;\n}\n\n/* Override the background color for even/odd win-containers */\n.listView .win-container.win-container-odd {\n    background-color: #707070;\n}\n\n.listView .win-container.win-container-even {\n    background-color: #686868;\n}\n\n.basicToolbar {\n\tmargin-top: 0px;\n    width: 100%;\n}/* Template for the items in the ListViews in this sample */       \n#sample {\n    height: 100%;\n}\n\n#sample .smallListIconTextItem\n{\n    width: 100%;\n    height: 70px;\n    padding: 5px;\n    overflow: hidden;\n    display: -ms-flexbox;\n    display: -webkit-flex;\n    display: flex;\n}\n\n    #sample .smallListIconTextItem img.smallListIconTextItem-Image \n    {\n        width: 60px;\n        height: 60px;\n        margin: 5px;\n        margin-right:20px;\n    }\n\n    #sample .smallListIconTextItem .smallListIconTextItem-Detail\n    {\n        margin: 5px;\n    }\n\n#sample .button-well {\n    margin: 5px;\n}\n\n/* CSS applied to the ListViews in this sample */\n#sample .listView\n{\n    height: 100%;\n    background-color: #555;\n}\n\n</style>\n\n<div class=\"basicToolbar\" data-win-control=\"WinJS.UI.ToolBar\" data-win-options=\"{\n\tshownDisplayMode: 'full',\n\tclosedDisplayMode: 'full'}\">\n<!-- Primary commands -->\n            <button data-win-control=\"WinJS.UI.Command\" data-win-options=\"{\n                    id:'cmdFullscreen',\n                    label:'fullscreen',\n                    section:'primary',\n                    type:'button',\n                    icon: 'fullscreen',\n                    onclick: SbxRadio.outputCommand}\"></button>\n            <button data-win-control=\"WinJS.UI.Command\" data-win-options=\"{\n                    id:'cmdAdd',\n                    label:'add',\n                    section:'primary',\n                    type:'button',\n                    icon: 'add',\n                    onclick: SbxRadio.outputCommand}\"></button>\n            <button data-win-control=\"WinJS.UI.Command\" data-win-options=\"{\n                    id:'cmdEdit',\n                    label:'edit',\n                    section:'primary',\n                    type:'button',\n                    icon: 'edit',\n                    onclick: SbxRadio.outputCommand}\"></button>\n            <button data-win-control=\"WinJS.UI.Command\" data-win-options=\"{\n                    id:'cmdDelete',\n                    label:'delete',\n                    section:'primary',\n                    type:'button',\n                    icon: 'delete',\n                    onclick: SbxRadio.outputCommand}\"></button>\n            <button data-win-control=\"WinJS.UI.Command\" data-win-options=\"{\n                    id:'cmdSave',\n                    label:'save',\n                    section:'primary',\n                    type:'button',\n                    icon: 'save',\n                    onclick: SbxRadio.outputCommand}\"></button>\n\t\t\t<hr data-win-control=\"WinJS.UI.Command\" data-win-options=\"{type:'separator'}\" />\n            <!-- Secondary command -->\n            <button data-win-control=\"WinJS.UI.Command\" data-win-options=\"{\n                    id:'cmdAbout',\n                    label:'about',\n                    section:'primary',\n                    type:'button',\n                    icon:'help',\n                    onclick: SbxRadio.outputCommand}\"></button>\n        </div>\n        <div class=\"status\"></div>\n<br/>\n<h1>Sandbox Radio</h1>\n<br/><br/>\n\n<div id=\"divList\">\n    \t<label style=\"font-size:18pt\">Stations</label>\n\t\t<div class=\"divider\"></div>\n        <input type=\"checkbox\" id=\"chkPlayOnSelect\" checked/>Play on Select\n        \n        <div id=\"sample\">\n\n            <!-- Simple template for the ListView instantiation  -->\n            <div class=\"smallListIconTextTemplate\" data-win-control=\"WinJS.Binding.Template\" style=\"display: none\">\n                <div class=\"smallListIconTextItem\">\n                    <i style=\"color:#afa\" data-win-bind=\"className: faicon\"></i> &nbsp;\n                    <div class=\"smallListIconTextItem-Detail\">\n                        <h4 data-win-bind=\"textContent: name\"></h4>\n                        <h6 data-win-bind=\"textContent: url\"></h6>\n                    </div>\n                </div>\n            </div>\n            \n\t\t\t<!-- Elements used for header and footer elements for ListView -->\n\t\t\t<!-- The declarative markup necesary for ListView instantiation -->\n\t\t\t<!-- Call WinJS.UI.processAll() in your initialization code -->\n\t\t\t<div class=\"listView win-selectionstylefilled\"\n\t\t\t\tdata-win-control=\"WinJS.UI.ListView\"\n\t\t\t\tdata-win-options=\"{\n\t\t\t\t\titemDataSource: SbxRadio.data.dataSource,\n\t\t\t\t\titemTemplate: select('.smallListIconTextTemplate'),\n\t\t\t\t\tselectionMode: 'single',\n\t\t\t\t\ttapBehavior: 'directSelect',\n\t\t\t\t\tlayout: { type: WinJS.UI.ListLayout }}\">\n\t\t\t</div>\n        </div>\n        <br/>\n        <audio id='player' controls volume=.5>\n            <source id='mp3source' src=\"\" type=\"audio/mp3\">\n            Your browser does not support the audio tag.\n        </audio>\n</div>\n\n<div class=\"box\">\n    <div id=\"dialogAbout\" data-win-control=\"WinJS.UI.ContentDialog\" data-win-options=\"{\n             title: 'About Sandbox Radio',\n             primaryCommandText: 'Close'\n        }\">\n\t    \t<div align='left' style=\"display: inline-block; padding:4px; color:#afa; width:160px\">\n    \t\t<label style=\"font-size:20pt;\">\n    \t\t<i class=\"fa fa-volume-up\"></i>\n    \t\t</label>\n    \t\t</div>&nbsp;\n    \t\t<p>App Version : <span id=\"spnVersion\"></span><br/>\n            TridentSandbox Version : <span id=\"spnTridentVersion\"></span></p>\n            <p><b>Sandbox Radio</b> is a simple internet radio bookmarking app. It can be used for storing the urls of radio streams or music/podcast files.</p>\n            <p>This application uses the WinJS ListView, Toolbar, and ContentDialog for presentation and the HTML 5 audio control to handle playing the music streams.</p>\n            <p>The HTML audio control (or the servers themselves) are rather particular about ending the \n            stream address with a /; character pattern.  It also direct stream links, not playlist \n            redirectors (pls). A good way to add more streams is to go to <a href=\"http://www.shoutcast.com/search\" target=\"_blank\">Shoutcast.com</a> \n            and use their station browser to listen to stations and then click download, pick m3u and save file to disk.  \n            Then open that file with text editor to read direct stream address.</p>\n        <div style=\"height: 50px; width: 1px;\"></div>\n    </div>\n</div>\n\n<div class=\"box\">\n\t<div id=\"dialogStationEdit\" data-win-control=\"WinJS.UI.ContentDialog\" data-win-options=\"{\n    \ttitle: 'Station Info',\n        primaryCommandText: 'Save',\n        secondaryCommandText: 'Cancel'\n        }\">\n        <input type=\"hidden\" id=\"hfStationId\">\n        <br/>\n\t\t<table>\n\t\t<tr>\n\t\t\t<td><label>Name </label></td>\n\t\t\t<td><input id=\"txtStationName\" type=\"text\" style=\"background-color:#444; color:white; width:350px\"/></td>\n\t\t</tr>\n\t\t<tr>\n\t\t\t<td><label>Url</label></td>\n\t\t\t<td><input type=\"text\" id=\"txtStationUrl\" style=\"background-color:#444; color:white; width:350px\"/></td>\n\t\t</tr>\n        <tr>\n        \t<td><label>Icon</label></td>\n            <td>\n                <div class=\"divider\"></div>\n            \t<input type=\"radio\" name=\"stationtype\" id=\"rdoVolume\" value=\"volume\" checked><i class=\"fa fa-volume-up fa-2x\"></i>\n                <div class=\"divider\"></div>\n\t\t\t\t<input type=\"radio\" name=\"stationtype\" id=\"rdoCloud\" value=\"download\"><i class=\"fa fa-cloud-download fa-2x\"></i>\n                <div class=\"divider\"></div>\n\t\t\t\t<input type=\"radio\" name=\"stationtype\" id=\"rdoTalk\" value=\"comment\"><i class=\"fa fa-comment-o fa-2x\"></i>\n                \n\t\t\t</td>\n        </tr>\n\t\t</table>\n\t</div>\n</div>",
  "scriptText": "function EVT_WindowResize() \n{\n\t$(\".listView\").height($(window).height()-340);\n}\n\nfunction EVT_WindowResize() {\n    switch (VAR_TRIDENT_ENV_TYPE) {\n        case \"IDE\" : \n        \talertify.log(\"This app only displays properly with a WinJS version\");\n            break;\n        case \"IDE WJS\" : \n\t\t\t$(\".listView\").height($(window).height()-520);\n            break;\n        case \"SBL\" : \n        \talertify.log(\"This app only displays properly with a WinJS version\");\n            break;\n        case \"SBL WJS\" : \n        \t$(\".listView\").height($(window).height() - 340); \n            break;\n        case \"STANDALONE\" : \n        \t$(\"#samplePivot\").height($(window).height() - 200); \n\t\t\t$(\".listView\").height($(window).height()-220);\n            break;\n        default : break;\n    }\n           // $(\"#samplePivot\").height(500);\n}\n\nfunction EVT_CleanSandbox() {\n\tsbv = null;\n}\n\n// set default player volume to be a bit lower to avoid potential blaring\nvar backgroundAudio=document.getElementById(\"player\");\nbackgroundAudio.volume=0.3;\n    \nvar sbv = {\n\t// This is the default set of sites to show... if you are running local filesystem\n    // you will need to edit this to add/remove sites\n\tstationurls : [\t{ name: \"KROQ\", url : \"http://208.80.54.77:80/KROQHD2CMP3\", faicon: \"fa fa-volume-up fa-2x\" },\n\t\t\t\t{ name: \"Greek Radio Thalassa\", url : \"http://82.197.165.143:80/;\", faicon: \"fa fa-volume-up fa-2x\" },\n\t\t\t\t{ name: \"PHISH Radio\", url : \"http://209.234.243.40:8002/;\", faicon: \"fa fa-volume-up fa-2x\" },\n\t\t\t\t{ name: \"Fam Friendy Christian\", url : \"http://66.225.205.47:80/;\", faicon: \"fa fa-volume-up fa-2x\" },\n\t\t\t\t{ name: \"Good Time Oldies\", url : \"http://69.4.232.112:8166/;\", faicon: \"fa fa-volume-up fa-2x\" },\n\t\t\t\t{ name: \"95.7 XRC (Rock)\", url : \"http://knight.wavestreamer.com:9631/listen.m3u/;\", faicon: \"fa fa-volume-up fa-2x\" },\n\t\t\t\t{ name: \"Goth and Metal\", url : \"http://listen.radionomy.com/Goth-N-Metal\", faicon: \"fa fa-volume-up fa-2x\" },\n\t\t\t\t{ name: \"1.FM Movie Soundtrack Hits\", url : \"http://205.164.62.15:10108/;\", faicon: \"fa fa-volume-up fa-2x\" },\n\t\t\t\t{ name: \"Soma Underground 80s\", Ururll : \"http://xstream1.somafm.com:8880/;\", faicon: \"fa fa-volume-up fa-2x\" },\n\t\t\t\t{ name: \"Soma FM BAGel\", url : \"http://uwstream3.somafm.com:9090/;\", faicon: \"fa fa-volume-up fa-2x\" },\n\t\t\t\t{ name: \"Soma FM Groove Salad\", url : \"http://uwstream1.somafm.com:80/;\", faicon: \"fa fa-volume-up fa-2x\" },\n\t\t\t\t{ name: \"Soma FM Secret Agent\", url : \"http://xstream1.somafm.com:8002/;\", faicon: \"fa fa-volume-up fa-2x\" },\n\t\t\t\t{ name: \"Soma FM DefCon\", url : \"http://uwstream3.somafm.com:6200/;\", faicon: \"fa fa-volume-up fa-2x\" },\n\t\t\t\t{ name: \"Soma FM Space Station\", url : \"http://uwstream3.somafm.com:8000/;\", faicon: \"fa fa-volume-up fa-2x\" },\n\t\t\t\t{ name: \"Soma FM Dubstep\", url : \"http://uwstream2.somafm.com:8400/;\", faicon: \"fa fa-volume-up fa-2x\" },\n\t\t\t\t{ name: \"Soma FM Earwaves\", url : \"http://uwstream3.somafm.com:5100/;\", faicon: \"fa fa-volume-up fa-2x\" },\n\t\t\t\t{ name: \"Soma FM Lush\", url : \"http://uwstream2.somafm.com:8800/;\", faicon: \"fa fa-volume-up fa-2x\" },\n\t\t\t\t{ name: \"Soma FM SouthBySoma\", url : \"http://uwstream2.somafm.com:5500/;\", faicon: \"fa fa-volume-up fa-2x\" },\n\t\t\t\t{ name: \"BoAB 1\", url : \"http://stream1.u7radio.org:8000/;\", faicon: \"fa fa-comment-o fa-2x\" },\n                { name: \"No Agenda stream (Adam Curry & John C. Dvorak)\", url : \"http://listen.noagendastream.com/noagenda\", faicon: \"fa fa-comment-o fa-2x\" }\n                ],\n                \n    mainListView : null,\n    stationListView : null,\n\n\tdb: new loki('StationDb'),\n\tstations: null,\n    ver: \"2.0\"\n};\n\n$(\"#spnVersion\").text(sbv.ver);\n$(\"#spnTridentVersion\").text(VAR_TRIDENT_VERSION);\n\nfunction initTridentDb() {\n\tsbv.stations = sbv.db.addCollection('stations', 'stations');\n\tsbv.stations.insert(sbv.stationurls);\n}\n\nfunction radioInit() {\n    if (VAR_TRIDENT_DB) {\n\t\tVAR_TRIDENT_API.GetAppKey('SandboxRadio', 'StationData', function (result) {\n        \t// if no data then just load up the default hardcoded data\n            //API_Inspect(result);\n        \tif (result.id == 0) {\n\t            initTridentDb();\n                showStationsInDb();\n            \treturn;\n        \t}\n        \n      \t\tsbv.db.loadJSON(result.val);\n\n\t\t\t// we rehydrated loki db object and collections but old collection references still\n  \t\t\t// point to old db object. \n\t\t\tsbv.stations = sbv.db.getCollection(\"stations\");\n            showStationsInDb();\n      });\n   }\n}\n\nfunction saveStations() {\n\tif(VAR_TRIDENT_DB) {\n        VAR_TRIDENT_API.SetAppKey('SandboxRadio', \"StationData\", JSON.stringify(sbv.db), function(result) {\n\t\t\tif (result.success) {\n\t\t\t\talertify.success(\"saved\");\n\t\t\t}\n\t\t\telse {\n\t\t\t\talertify.error(\"error saving stations\");\n\t\t\t}\n        });\n  \t}\n  \telse {\n\t\talertify.log(\"Trident Database is not available.\");\n\t}\n}\n//var items = new WinJS.Binding.List(sbv.stations.data);\n\nfunction loadStation(url) {\n    var audio = document.getElementById(\"player\");\n    audio.src = url;\n    audio.load();\n    audio.play();\n}\n\nfunction loadVid(url) {\n\tvar video = document.getElementById(\"vplayer\");\n    video.src = url;\n    video.load();\n    video.play();\n}\n\nfunction showStationsInDb() {\n\tSbxRadio.data = new WinJS.Binding.List(sbv.stations.data);\n    SbxRadio.listView.itemDataSource = SbxRadio.data.dataSource;\n    SbxRadio.data.notifyReload();\n}\n\n// Currently our list view does not do groupings so grouping logic is inert for now\n\n// Sorts the groups\nfunction compareGroups(leftKey, rightKey) {\n\treturn leftKey.charCodeAt(0) - rightKey.charCodeAt(0);\n}\n\n// Returns the group key that an item belongs to\nfunction getGroupKey(dataItem) {\n\treturn dataItem.name.toUpperCase().charAt(0);\n}\n\n// Returns the title for a group\nfunction getGroupData(dataItem) {\n\treturn {\n\t\ttitle: dataItem.name.toUpperCase().charAt(0)\n\t};\n}\n\nWinJS.Namespace.define(\"SbxRadio\", {\n\tgroupedItemsList : null,\n    listView: null,\n    data: new WinJS.Binding.List(),\n    outputCommand: WinJS.UI.eventHandler(function (ev) {\n    \tvar dialog;\n        var status = document.querySelector(\".status\");\n        var command = ev.currentTarget;\n        if (command.winControl) {\n            var cmd = command.winControl.label || command.winControl.icon || \"button\";\n            var section = command.winControl.section || \"\";\n            \n            switch (cmd) {\n            \tcase \"about\" :\n                \tdialog = document.getElementById(\"dialogAbout\").winControl;\n    \t\t\t\tdialog.show();\n                \tbreak;\n                case \"add\" :\n                \t$(\"#hfStationId\").val(\"\");  // new\n                    $(\"#txtStationName\").val(\"\");\n                    $(\"#txtStationUrl\").val(\"\");\n                    \n                \tdialog = document.getElementById(\"dialogStationEdit\").winControl;\n    \t\t\t\tdialog.show().then(function (info) {\n\t\t\t\t\t\tif (info.result == \"primary\") {\n\t\t\t\t\t\t\tvar icon = $(\"input[name=stationtype]:checked\").val();\n                            switch (icon) {\n                            \tcase \"volume\" : icon = \"fa fa-volume-up fa-2x\"; break;\n                                case \"download\" : icon = \"fa fa-cloud-download fa-2x\"; break;\n                                case \"comment\" : icon = \"fa fa-comment-o fa-2x\"; break;\n                            }\n                            \n\t\t\t\t\t\t\tsbv.stations.insert({\n                          \t\tname: $(\"#txtStationName\").val(),\n                                url: $(\"#txtStationUrl\").val(),\n                                faicon: icon\n\t\t\t\t\t\t\t});\n\t\t\t\t\t\t\tshowStationsInDb();\n\t\t\t\t\t\t}\n                    });\n                \tbreak;\n                case \"edit\" :\n                    \n                    SbxRadio.listView.selection.getItems().then(function(items) {\n\t\t\t\t\t\t// do something with the selected item\n                \t\t$(\"#hfStationId\").val(items[0].data.$loki);\n                    \t$(\"#txtStationName\").val(items[0].data.name);\n                    \t$(\"#txtStationUrl\").val(items[0].data.url);\n                        \n                        switch (items[0].data.faicon) {\n                        \tcase \"fa fa-volume-up fa-2x\": $(\"#rdoVolume\").prop(\"checked\", true); break;\n\t\t\t\t\t\t\tcase \"fa fa-cloud-download fa-2x\": $(\"#rdoCloud\").prop(\"checked\", true);  break;\n                            case \"fa fa-comment-o fa-2x\": $(\"#rdoTalk\").prop(\"checked\", true);  break;\n                            default : $(\"#rdoVolume\").prop(\"checked\", true);  break;\n\t\t\t\t\t\t}\n\n                \t\tdialog = document.getElementById(\"dialogStationEdit\").winControl;\n    \t\t\t\t\tdialog.show().then(function (info) {\n\t\t\t\t\t\t\tif (info.result == \"primary\") {\n                            \tvar station = sbv.stations.get(items[0].data.$loki);\n                                station.name = $(\"#txtStationName\").val();\n                                station.url = $(\"#txtStationUrl\").val();\n\n                                var icon = $(\"input[name=stationtype]:checked\").val();\n                                station.faicon = \"fa fa-volume-up fa-2x\";\n                                switch (icon) {\n                                    case \"volume\" : station.faicon = \"fa fa-volume-up fa-2x\"; break;\n                                    case \"download\" : station.faicon = \"fa fa-cloud-download fa-2x\"; break;\n                                    case \"comment\" : station.faicon = \"fa fa-comment-o fa-2x\"; break;\n                                }\n\t\t\t\t\t\t\t\tsbv.stations.update(station);\n                            \tshowStationsInDb();\n                          \t}\n                        });\n\t\t\t\t\t});\n\n                    //API_Inspect(SbxRadio.listView.selection.getItems());\n                \tbreak;\n                case \"delete\" :\n                    SbxRadio.listView.selection.getItems().then(function(items) {\n\t\t\t\t\t\t// do something with the selected item\n                \t\tvar id = items[0].data.$loki;\n                        var station = sbv.stations.get(id);\n                        sbv.stations.remove(station);\n                        \n                    \tshowStationsInDb();\n\t\t\t\t\t});\n                    break;\n                case \"save\" :\n                \tsaveStations();\n                    break;\n                case \"fullscreen\" :\n                \tAPI_UserFullToggle();\n                    break;\n                default : break;\n\t\t\t}\n            \n            //alertify.log(cmd);\n        }\n    }),\n    updateItem: function() {\n    \titemArray[0].title = \"marvy mint\";\n        //Sample.ListView.data[0].title = \"marvy mint\";\n        SbxRadio.data.setAt(0, itemArray[0]);\n    },\n});\n\n//var toolbar;\nWinJS.UI.processAll().then(function () {\n\tEVT_WindowResize();\n    radioInit();\n//\ttoolbar = document.querySelector('.basicToolbar').winControl;\n    SbxRadio.listView = document.querySelector('.listView').winControl;\n    SbxRadio.listView.oniteminvoked = function(e) {\n    \te.detail.itemPromise.then(function(item) {\n        \tif ($(\"#chkPlayOnSelect\").is(\":checked\")) {\n\t\t\t\t$(\"#td-vid\").hide();\n\t\t\t\tvar url = item.data.url;\n\t\t\t\tloadStation(url);\n            }\n        });\n    };\n});\n\n"
}