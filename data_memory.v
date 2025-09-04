module data_memory(
    input  [63:0] address,
    input  [63:0] WriteData,
    input         MemWrite,
    input         MemRead,
    input         rst,

    output [63:0] ReadData
);

    reg [63:0] temp_mem [0:1023]; 
    assign ReadData = (rst || !MemRead) ? 64'b0 : temp_mem[address >>> 3];

    initial begin
        $readmemh("dmem.hex", temp_mem);
    end

    integer fd, i;
    always@(*) begin
        if (MemWrite) begin
            temp_mem[address >>> 3] = WriteData;
            
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