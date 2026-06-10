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

instruction_data[0] <= 32'hfc010113;
instruction_data[1] <= 32'h02112e23;
instruction_data[2] <= 32'h02812c23;
instruction_data[3] <= 32'h04010413;
instruction_data[4] <= 32'h00000513;
instruction_data[5] <= 32'hfea42a23;
instruction_data[6] <= 32'h00100593;
instruction_data[7] <= 32'hfeb42823;
instruction_data[8] <= 32'h00400593;
instruction_data[9] <= 32'hfeb42623;
instruction_data[10] <= 32'h00200613;
instruction_data[11] <= 32'hfec42423;
instruction_data[12] <= 32'h00300613;
instruction_data[13] <= 32'hfec42223;
instruction_data[14] <= 32'h00500613;
instruction_data[15] <= 32'hfec42023;
instruction_data[16] <= 32'hfcb42e23;
instruction_data[17] <= 32'hfca42a23;
instruction_data[18] <= 32'h0040006f;
instruction_data[19] <= 32'hfd442503;
instruction_data[20] <= 32'hfdc42583;
instruction_data[21] <= 32'h0ab55c63;
instruction_data[22] <= 32'h0040006f;
instruction_data[23] <= 32'h00000513;
instruction_data[24] <= 32'hfca42823;
instruction_data[25] <= 32'h0040006f;
instruction_data[26] <= 32'hfd042503;
instruction_data[27] <= 32'hfdc42583;
instruction_data[28] <= 32'hfd442603;
instruction_data[29] <= 32'h40c585b3;
instruction_data[30] <= 32'h08b55063;
instruction_data[31] <= 32'h0040006f;
instruction_data[32] <= 32'hfd042503;
instruction_data[33] <= 32'h00251593;
instruction_data[34] <= 32'hfe040513;
instruction_data[35] <= 32'h00b50533;
instruction_data[36] <= 32'h00052583;
instruction_data[37] <= 32'h00452503;
instruction_data[38] <= 32'h04b55663;
instruction_data[39] <= 32'h0040006f;
instruction_data[40] <= 32'hfd042503;
instruction_data[41] <= 32'h00251513;
instruction_data[42] <= 32'hfe040593;
instruction_data[43] <= 32'h00b50533;
instruction_data[44] <= 32'h00452503;
instruction_data[45] <= 32'hfca42c23;
instruction_data[46] <= 32'hfd042503;
instruction_data[47] <= 32'h00251513;
instruction_data[48] <= 32'h00a58633;
instruction_data[49] <= 32'h00062503;
instruction_data[50] <= 32'h00a62223;
instruction_data[51] <= 32'hfd842503;
instruction_data[52] <= 32'hfd042603;
instruction_data[53] <= 32'h00261613;
instruction_data[54] <= 32'h00c585b3;
instruction_data[55] <= 32'h00a5a023;
instruction_data[56] <= 32'h0040006f;
instruction_data[57] <= 32'h0040006f;
instruction_data[58] <= 32'hfd042503;
instruction_data[59] <= 32'h00150513;
instruction_data[60] <= 32'hfca42823;
instruction_data[61] <= 32'hf75ff06f;
instruction_data[62] <= 32'h0040006f;
instruction_data[63] <= 32'hfd442503;
instruction_data[64] <= 32'h00150513;
instruction_data[65] <= 32'hfca42a23;
instruction_data[66] <= 32'hf45ff06f;
instruction_data[67] <= 32'h00000513;
instruction_data[68] <= 32'hfca42623;
instruction_data[69] <= 32'h0040006f;
instruction_data[70] <= 32'hfcc42583;
instruction_data[71] <= 32'h00400513;
instruction_data[72] <= 32'h02b54a63;
instruction_data[73] <= 32'h0040006f;
instruction_data[74] <= 32'hfcc42503;
instruction_data[75] <= 32'h00251593;
instruction_data[76] <= 32'hfe040513;
instruction_data[77] <= 32'h00b50533;
instruction_data[78] <= 32'h00054503;
instruction_data[79] <= 32'h020000ef;
instruction_data[80] <= 32'h0040006f;
instruction_data[81] <= 32'hfcc42503;
instruction_data[82] <= 32'h00150513;
instruction_data[83] <= 32'hfca42623;
instruction_data[84] <= 32'hfc9ff06f;
instruction_data[85] <= 32'h0040006f;
instruction_data[86] <= 32'h0000006f;
instruction_data[87] <= 32'hff010113;
instruction_data[88] <= 32'h00112623;
instruction_data[89] <= 32'h00812423;
instruction_data[90] <= 32'h01010413;
instruction_data[91] <= 32'hfea40ba3;
instruction_data[92] <= 32'hff744503;
instruction_data[93] <= 32'h40a001a3;
instruction_data[94] <= 32'h00c12083;
instruction_data[95] <= 32'h00812403;
instruction_data[96] <= 32'h01010113;
instruction_data[97] <= 32'h00008067;
for(int i = 98; i < NUMBER_OF_INSTRUCTIONS; i++) instruction_data[i] <= 0;


    end


endmodule