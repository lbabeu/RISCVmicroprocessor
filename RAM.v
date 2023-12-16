module RAM (input clk, input enable, input rw, input reset, input [31:0] memaddr, input [31:0] datain, output reg [31:0] out);

reg e[0:7];

wire [31:0] out_c0, out_c1, out_c2, out_c3, out_c4, out_c5, out_c6, out_c7;

MEMCHIP c0 (clk, e[0], rw, reset, memaddr, datain, out_c0);
MEMCHIP c1 (clk, e[1], rw, reset, memaddr, datain, out_c1);
MEMCHIP c2 (clk, e[2], rw, reset, memaddr, datain, out_c2);
MEMCHIP c3 (clk, e[3], rw, reset, memaddr, datain, out_c3);
MEMCHIP c4 (clk, e[4], rw, reset, memaddr, datain, out_c4);
MEMCHIP c5 (clk, e[5], rw, reset, memaddr, datain, out_c5);
MEMCHIP c6 (clk, e[6], rw, reset, memaddr, datain, out_c6);
MEMCHIP c7 (clk, e[7], rw, reset, memaddr, datain, out_c7);

always @(negedge clk) begin
if(enable == 1) begin
case(memaddr[12:10])
0: begin e[0] = 1; e[1] = 0; e[2] = 0; e[3] = 0; e[4] = 0; e[5] = 0; e[6] = 0; e[7] = 0; end
1: begin e[0] = 0; e[1] = 1; e[2] = 0; e[3] = 0; e[4] = 0; e[5] = 0; e[6] = 0; e[7] = 0; end
2: begin e[0] = 0; e[1] = 0; e[2] = 1; e[3] = 0; e[4] = 0; e[5] = 0; e[6] = 0; e[7] = 0; end
3: begin e[0] = 0; e[1] = 0; e[2] = 0; e[3] = 1; e[4] = 0; e[5] = 0; e[6] = 0; e[7] = 0; end
4: begin e[0] = 0; e[1] = 0; e[2] = 0; e[3] = 0; e[4] = 1; e[5] = 0; e[6] = 0; e[7] = 0; end
5: begin e[0] = 0; e[1] = 0; e[2] = 0; e[3] = 0; e[4] = 0; e[5] = 1; e[6] = 0; e[7] = 0; end
6: begin e[0] = 0; e[1] = 0; e[2] = 0; e[3] = 0; e[4] = 0; e[5] = 0; e[6] = 1; e[7] = 0; end
7: begin e[0] = 0; e[1] = 0; e[2] = 0; e[3] = 0; e[4] = 0; e[5] = 0; e[6] = 0; e[7] = 1; end
endcase

case(memaddr[12:10])
000: out <= out_c0;
001: out <= out_c1;
010: out <= out_c2;
011: out <= out_c3;
100: out <= out_c4;
101: out <= out_c5;
110: out <= out_c6;
111: out <= out_c7;
endcase
end
end
endmodule
