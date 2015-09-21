`default_nettype none

module clock_5Hz_generator(
  input wire input_clock,
  output reg output_clock
  );

  reg [22:0] count;

  always @(posedge input_clock) begin
    if (count >= 23'd5000000) begin
      count <= 23'b0;
      output_clock <= ~output_clock;
    end else begin
      count <= count + 1'b1;
    end
  end

endmodule

module clock_1kHz_generator(
  input wire input_clock,
  output reg output_clock
  );

  reg [14:0] count;

  always @(posedge input_clock) begin
    if (count >= 15'd25000) begin
      count <= 15'b0;
      output_clock <= ~output_clock;
    end else begin
      count <= count + 1'b1;
    end
  end

endmodule