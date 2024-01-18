`timescale 1ns/1ps

module alu(
    input [7:0] a,
    input [7:0] b,
    input op,
    input clk,
    output reg [7:0] out
);
    // state

    always @(posedge clk) begin
        if (op)
            out <= a + b;
        else
            out <= a - b;
        if (a || b && (c && d)) begin

        end
    end

    cover(a);
    cover(b);
    cover(c && d);
    cover(a || b);
    cover(c);
    cover(d);

    //cover(op); // this refers to line 13 of the original alu.v file (line 8 of alu.scala)
/*
    reg [7:0] a_old;
    genvar i;
    always @(posedge clk) begin
        // Line/branch coverage
        cover(op);
        cover(!op);

        // Toggle coverage
        a_old <= a;
    end
    generate for(i = 0; i < 8; i = i + 1) begin
        always @(posedge clk) begin
            cover(!a_old[i] && a[i]); // toggle 0->1
            cover(a_old[i] && !a[i]); // toggle 1->0
        end
    end
    endgenerate
    */
/*
    val x = Mux(sum > 15, 15, sum)

    val x = when (sum > 15) {
        15
    }.otherwise {
        sum
    }

    always @(*) begin
        if (sum > 15)
            x = 15;
        else
            x = sum;
    end

    always @(posedge clk) begin
        if (a > 5)
            $display("a: %d, b: %d, out: %d", a, b, out);
    end
*/
    //assign out = a + b;
    //assign out = op ? a + b : a - b; // ternary operator
endmodule
/*
module alu_tb();
    reg [7:0] a_tb, b_tb;
    reg op_tb;
    wire [7:0] out_tb;
    reg clk = 0;
    always #1 clk <= ~clk;
    alu a1 (.clk(clk), .a(a_tb), .b(b_tb), .op(op_tb), .out(out_tb));

    integer i;
    initial begin
        op_tb = 1;
        a_tb = 1;
        b_tb = 2;
        $display("%d", out_tb);
        @(posedge clk);
        $display("%d", out_tb);
        #0.1;
        $display("%d", out_tb);
        for (i = 0; i < 10; i = i + 1) begin
            a_tb = i;
            b_tb = i;
            op_tb = 1;
            #1; // force time advancement
            $display("%d", out_tb);
            assert(out_tb == 2*i) else $display("ERROR: %d != %d", out_tb, 2*i);
        end
        $finish();
    end
endmodule
*/

//`timescale 1ns/1ps
/*
module alu(
    input clk,
    input [7:0] a,
    input [7:0] b,
    input op,
    output [7:0] out
);
    reg [7:0] result;

    always @(posedge clk) begin
        if (op) begin
            result <= a + b;
        end else begin
            result <= a - b + 1;
        end
        //$display("%d", result);
    end
    assign out = result;
endmodule
*/
/*
def thing(a, b, op) -> int:
    if (op) return a + b
    else return a - b

class TestThing:
    def test_it():
        result = thing(1, 2, 1)
        assert result == 3, f""
*/
/*
module alu_tb();
    reg clk = 0;
    always #1 clk <= ~clk;
    reg [7:0] a_tb, b_tb;
    reg op_tb;
    wire [7:0] out_tb;

    alu dut (.clk(clk), .a(a_tb), .b(b_tb), .op(op_tb), .out(out_tb));

    integer i;
    initial begin
        for (i = 0; i < 10; i = i + 1) begin
            a_tb = i; // poke (drive some value into the DUT input)
            b_tb = i;
            op_tb = 1;
            @(posedge clk); #1; // step (advance the clock)
            $display("%d", out_tb); // peek (sense some value from the DUT output)
            assert(out_tb == 2*i) else $display("%d != %d", out_tb, 2*i);
        end
        $finish();
    end

endmodule
*/
/*
module alu_tb();

    reg clk = 0;
    always #1 clk <= ~clk;
    reg [7:0] a_tb, b_tb;
    reg op_tb;
    wire [7:0] out_tb;

    alu dut (.clk(clk), .a(a_tb), .b(b_tb), .op(op_tb), .out(out_tb));

    task test1;
        for (i = 0; i < 10; i = i + 1) begin
            a_tb = i; // poke (drive a value into a DUT input)
            b_tb = i;
            op_tb = 1;
            @(posedge clk); #1; // step (advance the clock)
            $display("%d", out_tb); // peek (sense a value from a DUT output)
            assert(out_tb == 2*i) else $display("%d != %d", out_tb, 2*i);
        end
    endtask

    task test2;
        for (i = 0; i < 10; i = i + 1) begin
            a_tb = i; // poke (drive a value into a DUT input)
            b_tb = i;
            op_tb = 0;
            @(posedge clk); #1; // step (advance the clock)
            $display("%d", out_tb); // peek (sense a value from a DUT output)
            assert(out_tb == 0) else $display("%d != %d", out_tb, 0);
        end
    endtask


    integer i;
    initial begin
        test1();
        rst = 1;
        @(posedge clk); #1;
        rst = 0;
        test2();
        $finish();
    end
endmodule
*/



/*
module alu_tb();
    reg clk = 0;
    always #1 clk <= !clk;
    reg [7:0] a_tb, b_tb;
    reg op_tb;
    wire [7:0] out_tb;

    alu dut (.clk(clk), .a(a_tb), .b(b_tb), .op(op_tb), .out(out_tb));

    integer i;
    initial begin
        for (i = 0; i < 10; i = i+1) begin
            a_tb = i; // poke (drive a value into a DUT input)
            b_tb = i;
            op_tb = 1;
            @(posedge clk); #1; // step (advancing the clock)
            $display("%d", out_tb); // peek (sense a value from a DUT output)
            assert(out_tb == 2*i) else $display("%d != %d", out_tb, 2*i);
        end
        $finish();
    end
endmodule
*/

/*
module alu_tb();
    reg clk = 0;
    always #1 clk <= !clk;
    reg [7:0] a_tb, b_tb;
    reg op_tb;
    wire [7:0] out_tb;

    alu dut (.clk(clk), .a(a_tb), .b(b_tb), .op(op_tb), .out(out_tb));

    integer i;
    initial begin
        for (i = 0; i < 10; i = i + 1) begin
            a_tb = i; // poke (drive a value into a DUT input)
            b_tb = i;
            op_tb = 1;
            @(posedge clk); #1; // step (advance the clock)
            $display("%d", out_tb); // peek (sense a value from a DUT output)
            assert(out_tb == 2*i) else $display("%d != %d", out_tb, 2*i);
        end
        $finish();
    end
endmodule
*/

/*
module alu_tb();
    reg clk = 0;
    always #1 clk <= ~clk;

    reg [7:0] a_tb, b_tb;
    reg op_tb;
    wire [7:0] out_tb;

    alu dut(.clk(clk), .a(a_tb), .b(b_tb), .op(op_tb), .out(out_tb));

    integer i;
    initial begin
        for (i = 0; i < 10; i = i + 1) begin
            a_tb = i; // poke API call
            b_tb = i;
            op_tb = 1;
            @(posedge clk); #1; // step API call
            $display("%d", out_tb); // peek API call
            //assert(out_tb != 2*i) else $display("ERROR: %d", out_tb);
        end
        $finish();
    end

endmodule
*/
