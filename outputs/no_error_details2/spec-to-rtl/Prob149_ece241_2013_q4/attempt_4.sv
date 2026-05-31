module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output logic fr2,
    output logic fr1,
    output logic fr0,
    output logic dfr
);

    logic [1:0] current_state;
    logic [1:0] prev_state;

    // Define state from sensors
    logic [1:0] s_encoded;
    always @(*) begin
        case (s)
            3'b000: s_encoded = 2'd0; // Below s[0]
            3'b001: s_encoded = 2'd1; // Between s[1] and s[0]
            3'b011: s_encoded = 2'd2; // Between s[2] and s[1]
            3'b111: s_encoded = 2'd3; // Above s[2]
            default: s_encoded = 2'd0;
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            current_state <= 2'd0;
            prev_state <= 2'd0;
        end else if (s_encoded != current_state) begin
            prev_state <= current_state;
            current_state <= s_encoded;
        end
    end

    // Outputs
    always @(*) begin
        // Nominal Flow
        // Below s[0]: fr0, fr1, fr2
        // Between s[1] and s[0]: fr0, fr1
        // Between s[2] and s[1]: fr0
        // Above s[2]: None
        fr2 = (current_state == 2'd0);
        fr1 = (current_state == 2'd0 || current_state == 2'd1);
        fr0 = (current_state == 2'd0 || current_state == 2'd1 || current_state == 2'd2);
        
        // dfr logic
        // Reset: "reset state machine to a state equivalent to... (no sensors asserted, and all four outputs asserted)"
        // This implies at reset, dfr is 1.
        if (reset) begin
            dfr = 1;
        end else if (current_state < prev_state) begin
            dfr = 1;
        end else begin
            dfr = 0;
        end
    end

endmodule