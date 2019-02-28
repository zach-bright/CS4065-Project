import net.java.games.input.*;
import org.gamecontrolplus.*;
import org.gamecontrolplus.gui.*;

import java.io.*;

final String configPath = "config";
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

BufferedReader configFile;

void setup() {
  // Initialize interface stuff.
  size(900, 600);
  frame.setTitle("Experiment");
  frameRate(60);
  
  // Load fonts.
  presentedTextFont = loadFont("Georgia-Bold-32.vlw");
  enteredTextFont = loadFont("Georgia-26.vlw");
  buttonFont = loadFont("Arial-BoldMT-16.vlw");

  /*
  // Load controller.
  control = ControlIO.getInstance(this);
  device = control.getDevice("");         // TODO: figure out the controller we're using
  selectionButton = device.getButton(""); // TODO: find name of button we're using
  joystick = device.getHat("");           // TODO: also find joystick's name
  
  try {
    configFile = new BufferedReader(new FileReader(configPath + File.separator + configH4));
    ConfigReader cr = new ConfigReader(configFile);
    Tree tc = cr.buildH4Tree();
  } catch (FileNotFoundException fnfe) {
    // TODO: add error for missing config
  } catch (IOException ioe) {
    // TODO: add error for failed tree build.
  }
  */
}

void draw() {
  background(background);
  
  // Draw parts of the UI that both keyboards share.
  drawCommonUI("Lorem ipsum dolor sit.", "Lorem ipsum");
}

void drawCommonUI(String presentedText, String enteredText) {
  // Draw the presented text.
  fill(black);
  textFont(presentedTextFont);
  textAlign(CENTER, TOP);
  text(presentedText, width/2, 46);
  
  // Draw entered text on a rectangular background.
  fill(highlight);
  rect(60, 110, 780, 40);
  fill(black);
  textFont(enteredTextFont);
  textAlign(LEFT, TOP);
  text(enteredText, 70, 120);
  
  // Draw rectangle for the keyboard.
  fill(highlight);
  rect(60, 160, 780, 390);
}
