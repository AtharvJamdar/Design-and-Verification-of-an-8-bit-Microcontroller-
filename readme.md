## Project Title

Design and Verification of an 8-bit Microcontroller using Verilog

## Project Summary

Design and Verification of 8 bit microcontroller using Verilog. Goal is to design custom microcontroller architecture with its own instruction set & verified its functionality through simulation in Vivado.

Architecture have three main parts: Datapath, Control unit & Memory system.

Datapath includes ALU, Accumulator, Program Counter (PC), Instruction Resistor (IR) & Data Register (DR).

Control unit is based on FSM & operates through four states that are LOAD, FETCH, DECODE & EXECUTE. In LOAD state we load instruction to Program Memory, during FETCH the instruction is loaded into Instruction Register. In DECODE the control signal is generated & in EXECUTE the ALU performs the required operation.

The ALU supports 14 operations such as AND, OR, XOR, ADD, SUB, shift, rotate & increment/decrement. Each instruction is 12 bit wide & classified M/S/I type for memory, immediate & special operations.

For verification I wrote multiple test programs in a binary file & loaded them into program memory. I simulated the design in Vivado & verified correct instruction execution by observing the waveforms of program counter, accumulator & status flag.

## Features

- \ Designed a custom 8-bit Harvard Architecture Microcontroller

- \ Developed in Verilog HDL

- \- 12-bit custom instruction format

- \- 4-stage instruction execution:

- \- LOAD

- \- FETCH

- \- DECODE

- \- EXECUTE

- \- FSM-based Control Unit

- \- 14 ALU operations

- \- Separate Program Memory and Data Memory

- \- Binary instruction program loading using `\$readmemb`

- \- Functional verification using multiple test programs


\- Simulation performed in Xilinx Vivado

## Processor Architecture

## RTL Module Hierarchy

MicroController

│

├── ALU

├── Control_Logic

├── Program Memory


├── Data Memory

├── Program Counter

├── Instruction Register

├── Data Register

├── Accumulator

├── Status Register

├── Adder

└── MUX1 / MUX2

## Module Description

|   | Module Description |   |   |   |   |
| --- | --- | --- | --- | --- | --- |
|   | ALU Control Logic | Performs arithmetic and logical operations Generates control signals based on current state and instruction |   |   |   |
|   | Program Counter | Holds address of next instruction |   |   |   |
|   | Program Memory | Stores program instructions |   |   |   |
|   | Data Memory Stores data Instruction Register Holds current instruction |   |   |   |   |
|   | Data Register | Stores data read from memory |   |   |   |
|   | Accumulator Status Register MUX1/MUX2 | Main working register Stores Zero, Carry, Sign and Overflow flags Select input sources |   |   |   |

## Instruction Format

Each instruction in the microcontroller is 12 bits wide. Based on the instruction encoding, the instruction set is wide. Based on the instruction encoding, the instruction set is divided into three types: M-type, I-type, and S-type.

## M-type (Memory Instruction):

One operand is the Accumulator (ACC) (or may be ignored depending on the operation), while the peration), while the second operand is obtained from the second operand is obtained from the Data Memory (DMem). The operation result is stored either in the Accumulator or back into the same Data Memory location.


## I-type (Immediate Instruction):

One operand is the Accumulator (ACC), and the second operand is an immediate value immediate value encoded within the instruction. The result of the operation is always stored in the the instruction. The result of the operation is always stored in the Accumulator.

## S-type (Special Instruction):

These instructions do not require any operands. They are used to perform special processor operations These instructions do not require any operands. They are used to perform special processor such as NOP (No Operation).

## Instruction Set

| Opcode Operation Description |
| --- |
| 0000 ADD Addition 0001 SUB Subtraction 0010 MOV Move |
| 0011 LOAD Load 0100 STORE Store 0101 AND Bitwise AND 0110 OR Bitwise OR 0111 XOR Bitwise XOR 1000 INC Increment 1001 DEC Decrement 1010 ROL Rotate Left 1011 ROR Rotate Right 1100 SHL Shift Left |
| 1101 SHR Shift Right |


## Execution Flow (FSM)

Each instruction needs 3 clock cycles to finish, i.e. FETCH stage, DECODE stage, and EXECUTE stage. Note that it is not pipelined. Together with the initial LOAD state, it can be considered as an FSM of 3 states (technically 4 states).

## States:

- 1. LOAD (initial state): load program to program memory, which takes 1 cycle per instruction loaded;

- 2. FETCH (first cycle): fetch current instruction from program memory;

