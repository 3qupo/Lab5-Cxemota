// Модуль ведомого (Slave)
module runner_lab (
    input wire clk,          // Системный тактовый сигнал
    input wire rst_n,        // Сброс активным нулем
    input wire sclk,         // Тактовый сигнал SPI от ведущего
    input wire mosi,         // Вход данных от ведущего
    output reg miso,         // Выход данных к ведущему
    input wire ss_n,         // Выбор ведомого (активный ноль)
    output reg [5:0] leds    // Выходы на 6 светодиодов
);

    reg [5:0] rx_shift_reg;  // Сдвиговый регистр для приема данных
    reg [2:0] bit_count;     // Счетчик принятых бит

    // Прием данных
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rx_shift_reg <= 6'b000000;
            bit_count <= 3'b000;
            leds <= 6'b000000;
        end else if (!ss_n) begin  // Когда выбрано ведомое устройство
            if (sclk) begin  // Считываем по переднему фронту
                rx_shift_reg <= {rx_shift_reg[4:0], mosi};
                bit_count <= bit_count + 1'b1;
                
                if (bit_count == 3'b101) begin  // После приема 6 бит
                    leds <= {rx_shift_reg[4:0], mosi};
                    bit_count <= 3'b000;
                end
            end
        end else begin
            bit_count <= 3'b000;
        end
    end

    // Выход MISO (не используется в данной реализации)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            miso <= 1'b0;
        else
            miso <= 1'b0;
    end
endmodule