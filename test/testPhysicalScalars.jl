module testPhysicalScalars

using
    PhysicalFields

function run()
    format = 'F'
    precision = 5
    aligned = false
    tC = newPhysicalScalar(CENTIGRADE)
    set!(tC, 37.0)
    tK = toSI(tC)
    s1 = "Body temperature = "
    println(s1, toString(tC; format, precision, aligned), " = ", toString(tK; format, precision, aligned))
    x  = newPhysicalScalar(CGS_ACCELERATION)
    set!(x, -π)
    aligned = true
    s1 = "This scalar should print as: -3.1416E+00 cm/s²\n"
    s2 = "it actually printed as:      "
    s3 = "\nand whose absolute value is: "
    format = 'E'
    println(s1, s2, toString(x; format, precision, aligned), s3, toString(abs(x); format, precision, aligned))
    σ  = newPhysicalScalar(PASCAL)
    set!(σ, 1.234)
    y  = MReal(0.001234)
    dϵ = PhysicalScalar(y, PhysicalFields.SI_STRAIN_RATE)
    s1 = string("stress           σ = ", toString(σ; format, precision, aligned))
    s2 = string("strain rate     dϵ = ", toString(dϵ; format, precision, aligned))
    s3 = string("stress power  σ dϵ = ", toString(σ*dϵ; format, precision, aligned))
    println(s1, "\n", s2, "\n", s3)
    println("Test type conversion to CGS units:")
    s4 = string("stress           σ = ", toString(toCGS(σ); format, precision, aligned))
    s5 = string("strain rate     dϵ = ", toString(toCGS(dϵ); format, precision, aligned))
    s6 = string("stress power  σ dϵ = ", toString(toCGS(σ*dϵ); format, precision, aligned))
    println(s4, "\n", s5, "\n", s6)
    println("and then back again to SI units:")
    s7 = string("stress           σ = ", toString(toSI(toCGS(σ)); format, precision, aligned))
    s8 = string("strain rate     dϵ = ", toString(toSI(toCGS(dϵ)); format, precision, aligned))
    s9 = string("stress power  σ dϵ = ", toString(toSI(toCGS(σ*dϵ)); format, precision, aligned))
    println(s7, "\n", s8, "\n", s9)
    ρ  = newPhysicalScalar(CGS(-3, 1, 0, 0))
    set!(ρ, 1.025)
    s10 = string("Density of salt water is: ", toString(ρ; format, precision, aligned))
    oneOnρ = 1 / ρ
    s11 = string("   therefore 1/ρ is:      ", toString(oneOnρ; format, precision, aligned))
    println(s10, "\n", s11)
    s12 = string("or equivalently, it is:   ", toString(toSI(ρ); format, precision, aligned))
    s13 = string("   therefore 1/ρ is:      ", toString(toSI(oneOnρ); format, precision, aligned))
    println(s12, "\n", s13)
    println("Testing scalar arithmetic:")
    a = newPhysicalScalar(CENTIMETER)
    set!(a, 4.0)
    b = newPhysicalScalar(CENTIMETER)
    set!(b, -2.0)
    println("     a = ", toString(a; format, precision, aligned))
    println("     b = ", toString(b; format, precision, aligned))
    println("    -b = ", toString(-b; format, precision, aligned))
    println(" a + b = ", toString(a+b; format, precision, aligned))
    println(" a - b = ", toString(a-b; format, precision, aligned))
    println(" a * b = ", toString(a*b; format, precision, aligned))
    println(" a / b = ", toString(a/b; format, precision, aligned))
    println()
    println("If these answers make sense, then this test passes.")
    return nothing
end

end  # module testPhysicalScalars
