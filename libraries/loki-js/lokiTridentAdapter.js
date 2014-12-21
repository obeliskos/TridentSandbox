/**
 * TridentAdapter - Loki persistence adapter class for indexedDb.
 *     This class fulfills abstract adapter interface which can be applied to other storage methods
 *     Utilizes the included LokiCatalog app/key/value database for actual database persistence.
 *
 * @param {string} appname - Application name context can be used to distinguish subdomains or just 'loki'
 */
function TridentAdapter(appname)
{
  this.app = 'loki';
  
  if (typeof (appname) !== 'undefined') 
  {
    this.app = appname;
  }

  // keep reference to catalog class for base AKV operations
  this.catalog = null;
}

/**
 * loadDatabase() - Retrieves a serialized db string from the catalog.
 *
 * @param {string} dbname - the name of the database to retrieve.
 * @param {function} callback - callback should accept string param containing serialized db string.
 */
TridentAdapter.prototype.loadDatabase = function(dbname, callback)
{
  var appName = this.app;
  
  // Using functions / variables defined in main page, should probably clean up later
  VAR_TRIDENT_API.GetAppKey(appName, dbname, function(result) {
    if (typeof (callback) === 'function') {
      if (result.id === 0) {
        console.warn("trident adapter could not find database");
        callback(null);
        return;
      }
      callback(result.val);
    }
    else {
      // support console use of api
      console.log(result.val);
    }
  });
}

/**
 * saveDatabase() - Saves a serialized db to the catalog.
 *
 * @param {string} dbname - the name to give the serialized database within the catalog.
 * @param {string} dbstring - the serialized db string to save.
 * @param {function} callback - (Optional) callback passed obj.success with true or false
 */
TridentAdapter.prototype.saveDatabase = function(dbname, dbstring, callback)
{
  var appName = this.app;
  
  // set (add/update) entry to AKV database
  VAR_TRIDENT_API.SetAppKey(appName, dbname, dbstring, callback);
}

/**
 * deleteDatabase() - Deletes a serialized db from the catalog.
 *
 * @param {string} dbname - the name of the database to delete from the catalog.
 */
TridentAdapter.prototype.deleteDatabase = function(dbname)
{
  var appName = this.app;
  
  // catalog was already initialized, so just lookup object and delete by id
  VAR_TRIDENT_API.GetAppKey(appName, dbname, function(result) {
    var id = result.id;
    
    if (id !== 0) {
      VAR_TRIDENT_API.DeleteAppKey(id);
    }
  });
}

/**
 * getDatabaseList() - Retrieves object array of catalog entries for current app.
 *
 * @param {function} callback - should accept array of database names in the catalog for current app.
 */
TridentAdapter.prototype.getDatabaseList = function(callback)
{
  var appName = this.app;
  
  // catalog already initialized
  // get all keys for current appName, and transpose results so just string array
  VAR_TRIDENT_API.GetAppKeys(appName, function(results) {
    var names = [];
    
    for(var idx = 0; idx < results.length; idx++) {
      names.push(results[idx].key);
    }
    
    if (typeof (callback) === 'function') {
      callback(names);
    }
    else {
      names.forEach(function(obj) {
        console.log(obj);
      });
    }
  });
}

/**
 * getCatalogSummary - allows retrieval of list of all keys in catalog along with size
 *
 * @param {function} callback - (Optional) callback to accept result array.
 */
TridentAdapter.prototype.getCatalogSummary = function(callback)
{
  var appName = this.app;
  
  // catalog already initialized
  // get all keys for current appName, and transpose results so just string array
  VAR_TRIDENT_API.GetAllKeys(function(results) {
    var entries = [];
    var obj,
      size,
      oapp,
      okey,
      oval;
    
    for(var idx = 0; idx < results.length; idx++) {
      obj = results[idx];
      oapp = obj.app || '';
      okey = obj.key || '';
      oval = obj.val || '';
      
      // app and key are composited into an appkey column so we will mult by 2
      size = oapp.length * 2 + okey.length * 2 + oval.length + 1;
      
      entries.push({ "app": obj.app, "key": obj.key, "size": size });
    }
    
    if (typeof (callback) === 'function') {
      callback(entries);
    }
    else {
      entries.forEach(function(obj) {
        console.log(obj);
      });
    }
  });
}
