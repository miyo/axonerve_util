#
# this file was created by a computer. trust it.
#

# compiler tools
XILINX_VIVADO_HLS ?= $(XILINX_SDX)/Vivado_HLS

SDX_CXX ?= $(XILINX_SDX)/bin/xcpp
XOCC ?= $(XILINX_SDX)/bin/xocc
RM = rm -f
RMDIR = rm -rf

SDX_PLATFORM = xilinx_aws-vu9p-f1-04261818_dynamic_5_0

# host compiler global settings
CXXFLAGS += -DSDX_PLATFORM=$(SDX_PLATFORM) -D__USE_XOPEN2K8 -I/opt/xilinx/xrt/include/ -I/opt/Xilinx/Vivado/2018.3.op2405991/include/ -O2 -Wall -fmessage-length=0 -std=c++14
LDFLAGS += -lxilinxopencl -lpthread -lrt -lstdc++ -L/opt/Xilinx/SDx/2018.3.op2405991/runtime/lib/x86_64

# kernel compiler global settings
XOCC_OPTS = -t hw --platform $(SDX_PLATFORM) --save-temps  

#
# OpenCL kernel files
#

#BINARY_CONTAINERS += binary_container_1.xclbin

BINARY_CONTAINER_1_OBJS += ../src/sdx_rtl_kernel/axonerve_wordcount_rtl/axonerve_wordcount_rtl.xo

ALL_MESSAGE_FILES = $(subst .xo,.mdb,$(ALL_KERNEL_OBJS)) $(subst .xclbin,.mdb,$(BINARY_CONTAINERS))

#
# host files
#

HOST_OBJECTS += axonerve_wordcount.o
HOST_OBJECTS += host.o
HOST_OBJECTS += xcl2.o

HOST_EXE = axonerve.exe

BUILD_SUBDIRS += src/

#
# primary build targets
#

.PHONY: all clean exe
all: $(BINARY_CONTAINERS) $(HOST_EXE)

exe: $(HOST_EXE)

.NOTPARALLEL: clean

clean:
	-$(RM) $(HOST_EXE) $(HOST_OBJECTS) *.so
# 	-$(RM) $(BINARY_CONTAINERS) $(ALL_KERNEL_OBJS) $(ALL_MESSAGE_FILES)  $(HOST_EXE) $(HOST_OBJECTS)
# 	-$(RM) *.xclbin.sh
# 	-$(RMDIR) $(BUILD_SUBDIRS)
# 	-$(RMDIR) _xocc*
# 	-$(RMDIR) .Xil
# 	-$(RMDIR) .so

.PHONY: incremental
incremental: all


nothing:

#
# binary container: binary_container_1.xclbin
#

# binary_container_1.xclbin: $(BINARY_CONTAINER_1_OBJS)
# 	-@echo $(XOCC) $(XOCC_OPTS) -l --nk axonerve_wordcount_rtl:1 --messageDb $(subst .xclbin,.mdb,$@) --xp misc:solution_name=link --temp_dir binary_container_1 --report_dir binary_container_1/reports --log_dir binary_container_1/logs --kernel_frequency "0:100|1:200" --remote_ip_cache /mnt/home/miyo/work/axonerve_util/wordcount/sdaccel/build/ip_cache -o"$@" $(+) > binary_container_1.xclbin.sh
# 	$(XOCC) $(XOCC_OPTS) -l --nk axonerve_wordcount_rtl:1 --messageDb $(subst .xclbin,.mdb,$@) --xp misc:solution_name=link --temp_dir binary_container_1 --report_dir binary_container_1/reports --log_dir binary_container_1/logs --kernel_frequency "0:100|1:200" --remote_ip_cache /mnt/home/miyo/work/axonerve_util/wordcount/sdaccel/build/ip_cache -o"$@" $(+)

#
# host rules
#

host.exe: libaxonerve_wordcount.so host.o
	g++ host.o -o host -L. -laxonerve_wordcount -lxilinxopencl -lpthread -lrt -lstdc++ -L/opt/Xilinx/SDx/2018.3.op2405991/runtime/lib/x86_64 -L/opt/xilinx/xrt/lib/

libaxonerve_wordcount_jni.so: ./axonerve_wordcount.o ./xcl2.o ./axonerve_wordcount_jni.o 
	$(SDX_CXX) $(CXXFLAGS) -shared -fPIC -DSDX_PLATFORM=$(SDX_PLATFORM) -D__USE_XOPEN2K8 -I/opt/Xilinx/SDx/2018.3.op2405991/runtime/include/1_2/ -I/opt/Xilinx/Vivado/2018.3.op2405991/include/ -I/usr/lib/jvm/java-8-openjdk-amd64/include/ -I/usr/lib/jvm/java-8-openjdk-amd64/include/linux/ -O2 -Wall -fmessage-length=0 -o "$@" -Wl,-soname,libaxonerve_wordcount_jni.so axonerve_wordcount_jni.o xcl2.o axonerve_wordcount.o -lxilinxopencl -lpthread -lrt -lstdc++ -L/opt/Xilinx/SDx/2018.3.op2405991/runtime/lib/x86_64 -L/opt/xilinx/xrt/lib/

