

package memory


import chisel3._

import chiseltest._

import org.scalatest.freespec.AnyFreeSpec

import chisel3.experimental.BundleLiterals._


class MEMORYSpec extends AnyFreeSpec with ChiselScalatestTester {

    "Memory should be correct" in {

        test(new memory()) { c =>

            // verify that the output of memory is correct

            c.io.wrAddr.poke(10.U)

            c.io.wrEna(1)

            c.io.wrData.poke(66.U)

            c.clock.step(1)


            c.io.rdAddr.poke(10.U)

            c.clock.step(1)

            c.io.rdData.expect(0.U)  

            

        }

    }

}

