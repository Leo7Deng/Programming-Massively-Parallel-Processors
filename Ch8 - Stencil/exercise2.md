Consider an implementation of a seven-point (3D) stencil with shared memory tiling and thread coarsening applied. The implementation is similar to those in Figs. 8.10 and 8.12, except that the tiles are not perfect cubes. Instead, a thread block size of 32 x 32 is used as well as a coarsening factor of 16 (i.e., each thread block processes 16 consecutive output planes in the z dimension).

a. What is the size of the input tile (in number of elements) that the thread block loads throughout its lifetime?
Since a 3D stencil will need to load the elements of front and back on the z plane, the amount of z planes we load is 16 + 1 + 1 = 18. Therefore the thread block loads 32 x 32 x 18 = 18432 elements.

b. What is the size of the output tile (in number of elements) that the thread block processes throughout its lifetime?
Since the 32 x 32 block size is the input and the elements on the edge will be halo cells for the output, the thread block processes 30 x 30 x 16 = 14400 elements.

c. What is the floating point to global memory access ratio (in OP/B) of the kernel?
We know that the input tile will load 18432 elements x 4 bytes = 73728 bytes. The output tile processes 14400 elements, where each element takes 7 multiplication operations, and to add these elements to the output takes 6 addition operations. So OP = 14400 x (7 + 6) = 187200. OP/B = 187200 OP / 73728 bytes = 2.539 OP/B.

d. How much shared memory (in bytes) is needed by each thread block if register tiling is not used, as in Fig. 8.10?
Without register tiling, we need to store 3 arrays of IN_TILE_DIM x IN_TILE_DIM, so the shared memory used would be 3 x 32 x 32 x 4 bytes = 12288 bytes.

e. How much shared memory (in bytes) is needed by each thread block if register tiling is used, as in Fig. 8.12?
With register tiling, we remove the need to store 3 arrays of IN_TILE_DIM x IN_TILE_DIM to only 1 array, since the inPrev and inNext stores don't need to be shared between threads. So the shared memory used would be 32 x 32 x 4 bytes = 4096 bytes.