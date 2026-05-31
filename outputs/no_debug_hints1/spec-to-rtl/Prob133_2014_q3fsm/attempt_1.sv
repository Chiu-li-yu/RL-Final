module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output z
);

    typedef enum logic [1:0] {
        STATE_A = 2'b00,
        STATE_B = 2'b01,
        STATE_DONE = 2'b10
    } state_t;

    logic [1:0] state, next_state;
    logic [1:0] count;
    logic [1:0] ones_count;
    logic z_reg;

    always @(posedge clk) begin
        if (reset) begin
            state <= STATE_A;
            count <= 2'b00;
            ones_count <= 2'b00;
            z_reg <= 1'b0;
        end else begin
            state <= next_state;
            if (state == STATE_B) begin
                count <= count + 1'b1;
                if (w) ones_count <= ones_count + 1'b1;
            end else begin
                count <= 2'b00;
                ones_count <= 2'b00;
            end

            if (next_state == STATE_DONE) begin
                z_reg <= (ones_count + (state == STATE_B && w ? 1 : 0) == 2);
            end else if (state == STATE_DONE) begin
                z_reg <= 1'b0;
            end
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            STATE_A: if (s) next_state = STATE_B;
            STATE_B: if (count == 2'b10) next_state = STATE_DONE;
            STATE_DONE: next_state = STATE_B;
            default: next_state = STATE_A;
        endcase
    end

    assign z = z_reg;
endmodule