class TrafficAnalysis {
    static void findBusiestThreeHours(int[] requests) {
        int windowTotal = 0;
        for (int i = 0; i < 3; i++) windowTotal += requests[i];

        int maxTotal = windowTotal;
        int startHour = 0;

        // Move the 3-hour window one hour at a time.
        for (int i = 3; i < requests.length; i++) {
            windowTotal = windowTotal + requests[i] - requests[i - 3];
            if (windowTotal > maxTotal) {
                maxTotal = windowTotal;
                startHour = i - 2;
            }
        }

        System.out.println("Busiest window: " + startHour + ":00 to " + (startHour + 3) + ":00");
        System.out.println("Total requests in 3 hours: " + maxTotal);
    }

    static void run() {
        int[] requestsPerHour = {
            120, 135, 150, 180, 210, 260, 310, 340,
            390, 420, 450, 430, 410, 380, 360, 330,
            300, 280, 250, 220, 190, 170, 150, 130
        };
        findBusiestThreeHours(requestsPerHour);
    }
}
