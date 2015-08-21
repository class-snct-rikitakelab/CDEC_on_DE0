`default_nettype none

module rom(
	  input	wire [7:0] adrs,
    input	wire [7:0] data,
    output wire [7:0] q,

    input wire clock,
    input wire wr_en
    );

	assign q = simple_program(adrs);

	function [7:0] simple_program;
		input [7:0] ad;
		begin
      case(ad)
	      8'h00 : simple_program = 8'h81;
	      8'h01 : simple_program = 8'h07;
	      8'h02 : simple_program = 8'h06;
	      8'h03 : simple_program = 8'h22;
	      8'h04 : simple_program = 8'h41;
	      8'h05 : simple_program = 8'hc0;
	      8'h06 : simple_program = 8'h05;
	      8'h07 : simple_program = 8'h03;
	      default : simple_program = 8'h00;
      endcase            
    end
  endfunction

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

endmodule