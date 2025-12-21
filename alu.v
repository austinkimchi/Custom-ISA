`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Santa Clara University
// Engineer: Austin Kim
// Create Date: 10/09/2025 10:05:56 AM
// Design Name: ALU with modules
// Module Name: alu, twoToOne, threeToOne, negate, fullAdder, oneBitAdder
// Project Name: Lab 2
// Description: This is a 32-bit ALU that can add, subtract, negate A or B, 
//              or output 0. It contians multiple modules to accomplish this.
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////

module ALU(
    // Signals
    input add, neg, sub,
    // Data
    input [31:0] A, B,
    output [31:0] out,
    output Z, N
    );
    wire [31:0] negA_arr, negB_arr;
    negate negA(.A(A), .out(negA_arr));
    negate negB(.A(B), .out(negB_arr));
    
    // selection wire
    // A is always positive unless
    // neg = 1 & sub = -1
    wire selA = neg & ~sub;
    
    // operate to build A
    wire [31:0] opA;
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin: muxA
            twoToOne mA(.A     (A[i]),
                        .negA  (negA_arr[i]),
                        .sel   (selA),
                        .out   (opA[i])
                        );
        end
    endgenerate
    
    // operate to build B
    // B (00), 0 (01), -B (10)
    wire [1:0] selB;
    assign selB[0] = add & neg; // are when add&neg are (11) it will pass 0
    assign selB[1] = ~neg & sub;
    
    wire [31:0] opB;
    genvar j;
    generate
        for (j = 0; j < 32; j = j + 1) begin : muxB
            threeToOne mB (.B    (B[j]),
                           .negB (negB_arr[j]),
                           .sel  (selB),
                           .out  (opB[j])
            );
        end
    endgenerate
    
    wire [31:0] sum;
    wire cout_temp;
    fullAdder add32(
        .A (opA),
        .B (opB),
        .sum (sum),
        .cout(cout_temp)
     );
     
     assign out = sum;
     assign Z = (sum == 32'b0);
     assign N = sum[31];
endmodule

module twoToOne(
    input A, negA,
    input sel,
    output out
    );
    assign out = (A & ~sel) | (negA & sel);
endmodule

module threeToOne(
    input B, negB,
    input [1:0] sel,
    output out
    );
    assign out =  (B & ~sel[1] & ~sel[0]) |
                (0 & ~sel[1] & sel[0]) |
                (negB & sel[1] & ~sel[0]);
endmodule

module oneBitAdder(
    input A, B, cin,
    output out, cout
    );
    assign out = A ^ B ^ cin;
    assign cout = ((A ^ B) & cin) | (A & B);
endmodule

module negate(
    input [31:0] A,
    output [31:0] out
    );
    assign out = ~A + 1'b1;
endmodule

module fullAdder(
    input [31:0] A, B,
    output [31:0] sum, 
    output cout
    );
    wire [32:0] carry;
    assign carry[0] = 1'b0;
    
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : add
            oneBitAdder oba(.A      (A[i]),
                        .B      (B[i]),
                        .cin    (carry[i]),
                        .out    (sum[i]),
                        .cout   (carry[i+1])
                        );
            
        end
    endgenerate
    
    assign cout = carry[32];
endmodule