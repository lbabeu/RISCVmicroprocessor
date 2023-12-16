module CPU_top(output reg clk, output reg [31:0] PC, output wire [31:0] ALUout, output wire [31:0] rs1, output wire [31:0] rs2,
output wire [31:0] instr, output wire PCsel, output wire RegWen, output wire BrUn, output wire Bsel, output wire Asel, output wire [3:0] ALUop, output wire WbSel,
output wire MemRW);

reg [4:0] inrs1;
reg [4:0] inrs2;
reg [4:0] rd;
reg [11:0] imm;
reg [31:0] extendedimm;
reg [31:0] opA;
reg [31:0] opB;
reg [31:0] datain;
wire [31:0] ramout;
reg [12:0] brimm;
integer cyclecounter; 
initial begin
cyclecounter = 0;
clk = 0;
PC = 0; //start instructions at ROM index 4, use PC = 0 just to make sure any transients in simulation smooth out;
end
always #2 clk = ~clk;

Control_Unit cu (clk, instr, PCsel, RegWen, BrUn, BEq, BLT, Bsel, Asel, ALUop, WbSel, MemRW);
ALU ALU (clk, 1, opA, opB, ALUop, ALUout);
RAM RAM (clk, 1, MemRW, 0, memaddr, datain,  ramout);
RegFile RegFile (0, RegWen, clk, inrs1, inrs2, rd, datain, rs1, rs2);
ROM ROM (clk, 1, PC, instr);
BranchComp BranchComp (BrUn, rs1, rs2, BEq, BLT);

//program counter
always @(posedge clk) begin
	if(PCsel == 1 && cyclecounter == 4) begin
	//PCsel = 1 means branch taken
	PC = ALUout;
	cyclecounter = 4;
	//PC = alu ALUout (current PC + branch offset)
	end
	if(PCsel == 0 && cyclecounter == 4) begin
	//branch not taken
	PC = PC + 4;
	cyclecounter = 0;
	end
cyclecounter = cyclecounter + 1;
end

//datapath
always @(posedge clk) begin
//check instruction type and take actions based on type
inrs1 <= instr[19:15];

//R type:
	if(instr[6:0] == 7'b0110011) begin
	rd = instr[11:7];
	inrs2 = instr[24:20];
	end
//I type:
	if(instr[6:0] == 7'b0010011) begin
	imm = instr[31:20];
	rd = instr[11:7];
	//sign extender
		if(imm[11] == 1) begin //signed so 1 = negative
		extendedimm <= {19'b1 + imm[11:0]};
		end
		if(imm[11] == 0) begin //0 MSB = positive, replace with lead zeroes
		extendedimm <= {19'b0 + imm[11:0]};
		end
		end
//B type (branches only) NOTE SWITCH IMM STRUCTURED: [12][10:5][4:1][11]
	if(instr[6:0] == 7'b1100011) begin
	brimm[12] = instr[31];
	brimm[11] = instr[7];
	brimm[10:5] = instr[30:25];
	brimm[4:1] = instr[11:8];
	brimm[0] = 0; //written like this because concatenation isn't working with modelsim
	
	//pad, same code as standard sign extender (instantiated here because doesn't work as its own module)
	if(brimm[12] == 1) begin
	extendedimm <= {19'b1 + brimm[12:0]};
	end
	if(brimm[12] == 0) begin
	extendedimm <= {19'b0 + brimm[12:0]};
	end
	
	end
	//breakpoint 1
	//breakpoint 2
	//mux time
	if(Asel == 1) begin //want current PC to pass
   opA <= PC;
	end
	
	if(Asel == 0) begin //want rs1 to pass
	opA <= rs1;
	end
	
	if(Bsel == 1) begin //want imm to pass
	opB <= extendedimm;
	end
	
   if(Bsel == 0) begin //want rs2 to pass
	opB <= rs2;
	end
	
	if(WbSel == 1) begin //want alu output to pass to regfile datain
	datain <= ALUout;
	end
	
	if(WbSel == 0) begin //want output of RAM to pass to regfile (only for LW and also d/c but then regfile write is disabled anyways)
	datain <= ramout;
	end
end
endmodule
