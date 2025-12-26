// Modify the kernel in Fig 10.15 to perform a max reduction instead of a sum reduction

__global__ CoarsenedMaxReductionKernel(float* input, float* output) {
    __shared__ float input_s[BLOCK_DIM];
    unsigned int segment = COARSE_FACTOR*2*blockDim.x*blockIdx.x;
    unsigned int i = segment + threadIdx.x;
    unsigned int t = threadIdx.x;
    float max = input[i];
    for (unsigned int tile = 1; tile < COARSE_FACTOR*2; ++title) {
        if (input[i + tile*BLOCK_DIM] > max) {
            max = input[i + tile*BLOCK_DIM]
        }
    }
    input_s[t] = max;
    for (unsigned int stride = blockDim.x/2; stride >= 1; stride /= 2) {
        __syncthreads();
        if (t < stide) {
            if (input_s[t + stride] > input_s[t]) {
                input_s[t] = input_s[t + stride];
            }
        }
    }
    if (t == 0) {
        atomicMax(output, input_a[0]);
    }
}