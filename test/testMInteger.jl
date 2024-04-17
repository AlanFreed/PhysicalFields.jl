module testMInteger

using
    ..PhysicalFields

export run

function run(at_dir::String)
    println("This program tests mutable integers.")
    i = MInteger(-2)
    j = MInteger(3)
    println("Given that")
    println("    i  = ", toString(get(i)))
    println("    j  = ", toString(j))
    println("the following logical operators return")
    println("    i == j is ", toString(i==j))
    println("    i ≠ j  is ", toString(i≠j))
    println("    i < j  is ", toString(i<j))
    println("    i ≤ j  is ", toString(i≤j))
    println("    i > j  is ", toString(i>j))
    println("    i ≥ j  is ", toString(i≥j))
    println("while the arithmatic operators return")
    println("    +i     = ", toString(+i))
    println("    -i     = ", toString(-i))
    println("    i + j  = ", toString(i+j))
    println("    i - j  = ", toString(i-j))
    println("    2j     = ", toString(2j))
    println("    i * j  = ", toString(i*j))
    println("    j ÷ i  = ", toString(j÷i))
    println("    j % i  = ", toString(j%i))
    println("    i ^ j  = ", toString(i^j))
    println("Reassigning j to be -3 gives")
    set!(j, -get(j))
    println("    j      = ", toString(j))
    println("The functions pertaining to mutable integers include:")
    println("    copy(j)     = ", toString(copy(j)))
    println("    deepcopy(j) = ", toString(deepcopy(j)))
    println("    abs(i)      = ", toString(abs(i)))
    println("    sign(i)     = ", toString(sign(i)))
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
    ri = fromFile(Int64, json_stream)
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
    println("Now we test writing vectors of integers to string.")
    println("First we test writing a short vector of false values:")
    v1 = Vector{Int64}(undef, 7)
    for i in 1:7
        v1[i] = 2^i
    end
    println(toString(v1))
    println("then we test writing a long vector of integer values:")
    v2 = Vector{Int64}(undef, 15)
    for i in 1:15
        v2[i] = 2^i
    end
    println(toString(v2))
    println()
    println("Finally, we test writing matrices of integers to string.")
    m1 = Matrix{Int64}(undef, 5, 5)
    for i in 1:5
        for j in 1:5
            if (i+j)%2 == 0
                m1[i,j] = j^(i÷2)
            else
                m1[i,j] = i^(j÷2)
            end
        end
    end
    println("For a 5x5 matrix:")
    println(toString(m1))
    m2 = Matrix{Int64}(undef, 5, 15)
    for i in 1:5
        for j in 1:15
            if (i+j)%2 == 0
                m2[i,j] = j^(i÷2)
            else
                m2[i,j] = i^(j÷2)
            end
        end
    end
    println("For a 5x15 matrix:")
    println(toString(m2))
    m3 = Matrix{Int64}(undef, 15, 5)
    for i in 1:15
        for j in 1:5
            if (i+j)%2 == 0
                m3[i,j] = j^(i÷2)
            else
                m3[i,j] = i^(j÷2)
            end
        end
    end
    println("For a 15x5 matrix:")
    println(toString(m3))
    m4 = Matrix{Int64}(undef, 15, 15)
    for i in 1:15
        for j in 1:15
            if (i+j)%2 == 0
                m4[i,j] = j^(i÷2)
            else
                m4[i,j] = i^(j÷2)
            end
        end
    end
    println("And finally, for a 15x15 matrix:")
    println(toString(m4))

    println()
    println("Our last test is of writing and reading a vector of integers to/from a file.")
    for i in 1:length(v2)
        if i%2 == 0
            v2[i] = 2^i
        else
            v2[i] = 3^i
        end
    end
    json_stream = openJSONWriter(my_dir_path, "testIntegerVector.json")
    toFile(v2, json_stream)
    close(json_stream)
    json_stream = openJSONReader(my_dir_path, "testIntegerVector.json")
    v3 = fromFile(Vector{Int64}, json_stream)
    close(json_stream)
    are_equal = true
    for i in 1:length(v2)
        if are_equal && v2[i] ≠ v3[i]
            are_equal = false
        end
    end
    if are_equal
        println("The read vector equals the written vector.")
    else
        println("ERROR: the read vector does not equal the written vector.")
    end

    println()
    println("If these answers make sense, then these function tests pass.")
    return nothing
end

end  # module testMInteger
