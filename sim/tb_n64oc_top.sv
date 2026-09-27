module tb_n64oc_top;
  logic clk = 1'b0;
  logic reset_n = 1'b0;
  logic video_valid;
  logic [23:0] video_rgb;
  logic video_hsync;
  logic video_vsync;
  logic audio_valid;
  logic [15:0] audio_l;
  logic [15:0] audio_r;

  n64oc_top dut (
    .clk(clk), .reset_n(reset_n),
    .video_valid(video_valid), .video_rgb(video_rgb),
    .video_hsync(video_hsync), .video_vsync(video_vsync),
    .audio_valid(audio_valid), .audio_l(audio_l), .audio_r(audio_r)
  );

  always #5 clk = ~clk;

  initial begin
    repeat (4) @(posedge clk);
    reset_n = 1'b1;
    repeat (20) @(posedge clk);
    $display("N64-OC top-level smoke test passed");
    $finish;
  end
endmodule
