`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company:       California State University San Bernardino
// Engineer:		Bogdan Kravtsov
//                Tyler Clayton
//
// Create Date:   14:20:02 10/03/2016
// Module Name:   INSTR_MEM
// Project Name:  MIPS 
// Description:   MIPS Instruction Memory implementation in verilog.
//
// Dependencies:  None
//
////////////////////////////////////////////////////////////////////////////////

module INSTR_MEM(input clk, input [31:0] addr, output reg [31:0] data);
   // Declare the memory block.
	reg [31:0] MEM [128:0];
	
	// Initialize memory.
	initial begin
		MEM[0]  <= 32'b100011_00000_00001_0000_0000_0000_0001;  // LW r1 , 1(r0)
		MEM[1]  <= 32'b100011_00000_00010_0000_0000_0000_0010;  // LW r2 , 2(r0)
		MEM[2]  <= 32'b100011_00000_00011_0000_0000_0000_0011;  // LW r3 , 3(r0)
		MEM[3]  <= 32'b100011_00000_00100_0000_0000_0000_0100;  // LW r4 , 4(r0)
		MEM[4]  <= 32'b100011_00000_00101_0000_0000_0000_0101;  // LW r5 , 5(r0)
		MEM[5]  <= 32'b000000_00001_00001_00001_00000_100000;   // ADD r1, r1, r1
		MEM[6]  <= 32'b000000_00010_00010_00010_00000_100000;   // ADD r2, r2, r2
		MEM[7]  <= 32'b000000_00011_00011_00011_00000_100000;   // ADD r3, r3, r3		
		MEM[8]  <= 32'b000000_00100_00100_00100_00000_100000;   // ADD r4, r4, r4	
		MEM[9]  <= 32'b000000_00101_00101_00101_00000_100000;   // ADD r5, r5, r5
		//MEM[10] <= 32'b101011_00001_00000_0000_0000_0000_0001;  // SW r1 , 1(r0)
		//MEM[11] <= 32'b101011_00010_00000_0000_0000_0000_0010;  // SW r2 , 2(r0)
		//MEM[12] <= 32'b101011_00011_00000_0000_0000_0000_0011;  // SW r3 , 3(r0)
		//MEM[13] <= 32'b101011_00100_00000_0000_0000_0000_0100;  // SW r4 , 4(r0)
		//MEM[14] <= 32'b101011_00101_00000_0000_0000_0000_0101;  // SW r5 , 5(r0)
	end

   // Assign the contents at the requested memory address to data.
	always @ *
	begin
		data <= MEM[addr];
	end
endmodule
