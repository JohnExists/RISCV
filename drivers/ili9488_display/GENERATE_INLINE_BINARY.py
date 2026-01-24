import subprocess

subprocess.run("riscv64-unknown-elf-gcc -march=rv32i -mabi=ilp32 -nostdlib -static -Ttext 0x0 -Wl,--build-id=none -o displ.elf displ.s".split(" "))
subprocess.run("riscv64-unknown-elf-objcopy -O binary displ.elf displ.bin".split(" "))
hexdump_str = subprocess.run(['hexdump', '-e', '16/1 "%02x " "\n"', "displ.bin"], capture_output=True, text=True, check=True).stdout

hexdump_str = str(hexdump_str).replace("\n", " ")
hexdump = hexdump_str.split(" ")
hexdump = list(filter(None, hexdump))

it = 0
counter = 0
str = ""
while(it != len(hexdump)):
    if(it >= 100000): break
    str += f"instruction_data[{counter}] <= 32'h{hexdump[it + 3]}{hexdump[it + 2]}{hexdump[it + 1]}{hexdump[it + 0]};\n"
    counter += 1
    it += 4

str += f"for(int i = {counter}; i < NUMBER_OF_INSTRUCTIONS; i++) instruction_data[i] <= 0;"
print(str)
