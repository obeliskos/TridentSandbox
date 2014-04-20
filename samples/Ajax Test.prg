{
  "progName": "Ajax Test",
  "htmlText": "<h3>Simple Ajax request demo</h3>\n\nYou should get an alertify notification if it succeeded.",
  "scriptText": "var url = \"http://forum.xda-developers.com/external.php?type=RSS2&forumids=2130\";\n\njQuery.ajax({\n\ttype: \"GET\",\n\turl: url,\n\tcache: false,\n\tdataType: \"html\",\n\t//data: \"userId=\" + encodeURIComponent(trim(document.forms[0].userId.value)),\n\tsuccess: function (response) {\n        \talertify.log('success');\n      \t},\n\terror: function (xhr, ajaxOptions, thrownError) {\n\t        alertify.log(xhr.status + \" : \" + xhr.statusText);\n      }\n});\n"
}