`timescale 1s / 1ms
`default_nettype none

module cpu_shell_sim; 
  reg  [2:0]   BUTTON;     // push buttons: {p_clock, reset_N, clock}
  reg  [9:0]   SW;         // slide switches: {mode, select_sw, io_in}
  wire [9:0]   LEDG;       // LED Green: {clocklevel, endseq, io_out}
  wire [6:0]   HEX0_D;     // 7seg digit 0
  wire         HEX0_DP;    // 7seg dp 0
  wire [6:0]   HEX1_D;     // 7seg digit 1
  wire         HEX1_DP;    // 7seg dp 1
  wire [6:0]   HEX2_D;     // 7seg digit 2
  wire         HEX2_DP;    // 7seg dp 2
  wire [6:0]   HEX3_D;     // 7seg digit 3
  wire         HEX3_DP;    // 7seg dp 3

  CPU_shell sut_cpu(
    .BUTTON(BUTTON),
    .SW(SW),
    .LEDG(LEDG),       // LED Green: {clocklevel, endseq, io_out}
    .HEX0_D(HEX0_D),     // 7seg digit 0
    .HEX0_DP(HEX0_DP),    // 7seg dp 0
    .HEX1_D(HEX1_D),     // 7seg digit 1
    .HEX1_DP(HEX1_DP),    // 7seg dp 1
    .HEX2_D(HEX2_D),     // 7seg digit 2
    .HEX2_DP(HEX2_DP),    // 7seg dp 2
    .HEX3_D(HEX3_D),     // 7seg digit 3
    .HEX3_DP(HEX3_DP)    // 7seg dp 3
    );

  // clock generator
  initial begin
    BUTTON[2] = 0;
    forever #2 BUTTON[2] = !BUTTON[2];
  end
  
  // programming phase
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
  
