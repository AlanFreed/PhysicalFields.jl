module testMBoolean

using
    ..PhysicalFields

export run

function run(at_dir::String)
    println("This program tests mutable booleans.")
    t = MBoolean(true)
    f = MBoolean()
    println("Given that")
    println("    t  is ", toString(get(t)))
    println("    f  is ", toString(f))
    println("it follows that")
    println("    !f     is ", toString(!f))
    println("    t == f is ", toString(t==f))
    println("    t ≠ f  is ", toString(t≠f))
    println("with the copy functions giving")
    println("copy(f)     = ", toString(copy(f)))
    println("deepcopy(t) = ", toString(deepcopy(t)))
    println("Reassigning the mutable boolean in t to be false gives")
    set!(t, false)
    println("    t  is ", toString(t))
    println()
    s = "Now we test writing/reading mutable booleans to/from a file."
    my_dir_path = string(at_dir, "test/files/")
    json_stream = openJSONWriter(my_dir_path, "testMBoolean.json")
    toFile(s, json_stream)
    toFile(true, json_stream)
    toFile(MBoolean(false), json_stream)
    close(json_stream)
    json_stream = openJSONReader(my_dir_path, "testMBoolean.json")
    println(fromFile(String, json_stream))
    println()
    b1 = fromFile(Bool, json_stream)
    println("The instance of type Bool should read as true.      It reads as: ", toString(b1))
    b2 = fromFile(MBoolean, json_stream)
    println("The instance of type MBoolean should read as false. It reads as: ", toString(b2))
    close(json_stream)
    println()
    println("To ensure the MBoolean read in is in fact mutable,")
    set!(b2, true)
    print("what was false should now read as true. It reads as: ")
    println(toString(b2), ".")

    println()
    println("Now we test writing vectors of booleans to string.")
    println("First we test writing a short vector of false values:")
    v1 = Vector{Bool}(undef, 7)
    for i in 1:7
        v1[i] = false
    end
    println(toString(v1))
    println("then we test writing a long vector of true values:")
    v2 = Vector{Bool}(undef, 15)
    for i in 1:15
        v2[i] = true
    end
    println(toString(v2))
    println()
    println("Finally, we test writing matrices of booleans to string.")
    m1 = Matrix{Bool}(undef, 5, 5)
    for i in 1:5
        for j in 1:5
            if (i+j)%2 == 0
                m1[i,j] = true
            else
                m1[i,j] = false
            end
        end
    end
    println("For a 5x5 matrix:")
    println(toString(m1))
    m2 = Matrix{Bool}(undef, 5, 15)
    for i in 1:5
        for j in 1:15
            if (i+j)%2 == 0
                m2[i,j] = true
            else
                m2[i,j] = false
            end
        end
    end
    println("For a 5x15 matrix:")
    println(toString(m2))
    m3 = Matrix{Bool}(undef, 15, 5)
    for i in 1:15
        for j in 1:5
            if (i+j)%2 == 0
                m3[i,j] = true
            else
                m3[i,j] = false
            end
        end
    end
    println("For a 15x5 matrix:")
    println(toString(m3))
    m4 = Matrix{Bool}(undef, 15, 15)
    for i in 1:15
        for j in 1:15
            if (i+j)%2 == 0
                m4[i,j] = true
            else
                m4[i,j] = false
            end
        end
    end
    println("And finally, for a 15x15 matrix:")
    println(toString(m4))

    println()
    println("Our last test is of writing and reading a vector of booleans to/from a file.")
    for i in 1:length(v2)
        if i%2 == 0
            v2[i] = true
        else
            v2[i] = false
        end
    end
    json_stream = openJSONWriter(my_dir_path, "testBoolVector.json")
    toFile(v2, json_stream)
    close(json_stream)
    json_stream = openJSONReader(my_dir_path, "testBoolVector.json")
    v3 = fromFile(Vector{Bool}, json_stream)
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

end  # module testMBoolean
