/**
 * Class InputMethod
 *
 * InputMethod classes translate a subset of user input (e.g. some keys on
 * the keyboard, a joystick + one key, etc.) into directions to be passed on
 * to an attached keyboard module. To do this, classes should attach custom 
 * input handlers through the use of PApplet.
 */
public abstract class InputMethod {
  PApplet applet;
  KeyboardModule kbModule;
  
  /**
   * Registers the applet and module with this input method.
   */
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
public class WASD extends InputMethod {
  WASD(PApplet applet, KeyboardModule kbModule) {
    super(applet, kbModule);
    applet.registerMethod("keyEvent", this);
  }
  
  /**
   * Convert a released-key event into a form that kbModule understands,
   * and pass it to the right method. WASD->ULDR->move(ULDR), ENTER->accept().
   */
  public void keyEvent(KeyEvent event) {
    // Only accept key-release events.
    if (event.getAction() != KeyEvent.RELEASE) {
      return;
    }
    
    // Convert the key from the event into a direction.
    // I really if-else chains but its easy, so w/e.
    char k = event.getKey();
    Direction direction;
    if (k == ENTER) {
      // Enter key accepts current selection.
      kbModule.accept();
      return;
    } else if (k == 'w') {
      direction = Direction.UP;
    } else if (k == 'a') {
      direction = Direction.LEFT;
    } else if (k == 's') {
      direction = Direction.DOWN;
    } else if (k == 'd') {
      direction = Direction.RIGHT;
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
public class Joystick extends InputMethod {
  private final float deadzoneRadius = 0.7;
  
  ControlIO control;
  ControlDevice device;
  ControlButton selectionButton, upButton, downButton, leftButton, rightButton;
  ControlButton lastPressed;
  boolean pressed = false;
  ControlHat joystick;

  Joystick(PApplet applet, KeyboardModule kbModule) {
    super(applet, kbModule);
    
    control = ControlIO.getInstance(this.applet);
    List<ControlDevice> devices = control.getDevices();
    for(ControlDevice controlDevice: devices){
      if(controlDevice.toString().indexOf("XINPUT") > -1) {
        device = control.getDevice(controlDevice.toString());
        break;
      }
    }
    selectionButton = device.getButton("Button 7");
    upButton = device.getButton("Button 3");
    downButton = device.getButton("Button 0");
    leftButton = device.getButton("Button 2");
    rightButton = device.getButton("Button 1");
  }
  
  public void handleInput(){
    Direction direction;
    if(!pressed){
      if(selectionButton.pressed()){
        pressed = true;
        lastPressed = selectionButton;
        kbModule.accept();
        return;
      } else if(upButton.pressed()){
        pressed = true;
        lastPressed = upButton;
        direction = Direction.UP;
      } else if(downButton.pressed()){
        pressed = true;
        lastPressed = downButton;
        direction = Direction.DOWN;
      } else if(leftButton.pressed()){
        pressed = true;
        lastPressed = leftButton;
        direction = Direction.LEFT;
      } else if(rightButton.pressed()){
        pressed = true;
        lastPressed = rightButton;
        direction = Direction.RIGHT;
      } else {
        return;
      }
      kbModule.move(direction);
    }
    checkRelease();
  }
  
  public void checkRelease(){
    if(pressed){
      if(!lastPressed.pressed()){
        pressed = false;
        lastPressed = null;
      }
    }
  }
}
