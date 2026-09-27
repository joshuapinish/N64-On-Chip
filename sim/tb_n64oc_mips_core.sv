module tb_n64oc_mips_core;

  logic clk = 1'b0;
  logic reset_n = 1'b0;

  logic        mem_valid, mem_write, mem_ready, halted;
  logic [63:0] mem_addr, mem_wdata, mem_rdata;
  logic [7:0]  mem_wstrb;
  logic [63:0] debug_pc, debug_r1, debug_r2, debug_r3, debug_r4;

  logic [31:0] instr_mem [0:31];
  logic [63:0] data_mem [0:63];
  integer i;

  n64oc_mips_core #(.RESET_PC(64'd0)) dut (
    .clk, .reset_n,
    .mem_valid, .mem_write, .mem_addr, .mem_wdata, .mem_wstrb,
    .mem_ready, .mem_rdata, .halted,
    .debug_pc, .debug_r1, .debug_r2, .debug_r3, .debug_r4
  );

  always #5 clk = ~clk;

  always_comb begin
    mem_ready = mem_valid;
    mem_rdata = 64'd0;

    if (mem_addr < 64'h0000_0100)
      mem_rdata = {32'd0, instr_mem[mem_addr[6:2]]};
    else
      mem_rdata = data_mem[mem_addr[8:3]];
  end

  always_ff @(posedge clk) begin
    if (mem_valid && mem_write) begin
      if (mem_wstrb[0]) data_mem[mem_addr[8:3]][7:0]   <= mem_wdata[7:0];
      if (mem_wstrb[1]) data_mem[mem_addr[8:3]][15:8]  <= mem_wdata[15:8];
      if (mem_wstrb[2]) data_mem[mem_addr[8:3]][23:16] <= mem_wdata[23:16];
      if (mem_wstrb[3]) data_mem[mem_addr[8:3]][31:24] <= mem_wdata[31:24];
      if (mem_wstrb[4]) data_mem[mem_addr[8:3]][39:32] <= mem_wdata[39:32];
      if (mem_wstrb[5]) data_mem[mem_addr[8:3]][47:40] <= mem_wdata[47:40];
      if (mem_wstrb[6]) data_mem[mem_addr[8:3]][55:48] <= mem_wdata[55:48];
      if (mem_wstrb[7]) data_mem[mem_addr[8:3]][63:56] <= mem_wdata[63:56];
    end
  end

  initial begin
    for (i = 0; i < 32; i = i + 1) instr_mem[i] = 32'h0000_000D;
    for (i = 0; i < 64; i = i + 1) data_mem[i] = 64'd0;

    // addiu r1,r0,0x1234
    instr_mem[0] = 32'h2401_1234;
    // sd r1,0x100(r0)
    instr_mem[1] = 32'hFC01_0100;
    // ld r2,0x100(r0)
    instr_mem[2] = 32'hDC02_0100;
    // addu r3,r1,r2
    instr_mem[3] = 32'h0022_1821;
    // break
    instr_mem[4] = 32'h0000_000D;

    repeat (3) @(posedge clk);
    reset_n = 1'b1;

    wait (halted);
    #1;

    if (debug_r1 !== 64'h1234) $fatal(1, "r1 mismatch: %h", debug_r1);
    if (debug_r2 !== 64'h1234) $fatal(1, "r2 mismatch: %h", debug_r2);
    if (debug_r3 !== 64'h2468) $fatal(1, "r3 mismatch: %h", debug_r3);
    if (data_mem[32] !== 64'h1234) $fatal(1, "store mismatch: %h", data_mem[32]);

    $display("MIPS smoke test passed: r1=%h r2=%h r3=%h", debug_r1, debug_r2, debug_r3);
    $finish;
  end
endmodule
