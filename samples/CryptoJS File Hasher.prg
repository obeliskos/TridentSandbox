{
  "progName": "CryptoJS File Hasher",
  "htmlText": "<style> /* Simple styles for the file drop target */\n#droptarget { border: solid black 2px; width: 200px; height: 200px; }\n#droptarget.active { border: solid red 4px; }\n</style>\n\n<h3>CryptoJS File Hasher</h3>\n\n<p>\nWarning : for files over 5-10 megs this is rather slow.&nbsp; \nOn my Core i5 test machine, A 20 meg file took about 10 seconds to calculate a hash for.&nbsp; \n</p>\n<p>\nJavascript is single threaded, but this -could- be adapted to use webworkers which can run \non different threads... where dropping 4 files might give each file hashing its own core.\n</p>\n\n<table width=\"100%\">\n<tr>\n    <td valign=\"top\">\n\t\t<div id=\"droptarget\">Drop File(s) Here to generate SH1 and MD5 hashes for them</div>\n    </td>\n    <td valign=\"top\">\n\t\t<ul id=\"hashInfoList\" class=\"tlist\" style=\"min-height:300px;min-width:300px\"></ul>\n    </td>\n</tr>\n</table>\n\n\n",
  "scriptText": "// Recommended practice is to place variables in this object and then delete in cleanup\nvar sbv = {\n\thlv : null\n}\n\nfunction EVT_CleanSandbox()\n{\n\tdelete sbv.hlv;\n}\n\n// When the document is loaded, add event handlers to the droptarget element\n// so that it can handle drops of files\nfunction DoInit() {\n\tsbv.hlv = new TridentList(\"hashInfoList\");\n\tsbv.hlv.clearList();\n    sbv.hlv.makeBright();\n\n    // Find the element we want to add handlers to.\n    var droptarget = document.getElementById(\"droptarget\");\n\n    // When the user starts dragging files over the droptarget, highlight it.\n    droptarget.ondragenter = function(e) {\n        // If the drag is something other than files, ignore it.\n        // The HTML5 dropzone attribute will simplify this when implemented.\n        var types = e.dataTransfer.types;\n        if (!types ||\n            (types.contains && types.contains(\"Files\")) ||\n            (types.indexOf && types.indexOf(\"Files\") != -1)) {\n            droptarget.classList.add(\"active\"); // Highlight droptarget\n            return false;                       // We're interested in the drag\n        }\n    };\n    // Unhighlight the drop zone if the user moves out of it\n    droptarget.ondragleave = function() {\n        droptarget.classList.remove(\"active\");\n    };\n\n    // This handler just tells the browser to keep sending notifications\n    droptarget.ondragover = function(e) { return false; };\n\n    // When the user drops files on us, get their URLs and display thumbnails.\n    droptarget.ondrop = function(e) {\n        var files = e.dataTransfer.files;            // The dropped files\n        for(var i = 0; i < files.length; i++) {      // Loop through them all\n            var f = files[i];\n        \tvar reader = new FileReader();\n            reader.onload = (function(thefile) {\n            \tAPI_LogMessage(thefile.name);\n            \treturn function(e) {\n                \t//alertify.log(thefile.name)\n                \tvar warray = CryptoJS.lib.WordArray.create(e.target.result);\n                    var sha1Hash = CryptoJS.SHA1(warray);\n                    var md5Hash = CryptoJS.MD5(warray);\n                    var listDesc = \"SHA1 : \" + sha1Hash + \"  MD5 : \" + md5Hash;\n                    \n                  \tsbv.hlv.addListItem(thefile.name, thefile.name, listDesc);\n\n                };\n            })(f);\n            reader.readAsArrayBuffer(f);\n        }\n\n        droptarget.classList.remove(\"active\");       // Unhighlight droptarget\n        return false;                                // We've handled the drop\n    }\n};\n\nDoInit();"
}