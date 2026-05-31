module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output logic z
);

    typedef enum logic [1:0] {
        STATE_A = 2'b00,
        STATE_B = 2'b01
    } state_t;

    state_t state, next_state;
    logic [1:0] count;
    logic [1:0] timer;

    always @(posedge clk) begin
        if (reset) begin
            state <= STATE_A;
            count <= 2'b00;
            timer <= 2'b00;
            z <= 1'b0;
        end else begin
            state <= next_state;
            if (state == STATE_B) begin
                if (timer == 2'b10) begin // 3rd cycle
                    timer <= 2'b00;
                    count <= 2'b00;
                    z <= (count + w == 2'b10);
                end else begin
                    timer <= timer + 1'b1;
                    count <= count + w;
                    z <= 1'b0;
                end
            end else begin
                timer <= 2'b00;
                count <= 2'b00;
                z <= 1'b0;
            end
        end
    end

    always @(*) begin
        case (state)
            STATE_A: next_state = (s) ? STATE_B : STATE_A;
            STATE_B: next_state = STATE_B;
            default: next_state = STATE_A;
        endcase
    end
endmodule