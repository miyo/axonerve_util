#include "xcl2.hpp"
#include <vector>

#define DATA_SIZE 4096

int main(int argc, char** argv)
{
    int size = DATA_SIZE;
    
    //Allocate Memory in Host Memory
    size_t vector_size_bytes = sizeof(int) * size;
    std::vector<int,aligned_allocator<int>> host_buffer1    (size);
    std::vector<int,aligned_allocator<int>> host_buffer2    (size);
    std::vector<int,aligned_allocator<int>> host_buffer3    (size);
    std::vector<int,aligned_allocator<int>> host_buffer4    (size);
    std::vector<int,aligned_allocator<int>> host_buffer5    (size);
    std::vector<int,aligned_allocator<int>> host_buffer6    (size);

    std::vector<int,aligned_allocator<int>> expected_result1(size);
    std::vector<int,aligned_allocator<int>> expected_result2(size);
    std::vector<int,aligned_allocator<int>> expected_result3(size);
    std::vector<int,aligned_allocator<int>> expected_result4(size);
    std::vector<int,aligned_allocator<int>> expected_result5(size);
    std::vector<int,aligned_allocator<int>> expected_result6(size);

    // Create the test data and Software Result 
    for(int i = 0 ; i < size; i++){
        host_buffer1[i] = i;
        host_buffer2[i] = i;
        host_buffer3[i] = i;
        host_buffer4[i] = i;
        host_buffer5[i] = i;
        host_buffer6[i] = i;
	expected_result1[i] = i+1;
	expected_result2[i] = i+1;
	expected_result3[i] = i+1;
	expected_result4[i] = i+1;
	expected_result5[i] = i+1;
	expected_result6[i] = i+1;
    }

    //OPENCL HOST CODE AREA START
    //Create Program and Kernel
    std::vector<cl::Device> devices = xcl::get_xil_devices();
    cl::Device device = devices[0];

    cl::Context context(device);
    cl::CommandQueue q(context, device, CL_QUEUE_PROFILING_ENABLE);
    std::string device_name = device.getInfo<CL_DEVICE_NAME>(); 

    std::string binaryFile = xcl::find_binary_file(device_name,"axonerve");
    cl::Program::Binaries bins = xcl::import_binary_file(binaryFile);
    devices.resize(1);
    cl::Program program(context, devices, bins);
    cl::Kernel axonerve_kvs_rtl(program,"axonerve_kvs_rtl");

    //Allocate Buffer in Global Memory
    std::vector<cl::Memory> bufVec;
    cl::Buffer buffer_1(context,  CL_MEM_READ_WRITE | CL_MEM_USE_HOST_PTR,  vector_size_bytes, host_buffer1.data());
    cl::Buffer buffer_2(context,  CL_MEM_READ_WRITE | CL_MEM_USE_HOST_PTR,  vector_size_bytes, host_buffer2.data());
    cl::Buffer buffer_3(context,  CL_MEM_READ_WRITE | CL_MEM_USE_HOST_PTR,  vector_size_bytes, host_buffer3.data());
    cl::Buffer buffer_4(context,  CL_MEM_READ_WRITE | CL_MEM_USE_HOST_PTR,  vector_size_bytes, host_buffer4.data());
    cl::Buffer buffer_5(context,  CL_MEM_READ_WRITE | CL_MEM_USE_HOST_PTR,  vector_size_bytes, host_buffer5.data());
    cl::Buffer buffer_6(context,  CL_MEM_READ_WRITE | CL_MEM_USE_HOST_PTR,  vector_size_bytes, host_buffer6.data());

    bufVec.push_back(buffer_1);
    bufVec.push_back(buffer_2);
    bufVec.push_back(buffer_3);
    bufVec.push_back(buffer_4);
    bufVec.push_back(buffer_5);
    bufVec.push_back(buffer_6);

    //Copy input data to device global memory
    q.enqueueMigrateMemObjects(bufVec, 0/* 0 means from host*/);

    //Set the Kernel Arguments
    axonerve_kvs_rtl.setArg(0, size);
    axonerve_kvs_rtl.setArg(1, buffer_1);
    axonerve_kvs_rtl.setArg(2, buffer_2);
    axonerve_kvs_rtl.setArg(3, buffer_3);
    axonerve_kvs_rtl.setArg(4, buffer_4);
    axonerve_kvs_rtl.setArg(5, buffer_5);
    axonerve_kvs_rtl.setArg(6, buffer_6);

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
        if (expected_result2[i] != host_buffer2[i]){
            std::cout << "[2] i = " << i << " expected = " << expected_result2[i] << ", result = " << host_buffer2[i] << std::endl;
            match = 1;
        }
        if (expected_result3[i] != host_buffer3[i]){
            std::cout << "[3] i = " << i << " expected = " << expected_result3[i] << ", result = " << host_buffer3[i] << std::endl;
            match = 1;
        }
        if (expected_result4[i] != host_buffer4[i]){
            std::cout << "[4] i = " << i << " expected = " << expected_result4[i] << ", result = " << host_buffer4[i] << std::endl;
            match = 1;
        }
        if (expected_result5[i] != host_buffer5[i]){
            std::cout << "[5] i = " << i << " expected = " << expected_result5[i] << ", result = " << host_buffer5[i] << std::endl;
            match = 1;
        }
        if (expected_result6[i] != host_buffer6[i]){
            std::cout << "[6] i = " << i << " expected = " << expected_result6[i] << ", result = " << host_buffer6[i] << std::endl;
            match = 1;
        }
	if(match) break;
    }

    std::cout << "TEST " << (match ? "FAILED" : "PASSED") << std::endl; 
    return (match ? EXIT_FAILURE :  EXIT_SUCCESS);
}
