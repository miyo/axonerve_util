#include <iostream>
#include <iomanip>
#include <vector>

#include <stdio.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>

#include "axonerve_kvs.hpp"

const int SERVER_PORT = 0x4000;
const int MAX_RQUEUE = 1024;

unsigned to_uint(std::vector<char> vec, int pos){
    unsigned int ret = 0;
    for(int i = 0; i < 4; i++){
	ret += (((unsigned int)vec[pos+i]) & 0x000000FF) << (i * 8);
    }
    return ret;
}

void server_run(AxonerveKVS& kvs){
    int sockfd;
    int client_sockfd;
    struct sockaddr_in addr;
 
    socklen_t len = sizeof( struct sockaddr_in );
    struct sockaddr_in from_addr;
 
    // create socket
    if((sockfd = socket(AF_INET, SOCK_STREAM, 0)) < 0){
	perror("failed: create socket");
	return;
    }
    
    int flag = 1;
    setsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR, (void*)&flag, sizeof(int));
    
    addr.sin_family = AF_INET;
    addr.sin_port = htons(SERVER_PORT);
    addr.sin_addr.s_addr = INADDR_ANY;
 
    if(bind(sockfd, (struct sockaddr *)&addr, sizeof(addr)) < 0){
	perror("failed: bind");
	return;
    }
 
    // listen
    if(listen(sockfd, SOMAXCONN) < 0){
	perror("failed: listen");
	return;
    }

    std::cout << "start server port=" << std::dec << SERVER_PORT << std::endl;
    std::cout << "to stop server, send 'Q'" << std::endl;

    unsigned int run_loop = 1;
    std::vector<char> rqueue;
    while(run_loop){
	// wait for connected
	if((client_sockfd = accept(sockfd, (struct sockaddr *)&from_addr, &len)) < 0){
	    perror("failed: accept");
	}

	rqueue.clear();
	// receive loop
	for(;;){
	    char buf[1024];
	    size_t rsize = recv(client_sockfd, buf, sizeof(buf), 0);
	    
	    if(rsize == 0){
		break;
	    }else{
		
		for(unsigned int i = 0; i < rsize; i++){
		    rqueue.push_back(buf[i]);
		}
		if(rqueue.size() > MAX_RQUEUE){ // close connection
		    break;
		}

		int pos = -1;
		for(unsigned int i = 0; i < rqueue.size(); i++){
		    if(rqueue[i] == '\n'){
			pos = i;
		    }
		}
		if(pos == -1) continue; // wait for next receive

		std::vector<char> mesg(pos+1);
		for(int i = 0; i < pos+1; i++){
		    mesg[i] = rqueue[0];
		    rqueue.erase(rqueue.begin());
		}
		
		//std::cout << "recev mesg=";
		//for(unsigned int i = 0; i < mesg.size(); i++){
		//    std::cout << " " << std::hex << std::setw(2) << std::setfill('0') << (int)mesg[i];
		//}
		//std::cout << ", len=" << mesg.size() << std::endl;
		
		if(mesg[0] == 'Q'){ // stop server
		    run_loop = 0;
		    break;
		}else if(mesg[0] == 'q'){ // close connection
		    break;
		}else if(mesg[0] == 'i'){ // init
		    kvs.reset();
		    mesg.clear();
		    mesg.push_back('I');
		}else if(mesg[0] == 'p' && mesg.size() > 21){
		    unsigned int k[4] = {to_uint(mesg, 1), to_uint(mesg, 5), to_uint(mesg, 9), to_uint(mesg, 13)};
		    unsigned int v = to_uint(mesg, 17);
		    std::cout << "put key=" << k[0] << k[1] << k[2] << k[3] << ", value=" << v << std::endl;
		    kvs.put(k, v);
		    mesg.clear();
		    mesg.push_back('P');
		}else if(mesg[0] == 'g' && mesg.size() > 17){
		    unsigned int k[4] = {to_uint(mesg, 1), to_uint(mesg, 5), to_uint(mesg, 9), to_uint(mesg, 13)};
		    unsigned int v = 0;
		    std::cout << "get key=" << k[0] << k[1] << k[2] << k[3] << std::endl;
		    bool f = kvs.get(k, v);
		    std::cout << " result flag=" << f << ", value=" << v << std::endl;
		    mesg.clear();
		    mesg.push_back('G');
		    mesg.push_back(f == true ? 'T' : 'F');
		    for(unsigned int i = 0; i < 4; i++){
			mesg.push_back((char)(v & 0x000000FF));
			v >>= 8;
		    }
		}else{
		    mesg.clear();
		    mesg.push_back('E');
		}
		mesg.push_back('\r');
		mesg.push_back('\n');
		
		// reply
		size_t ssize = mesg.size();
		do{
		    int slen = write(client_sockfd, mesg.data(), ssize);
		    ssize -= slen;
		    mesg.erase(mesg.begin(), mesg.begin()+slen);
		}while(ssize > 0);
	    }
	}
	close(client_sockfd);
    }
    
    close(sockfd);
}

int main(int argc, char** argv)
{
    AxonerveKVS kvs("./binary_container_1.xclbin");
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

    server_run(kvs);

    return (num_error == 0 ? EXIT_SUCCESS : EXIT_FAILURE);
}
