// TODO Finish implementation


module riscv_core (
    input clk,
    input rst,
    output reg read_reg_data_2_lsb,
    output reg led0,
    output reg led1,
    output reg led2
);
    // programs values
    reg[63:0] program_counter;
    reg[31:0] current_instruction;

    // instruction values
    wire[6:0] opcode = current_instruction[6:0];
    wire[4:0] rs1 = current_instruction[19:15];
    wire[4:0] rs2 = current_instruction[24:20];
    wire[4:0] rd = current_instruction[11:7];
    
    wire[2:0] funct3 = current_instruction[14:12];
    wire[6:0] funct7 = current_instruction[31:25];

    wire branching_condition = ( (alu_zero & funct3 == 3'b000) | // BEQ
                                (~alu_zero & funct3 == 3'b001) | // BNE
                                (alu_less_than & funct3 == 3'b100) | // BLT
                               (~alu_less_than & funct3 == 3'b101) ) // BGE 
                               & branch_enable;

    always_ff @(posedge clk) begin
        if(rst) program_counter <= 0;
        else program_counter <= branching_condition ? program_counter + immediate: 
                                                      program_counter + 64'd4;
    end

    instruction_memory im (
         .rst(rst),
        .program_counter(program_counter), 
        .instruction(current_instruction)
    ); 


    reg[63:0] read_reg_data_1;
    reg[63:0] read_reg_data_2;
    assign read_reg_data_2_lsb = read_reg_data_2[0];
    register_file rf (
        .clk(clk), 
        .rst(rst),
        .read_reg_addr_1(rs1),
        .read_reg_addr_2(rs2),
        .write_enable(reg_write_enable),
        .write_reg_addr(rd),
        .write_reg_data(progmem_to_reg_enable ? progmem_read_data : alu_output),
        .read_reg_data_1(read_reg_data_1),
        .read_reg_data_2(read_reg_data_2)
    );


    // Immediate value generated
    reg[63:0] immediate; 
    immediate_generator immgen(
        .instruction(current_instruction),
        .immediate(immediate)
    );

    // All Control signals
    wire branch_enable;
    wire alu_imm_enable;
    wire reg_write_enable;
    wire mem_write_enable;
    wire mem_read_enable;
    wire progmem_to_reg_enable;
    wire[3:0] alu_control_signal;
    control_unit ctrl(
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .alu_control_value(alu_control_signal),
        .reg_write_enable(reg_write_enable),
        .branch_enable(branch_enable),
        .alu_imm_enable(alu_imm_enable),
        .mem_write_enable(mem_write_enable),
        .mem_read_enable(mem_read_enable),
        .progmem_to_reg_enable(progmem_to_reg_enable)
    );


    // Results of the ALU
    reg[63:0] alu_output;
    wire alu_zero;
    wire alu_less_than;
    alu alu (
        .select(alu_control_signal),
        .data_in1(read_reg_data_1),
        .data_in2(alu_imm_enable ? immediate : read_reg_data_2),
        .data_out(alu_output),
        .zero(alu_zero),
        .less_than(alu_less_than)
    );


    reg[63:0] progmem_read_data;
    program_memory progmem (
        .clk(clk), 
        .rst(rst),
        .mem_write_enable(mem_write_enable),
        .mem_read_enable(mem_read_enable),
        .read_write_addr(alu_output),
        .write_data(read_reg_data_2),
        .read_data(progmem_read_data),
        .led0(led0),
        .led1(led1),
        .led2(led2)
    );

endmodule