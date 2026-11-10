import java.util.Arrays;
import java.util.List;

public class Main {

    public static void main(String[] args) {
        System.out.println("====================================");
        System.out.println(" HOSPITAL APPOINTMENT DESK SYSTEM");
        System.out.println("====================================");

        // TASK 1
        PatientSearchBenchmark.runBenchmark();

        // TASK 2: use 1,000 appointments so timing comparison is more meaningful.
        Appointment[] appointments = new Appointment[1_000];
        java.util.Random sortRandom = new java.util.Random(7);
        for (int i = 0; i < appointments.length; i++) {
            int urgency = 1 + sortRandom.nextInt(5);
            int arrival = 8 * 60 + sortRandom.nextInt(8 * 60);
            appointments[i] = new Appointment(10_000 + i, urgency, arrival,
                    arrival, arrival + 30);
        }

        System.out.println("\n--- TASK 2: APPOINTMENT SORTING ---");
        Appointment[] selectionData = appointments.clone();
        Appointment[] quickData = appointments.clone();

        AppointmentSorter.SortStats selectionStats =
                AppointmentSorter.selectionSort(selectionData);
        AppointmentSorter.SortStats quickStats =
                AppointmentSorter.quickSort(quickData);

        System.out.println("Appointments sorted: " + appointments.length);
        System.out.println("First 7 results (Selection Sort):");
        AppointmentSorter.printAppointments(Arrays.copyOf(selectionData, 7));
        System.out.println("Selection swaps: " + selectionStats.swaps);
        System.out.printf("Selection time: %.3f ms%n",
                selectionStats.nanoseconds / 1_000_000.0);

        System.out.println("\nFirst 7 results (Quick Sort):");
        AppointmentSorter.printAppointments(Arrays.copyOf(quickData, 7));
        System.out.println("Quick swaps: " + quickStats.swaps);
        System.out.printf("Quick time: %.3f ms%n",
                quickStats.nanoseconds / 1_000_000.0);

        // TASK 3
        System.out.println("\n--- TASK 3: DUPLICATE BOOKING CHECK ---");
        BookingRegistry registry = new BookingRegistry();
        System.out.println("Patient 101, SLOT-10: " + registry.book(101, "SLOT-10"));
        System.out.println("Patient 101, SLOT-10 again: " + registry.book(101, "SLOT-10"));
        System.out.println("Patient 102, SLOT-10: " + registry.book(102, "SLOT-10"));
        System.out.println("Total accepted bookings: " + registry.getBookingCount());

        // TASK 4
        System.out.println("\n--- TASK 4: QUEUE AND STACK ---");
        SimpleQueue<String> walkInQueue = new SimpleQueue<>();
        walkInQueue.enqueue("Patient 201");
        walkInQueue.enqueue("Patient 202");
        walkInQueue.enqueue("Patient 203");
        System.out.println("Next walk-in: " + walkInQueue.peek());
        System.out.println("Serving: " + walkInQueue.dequeue());
        System.out.println("Remaining walk-ins: " + walkInQueue.size());

        SimpleStack<String> recentPatients = new SimpleStack<>();
        recentPatients.push("Patient 301");
        recentPatients.push("Patient 302");
        recentPatients.push("Patient 303");
        System.out.println("Most recently viewed: " + recentPatients.peek());
        System.out.println("Back to: " + recentPatients.pop());

        // TASK 5
        System.out.println("\n--- TASK 5: DOCTOR SHIFT SCHEDULING ---");
        Appointment[] shiftAppointments = {
            new Appointment(401, 1, 540, 540, 600), // 09:00-10:00
            new Appointment(402, 1, 570, 570, 660), // 09:30-11:00
            new Appointment(403, 1, 600, 600, 660), // 10:00-11:00
            new Appointment(404, 1, 660, 660, 720), // 11:00-12:00
            new Appointment(405, 1, 690, 690, 750), // 11:30-12:30
            new Appointment(406, 1, 750, 750, 810)  // 12:30-13:30
        };

        List<Appointment> dpResult =
                AppointmentScheduler.dynamicProgramming(shiftAppointments);
        List<Appointment> greedyResult =
                AppointmentScheduler.greedy(shiftAppointments);

        System.out.println("DP maximum appointments: " + dpResult.size());
        for (Appointment a : dpResult) {
            System.out.println("Patient " + a.getPatientId() + ": "
                    + AppointmentScheduler.time(a.getStartMinute()) + "-"
                    + AppointmentScheduler.time(a.getEndMinute()));
        }

        System.out.println("Greedy maximum appointments: " + greedyResult.size());
        System.out.println("DP and greedy agree: " + (dpResult.size() == greedyResult.size()));

        System.out.println("\nAll assignment demonstrations completed.");
    }
}
