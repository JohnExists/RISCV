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

    output reg[7:0] read_data,
    output wire[7:0] leds,
    output wire[2:0] output_pins

);

    wire spi_data_rdy;
    reg [7:0] data_registers[0:NUMBER_OF_BYTES - 1];

    assign leds = data_registers[0];
//    assign output_pins = data_registers[1]; // 3 LSB are reserved for SPI TODO Remove later

    wire gpioA_read_data;
    gpio_controller  #( .GPIO_ADDRESS(9'b000000000) ) gpioA (
        .clk(clk),
        .rst(rst),
        .address(address),
        .write_data(write_data),
        .write_enable(write_enable),
        .read_enable(read_enable),
        .read_data(gpioA_read_data)
    )
    

    // always_comb begin
    //     if(read_enable) begin
    //         if(address == 10'd02) read_data = {7'd0 , spi_data_rdy};
    //         else read_data = data_registers[address];
            
    //     end
    //     else read_data = 0;
    // end

    // always_ff @(posedge clk) begin
    //     // If there is no clear then write the data to the register
    //     if(rst) for(int i = 0; i < NUMBER_OF_BYTES; i++) data_registers[i] <= 0;
    //     else if(write_enable) begin 
    //         data_registers[address] <= write_data[7:0]; 
 
    //     end
    // end

    wire SPI_write_enable = address == 10'h3;
    assign output_pins[2] = spi_data_rdy;
    spi_controller spi_control(
        .clk_in(clk),
        .rst(rst),
        .write_data_enable(write_enable & SPI_write_enable),
        .write_data(write_data),
        .sclk(output_pins[0]),
        .mosi(output_pins[1]),
        .spi_data_rdy(spi_data_rdy)
    );

endmodule