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

    // Map sensors to internal state
    // 0: None, 1: s[0], 2: s[0],s[1], 3: s[0],s[1],s[2]
    logic [1:0] state_from_sensors;
    always @(*) begin
        case (s)
            3'b000: state_from_sensors = 2'd0;
            3'b001: state_from_sensors = 2'd1;
            3'b011: state_from_sensors = 2'd2;
            3'b111: state_from_sensors = 2'd3;
            default: state_from_sensors = 2'd0; 
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            current_state <= 2'd0;
            prev_state <= 2'd0; // Assuming "long time" means prev is same or low
        end else begin
            if (state_from_sensors != current_state) begin
                prev_state <= current_state;
                current_state <= state_from_sensors;
            end
        end
    end

    // Outputs
    always @(*) begin
        // Nominal
        case (current_state)
            2'd0: {fr2, fr1, fr0} = 3'b111;
            2'd1: {fr2, fr1, fr0} = 3'b011;
            2'd2: {fr2, fr1, fr0} = 3'b001;
            2'd3: {fr2, fr1, fr0} = 3'b000;
            default: {fr2, fr1, fr0} = 3'b000;
        endcase
        
        // dfr logic
        if (reset) begin
            dfr = 1;
        end else if (current_state < prev_state) begin
            dfr = 1;
        end else begin
            dfr = 0;
        end
    end

endmodule