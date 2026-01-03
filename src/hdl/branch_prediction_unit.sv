module branch_prediction_unit (
    input wire[63:0] program_counter,
    input wire[31:0] instruction,
    output reg[63:0] branch_program_counter,
    output wire is_branching
);
    parameter B_TYPE = 7'b1100011;
    wire[6:0] opcode = instruction[6:0];
    wire[63:0] b_type_imm = ({ {52{instruction[31]}}, instruction[31], 
                                instruction[7], instruction[30:25], instruction[11:8] }) << 1;

    assign is_branching = (opcode == B_TYPE);
    assign branch_program_counter = program_counter + b_type_imm;

    wire[6:0] program_counter_lsb = program_counter[6:0];


    
endmodule