module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output logic [23:0] out_bytes,
    output logic done
);

    typedef enum logic [1:0] {
        WAIT_BYTE1 = 2'd0,
        GET_BYTE2  = 2'd1,
        GET_BYTE3  = 2'd2,
        DONE_STATE = 2'd3
    } state_t;

    state_t state, next_state;
    logic [7:0] b1, b2, b3;

    always @(posedge clk) begin
        if (reset) begin
            state <= WAIT_BYTE1;
            b1 <= 8'h0;
            b2 <= 8'h0;
            b3 <= 8'h0;
            out_bytes <= 24'h0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= (next_state == DONE_STATE);
            
            if (next_state == DONE_STATE) begin
                out_bytes <= {b1, b2, b3};
            end

            case (state)
                WAIT_BYTE1: if (in[3]) b1 <= in;
                GET_BYTE2:  b2 <= in;
                GET_BYTE3:  b3 <= in;
            endcase
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            WAIT_BYTE1: if (in[3]) next_state = GET_BYTE2;
            GET_BYTE2:  next_state = GET_BYTE3;
            GET_BYTE3:  next_state = DONE_STATE;
            DONE_STATE: next_state = WAIT_BYTE1;
        endcase
    end

endmodule
