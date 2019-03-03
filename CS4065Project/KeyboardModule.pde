/**
 * Interface KeyboardModule
 *
 * Interface for classes that represent non-physical keyboards. Rendering,
 * movement between keys, etc. must be handled, but processing inputs should
 * be left to InputMethod classes.
 */
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
  Tree<Direction> h4Tree;
  
  H4Keyboard(Tree<Direction> h4Tree) {
    this.h4Tree = h4Tree;
  }
  
  // Draw the H4 keyboard.
  void render() {
    
  }
  
  // Accept the current selection in the tree.
  void accept() {
    
  }
  
  // Move along the tree in the direction.
  void move(Direction direction) {
    
  }
}

/**
 * Class SoftKeyboard
 *
 * A keyboard that lets users navigate around in a way similar to
 * digital keyboards on video game consoles.
 */
class SoftKeyboard implements KeyboardModule {
  void render() {
    
  }
  
  // 
  void accept() {
    
  }
  
  // Move along the map in a direction.
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
