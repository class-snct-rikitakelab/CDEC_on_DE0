/* CPU_shell.v  = = = = = = = = = = = = = = = = = = = = = = = = = = = = *****
 **    CDEC8 and test bench / FPGA interface module			 ****
 ***       Ver. 1.0 2014.05.30						  ***
 ****									   **
 ***** (C) 2014 kimsyn (ET & VLSI system design labo. GCT ICE)  = = = = = = */

`default_nettype none
`include "my_const.vh"

module CPU_shell(
    input  wire        clock,	// clock
    input  wire        reset_N,	// reset (active low)

    input  wire [ 7:0] resad,	    // resource address for debug monitor
    output wire [ 7:0] resdt	    // resource data for debug monitor
    );

    wire [7:0] data_in;
    wire [7:0] data_out;
    wire [7:0] adrs;
    wire mmwr_en;

  //-- CPU core instantiation and bus connection

    CDEC8 CDEC8( clock, reset_N,
		 adrs[7:0], data_in[7:0], data_out[7:0],
		 mmwr_en,
         //mmrd_N, mmwr_N, mm_dboe,
		 resad, resdt);


  //-- memory/io signal connection
    ram ram(.adrs(adrs), .data(data_out), .q(data_in), 
        .clock(clock), .wr_en(mmwr_en));



endmodule

