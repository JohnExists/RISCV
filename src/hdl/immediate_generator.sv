module immediate_generator (
    input wire[31:0] instruction,
    output reg[63:0] immediate_value
);
    parameter LD = 7'b0000011, SD = 7'b0100011;
    parameter ADD = 7'b0110011, SUB = 7'b0110011, ADDI = 7'b0010011;
    parameter BEQ = 7'b1100111;

    wire[6:0] opcode = instruction[6:0];
    wire[63:0] i_type = { 53'd0, instruction[31:20] };
    wire[63:0] s_type = { 53'd0, instruction[31:25], instruction[11:7] };
    wire[31:0] b_type = { 54'd0, instruction[31], instruction[7], instruction[30:25], instruction[11:8] };

   always_comb begin
       case (opcode)
           ADDI:    immediate_value = i_type; 
           LD:      immediate_value = i_type; 
           SD:      immediate_value = s_type;
           BEQ:     immediate_value = b_type;
           default: immediate_value = 0;
       endcase
   end
endmodule