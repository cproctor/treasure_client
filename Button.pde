// ## Button

// All the  elements of the user interface are currently implemented as 
// Buttons. Some are enabled, others are not. When you create a Button, it will have the following behavior:
//
// - Every time there is a `render` event, it will first call
//   `buttonWillRender()`. This is a good opportunity to update
//   the button's label or set its enabled status. Then the 
//   button will render itself, by default as a rectangle with a 
//   centered label in the middle. If the button is 
//   enabled, it will use `renderEnabled()`; if not, it will 
//   use `renderDisabled()`.
// - Every time an enabled Button is clicked, it will send
//   out an event named `eventName` with value of `value`.

// We can make lots of different kinds of buttons by keeping this
// basic logic in place, and changing just the parts we want to change. 
// Note that every `Button` is a [View](Event.html), which means it automatically
// gets registered to be notified of [events](Event.html).
class Button extends View {
 // `label` is the text that will be shown on the button. `eventName` is the name of the 
 // event that will be sent when the button is clicked.
 String label, eventName = "buttonClick";
 // `value` will also be sent with event when the button is clicked. (We need this so that
 // the program can respond appropriately to when cards with different values are clicked.)
 int value;
 // Buttons will render differently when they are enabled, and will only send click events
 // when they are enabled.
 boolean enabled = true, canFocus = true;
 // Finally, each button gets a [Box](Box) that will help with tasks like drawing its rectangle and
 // figuring out whether it got clicked.
 Box box;
 
 // ### Constructor

 // To make a button just provide a label, value, eventName, and Box. The Button stores these values.
 Button(String _label, int _value, String _eventName, Box _box) {
   label = _label;
   value = _value;
   eventName = _eventName;
   box = _box;
 }

 // ### respond(Event e)

 // This is the basic logic that all buttons will use for rendering (so subclasses don't need to re-define it).
 void respond(Event e) {
   // If the [event](Event.html) name is `render`, then the Button needs to render. 
   if (e.name.equals("render")) {
     // First, we call `buttonWillRender`, which doesn't do anything--but it's an opportunity for 
     // subclasses to add needed behavior prior to rendering. 
     buttonWillRender();
     // If the button is enabled, 
     if (enabled) {
       // If it's a button that can focus and the [GameView](GameView.html)'s `focusedCard` matches this
       // button's value, 
       if (canFocus && view.focusedCard == value) {
         // then call `renderFocused` (which subclasses might also want to re-define).
         renderFocused();
       } 
       // If it's not a kind of button that focuses, or its value doesn't match `view.focusedCard`, 
       else {
         // then call `renderEnabled`.
         renderEnabled();
       }
     } 
     // Finally, if the button is disabled, 
     else {
       // call renderDisabled.
       renderDisabled();
     }
   }
   // If the [event](Event.html) name is `mouseClicked`, and the button is enabled, and the mouse 
   // is currently over the button's [Box(Box.html),
   // telling the world that **it** got clicked. 
   else if (e.name.equals("mouseClicked") && enabled && box.mouseOver()) {
     // the button needs to tell the [dispatcher](Event.html) that **it** got clicked. 
     // Again, subclasses can change how the button communicates by providing different values for `eventName` 
     // and `value`.
     dispatcher.notify(new Event(eventName, value));
   }
 }

 // ### buttonWillRender()

 // As noted above, this is a placeholder. It gets called before rendering, so it's a good opportunity to 
 // make any needed updates.
 void buttonWillRender() { 
 }

 // ## renderEnabled()

 // This is the default way of rendering enabled buttons: a yellow background with 
 // big black text. These styling functions are defined in [styles.html](styles.html).
 void renderEnabled() {
   // This helper just sets the fill color to yellow and a standard thin black outline (stroke).
   yellowFill();
   // We'll let the [Box](Box.html) take care of actually drawing the rectangle. 
   box.render();
   // This helper makes the text big and black.
   bigBlackText();
   // Set textAlign so that the text is centered horizontally and vertically.
   textAlign(CENTER, CENTER);
   // Finally, show the text. Note that this is easy because [Boxes](Box.html) already know their center positions.
   text(label, box.center.x, box.center.y);
 }

 // ## renderFocused()

 // Works follows the same pattern as `renderEnabled`. 
 void renderFocused() {
   brightYellowFill();
   box.render();
   bigBlackText();
   textAlign(CENTER, CENTER);
   text(label, box.center.x, box.center.y);
 }

 // ## renderDisabled()

 // Again, follows the same pattern same as `renderEnabled`. 
 void renderDisabled() {
   darkGreyFill();
   box.render();
   bigGreyText();
   textAlign(CENTER, CENTER);
   text(label, box.center.x, box.center.y);
 }
}

// # Button Subclasses
// Because of the way Button is written, it's quick and easy to make all kinds of buttons.

// ## PlayerCardButton

// One PlayerCardButton is used for each card in the player's hand.
class PlayerCardButton extends Button {

  // ### Constructor

