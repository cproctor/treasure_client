// ## GameView

// GameView is the first object in the Views layer. Views are responsible for 
// providing the user interface, presenting information on the screen and 
// responding to user actions like key presses and mouse clicks. 
// GameView creates all the other views, and handles [events](Event.html) they create. 
// GameView is a subclass of View, which is defined in [Event.html](Event.html). 
// Every View automatically registers itself with the [dispatcher](Event.html), so that the 
// [dispatcher](Event.html) can notify it about [events](Event.html). 
class GameView extends View {
  // The GameView has a [log](Logger.html) so that it can send messages about what's going on.
  Logger log;
  // For this interface, it made sense to also keep track of which card is focused. We are only
  // going to allow one thing to be focused at a time, so it makes sense to keep track of what's
  // focused in a central location rather than having each part of the interface keep track
  // of whether it's focused.   
  int focusedCard = 0;
  
  // Now we define a bunch of constants that specify the sizes and positions of all the buttons
  // on the screen. It's a **really** good idea to define constants like this, rather than just 
  // putting numbers directly into your code. That way, you know where to go to make changes, 
  // and you never have mystery code full of numbers whose meaning you might forget.
  // Try changing these values to see how they affect the user interface.
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

// ## Constructor

  // When a GameView is initialized, it creates all the other user interface elements, 
  // which are implemented as [buttons](Button.html). After creating the buttons, GameView
  // does not need to keep track of them. If they need to communicate, they'll send [events](Event.html) 
  // which GameView will respond to. This simplifies the code quite a bit. 
  GameView() {
    log = new Logger(DEBUG, "[VIEW]");
    // There's a bit of tedium involved in working with areas of the screen, so we'll use a class
    // called [Box](Box.html) to take care of that for us. Every Button needs a Box. We will be making
    // a lot of buttons, but we can just use one variable, `box`, to hold whichever Box we're currently 
    // working with. 
    Box box;
    
    // So let's get started adding [Buttons](Button.html) to the screen. First, we'll make a Box specifying
    // where the treasure button should be, 
    box = new Box(TREASURE_X, TREASURE_Y, TREASURE_SIZE, TREASURE_SIZE);
    // then we'll use it to create a [TreasureButton](Button.html).
    new TreasureButton(box);
    
    // Make a new Box for the player's score
    box = new Box(SCORE_X, SCORE_Y, SCORE_WIDTH, SCORE_HEIGHT);
    // and use it to create a [ScoreButton](Button.html).
    new ScoreButton(box);
    
    // And repeat the process to make an [OpponentScoreButton](Button.html)
    box = new Box(OPP_SCORE_X, OPP_SCORE_Y, SCORE_WIDTH, SCORE_HEIGHT);
    new OpponentScoreButton(box);
    
    // Now for the cards. We need to make a bunch of these, and they follow a predictable pattern, 
    // so it makes sense to use a loop. As long as we create card buttons with the right value and
    // with a [Box](Box.html) with the right coordinates, the buttons can take care of everything
    // else on their own. So we create a temporary variable, `i`, and loop through the same process
    // 13 times.
    for (int i = 0; i < 13; i++) {
      // We set `box` to have the correct position for the player's card, The vertical y-value
      // will always be the same (`HAND_Y`), but the horizontal x-value will be different for each
      // card. `HAND_X` is the origin point for the hand, and then each card gets shifted over
      // an appropriate amount, `i` times `BOX_SIZE + BOX_MARGIN`. This is a commonly-used pattern
      // for laying out items.
      box = new Box(HAND_X + i * (BOX_SIZE + BOX_MARGIN), HAND_Y, BOX_SIZE, BOX_SIZE);
      // Then we create a [PlayerCardButton](Button.html). In CS, `0` is usually considered the first
      // number (and it's important here, because we want the first card to have an x-offset of 0), so 
      // each card's value is set to `i+1` so they range from 1 to 13 instead of from 0 to 12.
      new PlayerCardButton(i+1, box);
      // Then re-define the [Box](Box.html) for the opponent's hand. We could have done this in a 
      // separate loop, but why bother.
      box = new Box(OPP_HAND_X + i * (BOX_SIZE + BOX_MARGIN), OPP_HAND_Y, BOX_SIZE, BOX_SIZE);
      // And create the [OpponentCardButton](Button.html)
      new OpponentCardButton(i+1, box);
    }
  }

  // ### respond(Event e)

