/**
 * Class GraphNode
 *
 * Container for the content of the node.
 */
class GraphNode {
  String content;
  Button button;
  
  GraphNode(String content, Button button) {
    this.content = content;
    this.button = button;
  }
  
  GraphNode(String content) {
    this.content = content;
    this.button = new Button(content);
  }
  
  @Override
  public boolean equals(Object other) {
    if (other == this) {
      return true;
    } else if (!(other instanceof GraphNode)) {
      return false;
    }
    return ((GraphNode)other).content.equals(this.content); //<>//
  }
  
  @Override
  public int hashCode() {
    return content.hashCode();
  }
}

/**
 * Class Graph
 *
 * Contains a list of nodes. Helps with traversal by containing
 * a current node + methods to move to surrounding nodes.
 * Implemented using an adjacency list.
 */
class Graph<T> {
  GraphNode currentNode;
  Map<GraphNode, Map<T, GraphNode>> nodeMap;
  List<GraphNode> mapKeys;
  
  Graph() {
    currentNode = null;
    nodeMap = new HashMap<GraphNode, Map<T, GraphNode>>();
    mapKeys = new ArrayList<GraphNode>();
  }
  
  void addNode(GraphNode node, Map<T, GraphNode> neighbors) {
    nodeMap.put(node, neighbors);
    mapKeys.add(node);
  }
  
  GraphNode getNodeWithKey(String k) {
    for (GraphNode g : mapKeys) {
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
    return currentNode;
  }
  
  String getCurrentContent() {
    return this.currentNode.content;
  }
}
