// TODO Finish implementation and reset functionality

module risc_core (
    input clk
);
    // programs values
    reg[63:0] program_counter;
    reg[31:0] current_instruction;

    // control signals
    wire write_rst;
    assign write_rst = 0; // TODO Change later

    wire branch_enable;
    wire alu_src;
    wire alu_imm_enable;
    wire reg_write_enable;
    wire mem_write_enable;
    wire mem_read_enable;

    // instruction values
    wire[6:0] opcode = current_instruction[6:0];
    wire[4:0] rs1 = current_instruction[19:15];
    wire[4:0] rs2 = current_instruction[24:20];
    wire[4:0] rd = current_instruction[11:7];
    
    wire[2:0] funct3 = current_instruction[14:12];
    wire[6:0] funct7 = current_instruction[31:25];

    // results of modules
    reg[63:0] read_reg_data_1;
    reg[63:0] read_reg_data_2;
    
    reg[63:0] immediate;

    wire[3:0] alu_control_signal;
    reg[63:0] alu_output;
    wire alu_zero;


    always_ff @(posedge clk) begin
        program_counter <= (branch_enable & alu_zero) ? program_counter + immediate <<< 1 : 
                                                        program_counter + 64'd4;
    end


    instruction_memory im (
        .program_counter(program_counter), 
        .instruction(current_instruction)
    );

    register_file rf (
        .clk(clk), 
        .rst(write_rst),
        .read_reg_addr_1(rs1),
        .read_reg_addr_2(rs2),
        .write_enable(reg_write_enable),
        .write_reg_addr(rd),
        .write_reg_data(alu_output),
        .read_reg_data_1(read_reg_data_1),
        .read_reg_data_2(read_reg_data_2)
    );

    immediate_generator immgen(
        .instruction(current_instruction),
        .immediate_value(immediate)
    );

    control_unit ctrl(
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .alu_control_value(alu_control_signal),
        .reg_write_enable(reg_write_enable),
        .branch_enable(branch_enable),
        .alu_imm_enable(alu_src),
        .mem_write_enable(mem_write_enable),
        .mem_read_enable(mem_read_enable)
    );

    alu alu (
        .select(alu_control_signal),
        .data_in1(read_reg_data_1),
        .data_in2(alu_src ? immediate : read_reg_data_2),
        .data_out(alu_output),
        .zero(alu_zero)
    );

endmodule