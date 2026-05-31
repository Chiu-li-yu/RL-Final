module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    localparam A = 2'b01;
    localparam B = 2'b10;

    logic [1:0] state, next_state;
    logic out_z;

    always_ff @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;
        else
            state <= next_state;
    end

    always @(*) begin
        case (state)
            A: begin
                if (x) begin
                    next_state = B;
                    out_z = 1'b1;
                end else begin
                    next_state = A;
                    out_z = 1'b0;
                end
            end
            B: begin
                if (x) begin
                    next_state = B;
                    out_z = 1'b0;
                end else begin
                    next_state = B;
                    out_z = 1'b1;
                end
            end
            default: begin
                next_state = A;
                out_z = 1'b0;
            end
        endcase
    end

    assign z = out_z;

endmodule
