module runner_lab (
    output [5:0] led,
    input rstn,
    input sys_clk,
    input cs,
    input mosi,
    input sclk
);

parameter reg_width = 8;
parameter counter_width = $clog2(reg_width);
parameter reset = 0;
parameter idle = 1;
parameter load = 2;
parameter transact1 = 3;

reg [reg_width - 1:0] mosi_d;
reg [counter_width:0] count;
reg [3:0] state;

initial begin
    mosi_d <= 0;
    state <= reset;
end

always @(posedge sys_clk or negedge rstn) begin
    if (!rstn)
        state <= reset;
    else if (!cs) begin
        if (state == reset)
            state <= load;
        else if (state == load)
            state <= transact1;
    end else
        state <= idle;
end

always @(posedge sclk) begin
    if (!cs && state == transact1) begin
        mosi_d <= {mosi_d[reg_width - 2:0], mosi};
        count <= count - 1;
    end
end

genvar i;
generate
    for (i = 0; i < 6; i = i + 1) begin
        assign led[i] = (rstn ? mosi_d[7 - i] : 1);
    end
endgenerate

endmodule
