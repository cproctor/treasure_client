// ## Box
// 
// A box manages a rectangle of the screen. It knows how to render itself, 
// and knows how to detect whether the mouse is over this area. Many UI 
// elements need these features.

class Box {
  int x, y, wt, ht;
  PVector center;
  
  Box(int _x, int _y, int _wt, int _ht) {
    x = _x;
    y = _y;
    wt = _wt;
    ht = _ht;
    center = new PVector(x + wt/2, y + ht/2);
   }
   
  boolean mouseOver() {
    return x <= mouseX && mouseX < x + wt && y <= mouseY && mouseY < y + ht;
  }
 
  void render() {
   rect(x, y, wt, ht); 
  }
}
