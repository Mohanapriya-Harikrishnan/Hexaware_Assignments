public class Appointment {
    private final int patientId;
    private final int urgency;       // 1 = highest urgency
    private final int arrivalMinute; // minutes after midnight
    private final int startMinute;   // for shift scheduling
    private final int endMinute;

    public Appointment(int patientId, int urgency, int arrivalMinute,
                       int startMinute, int endMinute) {
        if (urgency < 1 || startMinute >= endMinute) {
            throw new IllegalArgumentException("Invalid urgency or appointment time.");
        }
        this.patientId = patientId;
        this.urgency = urgency;
        this.arrivalMinute = arrivalMinute;
        this.startMinute = startMinute;
        this.endMinute = endMinute;
    }

    public int getPatientId() { return patientId; }
    public int getUrgency() { return urgency; }
    public int getArrivalMinute() { return arrivalMinute; }
    public int getStartMinute() { return startMinute; }
    public int getEndMinute() { return endMinute; }

    public String getArrivalTimeText() {
        return String.format("%02d:%02d", arrivalMinute / 60, arrivalMinute % 60);
    }

    @Override
    public String toString() {
        return "Patient " + patientId + " | urgency " + urgency
                + " | arrival " + getArrivalTimeText();
    }
}
