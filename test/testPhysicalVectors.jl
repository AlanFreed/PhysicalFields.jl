
module testPhysicalVectors

using
    ..PhysicalFields

export
    run


function run()
    format = 'F'
    precision = 5
    aligned = true
    println("Test the get and set operators via []:")
    a = PhysicalVector(3, DYNE)
    println("A new vector: ", toString(a; format))
    a1 = PhysicalScalar(a.units)
    set!(a1, 1.0)
    a2 = PhysicalScalar(a.units)
    set!(a2, 2.0)
    a3 = PhysicalScalar(a.units)
    set!(a3, 3.0)
    a[1] = a1
    a[2] = a2
    a[3] = a3
    println("reassigned:   ", toString(a; format))
    b   = PhysicalVector(15, CENTIMETER)
    b1  = PhysicalScalar(CENTIMETER)
    set!(b1, 1.0)
    b2  = PhysicalScalar(CENTIMETER)
    set!(b2, 0.9)
    b3  = PhysicalScalar(CENTIMETER)
    set!(b3, 0.8)
    b4  = PhysicalScalar(CENTIMETER)
    set!(b4, 0.7)
    b5  = PhysicalScalar(CENTIMETER)
    set!(b5, 0.6)
    b6  = PhysicalScalar(CENTIMETER)
    set!(b6, 0.5)
    b7  = PhysicalScalar(CENTIMETER)
    set!(b7, 0.4)
    b8  = PhysicalScalar(CENTIMETER)
    set!(b8, 0.3)
    b9  = PhysicalScalar(CENTIMETER)
    set!(b9, 0.2)
    b10 = PhysicalScalar(CENTIMETER)
    set!(b10, 0.1)
    b11 = PhysicalScalar(CENTIMETER)
    set!(b10, 0.0)
    b12 = PhysicalScalar(CENTIMETER)
    set!(b12, -0.1)
    b13 = PhysicalScalar(CENTIMETER)
    set!(b13, -0.2)
    b14 = PhysicalScalar(CENTIMETER)
    set!(b14, -0.3)
    b15 = PhysicalScalar(CENTIMETER)
    set!(b15, -0.4)
    b[1] = b1
    b[2] = b2
    b[3] = b3
    b[4] = b4
    b[5] = b5
    b[6] = b6
    b[7] = b7
    b[8] = b8
    b[9] = b9
    b[10] = b10
    b[11] = b11
    b[12] = b12
    b[13] = b13
    b[14] = b14
    b[15] = b15
    println("Check printing of long vectors:")
    println(toString(b; format))
    format = 'E'
    println(toString(b; format))
    println("Check printing of intermediate length vectors:")
    c = PhysicalVector(9, CENTIMETER)
    for i in 1:c.vector.len
        c[i] = b[i]
    end
    format = 'F'
    println(toString(c; format))
    d = PhysicalVector(6, CENTIMETER)
    for i in 1:d.vector.len
        d[i] = b[i]
    end
    format = 'E'
    println(toString(d; format))
    println("Check printing of short vectors:")
    println(toString(a; format))
    format = 'F'
    println(toString(a; format))
    println("Testing vector arithmetic in 3 space:")
    y = PhysicalScalar(CENTIMETER)
    set!(y, π)
    b = PhysicalVector(3, DYNE)
    b1 = PhysicalScalar(DYNE)
    set!(b1, -3.0)
    b2 = PhysicalScalar(DYNE)
    set!(b2, -2.0)
    b3 = PhysicalScalar(DYNE)
    set!(b3, -1.0)
    b[1] = b1
    b[2] = b2
    b[3] = b3
    format = 'E'
    println("    y = ", toString(y; format, precision, aligned))
    println("    a = ", toString(a; format))
    println("    b = ", toString(b; format))
    println("   -b = ", toString(-b; format))
    println("a + b = ", toString(a+b; format))
    println("a - b = ", toString(a-b; format))
    println("a * b = ", toString(a*b; format, precision, aligned))
    println("y * a = ", toString(y*a; format))
    println("a / y = ", toString(a/y; format))
    println("||b|| = ", toString(norm(b); format, precision, aligned))
    println("Base vectors:")
    e1 = unitVector(a)
    e2 = unitVector(b)
    println("e1    = ", toString(e1; format))
    println("e2    = ", toString(e2; format))
    e3 = cross(e1, e2)
    println("e3    = ", toString(e3; format), "  where e3 = e1 × e2")
    println("e1.e2 = ", toString(e1*e2; format, precision, aligned), "  angle is obtuse")
    println("e1.e3 = ", toString(e1*e3; format, precision, aligned), "  angle is right")
    println("e2.e3 = ", toString(e2*e3; format, precision, aligned), "  angle is right")
    println()
    println("Test ArrayOfPhysicalVectors:")
    println()
    entries = 5
    len = 3
    vᵢ = PhysicalVector(len, PASCAL)
    vᵢ1 = PhysicalScalar(PASCAL)
    set!(vᵢ1, 1)
    vᵢ2 = PhysicalScalar(PASCAL)
    set!(vᵢ2, 2)
    vᵢ3 = PhysicalScalar(PASCAL)
    set!(vᵢ3, 3)
    a = ArrayOfPhysicalVectors(entries, len, PASCAL)
    n = 3
    for i in 1:entries
        vᵢ[1] = vᵢ1
        vᵢ[2] = vᵢ2
        vᵢ[3] = vᵢ3
        n += 1
        vᵢ1 = PhysicalScalar(PASCAL)
        set!(vᵢ1, n)
        n += 1
        vᵢ2 = PhysicalScalar(PASCAL)
        set!(vᵢ2, n)
        n += 1
        vᵢ3 = PhysicalScalar(PASCAL)
        set!(vᵢ3, n)
        a[i] = vᵢ
    end
    println("This array of vectors has a length of ", string(a.array.rows), ".")
    for i in 1:entries
        vᵢ = a[i]
        println("a[", string(i), "] = ", toString(vᵢ; format))
    end
    a[3] = PhysicalVector(len, PASCAL)
    println("resetting the third entry to zeros, one has")
    println("a[3] = ", toString(a[3]; format))
    println()
    println("If these answers make sense, then this test passes.")
    return nothing
end

end  # module testPhysicalVectors
