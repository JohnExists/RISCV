module branch_target_buffer (
    input clk,
    input rst,
    // Input for finding where to predict branch taken or not
    input wire[31:0] pc,

    // Input For EX result to update btb
    input wire[31:0] EX_result_pc,
    input wire EX_result_conditional_branch_taken,
    input wire EX_result_branch_enable,

    output wire predict_branch_taken,
    output wire branch_stall_pipeline
);

endmodule
