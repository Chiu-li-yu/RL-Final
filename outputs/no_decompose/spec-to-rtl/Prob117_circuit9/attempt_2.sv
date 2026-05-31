module TopModule (
    input clk,
    input a,
    output logic [2:0] q
);
    logic [2:0] state;

    initial begin
        state = 3'd4;
    end

    always_ff @(posedge clk) begin
        if (a) begin
            state <= 3'd4;
        end else begin
            if (state == 3'd4)
                state <= 3'd5;
            else if (state == 3'd5)
                state <= 3'd6;
            else if (state == 3'd6)
                state <= 3'd0;
            else if (state == 3'd0)
                state <= 3'd1;
            else
                state <= 3'd0;
        end
    end

    assign q = state;
endmodule
