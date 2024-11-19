// Отправитель
// cd C:\iverilog\runner
// iverilog -o ./compiled ./src/runner.v ./src/runner_tb.v ./src/runner_lab.v
// vvp ./compiled 
// Модуль ведущего (Master)
module runner (
    output [5:0] led,
    input rstn,
    input sys_clk,
    input cs,
    input mosi,
    input sclk
);

    






