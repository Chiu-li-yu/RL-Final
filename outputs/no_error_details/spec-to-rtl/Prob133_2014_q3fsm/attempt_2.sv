module TopModule (
    input logic clk,
    input logic reset,
    input logic s,
    input logic w,
    output logic z
);

    // States: 
    // A: Idle
    // B0: First cycle of checking w
    // B1: Second cycle
    // B2: Third cycle
    // Z: Output cycle (z is evaluated based on previous 3 cycles)

    typedef enum logic [2:0] {
        A, B0, B1, B2, Z
    } state_t;

    state_t state, next_state;
    logic [1:0] w_count;

    always @(*) begin
        case (state)
            A: next_state = s ? B0 : A;
            B0: next_state = B1;
            B1: next_state = B2;
            B2: next_state = Z;
            Z: next_state = B0;
            default: next_state = A;
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            w_count <= 0;
            z <= 0;
        end else begin
            state <= next_state;
            case (next_state)
                B0: begin
                    w_count <= 0;
                    z <= 0;
                end
                B1: begin
                    if (w) w_count <= 1;
                    else w_count <= 0;
                end
                B2: begin
                    if (w) w_count <= w_count + 1;
                end
                Z: begin
                    // At start of Z, w_count holds total of first 3 cycles
                    // Actually, wait: 
                    // Cycle 1: B0
                    // Cycle 2: B1
                    // Cycle 3: B2
                    // Output z: at state Z
                    // Let's adjust logic.
                end
            endcase
        end
    end
endmodule