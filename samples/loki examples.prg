{
  "progName": "loki examples",
  "htmlText": "<h3>Examples for using the loki.js in-memory database</h3>\n\n<button class=\"minimal\" style=\"min-width:240px\" onclick=\"API_Inspect(db)\">\nInspect Database\n</button>",
  "scriptText": "// Switch to log tab, hide markup, and set window mode show code and output\nif (VAR_TRIDENT_ENV_TYPE == 'IDE') {\n\tAPI_SetActiveTab(2);\n\tsb_toggle_script();\n\tAPI_SetWindowMode(2);\n}\n\nvar db = new loki('Example');\n\nfunction EVT_CleanSandbox() {\n\tdb = null;\n}\n\n(function(){\n\ttrace(\".\")\n\ttrace(\". You can inspect the database on the Main Output tab\");\n    trace(\". or by using your browser's console\")\n\ttrace(\".\")\n    trace(\"\");\n    trace(\"begining examples...\");\n    \n    // You can insert API_Inspect(object) statements to \n    // use the trident inspector to dump objects for inspection\n    // API_Inspect(db);\n   \n    // create two example collections\n    var users = db.addCollection('users', ['email']);\n    var projects = db.addCollection('projects', ['name']);\n\n    // show collections in db\n    db.listCollections();\n\n    trace('Adding 9 users');\n    \n    // create six users\n    var odin = users.insert( { name : 'odin', email: 'odin.soap@lokijs.org', age: 38 } );\n    var thor = users.insert( { name : 'thor', email : 'thor.soap@lokijs.org', age: 25 } );\n    var stan = users.insert( { name : 'stan', email : 'stan.soap@lokijs.org', age: 29 } );\n    // we create a snapshot of the db here so that we can see the difference\n    // between the current state of the db and after the json has been reloaded\n    var json = db.serialize();\n\n\n    var oliver = users.insert( { name : 'oliver', email : 'oliver.soap@lokijs.org', age: 31 } );\n    var hector = users.insert( { name : 'hector', email : 'hector.soap@lokijs.org', age: 15} );\n    var achilles = users.insert( { name : 'achilles', email : 'achilles.soap@lokijs.org', age: 31 } );\n    var lugh = users.insert( { name : 'lugh', email : 'lugh.soap@lokijs.org', age: 31 } );\n    var nuada = users.insert( { name : 'nuada', email : 'nuada.soap@lokijs.org', age: 31 } );\n    var cuchullain = users.insert( { name : 'cuchullain', email : 'cuchullain.soap@lokijs.org', age: 31 } );\n\n    trace('Finished adding users');\n    \n    // create an example project\n    var prj = projects.insert( { name : 'LokiJS', owner: stan });\n\n    stan.name = 'Stan Laurel';\n\n    // update object (this really only syncs the index)\n    users.update(stan);\n    users.remove(achilles);\n    \n    // finding users with age greater than 25\n    trace('Find by age > 25');\n    trace(users.find( {'age':{'$gt': 25} } ));\n    trace('Get all users');\n    trace(users.find());\n    trace('Get all users with age equal to 25');\n    trace(users.find({'age': 25}));\n    // get by id with binary search index\n    trace(users.get(8));\n  \n    // a simple filter for users over 30\n    function ageView(obj){\n      return obj.age > 30;\n    }\n    // a little more complicated, users with names longer than 3 characters and age over 30\n    function aCustomFilter(obj){\n      return obj.name.length  < 5 && obj.age > 30;\n    }\n\n    // test the filters\n    trace('Example: Where test');\n    trace(users.where(function(obj){ return obj.age > 30; }));\n    trace('End view test');\n    sep();\n\n    trace('Example: Custom filter test');\n    trace(users.where(aCustomFilter));\n    trace('End of custom filter');\n    sep();\n    \n    // example of map reduce\n    trace('Example: Map-reduce');\n    function mapFun(obj){\n        return obj.age;\n    }\n    function reduceFun(array){\n      var len = array.length >>> 0;\n      var i = len;\n      var cumulator = 0;\n      while(i--){\n          cumulator += array[i];\n      }\n      return cumulator / len;\n    }\n\n    trace('Average age is : ' + users.mapReduce( mapFun, reduceFun).toFixed(2) );\n    trace('End of map-reduce');\n    sep();\n\n    trace('Example: stringify');\n    trace('String representation : ' + db.serialize());\n    trace('End stringify example');\n    sep();\n\n    trace('Example: findAndUpdate');\n    function updateAge(obj){\n      obj.age *= 2;\n      return obj;\n    }\n    users.findAndUpdate(ageView, updateAge);\n    trace(users.find());\n    trace('End findAndUpdate example');\n    \n    // revert ages back for future tests\n    function revertAge(obj) {\n    \tobj.age /= 2;\n        return obj;\n    }\n    users.findAndUpdate(ageView, revertAge);\n    \n    // test chain() operations via resultset\n    sep();\n    trace('Example: Chained resultset');\n    // get users over 25 with substring 'in' in the name \n    // data() ends the chain and returns data[]\n    // the where() function is a renamed equivalent to previous view() function\n    trace(\n    \tusers.chain()\n        \t.find({'age':{'$gt': 25}})\n            .where(function(obj){ return obj.name.indexOf(\"in\") != -1 })\n            .find({'name':{'$contains': 'in'}})\n            .simplesort(\"age\")\n            .data()\n\t);\n    \n    sep();\n    trace('Example: DynamicView');\n    \n    // Create dynview and apply filter (these two could have been chained together)\n   \tvar dynView = users.addDynamicView(\"over30users\");\n    dynView.applyFind({'age':{'$gt': 30}});\n    // .applyWhere() can also be used to apply a user supplied filter function\n    \n\n    trace(\"Number of over 30 users : \" + dynView.data().length);\n    lugh.age = 29;\n    users.update(lugh);\n    trace(\"Number of over 30 users : \" + dynView.data().length);\n\n\tsep();\n    trace(\"Example : Simple Sort\");\n\n\t// sort by age, true is optional second param which will sort descending\n    // we are allowed one sort which can be either simple (as below) \n\tdynView.applySimpleSort(\"age\", true);  \n    trace(dynView.data());\n\n\tsep();\n    trace(\"Example : Sort via compare function\");\n\n\t// change the sort by setting a new one in which we will supply the compareFun.\n    // sort be name ascending...\n    dynView.applySort( function(obj1, obj2) {\n    \tif (obj1.name == obj2.name) return 0;\n        if (obj1.name > obj2.name) return 1;\n        if (obj1.name < obj2.name) return -1;\n    });\n    trace(dynView.data());\n    \n\tsep();\n    trace(\"Example : Persistent DynamicView\")\n    \n    // removing a dynamic view for demonstration purposes only.\n    // you can have as many dynamic views as memory allows\n    users.removeDynamicView(\"over30users\");\n    \n    // Create a persistent dynamic view (second param indicates persistent)\n    var dynViewPersistent = users.addDynamicView(\"over20users\", true);\n    dynViewPersistent.applyFind({'age':{'$gt': 20}});\n    dynViewPersistent.applySimpleSort(\"age\");\n    trace(dynViewPersistent.data());\n    \n    // user should use data() but let's monitor persistent data array \n    trace(\"Internal persistent data array length : \" + \n    \tdynViewPersistent.resultdata.length);\n        \n    // let's also verify it matches the internal resultset filtered rows\n    trace(\"Internal resultset filteredrows array length : \" +\n    \tdynViewPersistent.resultset.filteredrows.length);\n    \n    sep();\n    trace(\"Example : resultset branching\");\n    \n    // applied filters are permanent, so use copy to branch query\n    var clonedResults = dynViewPersistent.branchResultset();\n    clonedResults.where(function(obj){ return obj.name.indexOf(\"in\") != -1 });\n    trace(\"branched query result count : \" + clonedResults.data().length);\n    trace(\"original result count : \" + dynViewPersistent.data().length);\n    \n    sep();\n    trace(\"Example : offset/limit\");\n    trace(dynViewPersistent.resultset.offset(2).limit(4).data());\n\n\tsep();\n    db.loadJSON(json);\n\n    trace(db.serialize());\n\n    function sep(){\n      trace('//---------------------------------------------//');\n    }\n\n    function trace(message){\n        if(typeof console !== 'undefined' && console.log){\n        \tconsole.log(message);\n            API_LogMessage(message);\n        }\n    }\n})();"
}