# This is a generated file. Use and modify at your own risk.
################################################################################

set kernel_name    "axonerve_kvs_rtl"
set kernel_vendor  "wasalabo"
set kernel_library "kernel"

##############################################################################

proc edit_core {core} {
  set bif      [::ipx::get_bus_interfaces -of $core  "m00_axi"] 
  set bifparam [::ipx::add_bus_parameter -quiet "MAX_BURST_LENGTH" $bif]
  set_property value        64           $bifparam
  set_property value_source constant     $bifparam
  set bifparam [::ipx::add_bus_parameter -quiet "NUM_READ_OUTSTANDING" $bif]
  set_property value        32           $bifparam
  set_property value_source constant     $bifparam
  set bifparam [::ipx::add_bus_parameter -quiet "NUM_WRITE_OUTSTANDING" $bif]
  set_property value        32           $bifparam
  set_property value_source constant     $bifparam

  set bif      [::ipx::get_bus_interfaces -of $core  "m01_axi"] 
  set bifparam [::ipx::add_bus_parameter -quiet "MAX_BURST_LENGTH" $bif]
  set_property value        64           $bifparam
  set_property value_source constant     $bifparam
  set bifparam [::ipx::add_bus_parameter -quiet "NUM_READ_OUTSTANDING" $bif]
  set_property value        32           $bifparam
  set_property value_source constant     $bifparam
  set bifparam [::ipx::add_bus_parameter -quiet "NUM_WRITE_OUTSTANDING" $bif]
  set_property value        32           $bifparam
  set_property value_source constant     $bifparam

  set bif      [::ipx::get_bus_interfaces -of $core  "m02_axi"] 
  set bifparam [::ipx::add_bus_parameter -quiet "MAX_BURST_LENGTH" $bif]
  set_property value        64           $bifparam
  set_property value_source constant     $bifparam
  set bifparam [::ipx::add_bus_parameter -quiet "NUM_READ_OUTSTANDING" $bif]
  set_property value        32           $bifparam
  set_property value_source constant     $bifparam
  set bifparam [::ipx::add_bus_parameter -quiet "NUM_WRITE_OUTSTANDING" $bif]
  set_property value        32           $bifparam
  set_property value_source constant     $bifparam

  set bif      [::ipx::get_bus_interfaces -of $core  "m03_axi"] 
  set bifparam [::ipx::add_bus_parameter -quiet "MAX_BURST_LENGTH" $bif]
  set_property value        64           $bifparam
  set_property value_source constant     $bifparam
  set bifparam [::ipx::add_bus_parameter -quiet "NUM_READ_OUTSTANDING" $bif]
  set_property value        32           $bifparam
  set_property value_source constant     $bifparam
  set bifparam [::ipx::add_bus_parameter -quiet "NUM_WRITE_OUTSTANDING" $bif]
  set_property value        32           $bifparam
  set_property value_source constant     $bifparam

  set bif      [::ipx::get_bus_interfaces -of $core  "m04_axi"] 
  set bifparam [::ipx::add_bus_parameter -quiet "MAX_BURST_LENGTH" $bif]
  set_property value        64           $bifparam
  set_property value_source constant     $bifparam
  set bifparam [::ipx::add_bus_parameter -quiet "NUM_READ_OUTSTANDING" $bif]
  set_property value        32           $bifparam
  set_property value_source constant     $bifparam
  set bifparam [::ipx::add_bus_parameter -quiet "NUM_WRITE_OUTSTANDING" $bif]
  set_property value        32           $bifparam
  set_property value_source constant     $bifparam

  set bif      [::ipx::get_bus_interfaces -of $core  "m05_axi"] 
  set bifparam [::ipx::add_bus_parameter -quiet "MAX_BURST_LENGTH" $bif]
  set_property value        64           $bifparam
  set_property value_source constant     $bifparam
  set bifparam [::ipx::add_bus_parameter -quiet "NUM_READ_OUTSTANDING" $bif]
  set_property value        32           $bifparam
  set_property value_source constant     $bifparam
  set bifparam [::ipx::add_bus_parameter -quiet "NUM_WRITE_OUTSTANDING" $bif]
  set_property value        32           $bifparam
  set_property value_source constant     $bifparam

  ::ipx::associate_bus_interfaces -busif "m00_axi" -clock "ap_clk" $core
  ::ipx::associate_bus_interfaces -busif "m01_axi" -clock "ap_clk" $core
  ::ipx::associate_bus_interfaces -busif "m02_axi" -clock "ap_clk" $core
  ::ipx::associate_bus_interfaces -busif "m03_axi" -clock "ap_clk" $core
  ::ipx::associate_bus_interfaces -busif "m04_axi" -clock "ap_clk" $core
  ::ipx::associate_bus_interfaces -busif "m05_axi" -clock "ap_clk" $core
  ::ipx::associate_bus_interfaces -busif "s_axi_control" -clock "ap_clk" $core

  ::ipx::infer_bus_interface "ap_clk_2"   "xilinx.com:signal:clock_rtl:1.0" $core

  set mem_map    [::ipx::add_memory_map -quiet "s_axi_control" $core]
  set addr_block [::ipx::add_address_block -quiet "reg0" $mem_map]

  set reg      [::ipx::add_register "Control" $addr_block]
  set_property address_offset 0x000 $reg
  set_property size           1     $reg

  set reg      [::ipx::add_register -quiet "data_num" $addr_block]
  set_property address_offset 0x010 $reg
  set_property size           4   $reg

  set reg      [::ipx::add_register -quiet "axi00_ptr0" $addr_block]
  set_property address_offset 0x018 $reg
  set_property size           8   $reg

  set reg      [::ipx::add_register -quiet "axi01_ptr0" $addr_block]
  set_property address_offset 0x020 $reg
  set_property size           8   $reg

  set reg      [::ipx::add_register -quiet "axi02_ptr0" $addr_block]
  set_property address_offset 0x028 $reg
  set_property size           8   $reg

  set reg      [::ipx::add_register -quiet "axi03_ptr0" $addr_block]
  set_property address_offset 0x030 $reg
  set_property size           8   $reg

  set reg      [::ipx::add_register -quiet "axi04_ptr0" $addr_block]
  set_property address_offset 0x038 $reg
  set_property size           8   $reg

  set reg      [::ipx::add_register -quiet "axi05_ptr0" $addr_block]
  set_property address_offset 0x040 $reg
  set_property size           8   $reg

  set_property slave_memory_map_ref "s_axi_control" [::ipx::get_bus_interfaces -of $core "s_axi_control"]

  set_property xpm_libraries {XPM_CDC XPM_MEMORY XPM_FIFO} $core
  set_property sdx_kernel true $core
  set_property sdx_kernel_type rtl $core
}

