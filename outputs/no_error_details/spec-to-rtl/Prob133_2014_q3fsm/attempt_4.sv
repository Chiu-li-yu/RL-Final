module TopModule (
    input logic clk,
    input logic reset,
    input logic s,
    input logic w,
    output logic z
);

    typedef enum logic [1:0] {A, B} state_t;
    state_t state;
    
    logic [1:0] cycle_cnt;
    logic [1:0] w_ones;

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_cnt <= 0;
            w_ones <= 0;
            z <= 0;
        end else begin
            case (state)
                A: begin
                    z <= 0;
                    if (s) state <= B;
                    cycle_cnt <= 0;
                    w_ones <= 0;
                end
                B: begin
                    if (cycle_cnt == 2) begin
                        // cycle 3 reached, evaluate
                        if (w_ones + (w ? 1 : 0) == 2) z <= 1;
                        else z <= 0;
                        cycle_cnt <= 0;
                        w_ones <= 0;
                    end else begin
                        z <= 0;
                        cycle_cnt <= cycle_cnt + 1;
                        if (w) w_ones <= w_ones + 1;
                    end
                end
            endcase
        end
    end
endmodule