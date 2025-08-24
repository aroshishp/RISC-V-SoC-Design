module control_unit_alu(
    input [2:0] ALUOp,
    input [3:0] funct, //[3] funct7[5], [2:0] funct3
    output reg [2:0] ALUControl,
    output reg sub
);

wire [2:0] funct3 = funct[2:0];
wire funct7_5 = funct[3]; // This is funct7[5]

/*
ALUControl mapping:
sum (add/sub): 3'b000
slt:           3'b001
and:           3'b010
or:            3'b011
xor:           3'b100
sra:           3'b101
sll:           3'b110
srl:           3'b111
*/
always@(*) begin
    $display("Time: %0t | ALUOp: %b | funct: %b | ALUControl: %b", $time, ALUOp, funct, ALUControl);
end

always @(*) begin
    // Default values
    // ALUControl = 3'b000; // Default to ADD for load/store/branch/I-type
    // sub = 1'b0;
    // $display("funct3: %b | funct7[5]: %b", funct3, funct7_5);

    case (ALUOp)
        3'b000: begin // R-type
            case (funct3)
                3'b000: begin // ADD/SUB
                    ALUControl = 3'b000;
                    if (funct7_5) sub = 1'b1; // SUB
                    else sub = 1'b0; // ADD
                end
                3'b001: ALUControl = 3'b110; // SLL
                3'b010: begin
                    ALUControl = 3'b001; // SLT
                    sub = 1'b1;
                end
                3'b011: begin
                    ALUControl = 3'b001; // SLTU (unsigned, same ALU op as SLT)
                    sub = 1'b1;
                end
                3'b100: ALUControl = 3'b100; // XOR
                3'b101: begin // SRL/SRA
                    if (funct7_5) ALUControl = 3'b101; // SRA
                    else ALUControl = 3'b111; // SRL
                end
                3'b110: ALUControl = 3'b011; // OR
                3'b111: ALUControl = 3'b010; // AND
                default: ALUControl = 3'bxxx;
            endcase
        end
        3'b001: begin // I-type
            case (funct3)
                3'b000: ALUControl = 3'b000; // ADDI
                3'b001: ALUControl = 3'b110; // SLLI
                3'b010: begin
                    ALUControl = 3'b001; // SLTI
                    sub = 1'b1;
                end
                3'b011: begin
                    ALUControl = 3'b001; // SLTIU (unsigned, same ALU op as SLTI)
                    sub = 1'b1;
                end
                3'b100: ALUControl = 3'b100; // XORI
                3'b101: begin // SRLI/SRAI
                    if (funct7_5) ALUControl = 3'b101; // SRAI
                    else ALUControl = 3'b111; // SRLI
                end
                3'b110: ALUControl = 3'b011; // ORI
                3'b111: ALUControl = 3'b010; // ANDI
                default: ALUControl = 3'bxxx;
            endcase
        end

        3'b100: begin
            ALUControl = 3'b000;
            sub = 1'b1;
        end
        // For Load, Store, JAL, JALR, LUI, AUIPC, ALUOp dictates ADD
        3'b010, 3'b011, 3'b101, 3'b110, 3'b111: begin
            ALUControl = 3'b000; // All use ADD operation
            sub = 1'b0;
        end
        default: begin
            ALUControl = 3'bxxx;
            sub = 1'bx;
        end
    endcase
end

endmodule






// module control_unit_alu(
//     input [2:0] ALUOp,
//     input [3:0] funct, //[3] funct7[5], [2:0] funct3
//     output [2:0] ALUControl,
//     output sub
// );

// wire [2:0] funct3 = funct[2:0];
// wire funct7 = funct[3];
// /*
// sum (add + sub),0
// slt,1
// and,2
// or,3
// xor,4
// sra,5
// sll,6
// srl7
// */

