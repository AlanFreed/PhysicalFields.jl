module testMBool

using
    ..PhysicalFields

export run

function run(at_dir::String)
    println("This function tests mutable booleans.")
    t = MBool(true)
    f = MBool()
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
    println("Reassigning the boolean in t to be false gives")
    set!(t, false)
    println("    t  is ", toString(t))
    println()
    println("If these answers make sense, then these function tests pass.")
    println()
    s = "Now we test writing/reading mutable booleans to/from a file."
    my_dir_path = string(at_dir, "/test/files/")
    json_stream = openJSONWriter(my_dir_path, "testMBool.json")
    toFile(s, json_stream)
    toFile(true, json_stream)
    toFile(MBool(true), json_stream)
    close(json_stream)
    json_stream = openJSONReader(my_dir_path, "testMBool.json")
    println(fromFile(String, json_stream))
    b1 = fromFile(Bool, json_stream)
    println("The instance of type Bool  read in is ", toString(b1),
        ". It should read as true.")
    b2 = fromFile(MBool, json_stream)
    println("The instance of type MBool read in is ", toString(b2),
        ". It should read as true.")
    close(json_stream)
    return nothing
end

end  # module testMBool
