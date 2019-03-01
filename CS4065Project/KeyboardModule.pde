interface KeyboardModule {
  abstract void render();
  abstract void accept();
  abstract void move(String action);
}

/**
 * Class H4Keyboard
 *
 * Handles everything about the H4-Writer keyboard implementation.
 * Rendering, handling the H4 tree structure, etc.
 */
class H4Keyboard implements KeyboardModule {
  Tree h4Tree;
  
  H4Keyboard(PApplet applet, Tree h4Tree) {
    
  }
  
  void render() {
    
  }
  
  void accept() {
    
  }
  
  void move(String action) {
    
  }
}

class SoftKeyboard implements KeyboardModule {
  void render() {
    
  }
  
  void accept() {
    
  }
  
  void move(String action) {
    
  }
}
