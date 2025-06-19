//this is a 2 to 1 mux. 
//If s is 0, the output is a
//If s is 1, the output is b
module Mux (a,b,s,c);

    input [31:0]a,b;
    input s;
    output [31:0]c;

    assign c = (~s) ? a : b ;
    
endmodule