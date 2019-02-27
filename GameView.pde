/* Layer: Views
 * ------------
 * The GameView coordinates the user interface. When it is initialized, 
 * it creates all the other views. GameView also responds to "playerCard"
 * events, telling the Game to play the requested card.
 */

class GameView extends View {
  Logger log;
  int focusedCard = 0;
  
  int BOX_SIZE = 40, 
      BOX_MARGIN = 5,
      TREASURE_X = 250, 
      TREASURE_Y = 150,
      TREASURE_SIZE = 100,
      HAND_X = 10, 
      HAND_Y = 350, 
      OPP_HAND_X = 10, 
      OPP_HAND_Y = 10,
      SCORE_WIDTH = 130,
      SCORE_HEIGHT = 30,
      SCORE_X = 460,
      SCORE_Y = 310,
      OPP_SCORE_X = 460,
      OPP_SCORE_Y = 60,
      REFRESH_X = 460,
      REFRESH_Y = 180,
      REFRESH_WIDTH = 130,
      REFRESH_HEIGHT = 40;
  
  GameView() {
    log = new Logger(DEBUG, "[VIEW]");
    Box box;
    
    box = new Box(TREASURE_X, TREASURE_Y, TREASURE_SIZE, TREASURE_SIZE);
    new TreasureButton(box);
    
    // There's no need to refresh when using autoplay. 
    // box = new Box(REFRESH_X, REFRESH_Y, REFRESH_WIDTH, REFRESH_HEIGHT);
    // new RefreshButton(box);
    
    box = new Box(SCORE_X, SCORE_Y, SCORE_WIDTH, SCORE_HEIGHT);
    new ScoreButton(box);
    
    box = new Box(OPP_SCORE_X, OPP_SCORE_Y, SCORE_WIDTH, SCORE_HEIGHT);
    new OpponentScoreButton(box);
    
    for (int i = 0; i < 13; i++) {
      box = new Box(HAND_X + i * (BOX_SIZE + BOX_MARGIN), HAND_Y, BOX_SIZE, BOX_SIZE);
      new PlayerCardButton(i+1, box);
      box = new Box(OPP_HAND_X + i * (BOX_SIZE + BOX_MARGIN), OPP_HAND_Y, BOX_SIZE, BOX_SIZE);
      new OpponentCardButton(i+1, box);
    }
  }
  
  void respond(Event e) {
    if (e.name.equals("playerCard")) {
      log.info("Playing card " + str(e.value));
      game.play(e.value);
      dispatcher.notify(new Event("render"));
    } 
    else if (e.name.equals("focusLeft")) {
      moveFocusLeft();
      dispatcher.notify(new Event("render"));
    }
    else if (e.name.equals("focusRight")) {
      moveFocusRight();
      dispatcher.notify(new Event("render"));
    }
    else if (e.name.equals("selectFocused")) {
      if (game.hand.hasValue(focusedCard)) {
        log.info("Playing card " + str(focusedCard));
        game.play(focusedCard);
        dispatcher.notify(new Event("render"));
      }
      else {
        log.warning("Can't play " + str(focusedCard)); 
      }
    }
  }
  
  void moveFocusLeft() {
    focusedCard -= 1;
    while (!game.hand.hasValue(focusedCard) && focusedCard > 0) {
      focusedCard -= 1; 
    }
  }
  void moveFocusRight() {
    focusedCard += 1;
    while (!game.hand.hasValue(focusedCard) && focusedCard < 14) {
      focusedCard += 1; 
    }
  }
}
