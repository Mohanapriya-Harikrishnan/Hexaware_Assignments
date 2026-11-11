import java.util.HashMap;
import java.util.Map;

class SKUHashTable {
    private static class Entry {
        int sku;
        String productName;
        Entry next;

        Entry(int sku, String productName) {
            this.sku = sku;
            this.productName = productName;
        }
    }

    private final Entry[] buckets;

    SKUHashTable(int capacity) {
        buckets = new Entry[capacity];
    }

    private int hash(int sku) {
        return Math.floorMod(sku, buckets.length);
    }

    void put(int sku, String productName) {
        int index = hash(sku);
        Entry current = buckets[index];

        while (current != null) {
            if (current.sku == sku) {
                current.productName = productName;
                return;
            }
            current = current.next;
        }

        Entry newEntry = new Entry(sku, productName);
        newEntry.next = buckets[index];
        buckets[index] = newEntry;
    }

    String get(int sku) {
        Entry current = buckets[hash(sku)];
        while (current != null) {
            if (current.sku == sku) return current.productName;
            current = current.next;
        }
        return null;
    }

    static void run() {
        SKUHashTable smallTable = new SKUHashTable(10);
        smallTable.put(101, "Wireless Mouse");
        smallTable.put(111, "USB Keyboard");

        System.out.println("Collision example: SKU 101 and SKU 111 both go to bucket 1.");
        System.out.println("Lookup SKU 111 in chained table: " + smallTable.get(111));

        int skuCount = 100_000;
        SKUHashTable chainedTable = new SKUHashTable(200_003);
        Map<Integer, String> hashMap = new HashMap<>();

        for (int i = 0; i < skuCount; i++) {
            int sku = 100_000 + i;
            String name = "Product-" + sku;
            chainedTable.put(sku, name);
            hashMap.put(sku, name);
        }

        // Warm up both look-up methods before recording the time.
        for (int i = 0; i < 10_000; i++) {
            int sku = 100_000 + (i % skuCount);
            chainedTable.get(sku);
            hashMap.get(sku);
        }

        long start = System.nanoTime();
        for (int i = 0; i < skuCount; i++) chainedTable.get(100_000 + i);
        long chainedTime = System.nanoTime() - start;

        start = System.nanoTime();
        for (int i = 0; i < skuCount; i++) hashMap.get(100_000 + i);
        long mapTime = System.nanoTime() - start;

        System.out.println("SKUs stored: " + skuCount);
        System.out.printf("Chaining lookup time: %.3f ms%n", chainedTime / 1_000_000.0);
        System.out.printf("HashMap lookup time:  %.3f ms%n", mapTime / 1_000_000.0);
        System.out.println("Note: timings change depending on the computer and system load.");
    }
}
