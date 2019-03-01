interface KeyboardModule {
  abstract void render();
  abstract void accept();
  abstract void move(Direction direction);
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
  
  void move(Direction direction) {
    
  }
}

class SoftKeyboard implements KeyboardModule {
  void render() {
    
  }
  
  void accept() {
    
  }
  
  void move(Direction direction) {
    
  }
}

/**
 * Enum Direction
 *
 * Enum to hold valid directional values.
 */
public enum Direction {
  UP,
  DOWN,
  LEFT,
  RIGHT;
  
  // Used by the config-to-data structure stuff in ConfigReader
  // to allow conversion of ULDR to Direction enum.
  public static Direction stringToDirection(String str) {
    if (str.equals("U")) {
      return Direction.UP;
    } else if (str.equals("L")) {
      return Direction.LEFT;
    } else if (str.equals("D")) {
      return Direction.DOWN;
    } else if (str.equals("R")) {
      return Direction.RIGHT;
    }
    return null;
  }
  
  // Applying above to an array. This could be done easily in ConfigReader
  // using Java 8 functional programming but its not supported in Processing :(
  public static Direction[] stringToDirection(String[] strs) {
    Direction[] directions = new Direction[strs.length];
    for (int i = 0; i < strs.length; i++) {
      directions[i] = stringToDirection(strs[i]);
    }
    return directions;
  }
}
