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
//         instruction_data[0] <= 32'b00000000000000000000010100110011; // add x10, x0, x0 ; initializes x10 to 0
//         instruction_data[1] <= 32'b00000000000101010000010100010011; // addi, x10, x10, 1 ; increments register x10
//         instruction_data[2] <= 32'b11111110000000000000111011100011; // beq x0, x0, -4 ; moves PC 4 bytes back

        // PROG 2
        // instruction_data[0] <= 32'b00000000000100000000010100010011; // addi x10, x0, 1
        // instruction_data[1] <= 32'b00000000000100000000010110010011; // addi x11, x0, 1
        // instruction_data[2] <= 32'b00000000101000000011000000100011; // sd x10, 0(x0)
        // instruction_data[3] <= 32'b00000000101100000011000100100011; // sd x11, 2(x0)
        // instruction_data[4] <= 32'b00000000101100000011001000100011; // sd x11, 4(x0)
        // instruction_data[5] <= 32'b00000000000000000000000001100011; // beq x0, x0, 0

        // instruction_data[0] <= 32'h00100613; // addi x12, x0, 1
        // instruction_data[1] <= 32'h7ff00493; // addi x9, x0, 2047
        // instruction_data[2] <= 32'h7ff00413; // addi x8, x0, 2047
        // instruction_data[3] <= 32'h00200493; // addi x9, x0, 2
        // instruction_data[4] <= 32'h00200413; // addi x8, x0, 2

        // instruction_data[5] <= 32'h00000593; // addi x11, x0, 0
        // instruction_data[6] <= 32'h00000513;
        // instruction_data[7] <= 32'h00150513;

        // instruction_data[8] <= 32'hfe954ee3;//  blt     a0,s1,14 <loop_inner>
        // instruction_data[9] <= 32'h00158593;
        // instruction_data[10] <= 32'hfe85c8e3;

        // instruction_data[11] <= 32'h40b00023; // sd
        // instruction_data[12] <= 32'h00000063;


        // instruction_data[0] <= 32'h05300593;
        // instruction_data[1] <= 32'h40b001a3;
        // instruction_data[2] <= 32'h40200603;
        // instruction_data[3] <= 32'h00000013;
        // instruction_data[4] <= 32'hfe060ce3;
        // instruction_data[5] <= 32'h04500593;
        // instruction_data[6] <= 32'h40b001a3;
        // instruction_data[7] <= 32'h40200603;
        // instruction_data[8] <= 32'h00000013;
        // instruction_data[9] <= 32'hfe060ce3;
        // instruction_data[10] <= 32'h08000593;
        // instruction_data[11] <= 32'h40b001a3;
        // instruction_data[12] <= 32'h40200603;
        // instruction_data[13] <= 32'h00000013;
        // instruction_data[14] <= 32'hfe060ce3;
        // instruction_data[15] <= 32'hfc0002e3;

        instruction_data[0] <= 32'h05300593;
        instruction_data[1] <= 32'h018000ef;
        instruction_data[2] <= 32'h05900593;
        instruction_data[3] <= 32'h010000ef;
        instruction_data[4] <= 32'h0aa00593;
        instruction_data[5] <= 32'h008000ef;
        instruction_data[6] <= 32'h0000006f;
        instruction_data[7] <= 32'h40b001a3;
        instruction_data[8] <= 32'h40200603;
        instruction_data[9] <= 32'hfe060ee3;
        instruction_data[10] <= 32'h000080e7;

        for(int i = 11; i < NUMBER_OF_INSTRUCTIONS; i++) instruction_data[i] <= 0;
    end

endmodule