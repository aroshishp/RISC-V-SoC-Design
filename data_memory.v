// module data_memory(
//     input [63:0] address,
//     input [63:0] WriteData,
//     input zero,
//     input MemWrite,
//     input MemRead,
//     input clk, 
//     input rst,

//     output [63:0] ReadData
// );

// reg [63:0] DMEM [1023:0];

// assign ReadData = (rst == 1'b1 || MemRead == 1'b0) ? 64'b0 : DMEM[address];
// integer fd, i;

// always @(posedge clk) begin
//     if (MemWrite) begin
//         DMEM[address] <= WriteData;
//         // Dump all data memory values to a file for debugging
        
//         fd = $fopen("dmem_dump.txt", "w");
//         if (fd) begin
//             $fdisplay(fd, "Data memory dump at time %0t:", $time);
//             for (i = 0; i < 1024; i = i + 1) begin
//                 $fdisplay(fd, "DMEM[%0d]: %h", i, DMEM[i]);
//             end
//             $fclose(fd);
//         end
//     end
// end

// integer fd_init, code_init, idx_init;
// reg [256*8:1] line_init;
// reg [63:0] value_init;

// initial begin
//     // Read data memory from dmem_dump.txt into DMEM array

//     fd_init = $fopen("dmem_dump.txt", "r");
//     if (fd_init) begin
//         // Skip header line
//         code_init = $fgets(line_init, fd_init);
//         for (idx_init = 0; idx_init < 1024; idx_init = idx_init + 1) begin
//             code_init = $fgets(line_init, fd_init);
//             if (code_init) begin
//                 // Parse line: DMEM[%d]: %h or DMEM[%d]: xxxxxxxx
//                 if ($sscanf(line_init, "DMEM[%d]: %h", idx_init, value_init) == 2) begin
//                     DMEM[idx_init] = value_init;
//                 end else begin
//                     DMEM[idx_init] = 64'h0000000000000000;
//                 end
//             end else begin
//                 DMEM[idx_init] = 64'h0000000000000000;
//             end
//         end
//         $fclose(fd_init);
//     end else begin
//         // If file not found, zero out memory
//         for (idx_init = 0; idx_init < 1024; idx_init = idx_init + 1) DMEM[idx_init] = 64'h0000000000000000;
//     end
// end
// endmodule

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

integer fd, i;
reg [63:0] temp_mem [0:1023];  // temporary buffer for file I/O

assign ReadData = (rst || !MemRead) ? 64'b0 : temp_mem[address];

initial begin
    $readmemh("dmem.hex", temp_mem);
end

// assign temp_mem[address] = (MemWrite) ? WriteData : 64'b0;

always@(*) begin
    if (MemWrite) begin
        temp_mem[address] = WriteData;
        
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





// always @(*) begin
//     if (MemWrite) begin
//         // Load current file contents
//         // $readmemh("dmem.hex", temp_mem);

//         // Update memory at the given address
//         temp_mem[address] = WriteData;

//         // Write back the full memory contents to file
//         fd = $fopen("dmem.hex", "w");
//         if (fd) begin
//             for (i = 0; i < 1024; i = i + 1) begin
//                 $fdisplay(fd, "%h", temp_mem[i]);
//             end
//             $fclose(fd);
//         end else begin
//             $display("ERROR: could not open dmem.hex for writing");
//         end
//     end
// end

// initial begin
//     // If file not found, initialize to zeros
//     fd = $fopen("dmem.hex", "r");
//     if (!fd) begin
//         fd = $fopen("dmem.hex", "w");
//         for (i = 0; i < 1024; i = i + 1) begin
//             $fdisplay(fd, "0000000000000000");
//         end
//         $fclose(fd);
//     end else begin
//         $fclose(fd);
//     end
// end

endmodule
