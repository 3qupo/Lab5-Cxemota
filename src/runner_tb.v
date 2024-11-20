`timescale 1ns / 1ps

module runner_tb;
    // Регистры и провода для тестбенча
    reg sys_clk = 0;
    reg rstn = 0;
    reg t_start = 1;
    reg up = 1;
    reg cs = 1;
    reg [7:0] _mosi;  // Данные для передачи
    wire sclk;
    wire miso;
    wire mosi;  // Определяем как wire
    reg mosi_driver;  // Регистратор для управления mosi в тестбенче

    // Подключение модулей
    runner master (
        .led(),
        .rstn(rstn),
        .sys_clk(sys_clk),
        .t_star(t_start),
        .up(up),
        .mosi(mosi),  // Подключаем как wire
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
        rstn = 0;  // Активный сброс
        t_start = 1;
        up = 1;
        cs = 1;
        mosi_driver = 0;

        // Этап 1: Сброс системы
        #10;
        rstn = 1;  // Выход из сброса
        #20;

        // Этап 2: Передача данных с мастера на ведомый
        t_start = 0;  // Начало передачи
        _mosi = 8'b11001010;  // Данные для передачи

        // Передача данных бит за битом
        repeat (8) begin
            #5 mosi_driver = _mosi[0];
            _mosi = _mosi >> 1;  // Сдвиг на 1 бит вправо
            #5;
        end

        // Этап 3: Завершение передачи
        t_start = 1;
        cs = 1;
        #10;

        // Этап 4: Тест работы кнопки `up`
        up = 0;  // Имитируем нажатие
        #10;
        up = 1;
        #50;
    end
    // Конец

    // Конец - обязательная часть
    initial begin
        $dumpfile("./runner_out.vcd");  // Файл для сохранения результатов
        $dumpvars(0, runner_tb);       // Сохраняем переменные для анализа
        #500 $finish;                  // Завершаем симуляцию через 500 ns
    end
    // Конец
endmodule
