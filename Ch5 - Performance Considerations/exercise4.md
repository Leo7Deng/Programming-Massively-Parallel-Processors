##### What is the floating point to global memory access ratio (in OP/B) of each of the following matrix-matrix multiplication kernels?

a. The simple kernel described in Chatper 3, Multidemnsional Grids and Data, without any optimizations applied.
To calculate a single element in the resulting matrix C, we will need to perform N multiplications and N additions (N is the row/col length). So the ops per output is 2N.
For each output, we need to read N floats from A and N floats from B. So we access 2N x 4 Bytes.
Ratio = 2N ops / (4 bytes x 2N) = 0.25 OP/B

b. The kernel described in Chatper 5, Memory Architecture and Data Locality with shared memory tiling applied using a tile size of 32 x 32.
For each 32 x 32 threads, they each perform 32 multiplications and 32 additions. So operations for 32 x 32 block of C is 32 x 32 x 32 x 2 = 6536 Ops.
For each 32 x 32 threads, we loaded in 32 x 32 floats from A and 32 x 32 floats from B. So the total bytes is 32 x 32 x 4 = 8192 bytes.
Ratio = 65536 Ops / 8192 bytes = 8.0 OP/B

c. The kernel described in this chapter with shared memory tiling applied using a tile size of 32 x 32 and thread coarsening applied using a coarsening factor of 4.
Thread coarsening calculates 4 elements per thread which allows fewer threads to do the same work. It reduced loads from Shared memory to registers so in our case it would not actually affect the number of operations needed, nor the number of accesses to global memory.
The ratio would still be 8.0 OP/B.