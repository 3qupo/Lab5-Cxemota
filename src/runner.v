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
    input up.
    output mosi,
    output miso,
    output sclk
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
reg [reg_width - 1:0] miso_d;
reg [counter_width:0] count;
reg [3:0] state;
reg [2:0] led_counter;