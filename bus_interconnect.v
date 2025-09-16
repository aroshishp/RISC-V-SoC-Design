module bus_interconnect(
    input [63:0] m_address,
    input [63:0] m_WriteData,
    input m_MemWrite,
    input m_MemRead,
    output [63:0] m_ReadData,

    output [63:0] d_address,
    output [63:0] d_WriteData,
    output d_MemWrite,
    output d_MemRead,
    input [63:0] d_ReadData
);

    assign d_address = m_address;
    assign d_WriteData = m_WriteData;
    assign d_MemWrite = m_MemWrite;
    assign d_MemRead = m_MemRead;
    assign m_ReadData = d_ReadData;

endmodule