`timescale 1ns / 1ps
`include "scu_def.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: Santa Clara Unviersity
// Engineer: Austin Kim
// 
// Create Date: 10/16/2025 03:50:27 PM
// Design Name: CPU
// Module Name: cpu
// Description: CPU Module
//////////////////////////////////////////////////////////////////////////////////

module cpu(
    input clk,
    input rst
    );
    wire PCSrc;
    wire [31:0] branch_target;
    
    // ----------- IF STAGE -----------
    wire [31:0] PC;
    wire [31:0] PC_next;
    reg [31:0] PC_reg;
    assign PC = PC_reg;
    // MUX: 0 - Adder (PC+1), 1 - Branch/Jump target
    assign PC_next = (PCSrc) ? branch_target : (PC + 1);
    
    // PC Inc.
    always @(posedge clk or posedge rst) begin
        if (rst)
            PC_reg <= 32'hffffffff;
        else
            PC_reg <= PC_next;
    end
    
    // Inst. Memory
    wire [31:0] inst_IF;
    inst_mem im(
        .clk(clk),
        .addr(PC),      // input address
        .inst(inst_IF)  // output instruction location
    );
    
    // ----------- IF/ID buffer -----------
    wire [31:0] PC_ID;
    wire [31:0] inst_ID;
    
    if_id IF_ID(
        .clk(clk),
        .rst(rst),
        .PC_in(PC),
        .inst_in(inst_IF),
        .PC_out(PC_ID),
        .inst_out(inst_ID)
    );
    
    // ----------- ID STAGE -----------
    wire [3:0] opcode   = inst_ID[`OPCODE_MSB:`OPCODE_LSB];
    wire [5:0] rs       = inst_ID[`RS_MSB:`RS_LSB];
    wire [5:0] rt       = inst_ID[`RT_MSB:`RT_LSB];
    wire [5:0] rd       = inst_ID[`RD_MSB:`RD_LSB];
    wire [31:0] rs_val_ID, rt_val_ID;
    
    wire [2:0] WB_WB;
    wire [5:0] rd_WB;
    wire [31:0] WB_data;
    
    reg_file regfile(
        .clk(clk),
        // Signal(s)
        .RegWrite(WB_WB[0]),
        // Data In
        .rs_addr(rs),
        .rt_addr(rt),
        .rd_addr(rd_WB),
        // Data Out
        .write_data(WB_data),
        .rs_data(rs_val_ID),
        .rt_data(rt_val_ID)
    );
    
    // UNIT: Imm Gen.
    wire [31:0] imm_val_ID;
    imm_gen ig(
        .inst(inst_ID),
        .imm(imm_val_ID)
    );
    
    // UNIT: Control Unit
    wire ALUSrc_cu, MemToReg_cu, RegWrite_cu, MemRead_cu, MemWrite_cu;
    wire SVPC_cu, Z_cu, N_cu, J_cu;
    wire [1:0] ALUOp_cu;
    
    control_unit cu(
        // Data In
        .opcode(opcode),
        // Data Out
        .ALUSrc(ALUSrc_cu),
        .MemToReg(MemToReg_cu),
        .RegWrite(RegWrite_cu),
        .MemRead(MemRead_cu),
        .MemWrite(MemWrite_cu),
        .ALUOp(ALUOp_cu),
        .SVPC(SVPC_cu),
        .Z(Z_cu),
        .N(N_cu),
        .J(J_cu)
    );
    
    // Control Signal Buses
    wire [2:0] WB_ID    = {SVPC_cu, MemToReg_cu, RegWrite_cu};
    wire [4:0] M_ID     = {J_cu, N_cu, Z_cu, MemRead_cu, MemWrite_cu};
    wire [2:0] EX_ID    = {ALUOp_cu, ALUSrc_cu};
    
    // ----------- ID/EX buffer -----------
    wire [2:0]  WB_EX;
    wire [4:0]  M_EX;
    wire [2:0]  EX_EX;
    wire [31:0] PC_EX, rs_val_EX, rt_val_EX;
    wire [31:0] imm_EX;
    wire [5:0]  rd_EX;
    
    id_ex ID_EX(
        // Signal(s)
        .clk(clk),
        .rst(rst),
        // Control Signals
        .WB_in(WB_ID),
        .M_in(M_ID),
        .EX_in(EX_ID),
        // Data In
        .PC_in(PC_ID),
        .rs_data_in(rs_val_ID),
        .rt_data_in(rt_val_ID),
        .imm_in(imm_val_ID),
        .rd_in(rd),
        // Data Out
        .WB_out(WB_EX),
        .M_out(M_EX),
        .EX_out(EX_EX),
        .PC_out(PC_EX),
        .rs_data_out(rs_val_EX),
        .rt_data_out(rt_val_EX),
        .imm_out(imm_EX),
        .rd_out(rd_EX)
    );
    
    // ----------- EX STAGE -----------
    wire [1:0] ALUOp = EX_EX[2:1];
    wire ALUSrc = EX_EX[0];
    
    // Unpack Signal for Mem Stage
    wire N_cu_EX = M_EX[3];
    wire Z_cu_EX = M_EX[2];
    
    // UNIT: ALU Control
    wire add, sub, neg;
    alu_control alu_ctrl(
        .ALUOp(ALUOp),
        .add(add),
        .sub(sub),
        .neg(neg)
    );
    
    // MUX: ALU second input (B)
    wire [31:0] alu_B_in = (ALUSrc) ? imm_EX : rt_val_EX;
    
    // ALU
    wire [31:0] alu_out_EX; // ALU results
    wire Z_EX, N_EX;        // flags
    
    ALU alu(
        // Signals
        .add(add),
        .sub(sub),
        .neg(neg),
        // Data In
        .A(rs_val_EX),
        .B(alu_B_in),
        // Data Out
        .out(alu_out_EX),
        .Z(Z_EX),
        .N(N_EX)
    );
    
    // Adder
    wire [31:0] PC_imm_EX = PC_EX + imm_EX;

    // ----------- EX/MEM buffer -----------
    wire [31:0] alu_out_MEM, PC_imm_MEM, rs_val_MEM, rt_val_MEM;
    wire [2:0]  WB_MEM;
    wire [4:0]  M_MEM;
    wire        N_flag_MEM, Z_flag_MEM;
    wire [5:0]  rd_MEM;
    
    ex_mem EX_MEM(
        // Signal(s)
        .clk(clk),
        .rst(rst),
        // Data In
        .WB_in(WB_EX),
        .M_in(M_EX),
        .PC_imm_in(PC_imm_EX),
        .N_in(N_EX),
        .Z_in(Z_EX),
        .OUT_in(alu_out_EX),
        .rt_in(rt_val_EX),
        .rs_in(rs_val_EX),
        .rd_in(rd_EX),
        // Data out
        .WB_out(WB_MEM),
        .M_out(M_MEM),
        .PC_imm_out(PC_imm_MEM),
        .N_out(N_flag_MEM),
        .Z_out(Z_flag_MEM),
        .OUT_out(alu_out_MEM),
        .rt_out(rt_val_MEM),
        .rs_out(rs_val_MEM),
        .rd_out(rd_MEM)
    );
    
    // ----------- MEM STAGE -----------
    wire J_cu_MEM           = M_MEM[4];
    wire N_cu_MEM           = M_MEM[3];
    wire Z_cu_MEM           = M_MEM[2];
    wire MemRead_cu_MEM     = M_MEM[1];
    wire MemWrite_cu_MEM    = M_MEM[0];
    
    wire [31:0] mem_data_MEM;
    
    data_memory dm(
        .clk(clk),
        // Data In
        .MemWrite(MemWrite_cu_MEM),
        .MemRead(MemRead_cu_MEM),
        .addr(alu_out_MEM),
        .write_data(rt_val_MEM),
        // Data Out
        .read_data(mem_data_MEM)        
    );
    
    // Set the PCSrc with "logic gates"
    wire go_branch = ((Z_cu_EX & Z_flag_MEM) | (N_cu_EX & N_flag_MEM));
    assign PCSrc = J_cu_MEM | go_branch;
    assign branch_target = (J_cu_MEM) ? rs_val_MEM : rs_val_EX;
    
    // ----------- MEM/WB buffer -----------
    wire [31:0] alu_res_WB, mem_data_WB, PC_imm_WB;
    
    mem_wb MEM_WB(
        // Signal(s)
        .clk(clk),
        .rst(rst),
        // Data In
        .WB_in(WB_MEM),
        .PC_imm_in(PC_imm_MEM),
        .read_data_in(mem_data_MEM),
        .ALU_res_in(alu_out_MEM),
        .rd_in(rd_MEM),
        // Data Out
        .WB_out(WB_WB),
        .PC_imm_out(PC_imm_WB),
        .read_data_out(mem_data_WB),
        .ALU_res_out(alu_res_WB),
        .rd_out(rd_WB)
    );
    
    // ----------- WB STAGE -----------
    wire SVPC_WB        = WB_WB[2];
    wire MemToReg_WB    = WB_WB[1];
    // MemToReg 0 - ALU_res_WB, 1 - mem_data_WB; SVPC 0 - MemToReg, 1- PC_imm_WB
    assign WB_data = (SVPC_WB)? PC_imm_WB : 
                           (MemToReg_WB)? mem_data_WB : alu_res_WB;
endmodule
