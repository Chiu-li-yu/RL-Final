module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output z
);

    typedef enum logic [1:0] {
        STATE_A = 2'b00,
        STATE_B = 2'b01
    } state_t;

    logic state, next_state;
    logic [1:0] count;
    logic [1:0] ones;
    logic z_val;

    always @(posedge clk) begin
        if (reset) begin
            state <= STATE_A;
            count <= 2'b00;
            ones <= 2'b0;
            z_val <= 1'b0;
        end else begin
            state <= next_state;
            if (next_state == STATE_B) begin
                if (state == STATE_A) begin
                    count <= 2'b00;
                    ones <= 2'b0;
                    z_val <= 1'b0;
                end else begin
                    count <= count + 1'b1;
                    if (w) ones <= ones + 1'b1;
                    
                    if (count == 2'b10) begin
                        z_val <= ((ones + (w ? 1'b1 : 1'b0)) == 2'd2);
                        count <= 2'b00;
                        ones <= 2'b0;
                    end else begin
                        z_val <= 1'b0;
                    end
                end
            end else begin
                z_val <= 1'b0;
            end
        end
    end

    always @(*) begin
        case (state)
            STATE_A: next_state = s ? STATE_B : STATE_A;
            STATE_B: next_state = STATE_B;
            default: next_state = STATE_A;
        endcase
    end

    assign z = z_val;
endmodule