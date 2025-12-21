`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Santa Clara Unviersity
// Engineer: Austin Kim
// 
// Create Date: 10/16/2025 03:50:27 PM
// Design Name: EX/MEM Pipeline Register 
// Module Name: ex_mem
// Description: EX/MEM Pipeline Register Module
//////////////////////////////////////////////////////////////////////////////////


module ex_mem(
    // Signal(s)
    input               clk,
    input               rst,
    // Data
    input       [2:0]   WB_in,
    input       [4:0]   M_in,
    input       [31:0]  PC_imm_in,
    input               N_in,
    input               Z_in,
    input       [31:0]  OUT_in,
    input       [31:0]  rt_in,
    input       [31:0]  rs_in,
    input       [5:0]   rd_in,
    output reg  [2:0]   WB_out,
    output reg  [4:0]   M_out,
    output reg  [31:0]  PC_imm_out,
    output reg          N_out,
    output reg          Z_out,
    output reg  [31:0]  OUT_out,
    output reg  [31:0]  rt_out,
    output reg  [31:0]  rs_out,
    output reg  [5:0]   rd_out
    );
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            WB_out          <= 3'b0;
            M_out           <= 5'b0;
            PC_imm_out      <= 3'b0;
            N_out           <= 1'b0;
            Z_out           <= 1'b0;
            OUT_out         <= 32'b0;
            rt_out          <= 32'b0;
            rs_out          <= 32'b0;
            rd_out          <= 6'b00;
        end else begin
            WB_out          <= WB_in;
            M_out           <= M_in;
            PC_imm_out      <= PC_imm_in;
            N_out           <= N_in;
            Z_out           <= Z_in;
            OUT_out         <= OUT_in;
            rt_out          <= rt_in;
            rs_out          <= rs_in;
            rd_out          <= rd_in;
        end
    end
endmodule
