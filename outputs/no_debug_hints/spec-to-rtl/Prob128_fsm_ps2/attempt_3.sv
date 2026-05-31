module TopModule (
    input logic clk,
    input logic reset,
    input logic [7:0] in,
    output logic done
);

    typedef enum logic [1:0] {
        SEARCH = 2'b00,
        BYTE2  = 2'b01,
        BYTE3  = 2'b10,
        DONE_ST = 2'b11
    } state_t;

    state_t current_state, next_state;

    always_ff @(posedge clk) begin
        if (reset) begin
            current_state <= SEARCH;
        end else begin
            current_state <= next_state;
        end
    end

    assign done = (current_state == DONE_ST);

    always @(*) begin
        case (current_state)
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
                next_state = DONE_ST;
            end
            DONE_ST: begin
                if (in[3]) begin
                    next_state = BYTE2;
                end else begin
                    next_state = SEARCH;
                end
            end
            default: next_state = SEARCH;
        endcase
    end
endmodule
