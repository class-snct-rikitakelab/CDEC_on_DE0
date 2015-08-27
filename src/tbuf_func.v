/* tbuf_func.v = = = = = = = = = = = = = = = = = = = = = = = = = = = = =*****
 **    3 state buffer							 ****
 ***       Ver. 1.0  2014.05.29						  ***
 ****									   **
 ***** (C) 2014 kimsyn (ET & VLSI system design labo. GCT ICE)  = = = = = = */


function [7:0] TBUF8_func;
	input	en;
	input	[7:0] data;

	TBUF8_func = (en)? data : 8'hzz;
endfunction
