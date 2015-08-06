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

    output       mmrd_N, 
    output       mmwr_N, 
    output       mm_dboe,

    input  [7:0] resad,
    output [7:0] resdt, 
    input  [7:0] LEDresad, 
    output [7:0] LEDresdt);

    wire [ 2:0] SZCy;
    wire [ 7:0] I;
    wire [14:0] ctrl;

    reg  [15:0] clock_count;
    reg         clk_count_en;

    CDEC8_DP CDEC8_DP ( 
        clock, reset_N,
        adrs, data_in, data_out,
        I, SZCy, ctrl,
        resad, resdt, LEDresad, LEDresdt);

    CDEC8_PLA_ctrl CDEC8_PLA_ctrl (
        clock, reset_N,
        I, SZCy, ctrl,
        mmrd_N,  mmwr_N, mm_dboe,
        resad, resdt, LEDresad, LEDresdt);
    
  //-- execution clock counter

    always @(negedge clock, negedge reset_N) begin
        if(~reset_N) begin
            clk_count_en <= `OFF;
        end else if(ctrl[7:3]==5'b00110) begin
            clk_count_en <= `OFF;
        end else if(ctrl[7:3]==5'b00101) begin
            clk_count_en <= `ON;
        end
    end

    always @(posedge clock, negedge reset_N) begin
        if(~reset_N) begin
            clock_count <= 16'h0000;
        end else if(ctrl[7:3]==5'b00100) begin
            clock_count <= 16'h0000;
        end else if(clk_count_en) begin
            clock_count <= clock_count + 1;
        end
    end

    assign LEDresdt = (LEDresad==8'h0E) ? clock_count[15:8] : 8'hZZ;
    assign LEDresdt = (LEDresad==8'h0F) ? clock_count[ 7:0] : 8'hZZ;

endmodule
