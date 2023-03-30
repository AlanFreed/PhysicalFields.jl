module testPhysicalTypes

using
    PhysicalFields

import
    PhysicalFields: CGS_ENERGY, CGS_FORCE, CGS_STRESS, CENTIMETER, KILOGRAM,
                    toString

export
    run

function run()
    # Create three scalars and populate an array of scalars with them.
    e1 = newPhysicalScalar(CGS_ENERGY)
    e2 = newPhysicalScalar(CGS_ENERGY)
    e3 = newPhysicalScalar(CGS_ENERGY)
    set!(e1, 1.0)
    set!(e2, 2.0)
    set!(e3, 3.0)
    sArr = newArrayOfPhysicalScalars(3, e1)
    sArr[2] = e2
    sArr[3] = e3
    # Create three vectors and populate an array of vectors with them.
    f = newPhysicalScalar(CGS_FORCE)
    set!(f, 1.0)
    v1 = newPhysicalVector(3, CGS_FORCE)
    v2 = newPhysicalVector(3, CGS_FORCE)
    v3 = newPhysicalVector(3, CGS_FORCE)
    v1[1] = f
    v2[2] = f
    v3[3] = f
    vArr = newArrayOfPhysicalVectors(3, v1)
    vArr[2] = v2
    vArr[3] = v3
    # Create three matrices and populate an array of matrices with them.
    s1 = newPhysicalScalar(CGS_STRESS)
    s2 = newPhysicalScalar(CGS_STRESS)
    s3 = newPhysicalScalar(CGS_STRESS)
    set!(s1, 1.0)
    set!(s2, 2.0)
    set!(s3, 3.0)
    m1 = newPhysicalTensor(3, 3, CGS_STRESS)
    m2 = newPhysicalTensor(3, 3, CGS_STRESS)
    m3 = newPhysicalTensor(3, 3, CGS_STRESS)
    m1[1,1] = s1
    m1[2,2] = s2
    m1[3,3] = s3
    m2[1,2] = s1
    m2[2,3] = s2
    m2[3,1] = s3
    m3[1,3] = s1
    m3[2,1] = s2
    m3[3,2] = s3
    mArr = newArrayOfPhysicalTensors(3, m1)
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
    b     = newPhysicalVector(15, CENTIMETER)
    x     = 1.0
    for i in 1:15
        s = newPhysicalScalar(CENTIMETER)
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
    d = newPhysicalVector(6, CENTIMETER)
    for i in 1:d.l
        d[i] = b[i]
    end
    println(toString(d))
    c = newPhysicalVector(9, CENTIMETER)
    for i in 1:c.l
        c[i] = b[i]
    end
    println(toString(c; format))
    println()
    println("Check printing of large matrices:")
    b = newPhysicalTensor(15, 15, KILOGRAM)
    x = 1.0
    for r in 1:b.r
        for c in 1:b.c
            s = newPhysicalScalar(KILOGRAM)
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
    c = newPhysicalTensor(10, 10, KILOGRAM)
    for i in 1:c.r
        for j in 1:c.c
            c[i,j] = b[i,j]
        end
    end
    println(toString(c; format))
    d = newPhysicalTensor(6, 6, KILOGRAM)
    for i in 1:d.r
        for j in 1:d.c
            d[i,j] = b[i,j]
        end
    end
    println()
    println(toString(d))
    println()
    println("Next dimension smaller:")
    e = newPhysicalTensor(9, 9, KILOGRAM)
    for i in 1:e.r
        for j in 1:e.c
            e[i,j] = b[i,j]
        end
    end
    println(toString(e; format))
    println()
    r = newPhysicalTensor(5, 5, KILOGRAM)
    for i in 1:r.r
        for j in 1:r.c
            r[i,j] = b[i,j]
        end
    end
    println(toString(r))
    println()
    println("Check out the printing of short-fat matrices:")
    g = newPhysicalTensor(3, 12, KILOGRAM)
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
    h = newPhysicalTensor(12, 3, KILOGRAM)
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
    return nothing
end

end  # module testPhysicalTypes
