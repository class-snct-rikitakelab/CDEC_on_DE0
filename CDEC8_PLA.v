// CDEC8_PLA .v(2014-10-30)
/* CDEC8_PLA.v  = = = = = = = = = = = = = = = = = = = = = = = = = = = = *****
 **    CDEC8 PLA control part module					 ****
 ***       Ver. 1.0  2014.05.30						  ***
 ****									   **
 ***** (C) 2014 kimsyn (ET & VLSI system design labo. GCT ICE)  = = = = = = */

/* generated by pla2verilog using next files
    format file : CDEC8_PLA_format.pclf
    RTL    file : CDEC8_PLA.rtl.
    header file : CDEC8_PLA_hdr.v
    footer file : CDEC8_PLA_ftr.v
*/

module CDEC8_PLA_ctrl(
    input  wire	       clock,
    input  wire	       reset_N,
    input  wire [ 7:0] I,
    input  wire [ 2:0] SZCy,
    
    output wire [14:0] ctrl,
    
    output wire        mmrd_N,
    output wire        mmwr_N,
    output wire        mm_dboe,

    input  wire [ 7:0] resad,
    output wire [ 7:0] resdt
    );
    
    wire   [ 1:0] mmrw;
    wire 	  endseq;
    reg	   [ 3:0] state;

  //-- PLA function

    function [15:0] PLA;
        input [3:0] state;
        input [7:0] instruction;
        input [2:0] flag;

        begin
            casex({ state, instruction, flag})
                15'b0000_XXXXXXXX_XXX : PLA = 16'b0_00_0_1_100_01110_000;
                15'b0001_XXXXXXXX_XXX : PLA = 16'b0_10_0_0_000_00000_100;
                15'b0010_XXXXXXXX_XXX : PLA = 16'b0_00_0_0_111_00000_101;
                15'b0011_00000101_XXX : PLA = 16'b1_00_0_0_001_00000_001;
                15'b0011_00000110_XXX : PLA = 16'b1_00_0_0_010_00000_001;
                15'b0011_00000111_XXX : PLA = 16'b1_00_0_0_011_00000_001;
                15'b0011_00001001_XXX : PLA = 16'b1_00_0_0_001_00000_010;
                15'b0011_00001010_XXX : PLA = 16'b1_00_0_0_010_00000_010;
                15'b0011_00001011_XXX : PLA = 16'b1_00_0_0_011_00000_010;
                15'b0011_00001101_XXX : PLA = 16'b1_00_0_0_001_00000_011;
                15'b0011_00001110_XXX : PLA = 16'b1_00_0_0_010_00000_011;
                15'b0011_00001111_XXX : PLA = 16'b1_00_0_0_011_00000_011;
                15'b0011_100000XX_XXX : PLA = 16'b0_00_0_1_100_01110_000;
                15'b0100_100000XX_XXX : PLA = 16'b0_10_0_0_000_00000_100;
                15'b0101_100000XX_XXX : PLA = 16'b0_00_0_0_100_00000_101;
                15'b0110_100000XX_XXX : PLA = 16'b0_10_0_0_000_00000_000;
                15'b0111_10000001_XXX : PLA = 16'b1_00_0_0_001_00000_101;
                15'b0111_10000010_XXX : PLA = 16'b1_00_0_0_010_00000_101;
                15'b0111_10000011_XXX : PLA = 16'b1_00_0_0_011_00000_101;
                15'b0011_1010XX00_XXX : PLA = 16'b0_00_0_1_100_01110_000;
                15'b0100_1010XX00_XXX : PLA = 16'b0_10_0_0_000_00000_100;
                15'b0101_1010XX00_XXX : PLA = 16'b0_00_0_0_100_00000_101;
                15'b0110_10100100_XXX : PLA = 16'b0_00_0_0_101_00000_001;
                15'b0110_10101000_XXX : PLA = 16'b0_00_0_0_101_00000_010;
                15'b0110_10101100_XXX : PLA = 16'b0_00_0_0_101_00000_011;
                15'b0111_1010XX00_XXX : PLA = 16'b1_01_0_0_000_00000_000;
                15'b0011_001XXX01_XXX : PLA = 16'b0_00_0_0_110_00000_001;
                15'b0011_001XXX10_XXX : PLA = 16'b0_00_0_0_110_00000_010;
                15'b0011_001XXX11_XXX : PLA = 16'b0_00_0_0_110_00000_011;
                15'b0100_001000XX_XXX : PLA = 16'b0_00_1_1_101_01000_001;
                15'b0100_001001XX_XXX : PLA = 16'b0_00_1_1_101_01010_001;
                15'b0100_001010XX_XXX : PLA = 16'b0_00_1_1_101_01011_001;
                15'b0100_001011XX_XXX : PLA = 16'b0_00_1_1_101_01101_001;
                15'b0100_001100XX_XXX : PLA = 16'b0_00_1_1_101_10000_001;
                15'b0100_001101XX_XXX : PLA = 16'b0_00_1_1_101_10001_001;
                15'b0100_001111XX_XXX : PLA = 16'b0_00_1_1_101_10010_001;
                15'b0101_001XXXXX_XXX : PLA = 16'b1_00_0_0_001_00000_100;
                15'b0011_01000001_XXX : PLA = 16'b0_00_1_1_110_01110_001;
                15'b0011_01000010_XXX : PLA = 16'b0_00_1_1_110_01110_010;
                15'b0011_01000011_XXX : PLA = 16'b0_00_1_1_110_01110_011;
                15'b0011_01000101_XXX : PLA = 16'b0_00_1_1_110_01111_001;
                15'b0011_01000110_XXX : PLA = 16'b0_00_1_1_110_01111_010;
                15'b0011_01000111_XXX : PLA = 16'b0_00_1_1_110_01111_011;
                15'b0011_01010001_XXX : PLA = 16'b0_00_1_1_110_10011_001;
                15'b0011_01010010_XXX : PLA = 16'b0_00_1_1_110_10011_010;
                15'b0011_01010011_XXX : PLA = 16'b0_00_1_1_110_10011_011;
                15'b0100_010XXX01_XXX : PLA = 16'b1_00_0_0_001_00000_100;
                15'b0100_010XXX10_XXX : PLA = 16'b1_00_0_0_010_00000_100;
                15'b0100_010XXX11_XXX : PLA = 16'b1_00_0_0_011_00000_100;
                15'b0011_11000000_XXX : PLA = 16'b0_00_0_0_100_00000_000;
                15'b0100_11000000_XXX : PLA = 16'b0_10_0_0_000_00000_000;
                15'b0101_11000000_XXX : PLA = 16'b1_00_0_0_000_00000_101;
                15'b0011_11011XXX_XXX : PLA = 16'b0_00_0_1_100_01110_000;
                15'b0100_11011100_0XX : PLA = 16'b1_00_0_0_000_00000_100;
                15'b0100_11011100_1XX : PLA = 16'b0_10_0_0_000_00000_000;
                15'b0100_11011010_X0X : PLA = 16'b1_00_0_0_000_00000_100;
                15'b0100_11011010_X1X : PLA = 16'b0_10_0_0_000_00000_000;
                15'b0100_11011001_XX0 : PLA = 16'b1_00_0_0_000_00000_100;
                15'b0100_11011001_XX1 : PLA = 16'b0_10_0_0_000_00000_000;
                15'b0101_11011XXX_XXX : PLA = 16'b1_00_0_0_000_00000_101;
                15'b0011_00000000_XXX : PLA = 16'b0_00_0_0_000_00000_000;
                15'b0011_11111111_XXX : PLA = 16'b0_00_0_1_000_01111_000;
                15'b0100_11111111_XXX : PLA = 16'b1_00_0_0_000_00000_100;
                15'b0011_11101000_XXX : PLA = 16'b1_00_0_0_000_00100_000;
                15'b0011_11101001_XXX : PLA = 16'b1_00_0_0_000_00101_000;
                15'b0011_11101010_XXX : PLA = 16'b1_00_0_0_000_00110_000;
                default : PLA = 16'bXXXXXXXXXXXXXXXX;
            endcase
        end
    endfunction

  //-- internal hardware resource singnal observation bus for debug monitor
    assign resdt    = (resad   ==8'h0B)? {endseq, 3'b000, state}: 8'hZZ;

  //-- PLA 
    assign {endseq, ctrl} = PLA(state, I, SZCy);

  //-- state counter
    always @(posedge clock or negedge reset_N) begin
    	if(~reset_N) begin
    	    state <= 4'b0000;
    	end else begin
    	    state <= (endseq) ? 4'b0000 : state + 1;
    	end
    end
    
  //-- memory access control signals
    assign mmrw     = ctrl[14:13];
    assign mmrd_N   = ~(mmrw == 2'b10   );	// memory read (active low)
    assign mm_dboe  =  (mmrw == 2'b01   );	// memory data bus output enable
    assign mmwr_N   = ~(mm_dboe & ~clock);	// memory write (active low)

endmodule

