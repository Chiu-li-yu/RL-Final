module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output logic [23:0] out_bytes,
    output logic done
);

    typedef enum logic [1:0] {
        IDLE = 2'b00,
        GET_B2 = 2'b01,
        GET_B3 = 2'b10
    } state_t;

    logic [1:0] state, next_state;
    logic [7:0] b1, b2, b3;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            b1 <= 8'd0;
            b2 <= 8'd0;
            b3 <= 8'd0;
        end else begin
            state <= next_state;
            if (state == IDLE && in[3]) b1 <= in;
            if (state == GET_B2) b2 <= in;
            if (state == GET_B3) b3 <= in;
        end
    end

    always @(*) begin
        next_state = state;
        done = 1'b0;
        case (state)
            IDLE: begin
                if (in[3]) next_state = GET_B2;
            end
            GET_B2: begin
                next_state = GET_B3;
            end
            GET_B3: begin
                done = 1'b1;
                if (in[3]) next_state = GET_B2;
                else next_state = IDLE;
            end
        endcase
    end

    always @(*) begin
        out_bytes = {b1, b2, b3};
    end

endmodule
