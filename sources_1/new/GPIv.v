// `timescale 1ns / 1ps

// module GPI(
//     input clk,
//     input addr,
//     input ce,
//     input wr_en,
//     input  [3:0] inPort,
   
//     output [31:0] rdata
//     );

//     reg [31:0] IDR;
//     assign rdata = IDR;

//     always @(*) begin
//         if(ce & ~wr_en) IDR[3:0] <= inPort;
        
//     end
// endmodule