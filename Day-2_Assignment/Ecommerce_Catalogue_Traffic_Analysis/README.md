# E-Commerce Catalogue and Traffic Analysis

This is a small Java console project for the five tasks in Set 1. Each DSA implementation is kept in a separate Java file so it is easier to read, test and update.

## Project structure

```text
Ecommerce_Catalogue_Traffic_Analysis/
├── src/
│   ├── Main.java
│   ├── BSTCategories.java
│   ├── SKUHashTable.java
│   ├── MicroserviceGraph.java
│   ├── TrafficAnalysis.java
│   └── GiftCardPairs.java
├── output/
│   └── execution_output.txt
├── decision_table.md
├── README.md
└── .gitignore
```

## Requirements

- JDK 17 or later
- VS Code with the Java Extension Pack (or any editor with `javac`)


## What each file does

1. **BSTCategories.java** – inserts 15 product categories, searches for a category and prints inorder, preorder and postorder traversals.
2. **SKUHashTable.java** – implements a hash table using linked-list chaining, demonstrates a collision and compares look-up time with Java's `HashMap` for 100,000 SKUs.
3. **MicroserviceGraph.java** – represents deployment dependencies as a directed graph, uses BFS-based topological sorting to get a deployment order and DFS to detect a cycle.
4. **TrafficAnalysis.java** – uses a sliding window to find the busiest continuous three-hour period from 24 hourly request counts.
5. **GiftCardPairs.java** – uses two pointers on a sorted list of order values to find pairs that match the gift-card amount.

## Notes

- In the graph, an edge `A -> B` means A must be deployed before B. Therefore, if Cart needs Pricing and Pricing needs Inventory, the deployment order is Inventory, Pricing, then Cart.
- The traffic input represents requests in each hour, not requests per minute. The 3-hour window is calculated from these 24 hourly totals.
- HashMap and custom-table timings depend on the computer and system load. Run the program on your own laptop and use the timings printed there in your submitted output.
- The values used in the program are sample values for demonstrating the algorithms. They can be changed if your faculty has provided a specific dataset.
