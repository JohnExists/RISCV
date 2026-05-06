module branch_prediction_unit (
    input clk,
    input rst,
    // Input for finding where to predict branch taken or not
    input wire[31:0] pc,
    input wire[31:0] instruction,

    // Input For EX_result to update bht
    input wire[31:0] EX_result_pc,
    input wire EX_result_conditional_branch_taken,
    input wire EX_result_branch_enable,

    output reg[31:0] branch_pc,
    output wire predict_branch_taken,
    output wire branch_stall_pipeline
);
   localparam JAL = 7'b1101111;
   localparam B_TYPE = 7'b1100011; // BEQ, BNE, BLT, BGE, BLTU, BGEU
   localparam JALR = 7'b1100111;

   reg [1:0] bht[0:31]; // Branch History Table

   wire[6:0] opcode = instruction[6:0];

   wire[5:0] pc_LSB = pc[7:2];
   wire[5:0] EX_result_pc_LSB = EX_result_pc[7:2];

    wire[31:0] imm_b = ({ {20{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8] }) << 1;
    wire[31:0] imm_uj= ({ {12{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:21]  }) << 1;
    assign branch_pc = opcode[2] ? pc + imm_uj : pc + imm_b; // JAL has bit 2 of the instruction as 1, BEQ, BGE, etc has it as 0

   assign predict_branch_taken = (opcode == B_TYPE & bht[pc_LSB][1]) | opcode == JAL;
   assign branch_stall_pipeline = opcode == JALR;

   always_ff@(posedge clk) begin
       if(rst) for(int i = 0; i < 32; i++) bht[i] <= 3'b10; // Default is weakly taken 
       if(EX_result_branch_enable) begin
           case (bht[EX_result_pc_LSB])
               2'b00: bht[EX_result_pc_LSB] <= EX_result_conditional_branch_taken ? 2'b01 : 2'b00;
               2'b01: bht[EX_result_pc_LSB] <= EX_result_conditional_branch_taken ? 2'b10 : 2'b00;
               2'b10: bht[EX_result_pc_LSB] <= EX_result_conditional_branch_taken ? 2'b11 : 2'b01;
               2'b11: bht[EX_result_pc_LSB] <= EX_result_conditional_branch_taken ? 2'b11 : 2'b10;
               default: bht[EX_result_pc_LSB] <= bht[EX_result_pc_LSB];
           endcase
       end 
   end
    
endmodule