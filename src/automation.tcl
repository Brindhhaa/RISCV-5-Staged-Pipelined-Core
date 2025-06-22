# TCL script to run pipeline in ModelSim

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
write wave wave.do
write list results.list

# quit simulator if you don't want to see it. If you want to keep the GUI on ModelSim, comment out the line below.
#quit -f