# Automation Scripts for RISC-V Pipelined Core Simulation

This folder contains the TCL script that automates the compilation and simulation of the 5-stage pipelined RISC-V processor using ModelSim (compatable with QuestaSim too).

---

## Files

- **`automation.tcl`**  
  Automates the entire simulation flow:
  - Creates a fresh work library.
  - Compiles all RTL source files and the top-level testbench.
  - Instantiates the design under test (DUT) and sets up the simulation.
  - Adds all relevant signals to the waveform viewer.
  - Runs the simulation for a specified duration (dependent on how many clock cycles you want).
  - Saves wave configuration and signal values to my device.
  - Exits the simulator (optional if you want to close the GUI at end of simulation)

---

## How I used it

1. Open ModelSim (or QuestaSim - this works with both) with GUI support.
2. Navigate to the project root directory in the simulator console.
3. Run the automation script:
   ```tcl
   do automation/run.tcl
