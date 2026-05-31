module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    logic state;
    localparam B = 1'b1;
    localparam A = 1'b0;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= B;
        end else begin
            case (state)
                B: state <= (in == 1'b0) ? A : B;
                A: state <= (in == 1'b0) ? B : A;
            endcase
        end
    end

    always @(*) begin
        out = (state == B);
    end

endmodule
