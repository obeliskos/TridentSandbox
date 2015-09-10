{
  "progName": "Springy Demo",
  "htmlText": "<a href=\"http://getspringy.com/\" target=\"_blank\">Springy Demo</a><br/>\n<canvas id=\"springydemo\" width=\"640\" height=\"480\" />\n",
  "scriptText": "// This is a sample taken from springy distribution itself\n// Springy is a simple force directed graphing library\n\nvar sbv = {\n    graph : null,\n    dennis : null,\n    michael : null,\n    jessica : null,\n    timothy : null,\n    barbara : null,\n    franklin : null,\n    monty : null,\n    james : null,\n    bianca : null\n};\n\nsandbox.events.clean = function() {\n    delete sbv.dennis;\n    delete sbv.michael;\n    delete sbv.jessica;\n    delete sbv.timothy;\n    delete sbv.barbara;\n    delete sbv.franklin;\n    delete sbv.monty;\n    delete sbv.james;\n    delete sbv.bianca;\n    delete sbv.graph;\n};\n\nsbv.graph = new Springy.Graph();\n\nsbv.dennis = sbv.graph.newNode({\n    label: 'Dennis',\n    ondoubleclick: function() { console.log(\"Hello!\"); }\n});\nsbv.michael = sbv.graph.newNode({label: 'Michael'});\nsbv.jessica = sbv.graph.newNode({label: 'Jessica'});\nsbv.timothy = sbv.graph.newNode({label: 'Timothy'});\nsbv.barbara = sbv.graph.newNode({label: 'Barbara'});\nsbv.franklin = sbv.graph.newNode({label: 'Franklin'});\nsbv.monty = sbv.graph.newNode({label: 'Monty'});\nsbv.james = sbv.graph.newNode({label: 'James'});\nsbv.bianca = sbv.graph.newNode({label: 'Bianca'});\n\nsbv.graph.newEdge(sbv.dennis, sbv.michael, {color: '#00A0B0'});\nsbv.graph.newEdge(sbv.michael, sbv.dennis, {color: '#6A4A3C'});\nsbv.graph.newEdge(sbv.michael, sbv.jessica, {color: '#CC333F'});\n// by default label uses color of edge\nsbv.graph.newEdge(sbv.jessica, sbv.barbara, {color: '#EB6841', label : 'reports to'});\nsbv.graph.newEdge(sbv.michael, sbv.timothy, {color: '#EDC951'});\n// can also specify text color to be different than edge color for readability\nif (sandbox.volatile.env === \"IDE WJS\") {\n    sbv.graph.newEdge(sbv.franklin, sbv.monty, {color: '#7DBE3C', textColor: '#fff', label: 'works for'});\n}\nelse {\n    sbv.graph.newEdge(sbv.franklin, sbv.monty, {color: '#7DBE3C', textColor: '#000', label: 'works for'});\n}\nsbv.graph.newEdge(sbv.dennis, sbv.monty, {color: '#000000'});\nsbv.graph.newEdge(sbv.monty, sbv.james, {color: '#00A0B0'});\nsbv.graph.newEdge(sbv.barbara, sbv.timothy, {color: '#6A4A3C'});\nsbv.graph.newEdge(sbv.dennis, sbv.bianca, {color: '#CC333F'});\nsbv.graph.newEdge(sbv.bianca, sbv.monty, {color: '#EB6841'});\n\njQuery(function(){\n    var springy = window.springy = jQuery('#springydemo').springy({\n        graph: sbv.graph,\n        nodeSelected: function(node){\n            console.log('Node selected: ' + JSON.stringify(node.data));\n        }\n    });\n});\n"
}