module Imm_Gen(
    input [31:0] imm_in,
    inout [1:0] imm_src,
    output [63:0] imm_out
);
    assign imm_out = (imm_src == 2'b00) ? {{52{imm_in[31]}}, imm_in[31:20]} : // I
                     (imm_src == 2'b01) ? {{52{imm_in[31]}}, imm_in[31:25], imm_in[11:7]} : // S
                     (imm_src == 2'b10) ? {{51{imm_in[31]}}, imm_in[31], imm_in[7], imm_in[30:25], imm_in[11:8], 1'b0} : // B
                     (imm_src == 2'b11) ? {{43{imm_in[31]}}, imm_in[31],imm_in[19:12],imm_in[20] ,imm_in[30:21], 1'b0} : 64'b0; // J
                     
endmodule
