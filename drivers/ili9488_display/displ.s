_start:
    jal x3, displ_init

    li x11, 0xfe
    sb x11, 0x400(x0)

    # Configures display to be in 3-bit/pixel mode
    li x11, 0x3A
    jal x1, write_cmd
    li x11, 0x11 # 0x11 = 3-bit/pixel
    jal x1, write_data

    # Addressing window parameters
    li x20, 0 # x1
    li x21, 320 # x2
    li x22, 0 # y1
    li x23, 480 # y2

infinite_loop:

    li x26, 0x00
    jal x4, fill_rect
    # jal x1, large_delay
    # jal x1, large_delay 
    # jal x1, large_delay

    li x26, 0x24
    jal x4, fill_rect
    # jal x1, large_delay
    # jal x1, large_delay 
    # jal x1, large_delay

    li x26, 0x12
    jal x4, fill_rect
    # jal x1, large_delay
    # jal x1, large_delay 
    # jal x1, large_delay


    li x26, 0x09
    jal x4, fill_rect
    # jal x1, large_delay
    # jal x1, large_delay 
    # jal x1, large_delay

    li x26, 0x36
    jal x4, fill_rect
    # jal x1, large_delay
    # jal x1, large_delay 
    # jal x1, large_delay

    li x26, 0x2D
    jal x4, fill_rect
    # jal x1, large_delay
    # jal x1, large_delay 
    # jal x1, large_delay

    li x26, 0x1B
    jal x4, fill_rect
    # jal x1, large_delay
    # jal x1, large_delay 
    # jal x1, large_delay

    li x11, 0xff
    sb x11, 0x400(x0)

    j infinite_loop



fill_rect:
    jal x3, set_addr_window

    mv x24, x20 # Non-Constant for iterating over OUTER loop
    loop_outer:
        mv x25, x22 # Non-Constant for iterating over INNER loop
    loop_inner:
        mv x11, x26
        jal x1, write_data

        addi x25, x25, 1
        blt x25, x21, loop_inner
        addi x24, x24, 1
        blt x24, x23, loop_outer

    nop
    nop
    nop

    jalr x0, 0(x4)


# ******* x12 = x_1, x13 = x_2, x14 = y_1, x15 = y_2 *******
set_addr_window:
    li x16, 0x0000ff00

    # ###################################
    # ###################################
    # Writing rows addr
    # ###################################
    # ###################################

    li x11, 0x2A
    jal x1, write_cmd

    # Writing data for x1
    srli x11, x20, 8
    jal x1, write_data


    mv x11, x20 # write 8 lsb for x1 into SPI
    jal x1, write_data
  


    # Writing data for x2
    srli x11, x21, 8 
    jal x1, write_data

    mv x11, x21 # write 8 lsb for x1 into SPI
    jal x1, write_data

    # ###################################
    # ###################################
    # Writing column addr
    # ###################################
    # ###################################

    li x11, 0x2B
    jal x1, write_cmd

    # Writing data for y1
    srli x11, x22, 8
    jal x1, write_data

    mv x11, x22 # write 8 lsb for x1 into SPI
    jal x1, write_data
  

    # Writing data for y2
    srli x11, x23, 8 
    jal x1, write_data

    mv x11, x23 # write 8 lsb for x1 into SPI
    jal x1, write_data
  
    li x11, 0x2C
    jal x1, write_cmd

    jalr x0, 0(x3)


displ_init:
    # Setting RST pin HIGH since it is active LOW
    li x10, 0x01
    sb x10, 0x401(x0)

    li x11, 0x01 # Sftwr Reset
    jal x1, write_cmd

    # jal x1, large_delay # Large delay for full reset to occur

    # Setting the RST pin HIGH
    li x10, 0x00
    sb x10, 0x401(x0)

    # nop for giving time to register commands
    nop
    nop
    nop

    # Setting the RST pin LOW
    li x10, 0x01
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

    # jal x1, large_delay

    # Display ON
    li x11, 0x29
    jal x1, write_cmd

    jalr x0, 0(x3)

write_data:
    # Setting the DC pin high for writing data
    li x13, 0x03 # 0000 0011
    sb x13, 0x401(x0)

    # Calling spi
    jal x2, spi_call
    nop
    jalr x0, 0(x1)  
write_cmd:
    # Setting the DC pin low for writing commands
    li x13, 0x01 # 0000 0001
    sb x13, 0x401(x0)

    # Calling spi
    jal x2, spi_call
    nop
    jalr x0, 0(x1)

large_delay:
    li x8, 0x00ffffff
    li x11, 0 # iterator for the for loop
    loop_ld:
        addi x11, x11, 1
        blt x11, x8, loop_ld # x11 < 0x00000fff

    jalr x0, 0(x1)

spi_call:
     sb x11, 0x403(x0) # value at addr 0x403 = 0x53
    nop
    nop
    jalr x0, 0(x2) # returns back
