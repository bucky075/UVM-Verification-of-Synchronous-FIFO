class fifo_env extends uvm_env;
  `uvm_component_utils(fifo_env)

  fifo_agent      agt;
  fifo_scoreboard sb;
  fifo_cov        cov;

  function new(string name = "fifo_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    agt = fifo_agent::type_id::create("agt", this);
    sb  = fifo_scoreboard::type_id::create("sb", this);
    cov = fifo_cov::type_id::create("cov", this);

    uvm_config_db#(uvm_active_passive_enum)::set(this, "agt", "is_active", UVM_ACTIVE);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    agt.ap.connect(sb.analysis_export);
    agt.ap.connect(cov.analysis_export);
  endfunction

endclass