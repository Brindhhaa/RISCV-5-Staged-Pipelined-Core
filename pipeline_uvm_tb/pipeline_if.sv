
//declares all the input and output that connects the driver to the DUT and the DUT to the monitor. 
//Interfaces the DUT with the driver and the monitor
interface pipeline_if(input bit clk, input bit rst);
    logic [31:0] InstrMemData;
    logic InstrMemRead;
    logic [31:0] PC;
    logic [31:0] ALU_Result;
    logic [31:0] RegFileWriteData;
    logic [4:0]  RegFileWriteAddr;
    logic RegFileWriteEn;
endinterface
