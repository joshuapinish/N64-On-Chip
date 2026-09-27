interface n64oc_bus_if #(
  parameter int AW = 32,
  parameter int DW = 64
)(
  input logic clk
);
  logic valid;
  logic ready;
  logic write;
  logic [AW-1:0] addr;
  logic [DW-1:0] wdata;
  logic [DW/8-1:0] wstrb;
  logic [DW-1:0] rdata;
  logic error;
  modport master (output valid, write, addr, wdata, wstrb, input ready, rdata, error);
  modport slave (input valid, write, addr, wdata, wstrb, output ready, rdata, error);
endinterface
