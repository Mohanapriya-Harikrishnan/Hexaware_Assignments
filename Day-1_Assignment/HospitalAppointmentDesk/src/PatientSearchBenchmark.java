import java.util.Random;

public class PatientSearchBenchmark {

    public static int linearSearch(Patient[] patients, int targetId) {
        for (int i = 0; i < patients.length; i++) {
            if (patients[i].getPatientId() == targetId) {
                return i;
            }
        }
        return -1;
    }

    // The input array must be sorted by patient ID.
    public static int binarySearch(Patient[] patients, int targetId) {
        int low = 0;
        int high = patients.length - 1;

        while (low <= high) {
            int mid = low + (high - low) / 2;
            int currentId = patients[mid].getPatientId();

            if (currentId == targetId) {
                return mid;
            } else if (currentId < targetId) {
                low = mid + 1;
            } else {
                high = mid - 1;
            }
        }
        return -1;
    }

    public static void runBenchmark() {
        final int recordCount = 20_000;
        final int lookupCount = 1_000;

        Patient[] patients = new Patient[recordCount];
        for (int i = 0; i < recordCount; i++) {
            patients[i] = new Patient(100_001 + i, "Patient-" + (i + 1));
        }

        // Create the same repeatable 1,000 lookup IDs for both algorithms.
        int[] targets = new int[lookupCount];
        Random random = new Random(42);
        for (int i = 0; i < lookupCount; i++) {
            targets[i] = 100_001 + random.nextInt(recordCount);
        }

        long linearStart = System.nanoTime();
        int linearFound = 0;
        for (int target : targets) {
            if (linearSearch(patients, target) != -1) linearFound++;
        }
        long linearTime = System.nanoTime() - linearStart;

        // Binary search needs data sorted by patient ID. This data is already sorted.
        long binaryStart = System.nanoTime();
        int binaryFound = 0;
        for (int target : targets) {
            if (binarySearch(patients, target) != -1) binaryFound++;
        }
        long binaryTime = System.nanoTime() - binaryStart;

        System.out.println("\n--- TASK 1: SEARCH BENCHMARK ---");
        System.out.println("Patient records: " + recordCount);
        System.out.println("Lookups per algorithm: " + lookupCount);
        System.out.println("Linear search found: " + linearFound);
        System.out.printf("Linear search time: %.3f ms%n", linearTime / 1_000_000.0);
        System.out.println("Binary search found: " + binaryFound);
        System.out.printf("Binary search time: %.3f ms%n", binaryTime / 1_000_000.0);
        System.out.println("Note: timings vary by computer and JVM. Both methods use the same lookup IDs.");
    }
}
