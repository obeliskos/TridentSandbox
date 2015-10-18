{
  "progName": "jQueryUI Demo",
  "htmlText": "<h3>jQueryUI Demo</h3>\n<a href='libraries/jquery-ui/jquery-ui-1.10.3.redmond/jquery-ui-1.10.3.custom/index.html'>See more detailed demo here</a>\n\n<h4>Datepicker:</h4>\n\n<input id='txtDatepicker' type='text'></input>\n<h4 class=\"demoHeaders\">Accordion</h4>\n<div id=\"accordion\">\n    <h3>First</h3>\n    <div>Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet.</div>\n    <h3>Second</h3>\n    <div>Phasellus mattis tincidunt nibh.</div>\n    <h3>Third</h3>\n    <div>Nam dui erat, auctor a, dignissim quis.</div>\n</div>\n<br/>\n<button id=\"button\">A button element</button>\n<form style=\"margin-top: 1em;\">\n    <div id=\"radioset\">\n        <input type=\"radio\" id=\"radio1\" name=\"radio\"><label for=\"radio1\">Choice 1</label>\n        <input type=\"radio\" id=\"radio2\" name=\"radio\" checked=\"checked\"><label for=\"radio2\">Choice 2</label>\n        <input type=\"radio\" id=\"radio3\" name=\"radio\"><label for=\"radio3\">Choice 3</label>\n    </div>\n</form>\n<br/>\n<div id=\"tabs\">\n    <ul>\n        <li><a href=\"#tabs-1\">First</a></li>\n        <li><a href=\"#tabs-2\">Second</a></li>\n        <li><a href=\"#tabs-3\">Third</a></li>\n    </ul>\n    <div id=\"tabs-1\">Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</div>\n    <div id=\"tabs-2\">Phasellus mattis tincidunt nibh. Cras orci urna, blandit id, pretium vel, aliquet ornare, felis. Maecenas scelerisque sem non nisl. Fusce sed lorem in enim dictum bibendum.</div>\n    <div id=\"tabs-3\">Nam dui erat, auctor a, dignissim quis, sollicitudin eu, felis. Pellentesque nisi urna, interdum eget, sagittis et, consequat vestibulum, lacus. Mauris porttitor ullamcorper augue.</div>\n</div>\n<br/>\n<button id=\"btnDialog\" onclick='openDialog()'>Open a jQueryUI dialog</button>\n\n<div id=\"divTestDialog\" style=\"display:none\">Hello Dialog</div>\n\n",
  "scriptText": "$( \"#accordion\" ).accordion();\n$( \"#button\" ).button();\n$( \"#radioset\" ).buttonset();\n\n$( \"#tabs\" ).tabs();\n\n$( \"#dialog\" ).dialog({\n    autoOpen: false,\n    width: 400,\n    buttons: [\n        {\n            text: \"Ok\",\n            click: function() {\n                $( this ).dialog( \"close\" );\n            }\n        },\n        {\n            text: \"Cancel\",\n            click: function() {\n                $( this ).dialog( \"close\" );\n            }\n        }\n    ]\n});\n\n$( \"#btnDialog\" ).button();\n\nfunction openDialog()\n{\n    $( \"#divTestDialog\" ).dialog({\n        dialogClass: \"no-close\",\n        buttons: [\n            {\n                text: \"OK\",\n                click: function() {\n                    $( this ).dialog( \"close\" );\n                }\n            }\n        ]\n    });\n}\n\n$(\"#txtDatepicker\").datepicker();"
}