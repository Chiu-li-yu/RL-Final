module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output logic [23:0] out_bytes,
    output logic done
);

    typedef enum logic [1:0] {
        SEARCH = 2'd0,
        COLLECT2 = 2'd1,
        COLLECT3 = 2'd2,
        DONE_STATE = 2'd3
    } state_t;

    state_t state, next_state;
    logic [7:0] byte1, byte2, byte3;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            byte1 <= 8'd0;
            byte2 <= 8'd0;
            byte3 <= 8'd0;
            done <= 1'b0;
            out_bytes <= 24'd0;
        end else begin
            state <= next_state;
            case (state)
                SEARCH: begin
                    if (in[3]) begin
                        byte1 <= in;
                    end
                end
                COLLECT2: begin
                    byte2 <= in;
                end
                COLLECT3: begin
                    byte3 <= in;
                end
                DONE_STATE: begin
                    // Hold data
                end
            endcase
            
            if (next_state == DONE_STATE) begin
                done <= 1'b1;
                out_bytes <= {byte1, byte2, in};
            end else begin
                done <= 1'b0;
            end
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            SEARCH: begin
                if (in[3]) next_state = COLLECT2;
            end
            COLLECT2: begin
                next_state = COLLECT3;
            end
            COLLECT3: begin
                next_state = DONE_STATE;
            end
            DONE_STATE: begin
                next_state = SEARCH;
            end
            default: next_state = SEARCH;
        endcase
    end

endmodule
