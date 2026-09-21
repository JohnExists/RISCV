module immediate_generator (
    input wire[31:0] instruction,
    output reg[31:0] immediate
);
//     All possible opcodes possible for this operation
    parameter LW = 7'b0000011, SW = 7'b0100011, JAL = 7'b1101111, JALR = 7'b1100111;
    parameter I_TYPE = 7'b0010011; // ADDI, SLTI, SLTIU, XORI, ORI, ANDI, SLLI, SRLI, SRAI
    parameter B_TYPE = 7'b1100011; // BEQ, BNE, BLT, BGE, BLTU, BGEU
    parameter LUI = 7'b0110111; // LUI

    // Leadings bits are sign-extended from the MSB of the instruction
    // (MSB is always the sign bit instructions)
    wire[6:0] opcode = instruction[6:0];
    wire[2:0] funct3 = instruction[14:12];
    
    wire[31:0] i_type_imm = { {20{instruction[31]}}, instruction[31:20] };
    wire[31:0] s_type_imm = { {20{instruction[31]}}, instruction[31:25], instruction[11:7] };
    // B-Type Bit-shifted left due to specifications of branch instruction not storing LSB
    wire[31:0] b_type_imm = { {20{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8] } << 1;
    wire[31:0] uj_type_imm ={ {12{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:21]  } << 1;
    wire[31:0] u_type_imm = { instruction[31:12], 12'd0 };
    wire[31:0] shamt_imm = { 27'd0, instruction[24:20] };

   always_comb begin
       case (opcode)
           SW:      immediate = s_type_imm;
           LW:      immediate = i_type_imm;
           JALR:    immediate = i_type_imm; 
           I_TYPE:  
            case (funct3)
                3'b001:  immediate = shamt_imm; // SLLI
                3'b101:  immediate = shamt_imm; // SRLI/SRAI (funct7 picks between them, doesn't affect immediate)
                default: immediate = i_type_imm; // ADDI, SLTI, SLTIU, XORI, ORI, ANDI
            endcase
           B_TYPE:  immediate = b_type_imm;
           LUI:     immediate = u_type_imm;
           JAL:     immediate = uj_type_imm;
           default: immediate = 32'd0;
       endcase
   end
endmodule