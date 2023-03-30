module testPhysicalTensors

using
    PhysicalFields

export
    run

function run()
    format = 'F'
    println("Test the get and set operators via [].")
    a = newPhysicalTensor(3, 3, SI_VELOCITY)
    println("A new 3x3 matrix has values: ")
    println(toString(a; format))
    x = 0.0
    for i in 1:3
        for j in 1:3
            x += 1.0
            a[i,j] = PhysicalScalar(MReal(x), a.u)
        end
    end
    println("that are reassigned to have entries of")
    println(toString(a; format))
    println()
    println("Check printing of large matrices:")
    b = newPhysicalTensor(15, 15, KILOGRAM)
    x = 1.0
    for i in 1:b.r
        for j in 1:b.c
            x -= 0.01
            b[i,j] = PhysicalScalar(MReal(x), KILOGRAM)
        end
    end
    println(toString(b))
    println()
    println(toString(b; format))
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
    format = 'E'
    println(toString(d; format))
    println()
    println("Next dimension smaller:")
    e = newPhysicalTensor(9, 9, KILOGRAM)
    for i in 1:e.r
        for j in 1:e.c
            e[i,j] = b[i,j]
        end
    end
    format = 'F'
    println(toString(e; format))
    r = newPhysicalTensor(5, 5, KILOGRAM)
    for i in 1:r.r
        for j in 1:r.c
            r[i,j] = b[i,j]
        end
    end
    format = 'E'
    println(toString(r; format))
    println()
    println("Check out the printing of short-fat matrices:")
    g = newPhysicalTensor(3, 12, KILOGRAM)
    for i in 1:g.r
        for j in 1:g.c
            g[i,j] = b[i,j]
        end
    end
    format = 'F'
    println(toString(g; format))
    format = 'E'
    println(toString(g; format))
    println()
    println("Check out the printing of tall-skiny matrices:")
    h = newPhysicalTensor(12, 3, KILOGRAM)
    for i in 1:h.r
        for j in 1:h.c
            h[i,j] = b[i,j]
        end
    end
    format = 'F'
    println(toString(h; format))
    println()
    format = 'E'
    println(toString(h; format))
    println()
    println("Test out the various matrix functions,")
    println("where tensor 'a' has entries of")
    println(toString(a; format))
    b = newPhysicalTensor(3, 3, CGS_VELOCITY)
    x = 10.0
    for i in 1:3
        for j in 1:3
            x -= 1.0
            b[i,j] = PhysicalScalar(MReal(x), b.u)
        end
    end
    println("while a tensor 'b' has entries of")
    println(toString(b; format))
    y = PhysicalScalar(MReal(π), CENTIMETER)
    w = newPhysicalVector(3, CGS_DIMENSIONLESS)
    z = newPhysicalVector(3, CGS_DIMENSIONLESS)
    x = 1.0
    for i in 1:3
        x += 2.0
        w[i] = PhysicalScalar(MReal(x-2.0), CGS_DIMENSIONLESS)
        z[i] = PhysicalScalar(MReal(x), CGS_DIMENSIONLESS)
    end
    println("along with scalar")
    println("y = ", toString(y))
    println("and vectors")
    println("w = ", toString(w))
    println("z = ", toString(z))
    println()
    println("Note: Pay attention to the units in these answers.")
    println("w ⊗ z = \n", toString(tensorProduct(w,z)))
    println("-b = \n", toString(-b))
    println("a + b = \n", toString(a+b))
    println("a - b = \n", toString(a-b))
    println("a * b = \n", toString(a*b))
    println("b * z = ", toString(b*z))
    println("y * a = \n", toString(y*a))
    println("a / y = \n", toString(a/y))
    println("||a|| = ", toString(norm(a)))
    println("tr a  = ", toString(tr(a)))
    println("det a = ", toString(det(a)))
    println("aᵀ = \n", toString(transpose(a)))
    println("The following should blow up because det(a) = 0.0.")
    println("a⁻¹ = \n", toString(inv(a)))
    println()
    c = newPhysicalTensor(3, 3, SI_COMPLIANCE)
    println("A new matrix 'c' has values of: ")
    c[1,1] = PhysicalScalar(MReal(3.0), SI_COMPLIANCE)
    c[1,2] = PhysicalScalar(MReal(2.0), SI_COMPLIANCE)
    c[1,3] = PhysicalScalar(MReal(1.0), SI_COMPLIANCE)
    c[2,1] = PhysicalScalar(MReal(-3.0), SI_COMPLIANCE)
    c[2,2] = PhysicalScalar(MReal(5.0), SI_COMPLIANCE)
    c[2,3] = PhysicalScalar(MReal(-1.0), SI_COMPLIANCE)
    c[3,1] = PhysicalScalar(MReal(0.0), SI_COMPLIANCE)
    c[3,2] = PhysicalScalar(MReal(1.0), SI_COMPLIANCE)
    c[3,3] = PhysicalScalar(MReal(5.0), SI_COMPLIANCE)
    println(toString(c))
    println("det c = ", toString(det(c)))
    cInv = inv(c)
    println("c⁻¹ = \n", toString(cInv))
    println("c*c⁻¹ = \n", toString(c*cInv))
    println()
    println("Let ᴸ denote Lagrangian and ᴱ denote Eulerian.")
    println()
    println("A Gram-Schmidt factorization of the 3x3 matrix c produces:")
    (qL, r) = qr(c)
    println("Qᴸ from a QR (Gram-Schmidt) factorization of matrix c is")
    println(toString(qL))
    println("R from a QR (Gram-Schmidt) factorization of matrix c is")
    println(toString(r))
    println("whose product must return matrix c as a first check")
    println(toString(qL*r))
    println("while QᴸQᴸᵀ must return the identity matrix as a second check")
    println(toString(qL*transpose(qL)))
    println()
    println("Likewise, L from a LQ factorization of matrix c is")
    (l, qE) = lq(c)
    println(toString(l))
    println("whose associated orthogonal matrix Qᴱ is")
    println(toString(qE))
    println("whose product must return matrix c as a first check")
    println(toString(l*qE))
    println("while QᴱQᴱᵀ must return the identity matrix as a second check")
    println(toString(qE*transpose(qE)))
    println("Note that QᴱQᴸ = ")
    println(toString(qE*qL))
    println()
    println("A Gram-Schmidt factorization of a 2x2 matrix d:")
    d = newPhysicalTensor(2, 2, SI_COMPLIANCE)
    d[1,1] = c[1,1]
    d[1,2] = c[1,2]
    d[2,1] = c[2,1]
    d[2,2] = c[2,2]
    println("Matrix d has components:")
    println(toString(d))
    (qL, r) = qr(d)
    println("Qᴸ from a QR (Gram-Schmidt) factorization of matrix d is")
    println(toString(qL))
    println("R from a QR (Gram-Schmidt) factorization of matrix d is")
    println(toString(r))
    println("whose product must return matrix d as a first check")
    println(toString(qL*r))
    println("while QᴸQᴸᵀ must return the identity matrix as a second check")
    println(toString(qL*transpose(qL)))
    println()
    println("Likewise, L from a LQ factorization of matrix d is")
    (l, qE) = lq(d)
    println(toString(l))
    println("whose associated orthogonal matrix Qᴱ is")
    println(toString(qE))
    println("whose product must return matrix d as a first check")
    println(toString(l*qE))
    println("while QᴱQᴱᵀ must return the identity matrix as a second check")
    println(toString(qE*transpose(qE)))
    println("Note that QᴱQᴸ = ")
    println(toString(qE*qL))
    println()
    println("Testing the solution for a linear system of equations Ax = b")
    A = newPhysicalTensor(3, 3, SI_MASS)
    A[1,1] = PhysicalScalar(MReal(5), SI_MASS)
    A[1,2] = PhysicalScalar(MReal(3), SI_MASS)
    A[1,3] = PhysicalScalar(MReal(-1), SI_MASS)
    A[2,1] = PhysicalScalar(MReal(-2), SI_MASS)
    A[2,2] = PhysicalScalar(MReal(4), SI_MASS)
    A[2,3] = PhysicalScalar(MReal(1), SI_MASS)
    A[3,1] = PhysicalScalar(MReal(-4), SI_MASS)
    A[3,2] = PhysicalScalar(MReal(2), SI_MASS)
    A[3,3] = PhysicalScalar(MReal(6), SI_MASS)
    b = newPhysicalVector(3, SI_FORCE)
    b[1] = PhysicalScalar(MReal(7), SI_FORCE)
    b[2] = PhysicalScalar(MReal(3), SI_FORCE)
    b[3] = PhysicalScalar(MReal(4), SI_FORCE)
    x = A \ b
    println("where A = ")
    println(toString(A))
    println("and b = ")
    println(toString(b))
    println("has a solution of ")
    println(toString(x))
    println()
    println("Test type ArrayOfPhysicalTensors:")
    entries = 5
    rows = 2
    cols = 3
    m₁ = newPhysicalTensor(rows, cols, CENTIMETER)
    m₁[1,1] = PhysicalScalar(MReal(1), CENTIMETER)
    m₁[1,2] = PhysicalScalar(MReal(2), CENTIMETER)
    m₁[1,3] = PhysicalScalar(MReal(3), CENTIMETER)
    m₁[2,1] = PhysicalScalar(MReal(4), CENTIMETER)
    m₁[2,2] = PhysicalScalar(MReal(5), CENTIMETER)
    m₁[2,3] = PhysicalScalar(MReal(6), CENTIMETER)
    array = newArrayOfPhysicalTensors(entries, m₁)
    n = PhysicalScalar(MReal(6), CENTIMETER)
    one = PhysicalScalar(MReal(1), CENTIMETER)
    for i in 2:entries
        mᵢ = newPhysicalTensor(rows, cols, CENTIMETER)
        n = n + one
        mᵢ[1,1] = n
        n = n + one
        mᵢ[1,2] = n
        n = n + one
        mᵢ[1,3] = n
        n = n + one
        mᵢ[2,1] = n
        n = n + one
        mᵢ[2,2] = n
        n = n + one
        mᵢ[2,3] = n
        array[i] = mᵢ
    end
    println("This array of matrices has a length of ", string(array.e), ".")
    for i in 1:entries
        mᵢ = array[i]
        println("array[", string(i), "] = \n", toString(mᵢ))
    end
    array[3] = newPhysicalTensor(rows, cols, CENTIMETER)
    println("resetting the third entry to zeros, one has")
    println("array[3] = \n", toString(array[3]))
    println()
    println("If these answers make sense, then this test passes.")
    return nothing
end

end  # module testPhysicalTensors
