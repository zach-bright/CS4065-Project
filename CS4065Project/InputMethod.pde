abstract class InputMethod {
  PApplet applet;
  KeyboardModule kbModule;
  
  // Registers the applet and module with this input method.
  protected InputMethod(PApplet applet, KeyboardModule kbModule) {
    this.applet = applet;
    this.kbModule = kbModule;
  }
}

/**
 * Class WASD
 *
 * Classic WASD controls, mostly for testing. Converts to ULDR and sends
 * to kbModule.
 */
class WASD extends InputMethod {
  WASD(PApplet applet, KeyboardModule kbModule) {
    super(applet, kbModule);
    applet.registerMethod("keyEvent", this);
  }
  
  // Convert a released-key event into a form that kbModule understands,
  // and pass it to the right method. WASD->ULDR->move(ULDR), ENTER->accept().
  void keyEvent(KeyEvent event) {
    // Only accept key-release events.
    if (event.getAction() != KeyEvent.RELEASE) {
      return;
    }
    
    // Convert the key from the event into a direction.
    // I really if-else chains but its easy, so w/e.
    char k = event.getKey();
    String direction;
    if (k == ENTER) {
      // Enter key accepts current selection.
      kbModule.accept();
      return;
    } else if (k == 'w') {
      direction = "U";
    } else if (k == 'a') {
      direction = "L";
    } else if (k == 's') {
      direction = "D";
    } else if (k == 'd') {
      direction = "R";
    } else {
      return;
    }
    // If key was W,A,S,D, then move.
    kbModule.move(direction);
  }
}

/**
 * Class Joystick
 * 
 * Handles polling the joystick every frame, turning this into 
 * U, D, L, or R. Also handle polling accept button (on controller).
 */
class Joystick extends InputMethod {
  final float deadzoneRadius = 0.7;
  
  ControlIO control;
  ControlDevice device;
  ControlButton selectionButton;
  ControlHat joystick;

  Joystick(PApplet applet, KeyboardModule kbModule) {
    super(applet, kbModule);
    control = ControlIO.getInstance(this.applet);
    device = control.getDevice("");         // TODO: figure out the controller we're using
    selectionButton = device.getButton(""); // TODO: find name of button we're using
    joystick = device.getHat("");           // TODO: also find joystick's name
  }
}