module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output logic [23:0] out_bytes,
    output logic done
);

    logic [1:0] state, next_state;
    logic [7:0] b1, b2;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= 2'd0;
            b1 <= 8'b0;
            b2 <= 8'b0;
            out_bytes <= 24'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            if (next_state == 2'd1) begin
                b1 <= in;
            end else if (next_state == 2'd2) begin
                b2 <= in;
            end else if (next_state == 2'd3) begin
                out_bytes <= {b1, b2, in};
            end
            
            done <= (next_state == 2'd3);
        end
    end

    always @(*) begin
        case (state)
            2'd0: next_state = (in[3]) ? 2'd1 : 2'd0;
            2'd1: next_state = 2'd2;
            2'd2: next_state = 2'd3;
            2'd3: next_state = (in[3]) ? 2'd1 : 2'd0;
            default: next_state = 2'd0;
        endcase
    end
endmodule
