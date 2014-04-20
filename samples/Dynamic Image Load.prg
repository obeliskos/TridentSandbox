{
  "progName": "Dynamic Image Load",
  "htmlText": "<h3>Dynamically Loading Web Image</h3>\n\n<div id='divImage'></div>",
  "scriptText": "// In theory you could put this into a function and create a timer loop to call that function\n// which would refresh the image on whatever interval you set\n\n$('#divImage').empty();\nvar img = $('<img id=\"imgNOAA\">');\nimg.attr('src', \"http://www.ssd.noaa.gov/goes/comp/nhem/rb.jpg\");\nimg.appendTo('#divImage');"
}