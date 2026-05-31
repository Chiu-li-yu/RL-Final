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
            // 4, 5, 6, 0, 1 ...
            if (state == 3'd6)
                state <= 3'd0;
            else if (state >= 3'd4 || state == 3'd0 || state == 3'd1)
                state <= state + 1'b1;
            else
                state <= 3'd4;
        end
    end

    assign q = state;
endmodule
