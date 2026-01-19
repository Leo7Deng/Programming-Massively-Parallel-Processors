Assume that parallel reduction is to be applied on the following input array:
[6, 2, 7, 4, 5, 8, 3, 1]

Show how the contents of the array change after each iteration if:
a. The unoptimized kernel in Fig 10.6 is used.
[6, 2, 7, 4, 5, 8, 3, 1]
[8, 2, 11, 4, 13, 8, 4, 1]
[19, 2, 7, 4, 17, 8, 3, 1]
[36, 2, 7, 4, 17, 8, 3, 1]

b. The kernel optimized for coalescing and divergence in Fig 10.9 us used.
[6, 2, 7, 4, 5, 8, 3, 1]
[11, 10, 10, 5, 5, 8, 3, 1]
[21, 15, 7, 4, 5, 8, 3, 1]
[36, 15, 7, 4, 5, 8, 3, 1]