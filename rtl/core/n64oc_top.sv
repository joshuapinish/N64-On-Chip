module n64oc_top (
  input  logic clk,
  input  logic reset_n,

  output logic        video_valid,
  output logic [23:0] video_rgb,
  output logic        video_hsync,
  output logic        video_vsync,

  output logic        audio_valid,
  output logic [15:0] audio_l,
  output logic [15:0] audio_r
);

  n64oc_test_video video_bringup (
    .clk(clk),
    .reset_n(reset_n),
    .valid(video_valid),
    .rgb(video_rgb),
    .hsync(video_hsync),
    .vsync(video_vsync)
  );

  always_comb begin
    audio_valid = 1'b0;
    audio_l = 16'd0;
    audio_r = 16'd0;
  end

endmodule
