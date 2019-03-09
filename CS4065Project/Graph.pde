/**
 * Class GraphNode
 *
 * Container for the content of the node.
 */
class GraphNode {
  String content;
  
  GraphNode(String content) {
    this.content = content;
  }
  
  boolean equals(GraphNode otherNode) {
    return otherNode.content.equals(this.content);
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
  
  Graph() {
    currentNode = null;
    nodeMap = new HashMap<GraphNode, Map<T, GraphNode>>();
  }
  
  void addNode(GraphNode node, Map<T, GraphNode> neighbors) {
    nodeMap.put(node, neighbors);
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
    currentNode = nodeMap.get(currentNode).get(label); //<>//
    return currentNode;
  }
  
  String getCurrentContent() {
    return this.currentNode.content;
  }
}
