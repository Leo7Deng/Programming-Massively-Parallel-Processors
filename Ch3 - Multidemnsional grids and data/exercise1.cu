// 1a
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

// 1b
__global__ void MatrixMulRowKernel(float *M, float*N, float*P, int Width) {
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