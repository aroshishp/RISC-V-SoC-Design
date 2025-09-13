////////////////////////////////////////////////////////////////
//MIGHT NOT WORK FOR JALR, CORRECT THE LOGIC LATER
////////////////////////////////////////////////////////////////

module forwarding_unit(
    input [4:0] ID_EX_RS1,
    input [4:0] ID_EX_RS2,
    input [4:0] EX_MEM_RDes,
    input [4:0] MEM_WB_RDes,
    input [4:0] EX_MEM_RS2,
    input [2:0] INSTR_TYPE,
    input EX_MEM_RegWrite,
    input MEM_WB_RegWrite,
    input EX_MEM_MemWrite,
    input MEM_WB_MemRead,
    input ID_EX_MemWrite,
    input ID_EX_Branch,
    output reg [1:0] Forward_A,
    output reg [1:0] Forward_B,
    output reg Forward_C
);

reg [1:0] Forward_A_intermediate;
reg [1:0] Forward_B_intermediate;

assign Forward_A_intermediate = (EX_MEM_RegWrite && (EX_MEM_RDes != 5'b0) && (EX_MEM_RDes == ID_EX_RS1)) ? 2'b10 :
                    (MEM_WB_RegWrite && (MEM_WB_RDes != 5'b0) && (MEM_WB_RDes == ID_EX_RS1)) && (!(EX_MEM_RegWrite && (EX_MEM_RDes != 5'b0) && (EX_MEM_RDes == ID_EX_RS1))) ? 2'b01 : 2'b00;

assign Forward_A = (INSTR_TYPE == 3'b110 || INSTR_TYPE == 3'b101) ? 2'b00 : Forward_A_intermediate; // U type and J type

assign Forward_B_intermediate = (EX_MEM_RegWrite && (EX_MEM_RDes != 5'b0) && (EX_MEM_RDes == ID_EX_RS2) && (!ID_EX_MemWrite)) ? 2'b10 :
                    (MEM_WB_RegWrite && (MEM_WB_RDes != 5'b0) && (MEM_WB_RDes == ID_EX_RS2) && (!ID_EX_MemWrite)) && (!(EX_MEM_RegWrite && (EX_MEM_RDes != 5'b0) && (EX_MEM_RDes == ID_EX_RS2) && (!ID_EX_MemWrite))) ? 2'b01 : 2'b00;

assign Forward_B = (INSTR_TYPE == 3'b001 || INSTR_TYPE == 3'b110 || INSTR_TYPE == 3'b101) ? 2'b00 : Forward_B_intermediate; // I type, U type and J type

assign Forward_C = (EX_MEM_MemWrite && MEM_WB_MemRead && (MEM_WB_RDes != 5'b0) && (EX_MEM_RS2 != 5'b0) && (MEM_WB_RDes == EX_MEM_RS2)) ? 1'b1 : 1'b0; 
//No extra checks needed bc MemWrite and MemRead are unique to store and load instructions

always@(*) begin
    $display("time = %t, Forward_A = %b, Forward_B = %b, Forward_C = %b", $time, Forward_A, Forward_B, Forward_C);
end
// always@(*) begin
//     $display("time = %0t, EX_MEM_RegWrite = %b, EX_MEM_RDes = %b, ID_EX_RS2 = %b, ")
endmodule