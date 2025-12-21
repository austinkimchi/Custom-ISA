`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Santa Clara Unviersity
// Engineer: Austin Kim
// 
// Create Date: 10/16/2025 03:50:27 PM
// Design Name: Data Memory 
// Module Name: data_memory
// Description: Data Memory Module
//////////////////////////////////////////////////////////////////////////////////


module data_memory(
        input clk,
        // Signals
        input MemWrite,
        input MemRead,
        // Data
        input [31:0] addr,
        input [31:0] write_data,
        output reg [31:0] read_data
    );
    reg [31:0] mem [0:65535];
    integer i;
    
    // Test Case Init.
    initial begin
        for (i=0; i<65536; i=i+1) mem[i] = 32'b0;
        // Array [3,1,5,7,2,9,8] at address 2
        mem[2] = 32'd3;
        mem[3] = 32'd1;
        mem[4] = 32'd5;
        mem[5] = 32'd7;
        mem[6] = 32'd2;
        mem[7] = 32'd9;
        mem[8] = 32'd8;
    end
    
    // MemWrite Signal
    always @(posedge clk) begin
        if (MemWrite) begin
            mem[addr[15:0]] <= write_data;  // Writes write_data signal to address.
        end
    end
    
    // MemRead Signal
    always @(posedge clk) begin
        if (MemRead) begin                  // Return memory value of address
            read_data = mem[addr[15:0]];    // 64K words 
        end else begin      // x don't care
            read_data = 32'b0;
        end
    end
endmodule
