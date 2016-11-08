`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company:       California State University San Bernardino
// Engineer:		Bogdan Kravtsov
//
// Create Date:   13:47:21 10/03/2016
// Module Name:   I_FETCH
// Project Name:  MIPS 
// Description:   MIPS FETCH stage implementation in verilog.
//
// Dependencies:  MUX.v, PC.v, INSTR_MEM.v, INCR.v, IF_ID.v
//
////////////////////////////////////////////////////////////////////////////////

module I_FETCH(input clk, PC_Src, input wire [31:0] EX_MEM_NPC, 
	output wire [31:0] IF_ID_IR, IF_ID_NPC);
	// Delcare signal wires.
	wire [31:0] pc_w;
	wire [31:0] data_w;
	wire [31:0] npc_w;
	wire [31:0] mux_npc_w;
	
	// Instantiate modules.
	MUX mux(.a(EX_MEM_NPC), .b(npc_w), .sel(PC_Src), .y(mux_npc_w));
	PC pc(.clk(clk), .npc(mux_npc_w), .PC(pc_w));
	INSTR_MEM mem(.clk(clk), .addr(pc_w), .data(data_w));
	INCR incr(.pcin(pc_w), .pcout(npc_w));
	IF_ID if_id(.clk(clk), .npc(npc_w), .instr(data_w), .instrout(IF_ID_IR), 
		.npcout(IF_ID_NPC));
endmodule
