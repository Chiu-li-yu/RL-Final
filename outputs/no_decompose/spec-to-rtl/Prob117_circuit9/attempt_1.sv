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
            if (state == 3'd6)
                state <= 3'd0;
            else if (state >= 3'd4)
                state <= state + 1'b1;
            else
                state <= 3'd0; // Handle initial state or transition
        end
    end

    always_comb begin
        q = state;
    end
endmodule
