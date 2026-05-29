module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    localparam IDLE = 3'd0;
    localparam S1   = 3'd1;
    localparam S2   = 3'd2;
    localparam S3   = 3'd3;
    localparam S4   = 3'd4;

    logic [2:0] state, next_state;

    always @(*) begin
        case (state)
            IDLE: begin
                if (data == 1'b1) next_state = S1;
                else              next_state = IDLE;
            end
            S1: begin
                if (data == 1'b1) next_state = S2;
                else              next_state = IDLE;
            end
            S2: begin
                if (data == 1'b0) next_state = S3;
                else              next_state = S2;
            end
            S3: begin
                if (data == 1'b1) next_state = S4;
                else              next_state = IDLE;
            end
            S4: begin
                next_state = S4;
            end
            default: next_state = IDLE;
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    assign start_shifting = (state == S4);

endmodule
