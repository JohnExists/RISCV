module alu #(
    DATA_SIZE = 64
) (
    input wire[3:0] select,
    input wire[DATA_SIZE - 1:0] data_in1,
    input wire[DATA_SIZE - 1:0] data_in2,
    output reg [DATA_SIZE -1:0] data_out,
    output wire zero
);

    assign zero = (data_out == 0);
    always @(*) 
    begin
        case (select)
            4'b0000:   data_out <= data_in1 & data_in2;
            4'b0001:   data_out <= data_in1 | data_in2;
            4'b0010:   data_out <= data_in1 + data_in2;
            4'b0110:   data_out <= data_in1 - data_in2;
            4'b0111:   data_out <= data_in1 < data_in2 ? 1 : 0;
            4'b1100:   data_out <= ~(data_in1 | data_in2);
            default:   data_out<= 4'b0000;
        endcase
    end

endmodule