module testPersistence

using
    ..PhysicalFields

export
    testBuiltIns,
    testToString
    
function testBuiltIns()
    println("Test writing-to and reading-from file for built-in types.")
    println()
    my_dir_path = string(pwd(), "/test/files/")
    if !isdir(my_dir_path)
        mkdir(string(pwd(), "/test/files/"))
    end
    
    # Testing values.

    json_stream = openJSONWriter(my_dir_path, "testBuiltInTypes.json")
    
    w1  = "This is a test file."
    w2  = Dict{String, Int}("a" => 1, "b" => 2, "c" => 3)
    w3  = Bool(true)
    w4  = Int8(-1)
    w5  = Int16(-2)
    w6  = Int32(-3)
    w7  = Int64(-4)
    w8  = Int128(-5)
    w9  = UInt8(1)
    w10 = UInt16(2)
    w11 = UInt32(3)
    w12 = UInt64(4)
    w13 = UInt128(5)
    w14 = Float16(1.0/3.0)
    w15 = Float32(2.0/3.0)
    w16 = Float64(4.0/3.0)
    
    toFile(w1,  json_stream) # String
    toFile(w2,  json_stream) # Dict
    toFile(w3,  json_stream) # Bool
    toFile(w4,  json_stream) # Int8
    toFile(w5,  json_stream) # Int16
    toFile(w6,  json_stream) # Int32
    toFile(w7,  json_stream) # Int64
    toFile(w8,  json_stream) # Int128
    toFile(w9,  json_stream) # UInt8
    toFile(w10, json_stream) # UInt16
    toFile(w11, json_stream) # UInt32
    toFile(w12, json_stream) # UInt64
    toFile(w13, json_stream) # UInt128
    toFile(w14, json_stream) # Float16
    toFile(w15, json_stream) # Float32
    toFile(w16, json_stream) # Float64
    
    close(json_stream)
    
    json_stream = openJSONReader(my_dir_path, "testBuiltInTypes.json")
    
    r1  = fromFile(String,  json_stream) # String
    r2  = fromFile(Dict,    json_stream) # Dict
    r3  = fromFile(Bool,    json_stream) # Bool
    r4  = fromFile(Int8,    json_stream) # Int8
    r5  = fromFile(Int16,   json_stream) # Int16
    r6  = fromFile(Int32,   json_stream) # Int32
    r7  = fromFile(Int64,   json_stream) # Int64
    r8  = fromFile(Int128,  json_stream) # Int128
    r9  = fromFile(UInt8,   json_stream) # UInt8
    r10 = fromFile(UInt16,  json_stream) # UInt16
    r11 = fromFile(UInt32,  json_stream) # UInt32
    r12 = fromFile(UInt64,  json_stream) # UInt64
    r13 = fromFile(UInt128, json_stream) # UInt128
    r14 = fromFile(Float16, json_stream) # Float16
    r15 = fromFile(Float32, json_stream) # Float32
    r16 = fromFile(Float64, json_stream) # Float64
    
    close(json_stream)
    
    if r1 == w1 && typeof(r1) == typeof(w1)
        println("Strings passed.")
    else
        println("Strings failed.")
    end
    
    if r2 == w2
        println("Dict passed.")
    else
        println("Dict failed.")
    end
    
    if r3 == w3 && typeof(r3) == typeof(w3)
        println("Bool passed.")
    else
        println("Bool failed.")
    end
    
    if r4 == w4 && typeof(r4) == typeof(w4)
        println("Int8 passed.")
    else
        println("Int8 failed.")
    end
    
    if r5 == w5 && typeof(r5) == typeof(w5)
        println("Int16 passed.")
    else
        println("Int16 failed.")
    end
    
    if r6 == w6 && typeof(r6) == typeof(w6)
        println("Int32 passed.")
    else
        println("Int32 failed.")
    end
    
    if r7 == w7 && typeof(r7) == typeof(w7)
        println("Int64 passed.")
    else
        println("Int64 failed.")
    end
    
    if r7 == w7 && typeof(r7) == typeof(w7)
        println("Int128 passed.")
    else
        println("Int128 failed.")
    end
    
    if r9 == w9 && typeof(r9) == typeof(w9)
        println("UInt8 passed.")
    else
        println("UInt8 failed.")
    end
    
    if r10 == w10 && typeof(r10) == typeof(w10)
        println("UInt16 passed.")
    else
        println("UInt16 failed.")
    end
    
    if r11 == w11 && typeof(r11) == typeof(w11)
        println("UInt32 passed.")
    else
        println("UInt32 failed.")
    end
    
    if r12 == w12 && typeof(r12) == typeof(w12)
        println("UInt64 passed.")
    else
        println("UInt64 failed.")
    end
    
    if r13 == w13 && typeof(r13) == typeof(w13)
        println("UInt128 passed.")
    else
        println("UInt128 failed.")
    end
    
    if r14 == w14 && typeof(r14) == typeof(w14)
        println("Float16 passed.")
    else
        println("Float16 failed.")
    end
    
    if r15 == w15 && typeof(r15) == typeof(w15)
        println("Float32 passed.")
    else
        println("Float32 failed.")
    end
    
    if r16 == w16 && typeof(r16) == typeof(w16)
        println("Float64 passed.")
    else
        println("Float64 failed.")
    end
    
    # Testing vectors of values.

    println()
    println("Test writing-to and reading-from built-in vector types.")
    println()
    
    wv1     = Vector{Bool}(undef, 2)
    wv1[1]  = true
    wv1[2]  = false
    
    wv2     = Vector{Int8}(undef, 2)
    wv2[1]  = -1
    wv2[2]  = 1
    
    wv3     = Vector{Int16}(undef, 2)
    wv3[1]  = -2
    wv3[2]  = 2
    
    wv4     = Vector{Int32}(undef, 2)
    wv4[1]  = -3
    wv4[2]  = 3
    
    wv5     = Vector{Int64}(undef, 2)
    wv5[1]  = -4
    wv5[2]  = 4
    
    wv6     = Vector{Int128}(undef, 2)
    wv6[1]  = -5
    wv6[2]  = 5
    
    wv7     = Vector{UInt8}(undef, 2)
    wv7[1]  = 0
    wv7[2]  = 1
    
    wv8     = Vector{UInt16}(undef, 2)
    wv8[1]  = 2
    wv8[2]  = 3
    
    wv9     = Vector{UInt32}(undef, 2)
    wv9[1]  = 4
    wv9[2]  = 5
    
    wv10    = Vector{UInt64}(undef, 2)
    wv10[1] = 6
    wv10[2] = 7
    
    wv11    = Vector{UInt128}(undef, 2)
    wv11[1] = 8
    wv11[2] = 9
    
    wv12    = Vector{Float16}(undef, 2)
    wv12[1] = 10.0
    wv12[2] = 11.0
    
    wv13    = Vector{Float32}(undef, 2)
    wv13[1] = 12.0
    wv13[2] = 13.0
    
    wv14    = Vector{Float64}(undef, 2)
    wv14[1] = 14.0
    wv14[2] = 15.0
    
    json_stream = openJSONWriter(my_dir_path, "testBuiltInVectorTypes.json")
    
    toFile(wv1,  json_stream) # Vector{Bool}
    toFile(wv2,  json_stream) # Vector{Int8}
    toFile(wv3,  json_stream) # Vector{Int16}
    toFile(wv4,  json_stream) # Vector{Int32}
    toFile(wv5,  json_stream) # Vector{Int64}
    toFile(wv6,  json_stream) # Vector{Int128}
    toFile(wv7,  json_stream) # Vector{UInt8}
    toFile(wv8,  json_stream) # Vector{UInt16}
    toFile(wv9,  json_stream) # Vector{UInt32}
    toFile(wv10, json_stream) # Vector{UInt64}
    toFile(wv11, json_stream) # Vector{UInt128}
    toFile(wv12, json_stream) # Vector{Float16}
    toFile(wv13, json_stream) # Vector{Float32}
    toFile(wv14, json_stream) # Vector{Float64}
    
    close(json_stream)
    
    json_stream = openJSONReader(my_dir_path, "testBuiltInVectorTypes.json")
    
    rv1  = fromFile(Vector{Bool},    json_stream) # Vector{Bool}
    rv2  = fromFile(Vector{Int8},    json_stream) # Vector{Int8}
    rv3  = fromFile(Vector{Int16},   json_stream) # Vector{Int16}
    rv4  = fromFile(Vector{Int32},   json_stream) # Vector{Int32}
    rv5  = fromFile(Vector{Int64},   json_stream) # Vector{Int64}
    rv6  = fromFile(Vector{Int128},  json_stream) # Vector{Int128}
    rv7  = fromFile(Vector{UInt8},   json_stream) # Vector{UInt8}
    rv8  = fromFile(Vector{UInt16},  json_stream) # Vector{UInt16}
    rv9  = fromFile(Vector{UInt32},  json_stream) # Vector{UInt32}
    rv10 = fromFile(Vector{UInt64},  json_stream) # Vector{UInt64}
    rv11 = fromFile(Vector{UInt128}, json_stream) # Vector{UInt128}
    rv12 = fromFile(Vector{Float16}, json_stream) # Vector{Float16}
    rv13 = fromFile(Vector{Float32}, json_stream) # Vector{Float32}
    rv14 = fromFile(Vector{Float64}, json_stream) # Vector{Float64}
    
    close(json_stream)
    
    if rv1 == wv1 && typeof(rv1) == typeof(wv1)
        println("Vector{Bool} passed.")
    else
        println("Vector{Bool} failed.")
    end
    
    if rv2 == wv2 && typeof(rv2) == typeof(wv2)
        println("Vector{Int8} passed.")
    else
        println("Vector{Int8} failed.")
    end
    
    if rv3 == wv3 && typeof(rv3) == typeof(wv3)
        println("Vector{Int16} passed.")
    else
        println("Vector{Int16} failed.")
    end
    
    if rv4 == wv4 && typeof(rv4) == typeof(wv4)
        println("Vector{Int32} passed.")
    else
        println("Vector{Int32} failed.")
    end
    
    if rv5 == wv5 && typeof(rv5) == typeof(wv5)
        println("Vector{Int64} passed.")
    else
        println("Vector{Int64} failed.")
    end
    
    if rv6 == wv6 && typeof(rv6) == typeof(wv6)
        println("Vector{Int128} passed.")
    else
        println("Vector{Int128} failed.")
    end
    
    if rv7 == wv7 && typeof(rv7) == typeof(wv7)
        println("Vector{UInt8} passed.")
    else
        println("Vector{UInt8} failed.")
    end
    
    if rv8 == wv8 && typeof(rv8) == typeof(wv8)
        println("Vector{UInt16} passed.")
    else
        println("Vector{UInt16} failed.")
    end
    
    if rv9 == wv9 && typeof(rv9) == typeof(wv9)
        println("Vector{UInt32} passed.")
    else
        println("Vector{UInt32} failed.")
    end
    
    if rv10 == wv10 && typeof(rv10) == typeof(wv10)
        println("Vector{UInt64} passed.")
    else
        println("Vector{UInt64} failed.")
    end
    
    if rv11 == wv11 && typeof(rv11) == typeof(wv11)
        println("Vector{UInt128} passed.")
    else
        println("Vector{UInt128} failed.")
    end
    
    if rv12 == wv12 && typeof(rv12) == typeof(wv12)
        println("Vector{Float16} passed.")
    else
        println("Vector{Float16} failed.")
    end
    
    if rv13 == wv13 && typeof(rv13) == typeof(wv13)
        println("Vector{Float32} passed.")
    else
        println("Vector{Float32} failed.")
    end
    
    if rv14 == wv14 && typeof(rv14) == typeof(wv14)
        println("Vector{Float64} passed.")
    else
        println("Vector{Float64} failed.")
    end
