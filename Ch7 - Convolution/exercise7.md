Consider performing a 2D tiled convolution with the kernel shown in Fig 7.12 on an array of size N x N with a filter of size M x M using an output tile of size T x T.

```cpp
01  #define IN_TILE_DIM 32
02  #define OUT_TILE_DIM ((IN_TILE_DIM) - 2*(FILTER_RADIUS))
03  __constant__ float F_c[2*FILTER_RADIUS+1][2*FILTER_RADIUS+1];
04  __global__ void convolution_tiled_2D_const_mem_kernel(float *N, float *P,
05                                                      int width, int height) {
06      int col = blockIdx.x*OUT_TILE_DIM + threadIdx.x - FILTER_RADIUS;
07      int row = blockIdx.y*OUT_TILE_DIM + threadIdx.y - FILTER_RADIUS;
08      //loading input tile
09      __shared__ N_s[IN_TILE_DIM][IN_TILE_DIM];
10      if(row>=0 && row<height && col>=0 && col<width) {
11          N_s[threadIdx.y][threadIdx.x] = N[row*width + col];
12      } else {
13          N_s[threadIdx.y][threadIdx.x] = 0.0;
14      }
15      __syncthreads();
16      // Calculating output elements
17      int tileCol = threadIdx.x - FILTER_RADIUS;
18      int tileRow = threadIdx.y - FILTER_RADIUS;
19      // turning off the threads at the edges of the block
20      if (col >= 0 && col < width && row >=0 && row < height) {
21          if (tileCol>=0 && tileCol<OUT_TILE_DIM && tileRow>=0
22                  && tileRow<OUT_TILE_DIM) {
23              float Pvalue = 0.0f;
24              for (int fRow = 0; fRow < 2*FILTER_RADIUS+1; fRow++) {
25                  for (int fCol = 0; fCol < 2*FILTER_RADIUS+1; fCol++) {
26                      Pvalue += F_c[fRow][fCol]*N_s[tileRow+fRow][tileCol+fCol];
27                  }
28              }
29              P[row*width+col] = Pvalue;
30          }
31      }
32  }
```

a. How many thread blocks are needed?
Each thread block maps to an output tile so the amount of thread blocks needed would be T x T

b. How many threads are needed per block?
The amount of threads needed per block would need to allow each thread to load one input element. Therefore, the amount of threads needed per block would be (M + T - 1) x (M + T - 1)

c. How much shared memory is needed per block?
The shared memory needed per block would be the input size, (M + T - 1) x (M + T - 1)
