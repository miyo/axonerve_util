## RTL-layer
As RTL-layer library, a simple wrapper module named `axonerve_kvs_kernel` is implemented. The interface module provides the following input and output ports. RTL-designer can put commands into queue with asserting `I_CMD_VALID`. `axonerve_kvs_kernel` handles queue-ed commands with monitoring Axonerve status, apropreately. The results from Axonerve is output with asserting `O_ACK`.

```
module axonerve_kvs_kernel (
                            input wire           I_CLK,
                            input wire           I_CLKX2,
                            input wire           I_XRST, // active low
                            output logic [31:0]  O_VERSION,
                            output logic         O_READY,
                            output logic         O_WAIT,

                            output logic         O_ACK,
                            output logic         O_ENT_ERR,
                            output logic         O_SINGLE_HIT,
                            output logic         O_MULTI_HIT,
                            output logic [127:0] O_KEY_DAT,
                            output logic [127:0] O_EKEY_MSK,
                            output logic [6:0]   O_KEY_PRI,
                            output logic [31:0]  O_KEY_VALUE,
                            output logic         O_CMD_EMPTY,
                            output logic         O_CMD_FULL,
                            output logic         O_ENT_FULL,
                            output logic [31:0]  O_KERNEL_STATUS,

                            input wire           I_CMD_INIT,
                            input wire           I_CMD_VALID,
                            input wire           I_CMD_ERASE,
                            input wire           I_CMD_WRITE,
                            input wire           I_CMD_READ,
                            input wire           I_CMD_SEARCH,
                            input wire           I_CMD_UPDATE,
                            input wire [127:0]   I_KEY_DAT,
                            input wire [127:0]   I_EKEY_MSK,
                            input wire [6:0]     I_KEY_PRI,
                            input wire [31:0]    I_KEY_VALUE
                            );
```

## SDAccel bridge
SDAccel bridge module (`user_logic.sv`) connects between AXI4-Stream and `axonerve_kvs_kernel`.

## C++-layer
A programmer can access Axonerve-KVS by using C++ APIs. the provided APIs are followings. When you use C++ APIs, include `axonerve_kvs.hpp` and link `axonerve_kvs.cpp` with your program.

| function                            | description                                                       |
|:------------------------------------|:------------------------------------------------------------------|
|`AxonerveKVS(std::string binaryFile)` | initialize Axonerve-KVS with FPGA bit-file specified by binaryFile|
|`void reset()`                        | reset Axonerve-KVS                                                |
|`void put(unsigned int key[4], unsigned int value)`| put value with `key[4]`
|`bool get(unsigned int key[4], unsigned int& value)`|search value with `key[4]`. the return value is the entry exists or not. found value is stored into `value`|
|`void remove(unsigned int key[4])`    | remove the entry with `key[4]`
|`~AxonerveKVS()`                      | close Axonerver-KVS                                               |



## Application-layer
As an application example, a simple server for Axonerve-KVS is implemented.

To run the server, execute the following command. The server wait for connection at 16384 port.

```
./axonrever.exe binary_container_1.awsxclbin
```

Client-side can access the server with telnet like the following.

```
telnet localhost 16384
```

The server provides the following commands. <key> and <value> are 16-Bytes and 4-Bytes, respectively.

| command      | description                      |
|:-------------|:---------------------------------|
|p<key><value> |put <value> with <key>            |
|r<key>        |remove the entry with <key>       |
|g<key>        |serchr the entry with <key>       |
|i             |reset Axonerve. remove all entries|
|q             |close connection                  |
|Q             |shutdown the server               |

The following is an example.

```
telnet localhost 16384
p0123456789abcdefmiyo     # put value <miyo> with key <0123456789abcdef>
P                         # success
g0123456789abcdef         # search the entry with key <0123456789abcdef>
GTmiyo                    # result, T=search success, miyo=return value
r0123456789abcdef         # remove the entry with key <0123456789abcdef>
R                         # success
g0123456789abcdef         # search the entry with key <0123456789abcdef>
GF                        # result, F=search failure
i                         # clear
Q                         # shutdown the server
```
