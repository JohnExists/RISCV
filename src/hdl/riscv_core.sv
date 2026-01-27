// TODO Finish implementation
// TODO Branch instructions are slowing down the processor WAY TOO MUCH

module riscv_core (
    input clk_in,
    input rst,
    output reg read_reg_data_2_lsb,
    output reg led0,
    output reg led1,
    output reg led2,
    output wire[15:0] io_pins
);
    reg[2:0] counter;
    reg clk;
    initial begin
        counter <= 0;
        clk <= 0;
    end
    always @(posedge clk_in) begin
        counter <= counter + 1;
        if(counter == 0) clk <= ~clk;
    end

    // wire clk = clk_in;

    // Gowin_rPLL pll(
    //     .clkout(clk), //output clkout
    //     .clkin(clk_in) //input clkin
    // );

    reg[63:0] program_counter;

    // All registers used for pipelining

    // Instruction Fetch / Instruction Decode
    reg[31:0] IF_ID_current_instruction;
    reg[63:0] IF_ID_program_counter;

    reg IF_ID_was_branch_taken;

    wire[6:0] IF_ID_opcode = IF_ID_current_instruction[6:0];
    wire[4:0] IF_ID_read_reg_addr_1 = IF_ID_current_instruction[19:15];
    wire[4:0] IF_ID_read_reg_addr_2 = IF_ID_current_instruction[24:20];
    wire[4:0] IF_ID_write_reg_addr = IF_ID_current_instruction[11:7];
    wire[2:0] IF_ID_funct3 = IF_ID_current_instruction[14:12];
    wire[6:0] IF_ID_funct7 = IF_ID_current_instruction[31:25];


    // Instruction Decode / Instruction Execute
    reg [63:0] ID_EX_program_counter;
    reg [63:0] ID_EX_read_reg_data_1;
    reg [63:0] ID_EX_read_reg_data_2;
    reg [63:0] ID_EX_immediate;
    reg [4:0] ID_EX_write_reg_addr;

    reg[3:0] ID_EX_alu_control_signal;    
    reg[2:0] ID_EX_funct3;
    reg[4:0] ID_EX_read_reg_addr_1;
    reg[4:0] ID_EX_read_reg_addr_2;

    reg ID_EX_was_branch_taken;

    wire actual_branch_taken;
    wire wrong_prediction;

    reg ID_EX_conditional_branch_enable;
    reg ID_EX_alu_imm_enable;
    reg ID_EX_mem_write_enable;
    reg ID_EX_mem_read_enable;
    reg ID_EX_reg_write_enable;
    reg ID_EX_progmem_to_reg_enable;
    reg ID_EX_next_pc_in_reg_enable;
    reg ID_EX_jump_to_alu_result;


    // Instruction Execute / Program Memory
    reg [63:0] EX_MEM_read_reg_data_2;
    reg [4:0] EX_MEM_write_reg_addr;
    reg [63:0] EX_MEM_alu_output;
    reg [63:0] EX_MEM_next_pc;
    reg [2:0] EX_MEM_funct3;
    reg EX_MEM_alu_zero;
    reg EX_MEM_alu_less_than;

    reg EX_MEM_mem_write_enable;
    reg EX_MEM_mem_read_enable;
    reg EX_MEM_reg_write_enable;
    reg EX_MEM_progmem_to_reg_enable;
    reg EX_MEM_next_pc_in_reg_enable;


    // Program Memory / Writeback
    reg [63:0] MEM_WB_progmem_read_data;
    reg [63:0] MEM_WB_alu_output;
    reg [63:0] MEM_WB_next_pc;
    reg [4:0] MEM_WB_write_reg_addr;

    reg MEM_WB_reg_write_enable;
    reg MEM_WB_progmem_to_reg_enable;
    reg MEM_WB_next_pc_in_reg_enable;

    wire[63:0] MEM_WB_write_reg_data = MEM_WB_progmem_to_reg_enable ? MEM_WB_progmem_read_data :
                                        MEM_WB_next_pc_in_reg_enable ? MEM_WB_next_pc :
                                                                        MEM_WB_alu_output;
    // All Control signals
    wire conditional_branch_enable;
    wire alu_imm_enable;
    wire reg_write_enable;
    wire mem_write_enable;
    wire mem_read_enable;
    wire progmem_to_reg_enable;
    wire next_pc_in_reg_enable;
    wire jump_to_alu_result;
    wire[3:0] alu_control_signal;
    control_unit ctrl(
        .current_instruction(IF_ID_current_instruction),
        .alu_control_value(alu_control_signal),
        .reg_write_enable(reg_write_enable),
        .conditional_branch_enable(conditional_branch_enable),
        .alu_imm_enable(alu_imm_enable),
        .mem_write_enable(mem_write_enable),
        .mem_read_enable(mem_read_enable),
        .progmem_to_reg_enable(progmem_to_reg_enable),
        .next_pc_in_reg_enable(next_pc_in_reg_enable),
        .jump_to_alu_result(jump_to_alu_result)
    );


    wire predict_branch_taken;
    wire[31:0] current_instruction;
    wire[63:0] branch_program_counter;
    wire branch_stall_pipeline;
    branch_prediction_unit bpu(
        .clk(clk),
        .rst(rst),
        .pc(program_counter),
        .instruction(current_instruction),
        .response_pc(ID_EX_program_counter),
        .response_conditional_branch_taken(actual_branch_taken),
        .response_branch_enable(ID_EX_conditional_branch_enable),
        .branch_pc(branch_program_counter),
        .predict_branch_taken(predict_branch_taken),
        .branch_stall_pipeline(branch_stall_pipeline)
    );


    // For dealing with DATA HAZARDS (EX forwards EX/MEM result, MEM forwards MEM/WB result)

    wire EX_data_hazard_1 = EX_MEM_reg_write_enable & 
                            (EX_MEM_write_reg_addr != 0) & 
                            (EX_MEM_write_reg_addr == ID_EX_read_reg_addr_1);

    wire EX_data_hazard_2 = EX_MEM_reg_write_enable & 
                            (EX_MEM_write_reg_addr != 0) & 
                            (EX_MEM_write_reg_addr == ID_EX_read_reg_addr_2);

    wire MEM_data_hazard_1 = (MEM_WB_reg_write_enable) & 
                            (MEM_WB_write_reg_addr != 0) & 
                            (MEM_WB_write_reg_addr == ID_EX_read_reg_addr_1);

    wire MEM_data_hazard_2 = MEM_WB_reg_write_enable & 
                            (MEM_WB_write_reg_addr != 0) & 
                            (MEM_WB_write_reg_addr == ID_EX_read_reg_addr_2);
    
    // For dealing with DATA HAZARDS (performs a stall if LD -> register file read)
    wire load_read_data_hazard = ID_EX_mem_read_enable &
                                    ( (ID_EX_write_reg_addr == IF_ID_read_reg_addr_1) |
                                    (ID_EX_write_reg_addr == IF_ID_read_reg_addr_2) );
                                
    wire nFlush = ~wrong_prediction & ~load_read_data_hazard & ~ID_EX_jump_to_alu_result;

    wire[63:0] alu_output;

    // Always block for updating the program counter
    always_ff @( posedge clk ) begin
        if(rst) program_counter <= 0;
        else if(wrong_prediction) program_counter <= actual_branch_taken ? ID_EX_program_counter + ID_EX_immediate : 
                                                                            ID_EX_program_counter + 64'd4;
        else if(ID_EX_jump_to_alu_result) program_counter <= alu_output;
        else if(load_read_data_hazard | branch_stall_pipeline) program_counter <= ID_EX_program_counter; // Stalls the pipeline by Redoing instruction
        else if(predict_branch_taken) program_counter <= branch_program_counter;
        else program_counter <= program_counter + 64'd4;
    end

    // programs values
    instruction_memory im (
        .rst(rst),
        .program_counter(program_counter), 
        .instruction(current_instruction)
    ); 

    /////////////////////////////////////////////////
    // For transitioning from INSTRUCTION FETCH to INSTRUCTION DECODE phase
    /////////////////////////////////////////////////
    always_ff @(posedge clk) begin
        IF_ID_current_instruction <= nFlush ? current_instruction : 32'h00000013;
        IF_ID_program_counter <= nFlush ? program_counter : 0;
        IF_ID_was_branch_taken <= nFlush ? predict_branch_taken : 0; // Stored in a register to propagate value to EX phase
    end

    wire[63:0] ID_read_reg_data_1;
    wire[63:0] ID_read_reg_data_2;
    assign read_reg_data_2_lsb = ID_read_reg_data_2[0];
    register_file rf (
        .clk(clk), 
        .rst(rst),
        .read_reg_addr_1(IF_ID_read_reg_addr_1),
        .read_reg_addr_2(IF_ID_read_reg_addr_2),
        .write_enable(MEM_WB_reg_write_enable),
        .write_reg_addr(MEM_WB_write_reg_addr),
        .write_reg_data(MEM_WB_write_reg_data),
        .read_reg_data_1(ID_read_reg_data_1),
        .read_reg_data_2(ID_read_reg_data_2)
    );

    // Immediate value generated
    wire[63:0] ID_immediate; 
    immediate_generator immgen(
        .instruction(IF_ID_current_instruction),
        .immediate(ID_immediate)
    );


    /////////////////////////////////////////////////
    // For transitioning from INSTRUCTION DECODE to INSTRUCTION EXECUTE phase
    /////////////////////////////////////////////////
    always_ff @(posedge clk) begin
        ID_EX_program_counter <= (~rst & nFlush) ? IF_ID_program_counter : 0; // makes it a 0 for rst high or nFlush low
        ID_EX_read_reg_data_1 <= nFlush ? ID_read_reg_data_1 : 0;
        ID_EX_read_reg_data_2 <= nFlush ? ID_read_reg_data_2 : 0;
        ID_EX_immediate <= nFlush ? ID_immediate : 0;
        ID_EX_write_reg_addr <= nFlush ? IF_ID_write_reg_addr : 0;
        ID_EX_funct3 <= nFlush ? IF_ID_funct3 : 0;
        ID_EX_read_reg_addr_1 <= nFlush ? IF_ID_read_reg_addr_1 : 0;
        ID_EX_read_reg_addr_2 <= nFlush ? IF_ID_read_reg_addr_2 : 0;

        ID_EX_alu_control_signal <= nFlush ? alu_control_signal : 0;
        ID_EX_conditional_branch_enable <= nFlush ? conditional_branch_enable : 0;
        ID_EX_alu_imm_enable <= nFlush ? alu_imm_enable : 0;
        ID_EX_mem_write_enable <= nFlush ? mem_write_enable : 0;
        ID_EX_mem_read_enable <= nFlush ? mem_read_enable : 0;
        ID_EX_reg_write_enable <= nFlush ? reg_write_enable : 0;
        ID_EX_progmem_to_reg_enable <= nFlush ? progmem_to_reg_enable : 0;
        ID_EX_next_pc_in_reg_enable <= nFlush ? next_pc_in_reg_enable : 0;
        ID_EX_jump_to_alu_result <= nFlush ? jump_to_alu_result : 0;

        // Stored in a register to propagate value to EX phase
        ID_EX_was_branch_taken <= nFlush ? IF_ID_was_branch_taken : 0; 

    end

    // Results of the ALU
    wire alu_zero;
    wire alu_less_than;
    alu alu (
        .select(ID_EX_alu_control_signal),
        .data_in1(EX_data_hazard_1 ? EX_MEM_alu_output : MEM_data_hazard_1 ? MEM_WB_write_reg_data : ID_EX_read_reg_data_1),
        .data_in2(ID_EX_alu_imm_enable ? ID_EX_immediate : 
                                    (EX_data_hazard_2 ? EX_MEM_alu_output : 
                                                        MEM_data_hazard_2 ? MEM_WB_write_reg_data : ID_EX_read_reg_data_2)),
        .data_out(alu_output),
        .zero(alu_zero),
        .less_than(alu_less_than)
    );


    /////////////////////////////////////////////////
    // For transitioning from INSTRUCTION EXECUTE to MEMORY phase
    /////////////////////////////////////////////////
    assign actual_branch_taken = ( (alu_zero & ID_EX_funct3 == 3'b000) | // BEQ
                                (~alu_zero & ID_EX_funct3 == 3'b001) | // BNE
                                (alu_less_than & ID_EX_funct3 == 3'b100) | // BLT
                               (~alu_less_than & ID_EX_funct3 == 3'b101) ) // BGE 
                               & ID_EX_conditional_branch_enable;

    assign wrong_prediction = ID_EX_conditional_branch_enable & (ID_EX_was_branch_taken != actual_branch_taken);
    
    always_ff @(posedge clk) begin
            EX_MEM_read_reg_data_2 <= EX_data_hazard_2 ? EX_MEM_alu_output :
                                        MEM_data_hazard_2 ? MEM_WB_write_reg_data : 
                                                ID_EX_read_reg_data_2;
            EX_MEM_alu_output <= alu_output;
            EX_MEM_next_pc <= ID_EX_program_counter + 64'd4;
            EX_MEM_alu_zero <= alu_zero;
            EX_MEM_alu_less_than <= alu_less_than;
            EX_MEM_write_reg_addr <= ID_EX_write_reg_addr;
            EX_MEM_funct3 <= ID_EX_funct3;

            EX_MEM_mem_write_enable <= ID_EX_mem_write_enable;
            EX_MEM_mem_read_enable <= ID_EX_mem_read_enable;
            EX_MEM_reg_write_enable <= ID_EX_reg_write_enable;
            EX_MEM_progmem_to_reg_enable <= ID_EX_progmem_to_reg_enable;
            EX_MEM_next_pc_in_reg_enable <= ID_EX_next_pc_in_reg_enable;
    end


    wire[63:0] progmem_read_data;
    wire[7:0] leds;
    assign led0 = leds[0];
    assign led1 = leds[1];
    assign led2 = leds[2];
    memory_management_unit mmu (
        .clk(clk), 
        .rst(rst),
        .funct3(EX_MEM_funct3),
        .mem_write_enable(EX_MEM_mem_write_enable),
        .mem_read_enable(EX_MEM_mem_read_enable),
        .address(EX_MEM_alu_output),
        .write_data( EX_MEM_read_reg_data_2),
        .read_data(progmem_read_data),
        .leds(leds),
        .io_pins(io_pins)
    );

    /////////////////////////////////////////////////
    // For transitioning from MEMORY to WRITEBACK phase
    /////////////////////////////////////////////////
    always_ff@(posedge clk) begin
        MEM_WB_progmem_read_data <= progmem_read_data;
        MEM_WB_alu_output <= EX_MEM_alu_output;
        MEM_WB_next_pc <= EX_MEM_next_pc;
        MEM_WB_write_reg_addr <= EX_MEM_write_reg_addr;

        MEM_WB_reg_write_enable <= EX_MEM_reg_write_enable;
        MEM_WB_progmem_to_reg_enable <= EX_MEM_progmem_to_reg_enable;
        MEM_WB_next_pc_in_reg_enable <= EX_MEM_next_pc_in_reg_enable;
    end

endmodule