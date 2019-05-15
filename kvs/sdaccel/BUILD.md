## Prepare a S3 Bucket

- Create a S3 Bucket. For example, it's named aws-f1-axonerve-kvs.
- create a folder. For example, it's named axonerve-kvs-20190503.

## Prepare AMI instance to synthesis and implementation

- Select FPGA in AMI
- using c4.4xlarge is recommended ($0.796/hour).
- It is recommended that you use 100GB of storage.

## (Only first time) configuration after starting the instance

- do `aws configure` and set key and password.
- At `/home/centos`, do `git clone https://github.com/aws/aws-fpga.git $AWS_FPGA_REPO_DIR`
- At `/home/centos`, do `git clone https://github.com/miyo/axonerve_util.git`
- upload netlist of AXONERVE
```
scp -i pem-file AXONERVE-netlist centos@IP-of-AWS-instance:
```

## Change current directory and set environment

```
cd $AWS_FPGA_REPO_DIR
source sdaccel_setup.sh
```

## create SDx project
- start SDx
```
cd ~/
sdx -workspace build
```
- click "Create a Xilinx(R) SDx(TM) Application project"
  - For example, the project named axonerve_kvs is created.
- select aws-vu9p-f1... as Platform.
  - When the candidate is not found, click "Add Custom Platform..." and add `/home/centos/src/project_data/aws-fpga/SDAccel/aws_platform` as a repository
- select "Empty Application"

## Prepare RTL kernel

### create a project skelton with "Kernel Wizard"

- Select "Xilinx" -> "RTL Kernel Wizard" in menu.
- General Settings
  - set `axonerve_kvs_rtl` at `kernel name`, set `wasalabo` `kernel vendor`, and click "Next".
  - set 2 as "clocks", and 1 as "Has Reset".
- Scalars
  - Leave the number of scalars 1, set `data_num` at `Argument name` of the scalar, and click "Next".
- Global Memory
  - Just click "Next"

### Replace and add Files

- Files to remove
  - `axonerve_kvs_rtl_example.sv`，`axonerve_kvs_rtl_example_vadd.sv`，`axonerve_kvs_rtl_ooc.xdc` と `axonerve_kvs_rtl_user.xdc`
- Files to add
  - `axonerve_kvs_rtl_example.sv`, `axonerve_kvs_rtl_example_vadd.sv`, and `user_logic.sv` at `/home/centos/axonerve_util/kvs/sdaccel/src/hdl`
  - `axonerve_kvs_kernel.sv` at `/home/centos/axonerve_util/kvs/hdl/sources`
  - xci files at `/home/centos/axonerve_util/kvs/sdaccel/src/xilinx-ip/aws-f1-vu9p`. copy them into this project.
  - uploaded netlist file of Axonerve
  - `axonerve_kvs_rtl_ooc.xdc` and `axonerve_kvs_rtl_user.xdc` at `/home/centos/axonerve_util/kvs/sdaccel/src/xdc/vu9p`
- Detailed operation
  - It is recommended that you set Libraries tab in Soureces pane.
  - Open "Design Sources" -> "SystemVerilog" -> "xil_defaultlib" and remove `axonerve_kvs_rtl_example.sv` and `axonerve_kvs_rtl_example_vadd.sv`.
  - Do right-click on "Design Sources" and select "Add Sources" from the context menu. Then, select "Add or create design sources" and click "Next"
    - Add `axonerve_kvs_rtl_example.sv`, `axonerve_kvs_rtl_example_vadd.sv`, and `user_logic.sv` at `/home/centos/axonerve_util/kvs/sdaccel/src/hdl`
    - Add `axonerve_kvs_kernel.sv` at `/home/centos/axonerve_util/kvs/hdl/sources`
    - Copy xci files at `/home/centos/axonerve_util/kvs/sdaccel/src/xilinx-ip/aws-f1-vu9p` (Do not forget check at "Copy sources into project" checkbox)
    - Add the uploaded netlist of Axonerve
  - Open "Constraints" -> "constrs_1", and remove `axonerve_kvs_rtl_ooc.xdc` and `axonerve_kvs_rtl_user.xdc`.
  - Select "Add or create constraints" and click "Next"
  - Add `axonerve_kvs_rtl_ooc.xdc` and `axonerve_kvs_rtl_user.xdc` at `/home/centos/axonerve_util/kvs/sdaccel/src/xdc/vu9p`.

### Execute "Generate RTL Kernel"

