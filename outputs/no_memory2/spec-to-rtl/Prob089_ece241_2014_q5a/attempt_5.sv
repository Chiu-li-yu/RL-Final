module TopModule (
    input logic clk,
    input logic areset,
    input logic x,
    output logic z
);

    typedef enum logic {
        S0 = 1'b0,
        S1 = 1'b1
    } state_t;

    state_t current_state, next_state;

    // State Register with asynchronous reset
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= S0;
        end else begin
            current_state <= next_state;
        end
    end

    // Next State Logic
    always @(*) begin
        case (current_state)
            S0: begin
                if (x)
                    next_state = S1;
                else
                    next_state = S0;
            end
            S1: begin
                next_state = S1;
            end
            default: next_state = S0;
        endcase
    end

    // Output Logic
    // Moore Machine: z depends only on the current state and x (wait, Moore means only state)
    // Actually, serial 2's complementer logic is usually:
    // If S0, z = x
    // If S1, z = ~x
    // This is Mealy. The prompt asks for a Moore state machine.
    // To make it Moore, we need more states.
    // State 0: Haven't seen '1' yet. Output is 0.
    // State 1: Have seen '1'. Current bit is 0, output is 1.
    // State 2: Have seen '1'. Current bit is 1, output is 0.
    // Let's re-design for Moore machine.
    
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        INV_0 = 2'b01,
        INV_1 = 2'b10
    } moore_state_t;

    moore_state_t m_current_state, m_next_state;

    always_ff @(posedge clk or posedge areset) begin
        if (areset) m_current_state <= IDLE;
        else m_current_state <= m_next_state;
    end

    always @(*) begin
        case (m_current_state)
            IDLE:  m_next_state = (x) ? INV_1 : IDLE;
            INV_0: m_next_state = (x) ? INV_1 : INV_0;
            INV_1: m_next_state = (x) ? INV_1 : INV_0;
            default: m_next_state = IDLE;
        endcase
    end

    always @(*) begin
        case (m_current_state)
            IDLE:  z = 0;
            INV_0: z = 1;
            INV_1: z = 0;
            default: z = 0;
        endcase
    end

endmodule
