module instruction_memory #(
    NUMBER_OF_INSTRUCTIONS = 50
) (
    input rst,
    input wire[63:0] program_counter,
    output reg[31:0] instruction
);

    reg [31:0] instruction_data[0:NUMBER_OF_INSTRUCTIONS - 1];

    // For combinational reads to the data
    assign instruction = instruction_data[program_counter >> 2];

    always_ff @(posedge rst) begin
        // PROG 1
        instruction_data[0] <= 32'b00000000000000000000010100110011; // add x10, x0, x0 ; initializes x10 to 0
        instruction_data[1] <= 32'h00000013; // nop
        instruction_data[2] <= 32'b00000000000101010000010100010011; // addi, x10, x10, 1 ; increments register x10
        instruction_data[3] <= 32'b11111110000000000000111011100011; // beq x0, x0, -4 ; moves PC 4 bytes back

        // PROG 2
        // instruction_data[0] <= 32'b00000000000100000000010100010011;
        // instruction_data[1] <= 32'b00000000000100000000010110010011;
        // instruction_data[2] <= 32'b00000000101000000011000000100011;
        // instruction_data[3] <= 32'b00000000101100000011000100100011;
        // instruction_data[4] <= 32'b00000000101100000011001000100011;
        // instruction_data[5] <= 32'b00000000000000000000000001100011;

        // instruction_data[0] <= 32'h00100613;
        // instruction_data[1] <= 32'h7ff00493;
        // instruction_data[2] <= 32'h7ff00413;
        // instruction_data[3] <= 32'h00000593;
        // instruction_data[4] <= 32'h00000513;
        // instruction_data[5] <= 32'h00000013;
        // instruction_data[6] <= 32'h00000013;
        // instruction_data[7] <= 32'h00000013;
        // instruction_data[8] <= 32'h00150513;
        // instruction_data[9] <= 32'hfe9548e3;
        // instruction_data[10] <= 32'h00158593;
        // instruction_data[11] <= 32'hfe85c2e3;
        // instruction_data[12] <= 32'h00c03223; // SD dont DEL PLS
        // instruction_data[13] <= 32'h00000063;


        for(int i = 4; i < NUMBER_OF_INSTRUCTIONS; i++) instruction_data[i] <= 0;
    end

endmodule