module hazard_detection_unit(
    input [4:0] RS1_ENTERING,
    input [4:0] RS2_ENTERING,
    input [4:0] RD_IF_ID,
    input [4:0] RD_ID_EX,
    input MemRead_IF_ID,
    input MemRead_ID_EX,
    input [6:0] opcode_ENTERING,
    input branch,
    output stall
);
    // always @(*) begin
    //     if (mem_read && (rd == rs1 || rd == rs2) && rd != 0) begin
    //         stall = 1;
    //     end else begin
    //         stall = 0;
    //     end
    // end

    assign stall = (MemRead_IF_ID && opcode_ENTERING == 7'b0110011 && (RD_IF_ID == RS1_ENTERING || RD_IF_ID == RS2_ENTERING) && RD_IF_ID != 0) || 
                    // (MemRead_ID_EX && opcode_ENTERING == 7'b1100011 && (RD_ID_EX == RS1_ENTERING || RD_ID_EX == RS2_ENTERING) && RD_ID_EX != 0) || 
                    (MemRead_IF_ID && opcode_ENTERING == 7'b1100011 && (RD_IF_ID == RS1_ENTERING || RD_IF_ID == RS2_ENTERING) && RD_IF_ID != 0);
    always@(*) begin
        $display("time = %0t, stall = %b", $time, stall);
    end
    // always@(*) begin
    //     $display("time = %0t, stall = %b, MemRead_ID_EX = %b, opcode_IF_ID = %b, RD_ID_EX = %b, RS1_IF_ID = %b, RS2_IF_ID = %b", $time, stall, MemRead_ID_EX, opcode_IF_ID, RD_ID_EX, RS1_IF_ID, RS2_IF_ID);
    // end
endmodule