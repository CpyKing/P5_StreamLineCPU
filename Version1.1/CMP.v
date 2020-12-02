`timescale 1ns / 1ps
`default_nettype none
`include "macro.v"
module CMP(
	input wire [`NumOfI:0] IBus,
	input wire [31:0] A, B,
	output  wire cmpTrue
    );
	reg reg_cmpTrue;
	assign cmpTrue = reg_cmpTrue;
	always @(*)begin
		case(1'b1)
			IBus[`beq]: begin
				if(A == B)
					reg_cmpTrue = 1;
				else
					reg_cmpTrue = 0;
			end
			default:
				reg_cmpTrue = 0;
		endcase
	end
endmodule
