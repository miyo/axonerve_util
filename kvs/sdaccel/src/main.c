#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <unistd.h>
#include <assert.h>
#include <stdbool.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/time.h>
#include <CL/opencl.h>
#include <CL/cl_ext.h>

////////////////////////////////////////////////////////////////////////////////

#if defined(SDX_PLATFORM) && !defined(TARGET_DEVICE)
#define STR_VALUE(arg)      #arg
#define GET_STRING(name) STR_VALUE(name)
#define TARGET_DEVICE GET_STRING(SDX_PLATFORM)
#endif

////////////////////////////////////////////////////////////////////////////////

int load_file_to_memory(const char *filename, char **result)
{
    uint size = 0;
    FILE *f = fopen(filename, "rb");
    if (f == NULL) {
        *result = NULL;
        return -1; // -1 means file opening fail
    }
    fseek(f, 0, SEEK_END);
    size = ftell(f);
    fseek(f, 0, SEEK_SET);
    *result = (char *)malloc(size+1);
    if (size != fread(*result, sizeof(char), size, f)) {
        free(*result);
        return -2; // -2 means file reading fail
    }
    fclose(f);
    (*result)[size] = 0;
    return size;
}

struct axonerve_query{
    unsigned int key[4];
    unsigned int value;
    unsigned int csr; // H-D 0: INIT, 1: ERASE, 2: WRITE, 3: READE, 4: SEARCH, 5: UPDATE
                      // D-H 0: SINGLE_HIT, 1: MULTI_HIT, 2: ENT_ERR, 3: ENT_FULL
    unsigned int priority;
    unsigned int mask[4];
    unsigned int dummy[4];
    unsigned int version;
};

#define ALIGNMENT_VAL (4*1024)

