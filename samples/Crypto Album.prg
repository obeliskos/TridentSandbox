{
  "progName": "Crypto Album",
  "htmlText": "<style> /* Simple styles for the file drop target */\n#droptarget { border: solid black 2px; width: 150px; height: 150px; }\n#droptarget.active { border: solid red 4px; }\n#droptargetAlbum { border: solid black 2px; width: 150px; height: 150px; }\n#droptargetAlbum.active { border: solid red 4px; }\n</style>\n\n<ul id=\"navmenu\" class=\"tnavlist\">\n<li class=\"tnavli\"><a class=\"tnava\" onclick=\"showDiv(1);\" href=\"javascript:void(0)\"><i class=\"fa fa-eye\"></i> View Album</a></li>\n<li class=\"tnavli\"><a class=\"tnava\" onclick=\"showDiv(2);\" href=\"javascript:void(0)\"><i class=\"fa fa-download\"></i> Import</a></li>\n<li class=\"tnavli\"><a class=\"tnava\" onclick=\"showDiv(3);\" href=\"javascript:void(0)\"><i class=\"fa fa-info\"></i> About</a></li>\n</ul>\n\n<div id=\"divView\">\n\t<div id=\"divViewTop\">\n        <table width=\"100%\">\n        <tr>\n            <td valign=\"top\">\n            \t<button class=\"minimal\" onclick=\"API_ShowLoad()\">Pick</button><br/>&nbsp;&nbsp;- or -<br/>\n                <div id=\"droptargetAlbum\">Drop Album Here to view its images</div>\n\t\t\t\t<input type='checkbox' id=\"chkScaleImage\" checked/>Scale Image<br/>\n                <input type='checkbox' id=\"chkFullscreenView\" checked/>Fullscreen<br/>\n\t\t\t\t<div id=\"divAlbumProgress\" style=\"display:none\">\n                \t<i class=\"fa fa-spinner fa-spin fa-2x\"></i>\n                </div><br/>\n            </td>\n            <td align='center'>\n                <div id=\"divViewThumbs\"></div>\n            </td>\n        </tr>\n        </table>\n    </div>\n\n\t<div id=\"divViewFullOuter\" style=\"display:none\">\n\t<table id=\"tblViewLayout\" width=\"100%\" bgcolor=\"#fff\">\n    <tr>\n    <td align='center'>\n    <div id=\"divViewFull\" style=\"overflow:auto\"></div>\n    </td>\n    </tr>\n    </table>\n    </div>\n\n</div>\n\n<div id=\"divImport\" style=\"display:none\">\n    <table width=\"100%\">\n    <tr>\n        <td valign=\"top\">\n            <div id=\"droptarget\">Drop Image Files Here to add to album</div><br/>\n            <button class=\"minimal\" onclick=\"newAlbum()\">New</button><br/>\n            <button class=\"minimal\" onclick=\"saveAlbum()\">Save</button><br/>\n\t\t\t<div id=\"divSaveProgress\" style=\"display:none\">\n\t\t\t\t<i class=\"fa fa-spinner fa-spin fa-2x\"></i>\n\t\t\t</div>\n        </td>\n        <td>\n          \t<label>Click on a thumbnail to remove it from the album</label><br/>\n            <div id=\"divThumbs\"></div>\n        </td>\n    </tr>\n    </table>\n\n    <div id=\"divFullImage\"></div>\n</div>\n\n<div id=\"divAbout\" style=\"display:none\">\n<h3>Crypto Album for Trident Sandbox</h3>\n<p>This application lets you import a series of images into an 'album' which you can then \nsave as a single, encrypted file.&nbsp; This application makes use of a web worker 'pool' to do the \nencryption decryption of each individual image, which somewhat compensates for the slower nature of \njavascript encryption.  On a machine/device with four cores it should be able \nto process (encrypt/decrypt) 3 or 4 images at a time (in addition to the main javascript thread).&nbsp; \nThe default worker pool size is 4 which is optimized for four cores, increase or decrease depending \non your cpu to see which pool size is fastest for your computer/device.\n</p>\n<p>To support the web workers, I created a web worker (crypto_worker.js) which i have in the libraries \nfolder.&nbsp;  You can use this web worker in your own programs, either to keep a single long running \noperation from locking up the user interface, or to parallel process multiple encrypt/decrypt/hash ops.&nbsp;\nI also included some web worker pooling logic which allows you to specify pool size approximating the \nnumber of cores on your machine for optimization.\n</p>\n<h4>View Album</h4>\n<p>On this tab you can drop a single album or pick it with the picker.&nbsp; This will \nprompt you for the password... once that is entered the program will spawn Workers to decrypt \nand will display them once they are loaded.  Clicking on an image will invoke the full screen API \nto view the image fullscreen and if the 'Scale Image' checkbox is checked it will scale the \nimage to fit your screen.</p>\n<h4>Import</h4>\n<p>On this tab you can drop multiple images to add to an album.&nbsp; You can append more later if you \nwant to by dropping more files, or you can click new to clear out the album in memory.&nbsp; \nIf you click on an image on the import screen it will ask you if you want to delete it.&nbsp; \nIf you wanted to preview it, you would have to go to the View Album screen and click on it there.&nbsp; \nOnce you are ready to save the file, press the save button.&nbsp; This will prompt you for a \npassword and then it will spawn crypto workers to encrypt them.&nbsp; Once all workers have \nfinished, your file download will begin.</p>\n<p>If you need to get an image out of an album you can right click and save as... the filename is \nlost so you will have to make up a filename for the image.&nbsp; DataURLs contain mime type but no \nfile name and if i added that to the file format i would have to provide a custom download link.&nbsp; \nFor the time being, I am ok with not having the filename stored.</p>\n</div>",
  "scriptText": "// Initializing the Worker Here to 4 simultaneous workers\n// This is an optimization setting the queue sizes can be different but this value\n// determines max workers which can run simultaneously.\n\nDoInit();\nDoInitViewer();\n\nvar albumData = [];\n\nvar sbv = {\n\tcachedPass : null,\n    imageIndex : null,\n    imageCounter : null,\n    lastAlbumName : \"album.eia\",\n    pool: new Pool(4)\n};\n\nsbv.pool.init();\n\nfunction EVT_CleanSandbox()\n{\n\tdelete sbv.cachedPass;\n\tdelete sbv.myVar2;\n    delete sbv.pool;\n    albumData = [];\n}\n\nvar thumbCounter = 0;\n\nfunction showDiv(divId) {\n\t$(\"#divView\").hide();\n    $(\"#divImport\").hide();\n    $(\"#divAbout\").hide();\n    \n\tswitch (divId) {\n    \tcase 1 : $(\"#divView\").show(); break;\n        case 2 : $(\"#divImport\").show(); break;\n        case 3 : $(\"#divAbout\").show(); break;\n    }\n}\n\nfunction EVT_UserLoadCallback(filestring, filename)\n{\n\tsbv.lastAlbumName = filename;\n    \n\tvar ealbum = JSON.parse(filestring);\n\talbumData = [];\n    var thumbCounter = 0;\n    \n    $(\"#divViewThumbs\").empty();\n    $(\"#divThumbs\").empty();\n\n\tAPI_ShowPasswordDialog(function(pass) {\n    \tsbv.cachedPass = pass;\n\n\t\t$(\"#divAlbumProgress\").show();\n        \n        for(var idx=0; idx < ealbum.length; idx++) {\n            var params = { \n                id: idx, \n                val: ealbum[idx], \n                algorithm: 'aes', \n                action: 'decrypt', \n                password: pass \n            };\n\n            var workerTask = new WorkerTask('libraries/crypto_worker.js', function() {\n                albumData[event.data.id] = event.data.val;\n\n                var thumb = document.createElement(\"img\");\n                thumb.src = event.data.val;\n                thumb.setAttribute(\"data-index\", event.data.id);\n                thumb.onload = (function(newIdx1) {\n                    return function() {\n                        this.width = 100;\n                        $(this).click( (function(newIdx2) {\n                            return function() {\n                                viewFullImage(newIdx2);\n                            }\n                        })(newIdx1));\n\n                        document.getElementById(\"divViewThumbs\").appendChild(this);\n                    }\n                })(event.data.id);\n\n                var thumb2 = document.createElement(\"img\");\n                thumb2.src = event.data.val;\n                thumb2.setAttribute(\"data-index\", event.data.id);\n                thumb2.onload = (function(newIdx1) {\n                    return function() {\n                        this.width = 100;\n                        $(this).click( (function(newIdx2) {\n                            return function() {\n                                deleteImage(newIdx2);\n                            }\n                        })(newIdx1));\n\n                        document.getElementById(\"divThumbs\").appendChild(this);\n                    }\n                })(event.data.id);\n                \n                thumbCounter++;\n                if (thumbCounter == ealbum.length) {\n    \t\t\t\t$(\"#divAlbumProgress\").hide();\n                \talertify.success(\"Done!\");\n                    \n                    ealbum = [];\n\t\t\t\t}\n            }, params);\n\n            sbv.pool.addWorkerTask(workerTask);\n\t\t}\n\t});\n    \n}\n\nfunction DoInitViewer() {\n    // Find the element we want to add handlers to.\n    var droptarget = document.getElementById(\"droptargetAlbum\");\n\n    // When the user starts dragging files over the droptarget, highlight it.\n    droptarget.ondragenter = function(e) {\n        // If the drag is something other than files, ignore it.\n        // The HTML5 dropzone attribute will simplify this when implemented.\n        var types = e.dataTransfer.types;\n        if (!types ||\n            (types.contains && types.contains(\"Files\")) ||\n            (types.indexOf && types.indexOf(\"Files\") != -1)) {\n            droptarget.classList.add(\"active\"); // Highlight droptarget\n            return false;                       // We're interested in the drag\n        }\n    };\n    // Unhighlight the drop zone if the user moves out of it\n    droptarget.ondragleave = function() {\n        droptarget.classList.remove(\"active\");\n    };\n\n    // This handler just tells the browser to keep sending notifications\n    droptarget.ondragover = function(e) { return false; };\n\n    // When the user drops files on us, get their URLs and display thumbnails.\n    droptarget.ondrop = function(e) {\n        var files = e.dataTransfer.files;            // The dropped files\n        for(var i = 0; i < files.length; i++) {      // Loop through them all\n        \tsbv.lastAlbumName = files[i].name;\n            \n            var type = files[i].type;\n            if (type.substring(0,6) == \"image/\") {    // images dropped on album box, warn and stop\n            \talertify.error(\"You dropped images on album viewer!\");\n                return false;\n            }\n                \n            var fileReader = new FileReader();\n \t\t\tfileReader.onload = loadAlbum;\n            \n            fileReader.readAsText(files[i], \"UTF-8\")\n        }\n\n        droptarget.classList.remove(\"active\");       // Unhighlight droptarget\n        return false;                                // We've handled the drop\n    }\n}\n\n// When the document is loaded, add event handlers to the droptarget element\n// so that it can handle drops of files\nfunction DoInit() {\n    // Find the element we want to add handlers to.\n    var droptarget = document.getElementById(\"droptarget\");\n\n    // When the user starts dragging files over the droptarget, highlight it.\n    droptarget.ondragenter = function(e) {\n        // If the drag is something other than files, ignore it.\n        // The HTML5 dropzone attribute will simplify this when implemented.\n        var types = e.dataTransfer.types;\n        if (!types ||\n            (types.contains && types.contains(\"Files\")) ||\n            (types.indexOf && types.indexOf(\"Files\") != -1)) {\n            droptarget.classList.add(\"active\"); // Highlight droptarget\n            return false;                       // We're interested in the drag\n        }\n    };\n    // Unhighlight the drop zone if the user moves out of it\n    droptarget.ondragleave = function() {\n        droptarget.classList.remove(\"active\");\n    };\n\n    // This handler just tells the browser to keep sending notifications\n    droptarget.ondragover = function(e) { return false; };\n\n    // When the user drops files on us, get their URLs and display thumbnails.\n    droptarget.ondrop = function(e) {\n        var files = e.dataTransfer.files;            // The dropped files\n        for(var i = 0; i < files.length; i++) {      // Loop through them all\n            var type = files[i].type;\n            if (type.substring(0,6) !== \"image/\")    // Skip any nonimages\n                continue;\n                \n            var fileReader = new FileReader();\n            fileReader.onload = (function(file) {\n            \treturn function(e) {\n                     var newIdx = albumData.length;\n                     \n                     albumData.push(e.target.result);\n                     \n                    var thumb = document.createElement(\"img\");\n                    thumb.src = e.target.result;\n                \tthumb.setAttribute(\"data-index\", newIdx);\n                    thumb.onload = (function(newIdx1) {\n                        return function() {\n                            this.width = 100;\n                            $(this).click( (function(newIdx2) {\n                                return function() {\n                                    viewFullImage(newIdx2);\n                                }\n                            })(newIdx1));\n\n                            document.getElementById(\"divViewThumbs\").appendChild(this);\n                        }\n                    })(newIdx);\n\n                    var thumb2 = document.createElement(\"img\");\n                    thumb2.src = e.target.result;\n\t\t\t\t\tthumb2.setAttribute(\"data-index\", newIdx);\n                    thumb2.onload = (function(newIdx1) {\n                        return function() {\n                            this.width = 100;\n                            $(this).click( (function(newIdx2) {\n                                return function() {\n                                    deleteImage(newIdx2);\n                                }\n                            })(newIdx1));\n\n                            document.getElementById(\"divThumbs\").appendChild(this);\n                        }\n                    })(newIdx);\n                     \n                     \n                };\n            })(files[i]);\n            \n            fileReader.readAsDataURL(files[i]);\n        }\n\n        droptarget.classList.remove(\"active\");       // Unhighlight droptarget\n        return false;                                // We've handled the drop\n    }\n};\n\nfunction showFullImage(idx) {\n\t$(\"#divFullImage\").empty();\n    \n    $(\"#divViewTop\").hide();\n    $(\"#divViewFull\").show();\n    \n\tvar img = document.createElement(\"img\"); // Create an <img> element\n\timg.src = albumData[idx];        \n\timg.onload = function() {                // When it loads\n\t\tdocument.getElementById('divFullImage').appendChild(this);     \n\t}\n}\n\nfunction scaleImage() {\n    var $img = $('#imgViewer'),\n        imageWidth = $img[0].width, //need the raw width due to a jquery bug that affects chrome\n        imageHeight = $img[0].height, //need the raw height due to a jquery bug that affects chrome\n        //maxWidth = screen.width,\n        //maxHeight = screen.height,\n   \t\tmaxWidth = $(window).width(),\n    \tmaxHeight = $(window).height(),\n        widthRatio = maxWidth / imageWidth,\n        heightRatio = maxHeight / imageHeight;\n\n    var ratio = widthRatio; //default to the width ratio until proven wrong\n\n    if (widthRatio * imageHeight > maxHeight) {\n        ratio = heightRatio;\n    }\n\n    //now resize the image relative to the ratio\n    $img.attr('width', imageWidth * ratio)\n        .attr('height', imageHeight * ratio);\n\n    //and center the image vertically and horizontally\n    //$img.css({\n    //    margin: 'auto',\n    //    position: 'absolute',\n    //    top: 0,\n    //    bottom: 0,\n    //    left: 0,\n    //    right: 0\n    //});\n}\n\nfunction viewFullImage(idx) {\n\t$(\"#divViewFull\").empty();\n    $(\"#divViewTop\").hide();\n    $(\"#divViewFullOuter\").show();\n    $(\"#navmenu\").hide();\n    \n\tvar img = document.createElement(\"img\"); // Create an <img> element\n    img.id = \"imgViewer\";\n\timg.src = albumData[idx];        \n\timg.onload = function() {\n\t\t$(this).click( function() {\n\t\t\tAPI_UserFullscreenExit();\n            $(\"#divViewFullOuter\").hide();\n\t\t\t$(\"#divViewTop\").show();\n\t\t    $(\"#navmenu\").show();\n\t\t});\n        \n\t}\n    \n\tdocument.getElementById('divViewFull').appendChild(img);   \n    \n    if ($(\"#chkFullscreenView\").is(':checked')) {\n\t\tAPI_UserFullscreen(document.getElementById(\"divViewFull\"));\n\t}\n    \n\tif ($('#chkScaleImage').is(':checked')) {\n\t\tsetTimeout(function() {\n    \t\tscaleImage();\n    \t}, 500);\n    }\n\n}\n\nfunction deleteImage(idx) {\n\tsbv.imageIndex = idx;\n    \n\talertify.confirm(\"Are you sure you want to remove this image from the album? \" + idx, function (e) {\n\t\tif (e) {\n        \talbumData[sbv.imageIndex] = null;\n            $(\"*[data-index=\" + sbv.imageIndex + \"]\").remove();\n            \n            sbv.imageIndex = null;\n\t\t} \n        else { sbv.imageIndex = null };\n\t});\n}\n\nfunction loadAlbum(evt) {\n\tvar ealbum = JSON.parse(evt.target.result);\n\talbumData = [];\n    thumbCounter = 0;\n    \n    $(\"#divViewThumbs\").empty();\n    $(\"#divThumbs\").empty();\n\n\tAPI_ShowPasswordDialog(function(pass) {\n    \tsbv.cachedPass = pass;\n\n\t\t$(\"#divAlbumProgress\").show();\n        \n        for(var idx=0; idx < ealbum.length; idx++) {\n            var params = { \n                id: idx, \n                val: ealbum[idx], \n                algorithm: 'aes', \n                action: 'decrypt', \n                password: pass \n            };\n\n            var workerTask = new WorkerTask('libraries/crypto_worker.js', function() {\n                albumData[event.data.id] = event.data.val;\n\n                var thumb = document.createElement(\"img\");\n                thumb.src = event.data.val;\n                thumb.setAttribute(\"data-index\", event.data.id);\n\n                thumb.onload = (function(newIdx1) {\n                    return function() {\n                        this.width = 100;\n                        $(this).click( (function(newIdx2) {\n                            return function() {\n                                viewFullImage(newIdx2);\n                            }\n                        })(newIdx1));\n\n                        document.getElementById(\"divViewThumbs\").appendChild(this);\n                    }\n                })(event.data.id);\n\n                var thumb2 = document.createElement(\"img\");\n                thumb2.src = event.data.val;\n                thumb2.setAttribute(\"data-index\", event.data.id);\n                thumb2.onload = (function(newIdx1) {\n                    return function() {\n                        this.width = 100;\n                        $(this).click( (function(newIdx2) {\n                            return function() {\n                                deleteImage(newIdx2);\n                            }\n                        })(newIdx1));\n\n                        document.getElementById(\"divThumbs\").appendChild(this);\n                    }\n                })(event.data.id);\n                \n                thumbCounter++;\n                if (thumbCounter == ealbum.length) {\n    \t\t\t\t$(\"#divAlbumProgress\").hide();\n                \talertify.log(\"Done!\");\n                    \n                    ealbum = [];\n\t\t\t\t}\n            }, params);\n\n            sbv.pool.addWorkerTask(workerTask);\n\n        \n            \n\t\t}\n\t});\n}\n\nfunction newAlbum() {\n\tsbv.lastAlbumName = \"album.eia\";\n    $(\"#divViewThumbs\").empty();\n    $(\"#divThumbs\").empty();\n    albumData = [];\n    ealbum = [];\n}\n\nfunction saveAlbum() {\n\tvar ealbum = [];\n    \n    sbv.ImageCounter = 0;\n    \n\tAPI_ShowPasswordDialog(function(pass) {\n\t\tif (pass.length < 6) {\n\t\t\talertify.alert(\"Password must be at least six characters\");\n\t\t\treturn;\n\t\t}\n            \n\t\t$(\"#divSaveProgress\").show();\n            \n\t\tsbv.cachedPass = pass;\n            \n\t\tfor(var idx=0; idx < albumData.length; idx++) {\n\t\t\tif (albumData[idx] == null) {\n\t\t\t\tif (++sbv.ImageCounter == albumData.length) {\n\t\t\t\t\t$(\"#divSaveProgress\").hide();\n\t\t\t\t\tAPI_SaveTextFile(sbv.lastAlbumName, JSON.stringify(ealbum));\n\t\t\t\t\tealbum = [];\n\t\t\t\t}\n\t\t\t}\n\t\t\telse {\n\t\t\t\tvar params = { \n\t\t\t\t\tid: idx, \n\t\t\t\t\tval: albumData[idx], \n\t\t\t\t\talgorithm: 'aes', \n\t\t\t\t\taction: 'encrypt', \n\t\t\t\t\tpassword: pass \n\t\t\t\t};\n\n\t\t\t\tvar workerTask = new WorkerTask('libraries/crypto_worker.js', function() {\n\t\t\t\t\tealbum.push(event.data.val);\n\n\t\t\t\t\tif (++sbv.ImageCounter == albumData.length) {\n\t\t\t\t\t\t$(\"#divSaveProgress\").hide();\n\t\t\t\t\t\tAPI_SaveTextFile(sbv.lastAlbumName, JSON.stringify(ealbum));\n\t\t\t\t\t\tealbum = [];\n\t\t\t\t\t}\n\t\t\t\t}, params);\n\n\t\t\t\tsbv.pool.addWorkerTask(workerTask);\n\t\t\t}\n\t\t}\n\t});\n}\n"
}