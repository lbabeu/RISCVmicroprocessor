module Control_Unit(
input clk,
input [31:0] instr,
output reg PCsel,
output reg RegWen,
output reg BrUn,
input BEq,
input BLT,
output reg Bsel,
output reg Asel,
output reg [3:0] AluOp,
output reg WbSel,
output reg MemRW);
//zero initial
initial begin
PCsel = 0;
RegWen = 0;
BrUn = 0;
Bsel = 0;
Asel = 0;
AluOp = 0;
WbSel = 0;
MemRW = 0;
end
/*notes about abstracted inputs:
Immsel not used - always do it, just use Bsel to decide whether to take the Imm value or not
PCsel 0 is +4 1 is from alu output (B TYPE ONLY!!!)

*/

//list of instructions
//LW - Load Word, value from memory -> register
//SW - Store word, value from register -> memory
//ADD - Add rs1 + rs2, store in rd
//SUB - Subtract rs1 - rs2, store in rd
//AND - Logical rs1 & rs2, store in rd
//OR - Logical rs1 | rs2, store in rd
//XOR - Logical rs1 ^ rs2, store in rd
//SLL - Bitshift rs1 << rs2, store in rd
//SRL - Bitshift rs1 >> rs2, store in rd
//BrNE - If rs1 != rs2, shift PC by Imm value
//BrEq - If rs1 = rs2, shift PC by Imm value
//BrLT - If rs1 < rs2, shift PC by Imm value
//BrGE - If rs1 >= rs2, shift PC by Imm value

//IMM:
//ADDI imm type add
//SUBI <- use add, add a negative number

//see description of instruction at its place
always @(posedge clk) begin
//every cycle run:
// R TYPE: instr [6:0] opcode instr [14:12] func3 instr [31:25] func7
// I TYPE: instr [6:0] opcode instr [14:12] func3 instr [31:20] imm
// B TYPE: instr [6:0] opcode instr [14:12] func3 instr
//LW
	if(instr[6:0] == 7'b0000011 && instr[14:12] == 3'b010) begin
	PCsel = 0;
	RegWen = 1;
	BrUn = 0;
	Bsel = 1;
	Asel = 0;
	AluOp = 4'b0000;
	WbSel = 0;
	MemRW = 0;
	end
//SW
	if(instr[6:0] == 7'b0100011 && instr[14:12] == 3'b010) begin
	//SW
	PCsel = 0;
	RegWen = 0;
	BrUn = 0;
	Bsel = 1;
	Asel = 0;
	AluOp = 4'b0000;
	WbSel = 0;
	MemRW = 1;
	end
	
