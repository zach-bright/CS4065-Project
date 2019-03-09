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
   * Construct a Graph from a saved config file, to be used
   * in the soft keyboard.
   */
  public Graph<Direction> buildSoftGraph() throws IOException {
    Graph<Direction> softGraph = new Graph();
    
    String line;
    while ((line = configReader.readLine()) != null) {
      // Config line has some key content, then a tab, then space-separated 
      // neighbor keys in order U R D L (clockwise).
      String[] splitLine = line.trim().split("\t");
      String content = splitLine[0];
      String[] neighbors = splitLine[1].split(" ");
      
      // Create a node representing this line's content.
      GraphNode center = new GraphNode(content);
      // Make a map from center to neighbor nodes and fill with content.
      Map<Direction, GraphNode> neighborNodes = new HashMap<Direction, GraphNode>();
      neighborNodes.put(Direction.UP, new GraphNode(neighbors[0]));
      neighborNodes.put(Direction.RIGHT, new GraphNode(neighbors[1]));
      neighborNodes.put(Direction.DOWN, new GraphNode(neighbors[2]));
      neighborNodes.put(Direction.LEFT, new GraphNode(neighbors[3]));
      // Add to the graph.
      softGraph.addNode(center, neighborNodes);
    }
    
    // Set current node to "q".
    softGraph.currentNode = softGraph.getNodeWithKey("q");
    return softGraph;
  }
}
