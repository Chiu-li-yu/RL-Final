module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    typedef enum logic [1:0] {
        A = 2'b00,
        B = 2'b01,
        C = 2'b10,
        D = 2'b11
    } state_t;

    logic [1:0] current_state, next_state;
    logic out_reg;

    always_ff @(posedge clk) begin
        if (reset) begin
            current_state <= A;
        end else begin
            current_state <= next_state;
        end
    end

    always @(*) begin
        case (current_state)
            A: next_state = in ? B : A;
            B: next_state = in ? B : C;
            C: next_state = in ? D : A;
            D: next_state = in ? B : C;
            default: next_state = A;
        endcase
    end

    always @(*) begin
        case (current_state)
            A: out_reg = 1'b0;
            B: out_reg = 1'b0;
            C: out_reg = 1'b0;
            D: out_reg = 1'b1;
            default: out_reg = 1'b0;
        endcase
    end

    assign out = out_reg;

endmodule