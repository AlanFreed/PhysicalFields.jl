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
    println("If these answers make sense, then these function tests pass.")
    return nothing
end

end  # module testMBoolean
