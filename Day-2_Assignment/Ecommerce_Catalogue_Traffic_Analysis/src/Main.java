public class Main {
    public static void main(String[] args) {
        System.out.println("========== E-COMMERCE CATALOGUE AND TRAFFIC ANALYSIS ==========");

        System.out.println("\n1. PRODUCT CATEGORY BST");
        BSTCategories.run();

        System.out.println("\n2. SKU LOOK-UP: CHAINING VS HASHMAP");
        SKUHashTable.run();

        System.out.println("\n3. MICROSERVICE DEPLOYMENT ORDER");
        MicroserviceGraph.run();

        System.out.println("\n4. BUSIEST CONTINUOUS 3-HOUR WINDOW");
        TrafficAnalysis.run();

        System.out.println("\n5. GIFT-CARD PAIRS USING TWO POINTERS");
        GiftCardPairs.run();

        System.out.println("\n========== PROGRAM COMPLETED ==========");
    }
}
