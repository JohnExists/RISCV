`timescale 1ns/100ps
`define SIMULATION_TIME 7500

module riscv_core_tb();
    // Input
    logic clk;
    logic rst;
    
    // Output
    logic read_reg_data_2_lsb;
    logic led0, led1, led2;

    riscv_core dut(
        .clk_in(clk), 
        .rst(rst),
        .read_reg_data_2_lsb(read_reg_data_2_lsb),
        .led0(led0),
        .led1(led1),
        .led2(led2)
    );
        

    initial begin
        clk <= 0;
        rst <= 1;
        #10
        rst <= 0;
        #`SIMULATION_TIME;
        $stop;
    end

    always begin
        #2 clk <= !clk;
    end
    

endmodule