module testPhysicalScalars

using
    ..PhysicalFields

function run()
    tK = PhysicalScalar(KELVIN)
    set!(tK, 37.0+273.0)
    println("Body temperature = ", toString(tK))
    x  = PhysicalScalar(CGS_ACCELERATION)
    set!(x, -π)
    aligned = true
    s1 = "This scalar should print as: -3.14159E+00 cm/s²\n"
    s2 = "it actually printed as:      "
    s3 = "\nand whose absolute value is: "
    format = 'E'
    println(s1, s2, toString(x), s3, toString(abs(x)))
    σ  = PhysicalScalar(PASCAL)
    set!(σ, 1.234)
    y  = MReal(0.001234)
    dϵ = PhysicalScalar(y, PhysicalFields.STRAIN_RATE)
    s1 = string("stress           σ = ", toString(σ))
    s2 = string("strain rate     dϵ = ", toString(dϵ))
    s3 = string("stress power  σ dϵ = ", toString(σ*dϵ))
    println(s1, "\n", s2, "\n", s3)
    println("Test type conversion to CGS units:")
    s4 = string("stress           σ = ", toString(toCGS(σ)))
    s5 = string("strain rate     dϵ = ", toString(toCGS(dϵ)))
    s6 = string("stress power  σ dϵ = ", toString(toCGS(σ*dϵ)))
    println(s4, "\n", s5, "\n", s6)
    println("and then back again to SI units:")
    s7 = string("stress           σ = ", toString(toSI(toCGS(σ))))
    s8 = string("strain rate     dϵ = ", toString(toSI(toCGS(dϵ))))
    s9 = string("stress power  σ dϵ = ", toString(toSI(toCGS(σ*dϵ))))
    println(s7, "\n", s8, "\n", s9)
    ρ  = PhysicalScalar(PhysicalUnits("CGS", -3, 1, 0, 0, 0, 0, 0))
    set!(ρ, 1.025)
    s10 = string("Density of salt water is: ", toString(ρ))
    oneOnρ = 1 / ρ
    s11 = string("   therefore 1/ρ is:      ", toString(oneOnρ))
    println(s10, "\n", s11)
    s12 = string("or equivalently, it is:   ", toString(toSI(ρ)))
    s13 = string("   therefore 1/ρ is:      ", toString(toSI(oneOnρ)))
    println(s12, "\n", s13)
    println("Testing scalar arithmetic:")
    a = PhysicalScalar(CENTIMETER)
    set!(a, 4.0)
    b = PhysicalScalar(CENTIMETER)
    set!(b, -2.0)
    println("     a = ", toString(a))
    println("     b = ", toString(b))
    println("    -b = ", toString(-b))
    println(" a + b = ", toString(a+b))
    println(" a - b = ", toString(a-b))
    println(" a * b = ", toString(a*b))
    println(" a / b = ", toString(a/b))
    println()
    println("If these answers make sense, then this test passes.")
    return nothing
end

end  # module testPhysicalScalars
