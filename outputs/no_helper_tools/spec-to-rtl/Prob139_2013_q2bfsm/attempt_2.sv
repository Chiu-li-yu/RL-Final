module TopModule (
    input logic clk,
    input logic resetn,
    input logic x,
    input logic y,
    output logic f,
    output logic g
);

    typedef enum logic [3:0] {
        STATE_A,
        STATE_F,
        STATE_X_WAIT1,
        STATE_X_WAIT0,
        STATE_X_WAIT1_FINAL,
        STATE_G_START,
        STATE_G_MONITOR1,
        STATE_G_MONITOR2,
        STATE_G_KEEP,
        STATE_G_OFF
    } state_t;

    state_t state, next_state;

    always_ff @(posedge clk) begin
        if (!resetn)
            state <= STATE_A;
        else
            state <= next_state;
    end

    always @(*) begin
        next_state = state;
        f = 0;
        g = 0;

        case (state)
            STATE_A: next_state = STATE_F;
            
            STATE_F: begin
                f = 1;
                next_state = STATE_X_WAIT1;
            end
            
            STATE_X_WAIT1: begin
                if (x) next_state = STATE_X_WAIT0;
            end
            
            STATE_X_WAIT0: begin
                if (!x) next_state = STATE_X_WAIT1_FINAL;
                else next_state = STATE_X_WAIT1;
            end
            
            STATE_X_WAIT1_FINAL: begin
                if (x) next_state = STATE_G_START;
                else next_state = STATE_X_WAIT1;
            end
            
            STATE_G_START: begin
                g = 1;
                if (y) next_state = STATE_G_KEEP;
                else next_state = STATE_G_MONITOR1;
            end
            
            STATE_G_MONITOR1: begin
                g = 1;
                if (y) next_state = STATE_G_KEEP;
                else next_state = STATE_G_MONITOR2;
            end
            
            STATE_G_MONITOR2: begin
                g = 1;
                if (y) next_state = STATE_G_KEEP;
                else next_state = STATE_G_OFF;
            end
            
            STATE_G_KEEP: begin
                g = 1;
            end
            
            STATE_G_OFF: begin
                g = 0;
            end
        endcase
    end
endmodule
