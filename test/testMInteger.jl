module testMInteger

using
    PhysicalFields

export run

function run()
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
    return nothing
end

end  # module testMInteger
