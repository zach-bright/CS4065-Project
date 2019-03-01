import java.io.*;

/**
 * Class ConfigReader
 *
 * A big-ass wrapper for reading a config file and building
 * a data structure around it.
 */
class ConfigReader {
  BufferedReader configReader;
  
  ConfigReader(BufferedReader configReader) {
    this.configReader = configReader;
  }
  
  // Construct an H4 tree from the saved config file.
  // Doesn't need to be that fast, because we only call it once.
  public Tree buildH4Tree() throws IOException {
    TreeNode<Direction> root = new TreeNode("", "", null);
    Tree<Direction> h4Tree = new Tree(root);
    
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
      // and a joystick path (e.g. UUD).
      String[] splitLine = line.trim().split(" ");
      String content = splitLine[0];
      // Need to split the path string into individual directions (e.g. U)
      String[] pathStrings = splitLine[1].split("");
      // Convert to array of directions and add to tree.
      Direction[] pathDirections = Direction.stringToDirection(pathStrings);
      h4Tree.addNodeToPath(content, pathDirections);
    }
    
    return h4Tree;
  }
}
