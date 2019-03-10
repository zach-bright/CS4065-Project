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
  int currentPhraseIndex, trialCount;
  
  int trialStartTime;
  
  TestHandler(String[] phrases, String outputFileName) {
    this.phrases = phrases;
    this.writer = createWriter(outputFileName);
    this.currentPhraseIndex = 0;
    this.currentPhrase = phrases[0];
    // TODO: set this once we enable the trials (or something...)
    this.trialCount = 1;
    
    // Write header line.
    this.writer.println("Trial #\tTime Elapsed (ms)\tWPM\tL Distance");
  }
  
  /**
   * Record a test as being completed.
   */
  public void recordTest(String enteredText) {
    int trialTime = millis() - trialStartTime;
    int distance = this.levenshteinDistance(currentPhrase, enteredText);
    String wpmString = String.format("%.4f", this.wpm(enteredText, trialTime));
    this.writer.println(trialCount + "\t" + trialTime + "\t" + wpmString + "\t" + distance);
  }
  
  /**
   * Advance to next phrase. If there are no more phrases, do
   * teardown of writer (flush, close) and call teardown method in
   * parent class (CS4065Project).
   */
  public void nextTest() {
    if (currentPhraseIndex >= phrases.length - 1) {
      this.writer.flush();
      this.writer.close();
      triggerExit();
      return;
    }
    
    // Setup for next trial.
    this.trialCount++;
    this.currentPhraseIndex++;
    this.currentPhrase = this.phrases[this.currentPhraseIndex];
    trialStartTime = millis();
  }
  
  /**
   * Calculates words-per-minute.
   */
  private double wpm(String text, int time) {
    // split() is stupid and returns a non-empty array on empty string, 
    // so we need to check that before calculating wpm.
    if ("".equals(text)) {
      return 0.0;
    }
    
    double wordCount = text.trim().split("\\s+").length; //<>// //<>// //<>//
    double minutes = ((double)time / 1000) / 60;
    return wordCount / minutes;
  }
  
  /**
   * Calculate Levenshtein distance between phrases. This is the number
   * of deletions, insertions, or substitutions needed to turn phrase1
   * into phrase2. This uses dynamic programming.
   */
  private int levenshteinDistance(String p1, String p2) {
    int p1Len = p1.length();
    int p2Len = p2.length();
    
    if (p1Len == 0) {
      return p2Len;
    }
    if (p2Len == 0) {
      return p1Len;
    }
    
    // Array to hold distances from p1.substring(0, i) to p2.substring(0, j)
    // for each i < p1.length and j < p2.length.
    int[][] dist = new int[p1Len + 1][p2Len + 1];
    
    // Distances for first row and column is 0, 1, 2...
    for (int a = 0; a <= p1Len; a++) {
      dist[a][0] = a;
    }
    for (int b = 0; b <= p2Len; b++) {
      dist[0][b] = b;
    }
    
    // Build up the distance array.
    int subCost; //<>// //<>// //<>//
    for (int j = 1; j <= p2Len; j++) {
      for (int i = 1; i <= p1Len; i++) {
        // If chars are the same, substitution is cost 0.
        if (p1.charAt(i - 1) == p2.charAt(j - 1)) {
          subCost = 0;
        } else {
          subCost = 1;
        }
        // Choose to either substitute (0 or 1 cost), delete (1 cost),
        // or insert (1 cost) a character.
        dist[i][j] = tripleMin(
          dist[i - 1][j] + 1,
          dist[i][j - 1] + 1,
          dist[i - 1][j - 1] + subCost
        );
      }
    }
    
    // Return optimal distance.
    return dist[p1Len][p2Len];
  }
  
  /** 
   * Minimum of three integers.
   */
  private int tripleMin(int a, int b, int c) {
    int min = a;
    if (b < min) {
      min = b;
    }
    if (c < min) {
      min = c;
    }
    return min;
  }
  
  public String getCurrentPhrase() {
    return currentPhrase;
  }
}
