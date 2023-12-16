module ALU (input clk, input enable, input [31:0] opA, input [31:0] opB, input [3:0] ALUop, output  reg [31:0] result);
//0000 0 add
//0001 1 sub
//0010 2 and
//0011 3 or
//0100 4 xor
//0101 5 sll
//0110 6 srl

always @(negedge clk) begin

	if(enable) begin
		if(ALUop == 4'b0000) begin
		result <= opA + opB;
		end
		
		if(ALUop == 4'b0001) begin
		result <= opA - opB;
		end
		
		if(ALUop == 4'b0010) begin
		result <= opA & opB;
		end
		
		if(ALUop == 4'b0011) begin
		result <= opA | opB;
		end
		
		if(ALUop == 4'b0100) begin
		result <= opA ^ opB;
		end
		
		if(ALUop == 4'b0101) begin
		result <= opA << opB;
		end
		
		if(ALUop == 4'b0110) begin
		result <= opA >> opB;
		end
	end

	
end
endmodule

