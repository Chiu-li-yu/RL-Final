module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output logic [23:0] out_bytes,
    output logic done
);

    typedef enum logic [1:0] {
        S0 = 2'd0, 
        S1 = 2'd1, 
        S2 = 2'd2, 
        S3 = 2'd3  
    } state_t;

    state_t state, next_state;
    logic [7:0] b1, b2;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= S0;
            b1 <= 8'b0;
            b2 <= 8'b0;
            out_bytes <= 24'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            if (next_state == S1) begin
                b1 <= in;
            end else if (next_state == S2) begin
                b2 <= in;
            end else if (next_state == S3) begin
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
