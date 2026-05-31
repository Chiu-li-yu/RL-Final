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

    logic [1:0] state, next_state;
    logic [1:0] count;
    logic [1:0] cycle;
    logic z_reg;

    assign z = z_reg;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= A;
            count <= 2'd0;
            cycle <= 2'd0;
            z_reg <= 1'b0;
        end else begin
            state <= next_state;
            if (state == A && s) begin
                count <= 2'd0;
                cycle <= 2'd0;
                z_reg <= 1'b0;
            end else if (state == B || (state == CHECK && cycle < 2)) begin
                count <= count + (w ? 1'b1 : 1'b0);
                cycle <= cycle + 1'b1;
                z_reg <= 1'b0;
            end else if (state == CHECK && cycle == 2) begin
                z_reg <= (count + (w ? 1'b1 : 1'b0) == 2'd2);
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
