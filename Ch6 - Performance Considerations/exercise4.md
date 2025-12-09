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
Let's compute the ops needed for 4 32 x 32 blocks. This will require 32 multiplications and 32 additions per output. So operations = 4 x 32 x 32 x (32 + 32) = 262144 Ops.
For 4 32 x 32 blocks, we would need to load 4 32 x 32 blocks from A. But from B, we only need to load 1 32 x 32 block. Therefore, the total bytes accessed is (4 x 32 x 32 + 32 x 32) x 4 bytes = 20480 byes.
Ratio = 262144 Ops / 20480 bytes = 12.8 OP/B.