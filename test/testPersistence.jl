module testPersistence

using
    ..PhysicalFields

export run

function run(at_dir::String)
    println("Test writing-to and reading-from file for built-in types.")
    println()
    my_dir_path = string(at_dir, "/test/files/")
    
    # Testing values.

    json_stream = openJSONWriter(my_dir_path, "testValuePersistence.json")
    
    w1  = "This is a test file."
    w2  = Dict{String, Int}("a" => 1, "b" => 2, "c" => 3)
    w3  = Bool(true)
    w4  = Int8(-1)
    w5  = Int16(-2)
    w6  = Int32(-3)
    w7  = Int64(-4)
    w8  = Int128(-5)
    w9  = BigInt(-6)
    w10 = UInt8(1)
    w11 = UInt16(2)
    w12 = UInt32(3)
    w13 = UInt64(4)
    w14 = UInt128(5)
    w15 = Float16(1.0)
    w16 = Float32(2.0)
    w17 = Float64(3.0)
    w18 = BigFloat(4.0)
    toFile(w1,  json_stream) # String
    toFile(w2,  json_stream) # Dict
    toFile(w3,  json_stream) # Bool
    toFile(w4,  json_stream) # Int8
    toFile(w5,  json_stream) # Int16
    toFile(w6,  json_stream) # Int32
    toFile(w7,  json_stream) # Int64
    toFile(w8,  json_stream) # Int128
    toFile(w9,  json_stream) # BigInt
    toFile(w10, json_stream) # UInt8
    toFile(w11, json_stream) # UInt16
    toFile(w12, json_stream) # UInt32
    toFile(w13, json_stream) # UInt64
    toFile(w14, json_stream) # UInt128
    toFile(w15, json_stream) # Float16
    toFile(w16, json_stream) # Float32
    toFile(w17, json_stream) # Float64
    toFile(w18, json_stream) # BigFloat
    
    close(json_stream)
    
    json_stream = openJSONReader(my_dir_path, "testValuePersistence.json")
    
    r1  = fromFile(String, json_stream)
    r2  = fromFile(Dict,   json_stream)
    r3  = fromFile(Bool,   json_stream) # Bool
    r4  = fromFile(Int8,   json_stream) # Int8
    r5  = fromFile(Int16,  json_stream) # Int16
    r6  = fromFile(Int32,  json_stream) # Int32
    r7  = fromFile(Int64,  json_stream) # Int64
    r8  = fromFile(Int128, json_stream) # Int128
    r9  = fromFile(Real,   json_stream) # BigInt
    r10 = fromFile(Real,   json_stream) # UInt8
    r11 = fromFile(Real,   json_stream) # UInt16
    r12 = fromFile(Real,   json_stream) # UInt32
    r13 = fromFile(Real,   json_stream) # UInt64
    r14 = fromFile(Real,   json_stream) # UInt128
    r15 = fromFile(Real,   json_stream) # Float16
    r16 = fromFile(Real,   json_stream) # Float32
    r17 = fromFile(Real,   json_stream) # Float64
    r18 = fromFile(Real,   json_stream) # BigFloat
    
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
        println("The dictionary written to was ", string(w2))
        println("The dictionary read from  was ", string(r2))
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
    
    if r8 == w8 && typeof(r8) == typeof(w8)
        println("Int128 passed.")
    else
        println("Int128 failed.")
    end
    
    if r9 == w9 && typeof(r9) == typeof(w9)
        println("BigInt passed.")
    else
        println("BigInt failed.")
    end
    
    if r10 == w10 && typeof(r10) == typeof(w10)
        println("UInt8 passed.")
    else
        println("UInt8 failed.")
    end
    
    if r11 == w11 && typeof(r11) == typeof(w11)
        println("UInt16 passed.")
    else
        println("UInt16 failed.")
    end
    
    if r12 == w12 && typeof(r12) == typeof(w12)
        println("UInt32 passed.")
    else
        println("UInt32 failed.")
    end
    
    if r13 == w13 && typeof(r13) == typeof(w13)
        println("UInt64 passed.")
    else
        println("UInt64 failed.")
    end
    
    if r14 == w14 && typeof(r14) == typeof(w14)
        println("UInt128 passed.")
    else
        println("UInt128 failed.")
    end
    
    if r15 == w15 && typeof(r15) == typeof(w15)
        println("Float16 passed.")
    else
        println("Float16 failed.")
    end
    
    if r16 == w16 && typeof(r16) == typeof(w16)
        println("Float32 passed.")
    else
        println("Float32 failed.")
    end
    
    if r17 == w17 && typeof(r17) == typeof(w17)
        println("Float64 passed.")
    else
        println("Float64 failed.")
    end
    
    if r18 == w18 && typeof(r18) == typeof(w18)
        println("BigFloat passed.")
    else
        println("BigFloat failed.")
    end
    
    # Test printing these values:
    
    println()
    println("For Int8,     toString = ", toString(w4),  " and print = ", w4)
    println("For Int16,    toString = ", toString(w5),  " and print = ", w5)
    println("For Int32,    toString = ", toString(w6),  " and print = ", w6)
    println("For Int64,    toString = ", toString(w7),  " and print = ", w7)
    println("For Int128,   toString = ", toString(w8),  " and print = ", w8)
    println("For BigInt,   toString = ", toString(w9),  " and print = ", w9)
    println("For UInt8,    toString = ", toString(w10), " and print = ", w10)
    println("For UInt16,   toString = ", toString(w11), " and print = ", w11)
    println("For UInt32,   toString = ", toString(w12), " and print = ", w12)
    println("For UInt64,   toString = ", toString(w13), " and print = ", w13)
    println("For UInt128,  toString = ", toString(w14), " and print = ", w14)
    println("For Float16,  toString = ", toString(w15), " and print = ", w15)
    println("For Float32,  toString = ", toString(w16), " and print = ", w16)
    println("For Float64,  toString = ", toString(w17), " and print = ", w17)
    println("For BigFloat, toString = ", toString(w18), " and print = ", w18)
    
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
    
    wv7     = Vector{BigInt}(undef, 2)
    wv7[1]  = -6
    wv7[2]  = 6
    
    wv8     = Vector{UInt8}(undef, 2)
    wv8[1]  = 0
    wv8[2]  = 1
    
    wv9     = Vector{UInt16}(undef, 2)
    wv9[1]  = 2
    wv9[2]  = 3
    
    wv10    = Vector{UInt32}(undef, 2)
    wv10[1] = 4
    wv10[2] = 5
    
    wv11    = Vector{UInt64}(undef, 2)
    wv11[1] = 6
    wv11[2] = 7
    
    wv12    = Vector{UInt128}(undef, 2)
    wv12[1] = 8
    wv12[2] = 9
    
    wv13    = Vector{Float16}(undef, 2)
    wv13[1] = 10.0
    wv13[2] = 11.0
    
    wv14    = Vector{Float32}(undef, 2)
    wv14[1] = 12.0
    wv14[2] = 13.0
    
    wv15    = Vector{Float64}(undef, 2)
    wv15[1] = 14.0
    wv15[2] = 15.0
    
    wv16    = Vector{BigFloat}(undef, 2)
    wv16[1] = 16.0
    wv16[2] = 17.0
    
    json_stream = openJSONWriter(my_dir_path, "testVectorPersistence.json")
    
    toFile(wv1,  json_stream) # Vector{Bool}
    toFile(wv2,  json_stream) # Vector{Int8}
    toFile(wv3,  json_stream) # Vector{Int16}
    toFile(wv4,  json_stream) # Vector{Int32}
    toFile(wv5,  json_stream) # Vector{Int64}
    toFile(wv6,  json_stream) # Vector{Int128}
    toFile(wv7,  json_stream) # Vector{BigInt}
    toFile(wv8,  json_stream) # Vector{UInt8}
    toFile(wv9,  json_stream) # Vector{UInt16}
    toFile(wv10, json_stream) # Vector{UInt32}
    toFile(wv11, json_stream) # Vector{UInt64}
    toFile(wv12, json_stream) # Vector{UInt128}
    toFile(wv13, json_stream) # Vector{Float16}
    toFile(wv14, json_stream) # Vector{Float32}
    toFile(wv15, json_stream) # Vector{Float64}
    toFile(wv16, json_stream) # Vector{BigFloat}
    
    close(json_stream)
    
    json_stream = openJSONReader(my_dir_path, "testVectorPersistence.json")
    
    rv1  = fromFile(Vector, json_stream) # Vector{Bool}
    rv2  = fromFile(Vector, json_stream) # Vector{Int8}
    rv3  = fromFile(Vector, json_stream) # Vector{Int16}
    rv4  = fromFile(Vector, json_stream) # Vector{Int32}
    rv5  = fromFile(Vector, json_stream) # Vector{Int64}
    rv6  = fromFile(Vector, json_stream) # Vector{Int128}
    rv7  = fromFile(Vector, json_stream) # Vector{BigInt}
    rv8  = fromFile(Vector, json_stream) # Vector{UInt8}
    rv9  = fromFile(Vector, json_stream) # Vector{UInt16}
    rv10 = fromFile(Vector, json_stream) # Vector{UInt32}
    rv11 = fromFile(Vector, json_stream) # Vector{UInt64}
    rv12 = fromFile(Vector, json_stream) # Vector{UInt128}
    rv13 = fromFile(Vector, json_stream) # Vector{Float16}
    rv14 = fromFile(Vector, json_stream) # Vector{Float32}
    rv15 = fromFile(Vector, json_stream) # Vector{Float64}
    rv16 = fromFile(Vector, json_stream) # Vector{BigFloat}
    
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
        println("Vector{BigInt} passed.")
    else
        println("Vector{BigInt} failed.")
    end
    
    if rv8 == wv8 && typeof(rv8) == typeof(wv8)
        println("Vector{UInt8} passed.")
    else
        println("Vector{UInt8} failed.")
    end
    
    if rv9 == wv9 && typeof(rv9) == typeof(wv9)
        println("Vector{UInt16} passed.")
    else
        println("Vector{UInt16} failed.")
    end
    
    if rv10 == wv10 && typeof(rv10) == typeof(wv10)
        println("Vector{UInt32} passed.")
    else
        println("Vector{UInt32} failed.")
    end
    
    if rv11 == wv11 && typeof(rv11) == typeof(wv11)
        println("Vector{UInt64} passed.")
    else
        println("Vector{UInt64} failed.")
    end
    
    if rv12 == wv12 && typeof(rv12) == typeof(wv12)
        println("Vector{UInt128} passed.")
    else
        println("Vector{UInt128} failed.")
    end
    
    if rv13 == wv13 && typeof(rv13) == typeof(wv13)
        println("Vector{Float16} passed.")
    else
        println("Vector{Float16} failed.")
    end
    
    if rv14 == wv14 && typeof(rv14) == typeof(wv14)
        println("Vector{Float32} passed.")
    else
        println("Vector{Float32} failed.")
    end
    
    if rv15 == wv15 && typeof(rv15) == typeof(wv15)
        println("Vector{Float64} passed.")
    else
        println("Vector{Float64} failed.")
    end
    
    if rv16 == wv16 && typeof(rv16) == typeof(wv16)
        println("Vector{BigFloat} passed.")
    else
        println("Vector{BigFloat} failed.")
    end
    
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
    
    # Test the printing of matrices.
    
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
    
end # run
end  # module testPersistence
