`default_nettype none

module memory(
  input	wire [7:0] adrs,
  input	wire [7:0] data,
  output wire [7:0] q,

  input wire clock,
  input wire wr_en
  );

  reg [7:0] ram[255:0];

  assign q = ram[adrs];

  always @(negedge clock) begin
    if (wr_en) begin
      ram[adrs] <= data;
    end
  end
endmodule