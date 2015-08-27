`default_nettype none

module rom(
	  input	wire [7:0] adrs,
    input	wire [7:0] data,
    output wire [7:0] q,

    input wire clock,
    input wire wr_en
    );

	//assign q = simple_program(adrs);
	//assign q = io_program(adrs);
	assign q = sigma_program(adrs);

	function [7:0] simple_program;
		input [7:0] ad;
		begin
      case(ad)
	      8'h00 : simple_program = 8'h81; // LD 07
	      8'h01 : simple_program = 8'h07;  
	      8'h02 : simple_program = 8'h06; // MOV A, B
	      8'h03 : simple_program = 8'h22; // ADD B
	      8'h04 : simple_program = 8'h41; // INC A
	      8'h05 : simple_program = 8'hc0; // JMP 05
	      8'h06 : simple_program = 8'h05;
	      8'h07 : simple_program = 8'h03; // DB 03
	      default : simple_program = 8'h00;
      endcase            
    end
  endfunction

	function [7:0] io_program;
		input [7:0] ad;
		begin
      case(ad)
	      8'h00 : io_program = 8'h01; // IN
	      8'h01 : io_program = 8'h04; // OUT
	      8'h02 : io_program = 8'hc0; // JMP 00
	      8'h03 : io_program = 8'h00; //
	      default : io_program = 8'h00;
      endcase            
    end
  endfunction

	function [7:0] sigma_program;
		input [7:0] ad;
		begin
      case(ad)
	      8'h00 : sigma_program = 8'h01; // IN
	      8'h01 : sigma_program = 8'h06; // MOV A, B
	      8'h02 : sigma_program = 8'h46; // DEC B
	      8'h03 : sigma_program = 8'hda; // JZ 09
	      8'h04 : sigma_program = 8'h09; // 
	      8'h05 : sigma_program = 8'h22; // ADD B
	      8'h06 : sigma_program = 8'h46; // DEC B
	      8'h07 : sigma_program = 8'hc0; // JMP 03
	      8'h08 : sigma_program = 8'h03; // 
	      8'h09 : sigma_program = 8'h04; // OUT
	      8'h0a : sigma_program = 8'hc0; // JMP 00
	      8'h0b : sigma_program = 8'h00; //     
	      default : sigma_program = 8'h00;
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