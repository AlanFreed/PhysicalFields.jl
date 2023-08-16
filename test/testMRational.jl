module testMRational

using
    ..PhysicalFields

export
    run

function run(at_dir::String)
    println("This function tests mutable rationals.")
    x = MRational(-1//3)
    y = MRational(2//7)
    aligned = true  # strings align to account for the minus sign
    println("Given that")
    println("    x  = ", toString(get(x)))
    println("    y  = ", toString(y; aligned))
    println("the following logical operators return")
    println("    x == y is ", toString(x==y))
    println("    x ≠ y  is ", toString(x≠y))
    println("    x < y  is ", toString(x<y))
    println("    x ≤ y  is ", toString(x≤y))
    println("    x > y  is ", toString(x>y))
    println("    x ≥ y  is ", toString(x≥y))
    println("while the arithmatic operators return")
    println("    +x     = ", toString(+x; aligned))
    println("    -x     = ", toString(-x; aligned))
    println("    x + y  = ", toString(x+y; aligned))
    println("    x - y  = ", toString(x-y; aligned))
    println("    2y     = ", toString(2y; aligned))
    println("    x * y  = ", toString(x*y; aligned))
    println("    x // y = ", toString(x//y; aligned))
    println("Reassigning y to -2//7 gives")
    set!(y, -get(y))
    println("    y      = ", toString(y; aligned))
    println("The functions pertaining to mutable rationals include:")
    println("    copy(y)        = ", toString(copy(y); aligned))
    println("    deepcopy(y)    = ", toString(deepcopy(y); aligned))
    println("    abs(y)         = ", toString(abs(y); aligned))
    println("    sign(y)        = ", toString(sign(y); aligned))
    println("    numerator(y)   = ", toString(numerator(y); aligned))
    println("    denominator(y) = ", toString(denominator(y); aligned))
    println()
    println("If these answers make sense, then this test passes.")
    println()
    wi = 123 // 321
    wj = 456 // 654
    println("Now we test writing/reading mutable rationals to/from a file.")
    my_dir_path = string(at_dir, "/test/files/")
    json_stream = openJSONWriter(my_dir_path, "testMRational.json")
    toFile(wi, json_stream)
    toFile(MRational(wj), json_stream)
    close(json_stream)
    json_stream = openJSONReader(my_dir_path, "testMRational.json")
    ri = fromFile(Rational, json_stream)
    println("The instance of type Rational  read in is ", toString(ri),
        ". It should read as $wi.")
    rj = fromFile(MRational, json_stream)
    println("The instance of type MRational read in is ", toString(rj),
        ". It should read as ", toString(wj), ".")
    close(json_stream)
    return nothing
end

end  # module testMRational
