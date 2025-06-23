# RISC-V 5-Stage Pipelined Core

This project implements a classic 5-stage pipelined RISC-V processor, designed in Verilog HDL. The pipeline is built for educational and research purposes, demonstrating modern CPU architecture concepts such as instruction pipelining, hazard detection, forwarding, and modular stage design.

---

## Architecture Overview

The processor is organized into five pipeline stages:

1. **Instruction Fetch (IF)**
2. **Instruction Decode (ID)**
3. **Execute (EX)**
4. **Memory Access (MEM)**
5. **Writeback (WB)**

Each stage is implemented as a separate module, with inter-stage pipeline registers handling data and control signal propagation.

---

## Pipeline Stages

### 1️⃣ Instruction Fetch (Fetch_Cycle)

**Purpose:**  
Fetches the next instruction from instruction memory and computes the next PC (Program Counter).

**Key modules:**  
- `PC.v` — Holds the current PC value.
- `PC_Adder.v` — Computes `PC + 4`.
- `Instruction_Memory.v` — Provides the instruction word.

**Inputs:**  
- `PCSrcE` (branch taken signal from EX)
- `PCTargetE` (branch target address)
- `clk`, `rst`

**Outputs:**  
- `InstrF` — Fetched instruction.
- `PCPlus4F` — Next sequential PC.
- `PCF` — Current PC for the Decode stage.

**Logic:**  
By default, `PC + 4` is computed to fetch sequential instructions. If a branch is resolved in Execute, `PCSrcE` redirects the PC to `PCTargetE`.

---

### 2️⃣ Instruction Decode (Decode_Cycle)

**Purpose:**  
Decodes the instruction, generates control signals, reads register operands, and computes immediate values.

**Key modules:**  
- `Control_Unit_Top.v` — Includes `Main_Decoder` and `ALU_Decoder`.
- `Register_File.v` — Stores CPU registers.
- `Sign_Extend.v` — Extends immediate fields.

**Inputs:**  
- `InstrD` — Instruction from Fetch stage.
- `ResultW` — Writeback result.
- `RD_W` — Destination register for Writeback.
- `RegWriteW` — Writeback enable.
- `clk`, `rst`

**Outputs:**  
- `RD1D`, `RD2D` — Register operands.
- `ImmExtD` — Sign-extended immediate.
- Control signals: `ALUSrcD`, `ResultSrcD`, `MemWriteD`, `BranchD`, `ALUControlD`.

**Logic:**  
Splits the instruction fields (opcode, funct3, funct7, rs1, rs2, rd) and determines the control signals to drive ALU and memory operations.

---

### 3️⃣ Execute (Execute_Cycle)

**Purpose:**  
Performs ALU operations, computes branch conditions, and generates branch decisions.

**Key modules:**  
- `ALU.v` — Arithmetic and logical unit.
- Forwarding logic — Ensures data hazards are resolved dynamically.

**Inputs:**  
- Register operands (`RD1E`, `RD2E`)
- Immediate (`ImmExtE`)
- ALU control signals
- Forwarding control signals (`ForwardAE`, `ForwardBE`)

**Outputs:**  
- `ALUResultE` — Computed ALU output.
- `PCSrcE` — Branch taken decision.
- `PCTargetE` — Computed branch target.

**Logic:**  
Selects ALU operands based on forwarding logic, performs the operation (add, sub, and, or, slt, etc.), and determines if a branch condition is met.

---

### 4️⃣ Memory Access (Memory_Cycle)

**Purpose:**  
Handles data memory read and write operations for load/store instructions.

**Key modules:**  
- `Data_Memory.v` — Simple RAM model.

**Inputs:**  
- `ALUResultM` — Address to read or write.
- `WriteDataM` — Data to store.
- `MemWriteM` — Memory write enable.

**Outputs:**  
- `ReadDataM` — Data loaded from memory.

**Logic:**  
Executes read or write depending on instruction type (LW, SW). For stores, writes `WriteDataM` to memory. For loads, retrieves data to be written back later.

---

### 5️⃣ Writeback (Writeback_Cycle)

**Purpose:**  
Chooses the final data to be written back to the register file.

**Inputs:**  
- `ReadDataW` — Data loaded from memory (for LW).
- `ALUResultW` — ALU output (for R-type instructions).
- `PCPlus4W` — PC + 4 for jump and link instructions.
- `ResultSrcW` — Selects which source to write back.

**Outputs:**  
- `ResultW` — Value to write to the register file.
- `RD_W` — Register address to write to.
- `RegWriteW` — Writeback enable.

**Logic:**  
Selects from multiple sources based on the instruction type, ensuring the correct data updates the register file.

---

## Hazard Detection & Forwarding

The pipeline includes a `Hazard_unit.v` module that:
- Detects data hazards between stages.
- Generates forwarding control signals to bypass data directly from later stages to ALU inputs.
- Controls stalling or flushing to handle branch mispredictions.

---

## How to Run

1. Compile using ModelSim/QuestaSim or your preferred simulator.
2. Use the TCL script in the `automation/` folder to automate compilation, simulation, and waveform generation.
3. Inspect signals and debug pipeline execution using the integrated waveform viewer.

---

## License

This project is for educational purposes. Modify and expand freely to explore advanced pipelining features like branch prediction, caches, or multi-cycle memory.

