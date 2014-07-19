 // Worker/Thread Pooling logic borrowed from here :
 // http://www.smartjava.org/content/html5-easily-parallelize-jobs-using-web-workers-and-threadpool
 //
 // This was added to support Crypto_Worker.js web worker, however you can use this pool
 // Workers of any type, even mixing several different types of workers
 
 function Pool(size) {
    var _this = this;
 
    // set some defaults
    this.taskQueue = [];
    this.workerQueue = [];
    this.poolSize = size;
 
    this.addWorkerTask = function(workerTask) {
        if (_this.workerQueue.length > 0) {
            // get the worker from the front of the queue
            var workerThread = _this.workerQueue.shift();
            workerThread.run(workerTask);
        } else {
            // no free workers,
            _this.taskQueue.push(workerTask);
        }
    }
 
    this.init = function() {
        // create 'size' number of worker threads
        for (var i = 0 ; i < size ; i++) {
            _this.workerQueue.push(new WorkerThread(_this));
        }
    }
 
    this.freeWorkerThread = function(workerThread) {
        if (_this.taskQueue.length > 0) {
            // don't put back in queue, but execute next task
            var workerTask = _this.taskQueue.shift();
            workerThread.run(workerTask);
        } else {
            //_this.taskQueue.push(workerThread);
            _this.workerQueue.push(workerThread);
        }
    }
}
 
// runner work tasks in the pool
function WorkerThread(parentPool) {
 
    var _this = this;
 
    this.parentPool = parentPool;
    this.workerTask = {};
 
    this.run = function(workerTask) {
        this.workerTask = workerTask;
        // create a new web worker
        if (this.workerTask.script!= null) {
            var worker = new Worker(workerTask.script);
            worker.addEventListener('message', dummyCallback, false);
            worker.postMessage(workerTask.startMessage);
        }
    }
 
    // for now assume we only get a single callback from a worker
    // which also indicates the end of this worker.
    function dummyCallback(event) {
        // pass to original callback
        _this.workerTask.callback(event);
 
        // we should use a seperate thread to add the worker
        _this.parentPool.freeWorkerThread(_this);
    }
 
}
 
// task to run
function WorkerTask(script, callback, msg) {
 
    this.script = script;
    this.callback = callback;
    this.startMessage = msg;
};
