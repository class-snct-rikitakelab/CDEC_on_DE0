`default_nettype none

module ram(
	  input	wire [7:0] adrs,
    input	wire [7:0] data,
    output wire [7:0] q,

    input wire clock,
    input wire wr_en
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

	// for testbench
	integer i;
	initial begin
		ram[8'h00] = 8'h81; // LD THREE, A
		ram[8'h01] = 8'h07;
		ram[8'h02] = 8'h06; // MOV A, B
		ram[8'h03] = 8'h22; // ADD B
		ram[8'h04] = 8'h41; // INC A
		ram[8'h05] = 8'hc0; // JMP 05
		ram[8'h06] = 8'h05;
		ram[8'h07] = 8'h03; // Label: THREE
		for(i=8; i<256; i=i+1)
			ram[i] = 8'h00;
	end
endmodule