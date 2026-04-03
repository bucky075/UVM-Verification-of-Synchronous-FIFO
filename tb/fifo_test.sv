class fifo_test extends uvm_test;
  `uvm_component_utils(fifo_test)

  fifo_env env;

  function new(string name = "fifo_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = fifo_env::type_id::create("env", this);
  endfunction

  task run_phase(uvm_phase phase);
    fifo_stress_sequence seq;
    int i;

    phase.raise_objection(this);

    for (i = 0; i < 3; i++) begin
      seq = fifo_stress_sequence::type_id::create($sformatf("seq_%0d", i));
      seq.start(env.agt.seqr);
    end

    repeat (5) @(posedge env.agt.drv.vif.clk);

    phase.drop_objection(this);
  endtask

endclass
