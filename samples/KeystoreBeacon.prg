{
  "progName": "KeystoreBeacon",
  "htmlText": "<h3>Keystore Finder</h3>\n<br/>\n<p>\nThis utility can be used if you are running a remote keystore server (TridentService), but do not know it's exact ip. \nIt will scan for the computer running the service and (if found) update service reference.\n</p>\n\n<table>\n<tr>\n\t<td>Enter Base Address :</td>\n    <td><input style='width:400px' type='text' id='txt-baseaddress' value='http://192.168.1.xxx/Pyramidion/Keystore'></td>\n</tr>\n<tr>\n\t<td>Scan start :</td>\n    <td><input type='text' id='txt-scanstart' value='100'></td>\n</tr>\n<tr>\n\t<td>Scan end :</td>\n    <td><input type='text' id='txt-scanend' value='140'></td>\n</tr>\n</table>\n\n\n<br/>\n\n<button class='minimal' onclick='doScan()'>\nScan\n</button>\n<br/>\n<br/>\n<div id=\"div-output\">\n</div>\n",
  "scriptText": "function scanAddress(address) {\n  //API_LogMessage(address);\n  var params = { 'App' : '', 'Key' : ''};\n  \n  jQuery.ajax({\n    type: \"POST\",\n    url: address,\n    data: params,\n    cache: false,\n    dataType: \"html\",\n\n    success: function (response) {\n    \t//alertify.log('success');\n        //API_Inspect(response);\n        var serviceLocation = address.replace('GetKey', '');\n        \n        $(\"#div-output\").append(serviceLocation);\n        \n        VAR_TRIDENT_API.baseUrl = serviceLocation;\n        VAR_TRIDENT_API.mode = 'service';\n        localStorage['TridentService'] = serviceLocation;\n        localStorage['TridentMode'] = 'service';\n        \n        sb_refresh_slots();\n    },\n    error: function (xhr, ajaxOptions, thrownError) {\n      // most -will- fail don't need to see errors\n      //API_LogMessage(address + \" \" + xhr.status + \" : \" + xhr.statusText);\n    }\n  });\n}\n\nfunction doScan() {\n  var i;\n  \n  var start = parseInt($('#txt-scanstart').val());\n  var end = parseInt($('#txt-scanend').val());\n  var baseAddress = $('#txt-baseaddress').val();\n  \n  for (i=start; i<=end; i++) {\n    scanAddress(baseAddress.replace('xxx',i) + \"/GetKey\");\n  }\n}\n"
}