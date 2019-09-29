# Wordcount Application with Axonerve

## Overview
This is implementation of Word-count application with Axonerve as an example.
This example includes the followings;
- implementing an application RTL logic to use Axonver-KVS in SDAccel framework.
- using FPGA logic implemented with SDAccel from Java with JNI
- using PlayFramework to implemnet user-intefarce for FPGA.

The below figure is the block diagram of this example.

## Getting started

### Start AWS-F1 instance
In the firewall settings, in-bound from 9000 port should be opned.

### Clone this repositry and move the working directory

```
git clone https://github.com/miyo/axonerve_util.git
cd wordcount
export ROOTDIR=`pwd`
```

### build and run

#### with C++ program

```
cd $(ROOTDIR)/sdaccel/software
source $AWS_FPGA_REPO_DIR/sdaccel_setup.sh 
make
sudo -s
source $AWS_FPGA_REPO_DIR/sdaccel_setup.sh 
./axonerve.exe ../bin/binary_container_1.awsxclbin
```

#### with Java

```
cd $(ROOTDIR)/sdaccel/software
source $AWS_FPGA_REPO_DIR/sdaccel_setup.sh 
make libaxonerve_wordcount.so
javac AxonerveWordcount.java
sudo -s
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:.
java -Djava.library.path=. AxonerveWordcount ../bin/binary_container_1.awsxclbin
```

#### with Playframework

```
cd $(ROOTDIR)/web-frontend
source $AWS_FPGA_REPO_DIR/sdaccel_setup.sh 
sbt compile
sudo -s
```


## Example
 % wget http://www.gutenberg.org/cache/epub/35990/pg35990.txt
