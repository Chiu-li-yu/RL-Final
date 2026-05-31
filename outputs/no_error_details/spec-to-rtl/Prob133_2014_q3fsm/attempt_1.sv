module TopModule (
    input logic clk,
    input logic reset,
    input logic s,
    input logic w,
    output logic z
);

    typedef enum logic [2:0] {
        STATE_A,
        STATE_B_0,
        STATE_B_1,
        STATE_B_2,
        STATE_Z
    } state_t;

    state_t state, next_state;
    logic [1:0] count_w; // To count how many 1s
    logic [1:0] cycles;  // To count 3 cycles

    always @(posedge clk) begin
        if (reset) begin
            state <= STATE_A;
            count_w <= 0;
            cycles <= 0;
            z <= 0;
        end else begin
            state <= next_state;
            if (state == STATE_A && s) begin
                cycles <= 0;
                count_w <= 0;
            end else if (state != STATE_A) begin
                if (cycles == 2) begin
                    cycles <= 0;
                    count_w <= 0;
                end else begin
                    cycles <= cycles + 1;
                    if (w) count_w <= count_w + 1;
                end
            end
        end
    end

    always @(*) begin
        case (state)
            STATE_A: next_state = s ? STATE_B_0 : STATE_A;
            STATE_B_0: next_state = STATE_B_1;
            STATE_B_1: next_state = STATE_B_2;
            STATE_B_2: next_state = STATE_Z;
            STATE_Z: next_state = STATE_B_0;
            default: next_state = STATE_A;
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            z <= 0;
        end else begin
            if (next_state == STATE_Z) begin
                if ((count_w + (w ? 1 : 0)) == 2) z <= 1;
                else z <= 0;
            end else begin
                z <= 0;
            end
        end
    end

endmodule