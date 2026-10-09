`timescale 1ns/100ps
`define SIMULATION_TIME 100

module alu_tb();
    // Input
    logic[3:0] select;
    logic[31:0] data_in1;
    logic[31:0] data_in2;

    // Output
    logic[31:0] data_out;
    logic alu_zero;
    logic alu_less_than;
    logic alu_less_than_unsigned;

    alu dut(
        .select(select),
        .data_in1(data_in1),
        .data_in2(data_in2),
        .data_out(data_out),
        .alu_zero(alu_zero),
        .alu_less_than(alu_less_than),
        .alu_less_than_unsigned(alu_less_than_unsigned)
    );


    localparam OP_AND  = 4'b0000;
    localparam OP_OR   = 4'b0001;
    localparam OP_XOR  = 4'b0010;
    localparam OP_NOR  = 4'b0011;
    localparam OP_ADD  = 4'b0100;
    localparam OP_SUB  = 4'b0101;
    localparam OP_SLL  = 4'b0110;
    localparam OP_SRL  = 4'b0111;
    localparam OP_SRA  = 4'b1000;
    localparam OP_SLTU = 4'b1001;


    initial begin
        #`SIMULATION_TIME;
        $stop;
    end

    initial begin
        select <= OP_ADD;
        data_in1 <= 32'd5;
        data_in2 <= 32'd5;
        #1;
        select <= OP_SUB;
        data_in1 <= 32'd5;
        data_in2 <= 32'd5;
        #1;
        // -1 vs 1: lt=1, ltu=0
        select <= OP_SUB;
        data_in1 <= 32'hFFFFFFFF;
        data_in2 <= 32'd1;
        #1;
        select <= OP_AND;
        data_in1 <= 32'hFFFF0000;
        data_in2 <= 32'h0F0F0F0F;
        #1;
        select <= OP_OR;
        data_in1 <= 32'hF0F0F0F0;
        data_in2 <= 32'h0F0F0F0F;
        #1;
        select <= OP_XOR;
        data_in1 <= 32'hAAAAAAAA;
        data_in2 <= 32'h55555555;
        #1;
        select <= OP_NOR;
        data_in1 <= 32'h00000000;
        data_in2 <= 32'h00000000;
        #1;
        select <= OP_SLL;
        data_in1 <= 32'd1;
        data_in2 <= 32'd4;
        #1;
        select <= OP_SRL;
        data_in1 <= 32'h80000000;
        data_in2 <= 32'd4;
        #1;
        select <= OP_SRA;
        data_in1 <= 32'h80000000;
        data_in2 <= 32'd4;
        #1;
        select <= OP_SLTU;
        data_in1 <= 32'd1;
        data_in2 <= 32'd2;
        #1;
    end


endmodule