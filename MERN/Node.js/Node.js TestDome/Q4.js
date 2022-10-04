/*
The createEmitter function should create a new EventEmitter and register "open" and "close" event listeners.
The callbacks for those events should be onOpen and onClose arguments, respectively. The opened and closed methods
should raise the "open" and "close" events on the EventEmitter they will receive as emitter arguments.
The callbacks should only be invoked once per emitter.

For example, after executing the following code, it should print "Opened!" and then "Closed!":
*/

const EventEmitter = require("events"); //events.EventEmitter is just a self reference

function createEmitter(onOpen, onClose) {    
  const myEmitter = new EventEmitter()
  myEmitter.once('open', onOpen); 
  myEmitter.once('close', onClose);
  return myEmitter; //This is important
}

function opened(emitter) {
  emitter.emit('open'); 
}
function closed(emitter) {
  emitter.emit('close');
}

let emitter = createEmitter(
  () => console.log("Opened!"), () => console.log("Closed!")
);
opened(emitter);
closed(emitter);

module.exports.createEmitter = createEmitter;
module.exports.opened = opened;
module.exports.closed = closed;