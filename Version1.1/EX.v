`timescale 1ns / 1ps
`default_nettype none
`include "macro.v"
module EX(
	input wire clk,
	input wire [31:0] E_instruc,
	input wire [31:0] E_PC,
	input wire [31:0] E_RD1,
	input wire [31:0] E_RD2,
	input wire [4:0]  E_WRA,
	input wire [31:0] E_Ext,
	input wire [31:0] E_M_Pass,
	input wire [31:0] E_W_WRD,
	input wire [1:0] PassSrcA,
	input wire [1:0] PassSrcB,
	
	output reg [31:0] EM_instruc,
	output reg [31:0] EM_AluRe,
	output reg [31:0] EM_WTDM,
	output reg [4:0]  EM_WRA,
	output reg [31:0] EM_PC,
	
	output wire [4:0] E_rs,
	output wire [4:0] E_rt
    );
	//	Declaration
	wire [1:0] AluCtrl;
	wire [31:0] AluResult;
	wire AluSrc;
	wire [31:0] A, B;
	//	Controller
	Controller Con_E(.instruc(E_instruc),
					 .AluCtrl(AluCtrl),
					 .AluSrc(AluSrc));
	//
	assign E_rs = E_instruc[`rs];
	assign E_rt = E_instruc[`rt];
	assign A = (PassSrcA == 2'b00) ? E_RD1 :
			   (PassSrcA == 2'b01) ? E_M_Pass :
			   (PassSrcA == 2'b10) ? E_W_WRD : 0;
	assign B = (AluSrc == 1) ? E_Ext :
			   (PassSrcB == 2'b00) ? E_RD2 :
			   (PassSrcB == 2'b01) ? E_M_Pass :
			   (PassSrcB == 2'b10) ? E_W_WRD : 0;
	assign AluResult = (AluCtrl == 2'b00) ? A + B :
					   (AluCtrl == 2'b01) ? A - B :
					   (AluCtrl == 2'b10) ? A | B :
					   (AluCtrl == 2'b11) ? {B[15:0], 16'b0} : 0;
	
	always @(posedge clk)begin
		EM_instruc <= E_instruc;
		EM_AluRe <= AluResult;
		EM_WTDM <= (PassSrcB == 2'b00) ? E_RD2 :
				   (PassSrcB == 2'b01) ? E_M_Pass :
				   (PassSrcB == 2'b10) ? E_W_WRD : 0;
		EM_WRA <= E_WRA;
		EM_PC <= E_PC;
	end
	//////////////	Initial
	initial begin
		EM_instruc <= 0;
		EM_AluRe <= 0;
		EM_WTDM <= 0;
		EM_WRA <= 0;
		EM_PC <= 0;
	end
	
endmodule
