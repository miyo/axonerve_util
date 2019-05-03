#ifndef AXONERVE_KVS_HPP
#define AXONERVE_KVS_HPP

#include "xcl2.hpp"

class AxonerveKVS{

private:
    cl::Context* context;
    cl::CommandQueue* q;
    cl::Program* program;
    cl::Kernel* axonerve_kvs_rtl;
    std::string binaryFile;

    void init();

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

    void emit_task(std::vector<axonerve_query,aligned_allocator<axonerve_query>>& buf);
    void dump(std::vector<axonerve_query,aligned_allocator<axonerve_query>>& buf);

 public:
    
    AxonerveKVS(std::string binaryFile);
    void reset();
    void put(unsigned int key[4], unsigned int value);
    bool get(unsigned int key[4], unsigned int& value);
    ~AxonerveKVS();
    
};

#endif /* AXONERVE_KVS_HPP */
