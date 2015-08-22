`timescale 10ns / 1ps
`default_nettype none

module cpu_shell_sim; 
  reg clock;
  reg reset_N;

  wire clocklevel;
  wire endseq;

  reg [1:0] ressel;
  wire [7:0] resdt_h;
  wire [7:0] resdt_l;

  CPU_shell sut_cpu(.clock(clock), .reset_N(reset_N), 
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
    #3;
    reset_N = 0;
    #4;
    reset_N = 1;
  end
endmodule
  
