module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);
    typedef enum logic [2:0] {
        A, B, C1, C2, C3, D, E, F
    } state_t;

    logic [2:0] state, next_state;
    logic [1:0] y_counter;

    always_ff @(posedge clk) begin
        if (!resetn) begin
            state <= A;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            A: next_state = B;
            B: next_state = C1;
            C1: next_state = (x) ? C2 : C1;
            C2: next_state = (x) ? C2 : ((!x) ? C3 : C1);
            C3: next_state = (x) ? D : ((!x) ? C1 : C3);
            D: next_state = (y) ? E : ((y_counter == 2'd1) ? F : D);
            E: next_state = E;
            F: next_state = F;
            default: next_state = A;
        endcase
    end

    always_ff @(posedge clk) begin
        if (!resetn || state == B || state == C1) y_counter <= 2'b0;
        else if (state == D) y_counter <= y_counter + 1'b1;
    end

    assign f = (state == B);
    assign g = (state == D || state == E);

endmodule