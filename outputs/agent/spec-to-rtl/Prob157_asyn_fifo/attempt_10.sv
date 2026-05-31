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
    output logic wfull,
    output logic rempty,
    output logic [WIDTH-1:0] rdata
);

    localparam ADDR_WIDTH = $clog2(DEPTH);

    logic [WIDTH-1:0] mem [0:DEPTH-1];
    logic [ADDR_WIDTH:0] wptr, rptr;
    logic [ADDR_WIDTH:0] wptr_gray, rptr_gray;
    logic [ADDR_WIDTH:0] rptr_sync_w1, rptr_sync_w2;
    logic [ADDR_WIDTH:0] wptr_sync_r1, wptr_sync_r2;

    function logic [ADDR_WIDTH:0] bin2gray(input logic [ADDR_WIDTH:0] bin);
        bin2gray = (bin >> 1) ^ bin;
    endfunction

    // Write Domain
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr <= 0;
            rptr_sync_w1 <= 0;
            rptr_sync_w2 <= 0;
        end else begin
            rptr_sync_w1 <= rptr_gray;
            rptr_sync_w2 <= rptr_sync_w1;
            if (winc && !wfull) begin
                mem[wptr[ADDR_WIDTH-1:0]] <= wdata;
                wptr <= wptr + 1;
            end
        end
    end

    assign wptr_gray = bin2gray(wptr);
    assign wfull = (wptr_gray == {~rptr_sync_w2[ADDR_WIDTH:ADDR_WIDTH-1], rptr_sync_w2[ADDR_WIDTH-2:0]});

    // Read Domain
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr <= 0;
            wptr_sync_r1 <= 0;
            wptr_sync_r2 <= 0;
            rdata <= 0;
        end else begin
            wptr_sync_r1 <= wptr_gray;
            wptr_sync_r2 <= wptr_sync_r1;
            if (rinc && !rempty) begin
                rptr <= rptr + 1;
                rdata <= mem[rptr[ADDR_WIDTH-1:0]];
            end
        end
    end

    assign rptr_gray = bin2gray(rptr);
    assign rempty = (rptr_gray == wptr_sync_r2);

endmodule
