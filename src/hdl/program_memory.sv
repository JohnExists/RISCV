// TODO Change it so that memory uses byte-addressing instead of word-addressing
module program_memory #(
    NUMBER_OF_BYTES = 10 // TODO change to 1024, annoying place & route bug
) (
    input clk,
    input rst,
    input wire[1:0] data_width,
    input wire write_enable,
    input wire read_enable,
    input wire[9:0] address,
    input wire[63:0] write_data,
    output reg[63:0] read_data
);
    localparam BYTE = 00, HALF_WORD = 01, WORD = 10, DOUBLE_WORD = 11;
    reg [7:0] data[0:NUMBER_OF_BYTES - 1];

    // For combinational reads to the data
    always_comb begin
        if(read_enable)
        begin
            case (data_width)
                BYTE: read_data = data[address];
                HALF_WORD: read_data = { data[address + 1], data[address] };
//                WORD: read_data = { data[address + 3], data[address + 2], data[address + 1], data[address] };
//                DOUBLE_WORD: read_data = { data[address + 7], data[address + 6], data[address + 5], data[address + 4], 
//                                    data[address + 3], data[address + 2], data[address + 1], data[address] };
                default: read_data = 0;
            endcase
        end
        else read_data = 0;
    end

    always_ff @(posedge clk) begin
//         Clears the register data if there is a reset
       if(rst) for(int i = 0; i < NUMBER_OF_BYTES; i++) data[i] <= 0;
//         If there is no clear then write the data to the register
        if(write_enable) begin 
           data[address] <= write_data[7:0]; 

        end
    end



endmodule