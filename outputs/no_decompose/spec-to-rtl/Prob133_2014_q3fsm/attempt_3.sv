module TopModule (
    input logic clk,
    input logic reset,
    input logic s,
    input logic w,
    output logic z
);

    // State definitions
    typedef enum logic [1:0] {
        A = 2'd0,
        B = 2'd1,
        CHECK = 2'd2
    } state_t;

    state_t state, next_state;
    logic [1:0] count;
    logic [1:0] cycle;
    logic next_z;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= A;
            count <= 2'd0;
            cycle <= 2'd0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            if (state == A && s) begin
                count <= 2'd0;
                cycle <= 2'd0;
                z <= 1'b0;
            end else if (state == B || (state == CHECK && cycle < 2)) begin
                count <= count + (w ? 1'b1 : 1'b0);
                cycle <= cycle + 1'b1;
                z <= 1'b0;
            end else if (state == CHECK && cycle == 2) begin
                z <= (count + (w ? 1'b1 : 1'b0) == 2'd2);
                count <= 2'd0;
                cycle <= 2'd0;
            end
        end
    end

    always @(*) begin
        case (state)
            A: next_state = s ? B : A;
            B: next_state = CHECK;
            CHECK: next_state = (cycle == 2) ? B : CHECK;
            default: next_state = A;
        endcase
    end
endmodule
