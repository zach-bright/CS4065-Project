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
  abstract String getEnteredText();
}

/**
 * Class H4Keyboard
 *
 * Handles everything about the H4-Writer keyboard implementation.
 * Rendering, handling the H4 tree structure, etc.
 */
class H4Keyboard implements KeyboardModule {
  Tree<Direction> h4Tree;
  String enteredText = "";
  String upList, leftList, downList, rightList;
  
  H4Keyboard(Tree<Direction> h4Tree) {
    this.h4Tree = h4Tree;
    this.updateListStrings();
  }
  
  // Draw the H4 keyboard.
  void render() {
    fill(black);
    textFont(buttonFont);
    textAlign(CENTER, TOP);
    text(upList, width/2, 200);
    text(leftList, (width/2)-100, 250);
    text(downList, width/2, 300);
    text(rightList, (width/2)+200, 250);
  }
  
  // Accept the current selection and add to text.
  void accept() {
    String content = h4Tree.getCurrentContent();
    if (content == null) {
      return;
    }
    
    enteredText += content;
    h4Tree.rewind();
  }
  
  // Move along the tree in a direction.
  void move(Direction direction) {
    h4Tree.crawlDown(direction);
    
    // If we moved to leaf, auto-accept.
    if (h4Tree.currentTreeNode.isLeaf()) {
      this.accept();
    }
    
    // Now that we moved, update [ULDR]List strings.
    this.updateListStrings();
  }
  
  // Update the four strings used to show users what options are
  // available to select for each of the four directions.
  private void updateListStrings() {
    // BFS down the tree in each direction.
    upList = h4Tree.getContentListFromLabel(Direction.UP);
    leftList = h4Tree.getContentListFromLabel(Direction.LEFT);
    downList = h4Tree.getContentListFromLabel(Direction.DOWN);
    rightList = h4Tree.getContentListFromLabel(Direction.RIGHT);
  }
  
  String getEnteredText() {
    return this.enteredText;
  }
}

/**
 * Class SoftKeyboard
 *
 * A keyboard that lets users navigate around in a way similar to
 * digital keyboards on video game consoles.
 */
class SoftKeyboard implements KeyboardModule {
  Map<Direction> softMap;
  String enteredText = "";
  
  SoftKeyboard(Map<Direction> softMap) {
    this.softMap = softMap;
  }
  
  // Draw the soft keyboard.
  void render() {
    
  }
  
  // Accept current selection and add to text.
  void accept() {
    enteredText += softMap.getCurrentContent();
  }
  
  // Move along the map in a direction.
  void move(Direction direction) {
    softMap.crawl(direction);
  }
  
  String getEnteredText() {
    return this.enteredText;
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
