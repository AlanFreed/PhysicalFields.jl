module testPhysicalTypes

using
    ..PhysicalFields

export
    run

function run(at_dir::String)
    # Create three scalars and populate an array of scalars with them.
    e1 = PhysicalScalar(CGS_ENERGY)
    set!(e1, 1.0)
    e2 = PhysicalScalar(2, CGS_ENERGY)
    e3 = PhysicalScalar(3, CGS_ENERGY)
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
    for i in 1:sa.array.len
        println("    For entry ", toString(i))
        println("        It wrote out scalar: ", toString(sArr[i]))
        println("        It read in a scalar: ", toString(sa[i]))
    end
    va = fromFile(ArrayOfPhysicalVectors, json_stream)
    println("An instance of type ArrayOfPhysicalVectors.")
    for i in 1:va.array.rows
        println("    For entry ", toString(i))
        println("        It wrote out vector: ", toString(vArr[i]))
        println("        It read in a vector: ", toString(va[i]))
    end
    ma = fromFile(ArrayOfPhysicalTensors, json_stream)
    println("An instance of type ArrayOfPhysicalTensors.")
    for i in 1:ma.array.pp
        println("    For entry ", toString(i))
        println("        It wrote out matrix:\n", toString(mArr[i]))
        println("        It read in a matrix:\n", toString(ma[i]))
    end
    close(json_stream)
    return nothing
end

end  # module testPhysicalTypes
