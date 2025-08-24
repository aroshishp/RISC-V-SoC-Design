module hazard_detection_unit(
    input [4:0] rs1,
    input [4:0] rs2,
    input [4:0] rd,
    input mem_read_1,
    input mem_read_2,
    input [6:0]opcode,
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

    assign stall = (mem_read_1 && opcode == 7'b0110011 && (rd == rs1 || rd == rs2) && rd != 0) || (mem_read_2 && branch && (rd == rs1 || rd == rs2) && rd != 0) || (mem_read_1 && branch && (rd == rs1 || rd == rs2) && rd != 0);

endmodule