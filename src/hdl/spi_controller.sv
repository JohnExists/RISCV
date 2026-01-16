module spi_controller #(
        parameter WORD_LENGTH = 8
    ) (
        input rst,
        input clk_in, 
        input write_data_enable,
        input [WORD_LENGTH - 1: 0] write_data,

        output sclk,
        output reg mosi, 
        output reg spi_data_rdy
    );
    localparam COUNTER_SIZE = $clog2(WORD_LENGTH);

    // Internal signals
    reg [WORD_LENGTH - 1:0] TX_buffer;
    reg [COUNTER_SIZE:0] counter;


    assign spi_data_rdy = counter == WORD_LENGTH;
    assign sclk = spi_data_rdy ? 0 : clk_in;

    // Updating spi_data_rdy to HIGH once ALL bits are trasmitted
    always @(negedge clk_in) // TODO was posedge, but I want it to be nededgw
    begin
        // Reset the entire system 
        if(rst) begin
            TX_buffer <= 0;
            counter <= WORD_LENGTH;
        end
        // Write to the buffer register and transmits first bit
        if(write_data_enable) begin
            TX_buffer <= write_data << 1;
            counter <= 0;
        end
        // Shifting left by one after every single bit that is shifted out
        else if(~spi_data_rdy) begin 
            TX_buffer <= TX_buffer << 1;
            counter <= counter + 3'd1;
        end

    end


    always @(negedge clk_in)
    begin
        if(write_data_enable)   mosi <= write_data[WORD_LENGTH - 1]; // So that old TX_buffer (00000000) isn't used
        else                    mosi <= TX_buffer[WORD_LENGTH - 1]; // Transmit MSB first
    end

endmodule