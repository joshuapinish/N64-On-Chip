module tb_n64oc_soc;

  logic clk = 1'b0;
  logic reset_n = 1'b0;
  logic halted;
  logic [63:0] debug_pc, debug_r1, debug_r2, debug_r3, debug_r4;

  n64oc_soc #(
    .BOOT_ROM_HEX("sim/data/boot_test.hex")
  ) dut (
    .clk,
    .reset_n,
    .halted,
    .debug_pc,
    .debug_r1,
    .debug_r2,
    .debug_r3,
    .debug_r4
  );

  always #5 clk = ~clk;

  initial begin
    repeat (3) @(posedge clk);
    reset_n = 1'b1;

    wait (halted);
    #1;

    if (debug_r1 !== 64'h1234)
      $fatal(1, "boot r1 mismatch: %h", debug_r1);
    if (debug_r2 !== 64'h1234)
      $fatal(1, "boot r2 mismatch: %h", debug_r2);
    if (debug_r3 !== 64'h2468)
      $fatal(1, "boot r3 mismatch: %h", debug_r3);

    $display("SoC boot test passed: reset vector executed and RDRAM round-trip worked");
    $display("  PC=%h r1=%h r2=%h r3=%h", debug_pc, debug_r1, debug_r2, debug_r3);
    $finish;
  end

  initial begin
    #5000;
    $fatal(1, "SoC boot test timed out");
  end

endmodule
