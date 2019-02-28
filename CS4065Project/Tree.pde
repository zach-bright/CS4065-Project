/**
 * Class TreeNode
 * 
 * Contains a label and content. Links to 0-to-1 parent and 0-to-many
 * chilren TreeNodes.
 */
class TreeNode {
  ArrayList<TreeNode> children;
  TreeNode parent;
  String content, label;
  
  TreeNode(String content, String label, TreeNode parent) {
    this.content = content;
    this.label = label;
    this.parent = parent;
    children = new ArrayList<TreeNode>();
  }
  
  void addChild(TreeNode child) {
    children.add(child);
  }
  
  ArrayList<TreeNode> getChildren() {
    return children;
  }
  
  // Search for child containing the label.
  TreeNode getChildFromLabel(String label) {
    for (TreeNode n : children) {
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
 * Contains a root node and methods to add or search down paths. Also, the 
 * ability to crawl up and down the tree is provided.
 */
class Tree {
  TreeNode currentTreeNode;
  TreeNode root;
  
  Tree(TreeNode root) {
    this.root = root;
    this.currentTreeNode = root;
  }
  
  // Follows a path down from root, creating nodes as necessary, and places  
  // a new node containing the provided content at the last place.
  void addNodeToPath(String content, String[] labelPath) {
    TreeNode currentNode = root;
    
    // Traverse down (making new nodes as necessary) to 2nd-last label.
    for (int i = 0; i < labelPath.length - 1; i++) {
      String label = labelPath[i];
      TreeNode nextNode = currentNode.getChildFromLabel(label);
      
      // Create nodes if necessary.
      if (nextNode == null) {
        nextNode = new TreeNode(null, label, currentNode);
        currentNode.addChild(nextNode);
      }
      
      currentNode = nextNode;
    }
    
    // Create new node and add it.
    TreeNode newNode = new TreeNode(content, labelPath[labelPath.length - 1], currentNode);
    currentNode.addChild(newNode);
  }
  
  // Trace a series of labels and return the TreeNode it leads to.
  // If a step fails, return null.
  TreeNode tracePath(String[] labelPath) {
    TreeNode currentTreeNode = root;
    for (String label : labelPath) {
      currentTreeNode = root.getChildFromLabel(label);
      if (currentTreeNode == null) {
        return null;
      }
    }
    return currentTreeNode;
  }
  
  // Goes to child TreeNode with the provided label.
  // If this isn't present, return null and stay.
  TreeNode crawlDown(String label) {
    TreeNode next = this.currentTreeNode.getChildFromLabel(label);
    if (next != null) {
      currentTreeNode = next;
    }
    return next;
  }
  
  // Goes to parent TreeNode. If root, return null and stay.
  TreeNode crawlUp() {
    if (currentTreeNode.parent == null) {
      return null;
    }
    currentTreeNode = currentTreeNode.parent;
    return currentTreeNode;
  }
  
  // Reset current TreeNode to the tree root.
  void rewind() {
    currentTreeNode = root;
  }
}
