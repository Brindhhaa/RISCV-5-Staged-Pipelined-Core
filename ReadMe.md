# RISC-V 5-Stage Pipelined Core

This project implements a classic 5-stage pipelined RISC-V CPU core in Verilog HDL, along with an automation flow to assemble instructions and run cycle-accurate simulations in ModelSim or QuestaSim.

---

## 📁 Folder Structure

### `src/`

This folder contains all the Verilog source files for the pipelined processor.  
Key highlights:
- Implements the **Fetch, Decode, Execute, Memory, and Writeback** pipeline stages.
- Includes supporting modules for hazard detection, forwarding, ALU control, branch prediction hooks, and pipeline registers.
- Contains the top-level pipeline integration (`pipeline_top.v`) and the testbench (`pipeline_tb.v`).

---

### `automation/`

This folder contains the **TCL automation script** that streamlines simulation:
- Assembles a RISC-V assembly source file into an ELF object, converts it to binary, and generates `memfile.hex` automatically.
- `memfile.hex` is then loaded by the Verilog `Instruction_Memory` for instruction fetch.
- Compiles all RTL source files, runs the simulation, adds signals to the waveform viewer, and saves the wave configuration (`wave.do`) and signal value dump (`results.list`).
- Fully automates the workflow so testing new programs is push-button repeatable.

---

## ✅ How to Run

1. Ensure you have the RISC-V GNU toolchain (`riscv64-unknown-elf-as` and `objcopy`) and `xxd` installed and available in your system `PATH`.
2. Open ModelSim (or QuestaSim) with GUI support.
3. From your project root, run the automation script:
   ```tcl
   do automation/automation.tcl
4. If you're running the simulation multiple times, you can also run:
   ```tcl
   do wave.do
This command essentially loads the previous settings from the last GUI simulation (the signals you had open, size of window, etc.) so that you don't have to reset these settings every time. Very helpful!
