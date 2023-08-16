module testMInteger

using
    ..PhysicalFields

export run

function run(at_dir::String)
    println("This function tests mutable integers.")
    i = MInteger(-2)
    j = MInteger(3)
    aligned = true
    println("Given that")
    println("    i  = ", toString(get(i); aligned))
    println("    j  = ", toString(j; aligned))
    println("the following logical operators return")
    println("    i == j is ", toString(i==j))
    println("    i ≠ j  is ", toString(i≠j))
    println("    i < j  is ", toString(i<j))
    println("    i ≤ j  is ", toString(i≤j))
    println("    i > j  is ", toString(i>j))
    println("    i ≥ j  is ", toString(i≥j))
    println("while the arithmatic operators return")
    println("    +i     = ", toString(+i; aligned))
    println("    -i     = ", toString(-i; aligned))
    println("    i + j  = ", toString(i+j; aligned))
    println("    i - j  = ", toString(i-j; aligned))
    println("    2j     = ", toString(2j; aligned))
    println("    i * j  = ", toString(i*j; aligned))
    println("    j ÷ i  = ", toString(j÷i; aligned))
    println("    j % i  = ", toString(j%i; aligned))
    println("    i ^ j  = ", toString(i^j; aligned))
    println("Reassigning j to be -3 gives")
    set!(j, -get(j))
    println("    j      = ", toString(j; aligned))
    println("The functions pertaining to mutable integers include:")
    println("    copy(j)     = ", toString(copy(j); aligned))
    println("    deepcopy(j) = ", toString(deepcopy(j); aligned))
    println("    abs(i)      = ", toString(abs(i); aligned))
    println("    sign(i)     = ", toString(sign(i); aligned))
    println()
    println("If these answers make sense, then this test passes.")
    println()
    wi = 123
    wj = 456
    s = "Now we test writing/reading mutable integers to/from a file."
    my_dir_path = string(at_dir, "/test/files/")
    json_stream = openJSONWriter(my_dir_path, "testMInteger.json")
    toFile(s, json_stream)
    toFile(wi, json_stream)
    toFile(MInteger(wj), json_stream)
    close(json_stream)
    json_stream = openJSONReader(my_dir_path, "testMInteger.json")
    println(fromFile(String, json_stream))
    ri = fromFile(Integer, json_stream)
    println("The instance of type Integer  read in is ", toString(ri),
        ". It should read as $wi.")
    rj = fromFile(MInteger, json_stream)
    println("The instance of type MInteger read in is ", toString(rj),
        ". It should read as ", toString(wj), ".")
    close(json_stream)
    return nothing
end

end  # module testMInteger
