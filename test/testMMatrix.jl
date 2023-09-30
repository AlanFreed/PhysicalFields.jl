module testMMatrix

using
    ..PhysicalFields

export run

function run(at_dir::String)
    println("These program tests mutable matrices.")
    println()
    println("First we test its three constructors.")
    mi = Matrix{Float64}(undef, 2, 3)
    mi[1,1] = 1.0
    mi[1,2] = 2.0
    mi[1,3] = 3.0
    mi[2,1] = 4.0
    mi[2,2] = 5.0
    mi[2,3] = 6.0
    vi = vec(mi)
    mj = Matrix{Float64}(undef, 2, 2)
    mj[1,1] = -1.0
    mj[1,2] = -5.0
    mj[2,1] = -3.0
    mj[2,2] = -4.0
    vj = vec(mj)
    mk = Matrix{Float64}(undef, 2, 2)
    mk[1,1] = 1.0
    mk[1,2] = 2.0
    mk[2,1] = 3.0
    mk[2,2] = 4.0
    vk = vec(mk)
    m₁ = MMatrix(2,3)
    m₂ = MMatrix(mj)
    m₃ = MMatrix(2, 2, vk)
    println("The matrix constructed from its dimensions returns zeros.")
    println("   m₁ = ")
    println(toString(m₁))
    for i in 1:2
        for j in 1:3
            m₁[i,j] = mi[i,j]
        end
    end
    println("that are then reassigned values of")
    println("   m₁ = ")
    println(toString(m₁))
    println("whose second row vector is m₁[2] = ", toString(m₁[2]), ".")
    println("A matrix constructed from assigned matrix [-1 -5; -3 -4] returns")
    println("   m₂ = ")
    println(toString(m₂))
    println("while a 2×2 matrix with column vector values of {1, 3, 2, 4}ᵀ returns")
    println("   m₃ = ")
    println(toString(m₃))
    println("The logical functions return")
    println("    m₁ == m₂ is ", toString(m₁==m₂))
    println("    m₁ ≠ m₂  is ", toString(m₁≠m₂))
    println("    m₁ ≈ m₂  is ", toString(m₁≈m₂))
    println("while the arithmatic operators return")
    println("    +m₂ = ")
    println(toString(+m₂))
    println("    -m₂ = ")
    println(toString(-m₂))
    println("    m₂ + m₃ = ")
    println(toString(m₂+m₃))
    println("    m₂ - m₃ = ")
    println(toString(m₂-m₃))
    println("    m₂ * m₃ = ")
    println(toString(m₂*m₃))
    println("With a real of x = 3.0, one gets scalar multiplications")
    x = 3.0
    println("    x * m₁ = ")
    println(toString(x*m₁))
    println("    m₁ / x  = ")
    println(toString(m₁/x))
    println("and with a vector of v = {-6, -7}ᵀ, one gets matrix/vector multiplications")
    v = Vector{Float64}(undef, 2)
    v[1] = -6.0
    v[2] = -7.0
    mv = MVector(2, v)
    println("    m₂ * v = ", toString(m₂*mv))
    println("    m₂ 'backslash' v = ", toString(m₂\mv))
    println("Matrix functions include")
    println("    ||m₃||  = ", toString(norm(m₃)))
    println("    tr(m₃)  = ", toString(tr(m₃)))
    println("    det(m₃) = ", toString(det(m₃)))
    println("    m₁ᵀ = ")
    println(toString(transpose(m₁)))
    println("    m₃⁻¹ = ")
    m₃⁻¹ = inv(m₃)
    println(toString(m₃⁻¹))
    println("    with verification m₃⁻¹*m₃ = ")
    println(toString(m₃⁻¹*m₃))
    println()
    println("Let ᴸ denote Lagrangian and ᴱ denote Eulerian,")
    c = MMatrix([3.0 2.0 1.0; -3.0 5.0 -1.0; 0.0 1.0 5.0])
    println()
    println("Given the 3×3 mutable matrix c =")
    println(toString(c))
    println("then a Gram-Schmidt factorization of c produces:")
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
    println("Note that QᴱQᴸ ≠ I; it orthogonal with components ")
    println(toString(qE*qL))
    Qᴸ = qL
    println()
    println("Now, consider a Gram-Schmidt factorization of a 2x2 matrix d:")
    d = MMatrix(2, 2)
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
    println("Note that QᴱQᴸ ≠ I; it orthogonal with components ")
    println(toString(qE*qL))
    println()
    println("Finally, we test the matrix product.")
    v₁ = MVector(3)
    v₁[1] = 1.0
    v₁[2] = 2.0
    v₁[3] = 3.0
    v₂ = MVector(2)
    v₂[1] = -1.0
    v₂[2] = 1.0
    println("Given vector v₁ = ", toString(v₁))
    println("  and vector v₂ = ", toString(v₂))
    println("v₁ ⊗ v₂ = ")
    println(toString(matrixProduct(v₁, v₂)))
    println()
    println("Now we test writing/reading mutable matrices to/from a file.")
    println()
    my_dir_path = string(at_dir, "/test/files/")
    json_stream = openJSONWriter(my_dir_path, "testMMatrix.json")
    toFile(Qᴸ, json_stream)
    toFile(c, json_stream)
    close(json_stream)
    json_stream = openJSONReader(my_dir_path, "testMMatrix.json")
    r₁ = fromFile(Matrix{Float64}, json_stream)
    println("An instance of type Matrix.")
    println("   It should read as: ")
    println(toString(Qᴸ))
    println("   It reads as:")
    println(toString(r₁))
    r₂ = fromFile(MMatrix, json_stream)
    println("An instance of type MMatrix.")
    println("   It should read as:")
    println(toString(c))
    println("   It reads as:")
    println(toString(r₂))
    close(json_stream)
    println()
    println("To verify that a read-in matrix is mutable,")
    println("reassign matrix")
    println(toString(r₁))
    println("so that it reads")
    println(toString(r₂))
    for i in 1:3
        for j in 1:3
            r₁[i,j] = r₂[i,j]
        end
    end
    println("It now reads as:")
    println(toString(r₁))
    println()
    println("If these answers make sense, then this test passes.")
    return nothing
end  # function run

end  # module testMMatrix