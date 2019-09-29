#ifndef AXONERVE_WORDCOUNT_HPP
#define AXONERVE_WORDCOUNT_HPP

#include "xcl2.hpp"

namespace Axonerve{

struct Word{
    unsigned char w[16];
};

struct Result{
    unsigned int value;
    unsigned int addr;
};

class AxonerveWordcount{

private:
    cl::Context* context;
    cl::CommandQueue* q;
    cl::Program* program;
    cl::Kernel* axonerve_wordcount_rtl;
    std::string binaryFile;

    void init();

 public:
    
    AxonerveWordcount(std::string binaryFile);
    void reset();
    void doWordCount(std::vector<Word, aligned_allocator<Word>>& buf);
    void getResult(std::vector<Result, aligned_allocator<Result>>& buf);
    void clear();
    void run(int command, int size);
    ~AxonerveWordcount();
    
};

}

#endif /* AXONERVE_WORDCOUNT_HPP */
