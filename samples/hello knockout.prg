{
  "progName": "hello knockout",
  "htmlText": "<h3>Knockout.js Model/View framework Databinding Sample</h3>\n<p>\nKnockout.js functionality provided mainly by ko.observable, ko.observableArray, and ko.pureComputed methods/classes.\n</p>\n\n<br/>\n<h4>\nko.observable and ko.pureComputed\n</h4>\n<fieldset>\n<div id=\"mystuff\">\n<p>First name: <input data-bind=\"value: firstName\" /></p>\n<p>Last name: <input data-bind=\"value: lastName\" /></p>\n<h2>Hello, <span data-bind=\"text: fullName\"> </span>!</h2>\n</div>\n</fieldset>\n\n<br/>\n<h4>\nko.observableArray\n</h4>\n<fieldset>\n<div id=\"myArrayStuff\">\n  <table width=\"100%\">\n    <tr>\n      <td>\n        <select style=\"width:200px\" size=8 data-bind=\"options: list,\n                        optionsText: 'name',\n                        value: 'id'\">\n\n        </select>\n      </td>\n      <td>\n      \t<button class=\"minimal\" onclick=\"addItem()\">Add Item</button>\n      </td>\n    </tr>\n  </table>\n</div>\n</fieldset>",
  "scriptText": "// Recommended practice is to place variables in this object and then delete in cleanup\nfunction EVT_CleanSandbox()\n{\n\t// putting all my bound controls into a named div to easily remove bindings here\n\tko.cleanNode($(\"#mystuff\")[0]);\n    ko.cleanNode($(\"#myArrayStuff\")[0]);\n}\n\n// Here's my data model\nvar ViewModel = function(first, last) {\n    this.firstName = ko.observable(first);\n    this.lastName = ko.observable(last);\n \n    this.fullName = ko.pureComputed(function() {\n        // Knockout tracks dependencies automatically. It knows that fullName depends on firstName and lastName, because these get called when evaluating fullName.\n        return this.firstName() + \" \" + this.lastName();\n    }, this);\n};\n \nko.applyBindings(new ViewModel(\"Planet\", \"Earth\"), document.getElementById('mystuff')); // This makes Knockout get to work\n\nvar SelectViewModel = {\n\tlist : ko.observableArray([{name: 'first', id: 1}, {name: 'second', id: 2}, {name: 'third', id: 3}])\n}\n\nko.applyBindings(SelectViewModel, document.getElementById('myArrayStuff'));\n\nfunction addItem()\n{\n\tSelectViewModel.list.push({name: 'another', id: 4});\n}"
}