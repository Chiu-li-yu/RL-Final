module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output done
);

    // States: 
    // IDLE: Looking for byte 1 (in[3] == 1)
    // BYTE2: Waiting for 2nd byte
    // BYTE3: Waiting for 3rd byte
    
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        BYTE2 = 2'b01,
        BYTE3 = 2'b10
    } state_t;

    logic [1:0] state, next_state;
    logic done_reg;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done_reg <= 1'b0;
        end else begin
            state <= next_state;
            if (state == BYTE3) begin
                done_reg <= 1'b1;
            end else begin
                done_reg <= 1'b0;
            end
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (in[3]) begin
                    next_state = BYTE2;
                end else begin
                    next_state = IDLE;
                end
            end
            BYTE2: begin
                next_state = BYTE3;
            end
            BYTE3: begin
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    assign done = done_reg;

endmodule