_start:
    jal x3, displ_init

infinite_loop:
    j infinite_loop

displ_init:
    li x11, 0x01 # Sftwr Reset
    jal x1, write_cmd

    jal x1, large_delay # Large delay for full reset to occur

    # Setting the RST pin HIGH
    li x10, 0x01
    sb x10, 0x401(x0)
    jal x1, large_delay # Large delay for full reset to occur
    # Setting the RST pin LOW
    li x10, 0x00
    sb x10, 0x401(x0)

    # Power Control
    li x11, 0xC0
    jal x1, write_cmd
    li x11, 0x17    # VRH[5:0]
    jal x1, write_data

    li x11, 0xC1 # SKIPPED
    jal x1, write_cmd
    li x11, 0x12    # SAP[2:0]; BT[3:0]
    jal x1, write_data

    # VCOM Control
    li x11, 0xC5
    jal x1, write_cmd
    li x11, 0x32        # VCM_REG[7:0] # SKIPPED
    jal x1, write_data
    li x11, 0x3C        # VCM_REG[7:0]
    jal x1, write_data

    # Memory Access Control
    li x11, 0x36
    jal x1, write_cmd
    li x11, 0x48       # MX, BGR mode # SKIPPED
    jal x1, write_data

    # Interface Pixel Format
    li x11, 0x3A 
    jal x1, write_cmd
    li x11, 0x11      # 0x66 = 18-bit/pixel
    jal x1, write_data

    # Frame Rate Control
    li x11, 0xB1
    jal x1, write_cmd
    li x11, 0xB0      # 0x66 = 18-bit/pixel
    jal x1, write_data

    # Display Function Control
    li x11, 0xB6
    jal x1, write_cmd
    li x11, 0x02
    jal x1, write_data
    li x11, 0x02
    jal x1, write_data

    # Set Image Function
    li x11, 0xE9
    jal x1, write_cmd
    li x11, 0x00
    jal x1, write_data

    # Adjust Control 3
    li x11, 0xF7
    jal x1, write_cmd
    li x11, 0xA9
    jal x1, write_data
    li x11, 0x51
    jal x1, write_data
    li x11, 0x2C
    jal x1, write_data
    li x11, 0x82
    jal x1, write_data

    # Sleep Out
    li x11, 0x11
    jal x1, write_cmd

    jal x1, large_delay

    # Display ON
    li x11, 0x29
    jal x1, write_cmd

write_data:
    # Setting the DC pin high for writing data
    li x13, 0x02
    sb x13, 0x401(x0)

    # Calling spi
    jal x2, spi_call
    nop
    jalr x0, 0(x1)  
write_cmd:
    # Setting the DC pin low for writing commands
    li x13, 0x00
    sb x13, 0x401(x0)

    # Calling spi
    jal x2, spi_call
    nop
    jalr x0, 0(x1)

large_delay:
    # lui x8, 0x00ffff
    # addi x8, x8, 0xff # Constant variable for comparing with for loops
    addi x8, x0, 0x0f # Constant variable for comparing with for loops

    li x11, 0 # iterator for the for loop
    loop_ld:
        add x11, x11, 1
        blt x11, x8, loop_ld # x11 < 1048575

    jalr x0, 0(x1)

spi_call:
     sb x11, 0x403(x0) # value at addr 0x403 = 0x53
loop:
    lb x12, 0x402(x0) # load status bit of SPI
    nop
    beq x12, x0, loop # loop if status bit is off
    
    nop
    jalr x0, 0(x2) # returns back
