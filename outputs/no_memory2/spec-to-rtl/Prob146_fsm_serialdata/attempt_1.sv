module TopModule(
    input clk,
    input in,
    input reset,
    output logic [7:0] out_byte,
    output logic done
);
    // UART protocol: 1 start (0), 8 data (LSB first), 1 stop (1)
    // Assuming 1 bit per clock cycle as per "stream of bits" simplified description.

    typedef enum logic [3:0] {
        IDLE,
        START,
        BIT0, BIT1, BIT2, BIT3, BIT4, BIT5, BIT6, BIT7,
        STOP
    } state_t;

    state_t state, next_state;
    logic [7:0] shift_reg;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            out_byte <= 8'd0;
            done <= 1'b0;
            shift_reg <= 8'd0;
        end else begin
            state <= next_state;
            if (state >= BIT0 && state <= BIT7) begin
                shift_reg[state - BIT0] <= in;
            end
            if (state == STOP && in == 1'b1) begin
                out_byte <= shift_reg;
                done <= 1'b1;
            end else begin
                done <= 1'b0;
            end
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            IDLE: next_state = (in == 1'b0) ? START : IDLE;
            START: next_state = BIT0;
            BIT0: next_state = BIT1;
            BIT1: next_state = BIT2;
            BIT2: next_state = BIT3;
            BIT3: next_state = BIT4;
            BIT4: next_state = BIT5;
            BIT5: next_state = BIT6;
            BIT6: next_state = BIT7;
            BIT7: next_state = STOP;
            STOP: next_state = (in == 1'b1) ? IDLE : STOP;
            default: next_state = IDLE;
        endcase
    end
endmodule