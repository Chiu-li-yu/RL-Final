module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output logic [23:0] out_bytes,
    output logic done
);

    typedef enum logic [1:0] {
        STATE_SEARCH = 2'd0,
        STATE_BYTE2  = 2'd1,
        STATE_BYTE3  = 2'd2
    } state_t;

    state_t current_state, next_state;
    logic [23:0] buffer, next_buffer;
    logic next_done;

    always_ff @(posedge clk) begin
        if (reset) begin
            current_state <= STATE_SEARCH;
            buffer <= 24'b0;
            done <= 1'b0;
        end else begin
            current_state <= next_state;
            buffer <= next_buffer;
            done <= next_done;
        end
    end

    always_comb begin
        next_state = current_state;
        next_buffer = buffer;
        next_done = 1'b0;

        case (current_state)
            STATE_SEARCH: begin
                if (in[3]) begin
                    next_buffer[23:16] = in;
                    next_state = STATE_BYTE2;
                end
            end
            STATE_BYTE2: begin
                next_buffer[15:8] = in;
                next_state = STATE_BYTE3;
            end
            STATE_BYTE3: begin
                next_buffer[7:0] = in;
                next_done = 1'b1;
                out_bytes = {next_buffer[23:16], next_buffer[15:8], in};
                next_state = STATE_SEARCH;
            end
            default: next_state = STATE_SEARCH;
        endcase
    end

    // Ensure out_bytes is only updated correctly
    always_comb begin
        if (done) begin
            out_bytes = buffer;
        end else begin
            out_bytes = 24'b0;
        end
    end

endmodule
