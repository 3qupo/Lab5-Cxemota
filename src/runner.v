// Отправитель
// cd C:\iverilog\runner                   АНДРЕЙ           
// cd C:\iverilog\runner\Lab5-Cxemota      ЮЛЯ
// iverilog -o ./compiled ./src/runner.v ./src/runner_tb.v ./src/runner_lab.v
// vvp ./compiled 
module runner
(
    output [5:0] led,
    input rstn,
    input sys_clk,
    input t_start,
    input up,
    output cs,
    input miso, 
    output mosi,
    output sclk
);

parameter reg_width = 8;
parameter counter_width = $clog2(reg_width);
parameter reset = 0, idle = 1, load = 2, transact1 = 3, transact2 = 4, unload = 5;

integer tmpcs = 1;
reg [reg_width-1:0] mosi_d;
reg [reg_width-1:0] miso_d;
reg [counter_width:0] count;
reg [3:0] state;

reg [2:0] led_counter;

initial
    begin
        led_counter <= 0;   
        mosi_d <= 0;
        miso_d <= 0;
        state <= 0;
    end

always @(state)
    begin
        case (state)
          reset:
              begin
                miso_d <= 0;
                mosi_d <= 0;
                count <= 0;
                tmpcs <= 1;
              end
          idle:
              begin
                miso_d <= 0;
                mosi_d <= 0;
                count <= 0;
                tmpcs <= 1;
              end
          load:
              begin
                miso_d <= 0;
                mosi_d <= led;
                count <= reg_width;
                tmpcs <= 0;
              end
          transact1:
              begin
                tmpcs <= 0;
                miso_d <= {miso_d[reg_width-2:0], miso};
                mosi_d <= {mosi_d[reg_width-2:0], 1'b0};
                count <= count-1;
              end
          transact2:
              begin
                tmpcs <= 0;
                miso_d <= {miso_d[reg_width-2:0], miso};
                mosi_d <= {mosi_d[reg_width-2:0], 1'b0};
                count <= count-1;
              end
          unload:
              begin
                miso_d <= 0;
                mosi_d <= 0;
                count <= 0;
                tmpcs <= 1;
              end
          default:
              begin
                miso_d <= 0;
                mosi_d <= 0;
                count <= 0;
                tmpcs <= 1;
              end
       endcase
   end


  always @(posedge sys_clk)
  begin
    if (!rstn)
      state = reset;
    else
      case (state)
        reset:
          if (!t_start)
            state = load;
          else
            state = idle;
        idle:
          if (!t_start)
            state = load;
        load:
          if (count != 0)
            state = transact1;
          else
            state = reset;
        transact1:
          if (count != 0)
            state = transact2;
          else
            state = unload;
        transact2:
          if (count != 0)
            state = transact1;
          else
            state = unload;
        unload:
          if (!t_start)
            state = load;
          else
            state = idle;
      endcase
  end

  assign cs = tmpcs;
  assign mosi = ( ~cs ) ? mosi_d[reg_width-1] : 1'bz;
  assign sclk = ( state == transact1 || state == transact2) ? sys_clk : 1'b0;



always @(posedge sys_clk)
begin
    if (!rstn)
    begin
        led_counter <= 0;
    end
    else
    begin
        if (!up)
            begin
                led_counter <= led_counter + 1;
                if (led_counter == 5)
                    begin
                        led_counter <= 0;
                    end
            end
    end
end

genvar i;
generate
  for (i = 0; i < 6; i = i + 1)
  begin
    assign led[i] = (rstn ? led_counter != i : 0);
  end
endgenerate

endmodule
