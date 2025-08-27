module data_memory(
    input  [63:0] address,
    input  [63:0] WriteData,
    input         zero,
    input         MemWrite,
    input         MemRead,
    // input         clk,
    input         rst,

    output [63:0] ReadData
);

// always@(*) begin
//     $display("Time = %t, ReadData = %h", $time, ReadData);
// end

integer fd, i;
reg [63:0] temp_mem [0:1023];  // temporary buffer for file I/O

assign ReadData = (rst || !MemRead) ? 64'b0 : temp_mem[address >>> 3];

initial begin
    $readmemh("dmem.hex", temp_mem);
end

// assign temp_mem[address] = (MemWrite) ? WriteData : 64'b0;

always@(*) begin
    if (MemWrite) begin
        // $display("address: %h, WriteData: %h", address, WriteData);
        temp_mem[address >>> 3] = WriteData;
        
        // Write back the full memory contents to file
        fd = $fopen("dmem.hex", "w");
        if (fd) begin
            for (i = 0; i < 1024; i = i + 1) begin
                $fdisplay(fd, "%h", temp_mem[i]);
            end
            $fclose(fd);
        end else begin
            $display("ERROR: could not open dmem.hex for writing");
        end
    end
end


endmodule
