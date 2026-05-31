module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output logic z
);

    localparam A = 3'd0;
    localparam B = 3'd1;
    localparam C1 = 3'd2;
    localparam C2 = 3'd3;
    localparam C3 = 3'd4;

    logic [2:0] state, next_state;
    logic [1:0] count;

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
        end else begin
            state <= next_state;
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            count <= 2'b0;
            z <= 1'b0;
        end else begin
            if (state == B) begin
                count <= w ? 2'd1 : 2'd0;
                z <= 1'b0;
            end else if (state == C1) begin
                count <= count + (w ? 1'b1 : 1'b0);
            end else if (state == C2) begin
                count <= count + (w ? 1'b1 : 1'b0);
            end else if (state == C3) begin
                z <= (count == 2'd2);
                count <= 2'd0;
            end
        end
    end

    always @(*) begin
        case (state)
            A: next_state = s ? B : A;
            B: next_state = C1;
            C1: next_state = C2;
            C2: next_state = C3;
            C3: next_state = B;
            default: next_state = A;
        endcase
    end

endmodule
