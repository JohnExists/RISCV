module alu #(
    DATA_SIZE = 32
) (
    input wire[3:0] select,
    input wire[DATA_SIZE - 1:0] data_in1,
    input wire[DATA_SIZE - 1:0] data_in2,
    output reg [DATA_SIZE - 1:0] data_out,
    output wire zero,
    output wire less_than
);

    assign zero = (data_out == 0);
    assign less_than = (data_out[DATA_SIZE - 1]); // Checking MSB to check if negative

    always_comb
    begin
        case (select)
            4'b0000:   data_out <= data_in1 & data_in2; // AND
            4'b0001:   data_out <= data_in1 | data_in2; // OR
            4'b0010:   data_out <= data_in1 ^ data_in2; // XOR
            4'b0011:   data_out <= ~(data_in1 | data_in2); // NOR

            4'b0100:   data_out <= data_in1 + data_in2; // ADDITION
            4'b0101:   data_out <= data_in1 - data_in2; // SUBTRACTION

            4'b0110:   data_out <= data_in1 << data_in2; // SHIFT LEFT
            4'b0111:   data_out <= data_in1 >> data_in2; // SHIFT RIGHT
            4'b1000:   data_out <= data_in1 >>> data_in2; // SHIFT RIGHT ARITHMETIC
            4'b1001:   data_out <= data_in1 < data_in2;  // A < B
            default:   data_out<= 4'b0000;
        endcase
    end


endmodule