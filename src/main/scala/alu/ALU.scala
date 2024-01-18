// See README.md for license details.

package alu

import chisel3._

class ALU extends Module {
  val io = IO(new Bundle {
    val a = Input(UInt(16.W))
    val b = Input(UInt(16.W))
    val op = Input(Bool())
    val out = Output(UInt(16.W))
  })
  io.out := Mux(io.op, io.a + io.b, io.a - io.b)
  chisel3.experimental.verification.cover(io.op)
// implementation
}
