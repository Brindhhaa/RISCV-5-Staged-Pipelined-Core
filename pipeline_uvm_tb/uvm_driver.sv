
class pipeline_driver extends uvm_driver #(pipeline_sequence_item);
  `uvm_component_utils(pipeline_driver)

  virtual pipeline_if vif;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    if (!uvm_config_db#(virtual pipeline_if)::get(this, "", "vif", vif))
      `uvm_fatal("NOVIF", "No interface!")
  endfunction

  task run_phase(uvm_phase phase);
    pipeline_sequence_item req;
    forever begin
      seq_item_port.get_next_item(req);
      vif.InstrMemData <= req.instruction;
      vif.InstrMemRead <= 1;
      @(posedge vif.clk);
      seq_item_port.item_done();
    end
  endtask
endclass
