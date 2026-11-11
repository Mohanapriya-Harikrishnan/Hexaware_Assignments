# Hospital Appointment Desk – Java DSA Assignment

## Requirements
- JDK 21 (JDK 17 or later should also work)
- Visual Studio Code
- VS Code Extension Pack for Java

## Run in VS Code
1. Open this folder in VS Code.
2. Open `src/Main.java`.
3. Click **Run** above `main()`.
4. Read the results in the Terminal.

## Run using terminal
Open the project folder in VS Code Terminal and run:

```powershell
javac -d out src/*.java
java -cp out Main
```

## Files
- `Main.java`: runs all five demonstrations.
- `Patient.java`: patient record model.
- `PatientSearchBenchmark.java`: linear and binary search, 20,000 records and 1,000 lookups.
- `Appointment.java`: appointment model.
- `AppointmentSorter.java`: selection sort and quick sort over 1,000 generated appointments, with swap/time counts.
- `BookingRegistry.java`: duplicate booking prevention with HashSet.
- `SimpleQueue.java`: linked-node queue implemented from scratch.
- `SimpleStack.java`: linked-node stack implemented from scratch.
- `AppointmentScheduler.java`: dynamic programming and greedy interval scheduling.

## Important assumptions
- Urgency `1` means highest urgency.
- Arrival time is measured in minutes after midnight.
- For scheduling, appointments are intervals `[start, end)`. An appointment ending at 10:00 can be followed by one starting at 10:00.
- Duplicate means the same patient ID and the same slot ID.
- The shift scheduling objective is to maximize the number of appointments. All appointments have equal value; therefore earliest-finish-time greedy is also optimal. The DP solution is included as requested.

## Complexity summary
| Feature | Time complexity |
|---|---|
| Linear search | O(n) per lookup |
| Binary search | O(log n) per lookup after sorting |
| Selection sort | O(n^2) |
| Quick sort | Average O(n log n), worst O(n^2) |
| HashSet add/check | Average O(1) |
| Queue enqueue/dequeue | O(1) |
| Stack push/pop | O(1) |
| DP scheduling in this implementation | O(n^2) |
| Greedy scheduling after sorting | O(n log n) |


