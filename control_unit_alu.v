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
// always@(*) begin
//     $display("Time: %0t | ALUOp: %b | funct: %b | ALUControl: %b", $time, ALUOp, funct, ALUControl);
// end

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
                3'b001: begin
                    ALUControl = 3'b110; // SLL
                    sub = 1'b0;
                end
                3'b010: begin
                    ALUControl = 3'b001; // SLT
                    sub = 1'b1;
                end
                3'b011: begin
                    ALUControl = 3'b001; // SLTU (unsigned, same ALU op as SLT)
                    sub = 1'b1;
                end
                3'b100: begin
                    ALUControl = 3'b100; // XOR
                    sub = 1'b0;
                end
                3'b101: begin // SRL/SRA
                    if (funct7_5) ALUControl = 3'b101; // SRA
                    else ALUControl = 3'b111; // SRL
                end
                3'b110: begin
                    ALUControl = 3'b011; // OR
                    sub = 1'b0;
                end
                3'b111: begin
                    ALUControl = 3'b010; // AND
                    sub = 1'b0;
                end
                default: ALUControl = 3'bxxx;
            endcase
        end
        3'b001: begin // I-type
            case (funct3)
                3'b000: begin
                    ALUControl = 3'b000; // ADDI
                    sub = 1'b0;
                end
                3'b001: begin
                    ALUControl = 3'b110; // SLLI
                    sub = 1'b0;
                end
                3'b010: begin
                    ALUControl = 3'b001; // SLTI
                    sub = 1'b1;
                end
                3'b011: begin
                    ALUControl = 3'b001; // SLTIU (unsigned, same ALU op as SLTI)
                    sub = 1'b1;
                end
                3'b100: begin
                    ALUControl = 3'b100; // XORI
                    sub = 1'b0;
                end
                3'b101: begin // SRLI/SRAI
                    if (funct7_5) ALUControl = 3'b101; // SRAI
                    else ALUControl = 3'b111; // SRLI
                end
                3'b110: begin
                    ALUControl = 3'b011; // ORI
                    sub = 1'b0;
                end
                3'b111: begin
                    ALUControl = 3'b010; // ANDI
                    sub = 1'b0;
                end
                default: ALUControl = 3'bxxx;
            endcase
        end

        3'b100: begin //B
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