# Automation Script for RISC-V Pipelined Core Simulation

This folder contains the TCL script that fully automates the assembly, compilation, and simulation of the 5-stage pipelined RISC-V processor using ModelSim (compatible with QuestaSim too).

---

## Files

- **`automation.tcl`**  
  Automates the complete flow:
  - Assembles a RISC-V `.s` assembly source file into an ELF object, extracts its raw binary, and converts it to `memfile.hex` in ASCII format.
  - `memfile.hex` is automatically loaded by `Instruction_Memory.v` to supply instructions to the Fetch stage.
  - Creates a fresh ModelSim `work` library.
  - Compiles all RTL source files and the top-level testbench.
  - Instantiates the design under test (DUT) and sets up the simulation.
  - Adds all relevant signals to the waveform viewer.
  - Runs the simulation for a specified duration (adjustable to cover desired clock cycles).
  - Saves the waveform viewer configuration to `wave.do` and dumps signal values to `results.list` for later inspection or reuse.
  - Optionally exits the simulator automatically (comment out the `quit -f` line if you prefer to keep the GUI open after running).

---

## How I use it

1. Open ModelSim (or QuestaSim — this script works with both) with GUI support.
2. Make sure your RISC-V assembly source (e.g., `program1.s`) is located in the expected folder specified in the script.
3. Navigate to the project root directory in the simulator console.
4. Run the automation script:
   ```tcl
   do automation/automation.tcl
