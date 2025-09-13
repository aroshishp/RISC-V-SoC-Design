module control_unit_main(
    // input zero,
    input [6:0] opcode,
    output Branch,
    output MemRead,
    output MemtoReg,
    output [2:0] ALUOp,
    output MemWrite,
    output ALUSrc,
    output RegWrite,
    output [1:0] Imm_Src
);

assign Branch = (opcode == 7'b1100011) ? 1'b1 : 1'b0; //B
assign MemRead = (opcode == 7'b0000011) ? 1'b1 : 1'b0; //Load
assign MemtoReg = (opcode == 7'b0000011) ? 1'b1 : 1'b0; //Load

/*
R type -> to be decoded
I type -> 
ld, sd -> always add
branch -> always sutract
jump -> 
u type -> 

*/

// initial begin
//     $monitor("Time: %0t | opcode: %b | Branch: %b | MemRead: %b | MemtoReg: %b | ALUOp: %b | MemWrite: %b | ALUSrc: %b | RegWrite: %b | Imm_Src: %b", 
//              $time, opcode, Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite, Imm_Src);
// end

assign ALUOp =  (opcode == 7'b0110011) ? 3'b000 : //R
                (opcode == 7'b0010011 || opcode == 7'b1100111) ? 3'b001 : //I, jalr
                (opcode == 7'b0000011) ? 3'b010 : //ld
                (opcode == 7'b0100011) ? 3'b011 : //sd
                (opcode == 7'b1100011) ? 3'b100 : //branch
                (opcode == 7'b1101111) ? 3'b101 : //jump
                (opcode == 7'b0110111) ? 3'b110 : //lui, auipc (U Type)
                (opcode == 7'b1110011) ? 3'b111 : 3'bxxx; //ecall, ebreak

assign Imm_Src = (opcode == 7'b0010011 || opcode == 7'b0000011) ? 2'b00 : // I
                 (opcode == 7'b0100011) ? 2'b01 : // S
                 (opcode == 7'b1100011) ? 2'b10 : // B
                 (opcode == 7'b1101111) ? 2'b11 : 2'bxx; // J


assign MemWrite = (opcode == 7'b0100011) ? 1'b1 : 1'b0; //S
assign ALUSrc = (opcode == 7'b0010011 || opcode == 7'b0000011 || opcode == 7'b0100011) ? 1'b1 : 1'b0; //I, Load, S
assign RegWrite = (opcode == 7'b0100011 || opcode == 7'b1100011 || opcode == 7'b1110011) ? 1'b0 : 1'b1; //not for S, B, EType

// always@(*) begin
//     $display("ALUOp: %b", ALUOp);
// end
    // $monitor("Time: %0t | opcode: %b | Branch: %b | MemRead: %b | MemtoReg: %b | ALUOp: %b | MemWrite: %b | ALUSrc: %b | RegWrite: %b | Imm_Src: %b", 
    //          $time, opcode, Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite, Imm_Src); 
// end
// always@(*) begin
//     $display("Time: %0t | opcode: %b | ALUOp: %b", $time, opcode, ALUOp);
// end
// always@(*) begin
//     $display("time = %0t, MemRead = %b, MemWrite = %b", $time, MemRead, MemWrite);
// end
endmodule