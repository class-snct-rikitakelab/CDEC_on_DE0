/* CDEC_DP.v  = = = = = = = = = = = = = = = = = = = = = = = = = = = = = *****
 **    CDEC data path part FPGA version					 ****
 ***       Ver. 1.0  2014.05.29						  ***
 ****									   **
 ***** (C) 2014 kimsyn (ET & VLSI system design labo. GCT ICE)  = = = = = = */

`default_nettype none
`include "my_const.vh"

module CDEC8_DP (
    input  wire        clock,
    input  wire        reset_N,

    output wire [ 7:0] adrs,
    input  wire [ 7:0] data_in,
    output wire [ 7:0] data_out,

    output wire [ 7:0] I,
    output wire [ 2:0] SZCy,

    input  wire [14:0] ctrl,

    input  wire [ 7:0] resad,	// resource address for PC debug monitor
    output wire [ 7:0] resdt,	// resource data    for PC debug monitor

    input  wire [ 7:0] LEDresad,	// resource address for LED signal display board
    output wire [ 7:0] LEDresdt);	// resource data    for LED signal display board


  //-- internal signals

    wire       rwr, fwr;
    wire [1:0] mmrw;
    wire [2:0] xdst, xsrc;
    wire [4:0] aluop;

    wire [7:0] XBUS;
    wire [7:0] PC, A, B, C, T, R, MAR, RDR, WDR, FLG;
    wire [7:0] alu_out;
    wire [2:0] alu_szcy;

  //-- ALU function include
    `include "ALU_func.v"

  //-- 3-state buffer function include
    `include "tbuf_func.v"

  //-- control signal re-assign
    assign {mmrw, fwr, rwr, xdst, aluop, xsrc} = ctrl; // CTRL

  //-- ALU/FLAG connection
    assign {alu_szcy,  alu_out} = ALU(XBUS, T, FLG[1], aluop);	// ALU
    assign SZCy = FLG[3:1];
 
  //-- memory bus
    assign adrs     = MAR;
    assign data_out = WDR;

  //-- data bus output connection
    assign data_out = WDR;			// WDR to external connection

  //-- XBUS connection
    assign XBUS = TBUF8_func(xsrc==3'b000, PC );	// PC
    assign XBUS = TBUF8_func(xsrc==3'b001, A  );	// A
    assign XBUS = TBUF8_func(xsrc==3'b010, B  );	// B
    assign XBUS = TBUF8_func(xsrc==3'b011, C  );	// C
    assign XBUS = TBUF8_func(xsrc==3'b100, R  );	// R
    assign XBUS = TBUF8_func(xsrc==3'b101, RDR);	// RDR
    assign XBUS = TBUF8_func(xsrc==3'b110, FLG);	// FLG

    PULLUP PXBUS[7:0] (.O(XBUS[7:0]));			// pull up of XBUS

  //-- register instantiation
    reg8_per PC_reg  (clock, (xdst==3'b000), XBUS,          PC, reset_N); // PC
    reg8_pe #(8) A_reg   (clock, (xdst==3'b001), XBUS,          A          ); // A
    reg8_pe  B_reg   (clock, (xdst==3'b010), XBUS,          B          ); // B
    reg8_pe  C_reg   (clock, (xdst==3'b011), XBUS,          C          ); // C
    reg8_ll  I_reg   (clock, (xdst==3'b111), XBUS,          I          ); // I
    reg8_ll  T_reg   (clock, (xdst==3'b110), XBUS,          T          ); // T
    reg8_ll  MAR_reg (clock, (xdst==3'b100), XBUS,          MAR        ); // MAR
    reg8_ll  WDR_reg (clock, (xdst==3'b101), XBUS,          WDR        ); // WDR
    reg8_pe  RDR_reg (clock, (mmrw==2'b10 ), data_in,       RDR        ); // RDR
    reg8_pe  R_reg   (clock, (rwr),          alu_out,       R          ); // R
    reg8_pe  FLG_reg (clock, (fwr), {4'h0, alu_szcy, 1'b0}, FLG        ); // FLG

  //-- internal hardware resource singnal observation bus for debug monitor
    assign resdt    = (   resad==8'h00) ? PC      : 8'hZZ;
    assign resdt    = (   resad==8'h01) ? I       : 8'hZZ;
    assign resdt    = (   resad==8'h02) ? T       : 8'hZZ;
    assign resdt    = (   resad==8'h03) ? R       : 8'hZZ;
    assign resdt    = (   resad==8'h04) ? MAR     : 8'hZZ;
    assign resdt    = (   resad==8'h05) ? data_in : 8'hZZ;
    assign resdt    = (   resad==8'h06) ? RDR     : 8'hZZ;
    assign resdt    = (   resad==8'h07) ? WDR     : 8'hZZ;
    assign resdt    = (   resad==8'h08) ? A       : 8'hZZ;
    assign resdt    = (   resad==8'h09) ? B       : 8'hZZ;
    assign resdt    = (   resad==8'h0A) ? C       : 8'hZZ;
//  assign resdt    = (   resad==8'h0B) ? state   : 8'hZZ;	// external
//  assign resdt    = (   resad==8'h0C) ? signal  : 8'hZZ;	// external
    assign resdt    = (   resad==8'h0D) ? FLG     : 8'hZZ;

  //-- internal hardware resource singnal observation bus for LED display board
    assign LEDresdt = (LEDresad==8'h00) ? PC      : 8'hZZ;
    assign LEDresdt = (LEDresad==8'h01) ? I       : 8'hZZ;
    assign LEDresdt = (LEDresad==8'h02) ? T       : 8'hZZ;
    assign LEDresdt = (LEDresad==8'h03) ? R       : 8'hZZ;
    assign LEDresdt = (LEDresad==8'h04) ? MAR     : 8'hZZ;
    assign LEDresdt = (LEDresad==8'h05) ? data_in : 8'hZZ;
    assign LEDresdt = (LEDresad==8'h06) ? RDR     : 8'hZZ;
    assign LEDresdt = (LEDresad==8'h07) ? WDR     : 8'hZZ;
    assign LEDresdt = (LEDresad==8'h08) ? A       : 8'hZZ;
    assign LEDresdt = (LEDresad==8'h09) ? B       : 8'hZZ;
    assign LEDresdt = (LEDresad==8'h0A) ? C       : 8'hZZ;
//                    (LEDresad==8'h0B) ? state   : 8'hZZ;	// external
//                    (LEDresad==8'h0C) ? signal  : 8'hZZ;	// external
    assign LEDresdt = (LEDresad==8'h0D) ? FLG     : 8'hZZ;
//  assign LEDresdt = (LEDresad==8'h0E) ? CLKCOUNT_H : 8'hZZ;	// external
//  assign LEDresdt = (LEDresad==8'h0F) ? CLKCOUNT_L : 8'hZZ;	// external

endmodule
