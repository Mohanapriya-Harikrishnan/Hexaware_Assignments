class BSTCategories {
    private static class Node {
        String category;
        Node left, right;

        Node(String category) {
            this.category = category;
        }
    }

    private Node root;

    void insert(String category) {
        root = insert(root, category);
    }

    private Node insert(Node current, String category) {
        if (current == null) return new Node(category);

        int compare = category.compareToIgnoreCase(current.category);
        if (compare < 0) current.left = insert(current.left, category);
        else if (compare > 0) current.right = insert(current.right, category);
        return current;
    }

    boolean search(String category) {
        Node current = root;
        while (current != null) {
            int compare = category.compareToIgnoreCase(current.category);
            if (compare == 0) return true;
            current = compare < 0 ? current.left : current.right;
        }
        return false;
    }

    private void inorder(Node node) {
        if (node == null) return;
        inorder(node.left);
        System.out.print(node.category + " | ");
        inorder(node.right);
    }

    private void preorder(Node node) {
        if (node == null) return;
        System.out.print(node.category + " | ");
        preorder(node.left);
        preorder(node.right);
    }

    private void postorder(Node node) {
        if (node == null) return;
        postorder(node.left);
        postorder(node.right);
        System.out.print(node.category + " | ");
    }

    void printTraversals() {
        System.out.print("Inorder:   ");
        inorder(root);
        System.out.println();
        System.out.print("Preorder:  ");
        preorder(root);
        System.out.println();
        System.out.print("Postorder: ");
        postorder(root);
        System.out.println();
    }

    static void run() {
        String[] categories = {
            "Electronics", "Books", "Clothing", "Home", "Beauty",
            "Sports", "Toys", "Groceries", "Furniture", "Footwear",
            "Jewellery", "Kitchen", "Mobiles", "Laptops", "Stationery"
        };

        BSTCategories tree = new BSTCategories();
        for (String category : categories) tree.insert(category);

        tree.printTraversals();
        System.out.println("Search 'Mobiles': " + (tree.search("Mobiles") ? "Category found" : "Category not found"));
        System.out.println("Search 'Medicines': " + (tree.search("Medicines") ? "Category found" : "Category not found"));
    }
}
