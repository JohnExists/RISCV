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