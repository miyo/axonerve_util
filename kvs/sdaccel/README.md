# Axonerve with SDAccel

This is an implementation to use Axonerve with SDAccel. Using Axonerve with OpenCL host program reduces implementation cost of bridge between software and hardware. This implementation provides a simple TCP server to use Axonerve as a simple KVS. In addition to that, this design provides interfaes for RTL designers and C++ programmers.

![overview](https://github.com/miyo/axonerve_util/raw/master/kvs/sdaccel/fig/overview.png)

## Quick Start Guide

### Create F1-instance with FPGA AMI

### setup environment

```
git clone https://github.com/aws/aws-fpga.git $AWS_FPGA_REPO_DIR
wget https://github.com/miyo/axonerve_util/releases/download/v20190516/axonerve_kvs.exe
wget https://github.com/miyo/axonerve_util/releases/download/v20190516/binary_container_1.awsxclbin
chmod 755 axonerve_kvs.exe
```

### run

```
sudo -s
source $AWS_FPGA_REPO_DIR/sdaccel_runtime_setup.sh
./axonerve_kvs.exe binary_container_1.awsxclbin
```

### after execution

Do not forget to stop the instance.

```
sudo halt -p
```

## Application guide
As an application example, a simple server for Axonerve-KVS is implemented.
To run the server, execute the following command.

```
./axonrever.exe binary_container_1.awsxclbin
```

The program starts a TCP server waiting for connection at port 16384.

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
% telnet 127.0.0.1 16384
Trying 127.0.0.1...
Connected to 127.0.0.1.
Escape character is '^]'.
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
%
```

## RTL-layer
SDAccel bridge module (`user_logic.sv`) connects between AXI4-Stream and `axonerve_kvs_kernel`. The input and output ports are the following. `p00_rd_{tvalid,tready,tlast,tdata}` are the port from application to Axonerve, and `p00_wr_{tvalid,tready,tdata}` are the port from Axonerve to application.

```
module user_logic
  #(
    parameter integer C_M_AXI_DATA_WIDTH = 512
    )
   (
    input wire                           aclk,
    input wire                           areset,
    input wire                           kernel_clk,
    input wire                           kernel_rst,
    
    input wire                           p00_rd_tvalid,
    output wire                          p00_rd_tready,
    input wire                           p00_rd_tlast,
    input wire [C_M_AXI_DATA_WIDTH-1:0]  p00_rd_tdata,
    output wire                          p00_wr_tvalid,
    input wire                           p00_wr_tready,
    output wire [C_M_AXI_DATA_WIDTH-1:0] p00_wr_tdata
    );
```

If you want to implement some application logic in RTL-layer, you can hook the input and output stream.

### Axonerver wrapper module
The module `../hdl/sources/axonerve_kvs_kernel` is a simple wrapper of Axonerve. The interface module provides the following input and output ports. 

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

RTL-designer can put commands into queue with asserting `I_CMD_VALID`. `axonerve_kvs_kernel` handles queue-ed commands with monitoring Axonerve status, apropreately. The results from Axonerve is output with asserting `O_ACK`.

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
