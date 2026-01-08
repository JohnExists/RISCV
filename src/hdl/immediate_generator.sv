module immediate_generator (
    input wire[31:0] instruction,
    output reg[63:0] immediate
);
//     All possible opcodes possible for this operation
    parameter LD = 7'b0000011, SD = 7'b0100011, JAL = 7'b1101111, JALR = 7'b1100111;
    parameter I_TYPE = 7'b0010011; // ADDI, SLTI, SLTIU, XORI, ORI, ANDI, SLLI, SRLI, SRAI
    parameter B_TYPE = 7'b1100011; // BEQ, BNE, BLT, BGE, BLTU, BGEU
    parameter LUI = 7'b0110111; // LUI

    // Leadings bits are sign-extended from the MSB of the instruction
    // (MSB is always the sign bit instructions)
    wire[6:0] opcode = instruction[6:0];
    wire[63:0] i_type_imm = { {52{instruction[31]}}, instruction[31:20] };
    wire[63:0] s_type_imm = { {52{instruction[31]}}, instruction[31:25], instruction[11:7] };
    // B-Type Bit-shifted left due to specifications of branch instruction not storing LSB
    wire[63:0] b_type_imm = { {52{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8] } << 1;
    wire[63:0] uj_type_imm ={ {45{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:21]  } << 1;
    wire[63:0] u_type_imm = { {32{instruction[31]}}, instruction[31:12], 12'd0 };

   always_comb begin
       case (opcode)
           SD:      immediate = s_type_imm;
           LD:      immediate = i_type_imm;
           JALR:    immediate = i_type_imm; 
           I_TYPE:  immediate = i_type_imm; 
           B_TYPE:  immediate = b_type_imm;
           LUI:     immediate = u_type_imm;
           JAL:     immediate = uj_type_imm;
           default: immediate = 64'd0;
       endcase
   end
endmodule