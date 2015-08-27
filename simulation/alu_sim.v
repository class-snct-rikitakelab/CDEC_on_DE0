`timescale 10ns / 1ps
`default_nettype none

module alu_sim;
  reg [7:0] xbus;
  reg [7:0] treg;
  reg cy;
  reg [4:0] alu_op;
  wire [2:0] alu_flag;
  wire [7:0] alu_result;

  alu alu(.x(xbus), .t(treg), .cy(cy), .alu_op(alu_op), .alu_flag(alu_flag), .alu_result(alu_result));
   
  initial begin
    xbus = 8'haa;
    treg = 8'h55;
    cy = 1'b0;
    // zero
    alu_op = 5'b00000;
    #1;
    // path x
    alu_op = 5'b00001;
    #1;
    // pass t
    alu_op = 5'b00010;
    #1;
    // add
    alu_op = 5'b01000;
    #1;
    // sub
    alu_op = 5'b01011;
    #1;
    // inc
    alu_op = 5'b01110;
    #1;
    // dec
    alu_op = 5'b01111;
    #1;
    // and
    alu_op = 5'b10000;
    #1;
    // or 
    alu_op = 5'b10001;
    #1;
    // shift right logical
    alu_op = 5'b11000;
    #1;
  end
endmodule
  
