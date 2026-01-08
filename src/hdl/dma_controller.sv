module dma_controller (
    input clk,
    input wire[31:0] base_address,
    input wire[15:0] base_word_count,
    input wire[2:0] control_register,

    input wire[63:0] write_data,
    output reg done,
    output reg spi_clk,
    output reg spi_mosi,
    output reg spi_rst
);
    reg[15:0] current_address;
    reg[15:0] current_word;

    assign spi_clk = clk;// make this 0 if SPI is not enabled


    reg chip_enable;
    wire[7:0] dout;

    // SRAM_SP sram(
    //     .clk(clk),
    //     .oce(oce), //input oce
    //     .ce(chip_enable), //Chip Enable
    //     .wre(wre), //Write enable
    //     .ad(address), // Address
    //     .din(8'd1/*TODO FIND SMTH FOR THIS PARAMETER*/) //input [7:0] din
    //     .dout(dout), // Read Output
    // );


endmodule