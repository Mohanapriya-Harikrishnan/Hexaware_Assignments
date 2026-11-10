public class AppointmentSorter {

    public static class SortStats {
        public final long swaps;
        public final long nanoseconds;

        public SortStats(long swaps, long nanoseconds) {
            this.swaps = swaps;
            this.nanoseconds = nanoseconds;
        }
    }

    // Lower urgency number comes first; ties are ordered by arrival time.
    private static int compare(Appointment a, Appointment b) {
        int urgencyCompare = Integer.compare(a.getUrgency(), b.getUrgency());
        if (urgencyCompare != 0) return urgencyCompare;
        return Integer.compare(a.getArrivalMinute(), b.getArrivalMinute());
    }

    public static SortStats selectionSort(Appointment[] array) {
        long swaps = 0;
        long start = System.nanoTime();

        for (int i = 0; i < array.length - 1; i++) {
            int minIndex = i;

            for (int j = i + 1; j < array.length; j++) {
                if (compare(array[j], array[minIndex]) < 0) {
                    minIndex = j;
                }
            }

            if (minIndex != i) {
                Appointment temp = array[i];
                array[i] = array[minIndex];
                array[minIndex] = temp;
                swaps++;
            }
        }

        return new SortStats(swaps, System.nanoTime() - start);
    }

    public static SortStats quickSort(Appointment[] array) {
        long start = System.nanoTime();
        long[] swaps = {0};
        quickSort(array, 0, array.length - 1, swaps);
        return new SortStats(swaps[0], System.nanoTime() - start);
    }

    private static void quickSort(Appointment[] array, int low, int high, long[] swaps) {
        if (low < high) {
            int pivotIndex = partition(array, low, high, swaps);
            quickSort(array, low, pivotIndex - 1, swaps);
            quickSort(array, pivotIndex + 1, high, swaps);
        }
    }

    private static int partition(Appointment[] array, int low, int high, long[] swaps) {
        Appointment pivot = array[high];
        int smallerIndex = low - 1;

        for (int j = low; j < high; j++) {
            if (compare(array[j], pivot) <= 0) {
                smallerIndex++;
                swap(array, smallerIndex, j, swaps);
            }
        }

        swap(array, smallerIndex + 1, high, swaps);
        return smallerIndex + 1;
    }

    private static void swap(Appointment[] array, int i, int j, long[] swaps) {
        if (i != j) {
            Appointment temp = array[i];
            array[i] = array[j];
            array[j] = temp;
            swaps[0]++;
        }
    }

    public static void printAppointments(Appointment[] appointments) {
        for (Appointment appointment : appointments) {
            System.out.println(appointment);
        }
    }
}
