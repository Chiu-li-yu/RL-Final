module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output z
);
    localparam A = 3'd0, B = 3'd1, C = 3'd2, D = 3'd3, E = 3'd4;
    logic [2:0] state, next_state;
    logic [1:0] count, next_count;

    always @(*) begin
        next_state = state;
        next_count = count;
        case (state)
            A: begin
                if (s) next_state = B;
                else next_state = A;
                next_count = 2'd0;
            end
            B: begin
                next_state = C;
                next_count = (w ? 2'd1 : 2'd0);
            end
            C: begin
                next_state = D;
                next_count = count + (w ? 2'd1 : 2'd0);
            end
            D: begin
                next_state = E;
                next_count = count + (w ? 2'd1 : 2'd0);
            end
            E: begin
                next_state = B;
                next_count = 2'd0;
            end
            default: begin
                next_state = A;
                next_count = 2'd0;
            end
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            count <= 2'd0;
        end else begin
            state <= next_state;
            count <= next_count;
        end
    end

    assign z = (state == E && count == 2'd2);
endmodule
