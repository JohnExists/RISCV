// TODO Change it so that memory uses byte-addressing instead of word-addressing
module program_memory #(
    NUMBER_OF_WORDS = 6
) (
    input clk,
    input rst,
    input wire mem_write_enable,
    input wire mem_read_enable,
    input wire[63:0] read_write_addr,
    input wire[63:0] write_data,
    output reg[63:0] read_data,
    output wire led0,
    output wire led1,
    output wire led2
);
    reg [31:0] data[0:NUMBER_OF_WORDS - 1];

    // For combinational reads to the data
    assign read_data = mem_read_enable ? { data[read_write_addr], data[read_write_addr + 1] } :
                        0 ;

    assign led0 = ~data[1][0];
    assign led1 = ~data[3][0];
    assign led2 = ~data[5][0];

    always_ff @(posedge clk) begin
        // Clears the register data if there is a reset
        if(rst) for(int i = 0; i < NUMBER_OF_WORDS; i++) data[i] <= 0;
        // If there is no clear then write the data to the register
        if(mem_write_enable) begin 
            data[read_write_addr] <= write_data[63:32]; 
            data[read_write_addr + 1] <= write_data[31:0]; 
        end
    end


endmodule