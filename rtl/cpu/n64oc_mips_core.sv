module n64oc_mips_core #(
  parameter logic [63:0] RESET_PC = 64'h0000_0000_BFC0_0000
)(
  input logic clk,
  input logic reset_n,
  output logic        mem_valid,
  output logic        mem_write,
  output logic [63:0] mem_addr,
  output logic [63:0] mem_wdata,
  output logic [7:0]  mem_wstrb,
  input  logic        mem_ready,
  input logic [63:0] mem_rdata,
  output logic        halted,
  output logic [63:0] debug_pc,
  output logic [63:0] debug_r1,
  output logic [63:0] debug_r2,
  output logic [63:0] debug_r3,
  output logic [63:0] debug_r4
);

  typedef enum logic [1:0] {S_FETCH, S_LOAD, S_STORE} state_t;
  state_t state;

  logic [63:0] r[0:31];
  logic [63:0] pc;
  logic [63:0] seq_pc;
  logic        branch_pending;
  logic [63:0] branch_target;
  logic [4:0]  load_rd;
  logic        load_signed;
  logic [63:0] data_addr;
  logic [63:0] data_wdata;
  logic [7:0]  data_wstrb;
  integer i;

  logic [31:0] insn;
  logic [5:0] op, fn;
  logic [4:0] rs, rt, rd, shamt;
  logic [15:0] imm;
  logic [25:0] target;

  assign mem_valid = !halted;
  assign mem_write = (state == S_STORE);
  assign mem_addr  = (state == S_FETCH) ? pc : data_addr;
  assign mem_wdata = data_wdata;
  assign mem_wstrb = (state == S_STORE) ? data_wstrb : 8'h00;

  assign insn = mem_rdata[31:0];
  assign op = insn[31:26];
  assign rs = insn[25:21];
  assign rt = insn[20:16];
  assign rd = insn[15:11];
  assign shamt = insn[10:6];
  assign fn = insn[5:0];
  assign imm = insn[15:0];
  assign target = insn[25:0];

  assign halted = (state === S_FETCH) ? halted_reg : halted_reg;

  logic halted_reg;
  assign debug_pc = pc;
  assign debug_r1 = r[1];
  assign debug_r2 = r[2];
  assign debug_r3 = r[3];
  assign debug_r4 = r[4];

  always_ff @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
      state <= S_FETCH;
      pc <= RESET_PC;
      seq_pc <= RESET_PC + 64'd4;
      branch_pending <= 1'b0;
      branch_target <= '0;
      load_rd <= '0;
      load_signed <= 1'b0;
      data_addr <= '0;
      data_wdata <= '0;
      data_wstrb <= '0;
      halted_reg <= 1'b0;
      for (i = 0; i < 32; i = i + 1) r[i] <= '0;
    end else if (!halted_reg) begin
      r[0] <= 64'd0;

      if (mem_ready) begin
        case (state)
          S_FETCH: begin
            logic take_branch;
            logic [63:0] new_target;
            take_branch = 1'b0;
            new_target = '0;

            case (op)
              6'h00: begin
                case (fn)
                  6'h00: r[rd] <= r[rt] << shamt;
                  6'h02: r[rd] <= r[rt] >> shamt;
                  6'h03: r[rd] <= $signed(r[rt]) >>> shamt;
                  6'h08: begin take_branch = 1'b1; new_target = r[rs]; end
                  6'h09: begin r[rd] <= seq_pc; take_branch = 1'b1; new_target = r[rs]; end
                  6'h21: r[rd] <= r[rs] + r[rt];
                  6'h23: r[rd] <= r[rs] - r[rt];
                  6'h24: r[rd] <= r[rs] & r[rt];
                  6'h25: r[rd] <= r[rs] | r[rt];
                  6'h26: r[rd] <= r[rs] ^ r[rt];
                  6'h27: r[rd] <= ~(r[rs] | r[rt]);
                  6'h2A: r[rd] <= ($signed(r[rs]) < $signed(r[rt])) ? 64'd1 : 64'd0;
                  6'h0D: halted_reg <= 1'b1;
                  default: halted_reg <= 1'b1;
                endcase
              end

              6'h02: begin take_branch = 1'b1; new_target = {seq_pc[63:28], target, 2'b00}; end
              6'h03: begin r[31] <= seq_pc; take_branch = 1'b1; new_target = {seq_pc[63:28], target, 2'b00}; end
              6'h04: if (r[rs] == r[rt]) begin take_branch = 1'b1; new_target = seq_pc + {{46{imm[15]}}, imm, 2'b00}; end
              6'h05: if (r[rs] != r[rt]) begin take_branch = 1'b1; new_target = seq_pc + {{46{imm[15]}}, imm, 2'b00}; end

              6'h08, 6'h09: r[rt] <= r[rs] + {{48{imm[15]}}, imm};
              6'h0C: r[rt] <= r[rs] & {48'd0, imm};
              6'h0D: r[rt] <= r[rs] | {48'd0, imm};
              6'h0E: r[rt] <= r[rs] ^ {48'd0, imm};
              6'h0F: r[rt] <= {imm, 48'd0};

              6'h23, 6'h37: begin
                data_addr <= r[rs] + {{48{imm[15]}}, imm};
                load_rd <= rt;
                load_signed <= (op == 6'h23);
                state <= S_LOAD;
              end

              6'h2B, 6'h3F: begin
                data_addr <= r[rs] + {{48{imm[15]}}, imm};
                data_wdata <= r[rt];
                data_wstrb <= (op == 6'h2B) ? 8'h0F : 8'hFF;
                state <= S_STORE;
              end

              default: halted_reg <= 1'b1;
            endcase

            if (state == S_FETCH && !halted_reg && op != 6'h23 && op != 6'h37 &&
                op != 6'h2B && op != 6'h3F) begin
              if (branch_pending) begin
                pc <= branch_target;
                seq_pc <= branch_target + 64'd4;
                branch_pending <= 1'b0;
              end else begin
                pc <= seq_pc;
                seq_pc <= seq_pc + 64'd4;
              end
              if (take_branch) begin
                branch_pending <= 1'b1;
                branch_target <= new_target;
              end
            end
          end

          S_LOAD: begin
            if (load_rd != 0) begin
              if (load_signed) r[load_rd] <= {{32{mem_rdata[31]}}, mem_rdata[31:0]};
              else r[load_rd] <= mem_rdata;
            end
            state <= S_FETCH;
            pc <= seq_pc;
            seq_pc <= seq_pc + 64'd4;
          end

          S_STORE: begin
            state <= S_FETCH;
            pc <= seq_pc;
            seq_pc <= seq_pc + 64'd4;
          end
        endcase
      end
    end
  end
endmodule
