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
    logic [ADDR_WIDTH:0] wbin, rbin;
    logic [ADDR_WIDTH:0] wptr_gray, rptr_gray;
    logic [ADDR_WIDTH:0] wbin_next, rbin_next;
    logic [ADDR_WIDTH:0] wgray_next, rgray_next;
    logic [ADDR_WIDTH:0] rptr_sync_w1, rptr_sync_w2;
    logic [ADDR_WIDTH:0] wptr_sync_r1, wptr_sync_r2;

    assign wbin_next  = wbin + (winc && !wfull);
    assign wgray_next = (wbin_next >> 1) ^ wbin_next;
    assign rbin_next  = rbin + (rinc && !rempty);
    assign rgray_next = (rbin_next >> 1) ^ rbin_next;

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wbin         <= 0;
            wptr_gray    <= 0;
            rptr_sync_w1 <= 0;
            rptr_sync_w2 <= 0;
        end else begin
            wbin         <= wbin_next;
            wptr_gray    <= wgray_next;
            rptr_sync_w1 <= rptr_gray;
            rptr_sync_w2 <= rptr_sync_w1;
            if (winc && !wfull) begin
                mem[wbin[ADDR_WIDTH-1:0]] <= wdata;
            end
        end
    end

    assign wfull = (wptr_gray == {~rptr_sync_w2[ADDR_WIDTH:ADDR_WIDTH-1], rptr_sync_w2[ADDR_WIDTH-2:0]});

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rbin         <= 0;
            rptr_gray    <= 0;
            wptr_sync_r1 <= 0;
            wptr_sync_r2 <= 0;
            rdata        <= 0;
        end else begin
            rbin         <= rbin_next;
            rptr_gray    <= rgray_next;
            wptr_sync_r1 <= wptr_gray;
            wptr_sync_r2 <= wptr_sync_r1;
            if (rinc && !rempty) begin
                rdata <= mem[rbin[ADDR_WIDTH-1:0]];
            end
        end
    end

    assign rempty = (rptr_gray == wptr_sync_r2);

endmodule
