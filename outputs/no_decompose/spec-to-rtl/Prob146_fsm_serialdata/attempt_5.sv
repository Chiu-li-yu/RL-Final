module TopModule (
    input clk,
    input in,
    input reset,
    output logic [7:0] out_byte,
    output logic done
);

    logic [2:0] state, next_state;
    logic [7:0] data;
    logic [2:0] count;

    parameter IDLE  = 3'd0;
    parameter START = 3'd1;
    parameter B0    = 3'd2;
    parameter B1    = 3'd3;
    parameter B2    = 3'd4;
    parameter B3    = 3'd5;
    parameter B4    = 3'd6;
    parameter B5    = 3'd7;
    parameter B6    = 3'd8; // Need to handle 8 bits
    // Actually the logic needs to be simpler

    logic [3:0] s, ns;
    parameter S_IDLE = 4'd0, S_START = 4'd1, S_DATA = 4'd2, S_STOP = 4'd3;

    always_ff @(posedge clk) begin
        if (reset) begin
            s <= S_IDLE;
            data <= 8'b0;
            count <= 3'd0;
            done <= 1'b0;
            out_byte <= 8'b0;
        end else begin
            s <= ns;
            case (s)
                S_IDLE: begin
                    done <= 1'b0;
                    count <= 3'd0;
                end
                S_DATA: begin
                    data <= {in, data[7:1]};
                    count <= count + 1'b1;
                end
                S_STOP: begin
                    if (in == 1'b1) begin
                        done <= 1'b1;
                        out_byte <= data;
                    end
                end
            endcase
        end
    end

    always @(*) begin
        ns = s;
        case (s)
            S_IDLE: ns = (in == 1'b0) ? S_START : S_IDLE;
            S_START: ns = S_DATA;
            S_DATA: ns = (count == 3'd7) ? S_STOP : S_DATA;
            S_STOP: ns = (in == 1'b1) ? S_IDLE : S_STOP;
        endcase
    end
endmodule