libaxonerve_wordcount.so: ./axonerve_wordcount.o ./xcl2.o
	$(SDX_CXX) $(CXXFLAGS) -shared -fPIC -DSDX_PLATFORM=$(SDX_PLATFORM) -D__USE_XOPEN2K8 -I/opt/Xilinx/SDx/2018.3.op2405991/runtime/include/1_2/ -I/opt/Xilinx/Vivado/2018.3.op2405991/include/ -O2 -Wall -fmessage-length=0 -o "$@" -Wl,-soname,libaxonerve_wordcount.so axonerve_wordcount.o xcl2.o

#AxonerveWordcount.h: ./AxonerveWordcount.java 
#	javac AxonerveWordcount.java -h .


axonerve_wordcount_jni.o: ./axonerve_wordcount_jni.cpp ./AxonerveWordcount.h ./axonerve_wordcount.hpp
	@mkdir -p $(@D)
	$(SDX_CXX) $(CXXFLAGS) -fPIC -DSDX_PLATFORM=$(SDX_PLATFORM) -D__USE_XOPEN2K8 -I/opt/Xilinx/SDx/2018.3.op2405991/runtime/include/1_2/ -I/opt/Xilinx/Vivado/2018.3.op2405991/include/ -I/usr/lib/jvm/java-8-openjdk-amd64/include/ -I/usr/lib/jvm/java-8-openjdk-amd64/include/linux/ -I/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.222.b10-1.el7_7.x86_64/include/ -I/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.222.b10-1.el7_7.x86_64/include/linux/ -O2 -Wall -c -fmessage-length=0 -o "$@" "$<"

axonerve_wordcount.o: ./axonerve_wordcount.cpp ./axonerve_wordcount.hpp
	@mkdir -p $(@D)
	$(SDX_CXX) $(CXXFLAGS) -fPIC -DSDX_PLATFORM=$(SDX_PLATFORM) -D__USE_XOPEN2K8 -I/opt/Xilinx/SDx/2018.3.op2405991/runtime/include/1_2/ -I/opt/Xilinx/Vivado/2018.3.op2405991/include/ -O2 -Wall -c -fmessage-length=0 -o "$@" "$<"

host.o: ./host.cpp ./axonerve_wordcount.hpp
	@mkdir -p $(@D)
	$(SDX_CXX) $(CXXFLAGS) -fPIC -DSDX_PLATFORM=$(SDX_PLATFORM) -D__USE_XOPEN2K8 -I/opt/Xilinx/SDx/2018.3.op2405991/runtime/include/1_2/ -I/opt/Xilinx/Vivado/2018.3.op2405991/include/ -O2 -Wall -c -fmessage-length=0 -o "$@" "$<"

xcl2.o: ./xcl2.cpp ./xcl2.hpp
	@mkdir -p $(@D)
	$(SDX_CXX) $(CXXFLAGS) -fPIC -DSDX_PLATFORM=$(SDX_PLATFORM) -D__USE_XOPEN2K8 -I/opt/Xilinx/SDx/2018.3.op2405991/runtime/include/1_2/ -I/opt/Xilinx/Vivado/2018.3.op2405991/include/ -O2 -Wall -c -fmessage-length=0 -o "$@" "$<"

$(HOST_EXE): $(HOST_OBJECTS)
	$(SDX_CXX) -o "$@" $(+) $(LDFLAGS) -lxilinxopencl -lpthread -lrt -lstdc++ -L/opt/Xilinx/SDx/2018.3.op2405991/runtime/lib/x86_64 -Wl,-rpath,$(XILINX_VIVADO)/lnx64/lib/csim -L $(XILINX_VIVADO)/lnx64/lib/csim -lhlsmc++-GCC46 -Wl,-rpath,$(XILINX_VIVADO)/lnx64/tools/fpo_v7_0 -L $(XILINX_VIVADO)/lnx64/tools/fpo_v7_0 -lgmp -lmpfr -lIp_floating_point_v7_0_bitacc_cmodel -Wl,-rpath,$(XILINX_VIVADO)/lnx64/tools/fft_v9_1 -L $(XILINX_VIVADO)/lnx64/tools/fft_v9_1 -lIp_xfft_v9_1_bitacc_cmodel -Wl,-rpath,$(XILINX_VIVADO)/lnx64/tools/fir_v7_0 -L $(XILINX_VIVADO)/lnx64/tools/fir_v7_0 -lgmp -lIp_fir_compiler_v7_2_bitacc_cmodel -Wl,-rpath,$(XILINX_VIVADO)/lnx64/tools/dds_v6_0 -L $(XILINX_VIVADO)/lnx64/tools/dds_v6_0 -lIp_dds_compiler_v6_0_bitacc_cmodel -L/opt/xilinx/xrt/lib/

