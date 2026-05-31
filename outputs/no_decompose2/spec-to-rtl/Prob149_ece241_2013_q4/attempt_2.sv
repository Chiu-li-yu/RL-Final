module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output logic fr2,
    output logic fr1,
    output logic fr0,
    output logic dfr
);

    logic [1:0] current_state, next_state;
    logic prev_level_higher;
    logic [1:0] prev_state;

    always_ff @(posedge clk) begin
        if (reset) begin
            current_state <= 2'b00;
            prev_state <= 2'b00;
        end else begin
            current_state <= next_state;
            prev_state <= current_state;
        end
    end

    always @(*) begin
        case (s)
            3'b111: next_state = 2'b11;
            3'b011: next_state = 2'b10;
            3'b001: next_state = 2'b01;
            3'b000: next_state = 2'b00;
            default: next_state = current_state;
        endcase

        prev_level_higher = (prev_state > next_state);

        if (next_state == 2'b11) begin
            {fr2, fr1, fr0, dfr} = 4'b0000;
        end else if (next_state == 2'b10) begin
            {fr2, fr1, fr0, dfr} = {1'b0, 1'b0, 1'b1, prev_level_higher};
        end else if (next_state == 2'b01) begin
            {fr2, fr1, fr0, dfr} = {1'b0, 1'b1, 1'b1, prev_level_higher};
        end else begin
            {fr2, fr1, fr0, dfr} = {1'b1, 1'b1, 1'b1, 1'b0};
        end
    end

endmodule
