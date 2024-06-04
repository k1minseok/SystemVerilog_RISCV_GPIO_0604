`timescale 1ns / 1ps

module GPI (
    input logic       clk,
    input logic       addr,
    input logic       wr_en,
    input logic       ce,
    input logic [3:0] inPort,

    output logic [31:0] rdata
);
    logic [31:0] IDR;

    assign rdata = IDR;

    // always_ff @(posedge clk) begin : GPI
    //     if (ce & ~wr_en) IDR[3:0] <= inPort;
    // end

    always_comb begin : GPI
        if (ce & ~wr_en) IDR[3:0] = inPort;
    end
    // always @(*) begin
    //     if (ce & ~wr_en) IDR[3:0] = inPort;
    // end
endmodule
