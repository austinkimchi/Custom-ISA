`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Santa Clara Unviersity
// Engineer: Austin Kim
// 
// Create Date: 10/16/2025 03:50:27 PM
// Design Name: ID/EX Pipeline Register 
// Module Name: id_ex
// Description: ID/EX Pipeline Register Module
//////////////////////////////////////////////////////////////////////////////////


module id_ex(
    input               clk,
    // Signal(s)
    input               rst,
    // Data
    input       [2:0]   WB_in,
    input       [4:0]   M_in,
    input       [2:0]   EX_in,
    input       [31:0]  PC_in,
    input       [31:0]  rs_data_in,
    input       [31:0]  rt_data_in,
    input       [31:0]  imm_in,
    input       [5:0]   rd_in,
    output reg  [2:0]   WB_out,
    output reg  [4:0]   M_out,
    output reg  [2:0]   EX_out,
    output reg  [31:0]  PC_out,
    output reg  [31:0]  rs_data_out,
    output reg  [31:0]  rt_data_out,
    output reg  [31:0]  imm_out,
    output reg  [5:0]   rd_out
    );
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            WB_out          <= 3'b0;
            M_out           <= 5'b0;
            EX_out          <= 3'b0;
            PC_out          <= 32'b0;
            rs_data_out     <= 32'b0;
            rt_data_out     <= 32'b0;
            imm_out         <= 32'b0;
            rd_out          <= 6'b0;
        end else begin
            WB_out          <= WB_in;
            M_out           <= M_in;
            EX_out          <= EX_in;
            PC_out          <= PC_in;
            rs_data_out     <= rs_data_in;
            rt_data_out     <= rt_data_in;
            imm_out         <= imm_in;
            rd_out          <= rd_in;
        end
    end
endmodule
