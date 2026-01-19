Consider the following array: [4, 6, 7, 1, 2, 8, 5, 2]. Perform a parallel inclusive prefix scan on the array, using the Kogge-Stone algorith. Report the intermediate states of the array after each step.

[4, 6, 7, 1, 2, 8, 5, 2]
[4, 10, 13, 8, 3, 10, 13, 7]
[4, 10, 17, 18, 16, 28, 16, 17]
[4, 10, 17, 18, 20, 18, 33, 35]