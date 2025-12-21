`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Santa Clara Unviersity
// Engineer: Austin Kim
// 
// Create Date: 10/16/2025 03:50:27 PM
// Design Name: Memory to Write-Back Pipeline Register 
// Module Name: mem_wb
// Description: Memory to Write-Back Pipeline Register Module
//////////////////////////////////////////////////////////////////////////////////


module mem_wb(
    input clk,
    // Signal(s)
    input rst,
    // Data
    input [2:0] WB_in,
    input [31:0] PC_imm_in,
    input [31:0] read_data_in,
    input [31:0] ALU_res_in,
    input [5:0] rd_in,
    output reg [2:0] WB_out,
    output reg [31:0] PC_imm_out,
    output reg [31:0] read_data_out,
    output reg [31:0] ALU_res_out,
    output reg [5:0] rd_out
    );
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            WB_out          <= 3'b0;
            PC_imm_out      <= 32'b0;
            read_data_out   <= 32'b0;
            ALU_res_out     <= 32'b0;
            rd_out          <= 6'b0;
        end else begin
            WB_out          <= WB_in;
            PC_imm_out      <= PC_imm_in;
            read_data_out   <= read_data_in;
            ALU_res_out     <= ALU_res_in;
            rd_out          <= rd_in;
        end
    end
endmodule
