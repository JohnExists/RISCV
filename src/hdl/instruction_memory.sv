module instruction_memory #(
    NUMBER_OF_INSTRUCTIONS = 300
) (
    input rst,
    input wire[31:0] program_counter,
    output reg[31:0] instruction
);

    reg [31:0] instruction_data[0:NUMBER_OF_INSTRUCTIONS - 1];

    // For combinational reads to the data
    assign instruction = instruction_data[program_counter >> 2];

    initial 
    begin
instruction_data[0] <= 32'hfe010113;
instruction_data[1] <= 32'h00112e23;
instruction_data[2] <= 32'h00812c23;
instruction_data[3] <= 32'h02010413;
instruction_data[4] <= 32'h00100793;
instruction_data[5] <= 32'hfef42623;
instruction_data[6] <= 32'h0180006f;
instruction_data[7] <= 32'hfec42503;
instruction_data[8] <= 32'h020000ef;
instruction_data[9] <= 32'hfec42783;
instruction_data[10] <= 32'h00178793;
instruction_data[11] <= 32'hfef42623;
instruction_data[12] <= 32'hfec42703;
instruction_data[13] <= 32'h00700793;
instruction_data[14] <= 32'hfee7d2e3;
instruction_data[15] <= 32'h0000006f;
instruction_data[16] <= 32'hfe010113;
instruction_data[17] <= 32'h00112e23;
instruction_data[18] <= 32'h00812c23;
instruction_data[19] <= 32'h02010413;
instruction_data[20] <= 32'hfea42623;
instruction_data[21] <= 32'h40300793;
instruction_data[22] <= 32'hfec42703;
instruction_data[23] <= 32'h0ff77713;
instruction_data[24] <= 32'h00e78023;
instruction_data[25] <= 32'h00000013;
instruction_data[26] <= 32'h40200793;
instruction_data[27] <= 32'h0007c783;
instruction_data[28] <= 32'h0ff7f793;
instruction_data[29] <= 32'hfe078ae3;
instruction_data[30] <= 32'h00000013;
instruction_data[31] <= 32'h00000013;
instruction_data[32] <= 32'h01c12083;
instruction_data[33] <= 32'h01812403;
instruction_data[34] <= 32'h02010113;
instruction_data[35] <= 32'h00008067;
for(int i = 36; i < NUMBER_OF_INSTRUCTIONS; i++) instruction_data[i] <= 0;

    end


endmodule