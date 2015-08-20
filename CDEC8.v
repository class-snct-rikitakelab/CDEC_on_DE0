/* CDEC8.v  = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = *****
 **    CDEC8 cpu core module						 ****
 ***       Ver. 1.0  2014.09.01						  ***
 ****									   **
 ***** (C) 2014 kimsyn (ET & VLSI system design labo. GCT ICE)  = = = = = = */

`default_nettype none
`include "my_const.vh"

module CDEC8(
    input         clock,
    input         reset_N,

    output [7:0] adrs,
    input  [7:0] data_in,
    output [7:0] data_out,
    output       mmwr_en,

    //output       mmrd_N, 
    //output       mmwr_N, 
    //output       mm_dboe,

    input  [7:0] resad,
    output [7:0] resdt);
	 
    wire [ 2:0] SZCy;
    wire [ 7:0] I;
    wire [14:0] ctrl;

    wire   [ 1:0] mmrw;

    // reg  [15:0] clock_count;
    // reg         clk_count_en;

    CDEC8_DP CDEC8_DP ( 
        clock, reset_N,
        adrs, data_in, data_out,
        I, SZCy, ctrl,
        resad, resdt);

    CDEC8_PLA_ctrl CDEC8_PLA_ctrl (
        clock, reset_N,
        I, SZCy, ctrl,
        resad, resdt);

  //-- memory access control signals
    assign mmrw     = ctrl[14:13];
    assign mmwr_en  = (mmrw == 2'b01);
    //assign mmrd_N   = ~(mmrw == 2'b10   );   // memory read (active low)
    //assign mm_dboe  =  (mmrw == 2'b01   );   // memory data bus output enable
    //assign mmwr_N   = ~(mm_dboe & ~clock);   // memory write (active low)

endmodule
