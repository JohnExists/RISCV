module instruction_memory #(
    NUMBER_OF_INSTRUCTIONS = 100
) (
    input wire[63:0] program_counter,
    output reg[31:0] instruction
);
    reg [31:0] instruction_data[0:NUMBER_OF_INSTRUCTIONS - 1];

    // For combinational reads to the data
    assign instruction = instruction_data[program_counter >> 2];

endmodule