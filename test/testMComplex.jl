module testMComplex

using
    ..PhysicalFields

export
    run

function run(at_dir::String)
    println("This function tests mutable complex numbers.")
    x = MComplex(2 + 3im)
    y = MComplex(conj(x))
    format = 'e'
    precision = 4
    aligned = true
    println("Given that")
    println("x = 2 + 3im = ", toString(x; format, precision, aligned))
    println("y = 2 - 3im = ", toString(y; format, precision, aligned))
    println("then the following logical operators return")
    println("    x == y is ", toString(x==y))
    println("    x ≈ y  is ", toString(x≈y))
    println("    x ≠ y  is ", toString(x≠y))
    println("while the arithmatic operators return")
    println("    +x    = ", toString(+x; format, precision, aligned))
    println("    -x    = ", toString(-x; format, precision, aligned))
    println("    x + y = ", toString(x+y; format, precision, aligned))
    println("    x - y = ", toString(x-y; format, precision, aligned))
    println("    x * y = ", toString(x*y; format, precision, aligned))
    println("    x / y = ", toString(x/y; format, precision, aligned))
    println("    x ^ y = ", toString(x^y; format, precision, aligned))
    println("Now we verify the complex functions using  z = -y/x")
    z = MComplex(y / x)
    set!(z, -get(z))
    println("copy(z)     = ", toString(copy(z); format, precision, aligned))
    println("deepcopy(z) = ", toString(deepcopy(z); format, precision, aligned))
    println("abs(z)      = ", toString(abs(z); format, precision, aligned))
    println("abs2(z)     = ", toString(abs2(z); format, precision, aligned))
    println("real(z)     = ", toString(real(z); format, precision, aligned))
    println("imag(z)     = ", toString(imag(z); format, precision, aligned))
    println("conj(z)     = ", toString(conj(z); format, precision, aligned))
    println("angle(z)    = ", toString(angle(z); format, precision, aligned))
    println("the trigonometric functions are:")
    println("sin(z) = ", toString(sin(z); format, precision, aligned))
    println("cos(z) = ", toString(cos(z); format, precision, aligned))
    println("tan(z) = ", toString(tan(z); format, precision, aligned))
    println("where")
    println("asin(sin(z)) = ", toString(asin(sin(z)); format, precision, aligned))
    println("acos(cos(z)) = ", toString(acos(cos(z)); format, precision, aligned))
    println("atan(tan(z)) = ", toString(atan(tan(z)); format, precision, aligned))
    println("the hyperbolic functions are:")
    println("sinh(z) = ", toString(sinh(z); format, precision, aligned))
    println("cosh(z) = ", toString(cosh(z); format, precision, aligned))
    println("tanh(z) = ", toString(tanh(z); format, precision, aligned))
    println("where")
    println("asinh(sinh(z)) = ", toString(asinh(sinh(z)); format, precision, aligned))
    println("acosh(cosh(z)) = ", toString(acosh(cosh(z)); format, precision, aligned))
    println("atanh(tanh(z)) = ", toString(atanh(tanh(z)); format, precision, aligned))
    println("the logarithmic and exponential functions are:")
    println("log(z)   = ", toString(log(z); format, precision, aligned))
    println("log2(z)  = ", toString(log2(z); format, precision, aligned))
    println("log10(z) = ", toString(log10(z); format, precision, aligned))
    println("exp(z)   = ", toString(exp(z); format, precision, aligned))
    println("exp2(z)  = ", toString(exp2(z); format, precision, aligned))
    println("exp10(z) = ", toString(exp10(z); format, precision, aligned))
    println("where")
    println("log(exp(z))     = ", toString(log(exp(z)); format, precision, aligned))
    println("log2(exp2(z))   = ", toString(log2(exp2(z)); format, precision, aligned))
    println("log10(exp10(z)) = ", toString(log10(exp10(z)); format, precision, aligned))
    println("and the square root gives:")
    println("sqrt(z)   = ", toString(sqrt(z); format, precision, aligned))
    println("with")
    println("sqrt(z)^2 = ", toString(sqrt(z)^2; format, precision, aligned))
    println()
    println("If these answers make sense, then this test passes.")
    println()
    wi = 1.23 + 4.56im
    wj = 3.21 - 6.54im
    println("Now we test writing/reading mutable complex to/from a file.")
    my_dir_path = string(at_dir, "/test/files/")
    json_stream = openJSONWriter(my_dir_path, "testMComplex.json")
    toFile(wi, json_stream)
    toFile(MComplex(wj), json_stream)
    close(json_stream)
    json_stream = openJSONReader(my_dir_path, "testMComplex.json")
    ri = fromFile(Complex, json_stream)
    println("The instance of type Complex  read in is ", toString(ri),
        ". It should read as $wi.")
    rj = fromFile(MComplex,json_stream)
    println("The instance of type MComplex read in is ", toString(rj),
        ". It should read as $wj.")
    close(json_stream)
    return nothing
end

end  # module testMComplex
