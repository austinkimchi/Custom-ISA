// Santa Clara University, CSEN 122, Fall 2025
// By: Professor Cho
// Reference SCU ISA assembly codes for 1-d stencil
//
// Problem description: for given array A and B, compute
//
// B[0] = A[0]
// B[i] = median(A[i-1], A[i], A[i+1]), if i > 0 and i < n-1
// B[n-1] = A[n-1]
//
// Assumptions:
//
// SCU ISA uses word addressing
// x1 = n (array size) (assuming n > 2)
// x2 = &A[0]
// x3 = &B[0]
//
// Register usage assumed:
//
// x0,x4-x39: to be used as temporal registers
// x40-x62: to be used for saving instruction addresses (by SVPC)
//
// note: if you run this code on your SCU ISA pipelined computer, the code may
// not run correctly, unless you have all the ALU forwarding unit and hazard
// detection unit implemented. You may want to insert NOPs appropriately to
// ensure correct execution.
//
// note: there can be multiple different implementations of course.
//

// PROLOGUE:
<00>:    SVPC    x40, 19         // save addr of LOOP_BODY (y = 19-0)
<01>:    SVPC    x41, 69         // save addr of EPILOGUE (y = 70-1)
<02>:    SVPC    x42, 48         // save addr of SWAP_1 (y = 50-2)
<03>:    SVPC    x43, 53         // save addr of SWAP_2 (y = 56-3)
<04>:    SVPC    x44, 59         // save addr of SWAP_3 (y = 63-4)
<05>:    SVPC    x45, 25         // return addr from SWAP_1 (y = 30-5)
<06>:    SVPC    x46, 28         // return addr from SWAP_2 (y = 34-6)
<07>:    SVPC    x47, 31         // return addr from SWAP_3 (y = 38-7)

<08>:    INC     x4, x1, -1      // save n-1 to x4
// Assume A array contains [3,1,5,7,2,9,8]
// Result: B =             [3,3,5,5,7,8,8]
<09>:    LD      x20, x2, 0      // load A[0] to x20;  y=0, rd=x10, rs=x2, rt=NA
// x20 is A[0] which is 3.
// This works correctly as observed in simulation.
<10>:    NOP
<11>:    NOP
<12>:    NOP

<13>:    ST      x20, x3, 0      // store x20 to B[0]; y=0, rd=NA, rs=x3, rt=x10
// ST works correctly as observed in simulation.
<14>:    SUB     x0, x0, x0      // making x0 as 0
<15>:    INC     x10, x0, 1      // set x10 (for variable i) as 1
// i starts at 1.
<16>:    NOP
<17>:    NOP
<18>:    NOP

// LOOP_BODY:
<19>:    ADD     x11, x2, x10    // addr of A[i]:x11=&A[0]+i
<20>:    ADD     x12, x3, x10    // addr of B[i]:x12=&B[0]+i
<21>:    NOP
<22>:    NOP

// x11 is A[1] which is &A=2 so should be address 3;
// x12 is B[1] which is &B=71 so should be address 72.

<23>:    LD      x13, x11, -1    // load A[i-1] to x13
<24>:    LD      x14, x11, 0     // load A[i] to x14
<25>:    LD      x15, x11, 1     // load A[i+1] to x15
// LD three elements: (correctly loaded)
// A[0]: 3
// A[1]: 1
// A[2]: 5


<26>:    NOP
<27>:    NOP

<28>:    SUB     x5, x14, x13    // x5 = x14 - x13 = 1 - 3 = -2 (correct output)
<29>:    BRN     x42             // SWAP_1 if x13 > x14 : x42 (got address 34)
<30>:    NOP                     // SWAP_1 returns here to avoid hazard
<31>:    NOP
<32>:    SUB     x5, x15, x14    //
<33>:    BRN     x43             // SWAP_2 if x15 > x14
<34>:    NOP                     // SWAP_2 returns here to avoid hazard
<35>:    NOP
<36>:    SUB     x5, x14, x13    //
<37>:    BRN     x44             // SWAP_3 if x13 > x14
                                 // after this, x14 holds the median of
                                 // the three elements
<38>:    NOP                     // SWAP_3 returns here to avoid hazard
<39>:    NOP
<40>:    ST      x14, x12, 0     // save x14 to B[i]
<41>:    INC     x10, x10, 1     // i = i+1
<42>:    NOP
<43>:    NOP
<44>:    NOP
<45>:    SUB     x5, x10, x4     // to compare i and n-1
<46>:    BRZ     x41             // goto epilogue if epilogue if i == n-1
<47>:    NOP
<48>:    NOP
<49>:    J       x40             // repeat LOOP_BODY

// SWAP_1 (swap x13 and x14)
<50>:    NOP
<51>:    ADD     x20, x13, x0   // x13 = 3
<52>:    ADD     x13, x14, x0   // x14 = 1
<53>:    NOP
<54>:    J       x45
<55>:    ADD     x14, x20, x0   // x14 = 3

// SWAP_2 (swap x14 and x15)
<56>:    NOP
<57>:    NOP
<58>:    ADD     x20, x14, x0
<59>:    ADD     x14, x15, x0
<60>:    NOP
<61>:    J       x46
<62>:    ADD     x15, x20, x0

// SWAP_3 (swap x13 and x14)
<63>:    NOP
<64>:    NOP
<65>:    ADD     x20, x13, x0
<66>:    ADD     x13, x14, x0
<67>:    NOP
<68>:    J       x47
<69>:    ADD     x14, x20, x0

// EPILOGUE
<70>:    ADD     x11, x2, x10    // addr of A[i]
<71>:    ADD     x12, x3, x10    // addr of B[i]
<72>:    NOP
<73>:    NOP
<74>:    LD      x20, x11, 0     // load A[i] to x20
<75>:    NOP
<76>:    NOP
<77>:    NOP
<78>:    ST      x20, x12, 0     // store x20 into B[i]

// END OF PROGRAM