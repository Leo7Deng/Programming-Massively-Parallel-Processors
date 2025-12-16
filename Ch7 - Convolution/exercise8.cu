// Revise the 2D kernel in Fig 7.7 to perform 3D convolution

// __global__ void convolution_2D_basic_kernel(float *N, float *F, float *P,                                            int r, int width, int height) {
//     int outCol = blockIdx.x*blockDim.x + threadIdx.x;
//     int outRow = blockIdx.y*blockDim.y + threadIdx.y;
//     float Pvalue = 0.0f;
//     for (int fRow = 0; fRow < 2*r+1; fRow++) {
//         for (int fCol = 0; fCol < 2*r+1; fCol++) {
//             inRow = outRow - r + fRow;
//             inCol = outCol - r + fCol;
//             if (inRow >= 0 && inRow < height && inCol >= 0 && inCol < width) {
//                 Pvalue += F[fRow][fCol]*N[inRow*width + inCol];
//             }
//         }
//     }
//     P[outRow][outCol] = Pvalue;
// }

__global__ void convolution_3D_basic_kernel(float *N, float *F, float *P, 
                                            int r, int width, int height, int depth) {
    int outCol = blockIdx.x * blockDim.x + threadIdx.x;
    int outRow = blockIdx.y * blockDim.y + threadIdx.y;
    int outDepth = blockIdx.z * blockDim.z + threadIdx.z;
    
    float Pvalue = 0.0f;
    int filterDim = 2 * r + 1; // size of one side of the filter cube

    for (int fDepth = 0; fDepth < filterDim; fDepth++) {
        for (int fRow = 0; fRow < filterDim; fRow++) {
            for (int fCol = 0; fCol < filterDim; fCol++) {
                int inRow = outRow - r + fRow;
                int inCol = outCol - r + fCol;
                int inDepth = outDepth - r + fDepth;

                if (inRow >= 0 && inRow < height && 
                    inCol >= 0 && inCol < width && 
                    inDepth >= 0 && inDepth < depth) {
                    
                    // flatten indices
                    int fIndex = fDepth * filterDim * filterDim + fRow * filterDim + fCol;
                    int nIndex = inDepth * height * width + inRow * width + inCol;

                    Pvalue += F[fIndex] * N[nIndex];
                }
            }
        }
    }
    int pIndex = outDepth * height * width + outRow * width + outCol;
    P[pIndex] = Pvalue;
}