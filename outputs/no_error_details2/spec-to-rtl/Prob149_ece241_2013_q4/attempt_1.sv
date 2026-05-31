module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output logic fr2,
    output logic fr1,
    output logic fr0,
    output logic dfr
);

    // FSM States representing the four zones:
    // 0: Below s[0] (None)
    // 1: Between s[0] and s[1] (s[0])
    // 2: Between s[1] and s[2] (s[0], s[1])
    // 3: Above s[2] (s[0], s[1], s[2])
    
    logic [1:0] current_state;
    logic [1:0] prev_state;

    // Determine current zone based on sensors
    logic [1:0] next_state;
    always @(*) begin
        case (s)
            3'b000: next_state = 2'd0;
            3'b001: next_state = 2'd1;
            3'b011: next_state = 2'd2;
            3'b111: next_state = 2'd3;
            default: next_state = current_state; // Should not happen based on spec
        endcase
    end

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            current_state <= 2'd0;
            prev_state <= 2'd0;
        end else if (s == 3'b000 || s == 3'b001 || s == 3'b011 || s == 3'b111) begin
            if (next_state != current_state) begin
                prev_state <= current_state;
                current_state <= next_state;
            end
        end
    end

    // Nominal flow outputs
    always @(*) begin
        case (current_state)
            2'd0: {fr2, fr1, fr0} = 3'b111;
            2'd1: {fr2, fr1, fr0} = 3'b011;
            2'd2: {fr2, fr1, fr0} = 3'b001;
            2'd3: {fr2, fr1, fr0} = 3'b000;
            default: {fr2, fr1, fr0} = 3'b000;
        endcase
    end

    // Supplemental flow (dfr)
    // "If the sensor change indicates that the previous level was higher than the current level, 
    // the flow rate should be increased by opening the Supplemental flow valve"
    always @(*) begin
        if (reset) begin
            dfr = 1;
        end else if (current_state < prev_state) begin
            dfr = 1;
        end else if (current_state > prev_state) begin
            dfr = 0;
        end else begin
            // If at reset condition
            dfr = (current_state == 2'd0) ? 1 : 0;
        end
    end

endmodule