
//this class is standard for all UVM tests

class pipeline_agent extends uvm_agent;
  `uvm_component_utils(pipeline_agent)

  pipeline_driver driver;
  pipeline_monitor monitor;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    driver = pipeline_driver::type_id::create("driver", this);
    monitor = pipeline_monitor::type_id::create("monitor", this);
  endfunction
endclass
