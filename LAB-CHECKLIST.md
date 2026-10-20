# Unpack and Multiply Lab: Question Checklist

Repo file to edit: `Lab-Unpack-and-Multiply/firmware/src/asmMult.s`

- [x] **Q1: Value of A in 16 bit hex for 0x9ABC1234** (Fill in, 1 pt): `0x9ABC`
- [x] **Q2: Is B positive or negative?** (Multiple choice, 1 pt): Positive (0x1234, top bit is 0)
- [x] **Q3: Value of B in 16 bit hex** (Fill in, 1 pt): `0x1234`
- [x] **Q4: A unpacked into a 32 bit register** (Fill in, 1 pt): `0xFFFF9ABC` (sign extended)
- [x] **Q5: B unpacked into a 32 bit register** (Fill in, 1 pt): `0x00001234`
- [x] **Q6: When is a product negative?** (Multiple answer, 0.5 pt): one input negative only
- [x] **Q7: Most negative signed 16 bit value** (Numeric, 1 pt): -32768
- [x] **Q8: Largest signed 16 bit value** (Numeric, 1 pt): 32767
- [x] **Q9: Valid signed comparison condition codes** (Multiple answer, 0.5 pt): GT and LE
- [x] **Q10: -32767 as 16 bit hex** (Fill in, 1 pt): `0x8001`
- [x] **Q11: -32767 as 32 bit hex** (Fill in, 1 pt): `0xFFFF8001`
- [ ] **Q12: Upload `asmMult.s`** (File upload, 40 pts, the main work)
  - [x] Change `nameStr` to your name
  - [x] Zero all variables at the start of the function
  - [x] Unpack A and B with shifts only (no SXTH/UXTH)
  - [x] Store a_Multiplicand, b_Multiplier, a_Sign, b_Sign, a_Abs, b_Abs, prod_Is_Neg
  - [x] Shift and add with r0 = multiplicand, r1 = multiplier
  - [x] Store abs_Product and final_Product, copy final to r0, `done` reached
  - [x] Negate with RSB, not flip bits and add 1
  - [x] Literals have no `#`, comments are `/* */` only
  - [ ] Run on the board once, confirm your name shows on the "ALL TESTS COMPLETE" line
- [ ] **Q13: Resources survey** (0 pts, not graded): answer honestly