end # testBuiltIns

function testToString()
    # Assign random values to the base types.
    
    function assignBoolean()::Bool
        x = rand()
        if x > 0.5
            return true
        else
            return false
        end
    end
    
    function assignInteger()::Int
        return rand(-1000:1000)
    end
    
    function assignReal()::Real
        min = -100.0
        max =  100.0
        return min + (max - min) * rand()
    end
        
    # Test the printing of boolean vectors.
    
    println()
    println("Boolean vectors:")
    len = 3
    v1 = Vector{Bool}(undef, len)
    for i in 1:len
        v1[i] = assignBoolean()
    end
    println()
    println(toString(v1))
    len = 15
    v2 = Vector{Bool}(undef, len)
    for i in 1:len
        v2[i] = assignBoolean()
    end
    println()
    println(toString(v2))
    
    # Test the printing of boolean matrices.
    
    println()
    println("Boolean matrices:")
    rows = 3
    cols = 4
    m1 = Matrix{Bool}(undef, rows, cols)
    for i in 1:rows
        for j in 1:cols
            m1[i,j] = assignBoolean()
        end
    end
    println()
    println(toString(m1))
    rows = 2
    cols = 15
    m2 = Matrix{Bool}(undef, rows, cols)
    for i in 1:rows
        for j in 1:cols
            m2[i,j] = assignBoolean()
        end
    end
    println()
    println(toString(m2))
    rows = 60
    cols = 3
    m3 = Matrix{Bool}(undef, rows, cols)
    for i in 1:rows
        for j in 1:cols
            m3[i,j] = assignBoolean()
        end
    end
    println()
    println(toString(m3))
    rows = 60
    cols = 15
    m4 = Matrix{Bool}(undef, rows, cols)
    for i in 1:rows
        for j in 1:cols
            m4[i,j] = assignBoolean()
        end
    end
    println()
    println(toString(m4))
    
    # Test the printing integer vectors.
    
    println()
    println("Integer vectors:")
    len = 3
    v3 = Vector{Int}(undef, len)
    for i in 1:len
        v3[i] = assignInteger()
    end
    println()
    println(toString(v3))
    len = 20
    v4 = Vector{Int}(undef, len)
    for i in 1:len
        v4[i] = assignInteger()
    end
    println()
    println(toString(v4))
    
    # Test the printing of integer matrices.
    
    println()
    println("Integer matrices:")
    rows = 3
    cols = 4
    m5 = Matrix{Int}(undef, rows, cols)
    for i in 1:rows
        for j in 1:cols
            m5[i,j] = assignInteger()
        end
    end
    println()
    println(toString(m5))
    rows = 2
    cols = 20
    m6 = Matrix{Int}(undef, rows, cols)
    for i in 1:rows
        for j in 1:cols
            m6[i,j] = assignInteger()
        end
    end
    println()
    println(toString(m6))
    rows = 60
    cols = 3
    m7 = Matrix{Int}(undef, rows, cols)
    for i in 1:rows
        for j in 1:cols
            m7[i,j] = assignInteger()
        end
    end
    println()
    println(toString(m7))
    rows = 60
    cols = 15
    m8 = Matrix{Int}(undef, rows, cols)
    for i in 1:rows
        for j in 1:cols
            m8[i,j] = assignInteger()
        end
    end
    println()
    println(toString(m8))
    
    # Test the printing real vectors.
    
    println()
    println("Real vectors:")
    len = 3
    v5 = Vector{Float32}(undef, len)
    for i in 1:len
        v5[i] = Float32(assignReal())
    end
    println()
    println(toString(v5))
    len = 20
    v6 = Vector{Float64}(undef, len)
    for i in 1:len
        v6[i] = Float64(assignReal())
    end
    println()
    println(toString(v6))
    
    # Test the printing of real matrices.
    
    println()
    println("Real matrices:")
    rows = 3
    cols = 4
    m9 = Matrix{Float16}(undef, rows, cols)
    for i in 1:rows
        for j in 1:cols
            m9[i,j] = Float16(assignReal())
        end
    end
    println()
    println(toString(m9))
    rows = 2
    cols = 20
    m10 = Matrix{Float32}(undef, rows, cols)
    for i in 1:rows
        for j in 1:cols
            m10[i,j] = Float32(assignReal())
        end
    end
    println()
    println(toString(m10))
    rows = 60
    cols = 3
    m11 = Matrix{Float64}(undef, rows, cols)
    for i in 1:rows
        for j in 1:cols
            m11[i,j] = Float64(assignReal())
        end
    end
    println()
    println(toString(m11))
    rows = 60
    cols = 15
    m12 = Matrix{Float32}(undef, rows, cols)
    for i in 1:rows
        for j in 1:cols
            m12[i,j] = Float32(assignReal())
        end
    end
    println()
    println(toString(m12))
    
end # testToString

end  # module testPersistence
