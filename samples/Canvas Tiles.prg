{
  "progName": "Canvas Tiles",
  "htmlText": "<h3>Html 5 Canvas Random Tiles Generation</h3>\n\nLoad Existing Image (will crop if larger) : \n<input style='height:30px;width:400px;' id='customFile' type=\"file\" name=\"customFile\" onchange=\"custom_load()\" />\n<br/><br/>\n<button style=\"height:40px\" onclick=\"paint()\">Paint</button>\n<button style=\"height:40px\" onclick=\"point()\">Point</button>\n<button style=\"height:40px\" onclick=\"savePicture()\">Save Picture</button>\n<br/>\n\n<!-- NOTE: make sure you set height and width directory not in style -->\n<CANVAS id=\"canvas\" height='400px' width='512px' ></CANVAS>\n",
  "scriptText": "// This is a sample i am making to learn alternate binary data I/O techniques\n// This particular demo demonstrates saving raw binary data as is nicely provided by\n// the html 5 canvas object.  Reading of that data is done using the \n// FileReaders' readAsDataURL() method which gives a base64 encoded string which\n// the Image (IMG) object nicely accepts.  The canvas then nicely accepts our painting\n// of that image with its 2d context's drawImage() method.\n\n// set up global stub object to load our global variables into.\nvar sandboxVars = {\n    canvas : document.getElementById(\"canvas\"),\n    ctx : canvas.getContext(\"2d\")\n};\n\nsandbox.events.clean = function() {\n    delete sandboxVars.canvas;\n    delete sandboxVars.ctx;\n};\n\npaint();\n\nfunction paint() {\n    for (x=0; x<32; x++) {\n        for(y=0; y<25; y++) {\n            sandboxVars.ctx.fillStyle = getRandomColor();\n\n            sandboxVars.ctx.fillRect(x*16,y*16,16,16);\n        }\n    }\n}\n\nfunction point() {\n    var x = Math.round(Math.random() * 32);\n    var y = Math.round(Math.random() * 25);\n\n    sandboxVars.ctx.fillStyle = getRandomColor();\n    sandboxVars.ctx.fillRect(x*16,y*16,16,16);\n}\n\nfunction custom_load()\n{\n    var file = document.getElementById('customFile').files[0];\n    if(file) {\n        var reader = new FileReader();\n\n        reader.readAsDataURL(file, \"UTF-8\");\n\n        reader.onload = function(evt) {\n            // Make an image from data url sent\n            var img = new Image;\n            img.src = evt.target.result;\n\n            // take image and draw to canvas, if image is larger it will be cropped\n            sandboxVars.ctx.drawImage(img, 0, 0);\n\n            alertify.success(\"loaded\");\n\n            // hack to clear out file control in case we save to that same file later\n            // so that there wont be a lock on that file.\n            // This is possibly not needed and possibly browser specific\n            // But this seems to help elsewhere so i will add here.\n            var cfControl = $(\"#customFile\");\n            cfControl.replaceWith( cfControl = cfControl.clone( true ) );\n        };\n        reader.onerror = function(evt) {\n            alertify.error(\"error\");\n        };\n    }\n}\n\nfunction savePicture()\n{\n    // canvas nicely supports multiple methods of exporting its data\n    // we will use msToBlob to easily save this data with msSaveBlob\n    var blob1 = sandboxVars.canvas.msToBlob();\n    window.navigator.msSaveBlob(blob1, \"canvastiles.png\");\n}\n\nfunction getRandomColor() {\n    var letters = '0123456789ABCDEF'.split('');\n    var color = '#';\n    for (var i = 0; i < 6; i++ ) {\n        color += letters[Math.round(Math.random() * 15)];\n    }\n    return color;\n}"
}