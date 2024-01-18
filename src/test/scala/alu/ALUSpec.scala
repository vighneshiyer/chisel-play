// See README.md for license details.

package alu

import chisel3._
import chiseltest._
import org.scalatest.freespec.AnyFreeSpec
import chisel3.experimental.BundleLiterals._

class ALUSpec extends AnyFreeSpec with ChiselScalatestTester {

  "alu" in {
    test(new ALU()).withAnnotations(Seq(VerilatorBackendAnnotation)) { dut =>
      dut.clock.step(10)
      dut.io.a.poke(5)
      dut.io.b.poke(6)
      //dut.clock.step(1)
      println(dut.io.out.peek())
      dut.io.out.expect(12) // peek + assert
    }
  }
}