int main(int argc, char** argv)
{

    int err;                            // error code returned from api calls
    int check_status = 0;
    const uint number_of_words = 7;


    cl_platform_id platform_id;         // platform id
    cl_device_id device_id;             // compute device id
    cl_context context;                 // compute context
    cl_command_queue commands;          // compute command queue
    cl_program program;                 // compute programs
    cl_kernel kernel;                   // compute kernel

    char cl_platform_vendor[1001];
    char target_device_name[1001] = TARGET_DEVICE;

    struct axonerve_query *queries;
    struct axonerve_query *results;

    if (posix_memalign((void**)&queries, ALIGNMENT_VAL, sizeof(struct axonerve_query)*number_of_words) != 0){
        return EXIT_FAILURE;
    }
    if (posix_memalign((void**)&results, ALIGNMENT_VAL, sizeof(struct axonerve_query)*number_of_words) != 0){
        return EXIT_FAILURE; // error.
    }

    
    cl_mem d_axi00_ptr0;                         // device memory used for a vector

    if (argc != 2) {
        printf("Usage: %s xclbin\n", argv[0]);
        return EXIT_FAILURE;
    }

    // Fill our data sets with pattern
    int query_id = 0;

    queries[query_id].key[0] = 0xdeadbeef;
    queries[query_id].key[1] = 0xdeadbeef;
    queries[query_id].key[2] = 0xdeadbeef;
    queries[query_id].key[3] = 0xdeadbeef;
    queries[query_id].value = 0x34343434;
    queries[query_id].csr = 0x10; // SEARCH
    queries[query_id].priority = 0;
    queries[query_id].mask[0] = 0;
    queries[query_id].mask[1] = 0;
    queries[query_id].mask[2] = 0;
    queries[query_id].mask[3] = 0;
    queries[query_id].dummy[0] = 0;
    queries[query_id].dummy[1] = 0;
    queries[query_id].dummy[2] = 0;
    queries[query_id].dummy[3] = 0;
    query_id++;
    
    queries[query_id].key[0] = 0xdeadbeef;
    queries[query_id].key[1] = 0xdeadbeef;
    queries[query_id].key[2] = 0xdeadbeef;
    queries[query_id].key[3] = 0xdeadbeef;
    queries[query_id].value = 0x34343434;
    queries[query_id].csr = 0x20; // SEARCH
    queries[query_id].priority = 0;
    queries[query_id].mask[0] = 0;
    queries[query_id].mask[1] = 0;
    queries[query_id].mask[2] = 0;
    queries[query_id].mask[3] = 0;
    queries[query_id].dummy[0] = 0;
    queries[query_id].dummy[1] = 0;
    queries[query_id].dummy[2] = 0;
    queries[query_id].dummy[3] = 0;
    query_id++;
    
    queries[query_id].key[0] = 0xdeadbeef;
    queries[query_id].key[1] = 0xdeadbeef;
    queries[query_id].key[2] = 0xdeadbeef;
    queries[query_id].key[3] = 0xdeadbeef;
    queries[query_id].value = 0x34343434;
    queries[query_id].csr = 0x10; // SEARCH
    queries[query_id].priority = 0;
    queries[query_id].mask[0] = 0;
    queries[query_id].mask[1] = 0;
    queries[query_id].mask[2] = 0;
    queries[query_id].mask[3] = 0;
    queries[query_id].dummy[0] = 0;
    queries[query_id].dummy[1] = 0;
    queries[query_id].dummy[2] = 0;
    queries[query_id].dummy[3] = 0;
    query_id++;
    
    queries[query_id].key[0] = 0xdeadbeef;
    queries[query_id].key[1] = 0xdeadbeef;
    queries[query_id].key[2] = 0xdeadbeef;
    queries[query_id].key[3] = 0xdeadbeef;
    queries[query_id].value = 0xabababab;
    queries[query_id].csr = 0x20; // SEARCH
    queries[query_id].priority = 0;
    queries[query_id].mask[0] = 0;
    queries[query_id].mask[1] = 0;
    queries[query_id].mask[2] = 0;
    queries[query_id].mask[3] = 0;
    queries[query_id].dummy[0] = 0;
    queries[query_id].dummy[1] = 0;
    queries[query_id].dummy[2] = 0;
    queries[query_id].dummy[3] = 0;
    query_id++;
    
    queries[query_id].key[0] = 0xdeadbeef;
    queries[query_id].key[1] = 0xdeadbeef;
    queries[query_id].key[2] = 0xdeadbeef;
    queries[query_id].key[3] = 0xdeadbeef;
    queries[query_id].value = 0x34343434;
    queries[query_id].csr = 0x10; // SEARCH
    queries[query_id].priority = 0;
    queries[query_id].mask[0] = 0;
    queries[query_id].mask[1] = 0;
    queries[query_id].mask[2] = 0;
    queries[query_id].mask[3] = 0;
    queries[query_id].dummy[0] = 0;
    queries[query_id].dummy[1] = 0;
    queries[query_id].dummy[2] = 0;
    queries[query_id].dummy[3] = 0;
    query_id++;

    queries[query_id].key[0] = 0xdeadbeef;
    queries[query_id].key[1] = 0xdeadbeef;
    queries[query_id].key[2] = 0xdeadbeef;
    queries[query_id].key[3] = 0xdeadbeef;
    queries[query_id].value = 0xabababab;
    queries[query_id].csr = 0x02; // ERASE
    queries[query_id].priority = 0;
    queries[query_id].mask[0] = 0;
    queries[query_id].mask[1] = 0;
    queries[query_id].mask[2] = 0;
    queries[query_id].mask[3] = 0;
    queries[query_id].dummy[0] = 0;
    queries[query_id].dummy[1] = 0;
    queries[query_id].dummy[2] = 0;
    queries[query_id].dummy[3] = 0;
    query_id++;
    
    queries[query_id].key[0] = 0xdeadbeef;
    queries[query_id].key[1] = 0xdeadbeef;
    queries[query_id].key[2] = 0xdeadbeef;
    queries[query_id].key[3] = 0xdeadbeef;
    queries[query_id].value = 0x34343434;
    queries[query_id].csr = 0x10; // SEARCH
    queries[query_id].priority = 0;
    queries[query_id].mask[0] = 0;
    queries[query_id].mask[1] = 0;
    queries[query_id].mask[2] = 0;
    queries[query_id].mask[3] = 0;
    queries[query_id].dummy[0] = 0;
    queries[query_id].dummy[1] = 0;
    queries[query_id].dummy[2] = 0;
    queries[query_id].dummy[3] = 0;
    query_id++;

    // Get all platforms and then select Xilinx platform
    cl_platform_id platforms[16];       // platform id
    cl_uint platform_count;
    int platform_found = 0;
    err = clGetPlatformIDs(16, platforms, &platform_count);
    if (err != CL_SUCCESS) {
        printf("Error: Failed to find an OpenCL platform!\n");
        printf("Test failed\n");
        return EXIT_FAILURE;
    }
    printf("INFO: Found %d platforms\n", platform_count);

    // Find Xilinx Plaftorm
    for (unsigned int iplat=0; iplat<platform_count; iplat++) {
        err = clGetPlatformInfo(platforms[iplat], CL_PLATFORM_VENDOR, 1000, (void *)cl_platform_vendor,NULL);
        if (err != CL_SUCCESS) {
            printf("Error: clGetPlatformInfo(CL_PLATFORM_VENDOR) failed!\n");
            printf("Test failed\n");
            return EXIT_FAILURE;
        }
        if (strcmp(cl_platform_vendor, "Xilinx") == 0) {
            printf("INFO: Selected platform %d from %s\n", iplat, cl_platform_vendor);
            platform_id = platforms[iplat];
            platform_found = 1;
        }
    }
    if (!platform_found) {
        printf("ERROR: Platform Xilinx not found. Exit.\n");
        return EXIT_FAILURE;
    }

    // Get Accelerator compute device
    cl_uint num_devices;
    unsigned int device_found = 0;
    cl_device_id devices[16];  // compute device id
    char cl_device_name[1001];
    err = clGetDeviceIDs(platform_id, CL_DEVICE_TYPE_ACCELERATOR, 16, devices, &num_devices);
    printf("INFO: Found %d devices\n", num_devices);
    if (err != CL_SUCCESS) {
        printf("ERROR: Failed to create a device group!\n");
        printf("ERROR: Test failed\n");
        return -1;
    }

    //iterate all devices to select the target device.
    for (uint i=0; i<num_devices; i++) {
        err = clGetDeviceInfo(devices[i], CL_DEVICE_NAME, 1024, cl_device_name, 0);
        if (err != CL_SUCCESS) {
            printf("Error: Failed to get device name for device %d!\n", i);
            printf("Test failed\n");
            return EXIT_FAILURE;
        }
        printf("CL_DEVICE_NAME %s\n", cl_device_name);
        if(strcmp(cl_device_name, target_device_name) == 0) {
            device_id = devices[i];
            device_found = 1;
            printf("Selected %s as the target device\n", cl_device_name);
	}
    }

    if (!device_found) {
        printf("Target device %s not found. Exit.\n", target_device_name);
        return EXIT_FAILURE;
    }

    // Create a compute context
    //
    context = clCreateContext(0, 1, &device_id, NULL, NULL, &err);
    if (!context) {
        printf("Error: Failed to create a compute context!\n");
        printf("Test failed\n");
        return EXIT_FAILURE;
    }

    // Create a command commands
    commands = clCreateCommandQueue(context, device_id, 0, &err);
    if (!commands) {
        printf("Error: Failed to create a command commands!\n");
        printf("Error: code %i\n",err);
        printf("Test failed\n");
        return EXIT_FAILURE;
    }

    int status;

    // Create Program Objects
    // Load binary from disk
    unsigned char *kernelbinary;
    char *xclbin = argv[1];

    //------------------------------------------------------------------------------
    // xclbin
    //------------------------------------------------------------------------------
    printf("INFO: loading xclbin %s\n", xclbin);
    int n_i0 = load_file_to_memory(xclbin, (char **) &kernelbinary);
    if (n_i0 < 0) {
        printf("failed to load kernel from xclbin: %s\n", xclbin);
        printf("Test failed\n");
        return EXIT_FAILURE;
    }

    size_t n0 = n_i0;

    // Create the compute program from offline
    program = clCreateProgramWithBinary(context, 1, &device_id, &n0,
                                        (const unsigned char **) &kernelbinary, &status, &err);

    if ((!program) || (err!=CL_SUCCESS)) {
        printf("Error: Failed to create compute program from binary %d!\n", err);
        printf("Test failed\n");
        return EXIT_FAILURE;
    }

    // Build the program executable
    //
    err = clBuildProgram(program, 0, NULL, NULL, NULL, NULL);
    if (err != CL_SUCCESS) {
        size_t len;
        char buffer[2048];

        printf("Error: Failed to build program executable!\n");
        clGetProgramBuildInfo(program, device_id, CL_PROGRAM_BUILD_LOG, sizeof(buffer), buffer, &len);
        printf("%s\n", buffer);
        printf("Test failed\n");
        return EXIT_FAILURE;
    }

    // Create the compute kernel in the program we wish to run
    //
    kernel = clCreateKernel(program, "axonerve_kvs_rtl", &err);
    if (!kernel || err != CL_SUCCESS) {
        printf("Error: Failed to create compute kernel!\n");
        printf("Test failed\n");
        return EXIT_FAILURE;
    }

    printf("kernel created.\n");
    sleep(1);
    printf("wait done.\n");
    
    // Create structs to define memory bank mapping
    cl_mem_ext_ptr_t d_bank_ext[4];

    d_bank_ext[0].flags = XCL_MEM_DDR_BANK0;
    d_bank_ext[0].obj = NULL;
    d_bank_ext[0].param = 0;

    d_bank_ext[1].flags = XCL_MEM_DDR_BANK1;
    d_bank_ext[1].obj = NULL;
    d_bank_ext[1].param = 0;

    d_bank_ext[2].flags = XCL_MEM_DDR_BANK2;
    d_bank_ext[2].obj = NULL;
    d_bank_ext[2].param = 0;

    d_bank_ext[3].flags = XCL_MEM_DDR_BANK3;
    d_bank_ext[3].obj = NULL;
    d_bank_ext[3].param = 0;
    // Create the input and output arrays in device memory for our calculation



    //d_axi00_ptr0 = clCreateBuffer(context,  CL_MEM_READ_WRITE | CL_MEM_USE_HOST_PTR,  sizeof(struct axonerve_query)*number_of_words, (void*)queries, NULL);
    d_axi00_ptr0 = clCreateBuffer(context,  CL_MEM_READ_WRITE | CL_MEM_EXT_PTR_XILINX,  sizeof(struct axonerve_query) * number_of_words, &d_bank_ext[0], NULL);


    if (!(d_axi00_ptr0)) {
        printf("Error: Failed to allocate device memory!\n");
        printf("Test failed\n");
        return EXIT_FAILURE;
    }
    // Write our data set into the input array in device memory
    //


    cl_event writeevent;
    err = clEnqueueWriteBuffer(commands, d_axi00_ptr0, CL_TRUE, 0, sizeof(struct axonerve_query) * number_of_words, queries, 0, NULL, &writeevent);
    if (err != CL_SUCCESS) {
        printf("Error: Failed to write to source array h_axi00_ptr0_input!\n");
        printf("Test failed\n");
        return EXIT_FAILURE;
    }
    //clWaitForEvents(1, &writeevent);


    // Set the arguments to our compute kernel
    err = 0;
    cl_uint d_data_num = sizeof(struct axonerve_query) * number_of_words;
    printf("bytes = %d\n", d_data_num);
    err |= clSetKernelArg(kernel, 0, sizeof(cl_uint), &d_data_num);
    err |= clSetKernelArg(kernel, 1, sizeof(cl_mem), &d_axi00_ptr0); 

    if (err != CL_SUCCESS) {
        printf("Error: Failed to set kernel arguments! %d\n", err);
        printf("Test failed\n");
        return EXIT_FAILURE;
    }

    // Execute the kernel over the entire range of our 1d input data set
    // using the maximum number of work group items for this device

    cl_event kernelevent;
    err = clEnqueueTask(commands, kernel, 0, NULL, &kernelevent);
    if (err) {
	printf("Error: Failed to execute kernel! %d\n", err);
	printf("Test failed\n");
	return EXIT_FAILURE;
    }
    //clWaitForEvents(1, &kernelevent);

    // Read back the results from the device to verify the output
    //
    cl_event readevent;

    err = 0;
    err |= clEnqueueReadBuffer( commands, d_axi00_ptr0, CL_TRUE, 0, sizeof(struct axonerve_query) * number_of_words, results, 0, NULL, &readevent );


    if (err != CL_SUCCESS) {
	printf("Error: Failed to read output array! %d\n", err);
	printf("Test failed\n");
	return EXIT_FAILURE;
    }
    clWaitForEvents(1, &readevent);

    // Check Results

    for (uint i = 0; i < number_of_words; i++) {
	/*
	printf("query: %d\n", i);
	printf("KEY: %08x %08x %08x %08x\n", queries[i].key[0],queries[i].key[1],queries[i].key[2],queries[i].key[3]);
	printf("VALUE: %08x\n", queries[i].value);
	printf("CSR: %08x\n", queries[i].csr);
	printf("  SINGLE_HIT: %d\n", (queries[i].csr & 0x00000001)>>0);
	printf("  MULTI_HIT: %d\n",  (queries[i].csr & 0x00000002)>>1);
	printf("  ENT_ERR: %d\n",    (queries[i].csr & 0x00000004)>>2);
	printf("  ENT_FULL: %d\n",   (queries[i].csr & 0x00000008)>>3);
	printf("PRI: %08x\n", queries[i].priority);
	printf("MASK: %08x %08x %08x %08x\n", queries[i].mask[0],queries[i].mask[1],queries[i].mask[2],queries[i].mask[3]);
	printf("VERSION: %08x\n", queries[i].version);
	*/
	printf("result: %d\n", i);
	printf("KEY: %08x %08x %08x %08x\n", results[i].key[0],results[i].key[1],results[i].key[2],results[i].key[3]);
	printf("VALUE: %08x\n", results[i].value);
	printf("CSR: %08x\n", results[i].csr);
	printf("  SINGLE_HIT: %d\n", (results[i].csr & 0x00000001)>>0);
	printf("  MULTI_HIT: %d\n",  (results[i].csr & 0x00000002)>>1);
	printf("  ENT_ERR: %d\n",    (results[i].csr & 0x00000004)>>2);
	printf("  ENT_FULL: %d\n",   (results[i].csr & 0x00000008)>>3);
	printf("PRI: %08x\n", results[i].priority);
	printf("MASK: %08x %08x %08x %08x\n", results[i].mask[0],results[i].mask[1],results[i].mask[2],results[i].mask[3]);
	printf("VERSION: %08x\n", results[i].version);
    }

    //--------------------------------------------------------------------------
    // Shutdown and cleanup
    //-------------------------------------------------------------------------- 
    free(queries);
    free(results);

    clFlush(commands);
    clFinish(commands);
    clReleaseKernel(kernel);
    clReleaseProgram(program);
    clReleaseMemObject(d_axi00_ptr0);
    clReleaseCommandQueue(commands);
    clReleaseContext(context);

    if (check_status) {
        printf("INFO: Test failed\n");
        return EXIT_FAILURE;
    } else {
        printf("INFO: Test completed successfully.\n");
        return EXIT_SUCCESS;
    }


} // end of main
