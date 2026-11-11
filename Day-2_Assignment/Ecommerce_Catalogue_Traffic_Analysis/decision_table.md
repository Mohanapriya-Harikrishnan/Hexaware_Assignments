# Decision Table

| Problem | Data structure / pattern used | Reason for choosing it |
|---|---|---|
| Product category insertion, search and traversal | Binary Search Tree (BST) | Keeps values in sorted order and supports searching by comparing the category at each node. Inorder traversal prints categories alphabetically. |
| SKU look-up | Hash table with chaining; Java HashMap | Hashing maps an SKU to a bucket for quick access. Chaining stores multiple entries in the same bucket when a collision occurs. HashMap is used as the built-in comparison. |
| Microservice deployment dependencies | Directed graph, BFS topological sorting and DFS cycle detection | A graph represents dependencies between services. BFS-based topological sorting gives an order that respects dependencies. DFS detects a back edge, which indicates a cycle. |
| Busiest continuous 3-hour period | Sliding window | Instead of adding every group of three hours from the beginning, the window reuses the previous total by adding the new hour and removing the hour that leaves. |
| Gift-card matching pairs | Two pointers | Since the order values are sorted, the left and right pointers can move inward depending on whether their sum is below or above the target. |
