`timescale 1ns / 1ps

module tb_cpu;

    // Inputs
    reg clk;
    reg rst;

    // Instantiate the Unit Under Test (UUT)
    cpu uut (
        .clk(clk),
        .rst(rst)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // At 20 ns here
    integer i;
    reg [6:0]  idx [0:7];
    reg [31:0] exp_val [0:7];
    
    initial begin
        rst = 1;
        #20;
        rst = 0;
        $display("Starting Simulation.");
        
        $display("--------------------------------------------------");
        $display("Checking A array is correctly initialized         ");
        $display("--------------------------------------------------");
        // SETUP:       idx     - stored register, 
        //              exp_val - abs value (relative to prog)
        idx[0] = 7'd2;  exp_val[0] = 32'd3;
        idx[1] = 7'd3;  exp_val[1] = 32'd1;
        idx[2] = 7'd4;  exp_val[2] = 32'd5;
        idx[3] = 7'd5;  exp_val[3] = 32'd7;
        idx[4] = 7'd6;  exp_val[4] = 32'd2;
        idx[5] = 7'd7;  exp_val[5] = 32'd9;
        idx[6] = 7'd8;  exp_val[6] = 32'd8;
    
        for (i = 0; i < 7; i = i + 1) begin
            if (uut.dm.mem[idx[i]] === exp_val[i]) begin
                $display("[PASS] Index x%0d: Correct (%0d)",
                        idx[i], exp_val[i]);
            end else begin
                $display("[FAIL] Index x%0d: Found %0d, Expected (%0d)",
                        idx[i], uut.dm.mem[idx[i]], exp_val[i]);
            end
        end
        
        // Each cycle takes 10 ns
        // Check that SVPC loaded into reg correctly.
        #80; // 8 inst. time
        #50; // 5 cycle time for WB stage
        
        $display("--------------------------------------------------");
        $display("Checking SVPC Data Setup (<00>-<07>)              ");
        $display("--------------------------------------------------");
        
        // SETUP:       idx     - stored register, 
        //              exp_val - abs value (relative to prog)
        idx[0] = 7'd40;  exp_val[0] = 32'd19;
        idx[1] = 7'd41;  exp_val[1] = 32'd70;
        idx[2] = 7'd42;  exp_val[2] = 32'd50;
        idx[3] = 7'd43;  exp_val[3] = 32'd56;
        idx[4] = 7'd44;  exp_val[4] = 32'd63;
        idx[5] = 7'd45;  exp_val[5] = 32'd30;
        idx[6] = 7'd46;  exp_val[6] = 32'd34;
        idx[7] = 7'd47;  exp_val[7] = 32'd38;

        // single loop to check all of them
        for (i = 0; i < 8; i = i + 1) begin
            if (uut.regfile.regs[idx[i]] === exp_val[i]) begin
                $display("[PASS] <%02d> x%0d: Correct immediate (%0d)",
                        i, idx[i], exp_val[i]);
            end else begin
                $display("[FAIL] <%02d> x%0d: Found %0d, Expected (%0d)",
                        i, idx[i], uut.regfile.regs[idx[i]], exp_val[i]);
            end
        end
        
        #2385;
        idx[0] = 7'd71; exp_val[0] = 32'd3;
        idx[1] = 7'd72; exp_val[1] = 32'd3;
        idx[2] = 7'd73; exp_val[2] = 32'd5;
        idx[3] = 7'd74; exp_val[3] = 32'd5;
        idx[4] = 7'd75; exp_val[4] = 32'd7;
        idx[5] = 7'd76; exp_val[5] = 32'd8;
        idx[6] = 7'd77; exp_val[6] = 32'd8;
        
        $display("--------------------------------------------------");
        $display("Checking Final Result (Data Mem - Indices 71-77)  ");
        $display("--------------------------------------------------");
        for (i = 0; i < 7; i = i + 1) begin
            if (uut.dm.mem[idx[i]] === exp_val[i]) begin
                $display("[PASS] Index x%0d: Correct (%0d)",
                        idx[i], exp_val[i]);
            end else begin
                $display("[FAIL] Index x%0d: Found %0d, Expected (%0d)",
                        idx[i], uut.dm.mem[idx[i]], exp_val[i]);
            end
        end

        $display("--------------------------------------------------");
        
        // Stop the simulation
        $finish;
    end

endmodule