# snipet definitions

head_snip =
%Q{
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

}

initial_begin_snip =
%Q{
  initial begin
}

program_mode_setting_snip =
%Q{
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
}

instruction_write_snip =
%Q{
    // instruction: _instruction_
    io_in = 8'h_instruction_;
    #2
    program_clock = 1'b0;
    #2
    program_clock = 1'b1;
    #2
}

run_mode_setting_snip =
%Q{
    // run mode setting
    mode = 1'b0;
    #10
    reset_N = 1'b0;
    #6;
    reset_N = 1'b1;
    #2;
}

initial_end_snip =
%Q{
  end
}

tail_snip =
%Q{
endmodule
}


# code

code = gets.chomp #"01 04 c0 00"
puts head_snip
puts initial_begin_snip
puts program_mode_setting_snip
puts code.split.map { |instruction| instruction_write_snip.gsub(/_instruction_/, instruction) }.join
puts run_mode_setting_snip
puts initial_end_snip
puts tail_snip
