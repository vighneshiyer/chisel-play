
package memory


import chisel3._


class memory() extends Module {

    val io = IO(new Bundle {

        val rdAddr = Input(UInt(10.W))

        val rdData = Output(UInt(8.W))

        val wrAddr = Input(UInt(10.W))

        val wrData = Input(UInt(8.W))

        val wrEna = Input(Bool())

    })

    val mem = SyncReadMem(1024 , UInt (8.W))

    io.rdData := mem.read(io.rdAddr)

    when(io.wrEna) {

        mem.write(io.wrAddr , io.wrData)

    }

    io.rdData := 0.U

}

