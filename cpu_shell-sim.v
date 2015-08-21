`timescale 10ns / 1ps
`default_nettype none

module cpu_shell_sim; 
  reg clock;
  reg reset_N;
  reg [7:0] resad;
  wire [7:0] resdt;
  
  CPU_shell sut_cpu(.clock(clock), .reset_N(reset_N), 
    .resad(resad), .resdt(resdt));

  initial begin
    clock = 0;
    forever #2 clock = !clock;
  end
  
  initial begin
    reset_N = 1;
    resad = 8'h08; // Areg
    #3;
    reset_N = 0;
    #4;
    reset_N = 1;
  end
endmodule
  
