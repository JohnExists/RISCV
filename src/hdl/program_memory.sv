module program_memory #(
    NUMBER_OF_BYTES = 4096
) (
    input clk,
    input rst,
    input is_unsigned,
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

//    assign read_data = {32{read_enable}} & {  FOURTH_BYTE_ENABLE ? data[address + 10'd3]: 8'd0,
//                                        THIRD_BYTE_ENABLE ? data[address + 10'd2]: 8'd0,
//                                        SECOND_BYTE_ENABLE ? data[address + 10'd1]: 8'd0,
//                                        data[address] };

    reg[31:0] dout;
    
    Gowin_SP your_instance_name(
        .dout(dout), //output [31:0] dout
        .clk(clk), //input clk
        .oce(1'd1), //input oce
        .ce(1'd1), //input ce
        .reset(rst), //input reset
        .wre(write_enable), //input wre
        .ad({2'd0, address}), //input [11:0] ad
        .din(write_data) //input [31:0] din
    );
    assign read_data = {32{read_enable}} & WORD ? dout : 
            HALF_WORD ? { is_unsigned ? 16'd0 : {16{dout[15]}}, dout[15:0] } : 
                        {  is_unsigned ? 24'd0 : {24{dout[7]}}, dout[7:0] } ;

    // always_ff @(posedge clk) begin
       //  Clears the register data if there is a reset
       //if(rst) for(int i = 0; i < NUMBER_OF_BYTES; i++) data[i] <= 0;
        // If there is no clear then write the data to the register
//        if(write_enable) begin 
//            data[address] <= write_data[7:0];
//            data[address + 10'd1] <= SECOND_BYTE_ENABLE ? write_data[15:8] : data[address + 10'd1];
//            data[address + 10'd2] <= THIRD_BYTE_ENABLE ? write_data[23:16] : data[address + 10'd2];
//            data[address + 10'd3] <= FOURTH_BYTE_ENABLE ? write_data[31:24] : data[address + 10'd3];
//        end
    // end
endmodule