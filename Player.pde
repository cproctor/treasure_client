// ## Player

// A Player represents a person with the following properties:
//
//   - **int pid**                  the player's ID
//   - **String name**              the player's name
//   - **int wins**                 total number of wins
//   - **int losses**               total number of losses
//   - **IntList gamesWaiting**     list of game IDs for games waiting for other players to join
//   - **IntList gamesPlaying**     list of game IDs currently playing
//   - **IntList gamesCancelled**   list of game IDs for cancelled games (waited too long to start)
//   - **IntList gamesComplete**    list of game IDs for complete games
//
// Players have the following methods:
//
//   - **Player(int pid)**          Gets a player by PID (the PID is effectively the player's password)
//   - **Player(String name)**      Creates a new player with the given name
//   - **Game newGame()**           Creates a new Game
//   - **Game newAutoplayGame()**   Creates a new autoplay Game against the bot. 
//   - **boolean canResumeGame()**  true when there is any currently playing game.
//   - **Game resumeAnyGame()**     Gets any currently playing game.
//   - **refresh()**                Updates the game with the latest from the server. This is useful when playing against another player, to see if they have played yet.

class Player {
  TreasureAPI api;
  String name;
  int pid, wins, losses;
  IntList gamesWaiting, gamesPlaying, gamesCancelled, gamesComplete;
  
  Player(JSONObject data, TreasureAPI _api) {
    api = _api;
    updateFromJSON(data);
  }
  
  Player(int _pid) {
    api = new TreasureAPI();
    pid = _pid;
    refresh();
  }
  
  Player(int _pid, TreasureAPI _api) {
    api = _api;
    pid = _pid;
    refresh();
  }
  
  Game newGame() {
    return api.newGame(pid);
  }
  
  Game newAutoplayGame() {
    return api.newAutoplayGame(pid);
  }
  
  boolean canResumeGame() {
    return gamesPlaying.size() > 0;
  }
  
  Game resumeAnyGame() {
    return api.resumeAnyGame(pid);
  }
  
  void refresh() {
    updateFromJSON(api.getPlayerJSON(pid));
  }
    
  // Reads a blob of JSON data from the server and updates this player's properties.
  void updateFromJSON(JSONObject data) {
    name = data.getString("name");
    pid = data.getInt("pid");
    JSONObject stats = data.getJSONObject("stats");
    wins = stats.getInt("wins");
    losses = stats.getInt("losses");
    gamesWaiting = json2IntList(data.getJSONArray("games_waiting"));
    gamesPlaying = json2IntList(data.getJSONArray("games_playing"));
    gamesCancelled = json2IntList(data.getJSONArray("games_cancelled"));
    gamesComplete = json2IntList(data.getJSONArray("games_complete"));
  }
  
  String toString() {
    return name + " (" + pid + ")";
  }
  
}
