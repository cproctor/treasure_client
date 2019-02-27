/* Layer: Views
 * ------------
 * All the UI elements are currently implemented as 
 * Buttons. Some are enabled, others are not. When you
 * create a Button, it will have the following behavior:
 * - Every time there is a "render" event, it will first call
 *   buttonWillRender(). This is a good opportunity to update
 *   the button's label or set its enabled status. Then the 
 *   button will draw itself, by default as a box with a 
 *   centered label in the middle. If the button is 
 *   enabled, it will use renderEnabled(); if not, it will 
 *   use renderDisabled().
 * - Every time it is clicked, if it is enabled, it will send
 *   out an event with name=eventName and value=value.
 * 
 * There are lots of subclasses of Button defined below.
 */

class Button extends View {
 String label, eventName = "buttonClick";
 int value;
 boolean enabled = true, canFocus = true;
 Box box;
 
 Button(String _label, int _value, String _eventName, Box _box) {
   label = _label;
   value = _value;
   eventName = _eventName;
   box = _box;
 }
 void respond(Event e) {
   if (e.name.equals("render")) {
     buttonWillRender();
     if (enabled) {
       if (canFocus && view.focusedCard == value) {
         renderFocused();
       } 
       else {
         renderEnabled();
       }
     } 
     else {
       renderDisabled();
     }
   }
   else if (e.name.equals("mouseClicked") && enabled && box.mouseOver()) {
     dispatcher.notify(new Event(eventName, value));
   }
 }
 void buttonWillRender() { 
 }
 void renderEnabled() {
   yellowFill();
   box.render();
   bigBlackText();
   textAlign(CENTER, CENTER);
   text(label, box.center.x, box.center.y);
 }
 void renderFocused() {
   brightYellowFill();
   box.render();
   bigBlackText();
   textAlign(CENTER, CENTER);
   text(label, box.center.x, box.center.y);
 }
 void renderDisabled() {
   darkGreyFill();
   box.render();
   bigGreyText();
   textAlign(CENTER, CENTER);
   text(label, box.center.x, box.center.y);
 }
}

/*  SUBCLASSES  */

class RefreshButton extends Button {
  RefreshButton(Box _box) {
    super("Refresh", 0, "refresh", _box); 
  }
  void renderEnabled() {
    yellowFill();
    box.render();
    bigBlackText();
    textAlign(CENTER, CENTER);
    text(label, box.center.x, box.center.y);
  }
}

class PlayerCardButton extends Button {
  PlayerCardButton(int _value, Box _box) {
    super(str(_value), _value, "playerCard", _box);
  }
  void buttonWillRender() {
    enabled = game.hand.hasValue(value);
  }
}

class OpponentCardButton extends PlayerCardButton {
   OpponentCardButton(int _value, Box _box) {
     super(_value, _box);
     eventName = "opponentCard";
     canFocus = false;
   }
   void renderEnabled() {
     greenFill();
     box.render();
     bigBlackText();
     textAlign(CENTER, CENTER);
     text(label, box.center.x, box.center.y);
   }
   void buttonWillRender() {
    enabled = game.opponentHand.hasValue(value);
  }
}

class DisabledButton extends Button {
  DisabledButton(Box _box) {
    super("", 0, "playerCard", _box);
    enabled = false;
  }
  DisabledButton(int _value, Box _box) {
    super(str(_value), _value, "playerCard", _box);
    enabled = false;
  }
}

class TreasureButton extends DisabledButton {
  TreasureButton(Box _box) {
    super(0, _box);
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

class OpponentScoreButton extends ScoreButton {
   OpponentScoreButton(Box _box) {
     super(_box);
   }
   void buttonWillRender() {
     label = game.opponentName + ": " + str(game.opponentScore);
   }
}
