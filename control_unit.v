`timescale 1ns / 1ps
`include "scu_def.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: Santa Clara Unviersity
// Engineer: Austin Kim
// 
// Create Date: 10/16/2025 03:50:27 PM
// Design Name: Control Unit 
// Module Name: control_unit
// Description: Control Unit Module
//////////////////////////////////////////////////////////////////////////////////


module control_unit(
    input [`OPCODE_MSB:`OPCODE_LSB] opcode,
    output reg ALUSrc,
    output reg MemToReg,
    output reg RegWrite,
    output reg MemRead,
    output reg MemWrite,
    output reg [1:0] ALUOp,
    output reg SVPC,
    output reg Z,
    output reg N,
    output reg J    
    );
    always @(*) begin
        // Default case:        
        ALUSrc      = 1'b0;
        MemToReg    = 1'b0;
        RegWrite    = 1'b0;
        MemRead     = 1'b0;
        MemWrite    = 1'b0;
        ALUOp       = 2'b00;
        SVPC        = 1'b0;
        Z           = 1'b0;
        N           = 1'b0;
        J           = 1'b0;
        case(opcode)
            `OP_NOP: begin // already set (default)
            end
            `OP_SVPC: begin
                ALUSrc      = 1'b1;
                RegWrite    = 1'b1;
                SVPC        = 1'b1;
            end
            `OP_LD: begin
                ALUSrc      = 1'b1;
                MemToReg    = 1'b1;
                RegWrite    = 1'b1;
                MemRead     = 1'b1;
            end
            `OP_ST: begin
                ALUSrc      = 1'b1;
                MemWrite    = 1'b1;
            end
            `OP_ADD: begin
                RegWrite    = 1'b1;
            end
            `OP_INC: begin
                ALUSrc      = 1'b1;
                RegWrite    = 1'b1;
            end
            `OP_NEG: begin
                RegWrite    = 1'b1;
                ALUOp       = 2'b10;
            end
            `OP_SUB: begin
                RegWrite    = 1'b1;
                ALUOp       = 2'b01;
            end
            `OP_J: begin
                J           = 1'b1;
            end
            `OP_BRZ: begin
                Z           = 1'b1;
            end
            `OP_BRN: begin
                N           = 1'b1;
            end
            default: begin
            end
        endcase
    end
endmodule
