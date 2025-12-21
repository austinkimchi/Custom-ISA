// This code will test NEG instruction

// CONTINUE FROM PREVIOUS PROGRAM
// MAKE SURE PREVIOUS PROG IS CLEARED

<79>:    NOP
<80>:    NOP
<81>:    SUB     x0, x0, x0      // Clear x0 to 0
<82>:    INC     x1, x0, 5       // Load 5 into x1
<83>:    INC     x2, x0, 10      // Load 10
<84>:    NOP
<85>:    NOP
<86>:    NOP
<87>:    NEG     x3, x1          // x3 = -x1 = -5
<88>:    NEG     x4, x2          // x4 = -x2 = -10

// END OF PROGRAM