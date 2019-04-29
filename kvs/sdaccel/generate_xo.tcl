set suffix rtl_ip    

# Import the RTL to the “packaged_kernel_{$suffix}” IP directory   
source ./scripts/package_kernel.tcl   

# Create the XO file
package_xo -xo_path ./src/axonerve_kvs_rtl.xo \
           -kernel_name axonerve_kvs_rtl \
           -ip_directory ./packaged_kernel_rtl_ip \
           -kernel_xml ./src/kernel.xml
# Exit Vivado
exit
