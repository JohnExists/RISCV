`timescale 1ns/100ps
`define SIMULATION_TIME 100

module register_file_tb();
    // Input
    logic clk;
    logic rst;

    logic wire[REGISTER_ADDR_SIZE - 1:0] read_reg_addr_1;
    logic wire[REGISTER_ADDR_SIZE - 1:0] read_reg_addr_2;
    
    logic write_enable;
    logic[4:0] write_reg_addr;
    logic[REGISTER_BIT_SIZE - 1:0] write_reg_data;

    // Outpit
    logic [REGISTER_BIT_SIZE - 1:0] read_reg_data_1;
    logic [REGISTER_BIT_SIZE - 1:0] read_reg_data_2;


    register_file dut(
        .clk(clk),
        .rst(rst),
        .read_reg_addr_1(read_reg_addr_1),
        .read_reg_addr_2(read_reg_addr_2),
        .write_enable(write_enable),
        .write_reg_addr(write_reg_addr),
        .write_reg_data(write_reg_data),
        .read_reg_data_1(read_reg_data_1),
        .read_reg_data_2(read_reg_data_2)
    );


    initial begin
        
        #`SIMULATION_TIME;
        $stop;
    end

    initial begin
        opcode <= LD; #1;
        opcode <= SD; #1;
        opcode <= ADD; #1;
        opcode <= ADDI; #1;
        opcode <= BEQ; #1;
    end


endmodule