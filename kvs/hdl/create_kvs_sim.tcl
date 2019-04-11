set project_dir    "./axonerve_kvs_sim"
set project_name   "axonerve_kvs_sim"
set project_target "xcvu9p-fsgd2104-2L-e"
set source_files { \
		       ./../../axonerve/AXONERVE_all.vp \
		       ./sources/axonerve_kvs_kernel.sv \
		   }

set ipcores { \
		  fifo_16_128k_ft \
		  fifo_300_16_ft \
	      }

create_project -force $project_name $project_dir -part $project_target
add_files -norecurse $source_files
update_compile_order -fileset sources_1

foreach ip ${ipcores} {
    import_ip -files ./ip/${ip}.xci
    update_compile_order -fileset sources_1
    generate_target all [get_files  $project_dir/$project_name.srcs/sources_1/ip/${ip}/${ip}.xci]
    catch { config_ip_cache -export [get_ips -all ${ip}] }
    export_ip_user_files \
	-of_objects [get_files $project_dir/$project_name.srcs/sources_1/ip/${ip}/${ip}.xci] \
	-no_script -sync -force -quiet
    create_ip_run \
	[get_files -of_objects [get_fileset sources_1] $project_dir/$project_name.srcs/sources_1/ip/${ip}/${ip}.xci]
    launch_runs -jobs 4 ${ip}_synth_1
    wait_on_run ${ip}_synth_1
    export_simulation \
	-of_objects [get_files $project_dir/$project_name.srcs/sources_1/ip/${ip}/${ip}.xci] \
	-directory $project_dir/$project_name.ip_user_files/sim_scripts \
	-ip_user_files_dir $project_dir/$project_name.ip_user_files \
	-ipstatic_source_dir $project_dir/$project_name.ip_user_files/ipstatic \
	-lib_map_path [list {modelsim=$project_dir/$project_name.cache/compile_simlib/modelsim} \
			    {questa=$project_dir/$project_name.cache/compile_simlib/questa} \
			    {ies=$project_dir/$project_name.cache/compile_simlib/ies} \
			    {xcelium=$project_dir/$project_name.cache/compile_simlib/xcelium} \
			    {vcs=$project_dir/$project_name.cache/compile_simlib/vcs} \
			    {riviera=$project_dir/$project_name.cache/compile_simlib/riviera}] \
	-use_ip_compiled_libs -force -quiet
}

set_property SOURCE_SET sources_1 [get_filesets sim_1]
add_files -fileset sim_1 -norecurse ./sources/axonerve_kvs_kernel_sim.sv
update_compile_order -fileset sim_1

set_property top axonerve_kvs_kernel_sim [get_filesets sim_1]
set_property top_lib xil_defaultlib [get_filesets sim_1]
set_property top_file ./sources/axonerve_kvs_kernel_sim.sv [get_filesets sim_1]
update_compile_order -fileset sim_1

launch_simulation
run 2ms

