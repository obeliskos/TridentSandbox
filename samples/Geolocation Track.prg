{
  "progName": "Geolocation Track",
  "htmlText": "<p id=\"demo\">Click the button to track your coordinates:</p>\n<button onclick=\"getLocation()\">Try It</button>\n",
  "scriptText": "// This sample demonstrates real time tracking\n// Taken from : http://www.w3schools.com/html/html5_geolocation.asp\n\nvar x=document.getElementById(\"demo\");\nfunction getLocation()\n{\n\tif (navigator.geolocation)\n\t{\n\t\tnavigator.geolocation.watchPosition(showPosition);\n\t}\n\telse\n\t{\n\t\tx.innerHTML=\"Geolocation is not supported by this browser.\";\n\t}\n}\n\nfunction showPosition(position)\n{\n\tx.innerHTML=\"Latitude: \" + position.coords.latitude + \n\t\t\"<br>Longitude: \" + position.coords.longitude;\t\n}\n"
}