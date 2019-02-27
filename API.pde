// Layer: API
// ----------
// TreasureAPI takes care of talking to the server. Just ask for
// what you want, and you'll get it! Example: 
// 
//   Player paulo;
//   Game game;
//   TreasureAPI api = new TreasureAPI();
//   paulo = api.newPlayer("Paulo");
//   game = api.newAutoplayGame(paulo.pid);
//
// An API (Application Programming Interface) is a specified way 
// of interacting with a piece of software. The main way of interacting
// with the Treasure server is via HTTP requests (for example, using
// a web browser). This is inconvenient, so the API class handles the 
// details and lets the rest of the program just ask for what it wants.
// This class was written to be understandable, but you don't need to read
// any further unless you want to. 

class TreasureAPI{
  String base_url = "http://treasure.chrisproctor.net";
  Logger log;
  
  TreasureAPI() {
    log = new Logger(DEBUG, "[API]");
    log.debug("Initialized API");
  }
  
  TreasureAPI(int logLevel) {
    log = new Logger(logLevel, "[API]");
    log.debug("Initialized API");
  }
  
  Player newPlayer(String name) {
    String url = base_url + "/players/new/" + name;
    log.debug(url);
    return new Player(loadJSONObject(url), this); 
  }
  
  Player getPlayer(int pid) {
    return new Player(getPlayerJSON(pid), this); 
  }
  
  JSONObject getPlayerJSON(int pid) {
    String url = base_url + "/players/" + str(pid);
    log.debug(url);
    return loadJSONObject(url);
  }
  
  Game newGame(int pid) {
    Player player = getPlayer(pid);
    String url = base_url + "/players/" + str(pid) + "/games/new";
    log.debug(url);
    return new Game(loadJSONObject(url), player, this); 
  }
  
  Game newAutoplayGame(int pid) {
    Player player = getPlayer(pid);
    String url = base_url + "/players/" + str(pid) + "/games/new";
    log.debug(url);
    Game g = new Game(loadJSONObject(url), player, this); 
    url = base_url + "/players/" + str(pid) + "/games/" + str(g.gid) + "/autoplay";
    log.debug(url);
    return new Game(loadJSONObject(url), player, this); 
  }
  
  Game joinAnyGame(int pid) {
    Player player = getPlayer(pid);
    String url = base_url + "/players/" + str(pid) + "/games/join";
    log.debug(url);
    return new Game(loadJSONObject(url), player, this); 
  }
  
  Game resumeAnyGame(int pid) {
    Player player = getPlayer(pid);
    String url = base_url + "/players/" + str(pid) + "/games/resume";
    log.debug(url);
    return new Game(loadJSONObject(url), player, this); 
  }
  
  Game joinGame(int pid, int gid) {
    Player player = getPlayer(pid);
    String url = base_url + "/players/" + str(pid) + "/games/" + str(gid) + "/join";
    log.debug(url);
    return new Game(loadJSONObject(url), player, this); 
  }
  
  Game getGame(int pid, int gid) {
    Player player = getPlayer(pid);
    return new Game(getGameJSON(pid, gid), player, this); 
  }
  
  JSONObject getGameJSON(int pid, int gid) {
    Player player = getPlayer(pid);
    String url = base_url + "/players/" + str(pid) + "/games/" + str(gid);
    log.debug(url);
    return loadJSONObject(url);
  }
  
  Game setGameToAutoplay(int pid, int gid) {
    Player player = getPlayer(pid);
    String url = base_url + "/players/" + str(pid) + "/games/" + str(gid) + "/autoplay";
    log.debug(url);
    return new Game(loadJSONObject(url), player, this); 
  }
  
  JSONObject playJSON(int pid, int gid, int card) {
    Player player = getPlayer(pid);
    String url = base_url + "/players/" + str(pid) + "/games/" + str(gid) + "/play/" + str(card);
    log.debug(url);
    return loadJSONObject(url);
  }
  
  Game play(int pid, int gid, int card) {
    return new Game(playJSON(pid, gid, card), player, this); 
  }
}
