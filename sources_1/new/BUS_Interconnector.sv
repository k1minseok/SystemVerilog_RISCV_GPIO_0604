`timescale 1ns / 1ps

module BUS_Interconnector (
    input logic [31:0] address,
    input logic [31:0] slave_rdata1,
    input logic [31:0] slave_rdata2,
    input logic [31:0] slave_rdata3,
    input logic [31:0] slave_rdata4,
    input logic [31:0] slave_rdata5,

    output logic [ 4:0] slave_sel,  //Chip-enable
    output logic [31:0] master_rdata
);

    decoder U_Decoder (
        .x(address),

        .y(slave_sel)
    );

    mux U_MUX (
        .sel(address),
        .a  (slave_rdata1),
        .b  (slave_rdata2),
        .c  (slave_rdata3),
        .d  (slave_rdata4),
        .e  (slave_rdata5),

        .y(master_rdata)
    );
endmodule


module decoder (
    input logic [31:0] x,

    output logic [4:0] y
);
    always_comb begin : decoder     // 상위 24bit로 장치 구분 가능
        case (x[31:8])  // address
            24'h0000_00: y = 5'b00001;  // RAM
            24'h0000_21: y = 5'b00010;  // GPOA
            24'h0000_22: y = 5'b00100;  // GPOB
            24'h0000_23: y = 5'b01000;  // GPIC
            24'h0000_24: y = 5'b10000;  // GPID
            default: y = 5'b0;
        endcase
    end
endmodule


module mux (
    input logic [31:0] sel,
    input logic [31:0] a,
    input logic [31:0] b,
    input logic [31:0] c,
    input logic [31:0] d,
    input logic [31:0] e,

    output logic [31:0] y
);

    always_comb begin : mux
        case (sel[31:8])  // address
            24'h0000_00: y = a;     // RAM
            24'h0000_21: y = b;     // GPOA
            24'h0000_22: y = c;     // GPOB
            24'h0000_23: y = d;     // GPIC
            24'h0000_24: y = e;     // GPID
            default: y = 32'b0;
        endcase
    end
endmodule
