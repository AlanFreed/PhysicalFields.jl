module testMutable

using
    ..PhysicalFields

export run

function run()
    println("This program tests mutable objects to ensure they are mutable.")
    println()
    println("Test MBoolean:")
    println()
    t = MBoolean(true)
    f = MBoolean()
    println("Given that")
    println("    t  is ", toString(get(t)))
    println("    f  is ", toString(f))
    println("it follows that")
    println("    !f     is ", toString(!f))
    println("    t == f is ", toString(t==f))
    println("    t ≠ f  is ", toString(t≠f))
    println("with the copy functions giving")
    println("copy(f)     = ", toString(copy(f)))
    println("Reassigning the mutable boolean in t to be false gives")
    set!(t, false)
    println("    t  is ", toString(t))
    println()
    println("Test MInteger:")
    println()
    i = MInteger(-2)
    j = MInteger(3)
    println("Given that")
    println("    i  = ", toString(get(i)))
    println("    j  = ", toString(j))
    println("the following logical operators return")
    println("    i == j is ", toString(i==j))
    println("    i ≠ j  is ", toString(i≠j))
    println("    i < j  is ", toString(i<j))
    println("    i ≤ j  is ", toString(i≤j))
    println("    i > j  is ", toString(i>j))
    println("    i ≥ j  is ", toString(i≥j))
    println("while the arithmatic operators return")
    println("    +i     = ", toString(+i))
    println("    -i     = ", toString(-i))
    println("    i + j  = ", toString(i+j))
    println("    i - j  = ", toString(i-j))
    println("    2j     = ", toString(2j))
    println("    i * j  = ", toString(i*j))
    println("    j ÷ i  = ", toString(j÷i))
    println("    j % i  = ", toString(j%i))
    println("    i ^ j  = ", toString(i^j))
    println("Reassigning j to be -3 gives")
    set!(j, -get(j))
    println("    j      = ", toString(j))
    println("The functions pertaining to mutable integers include:")
    println("    copy(j)     = ", toString(copy(j)))
    println("    abs(i)      = ", toString(abs(i)))
    println("    sign(i)     = ", toString(sign(i)))
    println()
    println("Test MReal:")
    println()
    x = MReal(-3.0)
    y = MReal(2.0)
    format = 'E'
    precision = 6
    aligned = true
    println("Given that")
    println("    x  = ", toString(get(x)))
    println("    y  = ", toString(y))
    println("    2y = ", toString(2y))
    println("the following logical operators return")
    println("    x == y is ", toString(x==y))
    println("    x ≠ y  is ", toString(x≠y))
    println("    x < y  is ", toString(x<y))
    println("    x ≤ y  is ", toString(x≤y))
    println("    x > y  is ", toString(x>y))
    println("    x ≥ y  is ", toString(x≥y))
    println("with approximately equal returning")
    println("    x ≈ y  is ", toString(x≈y))
    z = 2.000000001
    println("for z = ", string(z))
    println("    y ≈ z  is ", toString(y≈z))
    println("while the arithmatic operators return")
    println("    +x    = ", toString(+x))
    println("    -x    = ", toString(-x))
    println("    x + y = ", toString(x+y))
    println("    x - y = ", toString(x-y))
    println("    x * y = ", toString(x*y))
    println("    x / y = ", toString(x/y))
    println("    x ^ y = ", toString(x^y))
    println("Now we verify the functions using  z = -y/x")
    z = MReal(0.0)
    set!(z, -y/x)
    println("copy(z)     = ", toString(copy(z)))
    println("abs(z)      = ", toString(abs(z)))
    println("sign(z)     = ", toString(sign(z)))
    println("round(2z)   = ", toString(round(2z)))
    println("floor(2z)   = ", toString(floor(2z)))
    println("ceil(2z)    = ", toString(ceil(2z)))
    println("the trigonometric functions are:")
    println("sin(z) = ", toString(sin(z)))
    println("cos(z) = ", toString(cos(z)))
    println("tan(z) = ", toString(tan(z)))
    println("where")
    println("asin(sin(z)) = ", toString(asin(sin(z))))
    println("acos(cos(z)) = ", toString(acos(cos(z))))
    println("atan(tan(z)) = ", toString(atan(tan(z))))
    println("while")
    println("atan(y, x) = ", toString(atan(y, x)))
    println("the hyperbolic functions are:")
    println("sinh(z) = ", toString(sinh(z)))
    println("cosh(z) = ", toString(cosh(z)))
    println("tanh(z) = ", toString(tanh(z)))
    println("where")
    println("asinh(sinh(z)) = ", toString(asinh(sinh(z))))
    println("acosh(cosh(z)) = ", toString(acosh(cosh(z))))
    println("atanh(tanh(z)) = ", toString(atanh(tanh(z))))
    println("while the logarithmic and exponential functions are:")
    println("log(z)   = ", toString(log(z)))
    println("log2(z)  = ", toString(log2(z)))
    println("log10(z) = ", toString(log10(z)))
    println("exp(z)   = ", toString(exp(z)))
    println("exp2(z)  = ", toString(exp2(z)))
    println("exp10(z) = ", toString(exp10(z)))
    println("where")
    println("log(exp(z))     = ", toString(log(exp(z))))
    println("log2(exp2(z))   = ", toString(log2(exp2(z))))
    println("log10(exp10(z)) = ", toString(log10(exp10(z))))
    println("and the square root gives:")
    println("sqrt(z)   = ", toString(sqrt(z)))
    println("with")
    println("sqrt(z)^2 = ", toString(sqrt(z)^2))
    println()
    println("Test MVector:")
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
    println("Test MMatrix:")
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
    c = MMatrix([3.0 2.0 9.0; -3.0 5.0 -1.0; 0.0 1.0 15.0])
    println()
    println("Given the 3×3 mutable matrix c =")
    println(toString(c))
    println("then a Gram-Schmidt factorization of c produces:")
    (qL, r) = PhysicalFields.qr(c)
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
    println("Test MArray:")
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
    println("If these answers make sense, then this test passes.")
    return nothing
end # run

end # testMutable
