`include "CPU_Top.v"
`include "data_memory.v"
`include "instruction_memory.v"

module Memory_Top(
    input clk, 
    input rst
);

    wire [63:0] CPU_IMEM_address;
    wire [31:0] CPU_IMEM_instruction;

    wire [63:0] CPU_DMEM_address;
    wire [63:0] CPU_DMEM_WriteData;
    wire CPU_DMEM_MemWrite;
    wire CPU_DMEM_MemRead;
    wire [63:0] CPU_DMEM_ReadData;

    CPU_Top CPU_Top(
        .clk(clk),
        .rst(rst),

        .IMEM_address(CPU_IMEM_address),
        .IMEM_instruction(CPU_IMEM_instruction),

        .DMEM_address(CPU_DMEM_address),
        .DMEM_WriteData(CPU_DMEM_WriteData),
        .DMEM_MemWrite(CPU_DMEM_MemWrite),
        .DMEM_MemRead(CPU_DMEM_MemRead),
        .DMEM_ReadData(CPU_DMEM_ReadData)
    );

    data_memory data_memory(
        .address(CPU_DMEM_address),
        .WriteData(CPU_DMEM_WriteData),
        .MemWrite(CPU_DMEM_MemWrite),
        .MemRead(CPU_DMEM_MemRead),
        .rst(rst),

        .ReadData(CPU_DMEM_ReadData)
    );

    instruction_memory instruction_memory(
        .address(CPU_IMEM_address),
        .rst(rst),
        .instruction(CPU_IMEM_instruction)
    );

endmodule