`timescale 1ns/1ps

module tb_top;

  reg clk;
  reg rst;

  // Instantiate microcontroller
  microcontroller uut (
      .clk(clk),
      .rst(rst)
  );

  // Clock generation: 20ns period => 50 MHz
  initial begin
    clk = 0;
    forever #10 clk = ~clk;
  end

  // Reset
  initial begin
    rst = 1;
    #50;       // hold reset for 50 ns
    rst = 0;
  end
  // Run simulation for some time
  initial begin
    #10000;    // simulate for 1000 ns
    $finish;
  end

endmodule
