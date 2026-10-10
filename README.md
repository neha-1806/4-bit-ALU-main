# 4-bit-ALU

This project contains the design and verification plan for a parameterized Arithmetic Logic Unit (ALU) using Verilog HDL.

An ALU is one of the most important blocks inside a processor. It performs arithmetic, logical, shift, rotate, and comparison operations on binary data. This ALU is designed as a combinational circuit and can be used as a basic building block for CPU, microprocessor, or RISC-V processor projects.

The main goal of this project is to understand how an ALU works, how different operations are selected using opcode/control signals, and how important flags such as zero, carry, borrow, overflow, and negative are generated.

---

## What is an ALU?

ALU stands for Arithmetic Logic Unit.

It takes two input operands and one control signal as input, performs the selected operation, and gives the result along with status flags.

Basic ALU structure:

```text
        A[WIDTH-1:0] --------\
                              \
                               --->  ALU  ---> Result[WIDTH-1:0]
                              /
        B[WIDTH-1:0] --------/

        Opcode/ALU_Control ---> Selects operation

        Flags ---------------> Zero, Carry, Borrow, Overflow, Negative, etc.
```

---

## Features

* Parameterized data width
* Combinational ALU design
* Supports arithmetic operations
* Supports logical operations
* Supports shift operations
* Supports rotate operations
* Supports comparison operations
* Generates important processor flags
* Handles edge cases such as carry, borrow, overflow, zero result, and signed/unsigned comparison
* Suitable for processor datapath learning
* Can be extended for simple CPU or RISC-V processor projects

---

## ALU Inputs and Outputs

| Signal   | Direction | Size  | Description                             |
| -------- | --------- | ----- | --------------------------------------- |
| A        | Input     | WIDTH | First operand                           |
| B        | Input     | WIDTH | Second operand                          |
| opcode   | Input     | 4-bit | Selects ALU operation                   |
| result   | Output    | WIDTH | Output result of selected operation     |
| zero     | Output    | 1-bit | Set when result is zero                 |
| carry    | Output    | 1-bit | Set when carry is generated in addition |
| borrow   | Output    | 1-bit | Set when borrow occurs in subtraction   |
| overflow | Output    | 1-bit | Set when signed overflow occurs         |
| negative | Output    | 1-bit | Set when MSB of result is 1             |
| equal    | Output    | 1-bit | Set when A is equal to B                |
| greater  | Output    | 1-bit | Set when A is greater than B            |
| less     | Output    | 1-bit | Set when A is less than B               |

---

## Opcode Table

| Opcode | Operation              | Description        |
| ------ | ---------------------- | ------------------ |
| 0000   | ADD                    | A + B              |
| 0001   | SUB                    | A - B              |
| 0010   | AND                    | A & B              |
| 0011   | OR                     | A | B              |
| 0100   | XOR                    | A ^ B              |
| 0101   | NOT A                  | Bitwise NOT of A   |
| 0110   | NAND                   | ~(A & B)           |
| 0111   | NOR                    | ~(A | B)           |
| 1000   | Logical Left Shift     | A << 1             |
| 1001   | Logical Right Shift    | A >> 1             |
| 1010   | Arithmetic Right Shift | A >>> 1            |
| 1011   | Rotate Left            | MSB rotates to LSB |
| 1100   | Rotate Right           | LSB rotates to MSB |
| 1101   | Equal Compare          | Checks A == B      |
| 1110   | Less Than Compare      | Checks A < B       |
| 1111   | Greater Than Compare   | Checks A > B       |

---

## Flag Description

### Zero Flag

The zero flag becomes 1 when the ALU result is zero.

Example:

```text
A = 0101
B = 0101

A - B = 0000

zero = 1
```

---

### Carry Flag

The carry flag is used in unsigned addition.

Example for 4-bit ALU:

```text
A = 1111
B = 0001

A + B = 1 0000

result = 0000
carry = 1
```

The extra bit is stored as carry.

---

### Borrow Flag

The borrow flag is used in unsigned subtraction.

Example:

```text
A = 0010
B = 0101

A - B = 1101

borrow = 1
```

Borrow occurs because A is smaller than B in unsigned subtraction.

---

### Overflow Flag

Overflow is used in signed arithmetic.

Carry and overflow are not the same.

Example for 4-bit signed addition:

```text
A = 0111   // +7
B = 0001   // +1

A + B = 1000
```

In 4-bit signed number system, the range is:

```text
-8 to +7
```

So +8 cannot be represented. Therefore:

```text
overflow = 1
```

Signed addition overflow rule:

```text
If A and B have the same sign,
but result has a different sign,
then overflow occurs.
```

Signed subtraction overflow rule:

```text
If A and B have different signs,
and result sign is different from A sign,
then overflow occurs.
```

---

### Negative Flag

