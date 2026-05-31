module TopModule (
    input logic clk,
    input logic reset,
    input logic s,
    input logic w,
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
    logic [1:0] count, next_count;
    logic next_z;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= A;
            count <= 2'b0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            count <= next_count;
            z <= next_z;
        end
    end

    always @(*) begin
        next_state = state;
        next_count = count;
        next_z = 1'b0;

        case (state)
            A: begin
                if (s) next_state = B;
            end
            B: begin
                next_count = (w) ? 2'd1 : 2'd0;
                next_state = C1;
            end
            C1: begin
                next_count = count + (w ? 1'b1 : 1'b0);
                next_state = C2;
            end
            C2: begin
                next_count = count + (w ? 1'b1 : 1'b0);
                next_state = C3;
            end
            C3: begin
                next_z = (count + (w ? 1'b1 : 1'b0) == 2'd2);
                next_state = B;
                next_count = 2'd0;
            end
        endcase
    end
endmodule
