{
  "progName": "Trident Sandbox RSS Reader",
  "htmlText": "<style>\na.readerLink:link { color: #FFFF99; text-decoration: none; font-size: 20pt; }\na.readerLink:hover { text-decoration: underline; color: #FFFF99; }\na.readerLink:visited { color: #FFFF99; }\n\na.readerLink2:link { color: #FFFF99; text-decoration: none; }\na.readerLink2:hover { text-decoration: underline; color: #FFFF99; }\na.readerLink2:visited { color: #FFFF99; }\n\nfieldset { \n\tpadding: 1em;\n    font:80%/1 sans-serif;\n\tborder:1px solid white; \n}\nlabel.rss {\n\tfloat:left;\n    width:25%;\n    margin-right:0.5em;\n    padding-top:0.2em;\n    text-align:right;\n    font-weight:bold;\n}\n\nlegend {\n    padding: 0.2em 0.5em;\n    border:1px solid white;\n    color:white;\n    font-size:90%;\n    text-align:right;\n}\n\n</style> \n<ul class=\"tnavlist\">\n<li class=\"tnavli\"><a class=\"tnava\" onclick=\"showDiv(1);\" href=\"javascript:void(0)\"><i class=\"fa fa-home\"></i> Home</a></li>\n<li class=\"tnavli\"><a class=\"tnava\" onclick=\"showDiv(2);\" href=\"javascript:void(0)\"><i class=\"fa fa-rss\"></i> Feeds</a></li>\n<li class=\"tnavli\"><a class=\"tnava\" onclick=\"showDiv(3);\" href=\"javascript:void(0)\"><i class=\"fa fa-info-circle\"></i> About</a></li>\n</ul>\n\n<div id=\"divHome\" style=\"color:#ddd;\">\n\t<h3 style=\"color:#ddd\">Trident Sandbox RSS Reader</h3>\n\n\t<ul id=\"mainListView\" class=\"tlist\"></ul>\n\n\t<div id='divLinks'></div>\n</div>\n\n<div id=\"divFeeds\" style=\"color:#ddd; display:none\">\n<br/>\n\t<div id=\"divFeedsWarn\" style=\"color:#ddd; display:none\">\n\t\t<p>Since you are running local filesystem version, the list is hardcoded.  To \n    \t\tmanage the feeds, you should edit the feed list array at the top of the script</p>\n    </div>\n    \n\t<ul id=\"feedListView\" class=\"tlist\"></ul><br/>\n    \n\t<button class=\"shiny-blue\" onclick=\"addFeed()\"><i class=\"fa fa-plus\"></i> Add</button>&nbsp;\n\t<button class=\"shiny-blue\" onclick=\"editFeed()\"><i class=\"fa fa-pencil-square-o\"></i> Edit</button>&nbsp;\n\t<button class=\"shiny-blue\" onclick=\"deleteFeed()\"><i class=\"fa fa-trash-o\"></i> Delete</button>\n\t<button class=\"shiny-blue\" onclick=\"saveFeeds()\"><i class=\"fa fa-save\"></i> Save to DB</button>\n    <br/><br/>\n    <div id=\"divEditFeed\" style=\"display:none; background-color:#555; color:#ddd; padding:20px; font-size:20px;\">\n\t\t<input type=\"hidden\" id=\"hfFeedId\"/>\n\t\t<fieldset>\n        <legend>Feed Settings</legend>\n        <label class=\"rss\" for=\"txtFeedName\">Feed Name : </label>\n        <input type=\"text\" id=\"txtFeedName\" style=\"width:260px\"/>\n        <br/><br/>\n        <label class=\"rss\"for=\"txtFeedUrl\">Feed Url : </label>\n        <input type=\"text\" id=\"txtFeedUrl\" style=\"width:400px\" />\n        <br/><br/><br/>\n        \n        <span style=\"float:right\">\n\t\t<button class=\"shiny-blue\" onclick=\"saveFeed()\"><i class=\"fa fa-save\"></i> Save</button>&nbsp;\n\t\t<button class=\"shiny-blue\" onclick=\"$('#divEditFeed').hide();\"><i class=\"fa fa-ban\"></i> Cancel</button>\n        </span>\n        </fieldset>\n    </div>\n    \n</div>\n\n<div id=\"divAbout\" style=\"color:#ddd; display:none\">\n\t<h3 style=\"color:#ddd\">Trident Sandbox RSS Reader</h3>\n    \n    <p>This application works best with hosted or appcache version so that feed list \n    \tcan be saved into the TridentDB.  If you are running local filesystem version, \n        you will have to just edit the rssurls array at the top of the script.</p>\n        \n\t<p>This program works best hosted/appcached with 'Making data request <a class=\"readerLink2\" href=\"docs/HostingAndAppCache.htm\" target=\"_blank\">workaround</a>...' in place.</p>\n</div>",
  "scriptText": "var sbv = {\n\t// This is the default set of sites to show... if you are running local filesystem\n    // you will need to edit this to add/remove sites\n\trssurls : [\t{ Name: \"Engadget\", Url : \"http://www.engadget.com/rss-hd.xml\" },\n\t\t\t\t{ Name: \"Paul Thurrott's WinSupersite\", Url : \"http://winsupersite.com/rss.xml\" },\n\t\t\t\t{ Name: \"XDA WinRT Hacking\", Url : \"http://forum.xda-developers.com/external.php?type=RSS2&forumids=2130\" }\n                ],\n                \n    mainListView : null,\n    feedListView : null,\n\n\tdb: new loki('FeedDb'),\n\tfeeds: null\n};\n\nfunction EVT_CleanSandbox() {\n\tdelete sbv.rssurls;\n\tdelete sbv.db;\n    delete sbv.mainListView;\n    delete sbv.feedListView;\n    delete sbv.feeds;\n}\n\n// navlist handler to show/hide tabs\nfunction showDiv(id) {\n\t$(\"#divHome\").hide();\n    $(\"#divFeeds\").hide();\n    $(\"#divAbout\").hide();\n    \n    switch (id) {\n    \tcase 1 : $(\"#divHome\").show(); break;\n        case 2 : $(\"#divFeeds\").show(); break;\n        case 3 : $(\"#divAbout\").show(); break;\n    }\n}\n\nfunction loadFeed(sender, id) {\n\t$(\"#divLinks\").empty();\n    \n    // Converted old sample to use basic ajax call so i can set cache false property\n    $.ajax({\n      url: id,\n      success: function(data){\n        var $xml = $(data);\n\n        $xml.find(\"item\").each(function() {\n            var $this = $(this),\n                item = {\n                    title: $this.find(\"title\").text(),\n                    link: $this.find(\"link\").text(),\n                    description: $this.find(\"description\").text(),\n                    pubDate: $this.find(\"pubDate\").text(),\n                    author: $this.find(\"author\").text()\n            }\n\n            var a = document.createElement('a');\n            a.href =  item.link; // Instead of calling setAttribute \n            a.target = \"_blank\";\n            a.innerHTML = item.title; \n            a.className = \"readerLink\";\n            a.title = item.description;\n            divLinks.appendChild(a);\n            $(\"#divLinks\").append(\"<br/><div>\" + item.description + \"</div>\");\n            $(\"#divLinks\").append(\"<BR/>\");\n        });\n      },\n      error: function (xhr, ajaxOptions, thrownError) {\n\t        alertify.log(xhr.status + \" : \" + xhr.statusText);\n      },\n      cache: false\n    });\n}\n\nfunction initTridentDb() {\n\tsbv.feeds = sbv.db.addCollection('feeds', 'feeds');\n\n\tfor (idx = 0; idx < sbv.rssurls.length; idx++) {\n\t\tvar obj = sbv.rssurls[idx];\n\n\t\tsbv.feeds.insert(obj);\n\t}\n}\n\nfunction showFeedsInDb() {\n\tsbv.mainListView.clearList();\n    sbv.feedListView.clearList();\n    \n\tfor (idx = 0; idx < sbv.feeds.data.length; idx++) {\n    \tvar obj = sbv.feeds.data[idx];\n        \n        // use url for key on main list, but id for key on feeds list\n\t\tsbv.mainListView.addListItem(obj.Url, obj.Name, obj.Url);\n        sbv.feedListView.addListItem(obj.id, obj.Name, obj.Url);\n    }\n}\n\nfunction readerInit() {\n\tAPI_SetBackgroundColor(\"#444\");\n    \n\tsbv.mainListView = new TridentList(\"mainListView\", loadFeed);\n\n    if (VAR_TRIDENT_DB) {\n\t\t$(\"#divFeedsWarn\").hide();\t// hide warning intended for local filesystem users\n\t\tsbv.feedListView = new TridentList(\"feedListView\", feedDivCallback);\n        \n\t\tAPI_GetIndexedAppKey('TridentRssApp', 'RssData', function(e) {\n\t\t\tvar res = e.target.result;\n        \n        // if no data then just load up the default hardcoded data\n        if (!res) {\n            initTridentDb();\n            showFeedsInDb();\n            return;\n        }\n        \n      \tsbv.db.loadJSON(res.val);\n\n\t\t// we rehydrated loki db object and collections but old collection references still\n  \t\t// point to old db object. \n\t\tsbv.feeds = sbv.db.getCollection(\"feeds\");\n        \n\t\tshowFeedsInDb();\n      });\n      \n    }\n\telse {\n        for (idx = 0; idx < sbv.rssurls.length; idx++) {\n            var obj = sbv.rssurls[idx];\n\n            sbv.mainListView.addListItem(obj.Url, obj.Name, obj.Url);\n        }\n    }\n}\n\nfunction feedDivCallback(sender, id) {\n\t$(\"#divEditFeed\").hide();\n}\n\nfunction addFeed() {\n\t$(\"#hfFeedId\").val(\"\");\n    $(\"#txtFeedName\").val(\"\");\n    $(\"#txtFeedUrl\").val(\"\");\n    $(\"#divEditFeed\").show();\n}\n\nfunction editFeed() {\n\tvar selId = sbv.feedListView.listSettings.selectedId;\n    \n\tif (selId == null) return;\n    \n    var feedObj = sbv.feeds.get(selId);\n    \n\t$(\"#hfFeedId\").val(sbv.feedListView.listSettings.selectedId);\n    $(\"#txtFeedName\").val(feedObj.Name);\n    $(\"#txtFeedUrl\").val(feedObj.Url);\n    $(\"#divEditFeed\").show();\n}\n\nfunction deleteFeed() {\n\n\tvar selId = sbv.feedListView.listSettings.selectedId;\n    \n\tif (selId == null) return;\n\n\talertify.confirm(\"Are you sure you want to delete this feed?\", function (e) {\n\t\tif (e) {\n\t\t\tsbv.feeds.remove(sbv.feeds.get(selId));\n\n\t\t\tshowFeedsInDb();\n\t\t} \n\t});\n    \n}\n\nfunction saveFeed() {\n\tvar feedId = $(\"#hfFeedId\").val();\n    \n    var feedName = $(\"#txtFeedName\").val();\n    var feedUrl = $(\"#txtFeedUrl\").val();\n    \n    if (feedName == \"\") alertify.error(\"Feed Name is required\");\n    if (feedUrl == \"\") alertify.error(\"Feed Url is required\");\n    \n    if (feedName == \"\" || feedUrl == \"\") return;\n    \n    if (feedId == \"\") {\n    \t// Adding\n    \tvar obj = { Name : feedName, Url : feedUrl };\n\t\tsbv.feeds.insert(obj);\n        \n\t\tshowFeedsInDb();\n    \t$(\"#divEditFeed\").hide();\n    }\n    else {\n    \t// Updating\n    \tvar feedObj = sbv.feeds.get(parseInt(feedId));\n\n\t\tfeedObj.Name = feedName;\n        feedObj.Url = feedUrl;\n        \n\t\tshowFeedsInDb();\n        \n    \t$(\"#divEditFeed\").hide();\n        alertify.log(\"Don't forget to Save to DB when done.\");\n    }\n}\n\nfunction saveFeeds() {\n\tif(VAR_TRIDENT_DB) {\n      \tAPI_SetIndexedAppKey('TridentRssApp', 'RssData', JSON.stringify(sbv.db))\n  \t\talertify.log('RssData saved to Trident Database');\n  \t}\n  \telse {\n\t\talertify.log(\"Trident Database is not available.\");\n\t}\n\n}\n\nreaderInit();"
}