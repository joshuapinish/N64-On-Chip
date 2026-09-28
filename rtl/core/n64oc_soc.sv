module n64oc_soc #(
  parameter int RDRAM_BYTES = 8 * 1024 * 1024,
  parameter string BOOT_ROM_HEX = ""
)(
  input logic clk,
  input logic reset_n,
  output logic halted,
  output logic [63:0] debug_pc,
  output logic [63:0] debug_r1,
  output logic [63:0] debug_r2,
  output logic [63:0] debug_r3,
  output logic [63:0] debug_r4
);

  logic        mem_valid, mem_write, mem_ready;
  logic [63:0] mem_addr, mem_wdata, mem_rdata;
  logic [7:0]  mem_wstrb;

  logic        boot_ready;
  logic [63:0] boot_rdata;
  logic        ram_ready;
  logic [63:0] ram_rdata;

  logic boot_sel;
  logic ram_sel;

  assign boot_sel = mem_valid &&
                    (mem_addr >= 64'h0000_0000_BFC0_0000) &&
                    (mem_addr < 64'h0000_0000_BFC0_1000);

  assign ram_sel = mem_valid && (mem_addr < 64'h0000_0000_0080_0000);

  assign mem_ready = boot_sel ? boot_ready :
                     ram_sel  ? ram_ready  : 1'b0;

  assign mem_rdata = boot_sel ? boot_rdata :
                     ram_sel  ? ram_rdata  : 64'd0;

  n64oc_mips_core cpu (
    .clk,
    .reset_n,
    .mem_valid,
    .mem_write,
    .mem_addr,
    .mem_wdata,
    .mem_wstrb,
    .mem_ready,
    .mem_rdata,
    .halted,
    .debug_pc,
    .debug_r1,
    .debug_r2,
    .debug_r3,
    .debug_r4
  );

  n64oc_bootrom #(
    .WORDS(1024),
    .ROM_HEX(BOOT_ROM_HEX)
  ) bootrom (
    .clk,
    .reset_n,
    .valid(boot_sel),
    .addr(mem_addr),
    .ready(boot_ready),
    .rdata(boot_rdata)
  );

  n64oc_rdram #(
    .BYTES(RDRAM_BYTES)
  ) rdram (
    .clk,
    .reset_n,
    .valid(ram_sel),
    .write(mem_write),
    .addr(mem_addr[31:0]),
    .wdata(mem_wdata),
    .wstrb(mem_wstrb),
    .ready(ram_ready),
    .rdata(ram_rdata)
  );

endmodule
