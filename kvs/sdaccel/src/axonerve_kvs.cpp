#include <iostream>
#include <iomanip>
#include <memory>
#include <vector>
#include <unistd.h>

#define VERBOSE (0)

#include "axonerve_kvs.hpp"

namespace Axonerve{
    
void AxonerveKVS::emit_task(std::vector<axonerve_query,aligned_allocator<axonerve_query>>& buf){
    int size = buf.size();
    size_t vector_size_bytes = sizeof(axonerve_query) * size;
    //Allocate Buffer in Global Memory
    std::vector<cl::Memory> bufVec;
    cl::Buffer buffer_1(*context,  CL_MEM_READ_WRITE | CL_MEM_USE_HOST_PTR,  vector_size_bytes, buf.data());

    bufVec.push_back(buffer_1);

    //Copy input data to device global memory
    q->enqueueMigrateMemObjects(bufVec, 0/* 0 means from host*/);

    //Set the Kernel Arguments
    int data_num = vector_size_bytes;
    axonerve_kvs_rtl->setArg(0, data_num);
    axonerve_kvs_rtl->setArg(1, buffer_1);

    //Launch the Kernel
    q->enqueueTask(*axonerve_kvs_rtl);

    //Copy Result from Device Global Memory to Host Local Memory
    q->enqueueMigrateMemObjects(bufVec, CL_MIGRATE_MEM_OBJECT_HOST);
    q->finish();
}

void AxonerveKVS::dump(std::vector<axonerve_query,aligned_allocator<axonerve_query>>& buf){
    int size = buf.size();
    for (int i = 0 ; i < size ; i++){
	std::string sep = "";
	for(int j = 0; j < 4; j++){
	    std::cout << sep << "0x" << std::hex << std::setw(8) << std::setfill('0') << buf[i].key[j];
	    sep = " ";
	}
	std::cout << std::endl;
	std::cout << "0x" << std::hex << std::setw(8) << std::setfill('0') << buf[i].value << std::endl;
	std::cout << "0x" << std::hex << std::setw(8) << std::setfill('0') << buf[i].csr << std::endl;
	std::cout << "  SINGLE_HIT: " << ((buf[i].csr & 0x00000001) >> 0) << std::endl;
	std::cout << "  MULTI_HIT: "  << ((buf[i].csr & 0x00000002) >> 1) << std::endl;
	std::cout << "  ENT_ERR: "    << ((buf[i].csr & 0x00000004) >> 2) << std::endl;
	std::cout << "  ENT_FULL: "   << ((buf[i].csr & 0x00000008) >> 3) << std::endl;
	std::cout << "0x" << std::hex << std::setw(8) << std::setfill('0') << buf[i].priority << std::endl;
	for(int j = 0; j < 4; j++){
	    std::cout << sep << "0x" << std::hex << std::setw(8) << std::setfill('0') << buf[i].mask[j];
	    sep = " ";
	}
	std::cout << "0x" << std::hex << std::setw(8) << std::setfill('0') << buf[i].kernel_status << std::endl;
	std::cout << "0x" << std::hex << std::setw(8) << std::setfill('0') << buf[i].version << std::endl;
    }
}

void AxonerveKVS::init(){
    std::cerr << "initialize Axonerve KVS" << std::endl;
    std::vector<cl::Device> devices = xcl::get_xil_devices();
    cl::Device device = devices[0];
    
    context = new cl::Context(device);
    q = new cl::CommandQueue(*context, device, CL_QUEUE_PROFILING_ENABLE);
    
    std::string device_name = device.getInfo<CL_DEVICE_NAME>(); 
    //std::string binaryFile = xcl::find_binary_file(device_name,"axonerve");
    //std::string binaryFile = "./binary_container_1.xclbin";
    cl::Program::Binaries bins = xcl::import_binary_file(binaryFile);
    devices.resize(1);
    program = new cl::Program(*context, devices, bins);
    axonerve_kvs_rtl = new cl::Kernel(*program, "axonerve_kvs_rtl");
    
    std::cerr << "init wait...";
    sleep(1);
    std::cerr << "done." << std::endl;
}

AxonerveKVS::AxonerveKVS(std::string binaryFile) : binaryFile(binaryFile){
    init();
}

void AxonerveKVS::reset(){
    delete(context);
    delete(q);
    delete(program);
    delete(axonerve_kvs_rtl);
    init();
}

void AxonerveKVS::put(unsigned int key[4], unsigned int value){
    //Allocate Memory in Host Memory
    std::vector<axonerve_query,aligned_allocator<axonerve_query>> host_buffer1(1);

    // Create the test data and Software Result
    host_buffer1[0].key[0] = key[0];
    host_buffer1[0].key[1] = key[1];
    host_buffer1[0].key[2] = key[2];
    host_buffer1[0].key[3] = key[3];
    host_buffer1[0].value = value;
    host_buffer1[0].csr = 0x20;
    host_buffer1[0].priority = 0;
    host_buffer1[0].mask[0] = 0;
    host_buffer1[0].mask[1] = 0;
    host_buffer1[0].mask[2] = 0;
    host_buffer1[0].mask[3] = 0;
    host_buffer1[0].kernel_status = 0;
    host_buffer1[0].version = 0;
	
#if VERBOSE > 1
    std::cerr << "Queries" << std::endl;
    dump(host_buffer1);
#endif
    emit_task(host_buffer1);
#if VERBOSE > 1
    std::cerr << "Results" << std::endl;
    dump(host_buffer1);
#endif
}

void AxonerveKVS::put_all(std::vector<Data>& data){
    //Allocate Memory in Host Memory
    std::vector<axonerve_query,aligned_allocator<axonerve_query>> host_buffer1(1);

    // Create the test data and Software Result
    for(unsigned int i = 0; i < data.size(); i++){
	Data d = data.at(i);
	host_buffer1[i].key[0] = d.key[0];
	host_buffer1[i].key[1] = d.key[1];
	host_buffer1[i].key[2] = d.key[2];
	host_buffer1[i].key[3] = d.key[3];
	host_buffer1[i].value = d.value;
	host_buffer1[i].csr = 0x20;
	host_buffer1[i].priority = 0;
	host_buffer1[i].mask[0] = 0;
	host_buffer1[i].mask[1] = 0;
	host_buffer1[i].mask[2] = 0;
	host_buffer1[i].mask[3] = 0;
	host_buffer1[i].kernel_status = 0;
	host_buffer1[i].version = 0;
    }
	
#if VERBOSE > 1
    std::cerr << "Queries" << std::endl;
    dump(host_buffer1);
#endif
    emit_task(host_buffer1);
#if VERBOSE > 1
    std::cerr << "Results" << std::endl;
    dump(host_buffer1);
#endif
}

void AxonerveKVS::get_all(std::vector<Data>& data, std::vector<unsigned int>& values, std::vector<bool>& flags){
    //Allocate Memory in Host Memory
    std::vector<axonerve_query,aligned_allocator<axonerve_query>> host_buffer1(1);

    // Create the test data and Software Result
    for(unsigned int i = 0; i < data.size(); i++){
	Data d = data.at(i);
	host_buffer1[i].key[0] = d.key[0];
	host_buffer1[i].key[1] = d.key[1];
	host_buffer1[i].key[2] = d.key[2];
	host_buffer1[i].key[3] = d.key[3];
	host_buffer1[i].value = d.value;
	host_buffer1[i].csr = 0x10;
	host_buffer1[i].priority = 0;
	host_buffer1[i].mask[0] = 0;
	host_buffer1[i].mask[1] = 0;
	host_buffer1[i].mask[2] = 0;
	host_buffer1[i].mask[3] = 0;
	host_buffer1[i].kernel_status = 0;
	host_buffer1[i].version = 0;
    }
	
#if VERBOSE > 1
    std::cerr << "Queries" << std::endl;
    dump(host_buffer1);
#endif
    emit_task(host_buffer1);
#if VERBOSE > 1
    std::cerr << "Results" << std::endl;
    dump(host_buffer1);
#endif
    for(unsigned int i = 0; i < data.size(); i++){
        values.at(i) = host_buffer1[i].value;
        flags.at(i) = (host_buffer1[i].csr & 0x03);
    }
    return;
}

bool AxonerveKVS::get(unsigned int key[4], unsigned int& value){
    //Allocate Memory in Host Memory
    std::vector<axonerve_query,aligned_allocator<axonerve_query>> host_buffer1(1);

    // Create the test data and Software Result
    host_buffer1[0].key[0] = key[0];
    host_buffer1[0].key[1] = key[1];
    host_buffer1[0].key[2] = key[2];
    host_buffer1[0].key[3] = key[3];
    host_buffer1[0].value = 0;
    host_buffer1[0].csr = 0x10;
    host_buffer1[0].priority = 0;
    host_buffer1[0].mask[0] = 0;
    host_buffer1[0].mask[1] = 0;
    host_buffer1[0].mask[2] = 0;
    host_buffer1[0].mask[3] = 0;
    host_buffer1[0].kernel_status = 0;
    host_buffer1[0].version = 0;
	
#if VERBOSE > 1
    std::cerr << "Queries" << std::endl;
    dump(host_buffer1);
#endif
    emit_task(host_buffer1);
#if VERBOSE > 1
    std::cerr << "Results" << std::endl;
    dump(host_buffer1);
#endif
    value = host_buffer1[0].value;
    return (host_buffer1[0].csr & 0x03);
}

void AxonerveKVS::remove(unsigned int key[4]){
    //Allocate Memory in Host Memory
    std::vector<axonerve_query,aligned_allocator<axonerve_query>> host_buffer1(1);

    // Create the test data and Software Result
    host_buffer1[0].key[0] = key[0];
    host_buffer1[0].key[1] = key[1];
    host_buffer1[0].key[2] = key[2];
    host_buffer1[0].key[3] = key[3];
    host_buffer1[0].value = 0;
    host_buffer1[0].csr = 0x02;
    host_buffer1[0].priority = 0;
    host_buffer1[0].mask[0] = 0;
    host_buffer1[0].mask[1] = 0;
    host_buffer1[0].mask[2] = 0;
    host_buffer1[0].mask[3] = 0;
    host_buffer1[0].kernel_status = 0;
    host_buffer1[0].version = 0;
	
#if VERBOSE > 1
    std::cerr << "Queries" << std::endl;
    dump(host_buffer1);
#endif
    emit_task(host_buffer1);
#if VERBOSE > 1
    std::cerr << "Results" << std::endl;
    dump(host_buffer1);
#endif
    return;
}

AxonerveKVS::~AxonerveKVS(){
    std::cerr << "finalize Axonerve KVS" << std::endl;
    delete(context);
    delete(q);
    delete(program);
    delete(axonerve_kvs_rtl);
}

}
