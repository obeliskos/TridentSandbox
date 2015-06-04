{
  "progName": "Hosted Files Database",
  "htmlText": "<ul class=\"tnavlist\">\n<li class=\"tnavli\"><a class=\"tnava\" onclick=\"showDiv(1);\" href=\"javascript:void(0)\"><i class=\"fa fa-home\"></i> Home</a></li>\n<li class=\"tnavli\"><a class=\"tnava\" onclick=\"showDiv(2);\" href=\"javascript:void(0)\"><i class=\"fa fa-info-circle\"></i> About</a></li>\n</ul>\n\n<div id=\"divMain\">\n\t<h3>Hosted File Database</h3>\n\n\tPick file(s) from local filesystem to import to TridentDB : \n\t<input style='height:30px;width:200px;' id='customFile' type=\"file\" name=\"customFile\" onchange=\"custom_load()\" multiple />\n\t<br/><br/>\n\t<br/>\n    Files stored in the TridentDB with app name of 'TridentFiles' : <br/>\n\t<select size=8 id=\"selFiles\" style=\"width:600px\"></select><br/><br/>\n\t<button class=\"minimal\" onclick=\"deleteFile()\">Delete</button> \n\t<button class=\"minimal\" onclick=\"downloadFile()\">Download</button> \n</div>\n\n<div id=\"divAbout\" style=\"display:none\">\n\t<h3>\n    About Hosted Files Database\n    </h3>\n    \n    <p>\n    This Utility allows you to 'upload' files into the TridentDB.&nbsp;  Your files are not \n    going to any server, they are being stored into the TridentDB which is an indexedDB \n    database stored in your browser's sandbox storage.&nbsp;  You have a limited amount of \n    this sandboxed storage.&nbsp;  For Internet Explorer 10/11 it is probably about 120megs.&nbsp;  \n    To monitor the amount of storage used, you can use the 'Storage Summary' function \n    of Trident Sandbox to guage how much sandbox storage space you have used/left.\n    </p>\n    \n    <p>\n    You can use this utility to store whatever files you want, but it is intended for \n    storing images or other media within your websites.&nbsp; The files are stored as \n    DataUrls (base64 encoded with mime type header) and you can use these dataurls in \n    place of an internet url.&nbsp; It's like a hyperlink to hardcoded/embedded/inline file. \n    For example you can retrieve a file from the trident db \n    as a data url string and set the 'src' property of an IMG tag to that string and it \n    will display the image.&nbsp; The same could apply to an html 5 video or audio tag \n    with mp3's or AVIs.&nbsp; This allows hosted/appcached environments to add media to their \n    pages.\n    </p>\n    <p>\n    <a href=\"http://www.html5rocks.com/en/tutorials/workers/basics/\" target=\"_blank\">Web Workers</a> should support DataUrls but i have yet to test this.&nbsp; Javascript is \n    single threaded but Web Workers allow you to run computations on background thread(s) and \n    message back and forth.&nbsp;  \n    </p>\n</div>",
  "scriptText": "// This program lets you import files from your local filesystem into the \n// TridentDB (for hosted/appcached environments only). We are storing them  \n// with an app name of 'TridentFiles' and for the key we use the filename\n// We can then get these files (as a dataurl) and use them within any of our programs.\n// DataURL is base64 encoded which adds overhead, so monitor consumption within\n// the 'Storage Summary' feature of Trident Sandbox.\n// This is intended mainly for images but the dataurl adds the mime type into the \n// encoding so you can determine exactly what type of file it contains by either\n// the filename (key) or the dataurl itself (starting bytes of val)\n\nfunction showDiv(divId) {\n    $(\"#divMain\").hide();\n    $(\"#divAbout\").hide();\n\n    switch (divId) {\n        case 1 : $(\"#divMain\").show(); break;\n        case 2 : $(\"#divAbout\").show(); break;\n    }\n}\n\nfunction custom_load()\n{\n    var pickedFiles = $(\"#customFile\")[0].files;\n\n    for(i=0; i<pickedFiles.length; i++) {\n        var pfile = pickedFiles[i];//document.getElementById('customFile').files[0];\n\n        var reader = new FileReader();\n        reader.onload = (function(loadedFile) {\n            var loadedName = loadedFile.name;\n            return function(evt) {\n                sandbox.db.setAppKey(\"TridentFiles\", loadedName, evt.target.result);\n\n                setTimeout(function () { retrieveAllHostedFiles(); }, (VAR_TRIDENT_API.mode == \"trident\")?250:600);\n            };\n        })(pfile);\n\n        reader.onerror = function(evt) {\n            alertify.error(\"error\");\n        };\n\n        reader.readAsDataURL(pfile, \"UTF-8\");\n\n    }\n}\n\nfunction retrieveAllHostedFiles()\n{\n    $(\"#selFiles\").html(\"\");\n\n    sandbox.db.getAppKeys(\"TridentFiles\", function(result) {\n        for (var idx = 0; idx < result.length; idx++) {\n            var currObject = result[idx];\n\n            $('#selFiles').append($('<option>', {\n                value: currObject.id,\n                text: currObject.key\n            }));          \n        }\n    });\n}\n\nfunction deleteFile() {\n    var filename = $(\"#selFiles option:selected\").text();\n    var fileId = $(\"#selFiles option:selected\").val();\n\n    // confirm object deletion\n    alertify.confirm(\"Are you sure you want to delete \" + filename, function (e) {\n        if (e) {\n            // user clicked \"ok\"\n            sandbox.db.deleteAppKey(parseInt(fileId), function(result) {\n                if (result) {\n                    setTimeout(function () { retrieveAllHostedFiles(); }, 250);\n\n                }\n                else {\n                    alertify.log(\"Error deleting file unit\");\n                }\n            });\n        }\n    });\n}\n\nfunction downloadFile() {\n    var objId = $(\"#selFiles option:selected\").val();\n\n    // user clicked \"ok\"\n\n    sandbox.db.getAppKeyById(parseInt(objId), function (result) {\n        if(result == null || result.id === 0) {\n            alertify.error(\"GetAppKeyById returned nothing\");\n            return;\n        }\n\n        var fileName = result.key.replace(\"TridentFiles;\", \"\");\n        var dataURL = result.val;\n        sandbox.files.saveDataURL(fileName, dataURL);\n\n    });\n\n}\n\nretrieveAllHostedFiles();\n\n// Here is how you might retrieve and use an image uploaded by the above method \n\n//VAR_TRIDENT_API.GetAppKey(\"TridentFiles\", \"myimage.jpg\", function(result) {\n//\tvar img = new Image;\n//\timg.src = result.val;\t// e.target.result is trident db obj\n//\tdocument.getElementById('UI_MainPlaceholder').appendChild(img);     \n//});\n\n"
}