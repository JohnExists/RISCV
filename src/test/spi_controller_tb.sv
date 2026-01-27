`timescale 1ns/100ps
`define SIMULATION_TIME 200

module spi_controller_tb();
    // Input
    logic clk;
    logic rst;
    logic write_data_enable;
    logic[7:0] write_data;

    // Output
    logic mosi;
    logic sclk;
    logic spi_data_rdy;


    spi_controller dut(
        .clk_in(clk),
        .rst(rst),
        .write_data_enable(write_data_enable),
        .write_data(write_data),
        .mosi(mosi),
        .sclk(sclk),
        .spi_data_rdy(spi_data_rdy)
    );
        

    //         # Configures display to be in 3-bit/pixel mode
    // li x11, 0x3A
    // jal x1, write_cmd
    // li x11, 0x11 # 0x11 = 3-bit/pixel
    // jal x1, write_data

    // # Configures address window
    // li x12, 0
    // li x13, 320
    // li x14, 0
    // li x15, 480
    // jal x3, set_addr_window


    // li x12, 153600
    // li x13, 0
    // black_bg_loop:
    //     li x11, 0x00
    //     jal x1, write_data
    //     addi x13, x13, 1
    //     blt x13, x12, black_bg_loop


    initial begin
        rst <= 1;
        clk <= 0; #2;
        clk <= 1; #2;
        rst <= 0;

        write_data <= 8'b01010100;
        write_data_enable <= 1;
        clk <= 0; #2;
        clk <= 1; #2;
        write_data_enable <= 0;

        while (~spi_data_rdy) begin
            clk <= 0; #2;
            clk <= 1; #2;
        end

        write_data <= 8'b11111100;
        write_data_enable <= 1;
        clk <= 0; #2;
        clk <= 1; #2;
        write_data_enable <= 0;

        while (~spi_data_rdy) begin
            clk <= 0; #2;
            clk <= 1; #2;
        end

        write_data <= 8'b00111111;
        write_data_enable <= 1;
        clk <= 0; #2;
        clk <= 1; #2;
        write_data_enable <= 0;


        while (~spi_data_rdy) begin
            clk <= 0; #2;
            clk <= 1; #2;
        end

        $stop;
    end

    

endmodule