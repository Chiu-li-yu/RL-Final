module TopModule (
    input clk,
    input in,
    input reset,
    output logic [7:0] out_byte,
    output logic done
);

    logic [1:0] state, next_state;
    logic [7:0] shift_reg;
    logic [2:0] count;
    
    localparam IDLE = 2'd0;
    localparam DATA = 2'd1;
    localparam WAIT_STOP = 2'd2;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            count <= 3'd0;
            shift_reg <= 8'd0;
            done <= 1'b0;
            out_byte <= 8'd0;
        end else begin
            state <= next_state;
            
            if (state == IDLE && in == 1'b0) begin
                count <= 3'd0;
                done <= 1'b0;
            end else if (state == DATA) begin
                count <= count + 1'b1;
                shift_reg <= {in, shift_reg[7:1]};
                done <= 1'b0;
            end else if (state == WAIT_STOP) begin
                if (in == 1'b1) begin
                    done <= 1'b1;
                    out_byte <= shift_reg;
                end else begin
                    done <= 1'b0;
                end
            end else begin
                done <= 1'b0;
            end
        end
    end

    always @(*) begin
        case (state)
            IDLE: next_state = (in == 1'b0) ? DATA : IDLE;
            DATA: next_state = (count == 3'd7) ? WAIT_STOP : DATA;
            WAIT_STOP: next_state = (in == 1'b1) ? IDLE : WAIT_STOP;
            default: next_state = IDLE;
        endcase
    end
endmodule
