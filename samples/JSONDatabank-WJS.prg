{
  "progName": "JSONDatabank-WJS",
  "htmlText": "<style>\na.wjslink {\n   color: rgba(156, 114, 255, 0.67);\n}\na.wjslink:hover {\n   color: rgba(156, 114, 255, 0.97);\n}\n.fullScreen {\n    width: 100%;\n    height: 100%;\n    position: absolute;\n    top: 0;\n    left: 0;\n}\n\ninput[type='date'] {\n\tbackground-color: rgba(255, 255, 255, 0.8);\n    border-color: transparent;\n    color: #000;\n    min-height: 28px;\n    min-width: 64px;\n    -ms-user-select: element;\n    font-family: \"Segoe UI\", \"Segoe WP\", \"sans-serif\", \"Segoe UI Symbol\", \"Symbols\";\n    font-size: 15px;\n    font-weight: 400;\n    line-height: 1.333;\n}\ninput[type='date']:hover {\n\tbackground-color: rgba(255, 255, 255, 0.87);\n}\ninput[type='date']:focus {\n\tbackground-color: #fff;\n}\n\n/*width of each section*/\n.section1.win-hub-section {\n    width: 1200px;\n    overflow: hidden;\n/*    background-color:#565; */\n}\n\n.section2.win-hub-section {\n    width: 1300px; \n/*    background-color:#454; */\n}\n\n.section3.win-hub-section {\n    width: 800px;\n}\n\n.section4.win-hub-section {\n    width: 650px;\n/*    background-color:#232; */\n}\n\n#insertListView {\n    height: 100%;\n}\n\n.horizontallistview {\n    height: 100%;\n}\n\n\n/*ListView style inside section container*/\n#listView.win-listview {\n    height: calc(100% - 150px);\n    width: 100%;\n}\n\n\n#listView.win-listview .win-container {\n    width: 242px;\n    height: 60px;\n}\n\n\n/*styles for video in section 3*/\n.promoVideo {\n    height: 330px;\n    width: 400px;\n}\n\n/*App Header Styles*/\n#appHeader {\n    position: absolute;\n    z-index: 1;\n    top: 50px;\n    left: 40px;\n}\n\n    #appHeader .win-navigation-backbutton {\n        margin-right: 20px;\n    }\n\n    #appHeader h1 {\n        display: inline;\n    }\n\n/* if window height is less than 800 then make header area smaller */\n@media all and (max-height: 800px) {\n\t.win-hub-section-header {\n\t\tmargin-top:60px !important;\n\t}\n}\n\n/*styles when app is in the portrait mode*/\n@media all and (min-height: 1280px) {\n    .section2.win-hub-section {\n        overflow: hidden;\n    }\n\n    /*change the width of the form control to cover only one input box*/\n    .section4.win-hub-section {\n    }\n\n}\n\n/*styles for larger screens*/\n@media (min-width: 1920px) {\n    .section2.win-hub-section {\n        overflow: hidden;\n    }\n\n    /*change the width of the form control to cover only one input box*/\n    .section4.win-hub-section {\n    }\n\n}\n\n</style>\n\n<div id=\"divMainFS\" class=\"fullScreen\" style=\"display:none\" >\n    <!-- Flyouts -->\n    <div id=\"addLookupFlyout\" data-win-control=\"WinJS.UI.Flyout\" aria-label=\"{Add lookup flyout}\">\n        <div>Enter name of new lookup<br/>\n        <input type='text' id=\"txtAddLookupName\">\n        </div>\n        <button id=\"btnAddLookupAction\" onclick=\"doAddLookup()\">Add</button>\n    </div>\n\n    <div id=\"editLookupFlyout\" data-win-control=\"WinJS.UI.Flyout\" aria-label=\"{Edit lookup flyout}\">\n        <div>Edit name of lookup<br/>\n        <input type='text' id=\"txtEditLookupName\">\n        </div>\n        <button id=\"btnEditLookupAction\" onclick=\"doEditLookup()\">Update</button>\n    </div>\n\n    <div id=\"deleteLookupFlyout\" data-win-control=\"WinJS.UI.Flyout\" aria-label=\"{Delete lookup flyout}\">\n        <div>Delete lookup?<br/><br/></div>\n        <button id=\"btnDeleteLookupAction\" onclick=\"doDeleteLookup()\">Confirm</button>\n    </div>\n\n    <div id=\"addLookupValueFlyout\" data-win-control=\"WinJS.UI.Flyout\" aria-label=\"{Add lookup value flyout}\">\n        <div>Enter lookup value<br/>\n        <input type='text' id=\"txtAddLookupValue\">\n        </div>\n        <button id=\"btnAddLookupValueAction\" onclick=\"doAddLookupValue()\">Add</button>\n    </div>\n\n    <div id=\"editLookupValueFlyout\" data-win-control=\"WinJS.UI.Flyout\" aria-label=\"{Edit lookup value flyout}\">\n        <div>Edit lookup value<br/>\n        <input type='text' id=\"txtEditLookupValue\">\n        </div>\n        <button id=\"btnEditLookupValueAction\" onclick=\"doEditLookupValue()\">Update</button>\n    </div>\n\n    <div id=\"deleteLookupValueFlyout\" data-win-control=\"WinJS.UI.Flyout\" aria-label=\"{Delete lookup value flyout}\">\n        <div>Delete lookup value?<br/><br/></div>\n        <button id=\"btnDeleteLookupValueAction\" onclick=\"doDeleteLookupValue()\">Confirm</button>\n    </div>\n\n    <div id=\"deleteEntryFlyout\" data-win-control=\"WinJS.UI.Flyout\" aria-label=\"{Delete entry flyout}\">\n        <div>Delete Entry?<br/><br/></div>\n        <button id=\"btnDeleteLookupValueAction\" onclick=\"doDeleteEntry()\">Confirm</button>\n    </div>\n\n    <div id=\"deleteSchemaFlyout\" data-win-control=\"WinJS.UI.Flyout\" aria-label=\"{Delete schema flyout}\">\n        <div>Delete Schema?<br/><br/></div>\n        <button id=\"btnDeleteSchemaAction\" onclick=\"doDeleteSchema()\">Confirm</button>\n    </div>\n\n    <!-- AppBar -->\n    <div id=\"createAppBar\" data-win-control=\"WinJS.UI.AppBar\" data-win-options=\"{sticky: true, placement: 'top'}\">\n      <button data-win-control=\"WinJS.UI.AppBarCommand\" data-win-options=\"{id:'cmdSave',label:'Save',icon:'save',section:'global',tooltip:'Add new top-level node'}\"></button>\n      <button data-win-control=\"WinJS.UI.AppBarCommand\" data-win-options=\"{id:'cmdExport',label:'Export',icon:'download',section:'global',tooltip:'Add child below selected node'}\"></button>\n      <button data-win-control=\"WinJS.UI.AppBarCommand\" data-win-options=\"{id:'cmdImport',label:'Import',icon:'upload',section:'global',tooltip:'Rename the selected node', type:'flyout', flyout: select('#renameFlyout')}\"></button>\n      <button data-win-control=\"WinJS.UI.AppBarCommand\" data-win-options=\"{id:'cmdFullscreen',label:'Toggle Fullscreen',icon:'fullscreen',section:'selection',tooltip:'Toggle fullscreen'}\"></button>\n    </div>\n    \n    <!-- App Header -->\n    <div id=\"appHeader\">\n        <h2>JSON Databank</h2>\n    </div>\n    \n\t<!-- Hub / Hub Sections -->\n    <div style=\"top:80px\" data-win-control=\"WinJS.UI.Hub\">\n        <div class=\"section2\" data-win-control=\"WinJS.UI.HubSection\" data-win-options=\"{header: 'Data Entry', isHeaderStatic: true}\">\n            <table width=\"100%\">\n              <tr valign=\"top\">\n                <td>\n                    <label style=\"font-size:20px\"><b>Schemas</b></label><br/>\n                    <select size=\"15\" id=\"selSchemaList\" onchange=\"refreshSchemaItems()\" style=\"width:100%; font-size:20px\"></select><br/>\n                </td>\n                <td>\n                    <label style=\"font-size:20px\"><b>Items</b></label><br/>\n                    <select size=\"15\" id=\"selSchemaItems\" onchange=\"showItem()\" style=\"width:100%; font-size:20px\"></select><br/>\n                    <button class=\"minimal\" onclick=\"addEditorItem()\" style=\"min-width:100px; width:100px\"><i class=\"fa fa-plus-circle\"></i> Add</button>\n                    <button id=\"btnDeleteEntry\" class=\"minimal\" onclick=\"delEditorItem()\" style=\"min-width:100px; width:100px\"><i class=\"fa fa-minus-circle\"></i> Delete</button>\n                </td>\n                <td>\n                    <div style=\"margin-left:10px; overflow-y:scroll\" id='entry_editor_holder'></div>\n                    <div id=\"divEditorButtons\" style=\"margin-left:20px; display:none\">\n                        <button class=\"minimal\" onclick=\"saveEditorItem()\"><i class=\"fa fa-save\"></i> Save</button>\n                    </div>\n                </td>\n              </tr>\n            </table>\n        </div>\n        \n        <div class=\"section2\" data-win-control=\"WinJS.UI.HubSection\" data-win-options=\"{header: 'Schemas', isHeaderStatic: true}\">\n            <table width=\"100%\">\n            <tr valign=\"top\">\n                <td>\n                    <h3>Schemas</h3>\n                    <select id=\"selSchemaManage\" style=\"width:100%; font-size:20px;\" size=\"15\" onchange=\"manageSchemaChange()\"></select>\n                    <br/>\n                    <button id=\"btnDeleteSchema\" class=\"minimal\" onclick=\"deleteSchema()\"><i class=\"fa fa-minus-circle\"></i> Delete</button>\n                </td>\n                <td>\n                    <div style=\"margin-left:10px\" id='editor_holder'></div>\n                    <div id=\"divHints\">\n                        <ul>\n                            <li><i>All Schemas <b>must have</b> a <b>Name</b> property</i></li>\n                            <li><i>Schemas <b>should not</b> have an <b>id</b> property</i></li>\n                            <li><i>Schemas <b>should not</b> have an <b>objType</b> property</i></li>\n                        </ul>\n                    </div>\n\n                    <div style=\"margin-left:100px\">\n                        <button class=\"minimal\" onclick=\"newSchema()\"><i class=\"fa fa-plus\"></i> New</button>\n                        <button class=\"minimal\" onclick=\"saveSchema()\"><i class=\"fa fa-save\"></i> Save</button>\n                    </div>\n                </td>\n            </tr>\n\n            </table>\n        </div>\n        \n        <div class=\"section3\" data-win-control=\"WinJS.UI.HubSection\" data-win-options=\"{header: 'Lookups', isHeaderStatic: true}\">\n            <table width=\"100%\">\n            <tr>\n                <th>Lookups</th>\n                <th>Lookup Values</th>\n            </tr>\n            <tr>\n                <td><select size=\"15\" id=\"selLookups\" onchange=\"refreshLookupValues()\" style=\"width:100%; font-size:20px;\"></select></td>\n                <td><select size=\"15\" id=\"selLookupVals\" style=\"width:100%; font-size:20px;\"></select></td>\n            </tr>\n            <tr>\n                <td align='center'>\n                    <button id=\"btnAddLookup\" class=\"minimal\" onclick=\"addLookup()\" style=\"width:120px\"><i class=\"fa fa-plus-circle\"></i> Add</button> \n                    <button id=\"btnEditLookup\" class=\"minimal\" onclick=\"editLookup()\" style=\"width:120px\"><i class=\"fa fa-pencil-square-o\"></i> Edit</button> \n                    <button id=\"btnDeleteLookup\" class=\"minimal\" onclick=\"delLookup()\" style=\"width:120px\"><i class=\"fa fa-minus-circle\"></i> Delete</button>\n                </td>\n                <td align='center'>\n                    <button id=\"btnAddLookupValue\" class=\"minimal\" onclick=\"addLookupValue()\" style=\"width:120px\"><i class=\"fa fa-plus-circle\"></i> Add</button> \n                    <button id=\"btnEditLookupValue\" class=\"minimal\" onclick=\"editLookupValue()\" style=\"width:120px\"><i class=\"fa fa-pencil-square-o\"></i> Edit</button> \n                    <button id=\"btnDeleteLookupValue\" class=\"minimal\" onclick=\"delLookupValue()\" style=\"width:120px\"><i class=\"fa fa-minus-circle\"></i> Delete</button>\n                </td>\n            </tr>\n            </table>\n        </div>\n        \n        <div class=\"section4\" data-win-control=\"WinJS.UI.HubSection\" data-win-options=\"{header: 'Data Entry', isHeaderStatic: true}\">\n            <h3>About JSON Databank</h3>\n            <p>This is a data-filer type application that let's you define the structure of \n            non-hierarchical json objects (in a way similar to flat-file type tables), set up lookup lists, and enter/view data in those tables.&nbsp; \n            It uses loki.js to store json objects whose structure is defined dynamically.&nbsp; Json-Editor.js \n            is used for generating dynamic forms for data entry as well as for schema definition.</p>\n            <p>The <a class=\"wjslink\" href=\"https://github.com/jdorn/json-editor\" target=\"_blank\">Json Editor</a> control adheres to a more complete version of Json Schema standard.&nbsp; This \n            application simplifies and reduces it to basic datatypes you see implemented and then stores \n            that simplified schema in a loki schemas collection.&nbsp; This collection is later used to \n            recreate the schema for data entry.</p>\n        </div>\n        \n\t</div>\n</div>\n",
  "scriptText": "sandbox.ui.setBackgroundColor(\"#343\");\n\nvar sbv = {\n\teditor : null,\n    entryEditor: null,\n    db: new loki('JSON Databank'),\n    lookups: null,\n    lookupValues : null,\n    schemas: null\n}\n\nsandbox.events.clean = function() {\n\tif (sbv.editor) sbv.editor.destroy();\n    if (sbv.entryEditor) sbv.entryEditor.destroy();\n    \n    delete sbv.lookups;\n    delete sbv.lookupValues;\n    delete sbv.schemas;\n\tdelete sbv.db;\n    delete sbv.editor;\n    delete sbv.entryEditor;\n    \n\tsbv = null;\n}\n\nsandbox.events.windowResize = function() {\n    switch (sandbox.volatile.env) {\n        case \"IDE\" : alertify.error(\"This sample needs winjs version\"); break;\n        case \"IDE WJS\" : $(\"#UI_MainPlaceholder\").css(\"height\", $(window).height() - 280); break;\n        default : break;\n    }\n}\n\nsandbox.events.windowResize();\n//\n// UI LOAD/REFRESH FUNCTIONS\t\n//\n\n// updates select list for display/management of schemas\nfunction refreshSchemas() {\n\t$(\"#selSchemaManage\").html(\"\");\n\t$(\"#selSchemaList\").html(\"\");\n\n\tfor (var idx=0; idx < sbv.schemas.data.length; idx++) {\n\t\t$(\"#selSchemaManage\")\n\t\t\t.append($('<option>', { value : sbv.schemas.data[idx].$loki })\n\t\t\t.text(sbv.schemas.data[idx].Name)); \n\t\t$(\"#selSchemaList\")\n\t\t\t.append($('<option>', { value : sbv.schemas.data[idx].$loki })\n\t\t\t.text(sbv.schemas.data[idx].Name)); \n    }\n\n\t$('#selSchemaList option:first-child').attr(\"selected\", \"selected\");\n    refreshSchemaItems();\n    \n    $(\"#selSchemaItems\").focus();\n    $(\"#selSchemaList\").focus();\n}\n\n// Establishing a convention that all items need Name property,\n// which is what we will display in this list\nfunction refreshSchemaItems() {\n\t$(\"#selSchemaItems\").html(\"\");\n    \n\tvar schemaId = $(\"#selSchemaList\").val();\n    \n    if (schemaId == null) return;\n    \n    var schemaName = $(\"#selSchemaList\").find(\"option:selected\").text();\n\n\t// if dynamic collection hasn't been created yet then just exit with empty list\n\tvar schemaItems = null;\n    schemaItems = sbv.db.getCollection(schemaName);\n    if (schemaItems == null) { return; };\n    \n    for(var idx=0; idx < schemaItems.data.length; idx++) {\n\t\t$(\"#selSchemaItems\")\n\t\t\t.append($('<option>', { value : schemaItems.data[idx].$loki })\n\t\t\t.text(schemaItems.data[idx].Name));\n    }\n}\n\n// updates select list for display/management of lookups\nfunction refreshLookups() {\n\t$(\"#selLookups\").html(\"\");\n    \n\tfor(var idx=0; idx < sbv.lookups.data.length; idx++) {\n\t\t$(\"#selLookups\")\n\t\t\t.append($('<option>', { value : sbv.lookups.data[idx].$loki })\n\t\t\t.text(sbv.lookups.data[idx].name)); \n    }\n}\n\n// updates select list for display/management of values\nfunction refreshLookupValues() {\n\tvar lkpId = $(\"#selLookups\").val();\n    var lkpVals = sbv.lookupValues.find({ 'listId': { '$eq' : parseInt(lkpId) }});\n    \n\t$(\"#selLookupVals\").html(\"\");\n    \n\tfor(var idx=0; idx < lkpVals.length; idx++) {\n\t\t$(\"#selLookupVals\")\n\t\t\t.append($('<option>', { value : lkpVals[idx].$loki })\n\t\t\t.text(lkpVals[idx].name)); \n    }\n}\n\n//\n// LOOKUP MAINTENANCE\n//\n\nfunction addLookup() {\n    var btn = document.getElementById(\"btnAddLookup\");\n    document.getElementById(\"addLookupFlyout\").winControl.show(btn);\n}\n\nfunction doAddLookup() {\n\tvar str = $(\"#txtAddLookupName\").val();\n    document.getElementById(\"addLookupFlyout\").winControl.hide();\n    \n\tsbv.lookups.insert({ name: str });\n    refreshLookups();\n    initSchemaEditor();\n}\n\nfunction editLookup() {\n\tvar lkpId = $(\"#selLookups\").val();\n    if (lkpId == null) return;\n    \n    var lkpText = $(\"#selLookups\").find(\"option:selected\").text();\n    \n    $(\"#txtEditLookupName\").val(lkpText);\n    \n    var btn = document.getElementById(\"btnEditLookup\");\n    document.getElementById(\"editLookupFlyout\").winControl.show(btn);\n}\n\nfunction doEditLookup() {\n\tvar lkpId = $(\"#selLookups\").val();\n    var lkp = sbv.lookups.get(parseInt(lkpId));\n    \n\tlkp.name = $(\"#txtEditLookupName\").val();\n    \n    document.getElementById(\"editLookupFlyout\").winControl.hide();\n\n    refreshLookups();\n    initSchemaEditor();\n}\n\nfunction delLookup() {\n\tvar lkpId = $(\"#selLookups\").val();\n    if (lkpId == null) return;\n    \n    var btn = document.getElementById(\"btnDeleteLookup\");\n    document.getElementById(\"deleteLookupFlyout\").winControl.show(btn);\n}\n\nfunction doDeleteLookup() {\n\tvar lkpId = $(\"#selLookups\").val();\n    var lkpText = $(\"#selLookups\").find(\"option:selected\").text();\n    var lkp = sbv.lookups.get(parseInt(lkpId));\n\n    document.getElementById(\"deleteLookupFlyout\").winControl.hide();\n    \n   \t//remove values first\n\tvar lkpVals = sbv.lookupValues.find({ 'listId': { '$eq' : parseInt(lkpId) }});\n\tfor(var idx=0; idx < lkpVals.length; idx++) {\n       \tsbv.lookupValues.remove(lkpVals[idx]);\n    }\n           \n\tsbv.lookups.remove(lkp);\n    refreshLookups();\n    initSchemaEditor();\n}\n\nfunction addLookupValue() {\n\tvar lkpId = $(\"#selLookups\").val();\n    if (lkpId == null) return;\n    \n\tvar btn = document.getElementById(\"btnAddLookupValue\");\n    document.getElementById(\"addLookupValueFlyout\").winControl.show(btn);\n}\n\nfunction doAddLookupValue() {\n\tvar lkpId = $(\"#selLookups\").val();\n\tvar str = $(\"#txtAddLookupValue\").val();\n    document.getElementById(\"addLookupValueFlyout\").winControl.hide();\n\n\tsbv.lookupValues.insert({ listId: parseInt(lkpId), name: str });\n    refreshLookupValues();\n}\n\nfunction editLookupValue() {\n\tvar valId = $(\"#selLookupVals\").val();\n    if (valId == null) return;\n    \n    var valText = $(\"#selLookupVals\").find(\"option:selected\").text();\n    $(\"#txtEditLookupValue\").val(valText);\n    \n    var btn = document.getElementById(\"btnEditLookupValue\");\n    document.getElementById(\"editLookupValueFlyout\").winControl.show(btn);\n}\n\nfunction doEditLookupValue() {\n\tvar valId = $(\"#selLookupVals\").val();\n    var val = sbv.lookupValues.get(parseInt(valId));\n    \n\tval.name = $(\"#txtEditLookupValue\").val();;\n    document.getElementById(\"editLookupValueFlyout\").winControl.hide();\n\n    refreshLookupValues();\n}\n\nfunction delLookupValue() {\n\tvar lkpId = $(\"#selLookupVals\").val();\n    if (lkpId == null) return;\n    \n    var btn = document.getElementById(\"btnDeleteLookupValue\");\n    document.getElementById(\"deleteLookupValueFlyout\").winControl.show(btn);\n}\n\nfunction doDeleteLookupValue() {\n\tvar valId = $(\"#selLookupVals\").val();\n    var valText = $(\"#selLookupVals\").find(\"option:selected\").text();\n    var val = sbv.lookupValues.get(parseInt(valId));\n\n    document.getElementById(\"deleteLookupValueFlyout\").winControl.hide();\n    \n\tsbv.lookupValues.remove(val);\n    refreshLookupValues();\n}\n\n// returns array for placement into entry editor object reference\nfunction getLookupValues(lkpName) {\n\tvar lkp = sbv.lookups.find({ 'name': { '$eq' : lkpName }});\n    var valObjs = sbv.lookupValues.find({ 'listId': { '$eq' : lkp[0].$loki }});\n\tvar vals = [\"\"];\n    \n    for(var idx=0; idx < valObjs.length; idx++) {\n    \tvals.push(valObjs[idx].name);\n    }\n    \n    return vals;\n}\n\n// returns array for placement into schema def obj reference\nfunction getLookupLists() {\n\tvar listNames = [\"\"];\n    \n\tfor(var idx=0; idx < sbv.lookups.data.length; idx++) {\n    \tlistNames.push(sbv.lookups.data[idx].name);\t\n    }\n    \n    return listNames;\n}\n\nfunction generateEditorSchema(schemaId) {\n    var schema = sbv.schemas.get(schemaId);\n    var propertiesObject = {};\n    for(var idx=0; idx < schema.Properties.length; idx++) {\n    \tvar prop = schema.Properties[idx];\n        \n        if (prop.srcLookup != \"\") {\n        \tvar propAttrs = { type: \"string\", enum: getLookupValues(prop.srcLookup) };\n        \tpropertiesObject[prop.propName] = propAttrs;\n        }\n        else {\n        \tif (prop.type == \"date\") {\n        \t\tvar propAttrs = { type: \"string\", format: \"date\" };\n        \t\tpropertiesObject[prop.propName] = propAttrs;\n            }\n            else {\n            \tif (prop.type == \"textarea\") {\n        \t\t\tvar propAttrs = { type: \"string\", format: \"textarea\", rows: \"5\" };\n        \t\t\tpropertiesObject[prop.propName] = propAttrs;\n                }\n                else {\n        \t\t\tvar propAttrs = { type: prop.type };\n        \t\t\tpropertiesObject[prop.propName] = propAttrs;\n                }\n            }\n\t\t}\n    }\n    \n   \treturn propertiesObject;\n}\n\nfunction addEditorItem() {\n\tvar itemId = $(\"#selSchemaList\").val();\n    \n    if (itemId == null) return;\n    \n\tinitDataEditor();\n    \n    $(\"#selSchemaItems\").val([]);\n    \n    // override styles imposed by json editor or apply additional functionality\n    //$(\"input[data-schemaformat=date]\").datepicker();\n    $(\"textarea[data-schemaformat=textarea]\").css(\"height\", \"150px\");\n    $(\"#divEditorButtons\").show();\n\n}\n\nfunction saveEditorItem() {\n    var selItem = $(\"#selSchemaItems\").val();\n    var selSchema = $(\"#selSchemaList\").val();\n   \tvar schemaName = $(\"#selSchemaList\").find(\"option:selected\").text();\n    //var schemaItems = sbv.db.getCollection(schemaName);\n    var schemaRec = sbv.schemas.get(parseInt(selSchema));\n    \n    // If dynamic collection doesn't exist yet (this is first item), create it\n    var schemaItems = null;\n    try {\n    \tschemaItems = sbv.db.getCollection(schemaName);\n    }\n    catch (err) {\n    \tschemaItems = sbv.db.addCollection(schemaName);\n    };\n    \n    if (selItem == null) {\n    \tvar newObj = sbv.entryEditor.getValue();\n        \n    \tschemaItems.insert(newObj);\n\n\t\trefreshSchemaItems();\n        addEditorItem();\n    \talertify.success(\"added\");\n\t}\n    else {\n    \tvar oldObj = schemaItems.get(parseInt(selItem));\n    \tvar newObj = sbv.entryEditor.getValue();\n        \n        for (var idx=0; idx < schemaRec.Properties.length; idx++) {\n        \tvar propName = schemaRec.Properties[idx].propName;\n            \n\t\t\toldObj[propName] = newObj[propName];\n        }\n        \n        // in case they changed the 'name' property, item list would change\n\t\trefreshSchemaItems();\n        addEditorItem();\n    \talertify.log(\"updated\");\n\t}\n\n}\n\nfunction delEditorItem() {\n    var selItem = $(\"#selSchemaItems\").val();\n    if (selItem == null) return;\n    \n    var btn = document.getElementById(\"btnDeleteEntry\");\n    document.getElementById(\"deleteEntryFlyout\").winControl.show(btn);\n}\n\nfunction doDeleteEntry() {\n    var selItem = $(\"#selSchemaItems\").val();\n   \tvar schemaName = $(\"#selSchemaList\").find(\"option:selected\").text();\n    var schemaItems = sbv.db.getCollection(schemaName);\n    var oldObj = schemaItems.get(parseInt(selItem));\n\n    document.getElementById(\"deleteEntryFlyout\").winControl.hide();\n    \n\tschemaItems.remove(oldObj);\n\n\t// If no more items in dynamic collection, remove the collection but keep its schema\n    // This is necessary due to loki.js persistence bug with empty collections.\n    if (schemaItems.data.length == 0) {\n    \tsbv.db.removeCollection(schemaName);\n    }\n    \n\trefreshSchemaItems();\n}\n\n// when user changes the selected schema in shema manage screen, this displays contents\nfunction manageSchemaChange() {\n\t$(\"#divHints\").hide();\n    \n\tresetManageEditor();\n    \n\tvar selId = $(\"#selSchemaManage\").val();\n    var schema = sbv.schemas.get(parseInt(selId));\n    \n    var propertiesArray = [];\n    for(var idx=0; idx < schema.Properties.length; idx++) {\n    \tvar prop = schema.Properties[idx];\n        \n        if (prop.srcLookup != \"\") {\n        \tvar propObj = { name: prop.propName, type: prop.type, srcLookup: prop.srcLookup };\n        \tpropertiesArray.push(propObj);\n        }\n        else {\n\t\t\tvar propObj = { name: prop.propName, type: prop.type };\n\t\t\tpropertiesArray.push(propObj);\n\t\t}\n    }\n    \n    var editorObj = \n\t{ \n    \tSchemaName: schema.Name,\n        PropertyList: propertiesArray\n\t}\n    \n\tsbv.editor.setValue(editorObj);\n\n}\n\nfunction resetManageEditor() {\n\tvar editorObj = \n    { \n    \tSchemaName: \"\", \n        PropertyList: [\n        {\n        \tname: \"Name\",\n            type: \"string\",\n            srcLookup: \"\"\n        }\n        ] \n    }\n    \n\tsbv.editor.setValue(editorObj);\n}\n\nfunction newSchema()\n{\n\t$(\"#selSchemaManage\").val([]);\n\n\tresetManageEditor();\n}\n\nfunction saveSchema() \n{\n\tvar selId = $(\"#selSchemaManage\").val();\n\tvar schemaName = $(\"#selSchemaManage\").find(\"option:selected\").text();\n    \n\tvar editorObj = sbv.editor.getValue();\n\n    if (editorObj.SchemaName == \"\") {\n    \talertify.error(\"Must Provide a schema name\");\n        return;\n    }\n    \n    var newObj = {\n    \tName: editorObj.SchemaName,\n        Properties : []\n    }\n    \n\tfor(var idx=0; idx < editorObj.PropertyList.length; idx++) {\n\t\tvar prop = editorObj.PropertyList[idx];\n       \n\t\tvar newProp = { propName: prop.name, type: prop.type, srcLookup: prop.srcLookup };\n        if (newProp.srcLookup == null) newProp.srcLookup = \"\";\n\n\t\tnewObj.Properties.push(newProp);\n    }\n    \n    if (selId == null) {\n    \tsbv.schemas.insert(newObj);\n\n\t\trefreshSchemas();\n        resetManageEditor();\n        \n\t\talertify.success(\"schema added\");\n\t}\n    else {\n    \tvar oldObj = sbv.schemas.get(parseInt(selId));\n        \n        if (oldObj.Name != newObj.Name) {\n\t\t\talertify.confirm(\"This will rename collection, are you sure?\", function (e) {\n    \t\t\tif (e) {\n    \t\t\t\tvar itemColl = sbv.db.getCollection(schemaName);\n\n\t\t\t\t\titemColl.name = newObj.Name;\n                    itemColl.objType = newObj.Name;\n                    \n                    for(var idx=0; idx < itemColl.data.length; idx++) { \n                    \tvar item = itemColl.data[idx];\n                        \n                        item.objType = newObj.Name;\n                    }\n                    \n                \toldObj.Name = newObj.Name;\n        \t\t\toldObj.Properties = newObj.Properties;\n                    \n        \t\t\t// in case the name changed, refresh list\n\t\t\t\t\trefreshSchemas();\n                    resetManageEditor();\n                    \n              \t\talertify.success(\"schema renamed and updated\");\n                    return;\n    \t\t\t} \n                else { return; }\n\t\t\t});\n        }\n        else\n        {\n        \t// name didnt change, maybe properties did, all are in this one property array\n        \toldObj.Properties = newObj.Properties;\n        \n\t\t\talertify.success(\"schema updated\");\n        }\n    }\n}\n\nfunction deleteSchema() {\n\tvar selId = $(\"#selSchemaManage\").val();\n    if (selId == null) return;\n    \n    var btn = document.getElementById(\"btnDeleteSchema\");\n    document.getElementById(\"deleteSchemaFlyout\").winControl.show(btn);\n}\n\nfunction doDeleteSchema() {\n\tvar selId = $(\"#selSchemaManage\").val();\n    if (selId == null) return;\n    \n    var schema = sbv.schemas.get(parseInt(selId));\n    \n    document.getElementById(\"deleteSchemaFlyout\").winControl.hide();\n    \n\tsbv.schemas.remove(schema);\n\tsbv.db.removeCollection(schema.Name); \n\n    refreshSchemas();\n}\n\nfunction makeTestData() {\n\tsbv.lookups = sbv.db.addCollection('lookups'); \n\tsbv.lookupValues = sbv.db.addCollection('lookupValues'); \n\tsbv.schemas = sbv.db.addCollection('schemas'); \n            \n\tvar lkp1 = sbv.lookups.insert({ name:'PortTypes' });\n\tsbv.lookupValues.insert({ listId: lkp1.$loki, name: 'HDMI' });\n\tsbv.lookupValues.insert({ listId: lkp1.$loki, name: 'HDMI (mini)' });\n\tsbv.lookupValues.insert({ listId: lkp1.$loki, name: 'USB' });\n\tsbv.lookupValues.insert({ listId: lkp1.$loki, name: 'USB (mini)' });\n\tsbv.lookupValues.insert({ listId: lkp1.$loki, name: 'Thunderbolt' });\n            \n\tvar lkp2 = sbv.lookups.insert({ name: \"Tablet Manufacturers\" });\n\tsbv.lookupValues.insert({ listId: lkp2.$loki, name: 'Amazon' });\n\tvar apl = sbv.lookupValues.insert({ listId: lkp2.$loki, name: 'Apple' });\n\tsbv.lookupValues.insert({ listId: lkp2.$loki, name: 'Google' });\n\tvar ms = sbv.lookupValues.insert({ listId: lkp2.$loki, name: 'Microsoft' });\n\tsbv.lookupValues.insert({ listId: lkp2.$loki, name: 'Samsung' });\n\tsbv.lookupValues.insert({ listId: lkp2.$loki, name: 'Sony' });\n            \n\tsbv.schemas.insert({ Name: 'Tablets', Properties: [\n\t\t{ propName: 'Name', type: \"string\", srcLookup: \"\"},   \n\t\t{ propName: 'Manufacturer', type: \"lookup\", srcLookup: \"Tablet Manufacturers\" },\n\t\t{ propName: 'Screen Size', type: \"number\", srcLookup: \"\" },\n\t\t{ propName: 'Release Date', type: \"date\", srcLookup: \"\" },\n\t\t{ propName: 'Notes', type: \"textarea\", srcLookup: \"\" }\n\t]});\n            \n\t// Each schema that the user creates gets its own Loki Collection\n\tvar tablets = sbv.db.addCollection('Tablets');\n\ttablets.insert({ Name: \"IPAD Mini\", Manufacturer: \"Apple\", \"Screen Size\": 7.9, \"Release Date\": \"10/23/2012\", \"Notes\": \"thin...\" });\n\ttablets.insert({ Name: \"Surface RT\", Manufacturer: \"Microsoft\", \"Screen Size\": 10.6, \"Release Date\": \"10/26/2012\", \"Notes\": \"Office 2013; Built-in stand.\" });\n}\n\nfunction initProgram() {\n\n    if (!sandbox.db) {\n        $(\"#btnSave\").hide();\n\t\tmakeTestData();        \n            \n\t\trefreshLookups();\n\t\trefreshSchemas();\n\t\tinitSchemaEditor();\n\t\tresetManageEditor();\n        \n        return;\n    }\n\n\tsandbox.db.GetAppKey('JSON Databank', 'DatabankInfo', function(result) {\n    \tif (result == null || result.id == 0) {\n        \t// Nothing saved yet, initialize a new loki db with single note\n            makeTestData();\n            \n            refreshLookups();\n            refreshSchemas();\n            initSchemaEditor();\n\t\t\tresetManageEditor();\n        }\n        else {\n\t\t\tsbv.db.loadJSON(result.val);\n            sbv.lookups = sbv.db.getCollection(\"lookups\");\n            sbv.lookupValues = sbv.db.getCollection(\"lookupValues\");\n            sbv.schemas = sbv.db.getCollection(\"schemas\");\n            \n            refreshLookups();\n            refreshSchemas();\n            initSchemaEditor();\n\t\t\tresetManageEditor();\n        }\n    });\n}\n\nfunction showItem() {\n\tvar itemId = $(\"#selSchemaItems\").val();\n    \n    if (itemId == null) return;\n    \n\tinitDataEditor();\n    \n    var schemaName = $(\"#selSchemaList\").find(\"option:selected\").text();\n    var itemColl = sbv.db.getCollection(schemaName);\n    var itemObj = itemColl.get(parseInt(itemId));\n\tvar copiedObject = jQuery.extend({},itemObj);\n    delete copiedObject.$loki;\n    delete copiedObject.objType;\n\tsbv.entryEditor.setValue(copiedObject);\n    \n    // override styles imposed by json editor or apply additional functionality\n    //$(\"input[data-schemaformat=date]\").datepicker();\n    $(\"textarea[data-schemaformat=textarea]\").css(\"height\", \"150px\");\n    $(\"#divEditorButtons\").show();\n    $(\"#entry_editor_holder\").css(\"height\", $(\".section3\").height() - 220);\n}\n\nfunction initDataEditor() {\n\tvar schemaId = $(\"#selSchemaList\").val();\n    schemaId = parseInt(schemaId);\n    \n\t$(\"#entry_editor_holder\").empty();\n    \n    var propArray = generateEditorSchema(schemaId);\n    \n    sbv.entryEditor = new JSONEditor(document.getElementById('entry_editor_holder'), {\n        iconlib: \"fontawesome4\",\n        //theme: 'jqueryui',    //jqueryui render looks kind of ugly so just use default\n        disable_properties: true,\n        disable_edit_json : true,\n        disable_collapse: true,\n        \n        schema: {\n        \ttype: \"object\",\n            title: \"Item Entry\",\n            properties: propArray\n        }\n    });\n}\n\nfunction initSchemaEditor() {\n\t$(\"#editor_holder\").empty();\n    \n    // Define Form Schema for OUR reduced 'Schema' implementation\n    // This is a schema for schemas :S\n    sbv.editor = new JSONEditor(document.getElementById('editor_holder'),{\n        iconlib: \"fontawesome4\",\n        disable_properties: true,\n        disable_edit_json : true,\n        disable_collapse: true,\n        //theme: 'jqueryui',    //jqueryui render looks kind of ugly so just use default\n        schema: {\n            type: \"object\",\n            title: \"Schema Properties\",\n            properties: {\n                SchemaName: {\n                    title: \"Name\",\n                    type: \"string\"\n                },\n                PropertyList: {\n                    type: \"array\",\n                    format: \"table\",\n                    title: \"Properties\",\n                    uniqueItems: true,\n                    items : {\n                        type: \"object\",\n                        properties: {\n                            \"name\": {\n                            \ttitle: \"Name\",\n                                type: \"string\",\n                            },\n                            \"type\": {\n                            \ttitle: \"Type\",\n                                type: \"string\",\n                                enum: [\"string\", \"textarea\", \"int\", \"number\", \"boolean\", \"date\", \"lookup\"],\n                                default: \"String\"\n                            },\n                            \"srcLookup\": {\n                            \ttitle: \"SrcLookup\",\n                                type: \"string\",\n                                enum: getLookupLists()\n                            }\n                        }\n                    }\n                }\n            }\n        }\n    });\n}\n\n//\n// I/O ROUTINES\n//\nfunction saveTrident() {\n\tvar result = JSON.stringify(sbv.db);\n            \n    sandbox.db.SetAppKey('JSON Databank', \"DatabankInfo\", result, function(e) {\n\t\tif (e.success) alertify.success(\"Databank Saved\");\n        else alertify.error(\"Error encountered during save\");\n\t});\n}\n\nfunction exportDatabank() {\n\tsbv.appBar.hide();\n    \n    sandbox.ui.fullscreenExit();\n    \n\tvar result = JSON.stringify(sbv.db);\n    \n    sandbox.files.saveTextFile(\"MyDatabank.jdb\", result);\n}\n\nfunction importDatabank() {\n\tsbv.appBar.hide();\n\tsandbox.files.userfileShow();\n    $(\"#sb_user_file\").click();\n}\n\nsandbox.events.userLoadCallback = function (filestring, filename) {\n\tsandbox.files.userfileHide();\n    \n\tsbv.db.loadJSON(filestring);\n\n\t// we rehydrated loki db object and collections but old collection references still\n\t// point to old db object. \n\tsbv.lookups = sbv.db.getCollection(\"lookups\");\n\tsbv.lookupValues = sbv.db.getCollection(\"lookupValues\");\n\tsbv.schemas = sbv.db.getCollection(\"schemas\");\n            \n\trefreshLookups();\n\trefreshSchemas();\n\tinitSchemaEditor();\n\tresetManageEditor();\n};\n\nWinJS.UI.Pages.define(location.href, {\n    ready: function (element, options) {\n\t},\n    \n    unload: function () {\n        // TODO: Respond to navigations away from this page.\n    }\n});\n\nfunction doFullscreen() {\n\tsandbox.ui.fullscreenToggle();\n}\n\nWinJS.UI.processAll().then(function () {\n    sbv.appBar = document.getElementById(\"createAppBar\").winControl;\n\n    sbv.appBar.getCommandById(\"cmdSave\").addEventListener(\"click\", saveTrident, false);\n    sbv.appBar.getCommandById(\"cmdImport\").addEventListener(\"click\", importDatabank, false);\n    sbv.appBar.getCommandById(\"cmdExport\").addEventListener(\"click\", exportDatabank, false);\n    sbv.appBar.getCommandById(\"cmdFullscreen\").addEventListener(\"click\", doFullscreen, false);\n    \n    if (!sandbox.db) sbv.appBar.hideCommands([\"cmdSave\"]);\n    \n\tinitProgram();\n\n\t$(\"#divMainFS\").show();\n});\n"
}