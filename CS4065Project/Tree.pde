/**
 * Class Node
 * 
 * Contains a label and content. Links to 0-to-1 parent and 0-to-many
 * chilren nodes.
 */
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

/**
 * Class Tree
 * 
 * Essentially a wrapper for the root node. Contains methods that
 * help process the tree as a whole.
 */
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

/**
 * Class TreeCrawler
 * 
 * Utility class that helps with traversing up and down trees.
 */
class TreeCrawler {
  Node currentNode;
  Node root;
  
  TreeCrawler(Node root) {
    this.root = root;
    this.currentNode = root;
  }
  
  // Goes to child node with the provided label.
  // If this isn't present, return null;
  Node crawlDown(String label) {
    Node next = this.currentNode.getChildFromLabel(label);
    if (next != null) {
      currentNode = next;
    }
    return next;
  }
  
  // Goes to parent node. If root, return null.
  Node crawlUp() {
    if (currentNode.parent == null) {
      return null;
    }
    currentNode = currentNode.parent;
    return currentNode;
  }
  
  // Reset current node to the tree root.
  void rewind() {
    currentNode = root;
  }
}
