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
    
    return (num_error == 0 ? EXIT_SUCCESS : EXIT_FAILURE);
}