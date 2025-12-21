`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Santa Clara Unviersity
// Engineer: Austin Kim
// 
// Create Date: 10/16/2025 03:50:27 PM
// Design Name: ALU Control 
// Module Name: alu_control
// Description: ALU Control Module
//////////////////////////////////////////////////////////////////////////////////


module alu_control(
    // Signal(s)
    input [1:0] ALUOp,
    // Data
    output reg add,
    output reg sub,
    output reg neg
    );
    always @(*) begin
        // Default
        add = 0;
        sub = 0;
        neg = 0;
        
        case (ALUOp)
            2'b00: begin    // Add
                add = 1;
            end
            2'b01: begin    // Subtract
                add = 1;
                sub = 1;
            end
            2'b10: begin    // Negate
                add = 1;
                neg = 1;
            end
            2'b11: begin    // Pass (unused in SCU ISA)
                add = 1;
                neg = 1;
                sub = 1;
            end
        
        endcase
    end
endmodule
