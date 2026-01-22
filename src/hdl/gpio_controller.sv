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
    output reg[7:0] pin_out
);
    reg[7:0] data_reg;
    assign pin_out = data_reg;

    assign read_data = read_enable & address == GPIO_ADDRESS ? data_reg : 0;

    always_ff @(posedge clk) begin
        if(rst) data_reg <= 0;
        else if(write_enable & address == GPIO_ADDRESS) data_reg <= write_data;
    end

endmodule