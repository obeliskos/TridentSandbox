window.runExample = function(){
  try {
    // init db
    var db = new loki('Example');


    // create two example collections
    var users = db.addCollection('users','User', ['email'], true, false);
    var projects = db.addCollection('projects', 'Project', ['name']);

    // show collections in db
    db.listCollections();

    trace('Adding 9 users');
    
    // create six users
    var odin = users.insert( { name : 'odin', email: 'odin.soap@lokijs.org', age: 38 } );
    var thor = users.insert( { name : 'thor', email : 'thor.soap@lokijs.org', age: 25 } );
    var stan = users.insert( { name : 'stan', email : 'stan.soap@lokijs.org', age: 29 } );
    // we create a snapshot of the db here so that we can see the difference
    // between the current state of the db and after the json has been reloaded
    var json = db.serialize();


    var oliver = users.insert( { name : 'oliver', email : 'oliver.soap@lokijs.org', age: 31 } );
    var hector = users.insert( { name : 'hector', email : 'hector.soap@lokijs.org', age: 15} );
    var achilles = users.insert( { name : 'achilles', email : 'achilles.soap@lokijs.org', age: 31 } );
    var lugh = users.insert( { name : 'lugh', email : 'lugh.soap@lokijs.org', age: 31 } );
    var nuada = users.insert( { name : 'nuada', email : 'nuada.soap@lokijs.org', age: 31 } );
    var cuchullain = users.insert( { name : 'cuchullain', email : 'cuchullain.soap@lokijs.org', age: 31 } );

    trace('Finished adding users');
    
    // create an example project
    var prj = projects.insert( { name : 'LokiJS', owner: stan });

    // query for user
    //trace( users.find('name','odin') );
    
    

    stan.name = 'Stan Laurel';

    // update object (this really only syncs the index)
    users.update(stan);
    users.remove(achilles);
    
    // finding users with age greater than 25
    trace('Find by age > 25');
    trace(users.find( {'age':{'$gt': 25} } ));
    trace('Get all users');
    trace(users.find());
    trace('Get all users with age equal to 25');
    trace(users.find({'age': 25}));
    // get by id with binary search index
    trace(users.get(8));
  
    // a simple filter for users over 30
    function ageView(obj){
      return obj.age > 30;
    }
    // a little more complicated, users with names longer than 3 characters and age over 30
    function aCustomFilter(obj){
      return obj.name.length  < 5 && obj.age > 30;
    }



    // test the filters
    trace('Example: View "Age" test');
    users.storeView('age', function(obj){ return obj.age > 30; });
    trace(users.view('age'));
    trace('End view test');
    sep();

    trace('Example: Custom filter test');
    trace(users.view(aCustomFilter));
    trace('End of custom filter');
    sep();
    
    // example of map reduce
    trace('Example: Map-reduce');
    function mapFun(obj){
        return obj.age;
    }
    function reduceFun(array){
      var len = array.length >>> 0;
      var i = len;
      var cumulator = 0;
      while(i--){
          cumulator += array[i];
      }
      return cumulator / len;
    }

    trace('Average age is : ' + users.mapReduce( mapFun, reduceFun).toFixed(2) );
    trace('End of map-reduce');
    sep();

    trace('Example: stringify');
    trace('String representation : ' + db.serialize());
    trace('End stringify example');
    sep();

    trace('Example: findAndUpdate');
    function updateAge(obj){
      obj.age *= 2;
      return obj;
    }
    users.findAndUpdate(ageView, updateAge);
    trace(users.find());
    trace('End findAndUpdate example');

    db.loadJSON(json);

    trace(db.serialize());

    function sep(){
      trace('//---------------------------------------------//');
    }

    function trace(message){
        if(typeof console !== 'undefined' && console.log){
            console.log(message);
        }
    }

  } catch(err){
    console.error(err);
    console.log(err.message);
  }
  
};