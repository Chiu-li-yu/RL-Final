module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output logic z
);

    localparam STATE_A = 1'b0;
    localparam STATE_B = 1'b1;

    logic current_state, next_state;
    logic [1:0] counter;
    logic [1:0] w_count;

    always_ff @(posedge clk) begin
        if (reset) begin
            current_state <= STATE_A;
            counter <= 2'b00;
            w_count <= 2'b00;
            z <= 1'b0;
        end else begin
            current_state <= next_state;
            if (current_state == STATE_B) begin
                if (counter == 2'd2) begin
                    counter <= 2'b00;
                    w_count <= 2'b00;
                    z <= ((w_count + (w ? 1'b1 : 1'b0)) == 2'd2);
                end else begin
                    counter <= counter + 1'b1;
                    w_count <= w_count + (w ? 1'b1 : 1'b0);
                    z <= 1'b0;
                end
            end else begin
                counter <= 2'b00;
                w_count <= 2'b00;
                z <= 1'b0;
            end
        end
    end

    always @(*) begin
        case (current_state)
            STATE_A: next_state = s ? STATE_B : STATE_A;
            STATE_B: next_state = STATE_B;
            default: next_state = STATE_A;
        endcase
    end

endmodule
