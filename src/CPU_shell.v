/* CPU_shell.v  = = = = = = = = = = = = = = = = = = = = = = = = = = = = *****
 **    CDEC8 and test bench / FPGA interface module          ****
 ***       Ver. 1.0 2014.05.30                        ***
 ****                                      **
 ***** (C) 2014 kimsyn (ET & VLSI system design labo. GCT ICE)  = = = = = = */

module CPU_shell(
  input wire  [2:0] BUTTON,// push buttons: {clock, reset_N, p_clock}
  input wire  [9:0] SW,// slide switches: {mode, select_sw, io_in}
  output wire [9:0] LEDG,// LED Green: {clocklevel, endseq, io_out}
  output wire [6:0] HEX0_D,// 7seg digit 0
  output wire       HEX0_DP,// 7seg dp 0
  output wire [6:0] HEX1_D,// 7seg digit 1
  output wire       HEX1_DP,// 7seg dp 1
  output wire [6:0] HEX2_D,// 7seg digit 2
  output wire       HEX2_DP,// 7seg dp 2
  output wire [6:0] HEX3_D,// 7seg digit 3
  output wire       HEX3_DP// 7seg dp 3
  );

  wire clock;   // clock
  wire reset_N; // reset (active low)
  wire p_clock; // clock signal for programming

  wire [1:0]  select_sw;  // resource selector for debug monitor
  wire [7:0]  io_in;      // INPUT PORT (8-bit SW)

  wire clocklevel;        // clock level
  wire endseq;            // end seqence    
  wire [7:0] io_out;      // OUTPUT PORT (8-bit LED)

  wire [7:0] ssled3;
  wire [7:0] ssled2;
  wire [7:0] ssled1;
  wire [7:0] ssled0;

  assign clock    = BUTTON[2];
  assign reset_N  = BUTTON[1];
  assign p_clock  = BUTTON[0];

  assign {select_sw, io_in} = SW;

  assign LEDG = {clocklevel, endseq, io_out};

  assign {HEX0_DP, HEX0_D} = ssled0;
  assign {HEX1_DP, HEX1_D} = ssled1;
  assign {HEX2_DP, HEX2_D} = ssled2;
  assign {HEX3_DP, HEX3_D} = ssled3;

  // program/run mode selector
  // mode == 1 => program mode
  // mode == 0 => run mode
  wire  mode;

  // memory_programmer -> memory
  wire [7:0]  prog_adrs;
  wire [7:0]  prog_data;
  wire        prog_clock;
  wire        prog_wr_en;

  // CDEC8 <-> memory
  wire [7:0]  data_in;
  wire [7:0]  data_out;
  wire [7:0]  adrs;
  wire        mmwr_en;

  // debug
  wire        ressel;
  wire [7:0]  resad;
  wire [7:0]  resdt;

  //
  assign {mode, ressel} = select_sw;

  // 
  sseg_dec  sseg3(.en(mode), .data(mode ? prog_adrs[7:4] : 4'h0), .led(ssled3));
  sseg_dec  sseg2(.en(mode), .data(mode ? prog_adrs[3:0] : 4'h0), .led(ssled2));
  sseg_dec  sseg1(.en(1'b1), .data(mode ? prog_data[7:4] : resdt[7:4]), .led(ssled1));
  sseg_dec  sseg0(.en(1'b1), .data(mode ? prog_data[3:0] : resdt[3:0]), .led(ssled0));

  // memory programmer
  memory_programmer programmer(.clock_in(p_clock), .reset_N(reset_N),
    .data_in(io_in), .clock_out(prog_clock), .wr_en_out(prog_wr_en),
    .address_out(prog_adrs), .data_out(prog_data));

  // -- debug monitor ---
  // clock level
  assign clocklevel = clock;
  // convert ressel to resad
  assign resad = resource_select(ressel);

  function [7:0] resource_select;
    input sel;
    begin
      case (sel)
        2'b0 : resource_select = 8'h00; // PC
        2'b1 : resource_select = 8'h01; // I
      endcase
    end
  endfunction

  //-- CPU core instantiation and bus connection

  CDEC8 CDEC8( clock, reset_N,
    io_in, io_out,
    adrs[7:0], data_in[7:0], data_out[7:0], mmwr_en,
    endseq, resad, resdt);

  //-- memory/io signal connection
  memory ram(
    .adrs(mode ? prog_adrs : adrs), 
    .data(mode ? prog_data : data_out), 
    .q(data_in), 
    .clock(mode ? prog_clock : clock),
    .wr_en(mode ? prog_wr_en : mmwr_en));

endmodule
