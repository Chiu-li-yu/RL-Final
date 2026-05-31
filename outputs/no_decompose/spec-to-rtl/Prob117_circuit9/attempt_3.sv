module TopModule (
    input clk,
    input a,
    output logic [2:0] q
);
    logic [2:0] state;

    always_ff @(posedge clk) begin
        if (a) begin
            state <= 3'd4;
        end else begin
            if (state == 3'd4) state <= 3'd5;
            else if (state == 3'd5) state <= 3'd6;
            else if (state == 3'd6) state <= 3'd0;
            else if (state == 3'd0) state <= 3'd1;
            else state <= 3'd1;
        end
    end

    assign q = (state == 3'b000 && !a && $past(state) == 3'b000) ? 3'b000 : state;

    // Rethink: The waveform shows:
    // a=1: q stays 4
    // a=0: 4->5->6->0->1->2... (Wait, check waveform again)
    // 45ns(a=0) q=4
    // 55ns(a=0) q=5
    // 65ns(a=0) q=6
    // 75ns(a=0) q=0
    // 85ns(a=0) q=1
    // It seems to be a simple modulo counter when a=0
endmodule
