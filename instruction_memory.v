module instruction_memory(
    input [63:0] address,
    input rst,
    output [31:0] instruction
);

    reg [31:0] IMEM [0:1023];
    assign instruction = (rst == 1'b1) ? 32'h00000000 : IMEM[address[63:2]];

    initial begin
        $readmemh("imem_dump.hex", IMEM);
    end
endmodule