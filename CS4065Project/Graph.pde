/**
 * Class GraphNode
 *
 * Container for the content of the node.
 */
class GraphNode implements Comparable<GraphNode> {
  String content;
  Button button;
  int buttonOrder = -1;
  
  GraphNode(String content, Button button, int buttonOrder) {
    this.content = content;
    this.button = button;
    this.buttonOrder = buttonOrder;
  }
  
  GraphNode(String content, int buttonOrder) {
    this.content = content;
    this.button = new Button(content);
    this.buttonOrder = buttonOrder;
  }
  
  GraphNode(String content) {
    this.content = content;
    this.button = new Button(content);
  }
  
  public int compareTo(GraphNode g) {
    return this.buttonOrder - g.buttonOrder;
  }
  
  @Override
  public boolean equals(Object other) {
    if (other == this) {
      return true;
    } else if (!(other instanceof GraphNode)) {
      return false;
    }
    return ((GraphNode)other).content.equals(this.content);
  }
  
  @Override
  public int hashCode() {
    return content.hashCode();
  }
}

/**
 * Class Graph<T>
 *
 * Contains a list of nodes. Helps with traversal by containing
 * a current node + methods to move to surrounding nodes.
 * Implemented using an adjacency list.
 */
class Graph<T extends Enum<T>> {
  GraphNode currentNode;
  Class<T> labelEnum;
  Map<GraphNode, Map<T, GraphNode>> nodeMap;
  
  Graph(Class<T> labelEnum) {
    this.currentNode = null;
    this.labelEnum = labelEnum;
    this.nodeMap = new TreeMap<GraphNode, Map<T, GraphNode>>();
  }
  
  void addNode(GraphNode node, Map<T, GraphNode> neighbors) {
    nodeMap.put(node, neighbors);
  }
  
  void addNode(GraphNode node) {
    nodeMap.put(node, new EnumMap<T, GraphNode>(this.labelEnum));
  }
  
  GraphNode getNodeWithKey(String k) {
    for (GraphNode g : nodeMap.keySet()) {
      if (g.content.equals(k)) {
        return g;
      }
    }
    return null;
  }
  
  // Crawl to a node with provided label. If none is found, return
  // null and stay.
  GraphNode crawl(T label) {
    this.currentNode.button.toggleSelected(); //<>//
    this.currentNode = nodeMap.get(this.currentNode).get(label);
    this.currentNode.button.toggleSelected();
    return this.currentNode;
  }
  
  String getCurrentContent() {
    return this.currentNode.content;
  }
}

/**
 * Class DirectionalGraphBuilder
 *
 * Handles creating a Graph correctly by avoiding duplicate map
 * entries, storing with the correct buttonOrder, etc.
 */
class DirectionalGraphBuilder {
  Graph<Direction> graph;
  Map<GraphNode, GraphNode> allNodes;
  int currentButton = 0;
  
  DirectionalGraphBuilder() {
    this.graph = new Graph<Direction>(Direction.class);
    this.allNodes = new HashMap<GraphNode, GraphNode>();
  }
  
  /**
   * Add a node to the graph, but be careful about it. 
   *
   * Since nodes contain a button, its possible for a node to .equals 
   * another node but have different buttons attached. To avoid this, 
   * we store all nodes in a node->node map and check it before adding. 
   * If a node already exists, use it instead of making a new one.
   */
  void addNode(String firstNode, String[] neighbors) {
    // Node-ify the first string (i.e. the "center")
    GraphNode node = this.getNonDupeNode(new GraphNode(firstNode));
    node.buttonOrder = this.currentButton++;
    
    // Node-ify the neighbor strings.
    Map<Direction, GraphNode> neighborMap 
      = new EnumMap<Direction, GraphNode>(Direction.class);
    GraphNode neighborNode;
    for (int i = 0; i < 4; i++) {
      neighborNode = this.getNonDupeNode(new GraphNode(neighbors[i]));
      neighborMap.put(Direction.values()[i], neighborNode);
    }
    
    // Add to graph.
    this.graph.addNode(node, neighborMap);
  }
  
  /**
   * Set currentNode in graph to a string, and mark it as selected.
   */
  void setStartingPoint(String startingString) {
    GraphNode startNode = this.graph.getNodeWithKey(startingString);
    startNode.button.toggleSelected();
    this.graph.currentNode = startNode;
  }
  
  /**
   * Checks node->node map to see if the passed node is already present.
   * If a node is found, return it, otherwise return the passed node.
   * Dupe is just short for duplicate, since the name was getting long.
   */
  private GraphNode getNonDupeNode(GraphNode node) {
    GraphNode otherNode = allNodes.get(node);
    if (otherNode != null) {
      return otherNode;
    }
    
    // If this isn't a duplicate, add to the map.
    allNodes.put(node, node);
    return node;
  }
  
  Graph<Direction> getGraph() {
    return this.graph;
  }
}
