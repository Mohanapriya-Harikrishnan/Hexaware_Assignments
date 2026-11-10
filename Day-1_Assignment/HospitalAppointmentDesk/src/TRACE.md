# Selection Sort Trace (typed submission)

Example: sort appointment urgency values in ascending order.

Initial array: [3, 1, 2, 1]

Pass 1:
- Unsorted portion: [3, 1, 2, 1]
- Minimum value: 1 (index 1)
- Swap index 0 and index 1
- Array: [1, 3, 2, 1]

Pass 2:
- Unsorted portion: [3, 2, 1]
- Minimum value: 1 (index 3)
- Swap index 1 and index 3
- Array: [1, 1, 2, 3]

Pass 3:
- Unsorted portion: [2, 3]
- Minimum value: 2 (index 2)
- No swap required
- Array: [1, 1, 2, 3]

Sorted array: [1, 1, 2, 3]

Explanation:
Selection sort repeatedly finds the smallest item in the unsorted portion
and places it at the beginning of that portion. It performs O(n^2)
comparisons and at most n-1 actual swaps.
