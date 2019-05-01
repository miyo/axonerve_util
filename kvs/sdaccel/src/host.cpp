#include "xcl2.hpp"
#include <vector>

#define DATA_SIZE 16384

int main(int argc, char** argv)
{
    int size = DATA_SIZE;
    
    //Allocate Memory in Host Memory
    size_t vector_size_bytes = sizeof(int) * size;
    std::vector<int,aligned_allocator<int>> host_buffer1    (size);
    std::vector<int,aligned_allocator<int>> expected_result1(size);

    // Create the test data and Software Result 
    for(int i = 0 ; i < size; i++){
        host_buffer1[i] = i+300;
        expected_result1[i] = host_buffer1[i]+1;
    }

    //OPENCL HOST CODE AREA START
    //Create Program and Kernel
    std::vector<cl::Device> devices = xcl::get_xil_devices();
    cl::Device device = devices[0];

    cl::Context context(device);
    cl::CommandQueue q(context, device, CL_QUEUE_PROFILING_ENABLE);
    std::string device_name = device.getInfo<CL_DEVICE_NAME>(); 

    std::string binaryFile = xcl::find_binary_file(device_name,"axonerve");
    //std::string binaryFile = "./binary_container_1.xclbin";
    cl::Program::Binaries bins = xcl::import_binary_file(binaryFile);
    devices.resize(1);
    cl::Program program(context, devices, bins);
    cl::Kernel axonerve_kvs_rtl(program,"axonerve_kvs_rtl");

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
    for (int i = 0 ; i < size ; i++){
    	if (expected_result1[i] != host_buffer1[i]){
            std::cout << "[1] i = " << i << " expected = " << expected_result1[i] << ", result = " << host_buffer1[i] << std::endl;
            match = 1;
        }
        if(match) break;
    }

    std::cout << "TEST " << (match ? "FAILED" : "PASSED") << std::endl; 
    return (match ? EXIT_FAILURE :  EXIT_SUCCESS);
}
