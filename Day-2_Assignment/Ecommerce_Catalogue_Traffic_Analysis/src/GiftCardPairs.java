class GiftCardPairs {
    static void findPairs(int[] orderValues, int giftCardValue) {
        int left = 0;
        int right = orderValues.length - 1;
        boolean pairFound = false;

        System.out.println("Pairs adding up to Rs." + giftCardValue + ":");
        while (left < right) {
            int sum = orderValues[left] + orderValues[right];
            if (sum == giftCardValue) {
                System.out.println("Rs." + orderValues[left] + " + Rs." + orderValues[right]);
                pairFound = true;
                left++;
                right--;
            } else if (sum < giftCardValue) {
                left++;
            } else {
                right--;
            }
        }

        if (!pairFound) System.out.println("No matching pair found.");
    }

    static void run() {
        int[] orderValues = {100, 150, 200, 250, 300, 350, 400, 450};
        findPairs(orderValues, 550);
    }
}
