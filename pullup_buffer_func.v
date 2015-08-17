function [7:0] pullup_buffer_func;
	input en;

	pullup_buffer_func = (en)? 8'hff : 8'hzz;
endfunction