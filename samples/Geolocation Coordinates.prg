{
  "progName": "Geolocation Coordinates",
  "htmlText": "<p id=\"demo\">Click the button to get your coordinates:</p>\n\n<button onclick=\"getLocation()\">Try It</button>\n",
  "scriptText": "var x=document.getElementById(\"demo\");\nfunction getLocation()\n{\n\tif (navigator.geolocation)\n\t{\n\t\tnavigator.geolocation.getCurrentPosition(showPosition);\n\t}\n\telse\n\t{\n\t\tx.innerHTML=\"Geolocation is not supported by this browser.\";\n\t}\n}\n\nfunction showPosition(position)\n{\n\tx.innerHTML=\"Latitude: \" + position.coords.latitude + \n\t  \"<br>Longitude: \" + position.coords.longitude;\t\n}\n\n"
}