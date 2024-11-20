// Отправитель
// cd C:\iverilog\runner
// iverilog -o ./compiled ./src/runner.v ./src/runner_tb.v ./src/runner_lab.v
// vvp ./compiled 
// Модуль ведущего (Master)
module runner (
    output [5:0] led,
    input rstn,
    input sys_clk,
    input t_star,
    input up,
    input miso,
    output mosi,
    output sclk
);

parameter reg_width = 8;
parameter counter_width = $clog2(reg_width);
parameter reset = 0;
parameter idle = 1;
parameter load = 2;
parameter transact1 = 3;
parameter transact2 = 4;

reg [reg_width - 1:0] mosi_d;
reg [counter_width:0] count;
reg [3:0] state;
reg [2:0] led_counter;
reg tmpcs = 1;

initial begin
    led_counter <= 0;
    mosi_d <= 0;
    state <= reset;
end

always @(state) begin
    case (state)
        reset: begin
            mosi_d <= 0;
            count <= 0;
            tmpcs <= 1;
        end
        idle: begin
            mosi_d <= 0;
            count <= 0;
            tmpcs <= 1;
        end
        load: begin
            mosi_d <= led;
            count <= reg_width;
            tmpcs <= 0;
        end
        transact1: begin
            tmpcs <= 0;
            mosi_d <= {mosi_d[reg_width - 2:0], 1'b0};
            count <= count - 1;
        end
    endcase
end

assign mosi = (~tmpcs) ? mosi_d[reg_width - 1] : 1'bz;
assign sclk = (state == transact1 || state == transact2) ? sys_clk : 1'b0;

always @(posedge sys_clk) begin
    if (!rstn)
        led_counter <= 0;
    else if (!up) begin
        led_counter <= led_counter + 1;
        if (led_counter == 5)
            led_counter <= 0;
    end
end

genvar i;
generate
    for (i = 0; i < 6; i = i + 1) begin
        assign led[i] = (rstn ? led_counter != i : 0);
    end
endgenerate

endmodule
