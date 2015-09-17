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
  reg       sel;
  reg [7:0] io_in;

  assign BUTTON = {clock, reset_N, program_clock};
  assign SW = {mode, sel, io_in};

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
    clock = 0;
    forever #2 clock = !clock;
  end

  // programming -> run
  initial begin

    // program mode setting
    mode = 1'b1;
    sel = 1'b1;
    reset_N = 1'b1;
    io_in = 8'h00;
    program_clock = 1'b1;
    #3;
    reset_N = 1'b0;
    #4;
    reset_N = 1'b1;
    #2;


    // instruction: 81
    io_in = 8'h81;
    #2
    program_clock = 1'b0;
    #2
    program_clock = 1'b1;
    #2


    // instruction: 10
    io_in = 8'h10;
    #2
    program_clock = 1'b0;
    #2
    program_clock = 1'b1;
    #2


    // instruction: 06
    io_in = 8'h06;
    #2
    program_clock = 1'b0;
    #2
    program_clock = 1'b1;
    #2


    // instruction: 46
    io_in = 8'h46;
    #2
    program_clock = 1'b0;
    #2
    program_clock = 1'b1;
    #2


    // instruction: DA
    io_in = 8'hDA;
    #2
    program_clock = 1'b0;
    #2
    program_clock = 1'b1;
    #2


    // instruction: 0A
    io_in = 8'h0A;
    #2
    program_clock = 1'b0;
    #2
    program_clock = 1'b1;
    #2


    // instruction: 22
    io_in = 8'h22;
    #2
    program_clock = 1'b0;
    #2
    program_clock = 1'b1;
    #2


    // instruction: 46
    io_in = 8'h46;
    #2
    program_clock = 1'b0;
    #2
    program_clock = 1'b1;
    #2


    // instruction: C0
    io_in = 8'hC0;
    #2
    program_clock = 1'b0;
    #2
    program_clock = 1'b1;
    #2


    // instruction: 04
    io_in = 8'h04;
    #2
    program_clock = 1'b0;
    #2
    program_clock = 1'b1;
    #2


    // instruction: 04
    io_in = 8'h04;
    #2
    program_clock = 1'b0;
    #2
    program_clock = 1'b1;
    #2


    // instruction: A4
    io_in = 8'hA4;
    #2
    program_clock = 1'b0;
    #2
    program_clock = 1'b1;
    #2


    // instruction: 11
    io_in = 8'h11;
    #2
    program_clock = 1'b0;
    #2
    program_clock = 1'b1;
    #2


    // instruction: C0
    io_in = 8'hC0;
    #2
    program_clock = 1'b0;
    #2
    program_clock = 1'b1;
    #2


    // instruction: 0D
    io_in = 8'h0D;
    #2
    program_clock = 1'b0;
    #2
    program_clock = 1'b1;
    #2


    // instruction: FE
    io_in = 8'hFE;
    #2
    program_clock = 1'b0;
    #2
    program_clock = 1'b1;
    #2


    // instruction: 05
    io_in = 8'h05;
    #2
    program_clock = 1'b0;
    #2
    program_clock = 1'b1;
    #2


    // instruction: 00
    io_in = 8'h00;
    #2
    program_clock = 1'b0;
    #2
    program_clock = 1'b1;
    #2


    // instruction: FE
    io_in = 8'hFE;
    #2
    program_clock = 1'b0;
    #2
    program_clock = 1'b1;
    #2


    // run mode setting
    mode = 1'b0;
    #10
    reset_N = 1'b0;
    #6;
    reset_N = 1'b1;
    #2;

  end

endmodule