  // Every View must have a `respond` method, because the [dispatcher](Event.html) expects to call it when a new [Event](Event.html)
  // arrives. However, a default `respond` method is already defined in [View](Event.html), so if you don't 
  // provide one, the default will be used. 
  // You can re-define `respond` to change how the View responds. For GameView, there are
  // several different [event](Event.html) names that matter. We handle each in a separate case.
  void respond(Event e) {
    // `playerCard` [event](Event.html)s are sent when one of the player's active cards gets clicked. This means 
    // that card should be played.
    if (e.name.equals("playerCard")) {
      // Log it (helpful in debugging)
      log.info("Playing card " + str(e.value));
      // Tell the [game](Game.html) to play that card. Note this is the first time we're using an object
      // from the [Model](Player.html) layer. Interactions between views and modes should be short and 
      // sweet, just like this one! If you're reading carefully, you might wonder
      // why we don't check whether the card can be played. The program will crash if somebody tries to play
      // 14 or a card they've already played. It would be safer to check, but we know that only 
      // unplayed, legitimate cards will be sending this [event](Event.html), so we're only going to get legitimate
      // values. If you were thinking about possibly extending this program in the future, it would 
      // definitely be worth checking here, to prevent a future headache. This is called defensive 
      // programming. 
      game.play(e.value);
      // By convention, every view should respond to `render` [events](Event.html) by updating their parts of the screen.
      // Every time the [player](Player.html) or the [game](Game.html) potentially changes, we need to 
      // issue a `render` [event](Event.html) to tell the views to update themselves. Why doesn't GameView
      // do anything when it receives a `render` event? Because it's not responsible for any part of the screen; 
      // it just coordinates the other Views.
      dispatcher.notify(new Event("render"));
    } 
    // The `focusLeft` [event](Event.html) is sent when the left arrow is pressed.
    else if (e.name.equals("focusLeft")) {
      // We want to respond by moving the focus left. That's not too complicated, but it felt worth
      // putting into a separate method (below) to keep this part of the code cleaner.
      moveFocusLeft();
      // Something changed, so re-render.
      dispatcher.notify(new Event("render"));
    }
    // The `focusRight` [event](Event.html) is sent when the right arrow is pressed; we follow the same pattern.
    else if (e.name.equals("focusRight")) {
      moveFocusRight();
      dispatcher.notify(new Event("render"));
    }
    // Finally, the `selectFocused` [event](Event.html) is sent when the up arrow is pressed. 
    else if (e.name.equals("selectFocused")) {
      // We want to respond by playing whichever card is focused. In this case, we do need to 
      // check whether that card can be played, because sometimes the focusedCard is not a valid play.
      // This happens at the beginning of the game (`focusedCard` is initially set to `0`), after playing 
      // a card (`focusedCard` retains its value, but the card is no longer playable), and after moving too
      // far left or right. Luckily, we can easily use the [game](Game.html) model to check whether the player
      // has that value in her hand.
      if (game.hand.hasValue(focusedCard)) {
        // If so, we can play it. Log it, 
        log.info("Playing card " + str(focusedCard));
        // and tell the [game](Game.html) to play `focusedCard`..
        game.play(focusedCard);
        // Something changed, so re-render.
        dispatcher.notify(new Event("render"));
      }
      // In case `focusedCard` can't be played, nothing happens. But it's worth logging as a warning, in case
      // something goes wrong later.
      else {
        log.warning("Can't play " + str(focusedCard)); 
      }
    }
  }

  // ### moveFocusLeft()

  // We're almost finished, just need to define how to move the focus left and right. There are many ways we could
  // do this, but here's a simple strategy:
  void moveFocusLeft() {
    // reduce the value of `focusedCard` by 1. 
    focusedCard -= 1;
    // Then, as long as `focusedCard` isn't in the player's hand and we're still above `0`, 
    while (!game.hand.hasValue(focusedCard) && focusedCard > 0) {
      // keep reducing the value of `focusedCard`. The intent here is to allow focus to skip over as many
      // already-played cards as necessary. If we're already at or below 0, `focvusedCard` will keep decreasing
      // every time the left arrow is pressed, but we don't need to care, because it will zoom back up to the next 
      // available card the first time the right arrow is pressed.
      focusedCard -= 1; 
    }
  }
 
  // ### moveFocusRight()

  // Works exactly the same way as `moveFocusLeft`, just in reverse.
  void moveFocusRight() {
    focusedCard += 1;
    while (!game.hand.hasValue(focusedCard) && focusedCard < 14) {
      focusedCard += 1; 
    }
  }
}

// ## Next up
// We have now created all the [Buttons](Button.html) needed for the user interface, and written code
// to respond to their [events](Event.html). [Next, Let's have a look at how those buttons work](Button.html).




