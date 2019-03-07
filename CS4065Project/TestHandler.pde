/**
 * Class TestHandler
 *
 * Handles recording data, outputting it in the proper format, and anything
 * related to test phrases. This is mostly just dealing with everything
 * that happens after the user hits the [enter] key.
 */
class TestHandler {
  PrintWriter writer;
  String[] phrases;
  String currentPhrase;
  int currentPhraseIndex;
  
  TestHandler(String[] phrases, String outputFileName) {
    this.phrases = phrases;
    this.writer = createWriter(outputFileName);
    currentPhraseIndex = 0;
    currentPhrase = phrases[0];
  }
  
  // Record a test as being completed.
  public void recordTest(String enteredText) {
    // TODO: record some useful data here.
    writer.println();
  }
  
  // Advance to next phrase. If there are no more phrases, do
  // teardown of writer (flush, close) and call teardown method in
  // parent class (CS4065Project).
  public void nextTest() {
    if (currentPhraseIndex >= phrases.length - 1) {
      writer.flush();
      writer.close();
      triggerExit();
      return;
    }
    
    currentPhraseIndex++;
    currentPhrase = phrases[currentPhraseIndex];
  }
  
  public String getCurrentPhrase() {
    return currentPhrase;
  }
}
