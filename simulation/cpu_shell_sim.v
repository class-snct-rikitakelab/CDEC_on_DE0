`timescale 1ms/1us
`default_nettype none

module cpu_shell_sim; 
  wire  [2:0] BUTTON;   // push buttons: {clock, reset_N, p_clock}
  wire  [9:0] SW;       // slide switches: {mode, select_sw, io_in}
  wire  [9:0] LEDG;     // LED Green: {clocklevel, endseq, io_out}
  wire  [6:0] HEX0_D;   // 7seg digit 0
  wire        HEX0_DP;  // 7seg dp 0
  wire  [6:0] HEX1_D;   // 7seg digit 1
  wire        HEX1_DP;  // 7seg dp 1
  wire  [6:0] HEX2_D;   // 7seg digit 2
  wire        HEX2_DP;  // 7seg dp 2
  wire  [6:0] HEX3_D;   // 7seg digit 3
  wire        HEX3_DP;  // 7seg dp 3

  reg       clock;
  reg       reset_N;
  reg       program_clock;
  reg       mode;
  reg       res_sel;
  reg [7:0] io_in;

  assign BUTTON = {clock, reset_N, program_clock};
  assign SW = {mode, res_sel, io_in};

  CPU_shell sut_cpu_shell(
    .BUTTON(BUTTON),
    .SW(SW),
    .LEDG(LEDG),
    .HEX0_D(HEX0_D),
    .HEX0_DP(HEX0_DP),
    .HEX1_D(HEX1_D),
    .HEX1_DP(HEX1_DP),
    .HEX2_D(HEX2_D),
    .HEX2_DP(HEX2_DP),
    .HEX3_D(HEX3_D),
    .HEX3_DP(HEX3_DP));

  // clock generator
  initial begin
    BUTTON[2] = 0;
    forever #2 BUTTON[2] = !BUTTON[2];
  end
  
  // programming -> run
  initial begin
    mode = 1'b1;
    reset_N = 1'b1;
    res_sel = 2'b1;
    io_in = 8'h03;
    program_clock = 1'b1;
    #3;

    reset_N = 1'b0;
    #4;
    reset_N = 1'b1;
    #2;

    io_in = 8'h01; // IN
    #2
    program_clock = 1'b0;
    #2
    program_clock = 1'b1;
    #2

    io_in = 8'h04; // IN
    #2
    program_clock = 1'b0;
    #2
    program_clock = 1'b1;
    #2

    io_in = 8'hc0; // IN
    #2
    program_clock = 1'b0;
    #2
    program_clock = 1'b1;
    #2

    io_in = 8'h00; // IN
    #2
    program_clock = 1'b0;
    #2
    program_clock = 1'b1;
    #2

    mode = 1'b0;
    io_in = 8'haa;
    #10

    reset_N = 1'b0;
    #4;
    reset_N = 1'b1;
    #2;

  end
endmodule
  
