//This basically says which environments and sequences are being used 


class pipeline_test extends uvm_test;
  `uvm_component_utils(pipeline_test)

  pipeline_env env;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    env = pipeline_env::type_id::create("env", this);
  endfunction
endclass
