/**
 * Class MapNode
 *
 * Contains label and content, and connects to surrounding
 * MapNodes bidirectionally.
 */
class MapNode {
  ArrayList<MapNode> connectedNodes;
  String label, content;
  
  MapNode(String label, String content) {
    this.label = label;
    this.content = content;
    this.connectedNodes = new ArrayList<>();
  }
  
  void addConnection(MapNode node) {
    connectedNodes.add(node);
  }
  
  ArrayList<MapNode> getConnections() {
    return connectedNodes;
  }
  
  // Search for child containing the label.
  MapNode getChildFromLabel(String label) {
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
class Map {
  ArrayList<MapNode> nodes;
  MapNode currentNode;
  
  Map(ArrayList<MapNode> nodes, int startingIndex) {
    this.nodes = nodes;
    currentNode = nodes.get(startingIndex);
  }
  
  Map() {
    this.nodes = new ArrayList<MapNode>();
    currentNode = null;
  }
  
  // Crawl to a node with provided label. If none is found, 
  // return null and stay.
  MapNode crawl(String label) {
    MapNode next = this.currentNode.getChildFromLabel(label);
    if (next != null) {
      currentNode = next;
    }
    return next;
  }
}
