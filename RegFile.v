module RegFile(input reset, input writeenable, input clk, input [4:0] inrs1, input [4:0] inrs2, input [4:0] rd, input [31:0] datain, output reg [31:0] outrs1, output reg [31:0] outrs2);
//init registers
reg [5:0] i;
reg [31:0] regFile_contents[31:0];
//assign all internal registers to zero
initial begin
	for(i = 0; i < 31; i = i + 1) begin
	regFile_contents[i] <= 32'b0;
end

end
//end start requirements, move to in use 

//check if writeenable true
always @(posedge clk) begin
	if(reset) begin
	for(i = 0; i < 31; i = i + 1) begin
	regFile_contents[i] <= 32'b0;
	end
	end
	if(writeenable) begin
	
	regFile_contents[rd] <= datain;
		
	end
	
		
		
end
//end write

//read operation
always @(negedge clk) begin
	outrs1 = regFile_contents[inrs1];
	outrs2 = regFile_contents[inrs2];
end

endmodule