  // We only need to know two things to make a PlayerCardButton: its value and its [Box](Box.html).
  PlayerCardButton(int _value, Box _box) {
    // `super` refers to the parent class's constructor, which requires four values: 
    // label, value, eventName, and box. The label will just be the value (as a string), and 
    // `eventName` will be `playerCard`.
    super(str(_value), _value, "playerCard", _box);
  }

  // ### buttonWillRender()

  // Before rendering, we need to check whether the card is still in the player's hand, and 
  // update the enabled property accordingly. Then `render` will make sure disabled
  // cards have the disabled style, and `respond` will not create new events when the button is clicked.
  void buttonWillRender() {
    enabled = game.hand.hasValue(value);
  }
}

// ## OpponentCardButton

// OpponentCardButton is just like PlayerCardButton, except it doesn't focus, it sends events named
// `opponentCard` (which are ignored by [GameView](GameView.html)), and it has different styling. 
// It also checks `game.opponentHand` instead of `game.hand` to see whether it's enabled.
class OpponentCardButton extends PlayerCardButton {

   // ### Constructor
   
   OpponentCardButton(int _value, Box _box) {
     // We call the PlayerCardButton constructor, 
     super(_value, _box);
     // and then update `eventName` and `canFocus` as appropriate.
     eventName = "opponentCard";
     canFocus = false;
   }

   // ### renderEnabled()
 
   // Only one line is different here--we call `greenFill()` instead of `yellowFill()`.
   void renderEnabled() {
     greenFill();
     box.render();
     bigBlackText();
     textAlign(CENTER, CENTER);
     text(label, box.center.x, box.center.y);
   }

   // ### buttonWillRender()

   // We want these cards to show what's in the opponent's hand, so we need to update `enabled` 
   // according to `game.opponentHand`.
   void buttonWillRender() {
    enabled = game.opponentHand.hasValue(value);
  }
}

// ## DisabledButton

// Here, we add another layer to the class inheritance--there will be many kinds of disabled buttons,
// so we can define the functionality here and have them all inherit from DisabledButton. 
class DisabledButton extends Button {

  // ### Constructor

  // All we need to know to create a DisabledButton is where it should go. So we define a constructor
  // which only requires a [Box](Box.html).
  DisabledButton(Box _box) {
    // Call the Button constructor with sensible default values. `eventName` doesn't matter because
    // disabled buttons won't be sending any events.
    super("", 0, "disabled", _box);
    enabled = false;
  }
}

// ## TreasureButton

// TreasureButton is a DisabledButton which updates its label according to the game's current score. 
// It also has a more elaborate render; it uses the coordinates of its [Box](Box.html) to draw a circle.
class TreasureButton extends DisabledButton {
  TreasureButton(Box _box) {
    super(_box);
  }
  void buttonWillRender() {
    label = str(game.currentTreasure()); 
  }
  void renderDisabled() {
    treasureFill();
    ellipse(box.center.x, box.center.y, box.wt, box.ht);
    hugeBlueText();
    textAlign(CENTER, CENTER);
    text(label, box.center.x, box.center.y);
   }
}

// ## ScoreButton

// ScoreButton is a DisabledButton which updates its label with the player's name and current score.
// It also uses slightly different styles in `renderDisabled()`.
class ScoreButton extends DisabledButton {
   ScoreButton(Box _box) {
     super(_box);
   }
   void buttonWillRender() {
     label = game.player.name + ": " + str(game.score);
   }
   void renderDisabled() {
     darkGreyFill();
     box.render();
     mediumGreyText();
     textAlign(CENTER, CENTER);
     text(label, box.center.x, box.center.y);
   }
}

// ## OpponentScoreButton

// OpponentScoreButton extends ScoreButton (which extends DisabledButton which extends Button). 
// The only difference is that the label gets set to the opponent's name and the opponent's score.
class OpponentScoreButton extends ScoreButton {
   OpponentScoreButton(Box _box) {
     super(_box);
   }
   void buttonWillRender() {
     label = game.opponentName + ": " + str(game.opponentScore);
   }
}

// ## RefreshButton

// RefreshButton currently is not used, because the user interface only supports autoplay games where
// the bot plays immediately. If you wrote a multiplayer interface, you might want to add a button the player
// can use to refresh and check if the opponent had already played. All we need to do at the button level is
// set `eventName` to `"refresh"`; we could add code to the [GameView](GameView.html) `respond(Event e)` method
// to refresh the game when this event is received.
class RefreshButton extends Button {
  RefreshButton(Box _box) {
    super("Refresh", 0, "refresh", _box); 
  }
}

// # Summary

// This file defined a lot of different user interface elements, but none of them are very complicated. All they
// do is render themselves and respond to user interaction. Most of the work is done in the model and lower layers.
// Hopefully, you can see how you could make other user interface elements, possibly also extending from Button
// or working in a similar manner. 

// That's it for the View layer; the next layer down is Models. Let's start by looking at [Player](Player.html). 
// Note: I haven't finished writing documentaiton for the rest of the layers yet. It's coming!




