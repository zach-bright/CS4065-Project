import org.gamecontrolplus.gui.*;
import net.java.games.input.*;
import org.gamecontrolplus.*;

import javax.swing.JOptionPane;
import java.util.*;
import java.io.*;

final String configFolder = "config";
final String configH4 = "H4-connections.txt";
final String configSoft = "Soft-connections.txt";

final color black = #252525;
final color highlight = #F1F1F1;
final color background = #DDCCA1;
PFont presentedTextFont, enteredTextFont, buttonFont;

KeyboardModule kbModule;
InputMethod inMethod;
int kbCondition, inCondition;

void setup() {
  // Initialize interface stuff.
  size(900, 600);
  surface.setTitle("Experiment");
  frameRate(60);
  
  // Load fonts.
  presentedTextFont = loadFont("Georgia-Bold-32.vlw");
  enteredTextFont = loadFont("Georgia-26.vlw");
  buttonFont = loadFont("Arial-BoldMT-16.vlw");
  
  // Ask user for the two conditions.
  try {
    kbModule = buildKeyboardModule();
    inMethod = buildInputMethod();
  } catch (IOException ioe) {
    JOptionPane.showMessageDialog(null, "Config format incorrect: " + ioe.getMessage());
    exit();
  }
}

void draw() {
  background(background);
  
  // Draw parts of the UI that both keyboards share.
  drawCommonUI("Lorem ipsum dolor sit.", kbModule.getEnteredText());
  
  kbModule.render();
}

/**
 * Ask what keyboard to use, then builds and returns corresponding KB module.
 */
KeyboardModule buildKeyboardModule() throws IOException {
  // Get condition value.
  kbCondition = JOptionPane.showOptionDialog(frame, 
    "Please choose 1st condition.", "Condition", 
    JOptionPane.DEFAULT_OPTION, JOptionPane.PLAIN_MESSAGE, 
    null, new String[] {"Condition A", "Condition B"}, 0
  );
  
  KeyboardModule chosenKB;
  if (kbCondition == 0) {
    // Condition 0 is for the H4-Writer keyboard.
    BufferedReader configFile = createReader(configFolder + File.separator + configH4);
    ConfigReader cr = new ConfigReader(configFile);
    Tree<Direction> tc = cr.buildH4Tree();
    chosenKB = new H4Keyboard(tc);
  } else {
    // Condition 1 is for the Soft keyboard.
    // TODO: Write condition 1 initializer.
    throw new IOException("Condition not implemented.");
  }
  return chosenKB;
}

/**
 * Ask what method to use, then builds and returns corresponding input method.
 */
InputMethod buildInputMethod() throws IOException {
  // Get condition value.
  inCondition = JOptionPane.showOptionDialog(frame, 
    "Please choose 2nd condition.", "Condition", 
    JOptionPane.DEFAULT_OPTION, JOptionPane.PLAIN_MESSAGE, 
    null, new String[] {"Condition A", "Condition B"}, 0
  );
  
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
