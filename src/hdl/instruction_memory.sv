module instruction_memory #(
    NUMBER_OF_INSTRUCTIONS = 100
) (
    input rst,
    input wire[63:0] program_counter,
    output reg[31:0] instruction
);

    reg [31:0] instruction_data[0:NUMBER_OF_INSTRUCTIONS - 1];

    // For combinational reads to the data
    assign instruction = instruction_data[program_counter >> 2];

    initial 
    begin
instruction_data[0] <= 32'h008001ef;
instruction_data[1] <= 32'h0000006f;
instruction_data[2] <= 32'h00100593;
instruction_data[3] <= 32'h0fc000ef;
instruction_data[4] <= 32'h10c000ef;
instruction_data[5] <= 32'h00100513;
instruction_data[6] <= 32'h40a000a3;
instruction_data[7] <= 32'h100000ef;
instruction_data[8] <= 32'h00000513;
instruction_data[9] <= 32'h40a000a3;
instruction_data[10] <= 32'h0c000593;
instruction_data[11] <= 32'h0dc000ef;
instruction_data[12] <= 32'h01700593;
instruction_data[13] <= 32'h0c0000ef;
instruction_data[14] <= 32'h0c100593;
instruction_data[15] <= 32'h0cc000ef;
instruction_data[16] <= 32'h01200593;
instruction_data[17] <= 32'h0b0000ef;
instruction_data[18] <= 32'h0c500593;
instruction_data[19] <= 32'h0bc000ef;
instruction_data[20] <= 32'h03200593;
instruction_data[21] <= 32'h0a0000ef;
instruction_data[22] <= 32'h03c00593;
instruction_data[23] <= 32'h098000ef;
instruction_data[24] <= 32'h03600593;
instruction_data[25] <= 32'h0a4000ef;
instruction_data[26] <= 32'h04800593;
instruction_data[27] <= 32'h088000ef;
instruction_data[28] <= 32'h03a00593;
instruction_data[29] <= 32'h094000ef;
instruction_data[30] <= 32'h01100593;
instruction_data[31] <= 32'h078000ef;
instruction_data[32] <= 32'h0b100593;
instruction_data[33] <= 32'h084000ef;
instruction_data[34] <= 32'h0b000593;
instruction_data[35] <= 32'h068000ef;
instruction_data[36] <= 32'h0b600593;
instruction_data[37] <= 32'h074000ef;
instruction_data[38] <= 32'h00200593;
instruction_data[39] <= 32'h058000ef;
instruction_data[40] <= 32'h00200593;
instruction_data[41] <= 32'h050000ef;
instruction_data[42] <= 32'h0e900593;
instruction_data[43] <= 32'h05c000ef;
instruction_data[44] <= 32'h00000593;
instruction_data[45] <= 32'h040000ef;
instruction_data[46] <= 32'h0f700593;
instruction_data[47] <= 32'h04c000ef;
instruction_data[48] <= 32'h0a900593;
instruction_data[49] <= 32'h030000ef;
instruction_data[50] <= 32'h05100593;
instruction_data[51] <= 32'h028000ef;
instruction_data[52] <= 32'h02c00593;
instruction_data[53] <= 32'h020000ef;
instruction_data[54] <= 32'h08200593;
instruction_data[55] <= 32'h018000ef;
instruction_data[56] <= 32'h01100593;
instruction_data[57] <= 32'h024000ef;
instruction_data[58] <= 32'h034000ef;
instruction_data[59] <= 32'h02900593;
instruction_data[60] <= 32'h018000ef;
instruction_data[61] <= 32'h00200693;
instruction_data[62] <= 32'h40d000a3;
instruction_data[63] <= 32'h0340016f;
instruction_data[64] <= 32'h00000013;
instruction_data[65] <= 32'h00008067;
instruction_data[66] <= 32'h00000693;
instruction_data[67] <= 32'h40d000a3;
instruction_data[68] <= 32'h0200016f;
instruction_data[69] <= 32'h00000013;
instruction_data[70] <= 32'h00008067;
instruction_data[71] <= 32'h00f00413;
instruction_data[72] <= 32'h00000593;
instruction_data[73] <= 32'h00158593;
instruction_data[74] <= 32'hfe85cee3;
instruction_data[75] <= 32'h00008067;
instruction_data[76] <= 32'h40b001a3;
instruction_data[77] <= 32'h00000013;
instruction_data[78] <= 32'h00000013;
instruction_data[79] <= 32'h00010067;
for(int i = 80; i < NUMBER_OF_INSTRUCTIONS; i++) instruction_data[i] <= 0;
    end

endmodule