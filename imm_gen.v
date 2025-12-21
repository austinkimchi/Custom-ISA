`timescale 1ns / 1ps
`include "scu_def.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: Santa Clara Unviersity
// Engineer: Austin Kim
// 
// Create Date: 10/16/2025 03:50:27 PM
// Design Name: Immediate Generator 
// Module Name: imm_gen
// Description: Immediate Generator Module
//////////////////////////////////////////////////////////////////////////////////


module imm_gen(
    // Data
    input [31:0] inst,
    output [31:0] imm
    );
    wire [9:0] y = inst[`IMM_MSB:`IMM_LSB];
    assign imm = {{22{y[9]}}, y};           // sign extend: 22 bits + 10 bits = 32 bits
endmodule
