module TopModule (
    input logic clk,
    input logic reset,
    input logic [7:0] in,
    output logic done
);

    typedef enum logic [1:0] {
        SEARCH = 2'b00,
        BYTE2  = 2'b01,
        BYTE3  = 2'b10
    } state_t;

    state_t state, next_state;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
        end else begin
            state <= next_state;
        end
    end

    always_comb begin
        next_state = state;
        done = 1'b0;

        case (state)
            SEARCH: begin
                if (in[3]) begin
                    next_state = BYTE2;
                end else begin
                    next_state = SEARCH;
                end
            end
            BYTE2: begin
                next_state = BYTE3;
            end
            BYTE3: begin
                done = 1'b1;
                next_state = SEARCH;
            end
            default: next_state = SEARCH;
        endcase
    end
endmodule