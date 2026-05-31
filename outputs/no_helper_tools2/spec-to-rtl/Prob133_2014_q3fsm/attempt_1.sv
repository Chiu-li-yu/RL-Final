module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output z
);

    // States:
    // A: IDLE
    // B1: 1st cycle of checking w
    // B2: 2nd cycle of checking w
    // B3: 3rd cycle of checking w (last cycle)
    
    typedef enum logic [2:0] {A = 0, B1 = 1, B2 = 2, B3 = 3} state_t;
    logic [2:0] state, next_state;
    logic [1:0] count, next_count;
    logic z_reg, next_z;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= A;
            count <= 0;
            z_reg <= 0;
        end else begin
            state <= next_state;
            count <= next_count;
            z_reg <= next_z;
        end
    end

    always @(*) begin
        next_state = state;
        next_count = count;
        next_z = 0;
        case (state)
            A: begin
                if (s) next_state = B1;
            end
            B1: begin
                next_count = (w) ? 1 : 0;
                next_state = B2;
            end
            B2: begin
                next_count = count + (w ? 1 : 0);
                next_state = B3;
            end
            B3: begin
                if (count + (w ? 1 : 0) == 2) next_z = 1;
                next_state = B1;
                next_count = 0;
            end
            default: next_state = A;
        endcase
    end

    assign z = z_reg;

endmodule
