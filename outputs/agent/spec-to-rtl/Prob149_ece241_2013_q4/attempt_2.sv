module TopModule (
    input logic clk,
    input logic reset,
    input logic [2:0] s,
    output logic fr2,
    output logic fr1,
    output logic fr0,
    output logic dfr
);

    // States based on sensor inputs:
    // Below s[0]: 000
    // s[0]: 001
    // s[0], s[1]: 011
    // s[0], s[1], s[2]: 111
    
    // We need to store the "last state" that was valid
    logic [2:0] current_state, prev_state;

    // Determine state from sensors (only consider valid combinations)
    logic [2:0] next_state;
    always @(*) begin
        case (s)
            3'b000: next_state = 3'b000;
            3'b001: next_state = 3'b001;
            3'b011: next_state = 3'b011;
            3'b111: next_state = 3'b111;
            default: next_state = current_state;
        endcase
    end

    // Sequential update
    always_ff @(posedge clk) begin
        if (reset) begin
            current_state <= 3'b000;
            prev_state    <= 3'b000;
        end else begin
            if (next_state != current_state) begin
                prev_state    <= current_state;
                current_state <= next_state;
            end
        end
    end

    // Output logic
    always @(*) begin
        if (reset) begin
            fr2 = 1;
            fr1 = 1;
            fr0 = 1;
            dfr = 1;
        end else begin
            // Nominal flow rates
            case (current_state)
                3'b111: {fr2, fr1, fr0} = 3'b000;
                3'b011: {fr2, fr1, fr0} = 3'b001;
                3'b001: {fr2, fr1, fr0} = 3'b011;
                3'b000: {fr2, fr1, fr0} = 3'b111;
                default: {fr2, fr1, fr0} = 3'b000;
            endcase

            // Supplemental flow: if prev_state < current_state (water level rising)
            dfr = (prev_state < current_state);
        end
    end

endmodule
