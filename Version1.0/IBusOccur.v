`timescale 1ns / 1ps
`default_nettype none
`include "macro.v"
module IBusOccur(
	input wire [31:0] instruc,
	output wire [`NumOfI:0] IBus
    );
		//	R
	assign IBus[`addu] = (instruc[`OpCode] == 6'b000000) && (instruc[`Func] == 6'b100001);
	assign IBus[`subu] = (instruc[`OpCode] == 6'b000000) && (instruc[`Func] == 6'b100011);
	assign IBus[`jr]   = (instruc[`OpCode] == 6'b000000) && (instruc[`Func] == 6'b001000);
	assign IBus[`jalr] = (instruc[`OpCode] == 6'b000000) && (instruc[`Func] == 6'b001001);
		//	I
	assign IBus[`addi] = (instruc[`OpCode] == 6'b001000);
	assign IBus[`ori] = (instruc[`OpCode] == 6'b001101);
	assign IBus[`lui] = (instruc[`OpCode] == 6'b001111);
	assign IBus[`lw]  = (instruc[`OpCode] == 6'b100011);
	assign IBus[`lb]  = (instruc[`OpCode] == 6'b100000);
	assign IBus[`sw]  = (instruc[`OpCode] == 6'b101011);
	assign IBus[`sb]  = (instruc[`OpCode] == 6'b101000);
	assign IBus[`beq] = (instruc[`OpCode] == 6'b000100);
		// 	J
	assign IBus[`jal] = (instruc[`OpCode] == 6'b000011);
	assign IBus[`j]   = (instruc[`OpCode] == 6'b000010);


endmodule
