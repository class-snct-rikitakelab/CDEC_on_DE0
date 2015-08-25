`default_nettype none

module memory_programmer(
  input wire  clock_in,
  input wire  reset_N,

  input wire [7:0]  data_in,

  output wire       clock_out,
  output wire       wr_en_out,
  output wire [7:0] address_out,
  output wire [7:0] data_out
  );

  reg [7:0] address_counter;

  assign clock_out = clock_in;
  assign wr_en_out = reset_N;
  assign address_out = address_counter;
  assign data_out = data_in;


  always @(posedge clock_in or negedge reset_N) begin
    if (reset_N == 0) begin
      address_counter <= 8'h00;      
    end
    else begin
      address_counter <= address_counter + 1'b1;
    end
  end

endmodule
