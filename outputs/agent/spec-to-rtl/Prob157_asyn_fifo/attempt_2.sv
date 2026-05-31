module TopModule #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
) (
    input wclk,
    input rclk,
    input wrstn,
    input rrstn,
    input winc,
    input rinc,
    input [WIDTH-1:0] wdata,
    output wfull,
    output rempty,
    output reg [WIDTH-1:0] rdata
);

    localparam ADDR_WIDTH = $clog2(DEPTH);

    logic [ADDR_WIDTH:0] wptr, rptr;
    logic [ADDR_WIDTH:0] wptr_gray, rptr_gray;
    logic [ADDR_WIDTH:0] wptr_sync_rclk, rptr_sync_wclk;
    logic [ADDR_WIDTH:0] wptr_q1, rptr_q1;
    
    logic [WIDTH-1:0] mem [0:DEPTH-1];

    function [ADDR_WIDTH:0] bin2gray(input [ADDR_WIDTH:0] bin);
        bin2gray = bin ^ (bin >> 1);
    endfunction

    // Write Domain
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr <= 0;
            wptr_gray <= 0;
        end else begin
            if (winc && !wfull) begin
                wptr <= wptr + 1;
                wptr_gray <= bin2gray(wptr + 1);
            end
        end
    end

    // Synchronizer for wptr into rclk domain
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_q1 <= 0;
            wptr_sync_rclk <= 0;
        end else begin
            wptr_q1 <= wptr_gray;
            wptr_sync_rclk <= wptr_q1;
        end
    end

    // Read Domain
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr <= 0;
            rptr_gray <= 0;
        end else begin
            if (rinc && !rempty) begin
                rptr <= rptr + 1;
                rptr_gray <= bin2gray(rptr + 1);
            end
        end
    end

    // Synchronizer for rptr into wclk domain
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_q1 <= 0;
            rptr_sync_wclk <= 0;
        end else begin
            rptr_q1 <= rptr_gray;
            rptr_sync_wclk <= rptr_q1;
        end
    end

    // Memory Access
    always @(posedge wclk) begin
        if (winc && !wfull) mem[wptr[ADDR_WIDTH-1:0]] <= wdata;
    end

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) rdata <= 0;
        else if (rinc && !rempty) rdata <= mem[rptr[ADDR_WIDTH-1:0]];
    end

    // Full/Empty Logic
    assign wfull = (wptr_gray == {~rptr_sync_wclk[ADDR_WIDTH:ADDR_WIDTH-1], rptr_sync_wclk[ADDR_WIDTH-2:0]});
    assign rempty = (rptr_gray == wptr_sync_rclk);

endmodule
