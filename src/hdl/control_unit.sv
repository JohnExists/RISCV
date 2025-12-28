
// TODO Finish complete implementation with specified instructions
module control_unit (
    input wire[6:0] opcode,
    input wire[2:0] funct3,
    input wire[6:0] funct7,
    output reg[3:0] alu_control_value,
    output reg reg_write_enable,
    output reg mem_write_enable,
    output reg mem_read_enable,
    output reg branch_enable,
    output reg alu_imm_enable
);

    parameter LD = 7'b0000011, SD = 7'b0100011;
    parameter R_TYPE = 7'b0110011, ADDI = 7'b0010011; // R-Type includes all basic operations (add, sub, and, or, etc)
    parameter BEQ = 7'b1100111;


    parameter ADD_OP = 4'b0010, SUB_OP = 4'b0110, AND_OP = 4'b0000, OR_OP = 4'b0001;

    // Combinational logic for determining ALU control signals
    always_comb begin
        case (opcode)
            LD: alu_control_value = ADD_OP;
            SD: alu_control_value = ADD_OP;
            ADDI:alu_control_value = ADD_OP;
            R_TYPE:
            begin
                if(funct3 == 3'b000 & funct7 == 7'b0000000)alu_control_value = ADD_OP;
                else if(funct3 == 3'b000 & funct7 == 7'b0100000) alu_control_value = SUB_OP;
                else if(funct3 == 3'b111) alu_control_value = AND_OP;
                else if(funct3 == 3'b110) alu_control_value = OR_OP;
                else alu_control_value = 4'b0000;
            end
            BEQ:alu_control_value = SUB_OP; 
            default: alu_control_value = 4'b0000;
        endcase
    end

    // Combinational logic for enabling WRITE for program memory
    always_comb begin
        case (opcode)
            LD:      mem_write_enable = 1;
            default: mem_write_enable = 0;
        endcase
    end

    // Combinational logic for enabling READ for program memory
    always_comb begin
        case (opcode)
            SD:         mem_read_enable = 1;
            default:    mem_read_enable = 0;
        endcase
    end


    // Combinational logic for enabling WRITE for the register file
    always_comb begin
        case (opcode)
            LD:         reg_write_enable = 1;
            default:    reg_write_enable = 0;
        endcase
    end

    // Combinational logic for using immediate value instead of
    // register value for the 2nd operand in the ALU
    always_comb begin
        case (opcode)
            ADDI:       alu_imm_enable = 1;
            BEQ:        alu_imm_enable = 1;
            default:    alu_imm_enable = 0;
        endcase
    end


    // Combinational logic for enabling branches within the
    // program counter to occur
    always_comb begin
        case (opcode)
            BEQ:        branch_enable = 1;
            default:    branch_enable = 0;
        endcase
    end
    
endmodule