//this class instantiates the interface, instantiates the DUT, and starts the UVM process.
`include "uvm_macros.svh"
`include "pipeline_if.sv"
`include "uvm_env.sv"
`include "pipeline_top.sv"

module pipeline_testbench;

  bit clk;
  bit rst;

  pipeline_if pipeline_if(clk, rst);

  pipeline_top DUT (
    .clk(clk),
    .rst(rst)
    // Connect other ports accordingly
  );

  initial clk = 0;
  always #5 clk = ~clk;

  initial begin
    rst = 1;
    #20;
    rst = 0;
  end

  initial begin
    run_test("pipeline_test");
  end

endmodule
