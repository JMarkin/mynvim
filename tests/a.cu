// includes, system
#include <stdio.h>

// includes CUDA Runtime
#include <cuda_runtime.h>
#include <cuda_profiler_api.h>

// includes, project
#include <helper_cuda.h>
#include <helper_functions.h>  // helper utility functions

__global__ void increment_kernel(int *g_data, int inc_value) {
  int idx = blockIdx.x * blockDim.x + threadIdx.x;
  g_data[idx] = g_data[idx] + inc_value;
}

