Analyze the Kogge-Stone parallel scan kernel in Fig. 11.3. Show that control divergence occurs only in the first warp of each block for stride values up to half of the warp size. That is, for warp size 32, control divergence will occur 5 iterations for stride values 1, 2, 4, 8, and 16.

```cpp
01 __global__ void Kogge_Stone_scan_kernel(float *X, float *Y, unsigned int N){
02     shared float XY[SECTION_SIZE];
03     unsigned int i = blockIdx.x*blockDim.x + threadIdx.x;
04     if(i < N) {
05         XY[threadIdx.x] = X[i];
06     } else {
07         XY[threadIdx.x] = 0.0f;
08     }
09     for(unsigned int stride = 1; stride < blockDim.x; stride *= 2) {
10         syncthreads();
11         float temp;
12         if(threadIdx.x >= stride)
13             temp = XY[threadIdx.x] + XY[threadIdx.x-stride];
14         syncthreads();
15         if(threadIdx.x >= stride)
16             XY[threadIdx.x] = temp;
17     }
18     if(i < N) {
19         Y[i] = XY[threadIdx.x];
20     }
21 }
```

Control divergence only first warp of each block for stride values up to half of the warp size because of the lines 12 and 15. When stride > warp size / 2, lines 12 and 15 will only evaluate in true. For example, at stride 16, threads 0-15 will evaulate as false while thread 16-31 will evaluate to true, leading control divergence. But looking at stride 32, all threads in the warp will evaluate to false, so there will be no control divergence.