module register_file #(
    NUMBER_OF_REGISTERS = 32,
    REGISTER_BIT_SIZE = 32,
    REGISTER_ADDR_SIZE = $clog2(NUMBER_OF_REGISTERS)
) (
    input clk,
    input rst,
    input wire[REGISTER_ADDR_SIZE - 1:0] read_reg_addr_1,
    input wire[REGISTER_ADDR_SIZE - 1:0] read_reg_addr_2,
    input write_enable,
    input[4:0] write_reg_addr,
    input[REGISTER_BIT_SIZE - 1:0] write_reg_data,
    output wire [REGISTER_BIT_SIZE - 1:0] read_reg_data_1,
    output wire [REGISTER_BIT_SIZE - 1:0] read_reg_data_2
);
    // Sets up the data for the registers
    reg [REGISTER_BIT_SIZE - 1:0] reg_data [0:NUMBER_OF_REGISTERS - 1];

    // For combinational reads to the data (mux as to perform register file bypassing)
    // assign read_reg_data_1 = reg_data[read_reg_addr_1];
    // assign read_reg_data_2 = reg_data[read_reg_addr_2];
    assign read_reg_data_1 = (write_enable && write_reg_addr != 0 && write_reg_addr == read_reg_addr_1)
                            ? write_reg_data : reg_data[read_reg_addr_1];
    assign read_reg_data_2 = (write_enable && write_reg_addr != 0 && write_reg_addr == read_reg_addr_2)
                            ? write_reg_data : reg_data[read_reg_addr_2];


    // For sequential writes to the data / clears
    always@(posedge clk) begin
        // Clears the register data if there is a reset
        if(rst) begin
            reg_data[0] <= 0;
            reg_data[1] <= 0;            
            reg_data[2] <= 32'd100;
            for(int i = 3; i < NUMBER_OF_REGISTERS; i++) reg_data[i] <= 0; // TODO change 0 to i
        end
        // If there is no clear then write the data to the register
        else(write_enable & write_reg_addr != 0) begin reg_data[write_reg_addr] <= write_reg_data; end
    end

endmodule
