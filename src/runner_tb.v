`timescale 1ns / 1ps

module runner_tb;
    // Параметры
    parameter CLK_PERIOD = 10; // Период тактового сигнала 10 нс

    // Входы и выходы
    reg rstn;               // Сброс
    reg sys_clk;            // Системная тактовая частота
    reg t_start;            // Старт передачи (для Master)
    reg up;                 // Управляющий сигнал
    reg [7:0] mosi_d;       // Данные для передачи
    wire miso;              // Данные от Slave к Master
    wire mosi;              // Данные от Master к Slave
    wire sclk;              // Синхросигнал
    wire cs;                // Выбор Slave
    wire [5:0] master_led;  // Индикатор Master
    wire [5:0] slave_led;   // Индикатор Slave

    // Подключение модулей
    runner master (
        .rstn(rstn),
        .sys_clk(sys_clk),
        .t_start(t_start),
        .up(up),
        .miso(miso),
        .cs(cs),
        .mosi(mosi),
        .sclk(sclk),
        .led(master_led)
    );

    runner_lab slave (
        .rstn(rstn),
        .sys_clk(sys_clk),
        .cs(cs),
        .mosi(mosi),
        .sclk(sclk),
        .led(slave_led)
    );

    // Генерация системного тактового сигнала
    always #(CLK_PERIOD / 2) sys_clk = ~sys_clk;

    // Тестовая последовательность
    initial begin
        // Инициализация сигналов
        sys_clk = 1;           // Инициализация тактового сигнала
        rstn = 1;              // Снятие сброса
        t_start = 0;           // Передача не началась
        up = 0;                // Управляющий сигнал выключен
        mosi_d = 8'b00101010;  // Инициализация данных для отправки

        // Начало передачи
        #10;
        t_start = 1;          // Запуск передачи
        up = 1;               // Устанавливаем управляющий сигнал
        #CLK_PERIOD;

        t_start = 0;          // Окончание передачи
        up = 0;

        // Завершение моделирования
        #100;
        $stop;
    end

    // Мониторинг данных
    initial begin
        $monitor("Time: %0dns | Master LED: %b | Slave LED: %b | MOSI: %b | MISO: %b | SCLK: %b | CS: %b", 
                  $time, master_led, slave_led, mosi, miso, sclk, cs);
    end

    initial begin
        $dumpfile("./runner_out.vcd"); // Файл для сохранения результатов
        $dumpvars(0, runner_tb);       // Сохраняем переменные для анализа
    end

endmodule
