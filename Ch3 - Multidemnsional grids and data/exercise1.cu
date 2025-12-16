// 1a. Write a kernel that has each thread produce one output matrix row. Fill in the execution configuration parameters for this design.

// M, N: Input matrices (flattened 1D arrays of size Width*Width)
// P: Output matrix
// Width: The dimension of the matrices (Width x Width)
__global__ void MatrixMulRowKernel(float *M, float*N, float*P, int Width) {
    // Assume this is 1D (in the row dimension) because we want each thread to produce one output matrix row
    int row = blockIdx.y*blockDim.y+threadIdx.y

    if ((row < Width)) {
        for (int col = 0; col < Width; ++col) {
            float Pvalue = 0;
            for (int k = 0; k < Width; ++k) {
                Pvalue += M[row*Width+k]*N[k*Wdith+col]
            }
            P[row*Width+col] = Pvalue;
        }
    }  
}

// 1b. Write a kernel that has each thread produce one output matrix column. Fill in the execution configuration parameters for the design
__global__ void MatrixMulColKernel(float *M, float*N, float*P, int Width) {
    // Assume this is 1D (in the col dimension) because we want each thread to produce one output matrix col
    int col = blockIdx.x*blockDim.x+threadIdx.x

    if ((col < Width)) {
        for (int row = 0; row < Width; ++row) {
            float Pvalue = 0;
            for (int k = 0; k < Width; ++k) {
                Pvalue += M[row*Width+k]*N[k*Wdith+col]
            }
            P[row*Width+col] = Pvalue;
        }
    }  
}

// 1c.  Analyze the pros and cons of each of the two kernel designs.

// The column based kernel (1b) is significantly better than the row based Kernel (1a) because of memory coalescing. In CUDA, threads within a warp execute in lock step, so when they access global memory (DRAM), the hardware attempts to combine their requests into the same transaction. This is most efficient when threads access consecutive memory addresses.