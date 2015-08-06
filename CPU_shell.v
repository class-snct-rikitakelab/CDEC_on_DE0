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

    output wire [18:0] adrs,
    input  wire [31:0] data_in,
    output wire [31:0] data_out,

    output wire [ 1:0] mmcs_N,	// fixed signal for memory select
    output wire [ 3:0] mmbe_N,	// fixed signal for memory select
    output wire        mmrd_N,	// memory read  strobe (active low)
    output wire        mmwr_N,	// memory write strobe (active low)
    output wire        mm_dboe,

    output wire        iord_N,	// R.F.U.
    output wire        iowr_N,	// R.F.U.
    output wire        io_dboe,	// R.F.U.
    
    input  wire        intrq_N,	// R.F.U.
    output wire        intak_N,	// R.F.U.

    input  wire [ 7:0] resad,	    // resource address for debug monitor
    output wire [ 7:0] resdt,	    // resource data for debug monitor
    input  wire [ 7:0] LEDresad,    // resource address for 7-seg LED board
    output wire [ 7:0] LEDresdt,    // resource data for 7-seg LED board

    input  wire        HWD_WR_STB_N,
    input  wire [31:0] BP_bus,
    input  wire        BP_ptn_reg_sel,
    input  wire        BP_msk_reg_sel,
    input  wire [ 3:0] BP_set_sel,
    output wire [15:0] BP_cond_match_set);


  //-- internal signals
    wire   [ 7:0] basic_signal;


  //-- CPU core instantiation and bus connection

    CDEC8 CDEC8( clock, reset_N,
		 adrs[7:0], data_in[7:0], data_out[7:0],
		 mmrd_N, mmwr_N, mm_dboe,
		 resad, resdt, LEDresad, LEDresdt);


  //-- memory/io signal connection

    assign adrs[18:8] = 11'b000_0000_0000;

    assign mmcs_N  = 2'b10;
    assign mmbe_N  = 4'b1110;

    assign iord_N  = `HIGH;
    assign iowr_N  = `HIGH;
    assign io_dboe = `LOW;


  //-- unused signal connection
    assign intak_N = `HIGH;


  //-- internal hardware resource singnal observation bus for debug monitor and
  //                                                          LED display board

    assign basic_signal = { clock,  ~reset_N, ~intrq_N, ~intak_N,
                           ~mmrd_N, ~mmwr_N,  ~iord_N,  ~iowr_N  };
                     
    assign resdt    = (   resad==8'h0C) ? basic_signal      : 8'hZZ;
    assign LEDresdt = (LEDresad==8'h0C) ? basic_signal      : 8'hZZ;


  //-- break point 
    assign BP_cond_match_set = 16'h0000;


  //-- internal bus pull up for FPGA

    generate
        genvar i;

        for (i=0; i<32; i=i+1) begin : UD
            PULLUP PD (data_out[i]);
        end
    endgenerate


endmodule

