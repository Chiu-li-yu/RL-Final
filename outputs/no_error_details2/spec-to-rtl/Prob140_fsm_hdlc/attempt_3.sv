module TopModule (
    input clk,
    input reset,
    input in,
    output logic disc,
    output logic flag,
    output logic err
);

    // Using Moore FSM states
    // S0 is the starting state or after a 0 is received.
    // S1~S6 track 1 to 6 consecutive ones.
    // S7 tracks 7+ ones.
    // The outputs disc, flag, err should be asserted for a complete cycle *after* the condition occurs.
    
    typedef enum logic [3:0] {
        S0=0, S1=1, S2=2, S3=3, S4=4, S5=5, S6=6, S7=7,
        S_DISC=8, S_FLAG=9, S_ERR=10
    } state_t;

    state_t state;

    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            // Reset signals before calculating new state to ensure output cycle duration
            disc <= 0;
            flag <= 0;
            err <= 0;
            
            case (state)
                S0: state <= in ? S1 : S0;
                S1: state <= in ? S2 : S0;
                S2: state <= in ? S3 : S0;
                S3: state <= in ? S4 : S0;
                S4: state <= in ? S5 : S0;
                S5: if (in) state <= S6; else begin state <= S0; disc <= 1; end
                S6: if (in) state <= S7; else begin state <= S0; flag <= 1; end
                S7: if (in) state <= S7; else begin state <= S0; err <= 1; end
                default: state <= S0;
            endcase
        end
    end
endmodule