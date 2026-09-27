module n64oc_mips_core #(
  parameter logic [63:0] RESET_PC = 64'h0000_0000_BFC0_0000
)(
  input  logic clk,
  input  logic reset_n,
  output logic        mem_valid,
  output logic        mem_write,
  output logic [63:0] mem_addr,
  output logic [63:0] mem_wdata,
  output logic [7:0]  mem_wstrb,
  input  logic        mem_ready,
  input  logic [63:0] mem_rdata,
  output logic        halted
);

  logic [63:0] r[0:31];
  logic [63:0] pc, next_pc;
  logic        delay_active;
  logic [63:0] delay_target;
  logic        waiting_load;
  logic [4:0]  load_rd;
  logic [63:0] load_value;
  integer i;

  logic [31:0] insn;
  logic [5:0] op, fn;
  logic [4:0] rs, rt, rd, shamt;
  logic signed [63:0] s_rs, s_rt;
  logic [15:0] imm;
  logic [25:0] target;

  assign mem_valid = !halted && (!waiting_load);
  assign mem_write = mem_valid && (op == 6'h2B || op == 6'h3F);
  assign mem_addr  = pc;
  assign mem_wdata = r[rt];
  assign mem_wstrb = mem_write ? 8'hFF : 8'h00;

  assign insn = mem_rdata[31:0];
  assign op = insn[31:26];
  assign rs = insn[25:21];
  assign rt = insn[20:16];
  assign rd = insn[15:11];
  assign shamt = insn[10:6];
  assign fn = insn[5:0];
  assign imm = insn[15:0];
  assign target = insn[25:0];
  assign s_rs = $signed(r[rs]);
  assign s_rt = $signed(r[rt]);

  always_ff @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
      pc <= RESET_PC;
      next_pc <= RESET_PC + 64'd4;
      delay_active <= 1'b0;
      delay_target <= '0;
      waiting_load <= 1'b0;
      load_rd <= '0;
      load_value <= '0;
      halted <= 1'b0;
      for (i = 0; i < 32; i = i + 1) r[i] <= '0;
    end else if (!halted) begin
      r[0] <= 64'd0;

      if (waiting_load) begin
        if (mem_ready) begin
          if (load_rd != 0) r[load_rd] <= mem_rdata;
          waiting_load <= 1'b0;
          pc <= next_pc;
        end
      end else if (mem_ready) begin
        logic branch_taken;
        logic [63:0] branch_target;
        branch_taken = 1'b0;
        branch_target = '0;

        case (op)
          6'h00: begin
            case (fn)
              6'h00: r[rd] <= r[rt] << shamt;
              6'h02: r[rd] <= r[rt] >> shamt;
              6'h03: r[rd] <= $signed(r[rt]) >>> shamt;
              6'h08: begin branch_taken = 1'b1; branch_target = r[rs]; end
              6'h09: begin r[rd] <= next_pc; branch_taken = 1'b1; branch_target = r[rs]; end
              6'h21: r[rd] <= r[rs] + r[rt];
              6'h23: r[rd] <= r[rs] - r[rt];
              6'h24: r[rd] <= r[rs] & r[rt];
              6'h25: r[rd] <= r[rs] | r[rt];
              6'h26: r[rd] <= r[rs] ^ r[rt];
              6'h27: r[rd] <= ~(r[rs] | r[rt]);
              6'h2A: r[rd] <= (s_rs < s_rt) ? 64'd1 : 64'd0;
              6'h0D: halted <= 1'b1;
              default: halted <= 1'b1;
            endcase
          end
          6'h02: begin branch_taken = 1'b1; branch_target = {next_pc[63:28], target, 2'b00}; end
          6'h03: begin r[31] <= next_pc; branch_taken = 1'b1; branch_target = {next_pc[63:28], target, 2'b00}; end
          6'h04: if (r[rs] == r[rt]) begin branch_taken = 1'b1; branch_target = next_pc + {{46{imm[15]}}, imm, 2'b00}; end
          6'h05: if (r[rs] != r[rt]) begin branch_taken = 1'b1; branch_target = next_pc + {{46{imm[15]}}, imm, 2'b00}; end
          6'h08, 6'h09: r[rt] <= r[rs] + {{48{imm[15]}}, imm};
          6'h0C: r[rt] <= r[rs] & {48'd0, imm};
          6'h0D: r[rt] <= r[rs] | {48'd0, imm};
          6'h0E: r[rt] <= r[rs] ^ {48'd0, imm};
          6'h0F: r[rt] <= {imm, 48'd0};
          6'h23: begin
            waiting_load <= 1'b1;
            load_rd <= rt;
            load_value <= {{32{mem_rdata[31]}}, mem_rdata[31:0]};
          end
          6'h37: begin
            waiting_load <= 1'b1;
            load_rd <= rt;
            load_value <= mem_rdata;
          end
          6'h2B, 6'h3F: begin end
          default: halted <= 1'b1;
        endcase

        if (waiting_load == 1'b0) begin
          pc <= next_pc;
          next_pc <= next_pc + 64'd4;
        end

        if (branch_taken) begin
          delay_active <= 1'b1;
          delay_target <= branch_target;
        end

        if (delay_active) begin
          pc <= delay_target;
          next_pc <= delay_target + 64'd4;
          delay_active <= 1'b0;
        end
      end
    end
  end
endmodule