##############################################################################

proc package_project {path_to_packaged kernel_vendor kernel_library kernel_name} {
  set core [::ipx::package_project -root_dir $path_to_packaged -vendor $kernel_vendor -library $kernel_library -taxonomy "/KernelIP" -import_files -set_current false]
  foreach user_parameter [list C_S_AXI_CONTROL_ADDR_WIDTH C_S_AXI_CONTROL_DATA_WIDTH C_M00_AXI_ADDR_WIDTH C_M00_AXI_DATA_WIDTH C_M01_AXI_ADDR_WIDTH C_M01_AXI_DATA_WIDTH C_M02_AXI_ADDR_WIDTH C_M02_AXI_DATA_WIDTH C_M03_AXI_ADDR_WIDTH C_M03_AXI_DATA_WIDTH C_M04_AXI_ADDR_WIDTH C_M04_AXI_DATA_WIDTH C_M05_AXI_ADDR_WIDTH C_M05_AXI_DATA_WIDTH] {
    ::ipx::remove_user_parameter $user_parameter $core
  }
  ::ipx::create_xgui_files $core
  set_property supported_families { } $core
  set_property auto_family_support_level level_2 $core
  set_property used_in {out_of_context implementation synthesis} [::ipx::get_files -type xdc -of_objects [::ipx::get_file_groups "xilinx_anylanguagesynthesis" -of_objects $core] *_ooc.xdc]
  edit_core $core
  ::ipx::update_checksums $core
  ::ipx::save_core $core
  ::ipx::unload_core $core
  unset core
}

##############################################################################

proc package_project_dcp {path_to_dcp path_to_packaged kernel_vendor kernel_library kernel_name} {
  set core [::ipx::package_checkpoint -dcp_file $path_to_dcp -root_dir $path_to_packaged -vendor $kernel_vendor -library $kernel_library -name $kernel_name -taxonomy "/KernelIP" -force]
  edit_core $core
  ::ipx::update_checksums $core
  ::ipx::save_core $core
  ::ipx::unload_core $core
  unset core
}

##############################################################################

proc package_project_dcp_and_xdc {path_to_dcp path_to_xdc path_to_packaged kernel_vendor kernel_library kernel_name} {
  set core [::ipx::package_checkpoint -dcp_file $path_to_dcp -root_dir $path_to_packaged -vendor $kernel_vendor -library $kernel_library -name $kernel_name -taxonomy "/KernelIP" -force]
  edit_core $core
  set rel_path_to_xdc [file join "impl" [file tail $path_to_xdc]]
  set abs_path_to_xdc [file join $path_to_packaged $rel_path_to_xdc]
  file mkdir [file dirname $abs_path_to_xdc]
  file copy $path_to_xdc $abs_path_to_xdc
  set xdcfile [::ipx::add_file $rel_path_to_xdc [::ipx::add_file_group "xilinx_implementation" $core]]
  set_property type "xdc" $xdcfile
  set_property used_in [list "implementation"] $xdcfile
  ::ipx::update_checksums $core
  ::ipx::save_core $core
  ::ipx::unload_core $core
  unset core
}

##############################################################################