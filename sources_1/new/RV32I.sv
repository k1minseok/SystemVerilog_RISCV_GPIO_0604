`timescale 1ns / 1ps

module RV32I (
    input logic       clk,
    input logic       reset,
    input logic [3:0] InPortC,

    output logic [3:0] OutPortA,
    output logic [3:0] OutPortB,

    inout wire [3:0] IOPortD
);

    logic [31:0] w_InstrMemAddr, w_InstrMemData;
    logic w_wr_en;
    logic [31:0] w_Addr, w_dataMemRData, w_WData;
    logic [31:0] w_MasterRData;
    logic [31:0] w_RDataGPOA, w_RDataGPOB, w_RDataGPIC, w_RDataGPIOD;
    logic [4:0] w_slave_sel;

    logic [1:0] w_storeType;
    logic [2:0] w_loadType;


    wire        w_div_clk;
    clkDiv #(
        .HERZ(10_000_000)
    ) U_ClkDiv (
        .clk  (clk),
        .reset(reset),

        .o_clk(w_div_clk)
    );

    CPU_Core U_CPU_Core (
        .clk        (w_div_clk),
        .reset      (reset),
        .machineCode(w_InstrMemData),
        .MasterRData(w_MasterRData),

        .instrMemRAddr(w_InstrMemAddr),
        .Addr         (w_Addr),
        .WData        (w_WData),
        .storeType    (w_storeType),
        .loadType     (w_loadType),
        .dataMem_wr_en(w_wr_en)
    );

    BUS_Interconnector U_BUS_InterCon (
        .address     (w_Addr),
        .slave_rdata1(w_dataMemRData),
        .slave_rdata2(w_RDataGPOA),
        .slave_rdata3(w_RDataGPOB),
        .slave_rdata4(w_RDataGPIC),
        .slave_rdata5(w_RDataGPIOD),

        .slave_sel   (w_slave_sel),   //Chip-enable
        .master_rdata(w_MasterRData)
    );

    DataMemory U_RAM (  //slave 0
        .clk      (w_div_clk),
        .ce       (w_slave_sel[0]),
        .wr_en    (w_wr_en),
        .addr     (w_Addr[7:0]),
        .wdata    (w_WData),
        .storeType(w_storeType),
        .loadType (w_loadType),

        .rdata(w_dataMemRData)
    );

    GPO U_GPOA (  // slave 1
        .clk  (w_div_clk),
        .reset(reset),
        .ce   (w_slave_sel[1]),
        .wr_en(w_wr_en),
        .addr (w_Addr[0]),
        .wdata(w_WData),

        .rdata  (w_RDataGPOA),
        .outPort(OutPortA)
    );

    GPO U_GPOB (  // slave 2
        .clk  (w_div_clk),
        .reset(reset),
        .ce   (w_slave_sel[2]),
        .wr_en(w_wr_en),
        .addr (w_Addr[0]),
        .wdata(w_WData),

        .rdata  (w_RDataGPOB),
        .outPort(OutPortB)
    );

    GPI U_GPIC (  // slave 3
        .clk   (w_div_clk),
        .addr  (w_Addr[0]),
        .wr_en (w_wr_en),
        .ce    (w_slave_sel[3]),
        .inPort(InPortC),

        .rdata(w_RDataGPIC)
    );

    GPIO U_GPIOD (  // slave 4
        .clk  (w_div_clk),
        .reset(reset),
        .ce   (w_slave_sel[4]),
        .wr_en(w_wr_en),
        .addr (w_Addr[3:0]),
        .wdata(w_WData),

        .rdata(w_RDataGPIOD),

        .IOPort(IOPortD)
    );

    InstructionMemory U_ROM (  // only Read
        .addr(w_InstrMemAddr),

        .data(w_InstrMemData)
    );

endmodule



module clkDiv #(
    parameter HERZ = 100
) (
    input clk,
    input reset,

    output o_clk
);

    reg [$clog2(100_000_000/HERZ)-1 : 0] counter;
    reg r_clk;

    assign o_clk = r_clk;

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            counter <= 0;
            r_clk   <= 1'b0;
        end else begin
            if (counter == (100_000_000 / HERZ - 1)) begin
                counter <= 0;
                r_clk   <= 1'b1;
            end else begin
                counter <= counter + 1;
                r_clk   <= 1'b0;
            end
        end
    end

endmodule
