// See README.md for license details.

package dependence

import chisel3._
import chisel3.util._
import chiseltest._
import org.scalatest.freespec.AnyFreeSpec
import chisel3.experimental.BundleLiterals._

// class VecElemDict[T <: Data](gen: T) extends Bundle {
//   val count = Vec
// }

class VecElemCounter(n: Int, width: Int) extends Module {
  val io = IO(new Bundle {
    val in = Input(Vec(n, UInt(width.W)))
    val validInputs = Input(UInt(log2Ceil(n+1).W))
    //val out = Output(Vec(1 << width, UInt(log2Ceil(n+1).W)))
    val out = Output(Vec(n, UInt(log2Ceil(n+1).W)))
  })
  val table: Seq[Seq[Bool]] = io.in.map { case elem =>
    io.in.map { case otherElem =>
      elem === otherElem
    }
  }
  for (i <- 0 until n) {
    for (j <- 0 until n) {
      printf("Table %d %d: %d\n", i.U, j.U, table(i)(j))
    }
  }
  val counts: Seq[UInt] = table.map { row =>
    row.map(_.asUInt).reduce(_ +& _)
  }
  for (i <- 0 until n) {
      printf("Count %d %d\n", i.U, counts(i))
  }
  io.out := counts

  //val compTable: Seq[Seq[Bool]] = (0 until n).map { case col =>
  //  Seq.fill(n)(col).zip(io.in).map { case (col, elem) =>
  //    col.U === elem
  //  }
  //}
  /*
    Seq.fill(n)(io.in).map { case (inVec) =>
    inVec
  }
  val potentialSymbols = (0 until (1 << width))
  val compTable: Seq[Seq[Bool]] = io.in.map { symbol =>
    Seq.fill(potentialSymbols.length)(symbol).zip(potentialSymbols).map { case (symbol, idx) =>
      symbol === idx.U
    }
  }
  io.out := compTable.foldLeft(0.U) { (acc, comparisons) =>
    acc + comparisons.map(_.asUInt).reduce(_ + _)
  }
   */
}

class VecElemCounterSpec extends AnyFreeSpec with ChiselScalatestTester {
  "works" in {
    test(new VecElemCounter(4, 8)) { c =>
      c.io.in(0).poke(1.U)
      c.io.in(1).poke(1.U)
      c.io.in(2).poke(2.U)
      c.io.in(3).poke(3.U)
      c.clock.step()
      println(c.io.out.peek())
    }
  }
}

trait HasResetValue[T] {
  def resetValue(typeGen: T): T
}

object HasResetValueInstances {
  implicit val uintResetValueInstance = new HasResetValue[UInt] {
    override def resetValue(typeGen: UInt): UInt = 0.U
  }
  implicit val exampleBundleResetValueInstance = new HasResetValue[ExampleBundle] {
    // showing off how we can use the type generator instance itself to figure out the reset value
    // in this contrived example, we want to set the reset value of 'a' to the width of 'a' (contrived, but you get the point)
    override def resetValue(typeGen: ExampleBundle): ExampleBundle = typeGen.Lit(_.a -> typeGen.a.getWidth.U, _.b -> false.B)
  }
}

class ExampleBundle(width: Int) extends Bundle {
  val a = UInt(width.W)
  val b = Bool()
}

class ChiselDict[K <: Data : HasResetValue](keyGen: K) extends Module {
  val io = IO(Output(keyGen))
  val keyReg = RegInit(keyGen, implicitly[HasResetValue[K]].resetValue(keyGen))
  io := keyReg
}

class ChiselDictSpec extends AnyFreeSpec with ChiselScalatestTester {
  import HasResetValueInstances._
  "typeclass should work for arbitrary key types" in {
    test(new ChiselDict(UInt(32.W))) { c =>
      c.clock.step(10)
    }
    test(new ChiselDict(new ExampleBundle(10))) { c =>
      c.clock.step(10)
      c.io.a.expect(10)
    }
  }
}

/**
  * This is a trivial example of how to run this Specification
  * From within sbt use:
  * {{{
  * testOnly gcd.GcdDecoupledTester
  * }}}
  * From a terminal shell use:
  * {{{
  * sbt 'testOnly gcd.GcdDecoupledTester'
  * }}}
  */
class DependenceSpec extends AnyFreeSpec with ChiselScalatestTester {

  class X extends Module {
    val io = IO(new Bundle {
      val a = Input(UInt(32.W))
    })
  }

  "Gcd should calculate proper greatest common denominator" in {
    test(new X()){ c =>
      fork {
        c.io.a.poke(1.U)
        c.clock.step(1)
      }.fork.withRegion(Monitor) {
        println(c.io.a.peek())
        // c.io.a.poke(2.U) // not allowed in monitor thread
        c.clock.step(1)
      }.joinAndStep(c.clock)
    }
  }
}
