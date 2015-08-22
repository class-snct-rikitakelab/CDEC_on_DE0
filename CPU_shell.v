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

    output wire clocklevel,
    output wire endseq,

    input  wire [ 1:0] ressel,       // resource selector for debug monitor
    output wire [ 7:0] resdt_h,       // resource data for debug monitor
    output wire [ 7:0] resdt_l
    );

    wire [7:0] data_in;
    wire [7:0] data_out;
    wire [7:0] adrs;
    wire mmwr_en;

    wire [7:0] resad;
    wire [7:0] resdt;

  // -- debug monitor ---
    // clock level
    assign clocklevel = clock;
    // convert ressel to resad
    assign resad = resource_select(ressel);

    function [7:0] resource_select;
        input [1:0] sel;
        begin
            case (sel)
                2'b00 : resource_select = 8'h00; // PC
                2'b01 : resource_select = 8'h08; // A
                2'b10 : resource_select = 8'h01; // I
                2'b11 : resource_select = 8'h0e; // XBUX
            endcase
        end
    endfunction

    sseg_dec hex1(.data(resdt[7:4]), .led(resdt_h));
    sseg_dec hex0(.data(resdt[3:0]), .led(resdt_l));

  //-- CPU core instantiation and bus connection

    CDEC8 CDEC8( clock, reset_N,
		 adrs[7:0], data_in[7:0], data_out[7:0], mmwr_en,
         //mmrd_N, mmwr_N, mm_dboe,
         endseq,
		 resad, resdt);

  //-- memory/io signal connection
    // fake implementaion by rom instead of ram
    rom rom(.adrs(adrs), .data(data_out), .q(data_in), 
        .clock(clock), .wr_en(mmwr_en));
    // ram ram(.adrs(adrs), .data(data_out), .q(data_in), 
    //     .clock(clock), .wr_en(mmwr_en));


endmodule

