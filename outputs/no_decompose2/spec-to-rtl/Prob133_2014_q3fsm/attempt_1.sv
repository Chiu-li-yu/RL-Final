module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output logic z
);

    typedef enum logic [2:0] {
        A, 
        B, 
        C1, 
        C2, 
        C3
    } state_t;

    state_t state, next_state;
    logic [1:0] count;

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            count <= 2'b0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            
            // Logic for count and z
            if (state == B || state == C1 || state == C2) begin
                if (w) count <= count + 1'b1;
            end else if (state == C3) begin
                count <= 2'b0;
            end
            
            if (next_state == B) begin
                z <= (count + (w ? 1'b1 : 1'b0) == 2'd2);
            end else begin
                z <= 1'b0;
            end
        end
    end

    always @(*) begin
        next_state = state;
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
