#include "xcl2.hpp"
#include <vector>
#include <unistd.h>

#define DATA_SIZE 2

struct axonerve_query{
    unsigned int key[4];
    unsigned int value;
    unsigned int csr; // H-D 0: INIT, 1: ERASE, 2: WRITE, 3: READE, 4: SEARCH, 5: UPDATE
                      // D-H 0: SINGLE_HIT, 1: MULTI_HIT, 2: ENT_ERR, 3: ENT_FULL
    unsigned int priority;
    unsigned int mask[4];
    unsigned int dummy[3];
    unsigned int kernel_status;
    unsigned int version;
};

int main(int argc, char** argv)
{
    int size = DATA_SIZE;
    
    //Allocate Memory in Host Memory
    size_t vector_size_bytes = sizeof(axonerve_query) * size;
    std::vector<axonerve_query,aligned_allocator<axonerve_query>> host_buffer1(size);

    // Create the test data and Software Result
    host_buffer1[0].key[0] = 0xDEADBEEF;
    host_buffer1[0].key[1] = 0xDEADBEEF;
    host_buffer1[0].key[2] = 0xDEADBEEF;
    host_buffer1[0].key[3] = 0xDEADBEEF;
    host_buffer1[0].value = 0xABADCAFE;
    host_buffer1[0].csr = 0x20; // UPDATE
    host_buffer1[0].priority = 0;
    host_buffer1[0].mask[0] = 0; // 0xFFFFFFFF;
    host_buffer1[0].mask[1] = 0; // 0xFFFFFFFF;
    host_buffer1[0].mask[2] = 0; // 0xFFFFFFFF;
    host_buffer1[0].mask[3] = 0; // 0xFFFFFFFF;
    host_buffer1[1].kernel_status = 0;
    host_buffer1[1].version = 0;

    host_buffer1[1].key[0] = 0xDEADBEEF;
    host_buffer1[1].key[1] = 0xDEADBEEF;
    host_buffer1[1].key[2] = 0xDEADBEEF;
    host_buffer1[1].key[3] = 0xDEADBEEF;
    host_buffer1[1].value = 0x00000000;
    host_buffer1[1].csr = 0x10; // SEARCH
    host_buffer1[1].priority = 0;
    host_buffer1[1].mask[0] = 0; // 0xFFFFFFFF;
    host_buffer1[1].mask[1] = 0; // 0xFFFFFFFF;
    host_buffer1[1].mask[2] = 0; // 0xFFFFFFFF;
    host_buffer1[1].mask[3] = 0; // 0xFFFFFFFF;
    host_buffer1[1].kernel_status = 0;
    host_buffer1[1].version = 0;

    printf("Queries\n");
    for (int i = 0 ; i < size ; i++){
	printf("%08x %08x %08x %08x\n", host_buffer1[i].key[0],host_buffer1[i].key[1],host_buffer1[i].key[2],host_buffer1[i].key[3]);
	printf("%08x\n", host_buffer1[i].value);
	printf("%08x\n", host_buffer1[i].csr);
	printf("%08x\n", host_buffer1[i].priority);
	printf("%08x %08x %08x %08x\n", host_buffer1[i].mask[0],host_buffer1[i].mask[1],host_buffer1[i].mask[2],host_buffer1[i].mask[3]);
	printf("%08x\n", host_buffer1[i].kernel_status);
	printf("%08x\n", host_buffer1[i].version);
    }

    
    //OPENCL HOST CODE AREA START
    //Create Program and Kernel
    std::vector<cl::Device> devices = xcl::get_xil_devices();
    cl::Device device = devices[0];

    cl::Context context(device);
    cl::CommandQueue q(context, device, CL_QUEUE_PROFILING_ENABLE);
    std::string device_name = device.getInfo<CL_DEVICE_NAME>(); 

    //std::string binaryFile = xcl::find_binary_file(device_name,"axonerve");
    std::string binaryFile = "./binary_container_1.xclbin";
    cl::Program::Binaries bins = xcl::import_binary_file(binaryFile);
    devices.resize(1);
    cl::Program program(context, devices, bins);
    cl::Kernel axonerve_kvs_rtl(program,"axonerve_kvs_rtl");

    printf("init wait...\n");
    sleep(5);
    printf("done.\n");

    //Allocate Buffer in Global Memory
    std::vector<cl::Memory> bufVec;
    cl::Buffer buffer_1(context,  CL_MEM_READ_WRITE | CL_MEM_USE_HOST_PTR,  vector_size_bytes, host_buffer1.data());

    bufVec.push_back(buffer_1);

    //Copy input data to device global memory
    q.enqueueMigrateMemObjects(bufVec, 0/* 0 means from host*/);

    //Set the Kernel Arguments
    //int data_num = DATA_SIZE; // should be failed
    int data_num = vector_size_bytes; // should be success
    axonerve_kvs_rtl.setArg(0, data_num);
    axonerve_kvs_rtl.setArg(1, buffer_1);

    //Launch the Kernel
    q.enqueueTask(axonerve_kvs_rtl);

    //Copy Result from Device Global Memory to Host Local Memory
    q.enqueueMigrateMemObjects(bufVec, CL_MIGRATE_MEM_OBJECT_HOST);
    q.finish();

    //OPENCL HOST CODE AREA END
    
    // Compare the results of the Device to the simulation
    int match = 0;
    printf("Results\n");
    for (int i = 0 ; i < size ; i++){
	printf("%08x %08x %08x %08x\n", host_buffer1[i].key[0],host_buffer1[i].key[1],host_buffer1[i].key[2],host_buffer1[i].key[3]);
	printf("%08x\n", host_buffer1[i].value);
	printf("%08x\n", host_buffer1[i].csr);
	printf("  SINGLE_HIT: %d\n", (host_buffer1[i].csr & 0x00000001)>>0);
	printf("  MULTI_HIT: %d\n",  (host_buffer1[i].csr & 0x00000002)>>1);
	printf("  ENT_ERR: %d\n",    (host_buffer1[i].csr & 0x00000004)>>2);
	printf("  ENT_FULL: %d\n",   (host_buffer1[i].csr & 0x00000008)>>3);
	printf("%08x\n", host_buffer1[i].priority);
	printf("%08x %08x %08x %08x\n", host_buffer1[i].mask[0],host_buffer1[i].mask[1],host_buffer1[i].mask[2],host_buffer1[i].mask[3]);
	printf("%08x\n", host_buffer1[i].kernel_status);
	printf("%08x\n", host_buffer1[i].version);
    }

    std::cout << "TEST " << (match ? "FAILED" : "PASSED") << std::endl; 
    return (match ? EXIT_FAILURE :  EXIT_SUCCESS);
}
