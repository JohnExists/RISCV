module control_unit (
    input reg[31:0] current_instruction,
    output reg[3:0] alu_control_value,
    output reg reg_write_enable,
    output reg mem_write_enable,
    output reg mem_read_enable,
    output reg conditional_branch_enable,
    output reg alu_imm_enable,
    output reg progmem_to_reg_enable,
    output reg next_pc_in_reg_enable,
    output reg jump_to_alu_result
);

    wire[6:0] opcode = current_instruction[6:0];
    wire[2:0] funct3 = current_instruction[14:12];
    wire[6:0] funct7 = current_instruction[31:25];

    parameter LD = 7'b0000011, SD = 7'b0100011, JAL = 7'b1101111, JALR = 7'b1100111;
    parameter I_TYPE = 7'b0010011; // ADDI, SLTI, SLTIU, XORI, ORI, ANDI, SLLI, SRLI, SRAI
    parameter B_TYPE = 7'b1100011; // BEQ, BNE, BLT, BGE
    parameter R_TYPE = 7'b0110011; // R-Type includes all basic operations (add, sub, and, or, etc)
    parameter LUI = 7'b0110111; // LUI

    parameter ADD_OP = 4'b0100, SUB_OP = 4'b0101, AND_OP = 4'b0000, OR_OP = 4'b0001, XOR_OP = 4'b0010;
    parameter SLL_OP = 4'b0110, SRL_OP = 4'b0111, SRA_OP = 4'b1000;

    // Combinational logic for determining ALU control signals
    
    always_comb begin
        case (opcode)
            LD: alu_control_value = ADD_OP;
            SD: alu_control_value = ADD_OP;
            I_TYPE:
            begin
                if(funct3 == 3'b000) alu_control_value = ADD_OP;
                else if(funct3 == 3'b001) alu_control_value = SLL_OP;
                else if(funct3 == 3'b100) alu_control_value = XOR_OP;
                else if(funct3 == 3'b101 & funct7 == 7'b0000000) alu_control_value = SRL_OP;
                else if(funct3 == 3'b101 & funct7 == 7'b0100000) alu_control_value = SRA_OP;
                else if(funct3 == 3'b110) alu_control_value = OR_OP;
                else if(funct3 == 3'b111) alu_control_value = AND_OP;
                else alu_control_value = 4'b0000;

            end
            JAL: alu_control_value = ADD_OP;
            JALR: alu_control_value = ADD_OP;
            LUI: alu_control_value = ADD_OP;
            R_TYPE:
            begin
                if(funct3 == 3'b000 & funct7 == 7'b0000000)alu_control_value = ADD_OP;
                else if(funct3 == 3'b000 & funct7 == 7'b0100000) alu_control_value = SUB_OP;
                else if(funct3 == 3'b111) alu_control_value = AND_OP;
                else if(funct3 == 3'b110) alu_control_value = OR_OP;
                else alu_control_value = 4'b0000;
            end
            B_TYPE:alu_control_value = SUB_OP; 
            default: alu_control_value = 4'b0000;
        endcase
    end

    // Combinational logic for enabling WRITE for program memory
    always_comb begin
        case (opcode)
            SD:      mem_write_enable = 1;
            default: mem_write_enable = 0;
        endcase
    end

    // Combinational logic for enabling READ for program memory
    always_comb begin
        case (opcode)
            LD:         mem_read_enable = 1;
            default:    mem_read_enable = 0;
        endcase
    end


    // Combinational logic for enabling WRITE for the register file
    always_comb begin
        case (opcode)
            LD:         reg_write_enable = 1;
            R_TYPE:     reg_write_enable = 1;
            I_TYPE:     reg_write_enable = 1;            
            JAL:        reg_write_enable = 1;            
            JALR:       reg_write_enable = 1;   
            LUI:        reg_write_enable = 1;         
            default:    reg_write_enable = 0;
        endcase
    end

    // Combinational logic for using immediate value instead of
    // register value for the 2nd operand in the ALU
    always_comb begin
        case (opcode)
            LD:         alu_imm_enable = 1;
            SD:         alu_imm_enable = 1;
            I_TYPE:     alu_imm_enable = 1;
            LUI:        alu_imm_enable = 1;
            JAL:        alu_imm_enable = 1;
            JALR:       alu_imm_enable = 1;
            default:    alu_imm_enable = 0;
        endcase
    end


    // Combinational logic for enabling CONDITIONAL branches (for equality comparisons) within the
    // program counter to occur
    always_comb begin
        case (opcode)
            B_TYPE:     conditional_branch_enable = 1;
            default:    conditional_branch_enable = 0;
        endcase
    end


    // Combinational logic for enabling the output
    always_comb begin
        case (opcode)
            LD:         progmem_to_reg_enable = 1;
            default:    progmem_to_reg_enable = 0;
        endcase
    end



    // Combinational logic for enabling next program counter to be stored in a register
    always_comb begin
        case (opcode)
            JAL:        next_pc_in_reg_enable = 1;
            JALR:       next_pc_in_reg_enable = 1;
            default:    next_pc_in_reg_enable = 0;
        endcase
    end

    // Combinational logic for forcing the program counter to be equal to the ALU result
    always_comb begin
        case (opcode)
            JALR:       jump_to_alu_result = 1; 
            default:    jump_to_alu_result = 0;
        endcase
    end

    
endmodule