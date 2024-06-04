`timescale 1ns / 1ps

module GPIO (
    input logic        clk,
    input logic        reset,
    input logic        ce,
    input logic        wr_en,
    input logic [ 4:0] addr,
    input logic [31:0] wdata,

    output logic [31:0] rdata,

    inout wire [3:0] IOPort
);
    logic [31:0] MODER;
    logic [31:0] ODR;
    logic [31:0] IDR;

    // logic [ 3:0] rdata_reg;


    // assign rdata = rdata_reg;

    // Master -> GPIO(write)
    // 입력받은 wdata를 입력 받은 해당 주소에 저장
    // I/O 정하기, output 데이터 write
    always_ff @(posedge clk, posedge reset) begin
        if (reset) begin
            MODER <= 0;
            ODR   <= 0;
        end else begin
            if (ce & wr_en) begin
                // MODER <= 0;
                // ODR   <= 0;
                case (addr[3:2])    // 원하는 주소(MODER, ODR)에 데이터 저장
                    2'b00: MODER <= wdata;  // MODER 
                    // 2'b01: IDR <= wdata; // IDR write 불가 
                    2'b10: ODR <= wdata;  // ODR 
                endcase
            end
        end
    end

    // GPIO -> Master(read)
    // 각 레지스터에 저장된 값 read
    always_comb begin
        case (addr[3:2])
            // 2'b00:   rdata_reg = MODER;  // address 0x00 
            // 2'b01:   rdata_reg = IDR;  // address 0x04
            // // IDR은 read만 가능
            // 2'b10:   rdata_reg = ODR;  // address 0x08 
            // // ODR은 read & write 둘 다 됨

            2'b00:   rdata = MODER;  // address 0x00 
            2'b01:   rdata = IDR;  // address 0x04
            // IDR은 read만 가능
            2'b10:   rdata = ODR;  // address 0x08 
            // ODR은 read & write 둘 다 됨
            default: rdata = 32'bx;  // default: rdata_reg = 32'bx;
        endcase
    end


    // Port -> GPIO
    // GPO -> MODER가 0이면 IDR에 Port값 저장(input mode)
    always_comb begin
        IDR[0] = MODER[0] ? 1'bz : IOPort[0];
        IDR[1] = MODER[1] ? 1'bz : IOPort[1];
        IDR[2] = MODER[2] ? 1'bz : IOPort[2];
        IDR[3] = MODER[3] ? 1'bz : IOPort[3];
    end

    // GPIO -> Port
    // GPO -> MODER가 1이면 ODR값 Port에 출력(output mode)
    assign IOPort[0] = MODER[0] ? ODR[0] : 1'bz;
    assign IOPort[1] = MODER[1] ? ODR[1] : 1'bz;
    assign IOPort[2] = MODER[2] ? ODR[2] : 1'bz;
    assign IOPort[3] = MODER[3] ? ODR[3] : 1'bz;
endmodule
