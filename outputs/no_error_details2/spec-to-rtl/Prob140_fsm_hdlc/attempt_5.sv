module TopModule (
    input clk,
    input reset,
    input in,
    output logic disc,
    output logic flag,
    output logic err
);
    // (1) 0111110: disc (at the 6th bit, which is 0)
    // (2) 01111110: flag (at the 8th bit, which is 0)
    // (3) 01111111...: err (at the 8th bit, which is 1)
    
    typedef enum logic [3:0] {
        ST_0=0, ST_1=1, ST_2=2, ST_3=3, ST_4=4, ST_5=5, ST_6=6, ST_7=7
    } state_t;

    state_t state;

    always @(posedge clk) begin
        if (reset) begin
            state <= ST_0;
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            disc <= 0;
            flag <= 0;
            err <= 0;
            
            case (state)
                ST_0: state <= in ? ST_1 : ST_0;
                ST_1: state <= in ? ST_2 : ST_0;
                ST_2: state <= in ? ST_3 : ST_0;
                ST_3: state <= in ? ST_4 : ST_0;
                ST_4: state <= in ? ST_5 : ST_0;
                ST_5: if (in) state <= ST_6; else begin state <= ST_0; disc <= 1; end
                ST_6: if (in) state <= ST_7; else begin state <= ST_0; flag <= 1; end
                ST_7: if (in) state <= ST_7; else begin state <= ST_0; err <= 1; end
            endcase
        end
    end
endmodule