module TopModule (
    input clk,
    input areset,
    input x,
    output z
);
    logic state, next_state;
    logic current_z;

    localparam IDLE = 1'b0;
    localparam INVERT = 1'b1;

    always_ff @(posedge clk or posedge areset) begin
        if (areset)
            state <= IDLE;
        else
            state <= next_state;
    end

    always @(*) begin
        case (state)
            IDLE: begin
                if (x == 1'b1) begin
                    next_state = INVERT;
                    current_z = 1'b1;
                end else begin
                    next_state = IDLE;
                    current_z = 1'b0;
                end
            end
            INVERT: begin
                next_state = INVERT;
                current_z = !x;
            end
            default: begin
                next_state = IDLE;
                current_z = 1'b0;
            end
        endcase
    end

    assign z = current_z;

endmodule
