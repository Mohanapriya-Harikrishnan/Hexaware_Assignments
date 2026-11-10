import java.util.HashSet;
import java.util.Set;

public class BookingRegistry {
    // A unique key is the combination of patient ID and slot ID.
    private final Set<String> bookedSlots = new HashSet<>();

    public boolean book(int patientId, String slotId) {
        String key = patientId + "|" + slotId;
        return bookedSlots.add(key); // false if this exact key already exists
    }

    public int getBookingCount() {
        return bookedSlots.size();
    }
}
