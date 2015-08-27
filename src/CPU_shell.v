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
    input  wire        p_clock, // clock for programming

    input wire  [7:0] io_in,  // input port
    output wire [7:0] io_out, // output port

    output wire clocklevel,
    output wire endseq,

    input  wire [1:0] select_sw,       // resource selector for debug monitor
    output wire [7:0] ssled3,      // resource data for debug monitor (hex)
    output wire [7:0] ssled2,
    output wire [7:0] ssled1,
    output wire [7:0] ssled0
    );
    
    // mode == 1 : program mode
    // mode == 0 : run mode 
    wire        mode;

    // memory_programmer -> memory
    wire [7:0]  prog_adrs;
    wire [7:0]  prog_data;
    wire        prog_clock;
    wire        prog_wr_en;

    // CDEC8 <-> memory
    wire [7:0] data_in;
    wire [7:0] data_out;
    wire [7:0] adrs;
    wire mmwr_en;

    // debug
    wire        ressel;
    wire [7:0]  resad;
    wire [7:0]  resdt;
    
    //
    assign {mode, ressel} = select_sw;

    // 
    sseg_dec sseg3(.data(mode ? prog_adrs[7:4] : 4'h0), .led(ssled3));
    sseg_dec sseg2(.data(mode ? prog_adrs[3:0] : 4'h0), .led(ssled2));
    sseg_dec sseg1(.data(mode ? prog_data[7:4] : resdt[7:4]), .led(ssled1));
    sseg_dec sseg0(.data(mode ? prog_data[3:0] : resdt[3:0]), .led(ssled0));
   
   // memory programmer
   memory_programmer(.clock_in(p_clock), .reset_N(reset_N),
    .data_in(io_in), .clock_out(prog_clock), .wr_en_out(prog_wr_en),
    .address_out(prog_adrs), .data_out(prog_data));

  // -- debug monitor ---
    // clock level
    assign clocklevel = clock;
    // convert ressel to resad
    assign resad = resource_select(ressel);

    function [7:0] resource_select;
        input sel;
        begin
            case (sel)
                2'b0 : resource_select = 8'h00; // PC
                2'b1 : resource_select = 8'h01; // I
            endcase
        end
    endfunction

  //-- CPU core instantiation and bus connection

    CDEC8 CDEC8( clock, reset_N,
        io_in, io_out,
		adrs[7:0], data_in[7:0], data_out[7:0], mmwr_en,
        endseq,
		resad, resdt);

  //-- memory/io signal connection
    ram ram(
        .adrs(mode ? prog_adrs : adrs), 
        .data(mode ? prog_data : data_out), 
        .q(data_in), 
        .clock(mode ? prog_clock : clock),
        .wr_en(mode ? prog_wr_en : mmwr_en));

endmodule

