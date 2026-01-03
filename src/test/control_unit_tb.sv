`timescale 1ns/100ps
`define SIMULATION_TIME 7

module control_unit_tb();
    // Input
    logic[6:0] opcode;
    logic[2:0] funct3;
    logic[6:0] funct7;

    // Output
    logic[3:0] alu_control_value;
    logic reg_write_enable;
    logic mem_write_enable;
    logic mem_read_enable;
    logic branch_enable;
    logic alu_imm_enable;

    control_unit dut(
        .current_instruction({ funct7, 10'd0, funct3, 5'd0, opcode }),
        .alu_control_value(alu_control_value),
        .reg_write_enable(reg_write_enable),
        .mem_write_enable(mem_write_enable),
        .mem_read_enable(mem_read_enable),
        .branch_enable(branch_enable),
        .alu_imm_enable(alu_imm_enable)
    );

    parameter LD = 7'b0000011, SD = 7'b0100011;
    parameter ADD = 7'b0110011, SUB = 7'b0110011, I_TYPE = 7'b0010011;
    parameter B_TYPE = 7'b1100011;

    initial begin
        funct3 <= 0;
        funct7 <= 0;
        #`SIMULATION_TIME;
        $stop;
    end

    initial begin
        opcode <= LD; #1;
        opcode <= SD; #1;
        opcode <= ADD; #1;
        opcode <= I_TYPE; #1;
        opcode <= B_TYPE; #1;
    end

    always @(opcode or funct3 or funct7) begin
        $display("Time %t: opcode=%b \t alu_control=%b \t reg write=%b \t mem write=%b \t mem read =%b \t branch =%b \t alu imm=%b", 
                $realtime, opcode, alu_control_value, reg_write_enable, 
                mem_write_enable, mem_read_enable, branch_enable, alu_imm_enable);
    end



endmodule