module gpio_controller # (
    GPIO_ADDRESS = 10'b000000000
) (
    input wire clk,
    input wire rst,

    input wire[9:0] address,
    input wire[7:0] write_data,
    input wire write_enable,
    input wire read_enable,

    output reg[7:0] read_data,
    inout reg[7:0] pin_out
);
    reg is_output;
    reg[7:0] data_reg;
    assign pin_out = data_reg;

    assign read_data = read_enable & address == GPIO_ADDRESS ? data_reg : 0;

    always_ff @(posedge clk) begin
        if(rst) begin 
            data_reg <= 0;
            is_output <= 0;
        end 
        else if(write_enable & address == GPIO_ADDRESS) data_reg <= write_data;
    end

endmodule