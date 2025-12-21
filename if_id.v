`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Santa Clara Unviersity
// Engineer: Austin Kim
// 
// Create Date: 10/16/2025 03:50:27 PM
// Design Name: IF/ID Pipeline Register 
// Module Name: if_id
// Description: IF/ID Pipeline Register Module
//////////////////////////////////////////////////////////////////////////////////


module if_id( 
    input clk,
    // Signal(s)
    input rst,
    // Data
    input [31:0] PC_in,
    input [31:0] inst_in,
    output reg [31:0] PC_out,
    output reg [31:0] inst_out
    );
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            inst_out    <= 32'b0;
            PC_out      <= 32'b0;
        end else begin
            inst_out    <= inst_in;
            PC_out      <= PC_in;
        end
    end
endmodule
