{
  "progName": "WinJS FlipView",
  "htmlText": "<style>\n/*General Styles used for all FlipViews*/\n.flipView {\n    width: 100%;\n    max-width: 720px;\n    height: 405px;\n    background-image: url(\"/pages/flipview/images/Texture.png\");\n}\n\n.flipViewContent {\n    width: 100%;\n    max-width: 720px;\n    height: 405px;\n}\n\n/*Styles used in the Item Template*/\n.overlaidItemTemplate {\n    width: 100%;\n    max-width: 720px;\n    height: 405px;\n}\n\n    .overlaidItemTemplate img {\n        width: 100%;\n        height: 100%;\n    }\n\n    .overlaidItemTemplate .overlay {\n        position: absolute;\n        background-color: rgba(0,0,0,0.65);\n        height: 40px;\n        padding: 20px 15px;\n        overflow: hidden;\n        width:100%;\n        bottom:0;\n    }\n\n        .overlaidItemTemplate .overlay .ItemTitle {\n            color: rgba(255, 255, 255, 0.8);\n        }\n\n</style>\n\n<a class=\"TridentLinkSmall\" href=\"http://try.buildwinjs.com/#flipview\" target=\"_blank\">See official sample in Microsoft's 'Try WinJS' sandbox</a>\n<i>On touch devices, swipe image</i>\n\n<div class=\"simple_ItemTemplate\" data-win-control=\"WinJS.Binding.Template\" style=\"display: none\">\n    <div class=\"overlaidItemTemplate\">\n        <img class=\"image\" data-win-bind=\"src: picture; alt: title\" />\n        <div class=\"overlay\">\n            <h2 class=\"ItemTitle\" data-win-bind=\"textContent: title\"></h2>\n        </div>\n    </div>\n</div>\n<div id=\"simple_FlipView\" class=\"flipView\" data-win-control=\"WinJS.UI.FlipView\"\n     data-win-options=\"{\n        itemDataSource: DefaultData.bindingList.dataSource,\n        itemTemplate: select('.simple_ItemTemplate')\n     }\">\n</div>\n\n",
  "scriptText": "var array = API_SetBackgroundColor(\"#444\");\n\nvar array = [\n    { type: \"item\", title: \"Cliff\", picture: \"http://try.buildwinjs.com/pages/flipview/images/Cliff.jpg\" },\n    { type: \"item\", title: \"Grapes\", picture: \"http://try.buildwinjs.com/pages/flipview/images/Grapes.jpg\" },\n    { type: \"item\", title: \"Rainier\", picture: \"http://try.buildwinjs.com/pages/flipview/images/Rainier.jpg\" },\n    { type: \"item\", title: \"Sunset\", picture: \"http://try.buildwinjs.com/pages/flipview/images/Sunset.jpg\" },\n    { type: \"item\", title: \"Valley\", picture: \"http://try.buildwinjs.com/pages/flipview/images/Valley.jpg\" }\n];\nvar bindingList = new WinJS.Binding.List(array);\n\nWinJS.Namespace.define(\"DefaultData\", {\n    bindingList: bindingList,\n    array: array\n});\nWinJS.UI.processAll();\n\n"
}