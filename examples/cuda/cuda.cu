// nvcc cuda_hello.cu -o hello.o
#include <stdio.h>
#define MAX_DEVICE 2
#define RTERROR(status, s)                            \
  if (status != cudaSuccess)                          \
  {                                                   \
    printf("%s %s\n", s, cudaGetErrorString(status)); \
    cudaDeviceReset();                                \
    exit(-1);                                         \
  }

//HelloFromGPU<<<1, 5>>>();
__global__ void HelloFromGPU(void)
{
  printf("Hello from GPU\n");
}

int getDeviceCount() {
  cudaError_t status;
  int gpuCount = 0;
  status = cudaGetDeviceCount(&gpuCount);
  RTERROR(status, "cudaGetDeviceCount failed");
  if (gpuCount == 0)
  {
    printf("No CUDA-capable devices found, exiting.\n");
    cudaDeviceReset();
    exit(-1);
  }
  return gpuCount;
}

cudaDeviceProp getProps(int device)
{
  cudaDeviceProp deviceProp;
  cudaGetDeviceProperties(&deviceProp, device);
  return deviceProp;
}

void cudaGetSetDevice(){
  cudaError_t status;
  int device = 0;
  status = cudaGetDevice(&device);
  RTERROR(status, "Error fetching current GPU");
  status = cudaSetDevice(device);
  RTERROR(status, "Error setting CUDA device");
  cudaDeviceSynchronize();
}

void isSupportP2P(int gpuCount)
{
  int uvaOrdinals[MAX_DEVICE];
  int uvaCount = 0;
  int i, j;
  cudaDeviceProp prop;
  for (i = 0; i < gpuCount; ++i)
  {
    cudaGetDeviceProperties(&prop, i);
    if (prop.unifiedAddressing)
    {
      uvaOrdinals[uvaCount] = i;
      printf("   GPU%d \"%15s\"\n", i, prop.name);
      uvaCount += 1;
    }
    else
      printf("   GPU%d \"%15s\"     NOT UVA capable\n", i, prop.name);
  }
  int canAccessPeer_ij, canAccessPeer_ji;
  for (i = 0; i < uvaCount; ++i)
  {
    for (j = i + 1; j < uvaCount; ++j)
    {
      cudaDeviceCanAccessPeer(&canAccessPeer_ij, uvaOrdinals[i], uvaOrdinals[j]);
      cudaDeviceCanAccessPeer(&canAccessPeer_ji, uvaOrdinals[j], uvaOrdinals[i]);
      if (canAccessPeer_ij * canAccessPeer_ji)
      {
        printf("   GPU%d and GPU%d: YES\n", uvaOrdinals[i], uvaOrdinals[j]);
      }
      else
      {
        printf("   GPU%d and GPU%d: NO\n", uvaOrdinals[i], uvaOrdinals[j]);
      }
    }
  }
}

int main(void)
{
  // get GPU Number
  int gpuCount = getDeviceCount();
  printf("gpucount:%d\n", gpuCount);
  // get SM Number
  cudaDeviceProp deviceProp = getProps(0);
  printf("SM number:%d\n", deviceProp.multiProcessorCount);
  // get Mode info
  if (deviceProp.computeMode == cudaComputeModeDefault)
  {
    printf("GPU is in Compute Mode.\n");
  }
  // get P2P support info
  isSupportP2P(gpuCount);
  return 0;
}
