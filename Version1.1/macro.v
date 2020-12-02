`timescale 1ns / 1ps
`define OpCode 	31:26
`define rs		25:21
`define rt		20:16
`define rd		15:11
`define Shamt	10: 6
`define Func	 5: 0
`define Imm16	15: 0
`define Imm26	25: 0

`define NumOfI	15

`define addu	0
`define subu	1
`define jr		2
`define lui		3
`define ori		4
`define beq		5
`define lw		6
`define sw		7
`define j		8
`define jal		9
`define lb		10
`define sb		11
`define nop		12
`define jalr	13
`define addi	14