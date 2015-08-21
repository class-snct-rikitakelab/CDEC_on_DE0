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

	// testbench 1 (simple case)
	// integer i;
	// initial begin
	// 	ram[8'h00] = 8'h81; // LD THREE, A
	// 	ram[8'h01] = 8'h07;
	// 	ram[8'h02] = 8'h06; // MOV A, B
	// 	ram[8'h03] = 8'h22; // ADD B
	// 	ram[8'h04] = 8'h41; // INC A
	// 	ram[8'h05] = 8'hc0; // JMP 05
	// 	ram[8'h06] = 8'h05;
	// 	ram[8'h07] = 8'h03; // Label: THREE
	// 	for(i=8; i<256; i=i+1)
	// 		ram[i] = 8'h00;
	// end

	// testbench 2 (memory access)
	integer i;
	initial begin
		ram[8'h00] = 8'h81; // 				LD THREE, A
		ram[8'h01] = 8'h08; //
		ram[8'h02] = 8'ha4; // 				ST A, RSLT
		ram[8'h03] = 8'h09; // 
		ram[8'h04] = 8'h83; // 				LD RSLT, C
		ram[8'h05] = 8'h09; // 
		ram[8'h06] = 8'hc0; // STOP		JMP STOP
		ram[8'h07] = 8'h06; //
		ram[8'h08] = 8'h03; // THREE 	DB 0x03
		ram[8'h09] = 8'h00; // RSLT		DB 0x00
		for(i=10; i<256; i=i+1)
			ram[i] = 8'h00;
	end

endmodule