`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Santa Clara Unviersity
// Engineer: Austin Kim
// 
// Create Date: 10/16/2025 03:50:27 PM
// Design Name: Register File 
// Module Name: reg_file
// Description: Register File Module
//////////////////////////////////////////////////////////////////////////////////


module reg_file(
    input clk,
    // Signal(s)
    input RegWrite,
    // Data
    input [5:0] rs_addr,
    input [5:0] rt_addr,
    input [5:0] rd_addr,
    input [31:0] write_data,
    output [31:0] rs_data,
    output [31:0] rt_data
    );
    reg [31:0] regs [0:63];
    
    integer i;
    initial begin
        for(i=0; i<64; i=i+1) regs[i] = 0;
        
        // Assumptions
        regs[1] = 32'd7;    // n = 7 array size
        regs[2] = 32'd2;    // &A[0]
        regs[3] = 32'd71;   // &B[0]
    end
    
    assign rs_data = regs[rs_addr];
    assign rt_data = regs[rt_addr];
    
    always @(posedge clk) begin
        if(RegWrite) begin
            if (rd_addr != 0)
                regs[rd_addr] <= write_data;
        end
    end
endmodule
