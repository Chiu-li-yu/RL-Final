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
    logic [1:0] count;       // 0, 1, 2, 3 cycles
    logic [1:0] w_ones;      // count of w=1
    logic z_next;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= STATE_A;
            count <= 2'b00;
            w_ones <= 2'b00;
            z <= 1'b0;
        end else begin
            state <= next_state;
            if (state == STATE_B) begin
                if (count == 2'd2) begin
                    count <= 2'd0;
                    w_ones <= 2'd0;
                    z <= z_next;
                end else begin
                    count <= count + 1'b1;
                    w_ones <= w_ones + w;
                    z <= 1'b0;
                end
            end else begin
                count <= 2'd0;
                w_ones <= 2'd0;
                z <= 1'b0;
            end
        end
    end

    always @(*) begin
        next_state = state;
        z_next = 1'b0;
        
        case (state)
            STATE_A: begin
                if (s) next_state = STATE_B;
            end
            STATE_B: begin
                if (count == 2'd2) begin
                    // Check condition after 3 cycles (the 3rd cycle is current)
                    if ((w_ones + w) == 2'd2) begin
                        z_next = 1'b1;
                    end else begin
                        z_next = 1'b0;
                    end
                end
            end
        endcase
    end

endmodule
