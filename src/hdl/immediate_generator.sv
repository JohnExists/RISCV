module immediate_generator (
    input wire[31:0] instruction,
    output reg[63:0] immediate
);
//     All possible opcodes possible for this operation
    parameter LD = 7'b0000011, SD = 7'b0100011;
    parameter I_TYPE = 7'b0010011; // ADDI, SLTI, SLTIU, XORI, ORI, ANDI, SLLI, SRLI, SRAI
    parameter B_TYPE = 7'b1100011; // BEQ, BNE, BLT, BGE, BLTU, BGEU

    // Leadings bits are sign-extended from the MSB of the instruction
    // (MSB is always the sign bit instructions)
    wire[6:0] opcode = instruction[6:0];
    wire[63:0] i_type_imm = { {52{instruction[31]}}, instruction[31:20] };
    wire[63:0] s_type_imm = { {52{instruction[31]}}, instruction[31:25], instruction[11:7] };
    wire[63:0] b_type_imm = { {52{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8] };

   always_comb begin
       case (opcode)
           SD:      immediate = s_type_imm;
           LD:      immediate = i_type_imm; 
           I_TYPE:  immediate = i_type_imm; 
           B_TYPE:  immediate = b_type_imm << 1; // Bit-shifted left due to specifications of branch instruction not storing LSB
           default: immediate = 64'd0;
       endcase
   end
endmodule