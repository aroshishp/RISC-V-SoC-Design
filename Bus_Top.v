`include "CPU_Top.v"
`include "data_memory.v"
`include "bus_interconnect.v"
`include "instruction_memory.v"

module Bus_Top(
    input clk,
    input rst
);

    wire [63:0] CPU_IMEM_address;
    wire [31:0] CPU_IMEM_instruction;

    wire [63:0] CPU_Bus_address;
    wire [63:0] CPU_Bus_WriteData;
    wire CPU_Bus_MemWrite;
    wire CPU_Bus_MemRead;
    wire [63:0] CPU_Bus_ReadData;

    wire [63:0] Bus_DMEM_address;
    wire [63:0] Bus_DMEM_WriteData;
    wire Bus_DMEM_MemWrite;
    wire Bus_DMEM_MemRead;
    wire [63:0] Bus_DMEM_ReadData;

    bus_interconnect bus_interconnect(
        .m_address(CPU_Bus_address),
        .m_WriteData(CPU_Bus_WriteData),
        .m_MemWrite(CPU_Bus_MemWrite),
        .m_MemRead(CPU_Bus_MemRead),
        .m_ReadData(CPU_Bus_ReadData),

        .d_address(Bus_DMEM_address),
        .d_WriteData(Bus_DMEM_WriteData),
        .d_MemWrite(Bus_DMEM_MemWrite),
        .d_MemRead(Bus_DMEM_MemRead),
        .d_ReadData(Bus_DMEM_ReadData)
    );

    CPU_Top cpu(
        .clk(clk),
        .rst(rst),
        .IMEM_address(CPU_IMEM_address),
        .IMEM_instruction(CPU_IMEM_instruction),

        .DMEM_address(CPU_Bus_address),
        .DMEM_WriteData(CPU_Bus_WriteData),
        .DMEM_MemWrite(CPU_Bus_MemWrite),
        .DMEM_MemRead(CPU_Bus_MemRead),
        .DMEM_ReadData(CPU_Bus_ReadData)
    );

    data_memory data_memory(
        .address(Bus_DMEM_address),
        .WriteData(Bus_DMEM_WriteData),
        .MemWrite(Bus_DMEM_MemWrite),
        .MemRead(Bus_DMEM_MemRead),
        .rst(rst),

        .ReadData(Bus_DMEM_ReadData)
    );

    instruction_memory instruction_memory(
        .address(CPU_IMEM_address),
        .rst(rst),
        .instruction(CPU_IMEM_instruction)
    );
endmodule