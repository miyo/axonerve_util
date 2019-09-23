#include <iostream>
#include <iomanip>
#include <vector>

#include <stdio.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>

#include "axonerve_wordcount.hpp"

using namespace Axonerve;

int main(int argc, char** argv)
{
    int num_error = 0;
    if(argc < 2){
        std::cout << "usage: " << argv[0] << " xclbin" << std::endl;
        return EXIT_FAILURE;
    }
    
    std::string bin = std::string(argv[1]); 
    AxonerveWordcount wordcount(bin);
    
    wordcount.clear();

    std::vector<Word, aligned_allocator<Word>> buf(32);
    for(int i = 0; i < buf.size(); i++){
        for(int j = 0; j < 16; j++){
            buf[i].w[j] = (unsigned char)i;
        }
    }
    wordcount.doWordCount(buf);
    std::vector<Result, aligned_allocator<Result>> q(32);
    wordcount.getResult(q);
    for(int i = 0; i < q.size(); i++){
        std::cout << "addr=" << q[i].addr << ", value=" << q[i].value << " : ";
        for(int j = 0; j < 16; j++){
            std::cout << std::setw(2) << std::setfill('0') << std::hex << (int)(buf[q[i].addr].w[j]);
        }
        std::cout << std::endl;
    }
    
    return (num_error == 0 ? EXIT_SUCCESS : EXIT_FAILURE);
}
