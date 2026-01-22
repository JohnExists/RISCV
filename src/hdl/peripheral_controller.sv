// TODO Make it so that it can be a wider data bus (more than 1-byte at a time)
// TODO Add combinational reads and writes

module peripheral_controller  #(
    NUMBER_OF_BYTES = 4
) (
    input wire clk,
    input wire rst,
    input wire[9:0] address,
    input wire[7:0] write_data,
    input wire write_enable,
    input wire read_enable,

    output wire[7:0] read_data,
    output wire[7:0] output_pins_bank_1,
    output wire[7:0] output_pins_bank_2,
    output wire[7:0] leds
);
    wire spi_data_rdy;
    reg [7:0] data_registers[0:NUMBER_OF_BYTES - 1];

    wire[7:0] led_read_data, gpioA_read_data, spi_read_data;
    assign read_data = gpioA_read_data | spi_read_data;

    gpio_controller #( .GPIO_ADDRESS(10'd0) ) led (
        .clk(clk),
        .rst(rst),
        .address(address),
        .write_data(write_data),
        .write_enable(write_enable),
        .read_enable(read_enable),
        .read_data(led_read_data),
        .pin_out(leds)
    );

    gpio_controller #( .GPIO_ADDRESS(10'd1) ) gpioA (
        .clk(clk),
        .rst(rst),
        .address(address),
        .write_data(write_data),
        .write_enable(write_enable),
        .read_enable(read_enable),
        .read_data(gpioA_read_data),
        .pin_out(output_pins_bank_1)
    );
    
    spi_controller #( .STARTING_ADDRESS(10'd2) ) spi (
        .clk_in(clk),
        .rst(rst),
        .address(address),
        .write_data(write_data),
        .write_enable(write_enable),
        .read_enable(read_enable),
        .read_data(spi_read_data),
        .pin_out(output_pins_bank_2)
    );

endmodule