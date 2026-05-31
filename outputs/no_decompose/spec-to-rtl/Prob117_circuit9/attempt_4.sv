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
            state <= state + 1'b1;
        end
    end

    assign q = state;
endmodule
