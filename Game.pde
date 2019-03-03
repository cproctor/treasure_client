// ## Game
// 
// A Game represents a game, with the following properties:
//
//  - **Player player**             the current player
//  - **int gid**                   the game's ID
//  - **int score**                 the player's score
//  - **int opponentScore**         the opponent's score
//  - **String status**             the game's status. Either 'playing', 'waiting for players', 'cancelled', or 'complete'.
//  - **String opponentName**       the opponent's name
//  - **IntList hand**              all the cards in the player's hand
//  - **IntList opponentHand**      all the cards in the opponent's hand
//  - **ArrayList<IntDict> turns**  A list of turns, with the newest first. Each turn lists the card played by a player on that turn. There will definitely be a "treasure" key and there might be one for the player's name. There will not be a key for the opponent until the turn is complete, because you're not allowed to see the opponent's play!
// 
// Game has the following methods:
//
//  - **boolean playerCanPlay()**   The player can play only if the game's status is 'playing' and she has not yet played this turn.
//  - **IntDict currentTurn()**     Returns the current turn
//  - **int currentTreasure()**     Returns the current treasure
//  - **refresh()**                 Fetches the latest from the server. 
//  - **play(int card)**            Plays the given card and updates with the latest from the server.

class Game {
 TreasureAPI api;
 Player player;
 int gid, score, opponentScore;
 String status, opponentName;
 IntList hand, opponentHand;
 ArrayList<IntDict> turns;
  
 Game(JSONObject data, Player _player, TreasureAPI _api) {
    player = _player;
    api = _api;
    updateFromJSON(data);
  }
  
  boolean playerCanPlay() {
    if (!status.equals("playing")) return false;
    return !currentTurn().hasKey(player.name);
  }
  
  IntDict currentTurn() {
    return turns.get(0);
  }
  
  int currentTreasure() {
    return currentTurn().get("treasure"); 
  }
  
  void refresh() {
    updateFromJSON(api.getGameJSON(player.pid, gid)); 
  }
  
  void play(int card) {
    updateFromJSON(api.playJSON(player.pid, gid, card));  
  }
  
  String toString() {
    if (status.equals("waiting for players")) {
      return "Game " + str(gid) + ": " + player.name + " is waiting for an opponent."; 
    } else {
       return "Game " + str(gid) + " (" + status + ") between " + player.name + " and " + opponentName + ".";
    }
  }
  
  // Reads a blob of JSON data from the server and updates this game's properties.
  void updateFromJSON(JSONObject data) {
    gid = data.getInt("gid");
    status = data.getString("status");
    turns = new ArrayList<IntDict>();
    if (status.equals("waiting for players")) {
      hand = new IntList();
      opponentHand = new IntList();
      score = 0;
      opponentScore = 0;
      opponentName = "";
      return;
    }
    JSONObject playersData = data.getJSONObject("players");
    for (Object k : playersData.keys()) {
      String name = k.toString();
      if (!name.equals(player.name)) opponentName = name;
    }
    JSONObject playerData = playersData.getJSONObject(player.name);
    score = playerData.getInt("score");
    hand = new IntList(playerData.getJSONArray("hand").getIntArray());
    JSONObject opponentData = playersData.getJSONObject(opponentName);
    opponentScore = opponentData.getInt("score");
    opponentHand = json2IntList(opponentData.getJSONArray("hand"));
    JSONArray turnsData = data.getJSONArray("turns");
    for (int i = 0; i < turnsData.size(); i++) {
       turns.add(json2IntDict(turnsData.getJSONObject(i)));
    }
  }
}
