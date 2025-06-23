# TCL script to run pipeline in ModelSim


# Specify which RISC-V assembly source file to use
set program "Program/program1.s"

# Assemble the RISC-V source file into an object file (.o)
# - Uses GNU assembler for RISC-V (riscv64-unknown-elf-as)
# - Input: $program (assembly source)
# - Output: program.o (machine code in ELF object format)
exec riscv64-unknown-elf-as -o program.o $program

# Convert the ELF object file to a raw binary image
# - Uses objcopy to strip metadata, keeping only binary instructions
# - Output: program.bin (pure binary)
exec riscv64-unknown-elf-objcopy -O binary program.o program.bin


# Convert the raw binary to ASCII HEX format for Verilog's $readmemh
# - Uses xxd to format binary as hexadecimal text, 4 bytes per line
# - Output: memfile.hex (loaded by Instruction_Memory.v during simulation)
exec xxd -p -c 4 program.bin > memfile.hex


# Clear any old work library
vlib work
vmap work work

# Compile all Verilog files
vlog src/PC_Adder.v
vlog src/Instruction_Memory.v
vlog src/Single_Cycle_Top.v
vlog src/Data_Memory.v
vlog src/Sign_Extend.v
vlog src/ALU.v
vlog src/Writeback_Cycle.v
vlog src/Control_Unit_Top.v
vlog src/Execute_Cycle.v
vlog src/Fetch_Cycle.v
vlog src/pipeline_top.v
vlog src/Decode_Cycle.v
vlog src/Register_File.v
vlog src/Hazard_unit.v
vlog src/Main_Decoder.v
vlog src/ALU_Decoder.v
vlog src/Mux.v
vlog src/PC.v

# Compile your top-level testbench
vlog src/pipeline_tb.v

# Run the simulation
vsim work.pipeline_tb

#add interesting signals to waveform
add wave -r *

# run the simulation for a fixed time or until finish.
#adust nanosecond count according to the clock speed and how many instructions you want to simulate
run 1000ns

# save waveform to file
#'wave.do' is for when you add signals in the GUI, it saves your exact Wave window setup so you can reuse it next time. So next time, you
#don't have to spend time setting up wave signals, window height/width, and all that. It'll reuse from the last one
#'results.list' Dumps a plain text listing of signal values vs. time. It’s like a text log of the simulation waveforms.
write wave wave.do
write list results.list 




# quit simulator if you don't want to see it. If you want to keep the GUI on ModelSim, comment out the line below.
#quit -f