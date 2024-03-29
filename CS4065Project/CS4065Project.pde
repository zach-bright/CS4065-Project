import org.gamecontrolplus.gui.*;
import net.java.games.input.*;
import org.gamecontrolplus.*;

import javax.swing.JOptionPane;
import java.util.*;
import java.io.*;

final String configFolder = "config";
final String configH4 = "h4-connections.txt";
final String configSoft = "soft-connections.txt";
final String configPhrases = "phrases.txt";
final String configPhraseCount = "phrase-count.txt";

final color black = #252525;
final color buttonUnselected = #FFFFFF;
final color buttonSelected = #FFFB8B;
final color highlight = #F1F1F1;
final color background = #DDCCA1;
PFont presentedTextFont, enteredTextFont, buttonFont;

KeyboardModule kbModule;
InputMethod inMethod;
TestHandler tHandler;
String userId;
int kbCondition, inCondition;

boolean isFinished = false;

void setup() {
  // Initialize interface stuff.
  size(900, 600);
  surface.setTitle("Experiment");
  frameRate(60);
  
  // Load fonts.
  presentedTextFont = loadFont("Georgia-Bold-32.vlw");
  enteredTextFont = loadFont("Georgia-26.vlw");
  
  try {
    // Ask for keyboard and input conditions.
    kbCondition = getKbCondition();
    inCondition = getInputCondition();
    
    // Get user ID, use it to make output filename, build test handler obj.
    userId = getUserId();
    String timestamp = day() + "-" + month() + "-" + year();
    // kb and in condition are added to avoid overwriting files.
    String outputFileName = 
      "User-" + userId + "_" + "cond-" + kbCondition + "-" + inCondition + "_" + timestamp + ".txt";
    
    // Get phrase list and phrase count data and create test handler.
    String[] phraseList = loadStrings(configFolder + File.separator + configPhrases);
    String[] phraseCounts = loadStrings(configFolder + File.separator + configPhraseCount);
    for (int i = 0; i < phraseCounts.length; i++) {
      String s = phraseCounts[i];
      phraseCounts[i] = s.substring(s.indexOf("=") + 1);
    }
    tHandler = new TestHandler(
      new ArrayList<String>(Arrays.asList(phraseList)), 
      outputFileName,
      int(phraseCounts[0]),
      int(phraseCounts[1])
    );
    
    // Create kb and input modules.
    kbModule = buildKeyboardModule();
    inMethod = buildInputMethod();
    
    showPracticePopup();
  } catch (IOException ioe) {
    JOptionPane.showMessageDialog(null, "Config format incorrect: " + ioe.getMessage());
    exit();
  }
}

void draw() {
  background(background);
  
  // Draw parts of the UI that both keyboards share.
  drawCommonUI(tHandler.getCurrentPhrase(), kbModule.getEnteredText());
  
  // Render keyboard UI.
  kbModule.render();
  
  if(inMethod instanceof Joystick){
    ((Joystick) inMethod).handleInput();
  }
  if (isFinished) {
    // If all tests are done, notify user and exit.
    showExitDialog();
    exit();
    return;
  }
}

/**
 * Ask user for an ID to use to record their data.
 */
String getUserId() {
  return JOptionPane.showInputDialog(frame, "Please enter user ID.", 
    "User ID", JOptionPane.PLAIN_MESSAGE
  );
}

/**
 * Ask user for the keyboard condition value.
 */
int getKbCondition() {
  return JOptionPane.showOptionDialog(frame, 
    "Please choose 1st condition.", "Condition", 
    JOptionPane.DEFAULT_OPTION, JOptionPane.PLAIN_MESSAGE, 
    null, new String[] {"Condition A", "Condition B"}, 0
  );
}

/**
 * Ask user for the input condition value.
 */
int getInputCondition() {
  return JOptionPane.showOptionDialog(frame, 
    "Please choose 2nd condition.", "Condition", 
    JOptionPane.DEFAULT_OPTION, JOptionPane.PLAIN_MESSAGE, 
    null, new String[] {"Condition A", "Condition B"}, 0
  );
}

/**
 * Ask what keyboard to use, then builds and returns corresponding KB module.
 */
KeyboardModule buildKeyboardModule() throws IOException {
  KeyboardModule chosenKB;
  if (kbCondition == 0) {
    // Condition 0 is for the H4-Writer keyboard.
    BufferedReader configFile = createReader(configFolder + File.separator + configH4);
    ConfigReader cr = new ConfigReader(configFile);
    Tree<Direction> tc = cr.buildH4Tree();
    chosenKB = new H4Keyboard(tc, tHandler);
    buttonFont = loadFont("Arial-BoldMT-16.vlw");
  } else {
    // Condition 1 is for the Soft keyboard.
    BufferedReader configFile = createReader(configFolder + File.separator + configSoft);
    ConfigReader cr = new ConfigReader(configFile);
    Graph<Direction> tc = cr.buildSoftGraph();
    chosenKB = new SoftKeyboard(tc, tHandler);
    buttonFont = loadFont("Arial-BoldMT-20.vlw");
  }
  return chosenKB;
}

/**
 * Ask what method to use, then builds and returns corresponding input method.
 */
InputMethod buildInputMethod() throws IOException {
  InputMethod chosenIn;
  if (inCondition == 0) {
    // Condition 0 is for WASD input.
    chosenIn = new WASD(this, kbModule);
  } else {
    // Condition 1 is for Joystick input.
    chosenIn = new Joystick(this, kbModule);
  }
  return chosenIn;
}

/**
 * Draw UI elements common between keyboard modules.
 */
void drawCommonUI(String presentedText, String enteredText) {
  // Draw the presented text (text to be written).
  fill(black);
  textFont(presentedTextFont);
  textAlign(CENTER, TOP);
  text(presentedText, width/2, 46);
  
  // Draw entered text (what user wrote) on a rectangular bkg.
  fill(highlight);
  rect(60, 110, 780, 40);
  fill(black);
  textFont(enteredTextFont);
  textAlign(LEFT, TOP);
  text(enteredText, 70, 120);
  
  // Draw rectangle that the keyboard will be drawn over.
  fill(highlight);
  rect(60, 160, 780, 390);
}

/**
 * Tell user that the next trials will be practice.
 */
void showPracticePopup() {
  JOptionPane.showMessageDialog(
    null,
    "The following trials are for practice and will not be recorded."
  );
}

/**
 * Tell user that the next trials will be recorded.
 */
void showRecordingPopup() {
  JOptionPane.showMessageDialog(
    null, 
    "Practice complete. The following trials will be recorded."
  );
}

/**
 * Trigger exit dialog (and program exit) next frame.
 */
void triggerExit() {
  isFinished = true;
}

/**
 * Show a little dialog telling the user the program is gonna exit. 
 */
void showExitDialog() {
  JOptionPane.showMessageDialog(null, "All trials are complete, exiting now...");
}
