class pipeline_sequence_item extends uvm_sequence_item;

  //sequence is basically generating the data chunk (in this case, the instruction) to be passed to the driver.  
  rand bit [31:0] instruction; //initially generating a random 32 bit value, and then will filter it out for only legal instructions that can pass to the driver


  `uvm_object_utils(pipeline_sequence_item)

  // BIG CONSTRAINT BLOCK
  constraint legal_riscv_instr {

    // Allowed opcodes for a simple integer pipeline
    instruction[6:0] inside {
      7'b0110011, // R-type ALU ops
      7'b0010011, // I-type ALU ops
      7'b0000011, // I-type LOADs
      7'b0100011, // S-type STOREs
      7'b1100011, // B-type BRANCHes
      7'b0110111, // U-type LUI
      7'b0010111, // U-type AUIPC
      7'b1101111  // J-type JAL
    };

    // For each opcode, constrain funct3/funct7 as needed:

    // R-type: opcode 0110011
    if (instruction[6:0] == 7'b0110011) {
      instruction[14:12] inside {
        3'b000, // ADD/SUB
        3'b111, // AND
        3'b110, // OR
        3'b100, // XOR
        3'b001, // SLL
        3'b101, // SRL/SRA
        3'b010, // SLT
        3'b011  // SLTU
      };
      // ADD/SUB => funct7 must be 0000000 (ADD) or 0100000 (SUB)
      // SRL/SRA => funct7 must be 0000000 (SRL) or 0100000 (SRA)
      if (instruction[14:12] inside {3'b000, 3'b101}) begin
        instruction[31:25] inside { 7'b0000000, 7'b0100000 };
      end
      // Others => funct7 must be 0000000
      else {
        instruction[31:25] == 7'b0000000;
      }
    }

    // I-type ALU: opcode 0010011
    if (instruction[6:0] == 7'b0010011) {
      instruction[14:12] inside {
        3'b000, // ADDI
        3'b111, // ANDI
        3'b110, // ORI
        3'b100, // XORI
        3'b010, // SLTI
        3'b011, // SLTIU
        3'b001, // SLLI
        3'b101  // SRLI/SRAI
      };
      // SLLI, SRLI, SRAI must have same funct7 convention
      if (instruction[14:12] inside {3'b001, 3'b101}) begin
        instruction[31:25] inside {7'b0000000, 7'b0100000};
      end
    }

    // I-type LOAD: opcode 0000011
    if (instruction[6:0] == 7'b0000011) {
      instruction[14:12] inside {
        3'b000, // LB
        3'b001, // LH
        3'b010, // LW
        3'b100, // LBU
        3'b101  // LHU
      };
    }

    // S-type STORE: opcode 0100011
    if (instruction[6:0] == 7'b0100011) {
      instruction[14:12] inside {
        3'b000, // SB
        3'b001, // SH
        3'b010  // SW
      };
    }

    // B-type BRANCH: opcode 1100011
    if (instruction[6:0] == 7'b1100011) {
      instruction[14:12] inside {
        3'b000, // BEQ
        3'b001, // BNE
        3'b100, // BLT
        3'b101, // BGE
        3'b110, // BLTU
        3'b111  // BGEU
      };
    }

    // U-type: LUI (0110111) and AUIPC (0010111)
    if (instruction[6:0] inside {7'b0110111, 7'b0010111}) {
      // No funct3/funct7; immediate bits can be random
    }



  }

  function new(string name = "pipeline_sequence_item");
    super.new(name);
  endfunction

endclass
