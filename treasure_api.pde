TreasureAPI api;
Logger log;
Dispatcher dispatcher;
Player player;
Game game;
GameView view;

void setup() {
  log = new Logger(INFO, "[MAIN]");
  api = new TreasureAPI(DEBUG);
  player = new Player(41113, api);
  dispatcher = new Dispatcher();
  game = player.newAutoplayGame();
  log.info("Playing as " + player.toString());
  size(600, 400);
  view = new GameView();
  dispatcher.notify(new Event("render"));
}

void draw() {
}

void mouseClicked() {
  Event event = new Event("mouseClicked");
  dispatcher.notify(event);
}

void keyPressed() {
  if (key == CODED && keyCode == LEFT) {
     dispatcher.notify(new Event("focusLeft")); 
  }
  else if (key == CODED && keyCode == RIGHT) {
     dispatcher.notify(new Event("focusRight")); 
  }
  else if (key == CODED && keyCode == UP) {
     dispatcher.notify(new Event("selectFocused")); 
  }
}