- 3. DECODE (second cycle): decode instruction to generate control logic, read data memory for operand;

- 4. EXECUTE (of the third cycle): execute instruction

## Transitions:

- 1. LOAD → FETCH (initialization finish):

- a. Clear content of PC, IR, DR, Acc, SR; DMem is not required to be cleared.

- 2. FETCH → DECODE (rising edge of second cycle) :

- . IR = PMem [ PC ]

- 3. DECODE → EXECUTE

- . DR = DMem [ IR[3:0] ];

- 4. EXECUTE → FETCH (rising edge of first cycle and fourth cycle)


. For non-branch instruction, PC = PC + 1; for branch instruction, if branch is taken, PC = IR [7:0], otherwise PC = PC + 1;

- a. For ALU instruction, if the result destination is accumulator, Acc = ALU.Out; if the result destination is data memory, DMem [ IR[3:0] ] = ALU.Out.

- b. For ALU instruction, SR = ALU.Status;

The transitions can be simplified using enable port of corresponding registers, e.g. assign ALU.Out to Acc at every clock rising edge if Acc.E is set to 1. Such control signals as Acc.E are generated as a boolean function of both current state and the current instruction.

## Verification Strategy

The design was verified using a self-written Verilog testbench.

## Verification includes:

- \- Reset verification

- \- Program loading verification

- \- Arithmetic instruction verification

- \- Logical instruction verification

- \- Shift and rotate instruction verification

- \- Memory read/write verification

- \- Status flag verification

## Test Programs

To verify the functionality of the 8-bit Microcontroller, four test programs were developed. Each program focuses on validating a specific group of instructions, ensuring correct execution of memory access, arithmetic, logical, and shift/rotate operations.

## Test Program Summary

| Program | Purpose |
| --- | --- |
| Program 1 Memory Operations |   |
| Program 2 Arithmetic Operations |   |
|   | Program 3 Logic Operations |
| Program 4 Shift and Rotate Operations |   |

## Test Program 1 – Memory Operations

This program verifies the execution of memory-related instructions such as loading data from memory into the accumulator and storing the accumulator contents back to memory.

```
0000_0000_0000
1011_0000_0001
0010_0010_0000
1011_0000_0000
0011_0011_0000
0001_0000_0101
0000_0000_0000
```


```
0000_0000_0000
0000_0000_0000
0000_0000_0000
```

## Test Program 2 – Arithmetic Operations

This program validates arithmetic instructions including addition, subtraction, increment, decrement, and related arithmetic operations.

```
0000_0000_0000
1011_0000_0001
0010_0010_0000
0011_0000_0000
0010_0000_0000
0011_0001_0000
0010_0001_0000
0011_0111_0000
0010_0111_0000
0001_0000_1001
```

## Test Program 3 – Logic Operations

This program verifies logical instructions such as AND, OR, XOR, and NOT using different operand combinations.

```
0000_0000_0000
1011_0000_0101
0010_0010_0000
0010_0010_0001
0010_0010_0010
1011_0000_0011
0010_0100_0000
0010_0101_0001
0010_0110_0010
0001_0000_1001
```

## Test Program 4 – Shift and Rotate Operations

This program validates the shift and rotate instructions, including logical shifts and circular rotate operations.

```
0000_0000_0000
1011_0000_0101
1010_0000_0000
1000_0000_0111
1001_0000_0110
1111_0000_0111
1100_0000_0011
1101_0000_0101
1110_0000_0011
0001_0000_1001
```

## Simulation Results


The simulation results verify the correct functionality of the proposed 8-bit Microcontroller. Waveforms generated using the simulation tool demonstrate the execution of different instruction types, including memory, arithmetic, logic, and shift/rotate operations. The results confirm correct instruction fetching, decoding, execution, register updates, memory access, and status flag generation.

## Tools Used

- \- Xilinx Vivado (RTL Coding)

- \- QuestaSim (Simulation Waveforms)

- \- GitHub

## Authors

## Ketan Jamdar

B.E. Electronics and Telecommunication (RTL Design and Verification Engineer)

\- GitHub: https://github.com/ketan-jamdar

\- LinkedIn: https://www.linkedin.com/in/ketan-jamdar-432b6a265

## Atharv Jamdar

B.E. Electronics and Telecommunication (RTL Design and Verification Engineer)

\- GitHub: https://github.com/AtharvJamdar

\- LinkedIn: https://www.linkedin.com/in/atharv-jamdar-2a9a25197
