`timescale 1ns/1ps

module runner_tb;
    // Сигналы для тестирования
    reg clk;
    reg rst_n;
    reg btn_inc;
    reg btn_dec;
    wire sclk;
    wire mosi;
    wire miso;
    wire ss_n;
    wire [5:0] master_leds;
    wire [5:0] slave_leds;

    // Создание экземпляров ведущего и ведомого модулей
    runner master (
        .clk(clk),
        .rst_n(rst_n),
        .btn_inc(btn_inc),
        .btn_dec(btn_dec),
        .leds(master_leds),
        .sclk(sclk),
        .mosi(mosi),
        .miso(miso),
        .ss_n(ss_n)
    );

    runner_lab slave (
        .clk(clk),
        .rst_n(rst_n),
        .sclk(sclk),
        .mosi(mosi),
        .miso(miso),
        .ss_n(ss_n),
        .leds(slave_leds)
    );

    // Генерация тактового сигнала
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    // Тестовые воздействия
    initial begin
        // Инициализация
        rst_n = 0;
        btn_inc = 0;
        btn_dec = 0;
        #20;
        
        // Снятие сброса
        rst_n = 1;
        #20;

        // Тест увеличения количества светодиодов
        repeat (3) begin
            btn_inc = 1;
            #20;
            btn_inc = 0;
            #100;  // Ожидание завершения передачи
        end

        // Тест уменьшения количества светодиодов
        repeat (2) begin
            btn_dec = 1;
            #20;
            btn_dec = 0;
            #100;  // Ожидание завершения передачи
        end

        // Завершение симуляции
        #100;
        $finish;
    end

    // Мониторинг изменений
    initial begin
        $monitor("Время=%0t rst_n=%b btn_inc=%b btn_dec=%b master_leds=%b slave_leds=%b",
                 $time, rst_n, btn_inc, btn_dec, master_leds, slave_leds);
    end

    initial begin
        $dumpfile("./runner_out.vcd"); // Файл для сохранения результатов
        $dumpvars(0, runner_tb); // Сохраняем переменные для анализа
    end

endmodule