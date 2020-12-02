`timescale 1ns / 1ps
`default_nettype none
`include "macro.v"
module WB(
	input wire [31:0] W_instruc,
	input wire [31:0] W_PC,
	input wire [31:0] W_DM,
	input wire [31:0] W_AluRe,
	input wire [4:0] W_WRA,
	
	output wire [4:0] WD_WRA,
	output wire [31:0] WD_WRD,
	output wire WD_RegWrite,
	output wire [31:0] WD_PCWhenWrite
    );
	//	Declaration
	wire [1:0] MemtoReg;
	wire [31:0] ByteExt;
	wire BExtOp;
	//	Controller
	Controller Con_W(.instruc(W_instruc),
					 .BExtOp(BExtOp),
					 .MemtoReg(MemtoReg));
	//
	assign ByteExt = (BExtOp == 0) ? {24'b0, W_DM[7:0]} : {{24{W_DM[7]}}, W_DM[7:0]};
	assign WD_WRA = W_WRA;
	assign WD_WRD = (MemtoReg == 2'b00) ? W_DM : 
					(MemtoReg == 2'b01) ? W_AluRe :
					(MemtoReg == 2'b10) ? ByteExt :
					(MemtoReg == 2'b11) ? (W_PC + 8) : 0;
	assign WD_PCWhenWrite = W_PC;

endmodule
