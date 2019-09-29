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

    int n = 32;
    std::vector<Word, aligned_allocator<Word>> buf(n);
#if 1
    for(int i = 0; i < buf.size(); i++){ buf[i].w[0] = (unsigned char)'a'; }
    for(int i = 0; i < buf.size(); i++){
       if( i % 3 == 0) buf[i].w[0] = (unsigned char)'t';
       if( i % 3 == 0) buf[i].w[1] = (unsigned char)'h';
       if( i % 3 == 0) buf[i].w[2] = (unsigned char)'e';
    }
    for(int i = 0; i < buf.size(); i++){
       if( i % 5 == 0) buf[i].w[0] = (unsigned char)'i';
       if( i % 5 == 0) buf[i].w[1] = (unsigned char)'s';
       if( i % 5 == 0) buf[i].w[2] = 0;
    }
#else
    buf[1].w[15] = (unsigned char)1;
    buf[2].w[15] = (unsigned char)0xfe;
    buf[5].w[15] = (unsigned char)0x34;
    buf[7].w[15] = (unsigned char)0xab;
    buf[8].w[15] = (unsigned char)0xcd;
    buf[15].w[15] = (unsigned char)0xaa;
    buf[17].w[15] = (unsigned char)0x55;

    for(int i = 0; i < buf.size(); i++){ buf[i].w[15] = (unsigned char)i; }
#endif

    wordcount.doWordCount(buf);
    //wordcount.doWordCount(buf);

    sleep(1);
    std::vector<Result, aligned_allocator<Result>> q(n);

    wordcount.getResult(q);
    for(int i = 0; i < q.size(); i++){
        std::cout << "addr=" << std::dec << q[i].addr << ", value=" << q[i].value << " : ";
        for(int j = 0; j < 16; j++){
            std::cout << std::setw(2) << std::setfill('0') << std::hex << (int)(buf[q[i].addr].w[j]);
        }
        std::cout << std::endl;
    }
    
    return (num_error == 0 ? EXIT_SUCCESS : EXIT_FAILURE);
}
