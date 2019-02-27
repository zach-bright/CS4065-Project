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
 * Essentially a wrapper for the root TreeNode. Contains methods that
 * help process the tree as a whole.
 */
class Tree {
  TreeNode root;
  
  Tree(TreeNode root) {
    this.root = root;
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
}

/**
 * Class TreeCrawler
 * 
 * Utility class that helps with traversing up and down trees.
 */
class TreeCrawler {
  TreeNode currentTreeNode;
  TreeNode root;
  
  TreeCrawler(TreeNode root) {
    this.root = root;
    this.currentTreeNode = root;
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
