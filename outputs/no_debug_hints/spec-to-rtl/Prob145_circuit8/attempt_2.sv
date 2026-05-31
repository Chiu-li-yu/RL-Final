module TopModule(
    input clock,
    input a,
    output p,
    output q
);

    logic p_out;
    logic q_out;

    always @(*) begin
        if (clock) begin
            p_out = a;
        end else begin
            p_out = q_out;
        end
    end

    always_ff @(posedge clock or negedge clock) begin
        if (clock) begin
            // When clock is 1, maybe q follows some logic
        end else begin
            q_out <= p_out;
        end
    end

    assign p = p_out;
    assign q = q_out;

endmodule