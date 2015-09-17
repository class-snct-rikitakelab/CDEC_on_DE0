# snipet definitions

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

initial_begin_snip = "initial begin\n"

initial_end_snip = "end\n"

# code

code = gets.chomp #"01 04 c0 00"

puts initial_begin_snip
puts program_mode_setting_snip
puts code.split.map { |instruction| instruction_write_snip.gsub(/_instruction_/, instruction) }.join
puts run_mode_setting_snip
puts initial_end_snip

