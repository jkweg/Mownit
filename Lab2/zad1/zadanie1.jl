val16 = Float16(1/3)
val32 = Float32(1/3)
val64 = Float64(1/3)

val16_to_64 = Float64(val16)

println("Float16:      ", bitstring(val16))
println("Float32:       ", bitstring(val32))
println("Float64:       ", bitstring(val64))
println("Float16->Float64:   ", bitstring(val16_to_64))