The negative flag is set when the MSB of result is 1.

Example:

```text
result = 1001
negative = 1
```

This is mainly useful when the result is treated as a signed number.

---

### Equal Flag

The equal flag becomes 1 when both operands are equal.

```text
A == B
```

---

### Greater Flag

The greater flag becomes 1 when A is greater than B.

```text
A > B
```

---

### Less Flag

The less flag becomes 1 when A is less than B.

```text
A < B
```

---

## Important Edge Cases

A good ALU must handle edge cases correctly. These cases are very important during verification.

### 1. Addition Carry

```text
A = 1111
B = 0001

A + B = 1 0000
result = 0000
carry = 1
```

---

### 2. Subtraction Borrow

```text
A = 0010
B = 0101

A - B = 1101
borrow = 1
```

---

### 3. Signed Addition Overflow

```text
A = 0111   // +7
B = 0001   // +1

result = 1000
overflow = 1
```

---

### 4. Signed Subtraction Overflow

```text
A = 0111   // +7
B = 1111   // -1

A - B = +8

result = 1000
overflow = 1
```

---

### 5. Zero Result

```text
A = 0101
B = 0101

A - B = 0000
zero = 1
```

---

### 6. Negative Result

```text
result = 1000
negative = 1
```

---

### 7. Logical Shift vs Arithmetic Shift

Logical right shift fills MSB with 0.

```text
A = 1000
A >> 1 = 0100
```

Arithmetic right shift preserves the sign bit.

```text
A = 1000
A >>> 1 = 1100
```

---

### 8. Signed vs Unsigned Comparison

Same binary value can have different meaning in signed and unsigned representation.

Example:

```text
A = 1111
B = 0001
```

Unsigned interpretation:

```text
A = 15
B = 1

A > B
```

Signed interpretation:

```text
A = -1
B = 1

A < B
```

So signed and unsigned comparison must be handled carefully.

---

## Design Approach

The ALU can be divided into the following internal blocks:

```text
Arithmetic Unit
Logic Unit
Shift Unit
Rotate Unit
Comparator Unit
Flag Generator
Output Multiplexer
```

Internal block diagram:

```text
              A ----------------\
                                  \
                                   ---> Arithmetic Unit ----\
                                  /                          |
              B ----------------/                           |
                                                             |
                                   ---> Logic Unit ----------|
                                                             |
                                   ---> Shift Unit ----------|----> Output MUX ---> Result
                                                             |
                                   ---> Rotate Unit ---------|
                                                             |
                                   ---> Comparator Unit -----/

              opcode ---------------------------------------> Select Line

              result ---------------------------------------> Flag Generator
```

---

### Arithmetic Test Cases

| Operation | A    | B    | Expected Check     |
| --------- | ---- | ---- | ------------------ |
| ADD       | 0000 | 0000 | Result zero        |
| ADD       | 0001 | 0001 | Normal addition    |
| ADD       | 1111 | 0001 | Carry generation   |
| ADD       | 0111 | 0001 | Signed overflow    |
| SUB       | 0101 | 0010 | Normal subtraction |
| SUB       | 0101 | 0101 | Zero flag          |
| SUB       | 0010 | 0101 | Borrow generation  |
| SUB       | 0111 | 1111 | Signed overflow    |

---

### Logical Test Cases

Use alternating bit patterns:

```text
A = 1010
B = 0101
```

Test:

```text
AND
OR
XOR
NAND
NOR
NOT
```

These patterns help verify whether each bit is working correctly.

---

### Shift and Rotate Test Cases

| Operation              | Input A | Expected Check     |
| ---------------------- | ------- | ------------------ |
| Left Shift             | 0001    | Bit moves left     |
| Left Shift             | 1000    | MSB shift-out case |
| Right Shift            | 1000    | MSB becomes 0      |
| Arithmetic Right Shift | 1000    | Sign bit remains 1 |
| Rotate Left            | 1000    | MSB moves to LSB   |
| Rotate Right           | 0001    | LSB moves to MSB   |

---

### Comparison Test Cases

| A    | B    | Expected                       |
| ---- | ---- | ------------------------------ |
| 0101 | 0101 | Equal                          |
| 0110 | 0011 | Greater                        |
| 0010 | 0101 | Less                           |
| 1111 | 0001 | Check signed/unsigned behavior |

---


## Tools Used

This project can be simulated using any Verilog simulator such as:

* Xilinx Vivado
* ModelSim
* Icarus Verilog
* GTKWave
* EDA Playground

---

## Conclusion

This ALU project is a strong beginner-to-intermediate Verilog project. It covers important digital design concepts such as arithmetic circuits, logic circuits, shifting, rotating, comparison, flags, and verification.

A properly designed and tested ALU can later be used as a building block for larger projects like a simple CPU, microprocessor, or RISC-V processor.
