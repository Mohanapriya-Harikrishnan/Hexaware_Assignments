import java.util.ArrayList;
import java.util.Arrays;
import java.util.Comparator;
import java.util.List;

public class AppointmentScheduler {

    // DP for maximum number of non-overlapping appointments.
    // Appointments are sorted by finishing time.
    public static List<Appointment> dynamicProgramming(Appointment[] input) {
        Appointment[] jobs = input.clone();
        Arrays.sort(jobs, Comparator.comparingInt(Appointment::getEndMinute));

        int n = jobs.length;
        int[] dp = new int[n + 1];

        for (int i = 1; i <= n; i++) {
            int currentStart = jobs[i - 1].getStartMinute();
            int previousCompatible = 0;

            // Find the last earlier appointment that ends at/before this one starts.
            for (int j = i - 2; j >= 0; j--) {
                if (jobs[j].getEndMinute() <= currentStart) {
                    previousCompatible = j + 1; // dp uses a 1-based prefix length
                    break;
                }
            }

            int include = 1 + dp[previousCompatible];
            int exclude = dp[i - 1];
            dp[i] = Math.max(include, exclude);
        }

        // Reconstruct one optimal appointment set.
        List<Appointment> chosen = new ArrayList<>();
        int i = n;
        while (i > 0) {
            int currentStart = jobs[i - 1].getStartMinute();
            int previousCompatible = 0;
            for (int j = i - 2; j >= 0; j--) {
                if (jobs[j].getEndMinute() <= currentStart) {
                    previousCompatible = j + 1;
                    break;
                }
            }

            if (1 + dp[previousCompatible] > dp[i - 1]) {
                chosen.add(jobs[i - 1]);
                i = previousCompatible;
            } else {
                i--;
            }
        }

        java.util.Collections.reverse(chosen);
        return chosen;
    }

    // Greedy comparison: repeatedly choose the compatible appointment
    // that finishes earliest. Optimal when every appointment has equal value.
    public static List<Appointment> greedy(Appointment[] input) {
        Appointment[] jobs = input.clone();
        Arrays.sort(jobs, Comparator.comparingInt(Appointment::getEndMinute));

        List<Appointment> chosen = new ArrayList<>();
        int lastEnd = Integer.MIN_VALUE;

        for (Appointment job : jobs) {
            if (job.getStartMinute() >= lastEnd) {
                chosen.add(job);
                lastEnd = job.getEndMinute();
            }
        }
        return chosen;
    }

    public static String time(int minute) {
        return String.format("%02d:%02d", minute / 60, minute % 60);
    }
}
