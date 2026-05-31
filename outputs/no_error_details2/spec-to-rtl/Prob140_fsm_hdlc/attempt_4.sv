module TopModule (
    input clk,
    input reset,
    input in,
    output logic disc,
    output logic flag,
    output logic err
);
    // Based on the spec:
    // (1) 0111110: disc (at the 0 position, effectively, the discard happens after 5 ones)
    // Actually, "0111110: signal a bit needs to be discarded". 
    // Wait, the stuffing is 0 after 5 ones.
    
    typedef enum logic [3:0] {
        IDLE=0, C1=1, C2=2, C3=3, C4=4, C5=5, C6=6, C7=7
    } state_t;

    state_t state;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            disc <= 0;
            flag <= 0;
            err <= 0;
            
            case (state)
                IDLE: state <= in ? C1 : IDLE;
                C1:   state <= in ? C2 : IDLE;
                C2:   state <= in ? C3 : IDLE;
                C3:   state <= in ? C4 : IDLE;
                C4:   state <= in ? C5 : IDLE;
                C5:   if (in) state <= C6; else begin state <= IDLE; disc <= 1; end
                C6:   if (in) state <= C7; else begin state <= IDLE; flag <= 1; end
                C7:   if (in) state <= C7; else begin state <= IDLE; err <= 1; end
            endcase
        end
    end
endmodule