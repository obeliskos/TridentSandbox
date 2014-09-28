{
  "progName": "JSON Databank",
  "htmlText": "<ul class=\"tnavlist\">\n<li class=\"tnavli\"><a class=\"tnava\" onclick=\"showDiv(1);\" href=\"javascript:void(0)\"><i class=\"fa fa-pencil\"></i> Entry</a></li>\n<li class=\"tnavli\"><a class=\"tnava\" onclick=\"showDiv(2);\" href=\"javascript:void(0)\"><i class=\"fa fa-puzzle-piece\"></i> Schemas</a></li>\n<li class=\"tnavli\"><a class=\"tnava\" onclick=\"showDiv(3);\" href=\"javascript:void(0)\"><i class=\"fa fa-list\"></i> Lookups</a></li>\n<li class=\"tnavli\"><a class=\"tnava\" onclick=\"showDiv(4);\" href=\"javascript:void(0)\"><i class=\"fa fa-info-circle\"></i> About</a></li>\n</ul>\n\n<br/>\n<table style='width:100%;background-color:#aaa'>\n\t<tr style='background-color:#aaa'>\n\t\t<td>\n\t\t\t<div id='divDbActions' style='display:inline; width:100%'>\n\t\t\t\t<button style=\"height:34px\" id='btnSave' title='Save to Trident DB' onclick='saveTrident()'><i class=\"fa fa-floppy-o\"></i> Save TDB</button>&nbsp;\n\t\t\t\t<button style=\"height:34px\" title='Export / Save Locally' onclick='exportDatabank()'><i class=\"fa fa-download\"></i> Export</button>&nbsp;\n\t\t\t\t<button style=\"height:34px\" title='Import / Load Local File' onclick='importDatabank()'><i class=\"fa fa-arrow-up\"></i> Import</button>\n                <label id=\"lblPageName\" style=\"float:right; font-size:20px; margin-top:5px\">Item Entry</label>\n\t\t\t</div>\n\t\t</td>\n\t</tr>\n</table>\n\n<div id=\"divMain\">\n<br/>\n<table width=\"100%\">\n  <tr valign=\"top\">\n    <td align=\"center\" style=\"width:220px; height:100px\">\n    \t<label style=\"font-size:20px\"><b>Schemas</b></label><br/>\n    \t<select size=\"7\" id=\"selSchemaList\" onclick=\"refreshSchemaItems()\" style=\"width:100%; font-size:20px\"></select>\n        <button class=\"minimal\" onclick=\"addEditorItem()\"><i class=\"fa fa-plus\"></i> Add Item</button>\n    </td>\n    <td rowspan=\"2\">\n    \t<div style=\"margin-left:10px\" id='entry_editor_holder'></div>\n        <div id=\"divEditorButtons\" style=\"margin-left:20px; display:none\">\n        \t<button class=\"minimal\" onclick=\"saveEditorItem()\"><i class=\"fa fa-save\"></i> Save</button>\n        </div>\n\t</td>\n  </tr>\n  <tr>\n    <td align=\"center\" style=\"width:140px\">\n    \t<br/>\n    \t<label style=\"font-size:20px\"><b>Items</b></label><br/>\n    \t<select size=\"10\" id=\"selSchemaItems\" onclick=\"showItem()\" style=\"width:100%; font-size:20px\"></select>\n       \t<button class=\"minimal\" onclick=\"delEditorItem()\"><i class=\"fa fa-trash-o\"></i> Delete</button>\n\t</td>\n  </tr>\n</table>\n</div>\n\n<div id=\"divSchemas\" style=\"display:none\">\n\n<table width=\"100%\">\n<tr valign=\"top\">\n\t<td>\n    \t<h3>Schemas</h3>\n    \t<select id=\"selSchemaManage\" style=\"width:100%; font-size:20px;\" size=\"14\" onclick=\"manageSchemaChange()\"></select>\n        <br/>\n        <button class=\"minimal\" onclick=\"deleteSchema()\"><i class=\"fa fa-trash-o\"></i> Delete</button>\n\t</td>\n    <td>\n        <div style=\"margin-left:10px\" id='editor_holder'></div>\n\t\t<ul>\n\t\t\t<li><i>All Schemas <b>must have</b> a <b>Name</b> property</i></li>\n\t\t\t<li><i>Schemas <b>should not</b> have an <b>id</b> property</i></li>\n\t\t\t<li><i>Schemas <b>should not</b> have an <b>objType</b> property</i></li>\n\t\t</ul>\n\n        <div style=\"margin-left:100px\">\n        \t<button class=\"minimal\" onclick=\"newSchema()\"><i class=\"fa fa-plus\"></i> New</button>\n        \t<button class=\"minimal\" onclick=\"saveSchema()\"><i class=\"fa fa-save\"></i> Save</button>\n        </div>\n    </td>\n</tr>\n\n</table>\n\n</div>\n\n<div id=\"divLookups\" style=\"display:none\">\n<br/>\n<table width=\"100%\">\n<tr>\n\t<th>Lookups</th>\n\t<th>Lookup Values</th>\n</tr>\n<tr>\n\t<td><select size=\"14\" id=\"selLookups\" onclick=\"refreshLookupValues()\" style=\"width:100%; font-size:20px;\"></select></td>\n\t<td><select size=\"14\" id=\"selLookupVals\" style=\"width:100%; font-size:20px;\"></select></td>\n</tr>\n<tr>\n\t<td align='center'>\n    \t<button class=\"minimal\" onclick=\"addLookup()\" style=\"width:120px\"><i class=\"fa fa-plus\"></i> Add</button> \n        <button class=\"minimal\" onclick=\"editLookup()\" style=\"width:120px\"><i class=\"fa fa-pencil\"></i> Edit</button> \n        <button class=\"minimal\" onclick=\"delLookup()\" style=\"width:120px\"><i class=\"fa fa-trash-o\"></i> Delete</button>\n\t</td>\n    <td align='center'>\n    \t<button class=\"minimal\" onclick=\"addLookupValue()\" style=\"width:120px\"><i class=\"fa fa-plus\"></i> Add</button> \n        <button class=\"minimal\" onclick=\"editLookupValue()\" style=\"width:120px\"><i class=\"fa fa-pencil\"></i> Edit</button> \n        <button class=\"minimal\" onclick=\"delLookupValue()\" style=\"width:120px\"><i class=\"fa fa-trash-o\"></i> Delete</button>\n\t</td>\n</tr>\n</table>\n</div>\n\n<div id=\"divAbout\" style=\"display:none\">\n<h3>About JSON Databank</h3>\n<p>This is a data-filer type application that let's you define the structure of \nnon-hierarchical json objects (in a way similar to flat-file type tables), set up lookup lists, and enter/view data in those tables.&nbsp; \nIt uses loki.js to store json objects whose structure is defined dynamically.&nbsp; Json-Editor.js \nis used for generating dynamic forms for data entry as well as for schema definition.</p>\n<p>The Json Editor control adheres to a more complete version of Json Schema standard.&nbsp; This \napplication simplifies and reduces it to basic datatypes you see implemented and then stores \nthat simplified schema in a loki schemas collection.&nbsp; This collection is later used to \nrecreate the schema for data entry.</p>\n<p>Currently, the 'lookup' type is single select only.  Possibly in the future i will allow multiselect \nlookups.  The 'date' type is not fully supported in IE so it will just be a regular text box.</p>\n\n</p>\n</div>",
  "scriptText": "var sbv = {\n\teditor : null,\n    entryEditor: null,\n    db: new loki('JSON Databank'),\n    lookups: null,\n    lookupValues : null,\n    schemas: null\n}\n\nfunction EVT_CleanSandbox()\n{\n\tif (sbv.editor) sbv.editor.destroy();\n    if (sbv.entryEditor) sbv.entryEditor.destroy();\n    \n    delete sbv.lookups;\n    delete sbv.lookupValues;\n    delete sbv.schemas;\n\tdelete sbv.db;\n    delete sbv.editor;\n    delete sbv.entryEditor;\n    \n\tsbv = null;\n    EVT_CleanSandbox = null;\n}\n\nfunction showDiv(divIndex) {\n\t$(\"#divMain\").hide();\n\t$(\"#divSchemas\").hide();\n\t$(\"#divLookups\").hide();\n\t$(\"#divAbout\").hide();\n\n\tswitch(divIndex) {\n        case 1: $(\"#divMain\").show(); $(\"#lblPageName\").text(\"Item Entry\"); break;\n        case 2: $(\"#divSchemas\").show(); $(\"#lblPageName\").text(\"Manage Schemas\"); break;\n        case 3: $(\"#divLookups\").show(); $(\"#lblPageName\").text(\"Manage Lookups\"); break;\n        case 4: $(\"#divAbout\").show(); $(\"#lblPageName\").text(\"About\"); break;\n    }\n}\n\n//\n// UI LOAD/REFRESH FUNCTIONS\t\n//\n\n// updates select list for display/management of schemas\nfunction refreshSchemas() {\n\t$(\"#selSchemaManage\").html(\"\");\n\t$(\"#selSchemaList\").html(\"\");\n\n\tfor (var idx=0; idx < sbv.schemas.data.length; idx++) {\n\t\t$(\"#selSchemaManage\")\n\t\t\t.append($('<option>', { value : sbv.schemas.data[idx].id })\n\t\t\t.text(sbv.schemas.data[idx].Name)); \n\t\t$(\"#selSchemaList\")\n\t\t\t.append($('<option>', { value : sbv.schemas.data[idx].id })\n\t\t\t.text(sbv.schemas.data[idx].Name)); \n    }\n\n\t$('#selSchemaList option:first-child').attr(\"selected\", \"selected\");\n    refreshSchemaItems();\n    \n    $(\"#selSchemaItems\").focus();\n    $(\"#selSchemaList\").focus();\n}\n\n// Establishing a convention that all items need Name property,\n// which is what we will display in this list\nfunction refreshSchemaItems() {\n\t$(\"#selSchemaItems\").html(\"\");\n    \n\tvar schemaId = $(\"#selSchemaList\").val();\n    \n    if (schemaId == null) return;\n    \n    var schemaName = $(\"#selSchemaList\").find(\"option:selected\").text();\n\n\t// if dynamic collection hasn't been created yet then just exit with empty list\n\tvar schemaItems = null;\n    try {\n    \tschemaItems = sbv.db.getCollection(schemaName);\n    }\n    catch (err) { return; };\n    \n    for(var idx=0; idx < schemaItems.data.length; idx++) {\n\t\t$(\"#selSchemaItems\")\n\t\t\t.append($('<option>', { value : schemaItems.data[idx].id })\n\t\t\t.text(schemaItems.data[idx].Name));\n    }\n}\n\n// updates select list for display/management of lookups\nfunction refreshLookups() {\n\t$(\"#selLookups\").html(\"\");\n    \n\tfor(var idx=0; idx < sbv.lookups.data.length; idx++) {\n\t\t$(\"#selLookups\")\n\t\t\t.append($('<option>', { value : sbv.lookups.data[idx].id })\n\t\t\t.text(sbv.lookups.data[idx].name)); \n    }\n}\n\n// updates select list for display/management of values\nfunction refreshLookupValues() {\n\tvar lkpId = $(\"#selLookups\").val();\n    var lkpVals = sbv.lookupValues.find({ 'listId': { '$eq' : parseInt(lkpId) }});\n    \n\t$(\"#selLookupVals\").html(\"\");\n    \n\tfor(var idx=0; idx < lkpVals.length; idx++) {\n\t\t$(\"#selLookupVals\")\n\t\t\t.append($('<option>', { value : lkpVals[idx].id })\n\t\t\t.text(lkpVals[idx].name)); \n    }\n}\n\n//\n// LOOKUP MAINTENANCE\n//\n\nfunction addLookup() {\n\talertify.prompt(\"Enter Lookup Name\", function (e, str) {\n\t\tif (e) {\n\t\t\tsbv.lookups.insert({ name: str });\n            refreshLookups();\n            initSchemaEditor();\n\t\t} \n\t}, \"MyLookup\");\n}\n\nfunction editLookup() {\n\tvar lkpId = $(\"#selLookups\").val();\n    var lkpText = $(\"#selLookups\").find(\"option:selected\").text();\n    var lkp = sbv.lookups.get(parseInt(lkpId));\n    \n\talertify.prompt(\"Set Lookup Name\", function (e, str) {\n\t\tif (e) {\n\t\t\tlkp.name = str;\n            refreshLookups();\n            initSchemaEditor();\n\t\t} \n\t}, lkpText);\n}\n\nfunction delLookup() {\n\tvar lkpId = $(\"#selLookups\").val();\n    var lkpText = $(\"#selLookups\").find(\"option:selected\").text();\n    var lkp = sbv.lookups.get(parseInt(lkpId));\n\n\talertify.confirm(\"Delete \" + lkpText, function (e) {\n\t\tif (e) {\n        \t//remove values first\n    \t\tvar lkpVals = sbv.lookupValues.find({ 'listId': { '$eq' : parseInt(lkpId) }});\n \t\t\tfor(var idx=0; idx < lkpVals.length; idx++) {\n            \tsbv.lookupValues.remove(lkpVals[idx]);\n            }\n           \n\t\t\tsbv.lookups.remove(lkp);\n            refreshLookups();\n            initSchemaEditor();\n\t\t} \n\t});\n}\n\nfunction addLookupValue() {\n\tvar lkpId = $(\"#selLookups\").val();\n\talertify.prompt(\"Enter Lookup Value\", function (e, str) {\n\t\tif (e) {\n\t\t\tsbv.lookupValues.insert({ listId: parseInt(lkpId), name: str });\n            refreshLookupValues();\n\t\t} \n\t}, \"MyLookupValue\");\n}\n\nfunction editLookupValue() {\n\tvar valId = $(\"#selLookupVals\").val();\n    var valText = $(\"#selLookupVals\").find(\"option:selected\").text();\n    var val = sbv.lookupValues.get(parseInt(valId));\n    \n\talertify.prompt(\"Edit Lookup Value\", function (e, str) {\n\t\tif (e) {\n\t\t\tval.name = str;\n            refreshLookupValues();\n\t\t} \n\t}, valText);\n}\n\nfunction delLookupValue() {\n\tvar valId = $(\"#selLookupVals\").val();\n    var valText = $(\"#selLookupVals\").find(\"option:selected\").text();\n    var val = sbv.lookupValues.get(parseInt(valId));\n\n\talertify.confirm(\"Delete \" + valText, function (e) {\n\t\tif (e) {\n\t\t\tsbv.lookupValues.remove(val);\n            refreshLookupValues();\n\t\t} \n\t});\n}\n\n// returns array for placement into entry editor object reference\nfunction getLookupValues(lkpName) {\n\tvar lkp = sbv.lookups.find({ 'name': { '$eq' : lkpName }});\n    var valObjs = sbv.lookupValues.find({ 'listId': { '$eq' : lkp[0].id }});\n\tvar vals = [\"\"];\n    \n    for(var idx=0; idx < valObjs.length; idx++) {\n    \tvals.push(valObjs[idx].name);\n    }\n    \n    return vals;\n}\n\n// returns array for placement into schema def obj reference\nfunction getLookupLists() {\n\tvar listNames = [\"\"];\n    \n\tfor(var idx=0; idx < sbv.lookups.data.length; idx++) {\n    \tlistNames.push(sbv.lookups.data[idx].name);\t\n    }\n    \n    return listNames;\n}\n\nfunction generateEditorSchema(schemaId) {\n    var schema = sbv.schemas.get(schemaId);\n    var propertiesObject = {};\n    for(var idx=0; idx < schema.Properties.length; idx++) {\n    \tvar prop = schema.Properties[idx];\n        \n        if (prop.srcLookup != \"\") {\n        \tvar propAttrs = { type: \"string\", enum: getLookupValues(prop.srcLookup) };\n        \tpropertiesObject[prop.propName] = propAttrs;\n        }\n        else {\n        \tif (prop.type == \"date\") {\n        \t\tvar propAttrs = { type: \"string\", format: \"date\" };\n        \t\tpropertiesObject[prop.propName] = propAttrs;\n            }\n            else {\n            \tif (prop.type == \"textarea\") {\n        \t\t\tvar propAttrs = { type: \"string\", format: \"textarea\", rows: \"5\" };\n        \t\t\tpropertiesObject[prop.propName] = propAttrs;\n                }\n                else {\n        \t\t\tvar propAttrs = { type: prop.type };\n        \t\t\tpropertiesObject[prop.propName] = propAttrs;\n                }\n            }\n\t\t}\n    }\n    \n   \treturn propertiesObject;\n}\n\nfunction addEditorItem() {\n\tvar itemId = $(\"#selSchemaList\").val();\n    \n    if (itemId == null) return;\n    \n\tinitDataEditor();\n    \n    $(\"#selSchemaItems\").val([]);\n    \n    // override styles imposed by json editor or apply additional functionality\n    //$(\"input[data-schemaformat=date]\").datepicker();\n    $(\"textarea[data-schemaformat=textarea]\").css(\"height\", \"150px\");\n    $(\"#divEditorButtons\").show();\n\n}\n\nfunction saveEditorItem() {\n    var selItem = $(\"#selSchemaItems\").val();\n    var selSchema = $(\"#selSchemaList\").val();\n   \tvar schemaName = $(\"#selSchemaList\").find(\"option:selected\").text();\n    //var schemaItems = sbv.db.getCollection(schemaName);\n    var schemaRec = sbv.schemas.get(parseInt(selSchema));\n    \n    // If dynamic collection doesn't exist yet (this is first item), create it\n    var schemaItems = null;\n    try {\n    \tschemaItems = sbv.db.getCollection(schemaName);\n    }\n    catch (err) {\n    \tschemaItems = sbv.db.addCollection(schemaName, schemaName);\n    };\n    \n    if (selItem == null) {\n    \tvar newObj = sbv.entryEditor.getValue();\n        \n    \tschemaItems.insert(newObj);\n\n\t\trefreshSchemaItems();\n        addEditorItem();\n    \talertify.success(\"added\");\n\t}\n    else {\n    \tvar oldObj = schemaItems.get(parseInt(selItem));\n    \tvar newObj = sbv.entryEditor.getValue();\n        \n        for (var idx=0; idx < schemaRec.Properties.length; idx++) {\n        \tvar propName = schemaRec.Properties[idx].propName;\n            \n\t\t\toldObj[propName] = newObj[propName];\n        }\n        \n        // in case they changed the 'name' property, item list would change\n\t\trefreshSchemaItems();\n        addEditorItem();\n    \talertify.log(\"updated\");\n\t}\n\n}\n\nfunction delEditorItem() {\n    var selItem = $(\"#selSchemaItems\").val();\n   \tvar schemaName = $(\"#selSchemaList\").find(\"option:selected\").text();\n    var schemaItems = sbv.db.getCollection(schemaName);\n    var oldObj = schemaItems.get(parseInt(selItem));\n\n\tschemaItems.remove(oldObj);\n\n\t// If no more items in dynamic collection, remove the collection but keep its schema\n    // This is necessary due to loki.js persistence bug with empty collections.\n    if (schemaItems.data.length == 0) {\n    \tsbv.db.removeCollection(schemaName);\n    }\n    \n\trefreshSchemaItems();\n    \n\talertify.log(\"deleted\");\n}\n\n// when user changes the selected schema in shema manage screen, this displays contents\nfunction manageSchemaChange() {\n\tresetManageEditor();\n    \n\tvar selId = $(\"#selSchemaManage\").val();\n    var schema = sbv.schemas.get(parseInt(selId));\n    \n    var propertiesArray = [];\n    for(var idx=0; idx < schema.Properties.length; idx++) {\n    \tvar prop = schema.Properties[idx];\n        \n        if (prop.srcLookup != \"\") {\n        \tvar propObj = { name: prop.propName, type: prop.type, srcLookup: prop.srcLookup };\n        \tpropertiesArray.push(propObj);\n        }\n        else {\n\t\t\tvar propObj = { name: prop.propName, type: prop.type };\n\t\t\tpropertiesArray.push(propObj);\n\t\t}\n    }\n    \n    var editorObj = \n\t{ \n    \tSchemaName: schema.Name,\n        PropertyList: propertiesArray\n\t}\n    \n\tsbv.editor.setValue(editorObj);\n\n}\n\nfunction resetManageEditor() {\n\tvar editorObj = \n    { \n    \tSchemaName: \"\", \n        PropertyList: [\n        {\n        \tname: \"Name\",\n            type: \"string\",\n            srcLookup: \"\"\n        }\n        ] \n    }\n    \n\tsbv.editor.setValue(editorObj);\n}\n\nfunction newSchema()\n{\n\t$(\"#selSchemaManage\").val([]);\n\n\tresetManageEditor();\n}\n\nfunction saveSchema() \n{\n\tvar selId = $(\"#selSchemaManage\").val();\n\tvar schemaName = $(\"#selSchemaManage\").find(\"option:selected\").text();\n    \n\tvar editorObj = sbv.editor.getValue();\n\n    if (editorObj.SchemaName == \"\") {\n    \talertify.error(\"Must Provide a schema name\");\n        return;\n    }\n    \n    var newObj = {\n    \tName: editorObj.SchemaName,\n        Properties : []\n    }\n    \n\tfor(var idx=0; idx < editorObj.PropertyList.length; idx++) {\n\t\tvar prop = editorObj.PropertyList[idx];\n       \n\t\tvar newProp = { propName: prop.name, type: prop.type, srcLookup: prop.srcLookup };\n        if (newProp.srcLookup == null) newProp.srcLookup = \"\";\n\n\t\tnewObj.Properties.push(newProp);\n    }\n    \n    if (selId == null) {\n    \tsbv.schemas.insert(newObj);\n\n\t\trefreshSchemas();\n        resetManageEditor();\n        \n\t\talertify.success(\"schema added\");\n\t}\n    else {\n    \tvar oldObj = sbv.schemas.get(parseInt(selId));\n        \n        if (oldObj.Name != newObj.Name) {\n\t\t\talertify.confirm(\"This will rename collection, are you sure?\", function (e) {\n    \t\t\tif (e) {\n    \t\t\t\tvar itemColl = sbv.db.getCollection(schemaName);\n\n\t\t\t\t\titemColl.name = newObj.Name;\n                    itemColl.objType = newObj.Name;\n                    \n                    for(var idx=0; idx < itemColl.data.length; idx++) { \n                    \tvar item = itemColl.data[idx];\n                        \n                        item.objType = newObj.Name;\n                    }\n                    \n                \toldObj.Name = newObj.Name;\n        \t\t\toldObj.Properties = newObj.Properties;\n                    \n        \t\t\t// in case the name changed, refresh list\n\t\t\t\t\trefreshSchemas();\n                    resetManageEditor();\n                    \n              \t\talertify.success(\"schema renamed and updated\");\n                    return;\n    \t\t\t} \n                else { return; }\n\t\t\t});\n        }\n        else\n        {\n        \t// name didnt change, maybe properties did, all are in this one property array\n        \toldObj.Properties = newObj.Properties;\n        \n\t\t\talertify.success(\"schema updated\");\n        }\n    }\n}\n\nfunction deleteSchema() {\n\tvar selId = $(\"#selSchemaManage\").val();\n    if (selId == null) return;\n    \n    var schema = sbv.schemas.get(parseInt(selId));\n    \n\talertify.confirm(\"Delete schema \" + schema.Name + \"?\", function (e) {\n\t\tif (e) {\n\t\t\tsbv.schemas.remove(schema);\n\t\t\tsbv.db.removeCollection(schema.Name); \n\n\t\t\talertify.success(\"deleted\");\n            refreshSchemas();\n\t\t}\n\t});\n    \n}\n\nfunction makeTestData() {\n\tsbv.lookups = sbv.db.addCollection('lookups', 'lookups'); \n\tsbv.lookupValues = sbv.db.addCollection('lookupValues', 'lookupValues'); \n\tsbv.schemas = sbv.db.addCollection('schemas', 'schemas'); \n            \n\tvar lkp1 = sbv.lookups.insert({ name:'PortTypes' });\n\tsbv.lookupValues.insert({ listId: lkp1.id, name: 'HDMI' });\n\tsbv.lookupValues.insert({ listId: lkp1.id, name: 'HDMI (mini)' });\n\tsbv.lookupValues.insert({ listId: lkp1.id, name: 'USB' });\n\tsbv.lookupValues.insert({ listId: lkp1.id, name: 'USB (mini)' });\n\tsbv.lookupValues.insert({ listId: lkp1.id, name: 'Thunderbolt' });\n            \n\tvar lkp2 = sbv.lookups.insert({ name: \"Tablet Manufacturers\" });\n\tsbv.lookupValues.insert({ listId: lkp2.id, name: 'Amazon' });\n\tvar apl = sbv.lookupValues.insert({ listId: lkp2.id, name: 'Apple' });\n\tsbv.lookupValues.insert({ listId: lkp2.id, name: 'Google' });\n\tvar ms = sbv.lookupValues.insert({ listId: lkp2.id, name: 'Microsoft' });\n\tsbv.lookupValues.insert({ listId: lkp2.id, name: 'Samsung' });\n\tsbv.lookupValues.insert({ listId: lkp2.id, name: 'Sony' });\n            \n\tsbv.schemas.insert({ Name: 'Tablets', Properties: [\n\t\t{ propName: 'Name', type: \"string\", srcLookup: \"\"},   \n\t\t{ propName: 'Manufacturer', type: \"lookup\", srcLookup: \"Tablet Manufacturers\" },\n\t\t{ propName: 'Screen Size', type: \"number\", srcLookup: \"\" },\n\t\t{ propName: 'Release Date', type: \"date\", srcLookup: \"\" },\n\t\t{ propName: 'Notes', type: \"textarea\", srcLookup: \"\" }\n\t]});\n            \n\t// Each schema that the user creates gets its own Loki Collection\n\tvar tablets = sbv.db.addCollection('Tablets', 'Tablets');\n\ttablets.insert({ Name: \"IPAD Mini\", Manufacturer: \"Apple\", \"Screen Size\": 7.9, \"Release Date\": \"10/23/2012\", \"Notes\": \"thin...\" });\n\ttablets.insert({ Name: \"Surface RT\", Manufacturer: \"Microsoft\", \"Screen Size\": 10.6, \"Release Date\": \"10/26/2012\", \"Notes\": \"Office 2013; Built-in stand.\" });\n}\n\nfunction initProgram() {\n\n    if (!window.indexedDB) {\n        $(\"#btnSave\").hide();\n\t\tmakeTestData();        \n            \n\t\trefreshLookups();\n\t\trefreshSchemas();\n\t\tinitSchemaEditor();\n\t\tresetManageEditor();\n        \n        return;\n    }\n\n\tVAR_TRIDENT_API.GetAppKey('JSON Databank', 'DatabankInfo', function(result) {\n    \tif (result == null || result.id == 0) {\n        \t// Nothing saved yet, initialize a new loki db with single note\n            makeTestData();\n            \n            refreshLookups();\n            refreshSchemas();\n            initSchemaEditor();\n\t\t\tresetManageEditor();\n        }\n        else {\n\t\t\tsbv.db.loadJSON(result.val);\n            sbv.lookups = sbv.db.getCollection(\"lookups\");\n            sbv.lookupValues = sbv.db.getCollection(\"lookupValues\");\n            sbv.schemas = sbv.db.getCollection(\"schemas\");\n            \n            refreshLookups();\n            refreshSchemas();\n            initSchemaEditor();\n\t\t\tresetManageEditor();\n        }\n    });\n}\n\ninitProgram();\n\nfunction showItem() {\n\tvar itemId = $(\"#selSchemaItems\").val();\n    \n    if (itemId == null) return;\n    \n\tinitDataEditor();\n    \n    var schemaName = $(\"#selSchemaList\").find(\"option:selected\").text();\n    var itemColl = sbv.db.getCollection(schemaName);\n    var itemObj = itemColl.get(parseInt(itemId));\n\tvar copiedObject = jQuery.extend({},itemObj);\n    delete copiedObject.id;\n    delete copiedObject.objType;\n\tsbv.entryEditor.setValue(copiedObject);\n    \n    // override styles imposed by json editor or apply additional functionality\n    //$(\"input[data-schemaformat=date]\").datepicker();\n    $(\"textarea[data-schemaformat=textarea]\").css(\"height\", \"150px\");\n    $(\"#divEditorButtons\").show();\n}\n\nfunction initDataEditor() {\n\tvar schemaId = $(\"#selSchemaList\").val();\n    schemaId = parseInt(schemaId);\n    \n\t$(\"#entry_editor_holder\").empty();\n    \n    var propArray = generateEditorSchema(schemaId);\n    \n    sbv.entryEditor = new JSONEditor(document.getElementById('entry_editor_holder'), {\n        iconlib: \"fontawesome4\",\n        //theme: 'jqueryui',    //jqueryui render looks kind of ugly so just use default\n        disable_properties: true,\n        disable_edit_json : true,\n        disable_collapse: true,\n        \n        schema: {\n        \ttype: \"object\",\n            title: \"Item Entry\",\n            properties: propArray\n        }\n    });\n}\n\nfunction initSchemaEditor() {\n\t$(\"#editor_holder\").empty();\n    \n    // Define Form Schema for OUR reduced 'Schema' implementation\n    // This is a schema for schemas :S\n    sbv.editor = new JSONEditor(document.getElementById('editor_holder'),{\n        iconlib: \"fontawesome4\",\n        disable_properties: true,\n        disable_edit_json : true,\n        disable_collapse: true,\n        //theme: 'jqueryui',    //jqueryui render looks kind of ugly so just use default\n        schema: {\n            type: \"object\",\n            title: \"Schema Properties\",\n            properties: {\n                SchemaName: {\n                    title: \"Name\",\n                    type: \"string\"\n                },\n                PropertyList: {\n                    type: \"array\",\n                    format: \"table\",\n                    title: \"Properties\",\n                    uniqueItems: true,\n                    items : {\n                        type: \"object\",\n                        properties: {\n                            \"name\": {\n                            \ttitle: \"Name\",\n                                type: \"string\",\n                            },\n                            \"type\": {\n                            \ttitle: \"Type\",\n                                type: \"string\",\n                                enum: [\"string\", \"textarea\", \"int\", \"number\", \"boolean\", \"date\", \"lookup\"],\n                                default: \"String\"\n                            },\n                            \"srcLookup\": {\n                            \ttitle: \"SrcLookup\",\n                                type: \"string\",\n                                enum: getLookupLists()\n                            }\n                        }\n                    }\n                }\n            }\n        }\n    });\n}\n\n//\n// I/O ROUTINES\n//\nfunction saveTrident() {\n\tvar result = JSON.stringify(sbv.db);\n            \n    VAR_TRIDENT_API.SetAppKey('JSON Databank', \"DatabankInfo\", result, function(e) {\n\t\tif (e.success) alertify.success(\"Databank Saved\");\n        else alertify.error(\"Error encountered during save\");\n\t});\n    \n    \n}\n\nfunction exportDatabank() {\n\tvar result = JSON.stringify(sbv.db);\n    \n    API_SaveTextFile(\"MyDatabank.jdb\", result);\n}\n\nfunction importDatabank() {\n\tAPI_ShowLoad();\n}\n\nfunction EVT_UserLoadCallback(filestring, filename) {\n\tAPI_HideUserLoader();\n    \n\tsbv.db.loadJSON(filestring);\n\n\t// we rehydrated loki db object and collections but old collection references still\n\t// point to old db object. \n\tsbv.lookups = sbv.db.getCollection(\"lookups\");\n\tsbv.lookupValues = sbv.db.getCollection(\"lookupValues\");\n\tsbv.schemas = sbv.db.getCollection(\"schemas\");\n            \n\trefreshLookups();\n\trefreshSchemas();\n\tinitSchemaEditor();\n\tresetManageEditor();\n}"
}