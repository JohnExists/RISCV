`timescale 1ns/100ps
`define SIMULATION_TIME 1500

module riscv_core_tb();
    // Input
    logic clk;
    logic rst;
    
    // Output
    logic read_reg_data_2_lsb;
    logic[5:0] leds;

    riscv_core dut(
        .clk_in(clk), 
        .rst(rst),
        .read_reg_data_2_lsb(read_reg_data_2_lsb),
        .leds(leds)
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