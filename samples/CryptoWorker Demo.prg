{
  "progName": "CryptoWorker Demo",
  "htmlText": "<h3>Crypto Worker / Pool Sample</h3>\n<h4>Non-Pooling sample:</h4>\n<table width=\"100%\">\n<tr>\n    <td>\n        <table>\n        <tr>\n            <td>\n                <label>Password :</label>\n            </td>\n            <td>\n                <input type=\"password\" id=\"txtPassword\"/>\n            </td>\n        </tr>\n        <tr>\n            <td>\n                <label>Input Text :</label>\n            </td>\n            <td>\n                <textarea id=\"txtInputText\" rows=3 cols=40/>\n            </td>\n        </tr>\n        </table>\n    </td>\n    <td>\n    \t<label>Output :</label><br/>\n        <textarea id=\"txtOutputText\" rows=\"4\" cols=\"40\"/>\n    </td>\n</tr>\n</table>\n<br/>\n<button class=\"minimal\" onclick=\"basicEncrypt();\" style=\"width:240px\">Basic Worker Encrypt</button>\n<button class=\"minimal\" onclick=\"basicDecrypt();\" style=\"width:240px\">Basic Worker Decrypt</button>\n\n<br/><br/>\n<h4>Pooling Sample</h4>\n<table width=\"100%\">\n<tr>\n\t<td>\n    \t<table>\n        <tr>\n            <td>\n                <label>Password :</label>\n            </td>\n            <td>\n                <input type=\"password\" id=\"txtPasswordPool\"/>\n            </td>\n        </tr>\n        <tr>\n        \t<td><label>Values :</label></td>\n            <td><select id=\"selValues\" size=\"10\" style=\"width:200px\"></select>\n            </td>\n        </tr>\n        </table>\n    </td>\n    <td>\n    \t<label>Output Values: </label><br/>\n    \t<select id=\"selOutput\" size=\"10\" style=\"width:300px\"></select>\n    </td>\n</tr>\n</table>\n<br/>\n<button class=\"minimal\" onclick=\"poolRandom();\" style=\"width:240px\">Random Values</button>\n<button class=\"minimal\" onclick=\"poolEncrypt();\" style=\"width:240px\">Pool Encrypt</button>\n<button class=\"minimal\" onclick=\"poolDecrypt();\" style=\"width:240px\">Pool Decrypt</button>\n",
  "scriptText": "// Recommended practice is to place variables in this object and then delete in cleanup\nvar sbv = {\n\tworker: null,\n    pool: null\n}\n\nif (typeof(Worker) == \"undefined\") alertify.error(\"Web Workers do not appear to be supported in your browser\");\n\nfunction EVT_CleanSandbox()\n{\n\tdelete sbv.worker;\n}\n\nfunction basicEncrypt() {\n\tif ($(\"#txtPassword\").val() == \"\") {\n    \talertify.error(\"Enter Password\");\n        return;\n    }\n    \n\tsbv.worker = new Worker(\"libraries/crypto_worker.js\");\n\n\tsbv.worker.onmessage = function (event){\n\t\t$(\"#txtOutputText\").val(event.data.val);\n\n\t\t$(\"#txtInputText\").val(\"\");\n\n\t\t// Our custom crypto worker is built for one time call\n        // Since it closes itself after first message we will just clean up\n        // In theory you might write other workers which stay resident and handle multiple\n        sbv.worker.terminate();\n        sbv.worker = null;\n\t};\n    \n\tvar params = { \n\t\tid: \"\", \n\t\tval: $(\"#txtInputText\").val(), \n\t\talgorithm: 'aes', \n\t\taction: 'encrypt', \t\n\t\tpassword: $(\"#txtPassword\").val() \n\t};\n\n\n\tsbv.worker.postMessage(params);\n}\n\nfunction basicDecrypt() {\n\tsbv.worker = new Worker(\"libraries/crypto_worker.js\");\n\n\tsbv.worker.onmessage = function (event){\n\t\t$(\"#txtInputText\").val(event.data.val);\n\n\t\t$(\"#txtOutputText\").val(\"\");\n\n\t\t// Our custom crypto worker is built for one time call\n        // Since it closes itself after first message we will just clean up\n        // In theory you might write other workers which stay resident and handle multiple\n        sbv.worker.terminate();\n        sbv.worker = null;\n\t};\n    \n\tvar params = { \n\t\tid: \"\", \n\t\tval: $(\"#txtOutputText\").val(), \n\t\talgorithm: 'aes', \n\t\taction: 'decrypt', \n\t\tpassword: $(\"#txtPassword\").val() \n\t};\n\n\tsbv.worker.postMessage(params);\n}\n\nfunction poolRandom() {\n\t$(\"#selValues\").empty();\n    \n\tfor( var i=0; i < 10; i++ ) {\n        $(\"#selValues\").append($(\"<option></option>\").text(Math.floor(Math.random() * 100))); \n    }\n}\n\nfunction poolEncrypt() {\n\tif ($(\"#txtPasswordPool\").val() == \"\") {\n    \talertify.error(\"Enter Password\");\n        return;\n    }\n    \n\t$(\"#selOutput\").empty();\n\n\t// if first pool op, create pool\n\tif (sbv.pool == null) {\n    \tsbv.pool = new Pool(4);\t// optimized for 4 cores\n\t\tsbv.pool.init();\n    }\n    \n    var resultCount = 0;\n    \n\t// Overkill but we will make a worker for each value and encrypt separately\n    // Each value gets its own encrypt worker in the pool\n\t$(\"#selValues option\").each(function()\n\t{\n\t    // Create params, create new worker with callback logic, add to pool\n\t\tvar params = { \n\t\t\tid: \"\", // dont really care about matching or sequence\n\t\t\tval: $(this).text(), \n\t\t\talgorithm: 'aes', \n\t\t\taction: 'encrypt', \n\t\t\tpassword: $(\"#txtPasswordPool\").val() \n\t\t};\n\n\t\tvar workerTask = new WorkerTask('libraries/crypto_worker.js', function() {\n\t\t\t$(\"#selOutput\").append($(\"<option></option>\").text(event.data.val));\n            \n            // Detect if we are done\n            if (++resultCount == 10) {\n            \t$(\"#selValues\").empty();\n            }\n            \n\t\t}, params);\n\n\t\tsbv.pool.addWorkerTask(workerTask);\n        \n\t});    \n}\n\nfunction poolDecrypt() {\n\t$(\"#selValues\").empty();\n\n\t// if first pool op, create pool\n\tif (sbv.pool == null) {\n    \tsbv.pool = new Pool(4);\t// optimized for 4 cores\n\t\tsbv.pool.init();\n    }\n    \n    var resultCount = 0;\n    \n\t// Overkill but we will make a worker for each value and encrypt separately\n    // Each value gets its own encrypt worker in the pool\n\t$(\"#selOutput option\").each(function()\n\t{\n\t    // Create params, create new worker with callback logic, add to pool\n\t\tvar params = { \n\t\t\tid: \"\", // dont really care about matching or sequence\n\t\t\tval: $(this).text(), \n\t\t\talgorithm: 'aes', \n\t\t\taction: 'decrypt', \n\t\t\tpassword: $(\"#txtPasswordPool\").val() \n\t\t};\n\n\t\tvar workerTask = new WorkerTask('libraries/crypto_worker.js', function() {\n\t\t\t$(\"#selValues\").append($(\"<option></option>\").text(event.data.val));\n            \n            // Detect if we are done\n            if (++resultCount == 10) {\n            \t$(\"#selOutput\").empty();\n            }\n            \n\t\t}, params);\n\n\t\tsbv.pool.addWorkerTask(workerTask);\n        \n\t});    \n}"
}