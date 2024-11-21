`timescale 1ns / 1ps

module runner_tb();

// Объявление регистров и проводов для подключения к модулю
reg rstn;                // Сигнал сброса
reg sys_clk;             // Тактовый сигнал
reg t_start;             // Сигнал запуска передачи
reg up;                  // Сигнал для увеличения счетчика
wire [5:0] led;         // Выходные светодиоды
wire cs;                // Сигнал выбора устройства
reg miso;               // Данные на входе (Master In Slave Out)
wire mosi;              // Данные на выходе (Master Out Slave In)
wire sclk;              // Тактовый сигнал SPI

// Экземпляр модуля SPI
runner master (
    .led(led),
    .rstn(rstn),
    .sys_clk(sys_clk),
    .t_start(t_start),
    .up(up),
    .cs(cs),
    .miso(miso),
    .mosi(mosi),
    .sclk(sclk)
);

// Генерация тактового сигнала
initial begin
    sys_clk = 0;
    forever #5 sys_clk = ~sys_clk; // Тактовая частота 100 МГц
end

// Процесс тестирования
initial begin
    // Инициализация сигналов
    rstn = 0; // Активный сброс
    t_start = 1;
    up = 1;
    miso = 0; // Изначально данные на входе равны 0

    // Сброс модуля
    #10;
    rstn = 1; // Снятие сброса
    #10;
    up = 0;
    #10; 
    up = 1;

    // Тест 1: Запуск передачи
    t_start = 0; // Запуск передачи
    #10;
    t_start = 1;

    // Завершение симуляции
    #100;
    $stop; // Останавливаем симуляцию
end

    initial begin
        $dumpfile("./runner_out.vcd");  // Файл для сохранения результатов
        $dumpvars(0, runner_tb);       // Сохраняем переменные для анализа
        #1000 $finish;                 // Завершаем симуляцию через 1000 ns
    end
    // Конец
endmodule


//`timescale 1ns / 1ps

//module runner_tb();

   //Parameters
//  parameter reg_width = 8;
//  
   //Testbench signals
//  reg rstn;
//  reg sys_clk;
//  reg cs;
//  reg mosi;
//  wire [5:0] led;

   //Instantiate the SPI slave module
//  runner_lab #(
//    .reg_width(reg_width)
//  ) uut (
//    .led(led),
//    .rstn(rstn),
//    .sys_clk(sys_clk),
//    .cs(cs),
//    .mosi(mosi),
//    .sclk() // sclk not used in testbench
//  );
//  
//  reg [7:0] _mosi;

   //Clock generation
//  initial begin
//    sys_clk = 0;
//    forever #5 sys_clk = ~sys_clk; // 10ns clock period
//  end

   //Test sequence
//  initial begin
     //Initialize signals
//    rstn = 0;
//    cs = 1;
//    mosi = 0;

     //Reset the module
//    #10;
//    rstn = 1; // Release reset
//    #10;

     //Start SPI transaction
//    cs = 0; // Activate chip select
//    _mosi = 8'b00101010; // Sample data to send

     //Send data bit by bit
//      mosi = _mosi[0]; // Assign the next bit of data
//      #5; // Wait for the clock edge
//      mosi = _mosi[1]; // Assign the next bit of data
//      #5; // Wait for the clock edge
//      mosi = _mosi[2]; // Assign the next bit of data
//      #5; // Wait for the clock edge
//      mosi = _mosi[3]; // Assign the next bit of data
//      #5; // Wait for the clock edge
//      mosi = _mosi[4]; // Assign the next bit of data
//      #5; // Wait for the clock edge
//      mosi = _mosi[5]; // Assign the next bit of data
//      #5; // Wait for the clock edge
//      mosi = _mosi[6]; // Assign the next bit of data
//      #5; // Wait for the clock edge
//      mosi = _mosi[7]; // Assign the next bit of data
//      #5; // Wait for the clock edge

     //Deactivate chip select
//    cs = 1;
//    #10;

     //Check the LED outputs
//    if (led != 6'b101010) // Expected output for mosi_d = 8'b101010
//      $display("Test failed: led = %b, expected led = 101010", led);
//    else
//      $display("Test passed: led = %b", led);

     //Finish simulation
//    #1000;
//    $finish;
//end

//initial begin
//        $dumpfile("./runner_out.vcd");  // Файл для сохранения результатов
//        $dumpvars(0, runner_tb);       // Сохраняем переменные для анализа
//        #1000 $finish;                 // Завершаем симуляцию через 1000 ns
//    end

//endmodule
