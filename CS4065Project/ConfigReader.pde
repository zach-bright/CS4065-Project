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
  
  /**
   * Construct an H4 tree from the saved config file.
   * Doesn't need to be that fast, because we only call it once.
   */
  public Tree<Direction> buildH4Tree() throws IOException {
    TreeNode<Direction> root = new TreeNode("", "", null);
    Tree<Direction> h4Tree = new Tree(root);
    
    // Run through every line in the file.
    String line;
    while ((line = configReader.readLine()) != null) {
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
  
  /**
   * Construct a Graph from a saved config file, to be used in the soft kb.
   */
  public Graph<Direction> buildSoftGraph() throws IOException {
    DirectionalGraphBuilder dgb = new DirectionalGraphBuilder();
    
    String line;
    while ((line = configReader.readLine()) != null) {
      // Each line has key content, then a tab, then tab-separated connections.
      // So, split off the content and leave the connection list.
      String[] splitLine = line.trim().split("\t", 2);
      String content = splitLine[0];
      // Each tab-separated connection string contains a space-separated list 
      // of neighbor nodes that can be reached in a direction.
      String[][] neighbors = new String[4][];
      String[] unsplitNeighbors = splitLine[1].split("\t");
      for (int i = 0; i < 4; i++) {
        neighbors[i] = unsplitNeighbors[i].split(" ");
      }
      
      dgb.addNode(content, neighbors);
    }
    
    // Set current node to "q".
    dgb.setStartingPoint("q");
    return dgb.getGraph();
  }
}
