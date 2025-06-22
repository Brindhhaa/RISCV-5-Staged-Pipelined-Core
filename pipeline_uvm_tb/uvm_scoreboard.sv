//standard for all UVM tests

class pipeline_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(pipeline_scoreboard)

  uvm_analysis_imp #(pipeline_sequence_item, pipeline_scoreboard) analysis_export;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    analysis_export = new("analysis_export", this);
  endfunction

  function void write(pipeline_sequence_item t);
    `uvm_info("SCOREBOARD", $sformatf("Observed output: %h", t.instruction), UVM_MEDIUM)
  endfunction
endclass
