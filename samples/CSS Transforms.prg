{
  "progName": "CSS Transforms",
  "htmlText": "<style>\n.animated_div\n{\nwidth:60px;\nheight:40px;\ncolor:#ffffff;\nposition:relative;\nfont-weight:bold;\nfont-size:15px;\npadding:10px;\nfloat:left;\nmargin:20px;\nmargin-right:50px;\nborder:1px solid #888888;\n-webkit-border-radius:5px;\n-moz-border-radius:5px;\nborder-radius:5px;\n}\n\n#rotate1,#rotatey1\n{\nborder:1px solid #000000;\nbackground:red;\nmargin:10px;\nopacity:0.7;\n}\n\n</style>\n\n<h3>CSS Transforms- click on a box to animate</h3>\n<div style=\"height:80px;\">\n\t<div onclick=\"rotateDIV()\" id=\"rotate1\" class=\"animated_div\">2D rotate</div>\n\t<div onclick=\"rotateYDIV()\" id=\"rotatey1\" class=\"animated_div\">3D rotate</div>\n</div>\n",
  "scriptText": "var x,y,n=0,ny=0,rotINT,rotYINT\n\nfunction rotateDIV()\n{\n\tx=document.getElementById(\"rotate1\")\n\tclearInterval(rotINT)\n\trotINT=setInterval(\"startRotate()\",10)\n}\nfunction rotateYDIV()\n{\n\ty=document.getElementById(\"rotatey1\")\n\tclearInterval(rotYINT)\n\trotYINT=setInterval(\"startYRotate()\",10)\n}\n\nfunction startRotate()\n{\nn=n+1\nx.style.transform=\"rotate(\" + n + \"deg)\"\nx.style.webkitTransform=\"rotate(\" + n + \"deg)\"\nx.style.OTransform=\"rotate(\" + n + \"deg)\"\nx.style.MozTransform=\"rotate(\" + n + \"deg)\"\nif (n==180 || n==360)\n\t{\n\tclearInterval(rotINT)\n\tif (n==360){n=0}\n\t}\n}\nfunction startYRotate()\n{\n\tny=ny+1\n\ty.style.transform=\"rotateY(\" + ny + \"deg)\"\n\ty.style.webkitTransform=\"rotateY(\" + ny + \"deg)\"\n\ty.style.OTransform=\"rotateY(\" + ny + \"deg)\"\n\ty.style.MozTransform=\"rotateY(\" + ny + \"deg)\"\n\tif (ny==180 || ny>=360)\n\t{\n\t\tclearInterval(rotYINT)\n\t\tif (ny>=360){ny=0}\n\t}\n}\n\n"
}