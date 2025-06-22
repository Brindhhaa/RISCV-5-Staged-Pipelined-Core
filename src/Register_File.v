//This module serves as a small memory block made of 32 registers
//Each register holds 32 bits

//It lets you read 2 registers at the same time, given 2 5-bit addresses A1 and A2. 
//It then outputs the values stored at those addresses, RD1 and RD2
//If rst is low, both read outputs are forced to 0

//It also lets you write to one register on each clock cycle. 
//You need to provide a write address, A3, and the data to write WD3
//If the write enable signal WE3 is high, then writing is enabled. 
//On the next rising clock edge it stored WD3 into the register stored at A3


module Register_File(clk,rst,WE3,WD3,A1,A2,A3,RD1,RD2);

    input clk,rst,WE3;
    input [4:0]A1,A2,A3;
    input [31:0]WD3;
    output [31:0]RD1,RD2;

    reg [31:0] Register [31:0];

    always @ (posedge clk)
    begin
        if(WE3)
            Register[A3] <= WD3;
    end

    assign RD1 = (~rst) ? 32'd0 : Register[A1];
    assign RD2 = (~rst) ? 32'd0 : Register[A2];

    initial begin
        Register[5] = 32'h00000005;
        Register[6] = 32'h00000004;
        
    end

endmodule