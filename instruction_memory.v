module instruction_memory(
    input [63:0] PC,
    input rst,
    output [31:0] instruction
);

reg [31:0] IMEM [0:1023];

// always @(*) begin

assign instruction = (rst == 1'b1) ? 32'h00000000 : IMEM[PC[63:2]];

// always@(*) begin
//     $display("PC: %h | Instruction: %h", PC, instruction);
// end

initial begin
    // Read instructions from imem.txt into IMEM array
    $readmemh("imem_dump.txt", IMEM);
end

// initial begin
//     // IMEM[0] = 32'h00403183;
//     // IMEM[1] = 32'h00803203;
//     IMEM[0] = 32'h003202b3;
//     IMEM[1] = 32'h003202b3;
//     IMEM[2] = 32'h00638433;
//     IMEM[3] = 32'h00c50493;
// end
endmodule