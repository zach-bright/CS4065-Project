/**
 * Class MapNode
 *
 * Contains label and content, and connects to surrounding
 * MapNodes bidirectionally.
 */
class MapNode<T> {
  List<MapNode> connectedNodes;
  String content;
  T label;
  
  MapNode(String content, T label) {
    this.label = label;
    this.content = content;
    this.connectedNodes = new ArrayList<MapNode>();
  }
  
  void addConnection(MapNode node) {
    connectedNodes.add(node);
  }
  
  List<MapNode> getConnections() {
    return connectedNodes;
  }
  
  // Search for child containing the label.
  MapNode getChildFromLabel(T label) {
    for (MapNode n : connectedNodes) {
      if (n.label.equals(label)) {
        return n;
      }
    }
    return null;
  }
}

/**
 * Class Map
 *
 * Contains a list of nodes. Helps with traversal by containing
 * a current node + methods to move to surrounding nodes.
 */
class Map<T> {
  List<MapNode<T>> nodes;
  MapNode currentNode;
  
  Map(List<MapNode<T>> nodes, int startingIndex) {
    this.nodes = nodes;
    currentNode = nodes.get(startingIndex);
  }
  
  Map() {
    this.nodes = new ArrayList<MapNode<T>>();
    currentNode = null;
  }
  
  // Crawl to a node with provided label. If none is found, 
  // return null and stay.
  MapNode crawl(T label) {
    MapNode next = this.currentNode.getChildFromLabel(label);
    if (next != null) {
      currentNode = next;
    }
    return next;
  }
  
  String getCurrentContent() {
    return this.currentNode.content;
  }
}
