#ifndef AXONERVE_WORDCOUNT_HPP
#define AXONERVE_WORDCOUNT_HPP

#include "xcl2.hpp"

namespace Axonerve{

struct Word{
    unsigned char w[16];
};

struct Result{
    unsigned int addr;
    unsigned int value;
};

class AxonerveWordcount{

private:
    cl::Context* context;
    cl::CommandQueue* q;
    cl::Program* program;
    cl::Kernel* axonerve_wordcount_rtl;
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

 public:
    
    AxonerveWordcount(std::string binaryFile);
    void reset();
    void doWordCount(std::vector<Word, aligned_allocator<Word>>& buf);
    bool getResult(std::vector<Result, aligned_allocator<Result>>& buf);
    void clear();
    void run(int command, int size);
    ~AxonerveWordcount();
    
};

}

#endif /* AXONERVE_WORDCOUNT_HPP */
