`timescale 10ns / 1ps
`default_nettype none

module memory_programmer_sim;
  reg       clock_in;
  reg       reset_N;
  reg [7:0] data_in;

  wire        clock_out;
  wire        wr_en_out;
  wire [7:0]  address_out;
  wire [7:0]  data_out;

  wire [7:0]  q;

  memory_programmer sut_memory_programmer(
    .clock_in(clock_in),
    .reset_N(reset_N),
    .data_in(data_in),
    .clock_out(clock_out),
    .wr_en_out(wr_en_out),
    .address_out(address_out),
    .data_out(data_out));

  ram ram(.adrs(address_out), .data(data_out), .q(q), 
    .clock(clock_in), .wr_en(wr_en_out));


  initial begin
    clock_in = 0;
    forever #2 clock_in = !clock_in;
  end

  initial begin
    reset_N = 1;
    data_in = 8'h11;
    #3;
    reset_N = 0;
    #4;
    reset_N = 1;
    #10;
    data_in = 8'haa;
    #10;
    data_in = 8'hff;
  end
endmodule