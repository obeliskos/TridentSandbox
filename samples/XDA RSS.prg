{
  "progName": "XDA RSS",
  "htmlText": "<h3>XDA Developers RT Dev and Hacking RSS</h3>\n\n<div id='divLinks'></div>",
  "scriptText": "// You can find the forum id by viewing source on the xda website for that forum\nvar rssurl = \"http://forum.xda-developers.com/external.php?type=RSS2&forumids=2130\";\n\n// Converted old sample to use basic ajax call so i can set cache false property\n$.ajax({\n  url: rssurl,\n  success: function(data){\n    var $xml = $(data);\n    $xml.find(\"item\").each(function() {\n        var $this = $(this),\n            item = {\n                title: $this.find(\"title\").text(),\n                link: $this.find(\"link\").text(),\n                description: $this.find(\"description\").text(),\n                pubDate: $this.find(\"pubDate\").text(),\n                author: $this.find(\"author\").text()\n        }\n\n        var a = document.createElement('a');\n    \ta.href =  item.link; // Insted of calling setAttribute \n    \ta.innerHTML = item.title; \n    \ta.title = item.description;\n    \tdivLinks.appendChild(a);\n    \t$(\"#divLinks\").append(\"<br/><div>\" + item.description + \"</div>\");\n        $(\"#divLinks\").append(\"<BR/>\");\n    });\n  },\n  cache: false\n});\n\n"
}