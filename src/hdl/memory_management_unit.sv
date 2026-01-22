// TODO
module memory_management_unit (
    input clk,
    input rst,
    input wire[2:0] funct3,
    input wire mem_write_enable,
    input wire mem_read_enable,
    input wire[63:0] address,
    input wire[63:0] write_data,
    output wire[63:0] read_data,
    output wire[7:0] leds,
    output wire[15:0] io_pins
);
    wire progmem_enable = ~address[10]; // TODO This is not complete does NOT check upper bits
    wire peripherals_enable = address[10];

    wire[7:0] led, output_pins;

    wire[7:0] pcont_read_data;
    wire[63:0] progmem_read_data;

    assign read_data = { 56'd0, pcont_read_data } | progmem_read_data;
    

    peripheral_controller pcont (
        .clk(clk),
        .rst(rst),
        .write_enable(mem_write_enable & peripherals_enable),
        .read_enable(mem_read_enable & peripherals_enable),
        .address(address[9:0]),
        .write_data(write_data[7:0]),
        .read_data(pcont_read_data),
        .leds(leds),
        .output_pins_bank_1(io_pins[7:0]),
        .output_pins_bank_2(io_pins[15:8])
    );

    program_memory progmem (
        .clk(clk), 
        .rst(rst),
        .data_width(funct3[1:0]),
        .write_enable(mem_write_enable & progmem_enable),
        .read_enable(mem_read_enable & progmem_enable),
        .address(address[9:0]),
        .write_data(write_data),
        .read_data(progmem_read_data)
    );
    
endmodule