{
  "progName": "Geolocation Coordinates",
  "htmlText": "<p id=\"demo\">Click the button to get your coordinates:</p>\n\n<button onclick=\"getLocation()\">Try It</button>\n",
  "scriptText": "var x=document.getElementById(\"demo\");\nfunction getLocation()\n{\n    if (navigator.geolocation)\n    {\n        navigator.geolocation.getCurrentPosition(showPosition);\n    }\n    else\n    {\n        x.innerHTML=\"Geolocation is not supported by this browser.\";\n    }\n}\n\nfunction showPosition(position)\n{\n    x.innerHTML=\"Latitude: \" + position.coords.latitude + \n        \"<br>Longitude: \" + position.coords.longitude;\t\n}\n"
}