module testMVector

using
    ..PhysicalFields

export run

function run(at_dir::String)
    println("These program tests mutable column vectors.")
    println()
    println("First we test its three constructors.")
    vi = [1.0, 2.0, 3.0]
    vj = [4.0,-5.0, 6.0]
    vk = [7.0, 8.0,-9.0]
    v₁ = MVector(3)
    v₂ = MVector(vj)
    v₃ = MVector(3, vk)
    println("The vector constructed by giving its length returns zeros")
    println("   v₁ = ", toString(v₁))
    v₁[1] = vi[1]
    v₁[2] = vi[2]
    v₁[3] = vi[3]
    println("that are then reassigned values of")
    println("   v₁ = ", toString(v₁))
    println("The vector constructed from assigned vector [4.0,-5.0, 6.0] returns")
    println("   v₂ = ", toString(v₂))
    println("while the vector of length 3 with values of [7.0, 8.0,-9.0] returns")
    println("   v₃ = ", toString(v₃)) 
    println("The logical functions return")
    println("    v₁ == v₂ is ", toString(v₁==v₂))
    println("    v₁ ≠ v₂  is ", toString(v₁≠v₂))
    println("    v₁ ≈ v₂  is ", toString(v₁≈v₂))
    println("while the arithmatic operators return")
    println("    +v₁     = ", toString(+v₁))
    println("    -v₁     = ", toString(-v₁))
    println("    v₁ + v₂ = ", toString(v₁+v₂))
    println("    v₁ - v₂ = ", toString(v₁-v₂))
    println("    v₁ * v₂ = ", toString(v₁*v₂))
    println("that given x = 3.0")
    x = 3.0
    println("    x * v₁ = ", toString(x*v₁))
    println("    v₁ / x = ", toString(v₁/x))
    println("Vector functions include")
    println("    ||v₁|| = ", toString(norm(v₁)))
    println("        𝕖₁ = ", toString(unitVector(v₁)))
    println("   v₁ × v₂ = ", toString(cross(v₁,v₂)))
    println()
    println("Now we test writing/reading mutable vectors to/from a file.")
    println()
    my_dir_path = string(at_dir, "/test/files/")
    json_stream = openJSONWriter(my_dir_path, "testMVector.json")
    toFile(vi, json_stream)
    toFile(v₂, json_stream)
    close(json_stream)
    json_stream = openJSONReader(my_dir_path, "testMVector.json")
    r₁ = fromFile(Vector{Float64}, json_stream)
    println("An instance of type Vector.")
    println("   It should read as ", toString(vi), ".")
    println("   It reads as:      ", toString(r₁), ".")
    r₂ = fromFile(MVector, json_stream)
    println("An instance of type MVector.")
    println("   It should read as ", toString(v₂), ".")
    println("   It reads as:      ", toString(r₂), ".")
    close(json_stream)
    println()
    println("To verify that a read-in vector is mutable,")
    println("reassign vector  ", toString(r₁))
    println("so that it reads ", toString(r₂))
    for i in 1:3
        r₁[i] = r₂[i]
    end
    println("It now reads as ", toString(r₁))
    println()
    println("If these answers make sense, then this test passes.")
    return nothing
end  # function run

end  # module testMVector