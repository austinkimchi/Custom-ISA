//////////////////////////////////////////////////////////////////////////////////
// Company: Santa Clara University
// Engineer: Austin Kim
// Create Date: 10/09/2025 10:05:56 AM
// Design Name: SCU Arch Definitions
// Project Name: Project - Fall 2025
//////////////////////////////////////////////////////////////////////////////////
`ifndef SCU_DEF_VH
`define SCU_DEF_VH

`define OPCODE_LSB    0
`define OPCODE_MSB    3

`define RT_LSB        4
`define RT_MSB        9

`define RS_LSB        10
`define RS_MSB        15

`define RD_LSB        16
`define RD_MSB        21

`define IMM_LSB       22
`define IMM_MSB       31

// OPCodes
`define OP_NOP        4'b0000  // (1)  No operation        : -
`define OP_SVPC       4'b1111  // (2)  Save PC             : rd <- PC + y
`define OP_LD         4'b1110  // (3)  Load                : rd <- M[rs+y]
`define OP_ST         4'b0011  // (4)  Store               : M[rs+y] <- rt
`define OP_ADD        4'b0100  // (5)  Add                 : rd <- rs + rt
`define OP_INC        4'b0101  // (6)  Increment           : rd <- rs + rt
`define OP_NEG        4'b0110  // (7)  Negate              : rd <- rs
`define OP_SUB        4'b0111  // (8)  Subtract            : rd <- rs -rt
`define OP_J          4'b1000  // (9)  Jump                : PC <- rs
`define OP_BRZ        4'b1001  // (10) Branch if Zero      : PC <- rs, if Z = 1
`define OP_BRN        4'b1010  // (11) Branch if Negative  : PC <- rs, if N = 1

`endif // SCU_DEF_VH
