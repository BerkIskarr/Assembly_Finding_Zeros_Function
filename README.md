# Cramer's Rule Assembly Implementation

This repository contains an implementation of solving a system of linear equations using Cramer's Rule in x86-64 Assembly language.

## Overview

This program solves a system of two linear equations with two unknowns:
ax1 + bx2 = c dx1 + ex2 = f

The program calculates the solutions for `x1` and `x2` using Cramer's Rule and handles cases where the determinant is zero, which would indicate that the system has no solution.

### Equations

- **Equation 1**: `ax1 + bx2 = c`
- **Equation 2**: `dx1 + ex2 = f`

### Variables

- `a`, `b`, `c`, `d`, `e`, `f`: Coefficients and constants in the equations.
- `A0`: Determinant of the coefficient matrix (`a*e - b*d`).
- `A1`, `A2`: Determinants used to solve for `x1` and `x2`.

## Program Structure

The program is organized into the following sections:

### `.data`

This section contains initialized data, including:

- Coefficients `a`, `b`, `c`, `d`, `e`, `f`
- Strings for displaying the equations and the solution or error messages.

### `.bss`

This section reserves space for variables that store intermediate results:

- `A0`, `A1`, `A2`: Used to store determinant values.
- `x1`, `x2`: Used to store the solutions for the equations.

### `.text`

This is the main execution section of the program. It includes:

- **Equation Display**: Prints the equations `ax1 + bx2 = c` and `dx1 + ex2 = f`.
- **Determinant Calculation**: Computes the determinant `A0` and checks if it's zero.
- **Solution Calculation**: If `A0` is non-zero, calculates `x1` and `x2`.
- **Output**: Prints the calculated values of `x1` and `x2` using `printf`.
- **Zero Determinant Handling**: If `A0` is zero, prints "No solution!".

### Key Instructions

- **`movsd`**: Moves and manipulates double-precision floating-point numbers.
- **`mulsd`**, **`subsd`**, **`divsd`**: Performs floating-point multiplication, subtraction, and division.
- **`syscall`**: Used for system calls such as `write` for output and `exit` to terminate the program.
- **`call printf`**: Calls the `printf` function to display the solutions.

## Prerequisites

Ensure that you have the necessary tools to assemble and run x86-64 assembly code:

- **Assembler**: `nasm`
- **Linker**: `ld`

## Building and Running the Program

### Step 1: Assemble the Code

Use NASM to assemble the source file:

```bash
nasm -f elf64 -o cramer.o cramer.asm



