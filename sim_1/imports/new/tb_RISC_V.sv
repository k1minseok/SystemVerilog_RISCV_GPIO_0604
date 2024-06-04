
`timescale 1ns / 1ps


module tb_RISC_V ();
    logic       clk;
    logic       reset;
    logic [3:0] InPortC;

    logic [3:0] OutPortA;
    logic [3:0] OutPortB;

    tri [3:0] IOPortD;

    RV32I dut (.*);

    always #5 clk = ~clk;

    initial begin
        clk   = 0;
        reset = 1;
        #50 reset = 0;
        InPortC = 4'b1111;
    end
endmodule




// `timescale 1ns / 1ps

// module tb_GPIO;

//     logic clk;
//     logic reset;
//     logic ce;
//     logic wr_en;
//     logic [4:0] addr;
//     logic [31:0] wdata;
//     logic [31:0] rdata;
//     wire [3:0] IOPort;
//     logic [3:0] IOPort_drv; // Driver for IOPort

//     // Instantiate the GPIO module
//     GPIO uut (
//         .clk(clk),
//         .reset(reset),
//         .ce(ce),
//         .wr_en(wr_en),
//         .addr(addr),
//         .wdata(wdata),
//         .rdata(rdata),
//         .IOPort(IOPort)
//     );

//     // Drive IOPort
//     assign IOPort = IOPort_drv;

//     // Clock generation
//     always #5 clk = ~clk;

//     initial begin
//         // Initialize signals
//         clk = 0;
//         reset = 1;
//         ce = 0;
//         wr_en = 0;
//         addr = 0;
//         wdata = 0;
//         IOPort_drv = 4'bz;

//         // Reset the GPIO module
//         #10 reset = 0;

//         // Set MODER to configure 2 inputs and 2 outputs (e.g., 0b0011 means bits 0 and 1 are inputs, bits 2 and 3 are outputs)
//         #10 ce = 1; wr_en = 1; addr = 5'b00000; wdata = 32'b00000000_00000000_00000000_00000011;
//         #10 ce = 0; wr_en = 0;

//         // Write to ODR to set output values (e.g., set bits 2 and 3 to 1)
//         #10 ce = 1; wr_en = 1; addr = 5'b01000; wdata = 32'b00000000_00000000_00000000_00001100;
//         #10 ce = 0; wr_en = 0;

//         // Drive values on IOPort for input pins (e.g., set bits 0 and 1 to 1)
//         #10 IOPort_drv = 4'b0011;

//         #10 IOPort_drv = 4'b1100;

//         // Read MODER to verify configuration
//         #10 ce = 1; wr_en = 0; addr = 5'b00000;
//         #10 ce = 0;

//         // Read ODR to verify output values
//         #10 ce = 1; wr_en = 0; addr = 5'b01000;
//         #10 ce = 0;

//         // Read IDR to verify input values
//         #10 ce = 1; wr_en = 1; addr = 5'b00100;
//         #10 ce = 0;

//         // Print results
//         #10 $display("MODER: %b", rdata);
//         #10 $display("ODR: %b", rdata);
//         #10 $display("IDR: %b", rdata);

//         // Finish simulation
//         #10 $finish;
//     end

// endmodule
