module testPhysicalTypes

using
    ..PhysicalFields

export
    run

function run(at_dir::String)
    # Create three scalars and populate an array of scalars with them.
    e1 = PhysicalScalar(CGS_ENERGY)
    e2 = PhysicalScalar(CGS_ENERGY)
    e3 = PhysicalScalar(CGS_ENERGY)
    set!(e1, 1.0)
    set!(e2, 2.0)
    set!(e3, 3.0)
    sArr = ArrayOfPhysicalScalars(3, CGS_ENERGY)
    sArr[1] = e1
    sArr[2] = e2
    sArr[3] = e3
    # Create three vectors and populate an array of vectors with them.
    f = PhysicalScalar(1.0, CGS_FORCE)
    v1 = PhysicalVector(3, CGS_FORCE)
    v2 = PhysicalVector(3, CGS_FORCE)
    v3 = PhysicalVector(3, CGS_FORCE)
    v1[1] = f
    v1[2] = 2*f
    v1[3] = 3*f
    v2[1] = 4*f
    v2[2] = 5*f
    v2[3] = 6*f
    v3[1] = 7*f
    v3[2] = 8*f
    v3[3] = 9*f
    vArr = ArrayOfPhysicalVectors(3, 3, CGS_FORCE)
    vArr[1] = v1
    vArr[2] = v2
    vArr[3] = v3
    # Create three matrices and populate an array of matrices with them.
    m1 = PhysicalTensor(2, 3, CGS_STRESS)
    m1[1,1] = PhysicalScalar(1.1, CGS_STRESS)
    m1[1,2] = PhysicalScalar(1.4, CGS_STRESS)
    m1[1,3] = PhysicalScalar(1.7, CGS_STRESS)
    m1[2,1] = PhysicalScalar(1.2, CGS_STRESS)
    m1[2,2] = PhysicalScalar(1.5, CGS_STRESS)
    m1[2,3] = PhysicalScalar(1.8, CGS_STRESS)
    m2 = PhysicalTensor(2, 3, CGS_STRESS)
    m2[1,1] = PhysicalScalar(2.1, CGS_STRESS)
    m2[1,2] = PhysicalScalar(2.4, CGS_STRESS)
    m2[1,3] = PhysicalScalar(2.7, CGS_STRESS)
    m2[2,1] = PhysicalScalar(2.2, CGS_STRESS)
    m2[2,2] = PhysicalScalar(2.5, CGS_STRESS)
    m2[2,3] = PhysicalScalar(2.8, CGS_STRESS)
    m3 = PhysicalTensor(2, 3, CGS_STRESS)
    m3[1,1] = PhysicalScalar(3.1, CGS_STRESS)
    m3[1,2] = PhysicalScalar(3.4, CGS_STRESS)
    m3[1,3] = PhysicalScalar(3.7, CGS_STRESS)
    m3[2,1] = PhysicalScalar(3.2, CGS_STRESS)
    m3[2,2] = PhysicalScalar(3.5, CGS_STRESS)
    m3[2,3] = PhysicalScalar(3.8, CGS_STRESS)
    mArr = ArrayOfPhysicalTensors(3, 2, 3, CGS_STRESS)
    mArr[1] = m1
    mArr[2] = m2
    mArr[3] = m3
    # Print out the entries of this scalar array.
    println()
    println("The scalar fields held in the array of scalars include:")
    s1 = sArr[1]
    s2 = sArr[2]
    s3 = sArr[3]
    println("   at index 1: ", toString(s1))
    println("   at index 2: ", toString(s2))
    println("   at index 3: ", toString(s3))
    println()
    println("The vector fields held in the array of vectors include:")
    v1 = vArr[1]
    v2 = vArr[2]
    v3 = vArr[3]
    println("   at index 1: ", toString(v1))
    println("   at index 2: ", toString(v2))
    println("   at index 3: ", toString(v3))
    println()
    println("The tensor fields held in the array of matrices include:")
    m1 = mArr[1]
    m2 = mArr[2]
    m3 = mArr[3]
    println("   at index 1:")
    println(toString(m1))
    println("   at index 2:")
    println(toString(m2))
    println("   at index 3:")
    println(toString(m3))
    # Print out large vectors.
    b     = PhysicalVector(15, CENTIMETER)
    x     = 1.0
    for i in 1:15
        s = PhysicalScalar(CENTIMETER)
        set!(s, x)
        b[i] = s
        x -= 0.1
    end
    println()
    println("Check printing of long vectors in formats 'e', 'E' and 'F':")
    format = 'e'
    println(toString(b; format))
    println(toString(b))
    format = 'F'
    println(toString(b; format))
    println()
    println("Check printing of medium length vectors in formats 'E' and 'F':")
    d = PhysicalVector(6, CENTIMETER)
    for i in 1:d.l
        d[i] = b[i]
    end
    println(toString(d))
    c = PhysicalVector(9, CENTIMETER)
    for i in 1:c.l
        c[i] = b[i]
    end
    println(toString(c; format))
    println()
    println("Check printing of large matrices:")
    b = PhysicalTensor(15, 15, KILOGRAM)
    x = 1.0
    for r in 1:b.r
        for c in 1:b.c
            s = PhysicalScalar(KILOGRAM)
            set!(s, x)
            b[r,c] = s
            x -= 0.01
        end
    end
    println(toString(b; format))
    println()
    println(toString(b))
    println()
    println("Check printing of matrices, largest before truncating:")
    c = PhysicalTensor(10, 10, KILOGRAM)
    for i in 1:c.r
        for j in 1:c.c
            c[i,j] = b[i,j]
        end
    end
    println(toString(c; format))
    d = PhysicalTensor(6, 6, KILOGRAM)
    for i in 1:d.r
        for j in 1:d.c
            d[i,j] = b[i,j]
        end
    end
    println()
    println(toString(d))
    println()
    println("Next dimension smaller:")
    e = PhysicalTensor(9, 9, KILOGRAM)
    for i in 1:e.r
        for j in 1:e.c
            e[i,j] = b[i,j]
        end
    end
    println(toString(e; format))
    println()
    r = PhysicalTensor(5, 5, KILOGRAM)
    for i in 1:r.r
        for j in 1:r.c
            r[i,j] = b[i,j]
        end
    end
    println(toString(r))
    println()
    println("Check out the printing of short-fat matrices:")
    g = PhysicalTensor(3, 12, KILOGRAM)
    for i in 1:g.r
        for j in 1:g.c
            g[i,j] = b[i,j]
        end
    end
    println(toString(g; format))
    println()
    println(toString(g))
    println()
    println("Check out the printing of tall-skiny matrices:")
    h = PhysicalTensor(12, 3, KILOGRAM)
    for i in 1:h.r
        for j in 1:h.c
            h[i,j] = b[i,j]
        end
    end
    println(toString(h; format))
    println()
    println(toString(h))
    println()
    println("If this printout makes sense, then this test passes.")
    println()
    println("Test writing and reading physical fields to and from a JSON file.")
    println()
    my_dir_path = string(at_dir, "/test/files/")
    json_stream = openJSONWriter(my_dir_path, "testPhysicalTypes.json")
    toFile(s1, json_stream)    # writing a scalar to file.
    toFile(v1, json_stream)    # writing a vector to file.
    toFile(m1, json_stream)    # writing a tensor to file.
    toFile(sArr, json_stream)  # writing a scalar array to file.
    toFile(vArr, json_stream)  # writing a vector array to file.
    toFile(mArr, json_stream)  # writing a tensor array to file.
    close(json_stream)
    json_stream = openJSONReader(my_dir_path, "testPhysicalTypes.json")
    s = fromFile(PhysicalScalar, json_stream)
    println("An instance of type PhysicalScalar.")
    println("   It wrote out scalar: ", toString(s1))
    println("   It read in a scalar: ", toString(s))
    v = fromFile(PhysicalVector, json_stream)
    println("An instance of type PhysicalVector.")
    println("   It wrote out vector: ", toString(v1))
    println("   It read in a vector: ", toString(v))
    m = fromFile(PhysicalTensor, json_stream)
    println("An instance of type PhysicalTensor.")
    println("   It wrote out tensor:\n", toString(m1))
    println("   It read in a tensor:\n", toString(m))
    sa = fromFile(ArrayOfPhysicalScalars, json_stream)
    println("An instance of type ArrayOfPhysicalScalars.")
    for i in 1:sa.e
        println("    For entry ", toString(i))
        println("        It wrote out scalar: ", toString(sArr[i]))
        println("        It read in a scalar: ", toString(sa[i]))
    end
    va = fromFile(ArrayOfPhysicalVectors, json_stream)
    println("An instance of type ArrayOfPhysicalVectors.")
    for i in 1:va.e
        println("    For entry ", toString(i))
        println("        It wrote out vector: ", toString(vArr[i]))
        println("        It read in a vector: ", toString(va[i]))
    end
    ma = fromFile(ArrayOfPhysicalTensors, json_stream)
    println("An instance of type ArrayOfPhysicalTensors.")
    for i in 1:ma.e
        println("    For entry ", toString(i))
        println("        It wrote out matrix:\n", toString(mArr[i]))
        println("        It read in a matrix:\n", toString(ma[i]))
    end
    close(json_stream)
    return nothing
end

end  # module testPhysicalTypes
