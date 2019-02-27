import java.io.*;

class ConfigReader {
  BufferedReader configReader;
  
  ConfigReader(BufferedReader configReader) {
    this.configReader = configReader;
  }
  
  // Construct an H4 tree from the saved config file.
  public Tree buildH4Tree() throws IOException {
    TreeNode root = new TreeNode("", "", null);
    Tree h4Tree = new Tree(root);
    
    // Run through every line in the file.
    String line;
    while ((line = configReader.readLine()) != null) {
      try {
        line = configReader.readLine();
      } catch (IOException e) {
        // TODO: handle ioexception
        return null;
      }
      
      // Config lines contain some content (e.g. p), a space, 
      // and a joystick path (e.g. UUD)
      String[] splitLine = line.split(" ");
      String content = splitLine[0].trim();
      // Need to split the path string into individual directions (e.g. U)
      String[] path = splitLine[1].trim().split("");
      // Make sure path is valid before adding to tree.
      if (!this.validPath(path)) {
        throw new IOException("A path was invalid.");
      }
      
      h4Tree.addNodeToPath(content, path);
    }
    
    return h4Tree;
  }
  
  // Makes sure path elements are U, D, L, or R
  private boolean validPath(String[] path) {
    for (String p : path) {
      if (!(p.equals("U") || p.equals("D") || p.equals("L") || p.equals("R"))) {
         return false;
      }
    }
    return true;
  }
}
