# 32-bit MIPS Single-Cycle Processor

# Overview

This project implements a 32-bit single-cycle MIPS processor in VHDL. It supports a subset of the MIPS instruction set, executing each instruction in a single clock cycle.

# Features

Single-cycle architecture <br/> 

Implements key MIPS instructions (R-type, I-type, and basic J-type) <br/> 

32-bit data path <br/>

Separate instruction and data memories <br/> 

Support for ALU operations, memory access, and branching <br/>

# Supported Instructions

R-Type, I-Type, J-Type. See Control Signals Table for detailed view of all supported instructions. 

# Architecture

Program Counter (PC): Holds the address of the next instruction.  <br/>

Instruction Memory: Stores program instructions.  <br/> 

Register File: Contains 32 registers for computation.  <br/> 

ALU (Arithmetic Logic Unit): Performs arithmetic and logical operations.  <br/> 

Data Memory: Handles memory load (lw) and store (sw) operations.  <br/> 

Control Unit: Decodes instructions and generates control signals.  <br/> 

Multiplexers (MUXs): Used for data selection.  <br/> 

Sign Extender: Extends immediate values.  <br/> 

# Can be tested on any supported FPGA board. 
