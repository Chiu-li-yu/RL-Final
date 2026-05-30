module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output logic [23:0] out_bytes,
    output logic done
);
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        BYTE1 = 2'b01,
        BYTE2 = 2'b10,
        BYTE3 = 2'b11
    } state_t;

    state_t state, next_state;
    logic [7:0] b1, b2, b3;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done <= 1'b0;
            out_bytes <= 24'b0;
            b1 <= 8'b0;
            b2 <= 8'b0;
            b3 <= 8'b0;
        end else begin
            state <= next_state;
            if (state == BYTE1) b1 <= in;
            if (state == BYTE2) b2 <= in;
            if (state == BYTE3) b3 <= in;
            
            if (next_state == IDLE && state == BYTE3) begin
                done <= 1'b1;
                out_bytes <= {b1, b2, in};
            end else begin
                done <= 1'b0;
            end
        end
    end

    always_comb begin
        next_state = state;
        case (state)
            IDLE: if (in[3]) next_state = BYTE1;
            BYTE1: next_state = BYTE2;
            BYTE2: next_state = BYTE3;
            BYTE3: next_state = IDLE;
        endcase
    end
endmodule