`timescale 1ns / 1ps
`default_nettype none
`include "macro.v"
module Hazard_Unit(
	input wire clk, 
	
	input wire [`NumOfI:0] DIBus,
	input wire [`NumOfI:0] EIBus,
	input wire [`NumOfI:0] MIBus,
	
	input wire [4:0] D_rs, D_rt,
	
	input wire [4:0] E_rs, E_rt, E_WRA,
	input wire E_RegWrite,
	
	input wire [4:0] M_rt, M_WRA,
	input wire M_RegWrite,
	
	input wire [4:0] W_WRA,
	input wire W_RegWrite,
	
	output wire stall,
	output wire PassSrcRD1_D, PassSrcRD2_D,
	output wire [1:0] PassSrcA_E, PassSrcB_E,
	output wire PassSrc_M
    );
	//	Declaration
	reg [1:0] reg_TnewM;
	wire [1:0] TnewE, TnewM, Tuse_rs, Tuse_rt;
	wire stall_rs, stall_rs_E, stall_rs_M;
	wire stall_rt, stall_rt_E, stall_rt_M;
	//	Tnew...
	assign TnewE = (EIBus[`jr] || EIBus[`sw] || EIBus[`sb] ||
					EIBus[`beq] || EIBus[`j]) ? 0 :
					(EIBus[`addu] || EIBus[`subu] ||
					EIBus[`addi] || EIBus[`ori] || EIBus[`lui] || EIBus[`jalr] || EIBus[`jal]) ? 1 :
					(EIBus[`lw] || EIBus[`lb])  ? 2 : 0;
	//assign TnewM = (DIBus[`lw] || DIBus[`lb]) ? 1 : 0;
	assign TnewM = reg_TnewM;
	always @(posedge clk)	reg_TnewM = (TnewE == 0) ? 0 : (TnewE - 1);
	//	Tuse...
	assign Tuse_rs = (DIBus[`jr] || DIBus[`beq] || DIBus[`jalr]) ? 0 : 1;
	assign Tuse_rt = (DIBus[`beq]) ? 0 :
					 (DIBus[`addu] || DIBus[`subu]) ? 1 :
					 (DIBus[`sw] || DIBus[`sb]) ? 2 : 3;
	//	STALL
	assign stall_rs_E = (D_rs != 0) && (TnewE > Tuse_rs) && (D_rs == E_WRA && E_RegWrite == 1);
	assign stall_rs_M = (D_rs != 0) && (TnewM > Tuse_rs) && (D_rs == M_WRA && M_RegWrite == 1);
	assign stall_rt_E = (D_rt != 0) && (TnewE > Tuse_rt) && (D_rt == E_WRA && E_RegWrite == 1);
	assign stall_rt_M = (D_rt != 0) && (TnewM > Tuse_rt) && (D_rt == M_WRA && M_RegWrite == 1);
	assign stall_rs = stall_rs_E || stall_rs_M;
	assign stall_rt = stall_rt_E || stall_rt_M;
	assign stall = stall_rs || stall_rt;
	// PASSING
	assign PassSrcRD1_D = (D_rs != 0) && (M_RegWrite == 1) && (D_rs == M_WRA);
	assign PassSrcRD2_D = (D_rt != 0) && (M_RegWrite == 1) && (D_rt == M_WRA);
	assign PassSrcA_E = (E_rs != 0) && (M_RegWrite == 1) && (E_rs == M_WRA) ? 2'b01 :
						(E_rs != 0) && (W_RegWrite == 1) && (E_rs == W_WRA) ? 2'b10 : 2'b00;
	assign PassSrcB_E = (E_rt != 0) && (M_RegWrite == 1) && (E_rt == M_WRA) ? 2'b01 :
						(E_rt != 0) && (W_RegWrite == 1) && (E_rt == W_WRA) ? 2'b10 : 2'b00;
	assign PassSrc_M = (M_rt != 0) && (W_RegWrite == 1) && (M_rt == W_WRA) ? 1 : 0;
	

endmodule
