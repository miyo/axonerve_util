#include <iostream>
#include <iomanip>
#include <vector>

#include "xcl2.hpp"
#include "axonerve_kvs.hpp"

int main(int argc, char** argv)
{
    AxonerveKVS kvs;
    int num_error = 0;

    {
	std::cout << "put and get {0xdeadbeef, 0xdeadbeef, 0xdeadbeef, 0xdeadbeef} <- 0x00ababab" << std::endl;
	unsigned int key[4] = {0xdeadbeef, 0xdeadbeef, 0xdeadbeef, 0xdeadbeef};
	unsigned int value = 0;
	bool f;
	kvs.put(key, 0x00ababab);
	f = kvs.get(key, value);
	std::cout << (f ? "true" : "false") << ", " << "0x" << std::hex << std::setw(8) << std::setfill('0') << value << std::endl;
	num_error += !(f == true && value == 0x00ababab);
    }
    std::cout << "Error: " << num_error << std::endl;
    
    {
	std::cout << "put and get {0xabadcafe, 0xabadcafe, 0xabadcafe, 0xabadcafe} <- 0x34343434" << std::endl;
	unsigned int key[4] = {0xabadcafe, 0xabadcafe, 0xabadcafe, 0xabadcafe};
	unsigned int value = 0;
	bool f;
	kvs.put(key, 0x34343434);
	f = kvs.get(key, value);
	std::cout << (f ? "true" : "false") << ", " << "0x" << std::hex << std::setw(8) << std::setfill('0') << value << std::endl;
	num_error += !(f == true && value == 0x34343434);
    }
    std::cout << "Error: " << num_error << std::endl;

    {
	std::cout << "get {0xabadcafe, 0xabadcafe, 0xabadcafe, 0xabadcafe}" << std::endl;
	unsigned int key[4] = {0xdeadbeef, 0xdeadbeef, 0xdeadbeef, 0xdeadbeef};
	unsigned int value = 0;
	bool f;
	f = kvs.get(key, value);
	std::cout << (f ? "true" : "false") << ", " << "0x" << std::hex << std::setw(8) << std::setfill('0') << value << std::endl;
	num_error += !(f == true && value == 0x00ababab);
    }
    std::cout << "Error: " << num_error << std::endl;

    {
	std::cout << "get {0x00000000, 0x00000000, 0x00000000, 0x00000000}" << std::endl;
	unsigned int key[4] = {0x00000000, 0x00000000, 0x00000000, 0x00000000};
	unsigned int value = 0;
	bool f;
	f = kvs.get(key, value);
	std::cout << (f ? "true" : "false") << ", " << "0x" << std::hex << std::setw(8) << std::setfill('0') << value << std::endl;
	num_error += !(f == false);
    }
    std::cout << "Error: " << num_error << std::endl;

    {
	std::cout << "get {0xabadcafe, 0xabadcafe, 0xabadcafe, 0xabadcafe}" << std::endl;
	unsigned int key[4] = {0xabadcafe, 0xabadcafe, 0xabadcafe, 0xabadcafe};
	unsigned int value = 0;
	bool f;
	f = kvs.get(key, value);
	std::cout << (f ? "true" : "false") << ", " << "0x" << std::hex << std::setw(8) << std::setfill('0') << value << std::endl;
	num_error += !(f == true && value == 0x34343434);
    }
    std::cout << "Error: " << num_error << std::endl;

    std::cout << "init" << std::endl;
    kvs.reset();
    
    {
	std::cout << "get {0xabadcafe, 0xabadcafe, 0xabadcafe, 0xabadcafe}" << std::endl;
	unsigned int key[4] = {0xabadcafe, 0xabadcafe, 0xabadcafe, 0xabadcafe};
	unsigned int value = 0;
	bool f;
	f = kvs.get(key, value);
	std::cout << (f ? "true" : "false") << ", " << "0x" << std::hex << std::setw(8) << std::setfill('0') << value << std::endl;
	num_error += !(f == false);
    }
    std::cout << "Error: " << num_error << std::endl;

    {
	std::cout << "put and get {0xdeadbeef, 0xdeadbeef, 0xdeadbeef, 0xdeadbeef} <- 0x00ababab" << std::endl;
	unsigned int key[4] = {0xdeadbeef, 0xdeadbeef, 0xdeadbeef, 0xdeadbeef};
	unsigned int value = 0;
	bool f;
	kvs.put(key, 0x00ababab);
	f = kvs.get(key, value);
	std::cout << (f ? "true" : "false") << ", " << "0x" << std::hex << std::setw(8) << std::setfill('0') << value << std::endl;
	num_error += !(f == true && value == 0x00ababab);
    }
    std::cout << "Error: " << num_error << std::endl;

    for(unsigned int i = 0; i < 16384; i++){
	unsigned int key[4] = {i, i, i, i};
	kvs.put(key, i+100);
    }
    for(unsigned int i = 0; i < 16384; i++){
	unsigned int key[4] = {i, i, i, i};
	unsigned int value = 0;
	bool f;
	f = kvs.get(key, value);
	std::cout << (f ? "true" : "false") << ", " << "0x" << std::hex << std::setw(8) << std::setfill('0') << value;
	num_error += !(f == true && value == i+100);
	std::cout << " " << ((value == i+100) ? "OK" : "ERROR");
	std::cout << std::endl;
    }
    std::cout << "Error: " << num_error << std::endl;

    return (num_error == 0 ? EXIT_SUCCESS : EXIT_FAILURE);
}
