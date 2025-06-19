//This module is a register that keeps track of the PC. 
//On every rising edge of the clock, the PC updates
//If the reset signal is 0, then the PC is cleared to 0. 
//If the reset signal is 1, then the PC is updated to PC_Next
//The reset is active low. Meaning when it is 0, the PC is reset, when it's 1, it's inactive.


module PC_Module(clk,rst,PC,PC_Next);
    input clk,rst;
    input [31:0]PC_Next;
    output [31:0]PC;
    reg [31:0]PC;

    always @(posedge clk)
    begin
        if(~rst)
            PC <= {32{1'b0}};
        else
            PC <= PC_Next;
    end
endmodule

