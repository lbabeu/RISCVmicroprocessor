module ROM (input clk, input enable, input [31:0] memaddr, output reg [31:0] out);

reg [7:0] IMEMcontents[1023:0];

initial begin
IMEMcontents[7] = 8'b00111110;
IMEMcontents[6] = 8'b10000000;
IMEMcontents[5] = 8'b10000100;
IMEMcontents[4] = 8'b00010011;
//^ addi x8, x1, 1000 x8=1000

//00000001010000001000000100010011
IMEMcontents[11] = 8'b00000001;
IMEMcontents[10] = 8'b01000000;
IMEMcontents[9] = 8'b10000001;
IMEMcontents[8] = 8'b00010011;
//^addi x2, x1, 20 x2=20

//01000000001001000000000110110011
IMEMcontents[15] = 8'b01000000;
IMEMcontents[14] = 8'b00100100;
IMEMcontents[13] = 8'b00000001;
IMEMcontents[12] = 8'b10110011;
//sub x3, x8, x2 x3=980

//00000000001101000111001000110011
IMEMcontents[19] = 8'b00000000;
IMEMcontents[18] = 8'b00110100;
IMEMcontents[17] = 8'b01110010;
IMEMcontents[16] = 8'b00110011;
//AND x4 x8 x3 x4=960

//00000000010000011100001010110011
IMEMcontents[23] = 8'b00000000;
IMEMcontents[22] = 8'b01000001;
IMEMcontents[21] = 8'b11000010;
IMEMcontents[20] = 8'b10110011;
//XOR x5, x3, x4 x5=20


//00000000010100100110001100110011
IMEMcontents[27] = 8'b00000000;
IMEMcontents[26] = 8'b01010010;
IMEMcontents[25] = 8'b01100011;
IMEMcontents[24] = 8'b00110011;
//OR x6 x4 x5 x6 = 980


//00000001010000110000001100010011
IMEMcontents[31] = 8'b00000001;
IMEMcontents[30] = 8'b01000011;
IMEMcontents[29] = 8'b00000011;
IMEMcontents[28] = 8'b00010011;
//ADDI x6 x6 20 x6=1000


//11000010001000110000001100010011
IMEMcontents[35] = 8'b11000010;
IMEMcontents[34] = 8'b00100011;
IMEMcontents[33] = 8'b00000011;
IMEMcontents[32] = 8'b00010011;
//ADDI x6 x6 -990 x6=10


//00000000011000110001001100110011
IMEMcontents[39] = 8'b00000000;
IMEMcontents[38] = 8'b01100011;
IMEMcontents[37] = 8'b00010011;
IMEMcontents[36] = 8'b00110011;
//SLL x6 x6 x6   x6=10240

//00111110101001010000010001100011

IMEMcontents[43] = 8'b00111110;
IMEMcontents[42] = 8'b10100101;
IMEMcontents[41] = 8'b00000100;
IMEMcontents[40] = 8'b01100011;
//BEQ x10 x10 1000 branch taken PC+1000
end

always @(negedge clk) begin
	if(enable) begin
	out <= {IMEMcontents[memaddr+3], IMEMcontents[memaddr+2], IMEMcontents[memaddr+1], IMEMcontents[memaddr]};
	end
end

endmodule
