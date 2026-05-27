module TopModule (
    input logic clk,
    input logic reset,
    input logic s,
    input logic w,
    output logic z
);

    typedef enum logic [2:0] {
        A = 3'd0,
        B_1 = 3'd1,
        B_2 = 3'd2,
        B_3 = 3'd3,
        DONE = 3'd4
    } state_t;

    state_t state, next_state;
    logic [1:0] count, next_count;
    logic next_z;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= A;
            count <= 2'd0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            count <= next_count;
            z <= next_z;
        end
    end

    always_comb begin
        next_state = state;
        next_count = count;
        next_z = 1'b0;

        case (state)
            A: begin
                if (s) begin
                    next_state = B_1;
                    next_count = 2'd0;
                end
            end
            B_1: begin
                next_count = w ? 2'd1 : 2'd0;
                next_state = B_2;
            end
            B_2: begin
                next_count = w ? count + 1'b1 : count;
                next_state = B_3;
            end
            B_3: begin
                next_count = w ? count + 1'b1 : count;
                next_state = DONE;
            end
            DONE: begin
                next_z = (count == 2'd2);
                next_state = B_1;
                next_count = 2'd0;
            end
            default: next_state = A;
        endcase
    end
endmodule