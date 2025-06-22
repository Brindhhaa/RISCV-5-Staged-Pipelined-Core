//standard for all UVM tests

class pipeline_env extends uvm_env;
  `uvm_component_utils(pipeline_env)

  pipeline_agent agent;
  pipeline_scoreboard scoreboard;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agent = pipeline_agent::type_id::create("agent", this);
    scoreboard = pipeline_scoreboard::type_id::create("scoreboard", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    agent.monitor.analysis_port.connect(scoreboard.analysis_export);
  endfunction
endclass
