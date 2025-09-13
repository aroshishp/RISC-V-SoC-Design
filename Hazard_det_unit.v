module hazard_detection_unit(
    input [4:0] IF_ID_RS1,
    input [4:0] IF_ID_RS2,
    input [4:0] ENTERING_RS1,
    input [4:0] ENTERING_RS2,
    input [4:0] ID_EX_RD,
    input ID_EX_MemRead,
    input [6:0] IF_ID_opcode,
    input [6:0] ENTERING_opcode,
    input IF_ID_branch,
    output stall
);

    assign stall = (ID_EX_MemRead && IF_ID_opcode == 7'b0110011 && (ID_EX_RD == IF_ID_RS1 || ID_EX_RD == IF_ID_RS2) && ID_EX_RD != 0) || 
                    (ID_EX_MemRead && ENTERING_opcode == 7'b1100011 && (ID_EX_RD == ENTERING_RS1 || ID_EX_RD == ENTERING_RS2) && ID_EX_RD != 0) || 
                    (ID_EX_MemRead && IF_ID_branch && (ID_EX_RD == IF_ID_RS1 || ID_EX_RD == IF_ID_RS2) && ID_EX_RD != 0) ||
                    (ID_EX_MemRead && ENTERING_opcode == 7'b0100011 && (ID_EX_RD == ENTERING_RS2) && ID_EX_RD != 0);
                
    // always@(*) begin
    //     $display("time = %0t, stall = %b", $time, stall);
    // end
endmodule