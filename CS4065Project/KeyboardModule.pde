/**
 * Class KeyboardModule
 *
 * For classes that represent non-physical keyboards. Rendering, movement
 * between keys, etc. must be handled, but processing inputs should be
 * left to InputMethod classes.
 */
abstract class KeyboardModule {
  String upList, leftList, downList, rightList;
  String enteredText = "";
  String currentPath = "";
  boolean shift = false, caps = false;
  
  abstract void render();
  abstract void accept();
  abstract void move(Direction direction);
  abstract String getEnteredText();
  
  // Deals with everything special-character related.
  void handleSpecialChar(String charString) {
    switch (charString.trim()) {
      case "[bksp]":
        // Trim last char from text.
        if (enteredText.length() > 0) {
          enteredText = enteredText.substring(0, enteredText.length() - 1);
        }
        break;
      case "[enter]":
        // TODO: Logic to record current entered text and show next test.
        break;
      case "[shift]":
        shift = true;
        break;
      case "[caps]":
        caps = !caps;
        break;
      case "[sym]":
        // TODO: No clue what this one does.
    }
  }
}

/**
 * Class H4Keyboard
 *
 * Handles everything about the H4-Writer keyboard implementation.
 * Rendering, handling the H4 tree structure, etc.
 */
class H4Keyboard extends KeyboardModule {
  Tree<Direction> h4Tree;
  
  H4Keyboard(Tree<Direction> h4Tree) {
    this.h4Tree = h4Tree;
    this.updateListStrings();
  }
  
  // Draw the H4 keyboard.
  void render() {
    // TODO: Move this garbage into a special trapezoid class or
    //       something. God, I hate graphics programming.
    // Draw polygons.
    fill(highlight);
    beginShape();  // Left
    vertex(60, 160);
    vertex(60, 550);
    vertex(320, 420);
    vertex(320, 290);
    endShape(CLOSE);
    beginShape();  // Up
    vertex(60, 160);
    vertex(840, 160);
    vertex(580, 290);
    vertex(320, 290);
    endShape(CLOSE);
    beginShape();  // Right
    vertex(840, 160);
    vertex(580, 290);
    vertex(580, 420);
    vertex(840, 550);
    endShape(CLOSE);
    beginShape();  // Down
    vertex(60, 550);
    vertex(840, 550);
    vertex(580, 420);
    vertex(320, 420);
    endShape(CLOSE);
    
    // Draw text.
    fill(black);
    textFont(buttonFont);
    textAlign(CENTER, CENTER);
    rectMode(CENTER);
    text(upList, width/2, 225, 100, 100);
    text(leftList, 200, 350, 100, 100);
    text(downList, width/2, 485, 100, 100);
    text(rightList, 700, 350, 100, 100);
    text(currentPath, width/2, 355, 100, 100);
    rectMode(CORNER);
  }
  
  // Accept the current selection and add to text.
  void accept() {
    String content = h4Tree.getCurrentContent();
    if (content == null) {
      return;
    }
    
    // Check if content is a special character.
    if (content.matches("(\\[.*\\])")) {
      this.handleSpecialChar(content);
    } else {
      // Just like on normal keyboards, capitalize if shift or caps
      // is on, but not if both are on.
      if (this.shift ^ this.caps) { //<>//
        enteredText += content.toUpperCase();
      } else {
        enteredText += content;
      }
      // Turn off shift if we added alphanumeric.
      shift = false;
    }
    
    currentPath = "";
    h4Tree.rewind();
  }
  
  // Move along the tree in a direction.
  void move(Direction direction) {
    h4Tree.crawlDown(direction);
    currentPath += " " + direction;
    
    // If we moved to leaf, auto-accept.
    if (h4Tree.currentTreeNode.isLeaf()) {
      this.accept();
    }
    
    // Now that we moved, update [ULDR]List strings and current path.
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
class SoftKeyboard extends KeyboardModule {
  Map<Direction> softMap;
  
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
  // using Java 8 but its not supported in Processing :(
  public static Direction[] stringToDirection(String[] strs) {
    Direction[] directions = new Direction[strs.length];
    for (int i = 0; i < strs.length; i++) {
      directions[i] = stringToDirection(strs[i]);
    }
    return directions;
  }
}
