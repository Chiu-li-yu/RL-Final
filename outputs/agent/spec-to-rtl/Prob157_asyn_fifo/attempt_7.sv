module TopModule #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input  wclk,
    input  rclk,
    input  wrstn,
    input  rrstn,
    input  winc,
    input  rinc,
    input  [WIDTH-1:0] wdata,
    output wfull,
    output rempty,
    output reg [WIDTH-1:0] rdata
);

    localparam ADDR_WIDTH = $clog2(DEPTH);

    logic [WIDTH-1:0] mem [0:DEPTH-1];
    logic [ADDR_WIDTH:0] wptr, rptr;
    logic [ADDR_WIDTH:0] wptr_gray, rptr_gray;
    logic [ADDR_WIDTH:0] rptr_gray_q1, rptr_gray_q2;
    logic [ADDR_WIDTH:0] wptr_gray_q1, wptr_gray_q2;

    function [ADDR_WIDTH:0] bin2gray;
        input [ADDR_WIDTH:0] bin;
        bin2gray = (bin >> 1) ^ bin;
    endfunction

    // Write Logic
    assign wfull = (wptr_gray == {~rptr_gray_q2[ADDR_WIDTH:ADDR_WIDTH-1], rptr_gray_q2[ADDR_WIDTH-2:0]});

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr <= 0;
            wptr_gray <= 0;
            rptr_gray_q1 <= 0;
            rptr_gray_q2 <= 0;
        end else begin
            rptr_gray_q1 <= rptr_gray;
            rptr_gray_q2 <= rptr_gray_q1;
            if (winc && !wfull) begin
                mem[wptr[ADDR_WIDTH-1:0]] <= wdata;
                wptr <= wptr + 1;
            end
            wptr_gray <= bin2gray(wptr);
        end
    end

    // Read Logic
    assign rempty = (rptr_gray == wptr_gray_q2);

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr <= 0;
            rptr_gray <= 0;
            wptr_gray_q1 <= 0;
            wptr_gray_q2 <= 0;
            rdata <= 0;
        end else begin
            wptr_gray_q1 <= wptr_gray;
            wptr_gray_q2 <= wptr_gray_q1;
            if (rinc && !rempty) begin
                rdata <= mem[rptr[ADDR_WIDTH-1:0]];
                rptr <= rptr + 1;
            end
            rptr_gray <= bin2gray(rptr);
        end
    end

endmodule