module spi_controller #(
        parameter STARTING_ADDRESS = 10'b000000000,
        parameter WORD_LENGTH = 8
    ) (
        input clk_in, 
        input rst,

        input wire[9:0] address,
        input read_enable,
        input write_enable,
        input [WORD_LENGTH - 1: 0] write_data,

        output wire[7:0] read_data,
        output reg[7:0] pin_out
    );
    localparam COUNTER_SIZE = $clog2(WORD_LENGTH);

    localparam CR_ADDRESS = STARTING_ADDRESS;
    localparam DATA_ADDRESS = STARTING_ADDRESS + 1;

    // Internal signals
    reg [WORD_LENGTH - 1:0] TX_buffer;
    reg [COUNTER_SIZE:0] counter;
    reg mosi;

    assign spi_data_rdy = counter == WORD_LENGTH;

    // Updating Control Registers
    reg[7:0] control_reg; // [ 7'd0 , SPI BUSY (Active LOW)]
    assign control_reg = {7'b0, spi_data_rdy };

    // Updating Pin Out
    wire clk_out = spi_data_rdy ? 0 : clk_in;
    assign pin_out = { 5'd0, spi_data_rdy, mosi, clk_out };
    
    // Performing Reads
    assign read_data = read_enable & address == CR_ADDRESS ? control_reg : 0;

    // Performing Writes
    always @(negedge clk_in)
    begin
        // Reset the entire system 
        if(rst) begin
            TX_buffer <= 0;
            counter <= WORD_LENGTH;
            mosi <= 0;
        end
        // Write to the buffer register and transmits first bit
        if(write_enable & address == DATA_ADDRESS) begin
            TX_buffer <= write_data << 1;
            counter <= 0;
            mosi <= write_data[WORD_LENGTH - 1]; // So that old TX_buffer (00000000) isn't used
        end
        // Shifting left by one after every single bit that is shifted out
        else if(~spi_data_rdy) begin 
            TX_buffer <= TX_buffer << 1;
            counter <= counter + 3'd1;
            mosi <= TX_buffer[WORD_LENGTH - 1]; // Transmit MSB first
        end
    end

endmodule