// This is a generated file. Use and modify at your own risk.
////////////////////////////////////////////////////////////////////////////////

//-----------------------------------------------------------------------------
// kernel: axonerve_kvs_rtl
//
// Purpose: This kernel example shows a basic vector add +1 (constant) by
//          manipulating memory inplace.
//-----------------------------------------------------------------------------
#define BUFFER_SIZE 8192
#include <string.h>
#include <stdbool.h>
#include "hls_half.h"

// Do not modify function declaration
extern "C" void axonerve_kvs_rtl (
    unsigned int data_num,
    int* axi00_ptr0
) {

    #pragma HLS INTERFACE m_axi port=axi00_ptr0 offset=slave bundle=m00_axi
    #pragma HLS INTERFACE s_axilite port=data_num bundle=control
    #pragma HLS INTERFACE s_axilite port=axi00_ptr0 bundle=control
    #pragma HLS INTERFACE s_axilite port=return bundle=control

// Modify contents below to match the function of the RTL Kernel
    int i = 0;

    // Create input and output buffers for interface m00_axi
    int m00_axi_input_buffer[BUFFER_SIZE];
    int m00_axi_output_buffer[BUFFER_SIZE];


    // length is specified in number of words.
    unsigned int m00_axi_length = 4096;


    // Assign input to a buffer
    memcpy(m00_axi_input_buffer, (int*) axi00_ptr0, m00_axi_length*sizeof(int));

    // Add 1 to input buffer and assign to output buffer.
    for (i = 0; i < m00_axi_length; i++) {
      m00_axi_output_buffer[i] = m00_axi_input_buffer[i]  + 1;
    }

    // assign output buffer out to memory
    memcpy((int*) axi00_ptr0, m00_axi_output_buffer, m00_axi_length*sizeof(int));


}

