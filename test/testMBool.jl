module testMBool

using
    PhysicalFields

export run

function run()
    println("This function tests mutable booleans.")
    t = MBool(true)
    f = MBool(false)
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
    println("If these answers make sense, then this test passes.")
    return nothing
end

end  # module testMBool
