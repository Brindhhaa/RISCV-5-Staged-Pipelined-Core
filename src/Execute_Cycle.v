module execute_cycle(clk, rst, RegWriteE, ALUSrcE, MemWriteE, ResultSrcE, BranchE, ALUControlE, 
    RD1_E, RD2_E, Imm_Ext_E, RD_E, PCE, PCPlus4E, PCSrcE, PCTargetE, RegWriteM, MemWriteM, ResultSrcM, RD_M, PCPlus4M, WriteDataM, ALU_ResultM, ResultW, ForwardA_E, ForwardB_E);

    input clk, rst, RegWriteE,ALUSrcE,MemWriteE,ResultSrcE,BranchE;
    input [2:0] ALUControlE;
    input [31:0] RD1_E, RD2_E, Imm_Ext_E;
    input [4:0] RD_E;
    input [31:0] PCE, PCPlus4E;
    input [31:0] ResultW;
    input [1:0] ForwardA_E, ForwardB_E;


    output PCSrcE, RegWriteM, MemWriteM, ResultSrcM;
    output [4:0] RD_M; 
    output [31:0] PCPlus4M, WriteDataM, ALU_ResultM;
    output [31:0] PCTargetE;

    //declare interim wires
    //Src_A is the first ALU input. Src_B is the second ALU input
    //Src_B_interim is the register value. Either the Src_B can be a register value (Src_B_interim) or an immediate (sign extended immediate).
    //A mux will choose which one to use.
    wire [31:0] Src_A, Src_B_interim, Src_B;
    wire [31:0] ResultE;
    wire ZeroE;


    // Declaration of Modules
    // 3 by 1 Mux for Source A
    // In a pipelined processor, sometimes an instruction in the Execute stage needs
    // a register value that a previous instruction is still working on or hasn't updated. The newest
    // value usually exists somewhere else in the pipeline — either the value is fresh out of the ALU
    // where it is waiting in the Memory stage, or it's in the ResultW bus and is
    // about to be written back to the register file in the Writeback stage.
    // This mux (srca_mux) picks the freshest value for the ALU's first input:
    // - If there's no dependency, it uses the normal register output RD1_E.
    // - If the needed value was just computed by the previous instruction,
    //   it grabs ALU_ResultM from the Memory stage.
    // - If the needed value is about to be written back this cycle, it grabs ResultW.
    // The signal ForwardA_E tells the mux which one to pick so the ALU gets the
    // right value immediately without waiting.
    Mux_3_by_1 srca_mux (
                        .a(RD1_E),
                        .b(ResultW),
                        .c(ALU_ResultM),
                        .s(ForwardA_E),
                        .d(Src_A)
                        );

    // 3 by 1 Mux for Source B
    // This mux does the same thing as the Source A mux. It chooses the second input
    // of the ALU. The second input, can come from three places:
    // - RD2_E: the normal register output if there’s no issue.
    // - ALU_ResultM: if the value was just computed by the last instruction
    //   and is sitting in the Memory stage.
    // - ResultW: if the value is in the bus to be written back to the register file right now.
    // ForwardB_E decides which to use so the ALU always works with the right data without any delay
    // The output of this mux is called Src_B_interim — it still might get replaced with an immediate if the instruction needs it.
    Mux_3_by_1 srcb_mux (
                        .a(RD2_E),
                        .b(ResultW),
                        .c(ALU_ResultM),
                        .s(ForwardB_E),
                        .d(Src_B_interim)
                        );
    
    
    // ALU Src Mux
    // After picking the correct register-based value for Source B, we still need
    // to decide whether the ALU should use that register value or an immediate number
    // This mux does exactly that:
    // - If ALUSrcE is 0, use Src_B_interim (the register value we just selected).
    // - If ALUSrcE is 1, use Imm_Ext_E (the sign-extended immediate).
    // This way, the ALU always gets the proper second operand depending on the
    // type of instruction being executed.
    Mux alu_src_mux (
            .a(Src_B_interim),
            .b(Imm_Ext_E),
            .s(ALUSrcE),
            .c(Src_B)
            );


    // ALU Unit
    ALU alu (
            .A(Src_A),
            .B(Src_B),
            .Result(ResultE),
            .ALUControl(ALUControlE),
            .OverFlow(),
            .Carry(),
            .Zero(ZeroE),
            .Negative()
            );

    // Adder
    PC_Adder branch_adder (
            .a(PCE),
            .b(Imm_Ext_E),
            .c(PCTargetE)
            );

    // Register Logic
    always @(posedge clk or negedge rst) begin
        if(rst == 1'b0) begin
            RegWriteE_r <= 1'b0; 
            MemWriteE_r <= 1'b0; 
            ResultSrcE_r <= 1'b0;
            RD_E_r <= 5'h00;
            PCPlus4E_r <= 32'h00000000; 
            RD2_E_r <= 32'h00000000; 
            ResultE_r <= 32'h00000000;
        end
        else begin
            RegWriteE_r <= RegWriteE; 
            MemWriteE_r <= MemWriteE; 
            ResultSrcE_r <= ResultSrcE;
            RD_E_r <= RD_E;
            PCPlus4E_r <= PCPlus4E; 
            RD2_E_r <= Src_B_interim; 
            ResultE_r <= ResultE;
        end
    end

    // Output Assignments
    assign PCSrcE = ZeroE &  BranchE;
    assign RegWriteM = RegWriteE_r;
    assign MemWriteM = MemWriteE_r;
    assign ResultSrcM = ResultSrcE_r;
    assign RD_M = RD_E_r;
    assign PCPlus4M = PCPlus4E_r;
    assign WriteDataM = RD2_E_r;
    assign ALU_ResultM = ResultE_r;

endmodule    