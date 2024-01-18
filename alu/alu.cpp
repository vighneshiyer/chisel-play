#include <verilated.h>
#include <stdint.h>
#include "Valu.h"
#if VM_TRACE
# include <verilated_vcd_c.h> // Trace file format header
#endif

#define TOP_TYPE Valu

// Current simulation time
vluint64_t main_time = 0;
// Called by $time in Verilog
double sc_time_stamp() {
    return main_time;
}

void step(Valu *top, int cycles) {
    for (int i = 0; i < cycles; ++i) {
        top->clk = !top->clk;
        top->eval();
        top->clk = !top->clk;
        top->eval();
    }
}
/*
Valu* initialize() {
    return new Valu;
}

void end(*Valu v) {
    delete v;
}

void poke(*Valu v, std::string port, uint64_t value) {
    v->"port" = value;
}

uint64_t peek(*Valu v, std::string port) {
    return v->"port"
}
*/

int main(int argc, char **argv, char **env) {
    // Prevent unused variable warnings
    if (false && argc && argv && env) {}
    Verilated::debug(0);

    Verilated::commandArgs(argc, argv);
    Valu* top = new Valu;

    // If verilator was invoked with --trace
#if VM_TRACE
    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    top->trace(tfp, 99);
    tfp->open("dump.vcd");
#endif

    top->clk = 0;
    //top->reset = 0;
    //int *cycle_count = 0;

    step(top, 100);
    for (int i = 0; i < 10; i++) {
        top->a = i;
        top->b = i;
        top->op = 1;
        step(top, 1);
        printf("%d\n", top->out);
    }
    /*
    while (!Verilated::gotFinish()) { // no timeout
        main_time++;
        top->clk = !top->clk;
        if (top->clk == 1)
            *cycle_count++;
        if (*cycle_count > 100)
            break;
        step(top, 10, cycle_count);
        //for (i = 
        //top->a = 

        //printf("%d", top->clk);
        if (!top->clk) { // after negative edge
            if (main_time > 1 && main_time < 10) {
                top->reset = 1;  // Assert reset
            } else {
                top->reset = 0;  // Deassert reset
            }
        }
        top->eval();
    }
    */
    top->final();

#if VM_COVERAGE
    VerilatedCov::write("coverage.dat");
#endif
#if VM_TRACE
    if (tfp) { tfp->close(); }
#endif

    delete top;
    exit(0);
}

