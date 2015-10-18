{
  "progName": "CryptoJS",
  "htmlText": "<br/>\n<ul class=\"tnavlist\">\n    <li class=\"tnavli\"><a class=\"tnava\" onclick=\"showDiv(1);\" href=\"javascript:void(0)\"><i class=\"fa fa-lock\"></i> Encrypt</a></li>\n    <li class=\"tnavli\"><a class=\"tnava\" onclick=\"showDiv(2);\" href=\"javascript:void(0)\"><i class=\"fa fa-unlock\"></i> Decrypt</a></li>\n    <li class=\"tnavli\"><a class=\"tnava\" onclick=\"showDiv(3);\" href=\"javascript:void(0)\"><i class=\"fa fa-info-circle\"></i> About</a></li>\n</ul>\n\n<div id=\"divEncrypt\">\n    <h3>Encrypt</h3>\n\n    <table width=\"100%\">\n        <tr>\n            <th>Input</th>\n            <th>Output</th>\n        </tr>\n        <tr>\n            <td>\n                <textarea id='txtMessage' rows='10' style='width: 100%;'></textarea>\n            </td>\n            <td>\n                <textarea id='txtOutput' rows='10' style='width: 100%;'></textarea>\n            </td>\n        </tr>\n    </table>\n\n    <br/>\t\n    <button class=\"minimal\" onclick=\"encrypt()\">Encrypt</button>\n    <button class=\"minimal\" onclick=\"save()\">Save Output</button>\n</div>\n\n<div id=\"divDecrypt\" style=\"display:none\">\n    <h3>Decrypt</h3>\n\n    <table width=\"100%\">\n        <tr>\n            <th>Output</th>\n            <th>Input</th>\n        </tr>\n        <tr>\n            <td>\n                <textarea id='txtDecMessage' rows='10' style='width: 100%;'></textarea>\n            </td>\n            <td>\n                <textarea id='txtDecOutput' rows='10' style='width: 100%;'></textarea>\n            </td>\n        </tr>\n    </table>\n\n    <br/>\t\n    <button class=\"minimal\" onclick=\"decrypt()\">Decrypt</button>\n\n</div>\n\n<div id=\"divAbout\" style=\"display:none\">\n    <h3>About CryptJS Sample</h3>\n\n    <p>\n        This is a simple utility demonstrating a simple way of using Crypto.JS.  Additionally \n        it has functionality where you can see the raw encypted output for copy/paste or save. \n    </p>\n</div>",
  "scriptText": "sandbox.events.userLoadCallback = function(filestring) {\n    $('#txtMessage').val(filestring);\n};\n\nfunction showDiv(divIndex) {\n    $(\"#divEncrypt\").hide();\n    $(\"#divDecrypt\").hide();\n    $(\"#divAbout\").hide();\n\n    switch(divIndex) {\n        case 1: $(\"#divEncrypt\").show(); break;\n        case 2: $(\"#divDecrypt\").show(); break;\n        case 3: $(\"#divAbout\").show(); break;\n    }\n}\n\nfunction encrypt()\n{\n    sandbox.ui.showPasswordDialog(function(pass) {\n        if (pass.length < 6) {\n            alertify.alert(\"Password must be at least six characters\");\n            return;\n        }\n\n        var msg = $(\"#txtMessage\").val();\n\n        var encrypted = CryptoJS.AES.encrypt(msg, pass);\n        $(\"#txtOutput\").val(encrypted);\n    });\n\n}\n\nfunction decrypt()\n{\n    sandbox.ui.showPasswordDialog(function(pass) {\n        if (pass.length < 6) {\n            alertify.alert(\"Password must be at least six characters\");\n            return;\n        }\n\n        var msg = $(\"#txtDecMessage\").val();\n        var decrypted = CryptoJS.AES.decrypt(msg, pass);\n\n        document.getElementById(\"txtDecOutput\").value = decrypted.toString(CryptoJS.enc.Utf8);\n    });\n}\n\nfunction save()\n{\n    sandbox.files.saveTextFile('myencode.txt', $(\"#txtOutput\").val());\n}\n\n"
}