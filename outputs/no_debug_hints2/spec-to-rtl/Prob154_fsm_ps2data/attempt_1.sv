module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output logic [23:0] out_bytes,
    output logic done
);

    typedef enum logic [1:0] {
        S0 = 2'b00, // Searching for start
        S1 = 2'b01, // Received byte 1
        S2 = 2'b10, // Received byte 2
        S3 = 2'b11  // Received byte 3 (done)
    } state_t;

    state_t state, next_state;
    logic [7:0] b1, b2, b3;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= S0;
            b1 <= 8'b0;
            b2 <= 8'b0;
            b3 <= 8'b0;
            out_bytes <= 24'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            if (state == S0 && in[3]) begin
                b1 <= in;
            end else if (state == S1) begin
                b2 <= in;
            end else if (state == S2) begin
                b3 <= in;
                out_bytes <= {b1, b2, in};
            end
            
            done <= (next_state == S3);
        end
    end

    always @(*) begin
        case (state)
            S0: next_state = (in[3]) ? S1 : S0;
            S1: next_state = S2;
            S2: next_state = S3;
            S3: next_state = (in[3]) ? S1 : S0;
            default: next_state = S0;
        endcase
    end
endmodule
