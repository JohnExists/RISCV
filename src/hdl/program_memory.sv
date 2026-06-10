module program_memory #(
    NUMBER_OF_BYTES = 200 // TODO change to 1024, annoying place & route bug
) (
    input clk,
    input rst,
    input wire[1:0] data_width,
    input wire write_enable,
    input wire read_enable,
    input wire[9:0] address,
    input wire[31:0] write_data,
    output wire[31:0] read_data
);
    localparam BYTE = 2'b00, HALF_WORD = 2'b01, WORD = 2'b10, DOUBLE_WORD = 2'b11;
    reg [7:0] data[0:NUMBER_OF_BYTES - 1];

    // For combinational reads to the data

    wire SECOND_BYTE_ENABLE = data_width == HALF_WORD | data_width == WORD;
    wire THIRD_BYTE_ENABLE = data_width == WORD;
    wire FOURTH_BYTE_ENABLE = data_width == WORD;

    assign read_data = {32{read_enable}} & {  FOURTH_BYTE_ENABLE ? data[address + 10'd3]: 8'd0,
                                        THIRD_BYTE_ENABLE ? data[address + 10'd2]: 8'd0,
                                        SECOND_BYTE_ENABLE ? data[address + 10'd1]: 8'd0,
                                        data[address] };


    always_ff @(posedge clk) begin
       //  Clears the register data if there is a reset
       if(rst) for(int i = 0; i < NUMBER_OF_BYTES; i++) data[i] <= 0;
        // If there is no clear then write the data to the register
        if(write_enable) begin 
            data[address] <= write_data[7:0];
            data[address + 10'd1] <= SECOND_BYTE_ENABLE ? write_data[15:8] : data[address + 10'd1];
            data[address + 10'd2] <= THIRD_BYTE_ENABLE ? write_data[23:16] : data[address + 10'd2];
            data[address + 10'd3] <= FOURTH_BYTE_ENABLE ? write_data[31:24] : data[address + 10'd3];
        end
    end



endmodule