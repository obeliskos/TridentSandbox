{
  "progName": "LokiJS QueryPerf",
  "htmlText": "<h3>\n    Loki performance test\n</h3>\n\n<div style=\"width:1000px;height:400px\" id=\"chart1\">\n\n</div>",
  "scriptText": "// Recommended practice is to place variables in this object and then delete in cleanup\nvar sbv = {\n    db: new loki('Autos'),\n    samplecoll: null,\n    arraySize: 5000, // how large of a dataset to generate\n    totalIterations: 5000, // how many times we search it\n    results: [],\n    getIterations : 2000000,\n    plot1: null,\n    max: 0\n};\n\nsandbox.events.clean = function() { \n    if (sbv.plot1) sbv.plot1.destroy();\n    sbv.samplecoll = null;\n    delete sbv.samplecoll;\n    sbv.db = null;\n    delete sbv.db;\n    delete sbv.results;\n    sbv.plot1 = null;\n    delete sbv.plot1;\n    sbv = null;\n};\n\nfunction genRandomVal()\n{\n    var text = \"\";\n    var possible = \"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789\";\n\n    for( var i=0; i < 20; i++ )\n        text += possible.charAt(Math.floor(Math.random() * possible.length));\n\n    return text;\n}\n\n// in addition to the loki id we will create a key of our own\n// (customId) which is number from 1- totalIterations\n// we will later perform find() queries against customId with and \n// without an index\nfunction initializeDB() {\n    sbv.db = new loki('sample');\n\n    var start, end, totalTime;\n\n    sbv.samplecoll = sbv.db.addCollection('samplecoll');\n\n    start = performance.now();\n\n    for (var idx=0; idx < sbv.arraySize; idx++) {\n        //var v1 = genRandomVal();\n        //var v2 = genRandomVal();\n        sbv.samplecoll.insert({ \n            customId: idx//, \n            //val: v1, \n            //val2: v2, \n            //val3: \"more data 1234567890\"\n        });\n    }\n\n    end = performance.now();\n    totalTime = end-start;\n    var rate = sbv.arraySize * 1000 / totalTime;\n    rate = rate.toFixed(2);\n\n    sbv.results.push(rate);\n\n}\n\nfunction testperfGet() {\n    var start, end;\n    var totalTime = 0.0;\n\n    for (var idx=0; idx < sbv.getIterations; idx++) {\n        var customidx = Math.floor(Math.random() * sbv.arraySize) + 1;\n\n        start = performance.now();\n        var results = sbv.samplecoll.get(customidx);\n        end = performance.now();\n        totalTime += (end-start);\n    }\n\n    var rate = sbv.getIterations * 1000 / totalTime;\n    rate = rate.toFixed(2);\n    sbv.results.push(rate);\n}\n\nfunction testperfFind() {\n    var totalTime = 0.0, avgTime = 0.0;\n    var start, end;\n\n    for (var idx=0; idx < sbv.totalIterations; idx++) {\n        var customidx = Math.floor(Math.random() * sbv.arraySize) + 1;\n\n        start = performance.now();\n        var results = sbv.samplecoll.find({ 'customId': customidx });\n        end = performance.now();\n\n        totalTime += (end-start);\n    }\n\n    var rate = sbv.totalIterations * 1000 / totalTime;\n    rate = rate.toFixed(2);\n\n    sbv.results.push(rate);\n}\n\nfunction testperfRS(multiplier) {\n    var start, end;\n    var totalTime = 0.0;\n\n    var loopIterations = sbv.totalIterations;\n    if (typeof(multiplier) != \"undefined\") {\n        loopIterations = loopIterations * multiplier;\n    }\n\n    for (var idx=0; idx < loopIterations; idx++) {\n        var customidx = Math.floor(Math.random() * sbv.arraySize) + 1;\n\n        start = performance.now();\n        var results = sbv.samplecoll.chain().find({ 'customId': customidx }).data();\n        end = performance.now();\n\n        totalTime += (end-start);\n    }\n\n    sandbox.logger.log(\"totalTime (rs) : \" + totalTime);\n\n    var rate = loopIterations * 1000 / totalTime;\n    rate = rate.toFixed(2);\n    sbv.results.push(rate);\n}\n\nfunction testperfDV(multiplier) {\n    var start, end;\n    var start2, end2;\n    var totalTime = 0.0;\n    var totalTime2 = 0.0;\n\n    var loopIterations = sbv.totalIterations;\n    if (typeof(multiplier) != \"undefined\") {\n        loopIterations = loopIterations * multiplier;\n    }\n\n    for (var idx=0; idx < loopIterations; idx++) {\n        var customidx = Math.floor(Math.random() * sbv.arraySize) + 1;\n\n        start = performance.now();\n        var dv = sbv.samplecoll.addDynamicView(\"perfview\");\n        dv.applyFind({ 'customId': customidx });\n        var results = dv.data();\n        end = performance.now();\n        totalTime += (end-start);\n\n        // test speed of repeated query on an already set up dynamicview\n        start2 = performance.now();\n        var results = dv.data();\n        end2 = performance.now();\n        totalTime2 += (end2-start2);\n\n        sbv.samplecoll.removeDynamicView(\"perfview\");\n    }\n\n    var rate = loopIterations * 1000 / totalTime;\n    var rate2 = loopIterations * 1000 / totalTime2;\n    rate = rate.toFixed(2);\n    rate2 = rate2.toFixed(2);\n\n    sbv.results.push(rate);\n    sbv.results.push(rate2);\n}\n\nfunction plotresults() {\n    $.jqplot.config.enablePlugins = true;\n    var s1 = sbv.results;\n    var ticks = ['inserts', 'get', 'find no idx', 'resultset no idx', 'dv no idx', 'dv repeat', 'find w/idx', 'resultset w/idx', 'dv idx', 'dv rpt idx'];\n\n    if (sbv.plot1) { \n        sbv.plot1.destroy();\n        sbv.plot1 = null;\n    }\n\n    var max = 0;\n    var flt = 0.0;\n    for (var idx=0; idx < s1.length; idx++) {\n        flt = parseFloat(s1[idx]);\n        if (flt > sbv.max) sbv.max = flt;\n    }\n\n    sbv.plot1 = $.jqplot('chart1', [s1], {\n        // Only animate if we're not using excanvas (not in IE 7 or IE 8)..\n        title: 'Ops/sec rates for various loki database operations',\n        animate: !$.jqplot.use_excanvas,\n        seriesDefaults:{\n            renderer:$.jqplot.BarRenderer,\n            pointLabels: { show: true }\n        },\n        axes: {\n            xaxis: {\n                renderer: $.jqplot.CategoryAxisRenderer,\n                //pad: 2,\n                ticks: ticks\n            },\n            yaxis: {\n                min: 0,\n                max: sbv.max*1.15,\n                tickOptions: {\n                    formatString: \"%#.5f\"\n                }\n            }\n        },\n        highlighter: { show: true }\n    });\n}\n\n\ninitializeDB();\n\ntestperfGet();\ntestperfFind();\ntestperfRS();\ntestperfDV();\nsbv.samplecoll.ensureIndex(\"customId\");\ntestperfFind();\ntestperfRS();\ntestperfDV();\nplotresults();"
}