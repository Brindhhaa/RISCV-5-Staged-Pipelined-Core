module fetch_cycle(clk, rst, PCSrcE, PCTargetE, InstrD, PCD, PCPlus4D);

    //declare the inputs and the outputs
    input clk, rst;
    input PCSrcE;
    input [31:0] PCTargetE;
    output [31:0] InstrD;
    output [31:0] PCD, PCPlus4D;

    //declare the interim wires
    wire [31:0] PC_F, PCF, PCPlus4F
    wire [31:0] InstrF;

    //declare registers for pipelining the fetch stage
    reg [31:0] InstrF_reg;
    reg [31:0] PCF_reg, PCPlus4F_reg;

    //declaring PC Mux. Using the Mux module
    MUX PC_MUX(
        .a(PCPlus4F),
        .b(PCTargetE),
        .s(PCSrcE),
        .c(PC_F)
    );

    //declare PC Counter
    PC_Module Program_Counter (
        .clk(clk),
        .rst(rst),
        .PC(PCF),
        .PC_next(PC_F)
    );
  
    //declare instruction memory 
    Instruction_Memory IMEM (
        .rst(rst),
        .A(PCF),
        .RD(InstrF),
    );


    //Declare PC adder
    PC_Adder PC_adder(
        .a(PCF),
        .b(32'h00000004),
        .c(PCPlus4F),
    );

    //Fetch Cycle Register Logic
    //On a positive  edge of a clock or a negative edge of reset 
    always @(posedge clk or negedge rst) begin
        if(rst == 1'b0) begin
            InstrF_reg <= 32'h00000000;
            PCF_reg <= 32'h00000000;
            PCPlus4F_reg <= 32'h00000000;
        end
        else begin
            InstrF_reg <= InstrF;
            PCF_reg <= PCF;
            PCPlus4F_reg <= PCPlus4F;
        end

    end

//assigning the output ports the correct values
assign  InstrD = (rst == 1'b0) ? 32'h00000000 : InstrF_reg;
assign  PCD = (rst == 1'b0) ? 32'h00000000 : PCF_reg;
assign  PCPlus4D = (rst == 1'b0) ? 32'h00000000 : PCPlus4F_reg;


endmodule
