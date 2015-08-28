`timescale 10ns / 1ps
`default_nettype none

module register_sim;
  reg clock;
  reg wr_en;
  reg reset_N;
  reg [7:0]   in;
  wire [7:0]  out_pe;
  wire [7:0]  out_ner;
  wire [7:0]  out_ll;
  
  reg8_pe sut_reg8_pe(.clock(clock), .wr_en(wr_en), .in(in), .out(out_pe));
  reg8_ner sut_reg8_ner(.clock(clock), .reset_N(reset_N),.wr_en(wr_en), .in(in), .out(out_ner));
  reg8_ll sut_reg8_ll(.clock(clock), .wr_en(wr_en), .in(in), .out(out_ll));
  
  initial begin
    clock = 0;
    forever #2 clock = !clock;
  end
  
  initial begin
    wr_en = 0;
    reset_N = 1;
    in = 8'haa;
    #3;
    wr_en = 1;
    #4;
    wr_en = 0;
    in = 8'h99;
    #4;
    wr_en = 1;
    #4;
    reset_N = 0;
    #2; 
    wr_en = 0;
    #2;
    in = 8'h55;
    #2;
    wr_en = 1;
    #4;
    in = 8'hff;
    #6;
    in = 8'h11;
  end
endmodule
  
