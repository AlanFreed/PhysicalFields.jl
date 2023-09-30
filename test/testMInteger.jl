module testMInteger

using
    ..PhysicalFields

export run

function run(at_dir::String)
    println("This program tests mutable integers.")
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
    wi = 123
    wj = 456
    wk = 654
    s = "Now we test writing/reading mutable integers to/from a file."
    my_dir_path = string(at_dir, "test/files/")
    json_stream = openJSONWriter(my_dir_path, "testMInteger.json")
    toFile(s, json_stream)
    toFile(wi, json_stream)
    mi = MInteger(wj)
    toFile(mi, json_stream)
    close(json_stream)
    json_stream = openJSONReader(my_dir_path, "testMInteger.json")
    println(fromFile(String, json_stream))
    println()
    ri = fromFile(Integer, json_stream)
    print("The instance of type Integer should read as  $wi", ". ")
    println("It reads as: ", toString(ri), ".")
    rj = fromFile(MInteger, json_stream)
    print("The instance of type MInteger should read as $wj", ". ")
    println("It reads as: ", toString(wj), ".")
    close(json_stream)
    println()
    println("To ensure the MInteger read in is in fact mutable,")
    print("what was ", toString(rj), " should now read as $wk")
    set!(rj, wk)
    println(". It reads as: ", toString(rj), ".")
    println()
    println("If these answers make sense, then this test passes.")
    return nothing
end

end  # module testMInteger
