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
    int* axi00_ptr0,
    int* axi01_ptr0,
    int* axi02_ptr0,
    int* axi03_ptr0,
    int* axi04_ptr0,
    int* axi05_ptr0
) {

    #pragma HLS INTERFACE m_axi port=axi00_ptr0 offset=slave bundle=m00_axi
    #pragma HLS INTERFACE m_axi port=axi01_ptr0 offset=slave bundle=m01_axi
    #pragma HLS INTERFACE m_axi port=axi02_ptr0 offset=slave bundle=m02_axi
    #pragma HLS INTERFACE m_axi port=axi03_ptr0 offset=slave bundle=m03_axi
    #pragma HLS INTERFACE m_axi port=axi04_ptr0 offset=slave bundle=m04_axi
    #pragma HLS INTERFACE m_axi port=axi05_ptr0 offset=slave bundle=m05_axi
    #pragma HLS INTERFACE s_axilite port=data_num bundle=control
    #pragma HLS INTERFACE s_axilite port=axi00_ptr0 bundle=control
    #pragma HLS INTERFACE s_axilite port=axi01_ptr0 bundle=control
    #pragma HLS INTERFACE s_axilite port=axi02_ptr0 bundle=control
    #pragma HLS INTERFACE s_axilite port=axi03_ptr0 bundle=control
    #pragma HLS INTERFACE s_axilite port=axi04_ptr0 bundle=control
    #pragma HLS INTERFACE s_axilite port=axi05_ptr0 bundle=control
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


    // Create input and output buffers for interface m01_axi
    int m01_axi_input_buffer[BUFFER_SIZE];
    int m01_axi_output_buffer[BUFFER_SIZE];


    // length is specified in number of words.
    unsigned int m01_axi_length = 4096;


    // Assign input to a buffer
    memcpy(m01_axi_input_buffer, (int*) axi01_ptr0, m01_axi_length*sizeof(int));

    // Add 1 to input buffer and assign to output buffer.
    for (i = 0; i < m01_axi_length; i++) {
      m01_axi_output_buffer[i] = m01_axi_input_buffer[i]  + 1;
    }

    // assign output buffer out to memory
    memcpy((int*) axi01_ptr0, m01_axi_output_buffer, m01_axi_length*sizeof(int));


    // Create input and output buffers for interface m02_axi
    int m02_axi_input_buffer[BUFFER_SIZE];
    int m02_axi_output_buffer[BUFFER_SIZE];


    // length is specified in number of words.
    unsigned int m02_axi_length = 4096;


    // Assign input to a buffer
    memcpy(m02_axi_input_buffer, (int*) axi02_ptr0, m02_axi_length*sizeof(int));

    // Add 1 to input buffer and assign to output buffer.
    for (i = 0; i < m02_axi_length; i++) {
      m02_axi_output_buffer[i] = m02_axi_input_buffer[i]  + 1;
    }

    // assign output buffer out to memory
    memcpy((int*) axi02_ptr0, m02_axi_output_buffer, m02_axi_length*sizeof(int));


    // Create input and output buffers for interface m03_axi
    int m03_axi_input_buffer[BUFFER_SIZE];
    int m03_axi_output_buffer[BUFFER_SIZE];


    // length is specified in number of words.
    unsigned int m03_axi_length = 4096;


    // Assign input to a buffer
    memcpy(m03_axi_input_buffer, (int*) axi03_ptr0, m03_axi_length*sizeof(int));

    // Add 1 to input buffer and assign to output buffer.
    for (i = 0; i < m03_axi_length; i++) {
      m03_axi_output_buffer[i] = m03_axi_input_buffer[i]  + 1;
    }

    // assign output buffer out to memory
    memcpy((int*) axi03_ptr0, m03_axi_output_buffer, m03_axi_length*sizeof(int));


    // Create input and output buffers for interface m04_axi
    int m04_axi_input_buffer[BUFFER_SIZE];
    int m04_axi_output_buffer[BUFFER_SIZE];


    // length is specified in number of words.
    unsigned int m04_axi_length = 4096;


    // Assign input to a buffer
    memcpy(m04_axi_input_buffer, (int*) axi04_ptr0, m04_axi_length*sizeof(int));

    // Add 1 to input buffer and assign to output buffer.
    for (i = 0; i < m04_axi_length; i++) {
      m04_axi_output_buffer[i] = m04_axi_input_buffer[i]  + 1;
    }

    // assign output buffer out to memory
    memcpy((int*) axi04_ptr0, m04_axi_output_buffer, m04_axi_length*sizeof(int));


    // Create input and output buffers for interface m05_axi
    int m05_axi_input_buffer[BUFFER_SIZE];
    int m05_axi_output_buffer[BUFFER_SIZE];


    // length is specified in number of words.
    unsigned int m05_axi_length = 4096;


    // Assign input to a buffer
    memcpy(m05_axi_input_buffer, (int*) axi05_ptr0, m05_axi_length*sizeof(int));

    // Add 1 to input buffer and assign to output buffer.
    for (i = 0; i < m05_axi_length; i++) {
      m05_axi_output_buffer[i] = m05_axi_input_buffer[i]  + 1;
    }

    // assign output buffer out to memory
    memcpy((int*) axi05_ptr0, m05_axi_output_buffer, m05_axi_length*sizeof(int));


}

