module branch_prediction_unit (
    input clk,
    input rst,
    input wire[63:0] pc,
    input wire[31:0] instruction,
    input wire[63:0] response_pc,
    input wire response_branch_taken,
    input wire response_branch_enable,
    output reg[63:0] branch_pc,
    output wire predict_branch_taken
);
    parameter B_TYPE = 7'b1100011;

    wire[63:0] imm = ({ {52{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8] }) << 1;
    assign branch_pc = pc + imm;
    reg [1:0] bht[0:63]; // Branch History Table

    wire[6:0] opcode = instruction[6:0];

    wire[5:0] pc_LSB = pc[7:2];
    wire[5:0] response_pc_LSB = response_pc[7:2];

    assign predict_branch_taken = (opcode == B_TYPE) & (bht[pc_LSB][1]);


    always_ff@(posedge clk) begin
        if(rst) for(int i = 0; i < 64; i++) bht[i] <= 3'b10; // Default is weakly taken 
        if(response_branch_enable) begin
            case (bht[response_pc_LSB])
                2'b00: bht[response_pc_LSB] <= response_branch_taken ? 2'b01 : 2'b00;
                2'b01: bht[response_pc_LSB] <= response_branch_taken ? 2'b10 : 2'b00;
                2'b10: bht[response_pc_LSB] <= response_branch_taken ? 2'b11 : 2'b01;
                2'b11: bht[response_pc_LSB] <= response_branch_taken ? 2'b11 : 2'b10;
                default: bht[response_pc_LSB] <= bht[response_pc_LSB];
            endcase
        end 
    end
    
endmodule