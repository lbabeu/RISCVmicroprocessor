module MEMCHIP (input clk, input enable, input rw, input reset, input [31:0] memaddr, input [31:0] datain, output reg [31:0] out);

reg [7:0] chipcontents[127:0];
reg [31:0] i;

initial begin
	for(i = 0; i < 128; i = i + 1) begin
	chipcontents[i] <= 8'b0;
end
end

always @(negedge clk) begin

	if(reset == 1) begin
	for(i = 0; i < 128; i = i + 1) begin
	chipcontents[i] <= 8'b0;
	end
	end
if(enable == 1) begin
	if(rw == 0) begin
	//read
	out <= {chipcontents[memaddr + 3], chipcontents[memaddr + 2], chipcontents[memaddr + 1], chipcontents[memaddr]};
	end
	if(rw == 1) begin
	//write
	chipcontents[memaddr] <= datain[7:0];
	chipcontents[memaddr + 1] <= datain[15:8];
	chipcontents[memaddr + 2] <= datain[23:16];
	chipcontents[memaddr + 3] <= datain[31:24];
	end
end
end
endmodule