- select "source-only kernel"

## Build system by SDx

### Remove and add files

- remove `host_example.cpp` and add `axonerve_kvs.cpp`, `axonerve_kvs.hpp`, `host.cpp`, `xcl2.cpp`, and `xcl2.hpp`.
  - At "Project Explorer", Open src -> sdx_rtl_kernel -> axonerve_kvs_rtl and remove `host_example.cpp` (before 2018.2, the file was main.c).
  - Do right-click at axonerve_kvs in "Project Explorer". Select "Import Sources..." in the context menu.
  - Select `/home/centos/axonerve_util/kvs/sdaccel/src` in "Browse..."
  - Select `axonerve_kvs.cpp`, `axonerve_kvs.hpp`, `host.cpp`, `xcl2.cpp`, and `xcl2.hpp`.
  - Click "Finish"

### Settings of build options

- set System as target
  - In right-pane, select System in "Active build configuration"
- add `--kernel_frequncy "0:150|1:300"` into compile options.
  - Do right-click at axonerve_kvs in "Project Explorer"
  - Select "C/C++ Build Settings" in the context menu.
  - Click "Settings" at left side pane.
  - Set "System" in "Configuration tab" (it has been settled).
  - Open "Tool Settings" tab
  - Select "SDx XOCC Kernel Compiler" -> Miscellaneos, and add `--kernel_frequency "0:150|1:300"`
  - Select "SDx XOCC Kernel Linker" -> Miscellaneos, and add `--kernel_frequency "0:150|1:300"`
  - Close with "Apply and Close"
- Set axonerve_kvs_rtl as "Hardware Functions"
  - Click "Add Hardware Function..." (the icon like thunder) to the right of "Hardware Functions" in the right pane.
  - Select axonerve_kvs_rtl, and click OK.

### Build

- Select "Project" -> "Build Project" in menu.
  - Instead of that, click the icon like hammer in SDx toolbar.

## Create AFI image

- Change current directory as `cd /home/centos/build/axonerve_kvs/System`, and check the existence of `binary_container_1.xclbin`.
- Since the directory named `binary_container_1` disturbs this step, rename the directory by `mv binary_container_1 binary_container_1.o`.
- Create AFI image by the following command. It generates `binary_container_1.awsxclbin`.
```
$SDACCEL_DIR/tools/create_sdaccel_afi.sh \
  -xclbin=<xclbin file name>.xclbin \
  -s3_bucket=<bucket-name> \
  -s3_dcp_key=<dcp-folder-name> \
  -s3_logs_key=<logs-folder-name>
```
- In this example,
```
$SDACCEL_DIR/tools/create_sdaccel_afi.sh \
  -xclbin=binary_container_1.xclbin \
  -s3_bucket=aws-f1-axonerve-kvs \
  -s3_dcp_key=axonerve-kvs-20190503 \
  -s3_logs_key=axonerve-kvs-20190503
```
- Open `*_afi_id.txt` and check "FpgaImageId". For example, do `cat *_afi_id.txt`.
- Wait for creating AFI image with the following command. After finished the operation, "State" becomes "available".
```
aws ec2 describe-fpga-images --fpga-image-ids 確認したFpgaImageId
```
- Download `axonerve_kvs.exe` and `binary_container_1.awsxclbin` by using `scp`.
```
scp -i pem-file centos@IP-of-AWS-instance:axonerve_kvs.exe .
scp -i pem-file centos@IP-of-AWS-instance:binary_container_1.awsxclbin .
```

## Run program on AWS-F1.

- Create AWS-F1 instance.
  - Search FPGA in AMI. Create the instance with "f1.2xlarge".
- (Only first time) do configuration of the instance.
  - Do `aws configure`.
  - At `/home/centos`, do `git clone https://github.com/aws/aws-fpga.git $AWS_FPGA_REPO_DIR`
- Set environments with the setup script.
```
cd $AWS_FPGA_REPO_DIR; source sdaccel_setup.sh
```
- Upload `axonerve_kvs.exe` and `binary_container_1.awsxclbin`.
```
scp -i pem-file axonerve_kvs.exe centos@IP-of-AWS-instance:
scp -i pem-file binary_container_1.awsxclbin centos@IP-of-AWS-instance:
```
- Run
```
sudo -s
source $AWS_FPGA_REPO_DIR/sdaccel_runtime_setup.sh
./axonerve_kvs.exe binary_container_1.awsxclbin
```

