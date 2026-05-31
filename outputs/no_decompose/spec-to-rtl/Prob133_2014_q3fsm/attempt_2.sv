module TopModule (
    input logic clk,
    input logic reset,
    input logic s,
    input logic w,
    output logic z
);

    typedef enum logic [1:0] {
        A = 2'd0,
        B = 2'd1,
        CHECK = 2'd2
    } state_t;

    state_t state, next_state;
    logic [1:0] count;
    logic [1:0] cycle_cnt;
    logic next_z;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= A;
            count <= 2'b0;
            cycle_cnt <= 2'b0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            if (state == B) begin
                count <= (w ? 1'b1 : 1'b0);
                cycle_cnt <= 2'd1;
            end else if (state == CHECK) begin
                if (cycle_cnt == 2'd2) begin
                    count <= 2'b0;
                    cycle_cnt <= 2'b0;
                    z <= (count + (w ? 1'b1 : 1'b0) == 2'd2);
                end else begin
                    count <= count + (w ? 1'b1 : 1'b0);
                    cycle_cnt <= cycle_cnt + 1'b1;
                    z <= 1'b0;
                end
            end else begin
                z <= 1'b0;
            end
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            A: if (s) next_state = B;
            B: next_state = CHECK;
            CHECK: if (cycle_cnt == 2'd2) next_state = B;
        endcase
    end
endmodule
