`timescale 1ns / 1ps
`include "defines.sv"

module DataMemory (  // RAM
    input logic        clk,
    input logic        ce,
    input logic        wr_en,
    input logic [ 7:0] addr,
    input logic [31:0] wdata,
    input logic [ 1:0] storeType,
    input logic [ 2:0] loadType,

    output logic [31:0] rdata
);
    // logic [31:0] ram[0:2**6-1];
    logic [31:0] ram[0:2**8-1];

    // initial begin  // initial for test
    //     int i;
    //     for (i = 0; i < 2 ** 6; i++) begin
    //         ram[i] = 100 + i;
    //     end
    //     ram[58] = 32'h9999_9999;
    //     ram[59] = 32'h9999_9999;
    //     ram[60] = 32'h9999_9999;
    //     ram[62] = 32'h8765_4321;  // 0xf0f0 f0f0
    //     ram[63] = -252645136;  // 0xf0f0 f0f0
    // end


    // // write
    // always_ff @(posedge clk) begin
    //     if (wr_en & ce) begin
    //         case (storeType)  // s-type
    //             `SB:     ram[addr[7:2]][7:0] <= wdata[7:0];
    //             `SH:     ram[addr[7:2]][15:0] <= wdata[15:0];
    //             `SW:     ram[addr[7:2]] <= wdata[31:0];
    //             2'bxx:   ram[addr[7:2]] <= wdata;
    //             default: ram[addr[7:2]] <= 32'bx;
    //         endcase
    //     end
    // end

    // // read
    // always_comb begin
    //     case (loadType)
    //         `LB:     rdata = {{25{ram[addr[7:2]][7]}}, ram[addr[7:2]][6:0]};
    //         `LH:     rdata = {{17{ram[addr[7:2]][15]}}, ram[addr[7:2]][14:0]};
    //         `LW:     rdata = ram[addr[7:2]][31:0];
    //         `LBU:    rdata = {24'b0, ram[addr[7:2]][7:0]};  // 0-extend
    //         `LHU:    rdata = {16'b0, ram[addr[7:2]][15:0]};
    //         3'bxxx:  rdata = ram[addr[7:2]];
    //         default: rdata = 32'bx;
    //     endcase
    // end


    // write
    always_ff @(posedge clk) begin
        if (wr_en & ce) begin
            case (storeType)  // s-type
                `SB:     ram[addr[7:0]][7:0] <= wdata[7:0];
                `SH:     ram[addr[7:0]][15:0] <= wdata[15:0];
                `SW:     ram[addr[7:0]] <= wdata[31:0];
                // 2'bxx:   ram[addr[7:0]] <= wdata;
                default: ram[addr[7:0]] <= 32'bx;
            endcase
        end
    end

    // read
    always_comb begin
        case (loadType)
            `LB:     rdata = {{25{ram[addr[7:0]][7]}}, ram[addr[7:0]][6:0]};
            `LH:     rdata = {{17{ram[addr[7:0]][15]}}, ram[addr[7:0]][14:0]};
            `LW:     rdata = ram[addr[7:0]][31:0];
            `LBU:    rdata = {24'b0, ram[addr[7:0]][7:0]};  // 0-extend
            `LHU:    rdata = {16'b0, ram[addr[7:0]][15:0]};
            // 3'bxxx:  rdata = ram[addr[7:0]];
            default: rdata = 32'bx;
        endcase
    end
endmodule



// `timescale 1ns / 1ps

// module DataMemory (  // RAM
//     input logic        clk,
//     input logic        ce,
//     input logic        wr_en,
//     input logic [ 7:0] addr,
//     input logic [31:0] wdata,

//     output logic [31:0] rdata
// );
//     logic [31:0] ram[0:2**6-1];

//     initial begin  // initial for test
//         int i;
//         for (i = 0; i < 2**6; i++) begin
//             ram[i] = 100 + i;
//         end
//         ram[62] = 32'h8765_4321;  // 0xf0f0 f0f0
//         ram[63] = -252645136;  // 0xf0f0 f0f0
//     end

//     assign rdata = ram[addr[7:2]];

//     always_ff @(posedge clk) begin
//         if (wr_en & ce) ram[addr[7:2]] <= wdata;
//     end
// endmodule
