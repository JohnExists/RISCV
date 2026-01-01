`timescale 1ns/100ps
`define SIMULATION_TIME 20

module immediate_generator_tb();
    logic[31:0] instruction;
    logic[63:0] immediate;

    immediate_generator dut(
        .instruction(instruction),
        .immediate(immediate)
    );

    parameter LD = 7'b0000011, SD = 7'b0100011;
    parameter ADD = 7'b0110011, SUB = 7'b0110011, I_TYPE = 7'b0010011;
    parameter B_TYPE = 7'b1100011;

    initial begin
        instruction = 32'b0; // initial values 
        #`SIMULATION_TIME;
        $stop;
    end

    initial begin
        // Trying 1111111....opcode
        #1 instruction = { 25'd33554431, ADD  };
        #1 instruction = { 25'd33554431, SUB  };
        #1 instruction = { 25'd33554431, I_TYPE  };
        #1 instruction = { 25'd33554431, LD  };
        #1 instruction = { 25'd33554431, SD  };
        #1 instruction = { 25'd33554431, B_TYPE  };
        //
        #1 instruction = 32'b0; #5
        // Trying 1111 1111 1111 0000... opcode
        #1 instruction = { 12'b111111111111, 13'd0, I_TYPE  };
        #1 instruction = { 12'b111111111111, 13'd0, LD  };
        #1 instruction = { 12'b111111111111, 13'd0, SD  };
        #1 instruction = { 12'b111111111111, 13'd0, B_TYPE  };

        // Should output -2
        #1 instruction = 32'b11111110000000000000111111100011;
        // Should output -4
        #1 instruction = 32'b11111110000000000000111011100011;
        // Should output 1
        #1 instruction = 32'b00000000000101010000010100010011;
    end

    always @(instruction) begin
        // $display("");
    end



endmodule