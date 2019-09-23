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

    {
        std::vector<Word, aligned_allocator<Word>> buf(32);
        for(int i = 0; i < 16; i++){
            for(int j = 0; j < 16; j++){
                buf[i].w[j] = 0xFE;
            }
        }
        for(int i = 0; i < 16; i++){
            for(int j = 0; j < 16; j++){
                buf[i].w[j] = 0x55;
            }
        }
        wordcount.doWordCount(buf);
    }

    {
        std::vector<Result, aligned_allocator<Result>> buf(16);
        wordcount.getResult(buf);
        for(int i = 0; i < buf.size(); i++){
            std::cout << "addr=" << buf[i].addr << ", value=" << buf[i].value << std::endl;
        }
    }
    
    return (num_error == 0 ? EXIT_SUCCESS : EXIT_FAILURE);
}
