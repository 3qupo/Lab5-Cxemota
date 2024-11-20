`timescale 1ns / 1ps

module runner_tb;
    // Регистры и провода для тестбенча
    reg sys_clk = 0;
    reg rstn = 0;
    reg t_start = 1;
    reg up = 1;
    reg cs = 1;
    reg [7:0] mosi_d [7:0]; // Массив данных для передачи
    wire sclk;
    wire miso;
    wire mosi;  // Определяем как wire
    reg mosi_driver;  // Регистратор для управления mosi в тестбенче
    integer i, j; // Объявляем переменные в начале блока

    // Подключение модулей
    runner master (
        .led(),
        .rstn(rstn),
        .sys_clk(sys_clk),
        .t_star(t_start),
        .up(up),
        .mosi(mosi),
        .miso(miso),
        .sclk(sclk)
    );

    runner_lab slave (
        .led(),
        .rstn(rstn),
        .sys_clk(sys_clk),
        .cs(cs),
        .mosi(mosi),
        .sclk(sclk)
    );

    // Управляем mosi через непрерывное назначение
    assign mosi = mosi_driver;

    // Генерация системного тактового сигнала
    always #5 sys_clk = ~sys_clk;

    // Начало
    // Блок инициализации сигналов и начальных условий
    initial begin
    // Инициализация значений mosi_d
    mosi_d[0] = 8'b00111101;
    mosi_d[1] = 8'b01111010;
    mosi_d[2] = 8'b11110100;
    mosi_d[3] = 8'b11101000;
    mosi_d[4] = 8'b11010000;
    mosi_d[5] = 8'b10100000;
    mosi_d[6] = 8'b01000000;
    mosi_d[7] = 8'b10000000;

    rstn = 0;  // Активный сброс
    t_start = 1;
    up = 1;
    cs = 1;
    mosi_driver = 0;

    // Этап 1: Сброс системы
    #10;
    rstn = 1;  // Выход из сброса
    #20;

    // Этап 2: Передача данных через одно нажатие кнопки
    cs = 0;
    for (i = 0; i < 8; i = i + 1) begin
        // Моделируем нажатие кнопки
        up = 0;
        #10;
        up = 1;

        // Передача значения mosi_d[i]
        for (j = 0; j < 8; j = j + 1) begin
            mosi_driver = mosi_d[i][j];  // Передаём очередной бит
            #10;  // Ждём, пока бит передастся
        end
        #20;  // Задержка между передачами
    end

    cs = 1;  // Завершение передачи
    #50;
end
    // Конец

    // Конец - обязательная часть
    initial begin
        $dumpfile("./runner_out.vcd");  // Файл для сохранения результатов
        $dumpvars(0, runner_tb);       // Сохраняем переменные для анализа
        #1000 $finish;                 // Завершаем симуляцию через 1000 ns
    end
    // Конец
endmodule
