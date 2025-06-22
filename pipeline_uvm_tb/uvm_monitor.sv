
class pipeline_monitor extends uvm_monitor;
  `uvm_component_utils(pipeline_monitor)

  virtual pipeline_if vif;
  uvm_analysis_port #(pipeline_sequence_item) analysis_port;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    analysis_port = new("analysis_port", this);
  endfunction

  function void build_phase(uvm_phase phase);
    if (!uvm_config_db#(virtual pipeline_if)::get(this, "", "vif", vif))
      `uvm_fatal("NOVIF", "No interface!")
  endfunction

  task run_phase(uvm_phase phase);
    pipeline_sequence_item item;
    forever begin
      @(posedge vif.clk);
      item = pipeline_sequence_item::type_id::create("item");
      item.instruction = vif.ALU_Result;
      analysis_port.write(item);
    end
  endtask
endclass
