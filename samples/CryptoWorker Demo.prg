{
  "progName": "CryptoWorker Demo",
  "htmlText": "<h3>Crypto Worker / Pool Sample</h3>\n<h4>Non-Pooling sample:</h4>\n<table width=\"100%\">\n<tr>\n    <td>\n        <table>\n        <tr>\n            <td>\n                <label>Password :</label>\n            </td>\n            <td>\n                <input type=\"password\" id=\"txtPassword\"/>\n            </td>\n        </tr>\n        <tr>\n            <td>\n                <label>Input Text :</label>\n            </td>\n            <td>\n                <textarea id=\"txtInputText\" rows=3 cols=40/>\n            </td>\n        </tr>\n        </table>\n    </td>\n    <td>\n    \t<label>Output :</label><br/>\n        <textarea id=\"txtOutputText\" rows=\"4\" cols=\"40\"/>\n    </td>\n</tr>\n</table>\n<br/>\n<button class=\"minimal\" onclick=\"basicEncrypt();\" style=\"width:240px\">Basic Worker Encrypt</button>\n<button class=\"minimal\" onclick=\"basicDecrypt();\" style=\"width:240px\">Basic Worker Decrypt</button>\n\n<br/><br/>\n<h4>Pooling Sample</h4>\n<table width=\"100%\">\n<tr>\n\t<td>\n    \t<table>\n        <tr>\n            <td>\n                <label>Password :</label>\n            </td>\n            <td>\n                <input type=\"password\" id=\"txtPasswordPool\"/>\n            </td>\n        </tr>\n        <tr>\n        \t<td><label>Values :</label></td>\n            <td><select id=\"selValues\" size=\"10\" style=\"width:200px\"></select>\n            </td>\n        </tr>\n        </table>\n    </td>\n    <td>\n    \t<label>Output Values: </label><br/>\n    \t<select id=\"selOutput\" size=\"10\" style=\"width:300px\"></select>\n    </td>\n</tr>\n</table>\n<br/>\n<button class=\"minimal\" onclick=\"poolRandom();\" style=\"width:240px\">Random Values</button>\n<button class=\"minimal\" onclick=\"poolEncrypt();\" style=\"width:240px\">Pool Encrypt</button>\n<button class=\"minimal\" onclick=\"poolDecrypt();\" style=\"width:240px\">Pool Decrypt</button>\n",
  "scriptText": "// Recommended practice is to place variables in this object and then delete in cleanup\nvar sbv = {\n    worker: null,\n    pool: null\n};\n\nif (typeof(Worker) == \"undefined\") alertify.error(\"Web Workers do not appear to be supported in your browser\");\n\nsandbox.events.clean = function() {\n    delete sbv.worker;\n    delete sbv.pool;\n};\n\nfunction basicEncrypt() {\n    if ($(\"#txtPassword\").val() === \"\") {\n        alertify.error(\"Enter Password\");\n        return;\n    }\n\n    sbv.worker = new Worker(\"libraries/crypto_worker.js\");\n\n    sbv.worker.onmessage = function (event){\n        $(\"#txtOutputText\").val(event.data.val);\n\n        $(\"#txtInputText\").val(\"\");\n\n        // Our custom crypto worker is built for one time call\n        // Since it closes itself after first message we will just clean up\n        // In theory you might write other workers which stay resident and handle multiple\n        sbv.worker.terminate();\n        sbv.worker = null;\n    };\n\n    var params = { \n        id: \"\", \n        val: $(\"#txtInputText\").val(), \n        algorithm: 'aes', \n        action: 'encrypt',\n        password: $(\"#txtPassword\").val() \n    };\n\n\n    sbv.worker.postMessage(params);\n}\n\nfunction basicDecrypt() {\n    sbv.worker = new Worker(\"libraries/crypto_worker.js\");\n\n    sbv.worker.onmessage = function (event){\n        $(\"#txtInputText\").val(event.data.val);\n\n        $(\"#txtOutputText\").val(\"\");\n\n        // Our custom crypto worker is built for one time call\n        // Since it closes itself after first message we will just clean up\n        // In theory you might write other workers which stay resident and handle multiple\n        sbv.worker.terminate();\n        sbv.worker = null;\n    };\n\n    var params = { \n        id: \"\", \n        val: $(\"#txtOutputText\").val(), \n        algorithm: 'aes', \n        action: 'decrypt', \n        password: $(\"#txtPassword\").val() \n    };\n\n    sbv.worker.postMessage(params);\n}\n\nfunction poolRandom() {\n    $(\"#selValues\").empty();\n\n    for( var i=0; i < 10; i++ ) {\n        $(\"#selValues\").append($(\"<option></option>\").text(Math.floor(Math.random() * 100))); \n    }\n}\n\nfunction poolEncrypt() {\n    if ($(\"#txtPasswordPool\").val() === \"\") {\n        alertify.error(\"Enter Password\");\n        return;\n    }\n\n    $(\"#selOutput\").empty();\n\n    // if first pool op, create pool\n    if (sbv.pool === null) {\n        sbv.pool = new Pool(4);\t// optimized for 4 cores\n        sbv.pool.init();\n    }\n\n    var resultCount = 0;\n\n    // Overkill but we will make a worker for each value and encrypt separately\n    // Each value gets its own encrypt worker in the pool\n    $(\"#selValues option\").each(function()\n                                {\n        // Create params, create new worker with callback logic, add to pool\n        var params = { \n            id: \"\", // dont really care about matching or sequence\n            val: $(this).text(), \n            algorithm: 'aes', \n            action: 'encrypt', \n            password: $(\"#txtPasswordPool\").val() \n        };\n\n        var workerTask = new WorkerTask('libraries/crypto_worker.js', function() {\n            $(\"#selOutput\").append($(\"<option></option>\").text(event.data.val));\n\n            // Detect if we are done\n            if (++resultCount == 10) {\n                $(\"#selValues\").empty();\n            }\n\n        }, params);\n\n        sbv.pool.addWorkerTask(workerTask);\n\n    });    \n}\n\nfunction poolDecrypt() {\n    $(\"#selValues\").empty();\n\n    // if first pool op, create pool\n    if (sbv.pool == null) {\n        sbv.pool = new Pool(4);\t// optimized for 4 cores\n        sbv.pool.init();\n    }\n\n    var resultCount = 0;\n\n    // Overkill but we will make a worker for each value and encrypt separately\n    // Each value gets its own encrypt worker in the pool\n    $(\"#selOutput option\").each(function()\n                                {\n        // Create params, create new worker with callback logic, add to pool\n        var params = { \n            id: \"\", // dont really care about matching or sequence\n            val: $(this).text(), \n            algorithm: 'aes', \n            action: 'decrypt', \n            password: $(\"#txtPasswordPool\").val() \n        };\n\n        var workerTask = new WorkerTask('libraries/crypto_worker.js', function() {\n            $(\"#selValues\").append($(\"<option></option>\").text(event.data.val));\n\n            // Detect if we are done\n            if (++resultCount == 10) {\n                $(\"#selOutput\").empty();\n            }\n\n        }, params);\n\n        sbv.pool.addWorkerTask(workerTask);\n\n    });    \n}"
}