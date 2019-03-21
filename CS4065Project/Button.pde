class Button {
  int x, y, w, h;
  String label;
  boolean isRenderable = false;
  boolean isSelected = false;
  
  Button(int x, int y, int w, int h, String label) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.label = label;
    this.isRenderable = true;
  }
  
  Button(String label) {
    this.label = label;
  }
  
  void toggleSelected() {
    this.isSelected = !this.isSelected;
  }
  
  void setBox(int x, int y, int w, int h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.isRenderable = true;
  }
  
  void render() {
    if (!this.isRenderable) {
      return;
    }   //<>//
    if (this.isSelected) {
      fill(buttonSelected);
    } else {
      fill(buttonUnselected);
    }
    rect(x, y, w, h);
    fill(black);
    textFont(buttonFont);
    textAlign(CENTER, CENTER);
    text(this.label, this.x + (this.w / 2), this.y + (this.h / 2));
  }
}
