# Custom ISA

An implementation following a custom 32-bit pipelined Instruction Set Architecture (ISA) written using Verilog (Vivado).

## Overview
- 32-bit architecture with **64 registers (x0–x63)**
- Word-addressed memory
- 32-bit fixed instruction format: `imm val (10) | rd (6) | rs (6) | rt (6) | opcode (4)`
- Supports **11 core instructions**:  
  `NOP, SVPC, LD, ST, ADD, INC, NEG, SUB, J, BRZ, BRN`
- Includes ALU truth table, pipeline requirements, and CPU characteristics
- Supports assembly authoring, datapath/control design, and CPU testing

## CPU Characteristics
- Word-indexed PC and memory addressing  
- Branch instructions use Zero/Negative flags from the **previous** ALU instruction  
- Designed to support benchmark testing (e.g., median stencil program)

## Instruction Summary
| Instruction | Purpose |
|------------|--------|
| NOP | No operation |
| SVPC | Save PC + offset |
| ST / LD | Memory store / load |
| ADD / INC / SUB / NEG | Arithmetic |
| J | Unconditional jump |
| BRZ / BRN | Conditional branches |

## Project Components
- Assembly programs (Median stencil)
- Datapath + control logic
- Verilog CPU implementation
- Report & Testbench + waveform validation
- CPI and timing analysis

### Report
Read full report [here](./ISA_Report_AustinKim.pdf).
