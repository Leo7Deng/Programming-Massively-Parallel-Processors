Consider a histogram kernel that processes an input with 524,288 elements to produce a histogram with 128 bins. The kernel is configured with 1024 threads per block.

a. What is the total number of atomic operations that are performed on global memory by the kernel in Fig 9.6 where no privatization, shared memory, and thread coarsening are used?
Since there are no optimizations being used, each element is a seperate atomic operation, so there are 524,288 operations performed on global memory.

b. What is the maximum number of atomic operations that may be performed on global memory by the kernel in Fig. 9.10 where privatization and shared memory are used but not thread coarsening?
When using privatization and shared memory, atomic operations are performed per thread block. Since we are not using thread coarsening, we will use one thread per element, therefore 524,288 threads / 1024 threads per block = 512 blocks. Each block needs one atomic operation per histogram bin. Therefore the maximum atomic operations performed is 512 blocks x 128 bins = 65536 operations.

c. What is the maximum number of atomic operations that may be performed on global memory by the kernel in Fig 9.14 where privatization, shared memory, and thread coarsening are used with a coarsening factor of 4?
Since we are using a coarsening factor of 4, we will only have 524,288 / 4 =  131072 threads. The number of blocks used will be 131072 threads / 1024 threads per block = 128 blocks. Still, we will need to perform an atomic operation per histogram bin. The maximum atomic operations performed is 128 blocks x 128 bins = 16384 operations.