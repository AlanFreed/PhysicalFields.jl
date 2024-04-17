module testMArray

using
    ..PhysicalFields

export run

function run(at_dir::String)
    println("These program tests mutable 3D arrays.")
    println()
    println("First we test its three constructors.")
    ai = Array{Float64,3}(undef, 2, 2, 2)
    ai[1,1,1] = 1.0
    ai[1,1,2] = 2.0
    ai[1,2,1] = 3.0
    ai[1,2,2] = 4.0
    ai[2,1,1] = 5.0
    ai[2,1,2] = 6.0
    ai[2,2,1] = 7.0
    ai[2,2,2] = 8.0
    vi = vec(ai)
    aj = Array{Float64,3}(undef, 2, 2, 2)
    aj[1,1,1] = -1.0
    aj[1,1,2] = -2.0
    aj[1,2,1] = -3.0
    aj[1,2,2] = -4.0
    aj[2,1,1] = -5.0
    aj[2,1,2] = -6.0
    aj[2,2,1] = -7.0
    aj[2,2,2] = -8.0
    vj = vec(aj)
    ak = Array{Float64,3}(undef, 2, 2, 2)
    ak[1,1,1] = 8.0
    ak[1,1,2] = -7.0
    ak[1,2,1] = 6.0
    ak[1,2,2] = -5.0
    ak[2,1,1] = 4.0
    ak[2,1,2] = -3.0
    ak[2,2,1] = 2.0
    ak[2,2,2] = -1.0
    vk = vec(ak)
    a₁ = MArray(2, 2, 2)
    a₂ = MArray(aj)
    a₃ = MArray(2, 2, 2, vk)
    println("The array constructed from its dimensions returns zeros:")
    println("   matrix on page 1, i.e., a₁[1] = ")
    println(toString(a₁[1]))
    println("   matrix on page 2, i.e., a₁[2] = ")
    println(toString(a₁[2]))
    for i in 1:2
        for j in 1:2
            for k in 1:2
                a₁[i,j,k] = ai[i,j,k]
            end
        end
    end
    println("that are then reassigned values of:")
    println("   matrix on page 1, i.e., a₁[1] = ")
    println(toString(a₁[1]))
    println("   matrix on page 2, i.e., a₁[2] = ")
    println(toString(a₁[2]))
    println()
    println("A 2×2×2 array constructed from ", toString(vj), " returns")
    println("   matrix on page 1, i.e., a₂[1] = ")
    println(toString(a₂[1]))
    println("   matrix on page 2, i.e., a₂[2] = ")
    println(toString(a₂[2]))
    println()
    println("while a 2×2×2 array constructed from ", toString(vk), " returns")
    println("   matrix on page 1, i.e., a₃[1] = ")
    println(toString(a₃[1]))
    println("   matrix on page 2, i.e., a₃[2] = ")
    println(toString(a₃[2]))
    println()
    println("Now we test writing/reading mutable arrays to/from a file.")
    println()
    my_dir_path = string(at_dir, "/test/files/")
    json_stream = openJSONWriter(my_dir_path, "testMArray.json")
    toFile(a₁, json_stream)
    toFile(a₂, json_stream)
    close(json_stream)
    json_stream = openJSONReader(my_dir_path, "testMArray.json")
    r₁ = fromFile(MArray, json_stream)
    println("An instance of type MArray.")
    println("   It should read as: ")
    println("   for page 1:")
    println(toString(a₁[1]))
    println("   and for page 2:")
    println(toString(a₁[2]))
    println("   It reads as:")
    println("   for page 1:")
    println(toString(r₁[1]))
    println("   and for page 2:")
    println(toString(r₁[2]))
    r₂ = fromFile(MArray, json_stream)
    println("An instance of type MArray.")
    println("   It should read as:")
    println("   for page 1:")
    println(toString(a₂[1]))
    println("   and for page 2:")
    println(toString(a₂[2]))
    println("   It reads as:")
    println("   for page 1:")
    println(toString(r₂[1]))
    println("   and for page 2:")
    println(toString(r₂[2]))
    close(json_stream)
    println()
    println("To verify that a read-in array is mutable,")
    println("reassign the matrix on page 2 of the above array so that ")
    println(toString(r₁[2]))
    println("becomes")
    println(toString(r₂[2]))
    for i in 1:2
        for j in 1:2
            r₁[2,i,j] = r₂[2,i,j]
        end
    end
    println("It now reads as:")
    println(toString(r₁[2]))
    println()
    println("If these answers make sense, then this test passes.")
    return nothing
end  # run

end  # testMArray