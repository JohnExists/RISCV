// change name to spi_master_half_duplex
module spi_master_half_duplex #(
        parameter WORD_LENGTH = 8
    ) (
        input rst,
        input data_valid,
        input clk_in, 
        input [WORD_LENGTH - 1: 0] data,

        output reg mosi, 
        output reg cs,
        output clk_out,
        output reg data_done
    );
   
    // Internal signals
    localparam COUNTER_SIZE = $clog2(WORD_LENGTH);
    localparam WORD_LENGTH_MINUS_ONE = WORD_LENGTH - 3'b001;

    reg [WORD_LENGTH_MINUS_ONE:0] buffer;
    reg [COUNTER_SIZE:0] counter;

    reg done_clk_counter;

    assign clk_out = cs ? 0 : clk_in;


    // Load data into the buffer so we don't loose it.
    always @(posedge data_valid) begin
        buffer <= data;
    end

    always @(posedge clk_in) begin
        if(counter < WORD_LENGTH_MINUS_ONE) done_clk_counter <= 0;
        else
        begin
            // For the data_done to only stay for one pulse
            if(done_clk_counter == 0)
            begin
                data_done <= 1;
                done_clk_counter <= 1;
            end
            else data_done <= 0;
            
        end

    end

    always @(negedge clk_in or posedge rst)
    begin
        // Reset the entire system 
        if(rst)
        begin
            counter <= 0;
            cs <= 1'b1; // maybe change to one idk
        end
        // updates the bits on the MOSI line 
        else if(counter <= WORD_LENGTH_MINUS_ONE) 
        begin
            cs <= 1'b0;
            mosi <= buffer[counter];
            counter <= counter + 3'b1;
            // Since its running constantly reset to zero
        end
        // If the data is done transmitting
        else
        begin
            cs <= 1'b1;
            mosi <= 1'b0;
        end
    end

endmodule