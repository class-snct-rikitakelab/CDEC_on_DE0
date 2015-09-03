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

    // io port
    input  wire [7:0] io_in,  // input port 
    output wire [7:0] io_out, // output port

    // memory
    output wire [ 7:0] adrs,
    input  wire [ 7:0] data_in,
    output wire [ 7:0] data_out,

    // to control unit
    output wire [ 7:0] I,
    output wire [ 2:0] SZCy,

    // from control unit
    input  wire [16:0] ctrl,

    // debug monitor
    input  wire [ 7:0] resad,	// resource address for PC debug monitor
    output wire [ 7:0] resdt//,	// resource data    for PC debug monitor
    );


  //-- internal signals

    wire       rwr, fwr;
    wire [1:0] mmrw;
    wire [3:0] xdst, xsrc;
    wire [4:0] aluop;

    wire [7:0] XBUS;
    wire [7:0] PC, A, B, C, T, R, MAR, RDR, WDR, FLG;
    wire [7:0] IPORT;
    wire [7:0] alu_out;
    wire [2:0] alu_szcy;


  //-- 3-state buffer function include
    `include "tbuf_func.v"
  //  `include "ALU_func.v"


  //-- control signal re-assign
    assign {mmrw, fwr, rwr, xdst, aluop, xsrc} = ctrl; // CTRL

  //-- ALU/FLAG connection
    alu alu(.x(XBUS), .t(T), .cy(FLG[1]), .alu_op(aluop), .alu_flag(alu_szcy), .alu_result(alu_out));
    //assign {alu_szcy,  alu_out} = ALU(XBUS, T, FLG[1], aluop);	// ALU
    assign SZCy = FLG[3:1];
 
  //-- memory bus
    assign adrs     = MAR;
    assign data_out = WDR;


  //-- XBUS connection
    function [7:0] select_src;
        input [3:0] src;
        input [7:0] w0, w1, w2, w3, w4, w5, w6, w7, w8;
        begin
            case(src)
               4'b0000 : select_src = w0;
               4'b0001 : select_src = w1;
               4'b0010 : select_src = w2;
               4'b0011 : select_src = w3;
               4'b0100 : select_src = w4;
               4'b0101 : select_src = w5;
               4'b0110 : select_src = w6;
               4'b1000 : select_src = w7;
               default : select_src = w8;
            endcase            
        end
    endfunction

    assign XBUS = select_src(xsrc, PC, A, B, C, R, RDR, FLG, IPORT, 8'hff);
    //assign XBUS = TBUF8_func(xsrc==3'b000, PC );	// PC
    //assign XBUS = TBUF8_func(xsrc==3'b001, A  );	// A
    //assign XBUS = TBUF8_func(xsrc==3'b010, B  );	// B
    //assign XBUS = TBUF8_func(xsrc==3'b011, C  );	// C
    //assign XBUS = TBUF8_func(xsrc==3'b100, R  );	// R
    //assign XBUS = TBUF8_func(xsrc==3'b101, RDR);	// RDR
    //assign XBUS = TBUF8_func(xsrc==3'b110, FLG);	// FLG
    // // otherwise pullup
    //assign XBUS = (xsrc==3'b111) ? 8'hff : 8'hzz;
    // //PULLUP PXBUS[7:0] (.O(XBUS[7:0]));			// pull up of XBUS

  //-- register instantiation
    reg8_per PC_reg  (clock, (xdst==4'b0000), XBUS,          PC, reset_N); // PC
    reg8_pe  A_reg   (clock, (xdst==4'b0001), XBUS,          A          ); // A
    reg8_pe  B_reg   (clock, (xdst==4'b0010), XBUS,          B          ); // B
    reg8_pe  C_reg   (clock, (xdst==4'b0011), XBUS,          C          ); // C
    reg8_ll  I_reg   (clock, (xdst==4'b0111), XBUS,          I          ); // I
    reg8_ll  T_reg   (clock, (xdst==4'b0110), XBUS,          T          ); // T
    reg8_ll  MAR_reg (clock, (xdst==4'b0100), XBUS,          MAR        ); // MAR
    reg8_ll  WDR_reg (clock, (xdst==4'b0101), XBUS,          WDR        ); // WDR
    reg8_pe  RDR_reg (clock, (mmrw==2'b10 ), data_in,       RDR        ); // RDR
    reg8_pe  R_reg   (clock, (rwr),          alu_out,       R          ); // R
    reg8_pe  FLG_reg (clock, (fwr), {4'h0, alu_szcy, 1'b0}, FLG        ); // FLG
    reg8_ll  IPORT_reg(clock, (1'b1), io_in, IPORT);          // IPORT
    reg8_pe  OPORT_reg(clock, (xdst==4'b1000), XBUS, io_out); // OPORT

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
    assign resdt    = (   resad==8'h0E) ? XBUS    : 8'hzz;
    assign resdt    = (   resad==8'h0F) ? IPORT   : 8'hzz;

endmodule