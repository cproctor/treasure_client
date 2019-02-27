Treasure API
------------

Version 1.1.

This Processing project contains code to help you write an interface for the Treasure game.
The code is organized into four layers:

- Views: These manage the user interface the user sees and interacts with. You'll be creating
  new views.
- Models: These represent the state of Players and Games. Your views will interact with Models, 
  but you don't need to worry about the internals. 
- API: This is code that helps the models interact with the server.
- Server: The server is on another computer. It keeps the master copies of all the data, and enforces
  rules (like you can't see your opponent's hand, and you can't just declare yourself the winner
  of a game). 
