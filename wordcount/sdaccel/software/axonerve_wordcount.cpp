#include <iostream>
#include <iomanip>
#include <memory>
#include <vector>
#include <unistd.h>

#define VERBOSE (0)

#include "axonerve_wordcount.hpp"

namespace Axonerve{
    
void AxonerveWordcount::doWordCount(std::vector<Word, aligned_allocator<Word>>& buf){
    size_t vector_size_bytes = sizeof(Word) * buf.size();
    //Allocate Buffer in Global Memory
    std::vector<cl::Memory> bufVec;
    cl::Buffer buffer_1(*context,  CL_MEM_READ_WRITE | CL_MEM_USE_HOST_PTR,  vector_size_bytes, buf.data());

    bufVec.push_back(buffer_1);

    //Copy input data to device global memory
    q->enqueueMigrateMemObjects(bufVec, 0/* 0 means from host*/);
    
    //Set the Kernel Arguments
    int data_num = buf.size();
    int command = 1; // wordcount
    axonerve_wordcount_rtl->setArg(0, data_num);
    axonerve_wordcount_rtl->setArg(1, command);
    axonerve_wordcount_rtl->setArg(2, 0); // reserved
    axonerve_wordcount_rtl->setArg(3, buffer_1);

    //Launch the Kernel
    q->enqueueTask(*axonerve_wordcount_rtl);

    q->finish();
}

void AxonerveWordcount::getResult(std::vector<Result, aligned_allocator<Result>>& buf){
    size_t vector_size_bytes = sizeof(Result) * buf.size();
    //Allocate Buffer in Global Memory
    std::vector<cl::Memory> bufVec;
    cl::Buffer buffer_1(*context,  CL_MEM_READ_WRITE | CL_MEM_USE_HOST_PTR,  vector_size_bytes, buf.data());

    bufVec.push_back(buffer_1);

    //Set the Kernel Arguments
    int data_num = buf.size();
    int command = 2; // result_copy
    axonerve_wordcount_rtl->setArg(0, data_num);
    axonerve_wordcount_rtl->setArg(1, command);
    axonerve_wordcount_rtl->setArg(2, 0); // reserved
    axonerve_wordcount_rtl->setArg(3, buffer_1);

    //Launch the Kernel
    q->enqueueTask(*axonerve_wordcount_rtl);

    //Copy Result from Device Global Memory to Host Local Memory
    q->enqueueMigrateMemObjects(bufVec, CL_MIGRATE_MEM_OBJECT_HOST);
    q->finish();
}

void AxonerveWordcount::clear(){
    int command = 3; // clear
    axonerve_wordcount_rtl->setArg(0, 0);
    axonerve_wordcount_rtl->setArg(1, command);
    axonerve_wordcount_rtl->setArg(2, 0); // reserved
    axonerve_wordcount_rtl->setArg(3, 0);

    q->enqueueTask(*axonerve_wordcount_rtl);

    q->finish();
}

void AxonerveWordcount::init(){
    std::cerr << "initialize Axonerve Wordcount" << std::endl;
    std::vector<cl::Device> devices = xcl::get_xil_devices();
    cl::Device device = devices[0];
    
    context = new cl::Context(device);
    q = new cl::CommandQueue(*context, device, CL_QUEUE_PROFILING_ENABLE);
    
    std::string device_name = device.getInfo<CL_DEVICE_NAME>(); 
    cl::Program::Binaries bins = xcl::import_binary_file(binaryFile);
    devices.resize(1);
    program = new cl::Program(*context, devices, bins);
    axonerve_wordcount_rtl = new cl::Kernel(*program, "axonerve_wordcount_rtl");
    
    std::cerr << "init wait...";
    sleep(1);
    std::cerr << "done." << std::endl;
}

void AxonerveWordcount::reset(){
    delete(context);
    delete(q);
    delete(program);
    delete(axonerve_wordcount_rtl);
    init();
}

AxonerveWordcount::AxonerveWordcount(std::string binaryFile) : binaryFile(binaryFile){
    init();
}

AxonerveWordcount::~AxonerveWordcount(){
    std::cerr << "finalize Axonerve Wordcount" << std::endl;
    delete(context);
    delete(q);
    delete(program);
    delete(axonerve_wordcount_rtl);
}

}
