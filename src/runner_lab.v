module runner_lab (
    output [5:0] led,
    input rstn,
    input sys_clk,
    input cs,
    input mosi,
    input sclk
);

parameter reg_width = 8;
parameter counter_width = $clog2(reg_width);
parameter reset = 0;
parameter idle = 1;
parameter load = 2;
parameter transact1 = 3;
parameter transact2 = 4;
parameter unload = 5;
integer tmpcs = 1;
reg [reg_width - 1:0] mosi_d;
reg [counter_width:0] count;
reg [3:0] state;
reg [2:0] led_counter;

initial 
    begin 
        led_counter <= 0;
        mosi_d <= -1;
        state <= 0;
    end

always @(state)
    begin
        case(state)
            reset:
                begin
                    mosi_d <= -1;
                    count <= 0;
                end
            idle:
                begin 
                    count <= 0;
                end
            load:
                begin   
                    mosi_d <= -1;
                    count <= reg_width;
                end
            transact1:
                begin  
                    mosi_d <= {mosi_d[reg_width - 2:0], mosi};
                    count <= count - 1;
                end
            transact2:
                begin
                    mosi_d <= {mosi_d[reg_width - 2:0], mosi};
                    count <= count - 1;
                end
            unload:
                begin     
                    count <= 0;
                end
            default:
                begin       
                    count <= 0;
                end
        endcase
    end

always @(sys_clk)
    begin   
        if (!cs)
            begin
                if (count == 0)
                    begin       
                        state = load;
                        state = transact1;
                    end
                else    
                    case(state)
                        transact1:
                            state = transact1;
                        transact2:
                            state = transact2;
                    endcase
            end
        else
            state = idle;
    end

assign sclk = (state == transact1 || state == transact2) ? sys_clk : 1'b0;

genvar i;
generate
    for (i = 0; i < 6; i = i + 1)
        begin       
            assign led[i] = (rstn ? mosi_d[7 - i] : 1);
        end
endgenerate


endmodule