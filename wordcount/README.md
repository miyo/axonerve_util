# Wordcount Application with Axonerve

## Overview
This is implementation of Word-count application with Axonerve as an example.
This example includes the followings;
- implementing an application RTL logic to use Axonver-KVS in SDAccel framework.
- using FPGA logic implemented with SDAccel from Java with JNI
- using PlayFramework to implemnet user-intefarce for FPGA.

The below figure is the block diagram of this example.

## Getting started

### Start AWS-F1 instance and setup environment.
In the firewall settings, in-bound from 9000 port should be opned.
To use this example, Java and SBT are required. please install them as the followings.
```
sudo yum install java-11-openjdk-deve
wget https://sbt-downloads.cdnedge.bluemix.net/releases/v1.3.2/sbt-1.3.2.zip
unzip sbt-1.3.2.zip
sudo mv sbt /usr/local/
sudo ln -s /usr/local/sbt/bin/sbt /usr/local/bin/
```

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
source $AWS_FPGA_REPO_DIR/sdaccel_setup.sh 
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:.
java -Djava.library.path=. AxonerveWordcount ../bin/binary_container_1.awsxclbin
```

#### with Playframework

```
cd $(ROOTDIR)/web-frontend
source $AWS_FPGA_REPO_DIR/sdaccel_setup.sh 
sudo -s
source $AWS_FPGA_REPO_DIR/sdaccel_setup.sh 
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:./native/
/usr/local/bin/sbt run
```
Access the AWS-F1 by using Web browser.

![overview](https://github.com/miyo/axonerve_util/raw/master/wordcount/figs/frontpage.png)
![overview](https://github.com/miyo/axonerve_util/raw/master/wordcount/figs/result.png)
(cf. pg35990.txt is in http://www.gutenberg.org/cache/epub/35990/pg35990.txt)
