module TopModule (
    input logic clk,
    input logic reset,
    input logic s,
    input logic w,
    output logic z
);

    typedef enum logic [1:0] {A, B} state_t;
    state_t state, next_state;

    // Counter for checking 3 cycles
    logic [1:0] cycle_cnt;
    // Counter for w=1
    logic [1:0] w_ones;
    logic z_reg;

    always @(*) begin
        case (state)
            A: next_state = s ? B : A;
            B: next_state = B;
            default: next_state = A;
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_cnt <= 0;
            w_ones <= 0;
            z <= 0;
        end else begin
            state <= next_state;
            if (state == A) begin
                cycle_cnt <= 0;
                w_ones <= 0;
                z <= 0;
            end else begin
                if (cycle_cnt == 2) begin
                    // This is the 3rd cycle, evaluate and output
                    if (w_ones + (w ? 1 : 0) == 2) z <= 1;
                    else z <= 0;
                    cycle_cnt <= 0;
                    w_ones <= 0;
                end else begin
                    z <= 0;
                    cycle_cnt <= cycle_cnt + 1;
                    if (w) w_ones <= w_ones + 1;
                    else w_ones <= w_ones;
                end
            end
        end
    end
endmodule