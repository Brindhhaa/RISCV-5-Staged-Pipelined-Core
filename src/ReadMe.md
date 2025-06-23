# RISC-V 5-Stage Pipelined Core

This is a project where I implemented a 5-stage pipelined RISC-V based processor, designed in Verilog HDL. 
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
<img width="361" alt="image" src="https://github.com/user-attachments/assets/114dff61-6424-49a8-b837-c531a1a3fd24" />

**Purpose:**  
Fetches the next instruction from instruction memory and computes the next PC (Program Counter).


**Key modules:**  
- `PC.v` — Holds the current PC value.
- `Instruction_Memory.v` — Provides the instruction word.

**Inputs:**  
- `PCSrcE` (branch taken signal from EX)
- `PCTargetE` (branch target address)
- `clk`, `rst`

**Outputs:**  
- `InstrF` — Fetched instruction.
- `PCF` — Current PC for the Decode stage.

---

### 2️⃣ Instruction Decode (Decode_Cycle)

<img width="741" alt="image" src="https://github.com/user-attachments/assets/df600a2b-6cf4-434a-b435-f632742fe4f9" />

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


<img width="558" alt="image" src="https://github.com/user-attachments/assets/40748fbe-01b8-48ad-b148-ee8178064350" />

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
<img width="365" alt="image" src="https://github.com/user-attachments/assets/9fcf6d79-b251-4463-a259-39a310fdc64f" />

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
<img width="256" alt="image" src="https://github.com/user-attachments/assets/99a75a65-d2a5-4fee-99c2-6f4abc79ddfa" />

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



All images are sourced by MERLDSU!
