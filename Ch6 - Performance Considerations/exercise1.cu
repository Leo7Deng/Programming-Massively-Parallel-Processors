#define TILE_WIDTH 32

// __global__ for kernel called from CPU
// A is a matrix in row major form
// B is a matrix in major row form
// C is the resulting matrix in row major form
// M is the rows of A and C
// N is the cols in B and C
// K is the cols of A and rows of B
__global__ void matrixMulCornerTurn(float* A, float* B, float*C, int M, int N, int K) {
    // 1. find the row and col that this thread should work on
    int row = blockIdx.y * TILE_WIDTH + threadIdx.y;
    int col = blockIdx.x * TILE_WIDTH + threadIdx.x;

    // 2. allocate A and B into shared memory for lower latency access
    __shared__ float As[TILE_WIDTH][TILE_WIDTH];
    __shared__ float Bs[TILE_WIDTH][TILE_WIDTH];

    float C_value = 0.0f;
    // 3. loop over tiles
    // We want ceil(K/TILE_WIDTH) phases
    for (int ph = 0; ph < (K + TILE_WIDTH - 1 ) / TILE_WIDTH; ++ph) {
        // For each phase, we want to calculate a TILE_WIDTH out of K dot products for one element of C
        // To leverage shared memory within the block of threads, we will load a block of size TILE_WIDTH
        // x TILE_WIDTH of A and B into shared memory

        // load As first
        int A_col_idx = ph * TILE_WIDTH + threadIdx.x;
        if (row < M && A_col_idx < K) {
            // since A is row major form, these global memory access will be coalesced
            As[threadIdx.y][threadIdx.x] = A[row * K + A_col_idx];
        } else { // thread is out of bounds. This means extra threads in the grid are not being used
            As[threadIdx.y][threadIdx.x] = 0.0f;
        }

        // load Bs which is in col major form
        // use threadIdx.x to control rows and threadIdx.y to control cols
        // basically we need to "flip" A_col_idx and col used in loading in As
        int B_row_idx = ph * TILE_WIDTH + threadIdx.x;
        int t_col = blockIdx.x * TILE_WIDTH + threadIdx.y;
        if (t_col < N && B_row_idx < K) {        
            Bs[threadIdx.x][threadIdx.y] = B[t_col * K + B_row_idx];
        } else {
            Bs[threadIdx.x][threadIdx.y] = 0.0f;
        }
        
        // 4. make sure everything in the tile is loaded
        __syncthreads();
        
        // 5. compute TILE_WIDTH out of K dot products of one element of C using loaded shared memory
        for (int k = 0; k < TILE_WIDTH; ++k) {
            // Bs is in normal form. We only had to perform corner turn when loading into shared memory
            C_value += As[threadIdx.y][k] * Bs[k][threadIdx.x];
        }

        __syncthreads();
    }

    // 6. write result to C
    if (row < M && col < N) {
        C[row * N + col] = C_value;
    }
}