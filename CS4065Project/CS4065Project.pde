import net.java.games.input.*;
import org.gamecontrolplus.*;
import org.gamecontrolplus.gui.*;

import java.io.*;
import javax.swing.JOptionPane;

final String configFolder = "config";
final String configH4 = "H4-connections.txt";
final String configSoft = "Soft-connections.txt";

final color black = #252525;
final color highlight = #F1F1F1;
final color background = #DDCCA1;
PFont presentedTextFont, enteredTextFont, buttonFont;

ControlIO control;
ControlDevice device;
ControlButton selectionButton;
ControlHat joystick;

KeyboardModule kbModule;
InputMethod inMethod;

BufferedReader configFile;

void setup() {
  // Initialize interface stuff.
  size(900, 600);
  surface.setTitle("Experiment");
  frameRate(60);
  
  // Load fonts.
  presentedTextFont = loadFont("Georgia-Bold-32.vlw");
  enteredTextFont = loadFont("Georgia-26.vlw");
  buttonFont = loadFont("Arial-BoldMT-16.vlw");

  // TODO: Move all of this into a method that asks the user about picking 
  //       various "conditions", which decide input method + kb module. 
  //       Basically, what we did in assignment 2.
  try {
    // Construct the H4 Tree.
    configFile = createReader(configFolder + File.separator + configH4);
    ConfigReader cr = new ConfigReader(configFile);
    Tree<Direction> tc = cr.buildH4Tree();
    
    // Create keyboard module, attach the tree, and register and input method.
    kbModule = new H4Keyboard(tc);
    inMethod = new WASD(this, kbModule);
  } catch (IOException ioe) {
    JOptionPane.showMessageDialog(null, "Config format incorrect: " + ioe.getMessage());
  }
}

void draw() {
  background(background);
  
  // Draw parts of the UI that both keyboards share.
  drawCommonUI("Lorem ipsum dolor sit.", "Lorem ipsum");
  
  kbModule.render();
}

// Draws UI elements common between keyboards.
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
