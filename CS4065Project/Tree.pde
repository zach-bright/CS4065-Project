class Node {
  ArrayList<Node> children;
  Node parent;
  String content, label;
  
  Node(String content, String label, Node parent) {
    this.content = content;
    this.label = label;
    this.parent = parent;
    children = new ArrayList<>();
  }
  
  void addChild(Node child) {
    children.add(child);
  }
  
  ArrayList<Node> getChildren() {
    return children;
  }
  
  // Search for child containing the label.
  Node getChildFromLabel(String label) {
    for (Node n : children) {
      if (n.label.equals(label)) {
        return n;
      }
    }
    return null;
  }
}

class Tree {
  Node root;
  
  Tree(Node root) {
    this.root = root;
  }
  
  // Trace a series of labels and return the node it leads to.
  // If a step fails, return null.
  Node tracePath(String[] labelPath) {
    Node currentNode = root;
    for (String label : labelPath) {
      currentNode = root.getChildFromLabel(label);
      if (currentNode == null) {
        return null;
      }
    }
    return currentNode;
  }
}
