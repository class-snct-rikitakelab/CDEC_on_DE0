module ram(
	  input	 [7:0] adrs,
    input	 [7:0] data,
    output [7:0] q,

    input clock,
    input wr_en
    );

	reg [7:0] ram[255:0];

	reg [7:0] adrs_reg;

	always @(negedge clock) begin
		if (wr_en) begin
			ram[adrs] <= data;
		end
		adrs_reg <= adrs;
	end

	assign q = ram[adrs_reg];

endmodule