`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company:       California State University San Bernardino
// Engineer:		Bogdan Kravtsov
//                Tyler Clayton
//
// Create Date:   11:12:18 10/17/2016
// Module Name:   I_DECODE
// Project Name:  MIPS
// Description:   The MIPS ID (DECODE) pipeline stage.
//
// Dependencies:  CONTROL.v, REG.v, S_EXTEND.v, ID_EX.v
//
////////////////////////////////////////////////////////////////////////////////

module I_DECODE(
	input         clk, RegWrite,
	input  [31:0] IF_ID_instr, IF_ID_NPC, 
	input  [4:0]  MEM_WB_Writereg,
   input  [31:0] MEM_WB_Writedata,
	output [1:0]  WB,
	output [2:0]  M,
	output [3:0]  EX,
	output [31:0] NPC,
	output [31:0] rdata1out,
	output [31:0] rdata2out,
	output [31:0] IR,
	output [4:0]  instrout_2016,
	output [4:0]  instrout_1511);
	
	// Wires
	wire [1:0]  CTL_WB;
	wire [2:0]  CTL_M;
	wire [3:0]  CTL_EX;
	wire [31:0] REG_A;
	wire [31:0] REG_B; 
	wire [31:0] EXT_OUT;
	
	// Instantiate modules		
	// CONTROL
	CONTROL ctl(.opcode(IF_ID_instr[31:26]), .WB(CTL_WB), .M(CTL_M), 
		.EX(CTL_EX));	
	// REG
	REG gp_reg(.clk(clk), .regwrite(RegWrite), .rs(IF_ID_instr[25:21]), 
		.rt(IF_ID_instr[20:16]), .rd(MEM_WB_Writereg), 
		.writedata(MEM_WB_Writedata), .A(REG_A), .B(REG_B));		
	// S_EXTEND	
	S_EXTEND #(.OUT_SIZE(32), .IN_SIZE(16)) s_ex(.din(IF_ID_instr[15:0]), 
		.dout(EXT_OUT));	
	// ID_EX
	ID_EX	id_ex(.clk(clk), .ctlwb_out(CTL_WB), .ctlm_out(CTL_M), 
		.ctlex_out(CTL_EX), .npc(IF_ID_NPC), .readdat1(REG_A), 
		.readdat2(REG_B), .signext_out(EXT_OUT), 
		.instr_2016(IF_ID_instr[20:16]), .instr_1511(IF_ID_instr[15:11]), 
		.wb_ctlout(WB), .m_ctlout(M),
		.ex_ctlout(EX), .npcout(NPC), .rdata1out(rdata1out), 
		.rdata2out(rdata2out), .s_extendout(IR), .instrout_2016(instrout_2016), 
		.instrout_1511(instrout_1511));
endmodule
