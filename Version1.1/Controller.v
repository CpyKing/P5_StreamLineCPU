`timescale 1ns / 1ps
`default_nettype none
`include "macro.v"
module Controller(
	input wire [31:0] instruc,
	
	output wire [`NumOfI:0] IBus,
	output wire isBranch,
	output wire immJump,
	output wire regJump,
	output wire [1:0] RegDst,
	output wire ExtOp,
	output wire [1:0] AluCtrl,
	output wire AluSrc,
	output wire MemWrite,
	output wire isByte,
	output wire [1:0] MemtoReg,
	output wire BExtOp,
	output wire PassAPC
    );
	
	reg addu, subu, jr, jalr,
		 ori, lui, lw, sw, lb, sb, beq, addi,
		 j, jal, nop;
	wire [5:0] OpCode = instruc[`OpCode];
	wire [5:0] Func   = instruc[`Func];
	
	// Bus Occur
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
		 
	always @(*) begin
		//	R
		addu = (OpCode == 6'b000000) && (Func == 6'b100001);
		subu = (OpCode == 6'b000000) && (Func == 6'b100011);
		jr   = (OpCode == 6'b000000) && (Func == 6'b001000);
		jalr = (OpCode == 6'b000000) && (Func == 6'b001001);
		//	I
		addi = (OpCode == 6'b001000);
		ori = (OpCode == 6'b001101);
		lui = (OpCode == 6'b001111);
		lw  = (OpCode == 6'b100011);
		lb  = (OpCode == 6'b100000);
		sw  = (OpCode == 6'b101011);
		sb  = (OpCode == 6'b101000);
		beq = (OpCode == 6'b000100);
		// 	J
		jal = (OpCode == 6'b000011);
		j   = (OpCode == 6'b000010);		
	end
	
	assign isBranch = beq;
	assign immJump = jal || j;
	assign regJump = jr || jalr;
	assign RegDst = {addu || subu || jalr || jal, addi || ori || lui || lw || lb || jal};
	assign ExtOp = lw || lb || sw || sb || beq || addi;// 0-zero_ext, 1-sign_ext
	assign AluCtrl = {ori || lui, subu || lui};//00-'+', 01-'-', 10-'|', 11-'load high'
	assign AluSrc =  ori || lb || lw || sw || sb || lui || addi;
	assign MemWrite = sb || sw;
	assign isByte = lb || sb;
	assign MemtoReg = {jal || jalr, jalr || jal || addu || subu || ori || lui || addi};
	assign BExtOp = lb;
	assign PassAPC = jal || jalr;
	
endmodule
