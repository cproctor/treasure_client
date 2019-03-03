// Three classes are defined here: Dispatcher, View, and Event. 
// There will be one dispatcher for the whole program, responsible for 
// coordination. Every part of the user interface should inherit from 
// View; Views register themselves with the dispatcher so that they get
// notified of events. Each View has a `respond()` method, which 
// is called whenever there is an event.

// ## Dispatcher
class Dispatcher {
  Logger log;
  ArrayList<View> views;
  
  Dispatcher() {
    log = new Logger(DEBUG, "[EVENT]");
    views = new ArrayList<View>();
  }
  
  Dispatcher(int logLevel) {
    log = new Logger(logLevel, "[EVENT]");
    views = new ArrayList<View>();
  }
  
  void register(View v) {
    views.add(v); 
  }
  
  void notify(Event e) {
    log.debug("Event '" + e.name + "' with value " + str(e.value));
    for (View v: views) { v.respond(e); }
  }
}

// ## View
class View {
  View() {
    dispatcher.register(this);  
  }
  
  void respond(Event e) {
    if (e.name.equals("render")) render();
  }
  
  void render() {
  }
}

// ## Event
class Event {
  String name;
  int value = 0;
  
  Event(String _name, int _value) {
    name = _name;
    value = _value;
  }
  
  Event(String _name) {
    name = _name;
  }
}
