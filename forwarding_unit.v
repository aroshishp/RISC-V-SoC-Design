module forwarding_unit(
    input [4:0] ID_EX_RS1,
    input [4:0] ID_EX_RS2,
    input [4:0] EX_MEM_RD,
    input [4:0] MEM_WB_RD,
    input EX_MEM_RegWrite,
    input MEM_WB_RegWrite,
    output reg [1:0] Forward_A,
    output reg [1:0] Forward_B
);

assign Forward_A = (EX_MEM_RegWrite && (EX_MEM_RD != 5'b0) && (EX_MEM_RD == ID_EX_RS1)) ? 2'b10 :
                    (MEM_WB_RegWrite && (MEM_WB_RD != 5'b0) && (MEM_WB_RD == ID_EX_RS1)) ? 2'b01 : 2'b00;

assign Forward_B = (EX_MEM_RegWrite && (EX_MEM_RD != 5'b0) && (EX_MEM_RD == ID_EX_RS2)) && (!(EX_MEM_RegWrite && (EX_MEM_RD != 5'b0) && (EX_MEM_RD == ID_EX_RS1))) ? 2'b10 :
                    (MEM_WB_RegWrite && (MEM_WB_RD != 5'b0) && (MEM_WB_RD == ID_EX_RS2)) && (!(MEM_WB_RegWrite && (MEM_WB_RD != 5'b0) && (MEM_WB_RD == ID_EX_RS1))) ? 2'b01 : 2'b00;

// always@(*) begin
//     $display("Forward_A = %b, Forward_B = %b", Forward_A, Forward_B);
// end
endmodule