//ADD
	if(instr[6:0] == 7'b0110011 && instr[14:12] == 3'b000 && instr[31:25] == 7'b0000000) begin
	//ADD
	PCsel = 0;
	RegWen = 1;
	BrUn = 0;
	Bsel = 0;
	Asel = 0;
	AluOp = 4'b0000;
	WbSel = 1;
	MemRW = 0;
	end
//SUB
	if(instr[6:0] == 7'b0110011 && instr[14:12] == 3'b000 && instr[31:25] == 7'b0100000) begin
	//SUB
	PCsel = 0;
	RegWen = 1;
	BrUn = 0;
	Bsel = 0;
	Asel = 0;
	AluOp = 4'b0001;
	WbSel = 1;
	MemRW = 0;
	end
//AND
	if(instr[6:0] == 7'b0110011 && instr[14:12] == 3'b111 && instr[31:25] == 7'b0000000) begin
	//AND
	PCsel = 0;
	RegWen = 1;
	BrUn = 0;
	Bsel = 0;
	Asel = 0;
	AluOp = 4'b0010;
	WbSel = 1;
	MemRW = 0;
	end
//OR
	if(instr[6:0] == 7'b0110011 && instr[14:12] == 3'b110 && instr[31:25] == 7'b0000000) begin
	//OR
	PCsel = 0;
	RegWen = 1;
	BrUn = 0;
	Bsel = 0;
	Asel = 0;
	AluOp = 4'b0011;
	WbSel = 1;
	MemRW = 0;
	end
//XOR
	if(instr[6:0] == 0110011 && instr[14:12] == 100 && instr[31:25] == 0000000) begin
	//XOR
	PCsel = 0;
	RegWen = 1;
	BrUn = 0;
	Bsel = 0;
	Asel = 0;
	AluOp = 4'b0100;
	WbSel = 1;
	MemRW = 0;
	end
//SLL
	if(instr[6:0] == 7'b0110011 && instr[14:12] == 3'b001 && instr[31:25] == 7'b0000000) begin
	//SLL
	PCsel = 0;
	RegWen = 1;
	BrUn = 0;
	Bsel = 0;
	Asel = 0;
	AluOp = 4'b0101;
	WbSel = 1;
	MemRW = 0;
	end
//SRL
	if(instr[6:0] == 7'b0110011 && instr[14:12] == 3'b101 && instr[31:25] == 7'b0000000) begin
	//SRL
	PCsel = 0;
	RegWen = 1;
	BrUn = 0;
	Bsel = 0;
	Asel = 0;
	AluOp = 4'b0110;
	WbSel = 1;
	MemRW = 0;
	end
//BEQ
	if(instr[6:0] == 7'b1100011 && instr[14:12] == 3'b000) begin
	//BEQ
		if(BEq == 1) begin
			PCsel = 1;
			RegWen = 0;
			BrUn = 0;
			Bsel = 1;
			Asel = 1;
			AluOp = 4'b0000;
			WbSel = 0;
			MemRW = 0;
	end
	else begin
		PCsel = 0;
			RegWen = 0;
			BrUn = 0;
			Bsel = 1;
			Asel = 1;
			AluOp = 4'b0000;
			WbSel = 0;
			MemRW = 0;
	end
	end
//BNE
	if(instr[6:0] == 7'b1100011 && instr[14:12] == 3'b001) begin
	//BNE
			if(BEq != 1) begin
			PCsel = 1;
			RegWen = 0;
			BrUn = 0;
			Bsel = 1;
			Asel = 1;
			AluOp = 4'b0000;
			WbSel = 0;
			MemRW = 0;
	end
	else begin
		PCsel = 0;
			RegWen = 0;
			BrUn = 0;
			Bsel = 1;
			Asel = 1;
			AluOp = 4'b0000;
			WbSel = 0;
			MemRW = 0;
	end
	end
//BLT
	if(instr[6:0] == 7'b1100011 && instr[14:12] == 3'b100) begin
	//BLT
			if(BEq != 1 && BLT == 1) begin
			PCsel = 1;
			RegWen = 0;
			BrUn = 0;
			Bsel = 1;
			Asel = 1;
			AluOp = 4'b0000;
			WbSel = 0;
			MemRW = 0;
	end
	else begin
		PCsel = 0;
			RegWen = 0;
			BrUn = 0;
			Bsel = 1;
			Asel = 1;
			AluOp = 4'b0000;
			WbSel = 0;
			MemRW = 0;
	end
	end
//BGE
	if(instr[6:0] == 7'b1100011 && instr[14:12] == 3'b101) begin
	//BGE
			if(BEq == 1 || BLT == 0) begin
			PCsel = 1;
			RegWen = 0;
			BrUn = 0;
			Bsel = 1;
			Asel = 1;
			AluOp = 4'b0000;
			WbSel = 0;
			MemRW = 0;
	end
	else begin
			PCsel = 0;
			RegWen = 0;
			BrUn = 0;
			Bsel = 1;
			Asel = 1;
			AluOp = 4'b0000;
			WbSel = 0;
			MemRW = 0;
	end
	end
//ADDI
	if(instr[6:0] == 7'b0010011 && instr[14:12] == 3'b000) begin
	//ADDI
	PCsel = 0;
	RegWen = 1;
	BrUn = 0;
	Bsel = 1;
	Asel = 0;
	AluOp = 4'b0000;
	WbSel = 1;
	MemRW = 0;
	end

end
endmodule