// assign ALUControl = (ALUOp == 3'b000) ? //R
//                     (
//                         (funct3 == 3'b000 && !funct7) ? 3'b000 :
//                         (funct3 == 3'b000 && funct7) ? 3'b000 :
//                         (funct3 == 3'b100 && !funct7) ? 3'b100 :
//                         (funct3 == 3'b110 && !funct7) ? 3'b011 :
//                         (funct3 == 3'b111 && !funct7) ? 3'b010 :
//                         (funct3 == 3'b001 && !funct7) ? 3'b110 :
//                         (funct3 == 3'b101 && !funct7) ? 3'b111 :
//                         (funct3 == 3'b101 && funct7) ? 3'b101 :
//                         (funct3 == 3'b010 && !funct7) ? 3'b001 :
//                         (funct3 == 3'b011 && !funct7) ? 3'b001 : 3'bxxx;
//                     ) :
//                 (ALUOp == 3'b001) ? //I
//                     (
//                         (funct3 == 3'b000) ? 3'b000 : //addi
//                         (funct3 == 3'b100) ? 3'b100 : //xori
//                         (funct3 == 3'b110) ? 3'b011 : //ori
//                         (funct3 == 3'b111) ? 3'b010 : //andi
//                         (funct3 == 3'b001) ? 3'b110 : //slli
//                         (funct3 == 3'b101 && funct7[5] == 1'b0) ? 3'b111 :
//                         (funct3 == 3'b101 && funct7[5] == 1'b1) ? 3'b101 : //srli
//                         (funct3 == 3'b010) ? 3'b001 : //slti
//                         (funct3 == 3'b011) ? 3'b001 : 3'bxxx;
//                     ) :
//                 (ALUOp == 3'b010) ? 3'b000 :
//                 (ALUOp == 3'b011) ? 3'b000 :
//                 (ALUOp == 3'b100) ? 3'b000 :
//                 (ALUOp == 3'b101) ? 3'b000 :
//                 (ALUOp == 3'b110) ? 3'b000 :
//                 (ALUOp == 3'b111) ? 3'b000 : 3'bxxx;


// ///INCOMPLETE 
// assign sub = (ALUOp == 3'b000) ? //R
//                     (
//                         (funct3 == 3'b000 && funct7 == 7'b0000000) ? 3'b000 :
//                         (funct3 == 3'b000 && funct7 == 7'b0100000) ? 3'b000 :
//                         (funct3 == 3'b100 && funct7 == 7'b0000000) ? 3'b100 :
//                         (funct3 == 3'b110 && funct7 == 7'b0000000) ? 3'b011 :
//                         (funct3 == 3'b111 && funct7 == 7'b0000000) ? 3'b010 :
//                         (funct3 == 3'b001 && funct7 == 7'b0000000) ? 3'b110 :
//                         (funct3 == 3'b101 && funct7 == 7'b0000000) ? 3'b111 :
//                         (funct3 == 3'b101 && funct7 == 7'b0100000) ? 3'b101 :
//                         (funct3 == 3'b010 && funct7 == 7'b0000000) ? 3'b001 :
//                         (funct3 == 3'b011 && funct7 == 7'b0000000) ? 3'b001 : 3'bxxx;
//                     ) :
//                 (ALUOp == 3'b001) ? //I
//                     (
//                         (funct3 == 3'b000) ? 3'b000 : //addi
//                         (funct3 == 3'b100) ? 3'b100 : //xori
//                         (funct3 == 3'b110) ? 3'b011 : //ori
//                         (funct3 == 3'b111) ? 3'b010 : //andi
//                         (funct3 == 3'b001) ? 3'b110 : //slli
//                         (funct3 == 3'b101 && funct7[5] == 1'b0) ? 3'b111 :
//                         (funct3 == 3'b101 && funct7[5] == 1'b1) ? 3'b101 : //srli
//                         (funct3 == 3'b010) ? 3'b001 : //slti
//                         (funct3 == 3'b011) ? 3'b001 : 3'bxxx;
//                     ) :
//                 (ALUOp == 3'b010) ? 3'b000 :
//                 (ALUOp == 3'b011) ? 3'b000 :
//                 (ALUOp == 3'b100) ? 3'b000 :
//                 (ALUOp == 3'b101) ? 3'b000 :
//                 (ALUOp == 3'b110) ? 3'b000 :
//                 (ALUOp == 3'b111) ? 3'b000 : 3'bxxx;
// endmodule