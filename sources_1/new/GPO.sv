`timescale 1ns / 1ps

module GPO (
    input logic        clk,
    input logic        reset,
    input logic        ce,
    input logic        wr_en,
    input logic        addr,
    input logic [31:0] wdata,

    output logic [31:0] rdata,
    output logic [ 3:0] outPort  // 4 ports
);
    // logic [31:0] ODR;  // GPO 32bit register

    // assign outPort = ODR[3:0];  // output to Port

    // always_ff @(posedge clk, posedge reset) begin : GPO
    //     if (reset) begin
    //         ODR <= 0;
    //     end else begin
    //         if (ce & wr_en) ODR <= wdata;  // write
    //     end
    // end

    // assign rdata = ODR;  // read

    reg [31:0] ODR[0:1];            // 수정 필요할듯....
    //assign outPort = ODR[1][3:0];

    assign outPort = ODR[0][3:0];
    assign rdata = wr_en ? 32'bx : ODR[addr]; // Master check -> do not read

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            ODR[0] <= 0;
            ODR[1] <= 0;
        end else begin
            if (ce && wr_en) begin
                ODR[addr] <= wdata;
            end
        end
    end

endmodule
