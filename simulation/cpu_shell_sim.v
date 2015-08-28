`timescale 10ns / 1ps
`default_nettype none

module cpu_shell_sim; 
  reg clock;
  reg reset_N;

  wire clocklevel;
  wire endseq;

  reg  [7:0] io_in;  // input port
  wire [7:0] io_out; // output port

  reg [1:0] ressel;
  wire [7:0] resdt_h;
  wire [7:0] resdt_l;

  CPU_shell sut_cpu(.clock(clock), .reset_N(reset_N),
    .io_in(io_in), .io_out(io_out),
    .clocklevel(clocklevel), .endseq(endseq),
    .ressel(ressel), 
    .resdt_h(resdt_h), .resdt_l(resdt_l));

  initial begin
    clock = 0;
    forever #2 clock = !clock;
  end
  
  initial begin
    reset_N = 1;
    ressel = 2'b1; // Areg
    io_in = 8'h03;
    #3;
    reset_N = 0;
    #4;
    reset_N = 1;
  end
endmodule
  
