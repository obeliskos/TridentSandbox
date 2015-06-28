{
  "progName": "node os module",
  "htmlText": "<h3>Node OS Module sample</h3>",
  "scriptText": "sandbox.ide.setWindowMode(2);\n\nvar os = require(\"os\");\n\nsandbox.ide.setActiveTab(1);\n\nsandbox.logger.log(\"Host Name : \" + os.hostname());\n\nsandbox.logger.log(\"Platform : \" + os.platform());\n\nsandbox.logger.log(\"Arch : \" + os.arch());\n\nsandbox.logger.log(\"Release : \" + os.release());\n\nsandbox.logger.log(\"Uptime : \" + os.uptime());\n\nsandbox.logger.log(\"TotalMem : \" + os.totalmem());\n\nsandbox.logger.log(\"FreeMem : \" + os.freemem());\n\nsandbox.logger.log(\"CPUs : \" + JSON.stringify(os.cpus(), null, '\\t'));"
}