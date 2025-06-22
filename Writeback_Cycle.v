// In an ordinary pipelined RISC-V processor, the writeback stage must choose which value 
// to write back to a register: the ALU result for arithmetic operations, 
// the data read from memory for load instructions, or PC+4 for jump-and-link 
// instructions like JAL that need to save the return address. 
// This module currently uses a 2-to-1 mux that only switches between 
// the ALU result and memory data, so it ignores PCPlus4W and cannot 
// properly handle jump-and-link instructions. 
// To support RISC-V instruction types correctly, this should be a 3-to-1 mux 
// that selects between ALU_ResultW, ReadDataW, and PCPlus4W using a 2-bit selector.

module writeback_cycle(clk, rst, ResultSrcW, PCPlus4W, ALU_ResultW, ReadDataW, ResultW);

// Declaration of IOs
input clk, rst, ResultSrcW;
input [31:0] PCPlus4W, ALU_ResultW, ReadDataW;

output [31:0] ResultW;

// Declaration of Module
Mux result_mux (    
                .a(ALU_ResultW),
                .b(ReadDataW),
                .s(ResultSrcW),
                .c(ResultW)
                );
endmodule