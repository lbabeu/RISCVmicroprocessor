module BranchComp (
  input BrUn,
  input [31:0] rs1,
  input [31:0] rs2,
  output reg BrEq,
  output reg BrLT
);


  always @(rs1 or rs2) begin
    // Comparisons should be in a single if-else block, not separate blocks
    if (rs1 > rs2) begin
      BrLT = 1;
      BrEq = 0;
    end
    else if (rs1 == rs2) begin
      BrLT = 0;
      BrEq = 1;
    end
    else begin
      // If rs1 < rs2, assuming BrUn is true, set both outputs to 0
      if (BrUn) begin
        BrLT = 0;
        BrEq = 0;
      end
    end
  end

endmodule
