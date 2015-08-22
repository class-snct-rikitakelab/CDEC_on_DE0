`default_nettype none

module sseg_dec(
	input wire [3:0]  data,
	output wire [7:0] led
	);

	assign led = ~dec(data);

	function [7:0] dec;
		input [3:0] data_in;
		begin
			case(data_in)
				4'h0 : dec = 8'b00111111;
				4'h1 : dec = 8'b00000110;
				4'h2 : dec = 8'b01011011;
				4'h3 : dec = 8'b01001111;
				4'h4 : dec = 8'b01100110;
				4'h5 : dec = 8'b01101101;
				4'h6 : dec = 8'b01111101;
				4'h7 : dec = 8'b00100111;
				4'h8 : dec = 8'b01111111;
				4'h9 : dec = 8'b01101111;
				4'ha : dec = 8'b01110111;
				4'hb : dec = 8'b01111100;
				4'hc : dec = 8'b01011000;
				4'hd : dec = 8'b01011110;
			endcase
		end
	endfunction
endmodule