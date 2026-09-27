module tb_n64oc_cart_rom;

  logic clk = 1'b0;
  logic reset_n = 1'b0;
  logic valid = 1'b0;
  logic [31:0] addr = 32'd0;
  logic ready;
  logic [63:0] rdata;

  n64oc_cart_rom #(
    .ROM_WORDS(4),
    .ROM_HEX("sim/data/cart_test.hex")
  ) dut (
    .clk, .reset_n, .valid, .addr, .ready, .rdata
  );

  always #5 clk = ~clk;

  initial begin
    repeat (2) @(posedge clk);
    reset_n = 1'b1;

    @(negedge clk);
    valid = 1'b1;
    addr = 32'd0;

    @(posedge clk);
    #1;
    if (!ready || rdata !== 64'h1122334455667788)
      $fatal(1, "ROM word 0 mismatch: ready=%b data=%h", ready, rdata);

    @(negedge clk);
    addr = 32'd8;

    @(posedge clk);
    #1;
    if (!ready || rdata !== 64'hDEADBEEFCAFEBABE)
      $fatal(1, "ROM word 1 mismatch: ready=%b data=%h", ready, rdata);

    $display("Cartridge ROM smoke test passed");
    $finish;
  end
endmodule
