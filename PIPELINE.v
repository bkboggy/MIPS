`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company:       California State University San Bernardino
// Engineer:		Bogdan Kravtsov
//                Tyler Clayton
//
// Create Date:   11:10:00 10/17/2016
// Module Name:   PIPELINE
// Project Name:  MIPS 
// Description:   MIPS pipeline.
//
// Dependencies:  I_FETCH.v, I_DECODE.v, I_EXECUTE.v, MEM.v, WB.v
//
////////////////////////////////////////////////////////////////////////////////

module PIPELINE(input clk);
	// I_FETCH output wires.
	wire [31:0] IF_ID_IR; 
	wire [31:0] IF_ID_NPC;

	// I_DECODE output wires.
	wire [1:0]  ID_EX_WB;
	wire [2:0]  ID_EX_M;
	wire [3:0]  ID_EX_EX;
	wire [31:0] ID_EX_NPC;
	wire [31:0] ID_EX_rdata1out;
	wire [31:0] ID_EX_rdata2out;
	wire [31:0] ID_EX_IR;
	wire [4:0]  ID_EX_instrout_2016;
	wire [4:0]  ID_EX_instrout_1511;
	
	// I_EXECUTE output wires.
	wire [1:0]  EX_MEM_wb_ctlout_wire;
	wire [2:0]  EX_MEM_m_ctlout_wire;
	wire [31:0] EX_MEM_add_result_wire;
	wire        EX_MEM_zero_wire;
	wire [31:0] EX_MEM_alu_result_wire;
	wire [31:0] EX_MEM_rdata2out_wire;
	wire [4:0]  EX_MEM_five_bit_muxout_wire;
	
	
	// MEM output wires.
	wire        PCSrc_wire;
	wire [4:0]  mem_Write_reg_wire;
	wire [1:0]  mem_control_wb_wire;
	wire [31:0] Read_data_wire;
	wire [31:0] mem_ALU_result_wire;
	
	// WB output wires.
	wire [31:0] wb_data_wire;
	
	I_FETCH FETCH(.clk(clk), .PC_Src(PCSrc_wire), .EX_MEM_NPC(EX_MEM_add_result_wire), 
		.IF_ID_IR(IF_ID_IR), .IF_ID_NPC(IF_ID_NPC));
		
	I_DECODE DECODE(.clk(clk), .RegWrite(mem_control_wb_wire[1]), .IF_ID_instr(IF_ID_IR), 
		.IF_ID_NPC(IF_ID_NPC), .MEM_WB_Writereg(mem_Write_reg_wire), 
		.MEM_WB_Writedata(wb_data_wire), .WB(ID_EX_WB), .M(ID_EX_M), 
		.EX(ID_EX_EX), .NPC(ID_EX_NPC), .rdata1out(ID_EX_rdata1out), 
		.rdata2out(ID_EX_rdata2out), .IR(ID_EX_IR), 
		.instrout_2016(ID_EX_instrout_2016), .instrout_1511(ID_EX_instrout_1511));
		
	I_EXECUTE EXECUTE(.clk(clk), .WB(ID_EX_WB), .M(ID_EX_M), .EX(ID_EX_EX), 
		.NPC(ID_EX_NPC), .rdata1in(ID_EX_rdata1out), .rdata2in(ID_EX_rdata2out), 
		.IR(ID_EX_IR), .instrout_2016(ID_EX_instrout_2016), 
		.instrout_1511(ID_EX_instrout_1511), .wb_ctlout(EX_MEM_wb_ctlout_wire), 
		.m_ctlout(EX_MEM_m_ctlout_wire), .add_result(EX_MEM_add_result_wire), 
		.zero(EX_MEM_zero_wire), .alu_result(EX_MEM_alu_result_wire), 
		.rdata2out(EX_MEM_rdata2out_wire), .five_bit_muxout(EX_MEM_five_bit_muxout_wire));
		
		
	MEM MEMORY(.clk(clk), .m_ctlout(EX_MEM_m_ctlout_wire[2]), .zero(EX_MEM_zero_wire), 
		.MemWrite(EX_MEM_m_ctlout_wire[0]), .MemRead(EX_MEM_m_ctlout_wire[1]),
		.Address(EX_MEM_alu_result_wire), .Write_data(EX_MEM_rdata2out_wire), 
		.control_wb_in(EX_MEM_wb_ctlout_wire), .ALU_result_in(EX_MEM_alu_result_wire), 
		.Write_reg_in(EX_MEM_five_bit_muxout_wire), .PCSrc(PCSrc_wire), 
		.mem_control_wb(EX_MEM_wb_ctlout_wire), .Read_data(Read_data_wire), 
		.mem_ALU_result(mem_ALU_result_wire), .mem_Write_reg(mem_Write_reg_wire));
	
	WB WRITEBACK(.MemtoReg(mem_control_wb_wire[0]), .ReadData(Read_data_wire), 
		.ALUResult(mem_ALU_result_wire), .WriteData(wb_data_wire));
endmodule
