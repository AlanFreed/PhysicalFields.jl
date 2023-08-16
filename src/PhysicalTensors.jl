# PhysicalTensors

# Methods for testing the kind of system of units.

function isDimensionless(t::PhysicalTensor)::Bool
    return isDimensionless(t.u)
end

function isDimensionless(at::ArrayOfPhysicalTensors)::Bool
    return isDimensionless(at.u)
end

function isCGS(t::PhysicalTensor)::Bool
    return isCGS(t.u)
end

function isCGS(at::ArrayOfPhysicalTensors)::Bool
    return isCGS(at.u)
end

function isSI(t::PhysicalTensor)::Bool
    return isSI(t.u)
end

function isSI(at::ArrayOfPhysicalTensors)::Bool
    return isSI(at.u)
end

# Methods for converting between systems of units.

function toCGS(t::PhysicalTensor)::PhysicalTensor
    if isDimensionless(t) || isCGS(t)
        return t
    elseif isSI(t)
        units = CGS(t.u.m, t.u.kg, t.u.s, t.u.K)
        tensor = PhysicalTensor(t.r, t.c, units)
        if (t.u == KELVIN)
            for i in 1:t.r
                for j in 1:t.c
                    tensor.m[i,j] = -273.15 + t.m[i,j]
                end
            end
        else
            for i in 1:t.r
                for j in 1:t.c
                    tensor.m[i,j] = (100.0^t.u.m * 1000.0^t.u.kg) * t.m[i,j]
                end
            end
        end
        return tensor
    else
        msg = "Tensors must be dimensionless or have CGS or SI units."
        throw(ErrorException(msg))
    end
end

function toCGS(at::ArrayOfPhysicalTensors)::ArrayOfPhysicalTensors
    if isDimensionless(at) || isCGS(at)
        return at
    elseif isSI(at)
        units = CGS(at.u.m, at.u.kg, at.u.s, at.u.K)
        pt₁ = PhysicalTensor(at.r, at.c, units)
        if (at.u == KELVIN)
            for i in 1:at.r
                for j in 1:at.c
                    pt₁.m[i,j] = -273.15 + at.a[1,i,j]
                end
            end
        else
            for i in 1:at.r
                for j in 1:at.c
                    pt₁.m[i,j] = (100.0^at.u.m * 1000.0^at.u.kg) * at.a[1,i,j]
                end
            end
        end
        tenArr = ArrayOfPhysicalTensors(at.e, at.r, at.c, units)
        if (at.u == KELVIN)
            for i in 2:at.e
                for j in 1:at.r
                    for k in 1:at.c
                        tenArr.a[i,j,k] = -273.15 + at.a[i,j,k]
                    end
                end
            end
        else
            for i in 2:at.e
                for j in 1:at.r
                    for k in 1:at.c
                        tenArr.a[i,j,k] = (100.0^at.u.m * 1000.0^at.u.kg) * at.a[i,j,k]
                    end
                end
            end
        end
        return tenArr
    else
        msg = "Tensor arrays must be dimensionless or have CGS or SI units."
        throw(ErrorException(msg))
    end
end

function toSI(t::PhysicalTensor)::PhysicalTensor
    if isSI(t)
        return t
    elseif isCGS(t)
        units = SI(t.u.cm, t.u.g, t.u.s, t.u.C)
        tensor = PhysicalTensor(t.r, t.c, units)
        if (t.u == CENTIGRADE)
            for i in 1:t.r
                for j in 1:t.c
                    tensor.m[i,j] = 273.15 + t.m[i,j]
                end
            end
        else
            for i in 1:t.r
                for j in 1:t.c
                    tensor.m[i,j] = (100.0^(-t.u.cm) * 1000.0^(-t.u.g)) * t.m[i,j]
                end
            end
        end
        return tensor
    else
        msg = "Tensors must be dimensionless or have CGS or SI units."
        throw(ErrorException(msg))
    end
end

function toSI(at::ArrayOfPhysicalTensors)::ArrayOfPhysicalTensors
    if isSI(at)
        return at
    elseif isCGS(at)
        units = SI(at.u.cm, at.u.g, at.u.s, at.u.C)
        pt₁ = PhysicalTensor(at.r, at.c, units)
        if (at.u == CENTIGRADE)
            for i in 1:at.r
                for j in 1:at.c
                    pt₁.m[i,j] = 273.15 + at.a[1,i,j]
                end
            end
        else
            for i in 1:at.r
                for j in 1:at.c
                    pt₁.m[i,j] = (100.0^(-at.u.cm) * 1000.0^(-at.u.g)) * at.a[1,i,j]
                end
            end
        end
        tenArr = ArrayOfPhysicalTensors(at.e, at.r, at.c, units)
        if (at.u == CENTIGRADE)
            for i in 2:at.e
                for j in 1:at.r
                    for k in 1:at.c
                        tenArr.a[i,j,k] = 273.15 + at.a[i,j,k]
                    end
                end
            end
        else
            for i in 2:at.e
                for j in 1:at.r
                    for k in 1:at.c
                        tenArr.a[i,j,k] = (100.0^(-at.u.cm) * 1000.0^(-at.u.g)) * at.a[i,j,k]
                    end
                end
            end
        end
        return tenArr
    else
        msg = "Tensor arrays must be dimensionless or have CGS or SI units."
        throw(ErrorException(msg))
    end
end

#=
--------------------------------------------------------------------------------
=#

function Base.:(copy)(y::PhysicalTensor)::PhysicalTensor
    rows    = copy(y.r)
    columns = copy(y.c)
    matrix  = copy(y.m)
    units   = copy(y.u)
    return PhysicalTensor(rows, columns, matrix, units)
end

function Base.:(copy)(y::ArrayOfPhysicalTensors)::ArrayOfPhysicalTensors
    entries = copy(y.e)
    rows    = copy(y.r)
    columns = copy(y.c)
    array   = copy(y.a)
    units   = copy(y.u)
    return ArrayOfPhysicalTensors(entries, rows, columns, array, units)
end

function Base.:(deepcopy)(y::PhysicalTensor)::PhysicalTensor
    rows    = deepcopy(y.r)
    columns = deepcopy(y.c)
    matrix  = deepcopy(y.m)
    units   = deepcopy(y.u)
    return PhysicalTensor(rows, columns, matrix, units)
end

function Base.:(deepcopy)(y::ArrayOfPhysicalTensors)::ArrayOfPhysicalTensors
    entries = deepcopy(y.e)
    rows    = deepcopy(y.r)
    columns = deepcopy(y.c)
    array   = deepcopy(y.a)
    units   = deepcopy(y.u)
    return ArrayOfPhysicalTensors(entries, rows, columns, array, units)
end

#=
--------------------------------------------------------------------------------
=#

# Overloaded these operators: logical: ==, ≠, ≈
#                             unary:   +, -
#                             binary:  +, -, *, /, \

function Base.:≠(y::PhysicalTensor, z::PhysicalTensor)::Bool
    if (y.r ≠ z.r) || (y.c ≠ z.c)
        return true
    end
    if areEquivalent(y.u, z.u)
        if ((isDimensionless(y) && isDimensionless(z)) ||
            (isCGS(y) && isCGS(z)) || (isSI(y) && isSI(z)))
            for i in 1:y.r
                for j in 1:y.c
                    if y.m[i,j] ≠ z.m[i,j]
                        return true
                    end
                end
            end
        elseif (isCGS(y) && isSI(z))
            w = toCGS(z)
            for i in 1:y.r
                for j in 1:y.c
                    if y.m[i,j] ≠ w.m[i,j]
                        return true
                    end
                end
            end
        elseif (isSI(y) && isCGS(z))
            w = toCGS(y)
            for i in 1:w.r
                for j in 1:w.c
                    if w.m[i,j] ≠ z.m[i,j]
                        return true
                    end
                end
            end
        else
            msg = "Tensors must be dimensionless or have CGS or SI units."
            throw(ErrorException(msg))
        end
    else
        return true
    end
    return false
end

function Base.:(==)(y::PhysicalTensor, z::PhysicalTensor)::Bool
    notEqual = (y ≠ z)
    return !notEqual
end

function Base.:≈(y::PhysicalTensor, z::PhysicalTensor)::Bool
    if (y.r ≠ z.r) || (y.c ≠ z.c)
        return false
    end
    if areEquivalent(y.u, z.u)
        if ((isDimensionless(y) && isDimensionless(z)) ||
            (isCGS(y) && isCGS(z)) || (isSI(y) && isSI(z)))
            for i in 1:y.r
                for j in 1:y.c
                    if !(y.m[i,j] ≈ z.m[i,j])
                        return false
                    end
                end
            end
        elseif (isCGS(y) && isSI(z))
            w = toCGS(z)
            for i in 1:y.r
                for j in 1:y.c
                    if !(y.m[i,j] ≈ w.m[i,j])
                        return false
                    end
                end
            end
        elseif (isSI(y) && isCGS(z))
            w = toCGS(y)
            for i in 1:w.r
                for j in 1:w.c
                    if !(w.m[i,j] ≈ z.m[i,j])
                        return false
                    end
                end
            end
        else
            msg = "Tensors must be dimensionless or have CGS or SI units."
            throw(ErrorException(msg))
        end
    else
        return false
    end
    return true
end

function Base.:+(y::PhysicalTensor)::PhysicalTensor
    tensor = PhysicalTensor(y.r, y.c, y.u)
    for i in 1:y.r
        for j in 1:y.c
            tensor[i,j] = +y[i,j]
        end
    end
    return tensor
end

function Base.:-(y::PhysicalTensor)::PhysicalTensor
    tensor = PhysicalTensor(y.r, y.c, y.u)
    for i in 1:y.r
        for j in 1:y.c
            tensor[i,j] = -y[i,j]
        end
    end
    return tensor
end

function Base.:+(y::PhysicalTensor, z::PhysicalTensor)::PhysicalTensor
    if (y.r ≠ z.r) || (y.c ≠ z.c)
        msg = "Tensor addition requires their matrices to have the same dimensions."
        throw(DimensionMismatch(msg))
    end
    if areEquivalent(y.u, z.u)
        if ((isDimensionless(y) && isDimensionless(z)) ||
            (isCGS(y) && isCGS(z)) || (isSI(y) && isSI(z)))
            tensor = PhysicalTensor(y.r, y.c, y.u)
            for i in 1:y.r
                for j in 1:y.c
                    tensor[i,j] = y[i,j] + z[i,j]
                end
            end
        elseif (isCGS(y) && isSI(z))
            w = toCGS(z)
            tensor = PhysicalTensor(y.r, y.c, y.u)
            for i in 1:y.r
                for j in 1:y.c
                    tensor[i,j] = y[i,j] + w[i,j]
                end
            end
        elseif (isSI(y) && isCGS(z))
            w = toCGS(y)
            tensor = PhysicalTensor(w.r, w.c, w.u)
            for i in 1:w.r
                for j in 1:w.c
                    tensor[i,j] = w[i,j] + z[i,j]
                end
            end
        else
            msg = "Tensors must be dimensionless or have CGS or SI units."
            throw(ErrorException(msg))
        end
    else
        msg = "Tensor addition requires tensors to have equivalent units."
        throw(ErrorException(msg))
    end
    return tensor
end

function Base.:-(y::PhysicalTensor, z::PhysicalTensor)::PhysicalTensor
    if (y.r ≠ z.r) || (y.c ≠ z.c)
        msg = "Tensor subtraction requires their matrices have the same dimensions."
        throw(DimensionMismatch(msg))
    end
    if areEquivalent(y.u, z.u)
        if ((isDimensionless(y) && isDimensionless(z)) ||
            (isCGS(y) && isCGS(z)) || (isSI(y) && isSI(z)))
            tensor = PhysicalTensor(y.r, y.c, y.u)
            for i in 1:y.r
                for j in 1:y.c
                    tensor[i,j] = y[i,j] - z[i,j]
                end
            end
        elseif (isCGS(y) && isSI(z))
            w = toCGS(z)
            tensor = PhysicalTensor(y.r, y.c, y.u)
            for i in 1:y.r
                for j in 1:y.c
                    tensor[i,j] = y[i,j] - w[i,j]
                end
            end
        elseif (isSI(y) && isCGS(z))
            w = toCGS(y)
            tensor = PhysicalTensor(w.r, w.c, w.u)
            for i in 1:w.r
                for j in 1:w.c
                    tensor[i,j] = w[i,j] - z[i,j]
                end
            end
        else
            msg = "Tensors must be dimensionless or have CGS or SI units."
            throw(ErrorException(msg))
        end
    else
        msg = "Tensor subtraction requires tensors to have equivalent units."
        throw(ErrorException(msg))
    end
    return tensor
end

function Base.:*(y::PhysicalTensor, z::PhysicalTensor)::PhysicalTensor
    if y.c ≠ z.r
        msg = "Tensor multiplication requires the columns of the first"
        msg *= " tensor equal the rows of the second tensor."
        throw(DimensionMismatch(msg))
    end
    if ((isCGS(y) && isCGS(z)) || (isSI(y) && isSI(z)))
        units = y.u + z.u
        tensor = PhysicalTensor(y.r, z.c, units)
        for i in 1:y.r
            for j in 1:z.c
                scalar = PhysicalScalar(units)
                for k in 1:y.c
                    scalar = scalar + y[i,k] * z[k,j]
                end
                tensor[i,j] = scalar
            end
        end
    elseif (isCGS(y) && isSI(z))
        w = toCGS(z)
        units = y.u + w.u
        tensor = PhysicalTensor(y.r, w.c, units)
        for i in 1:y.r
            for j in 1:w.c
                scalar = PhysicalScalar(units)
                for k in 1:y.c
                    scalar = scalar + y[i,k] * w[k,j]
                end
                tensor[i,j] = scalar
            end
        end
    elseif (isSI(y) && isCGS(z))
        w = toCGS(y)
        units = w.u + z.u
        tensor = PhysicalTensor(w.r, z.c, units)
        for i in 1:w.r
            for j in 1:z.c
                scalar = PhysicalScalar(units)
                for k in 1:w.c
                    scalar = scalar + w[i,k] * z[k,j]
                end
                tensor[i,j] = scalar
            end
        end
    else
        msg = "Tensors must be dimensionless or have CGS or SI units."
        throw(ErrorException(msg))
    end
    return tensor
end

function Base.:*(y::PhysicalTensor, z::PhysicalVector)::PhysicalVector
    if y.c ≠ z.l
        msg = "Tensor-vector multiplication requires the columns of the"
        msg *= " tensor equals the length of the vector."
        throw(DimensionMismatch(msg))
    end
    if ((isCGS(y) && isCGS(z)) || (isSI(y) && isSI(z)))
        units = y.u + z.u
        vector = PhysicalVector(y.r, units)
        for i in 1:y.r
            scalar = PhysicalScalar(units)
            for j in 1:y.c
                scalar = scalar + y[i,j] * z[j]
            end
            vector[i] = scalar
        end
    elseif (isCGS(y) && isSI(z))
        w = toCGS(z)
        units = y.u + w.u
        vector = PhysicalVector(y.r, units)
        for i in 1:y.r
            scalar = PhysicalScalar(units)
            for j in 1:y.c
                scalar = scalar + y[i,j] * w[j]
            end
            vector[i] = scalar
        end
    elseif (isSI(y) && isCGS(z))
        w = toCGS(y)
        units = w.u + z.u
        vector = PhysicalVector(w.r, units)
        for i in 1:w.r
            scalar = PhysicalScalar(units)
            for j in 1:y.c
                scalar = scalar + w[i,j] * z[j]
            end
            vector[i] = scalar
        end
    else
        msg = "Vectors and tensors must be dimensionless or have CGS or SI units."
        throw(ErrorException(msg))
    end
    return vector
end

function Base.:*(y::PhysicalScalar, z::PhysicalTensor)::PhysicalTensor
    if ((isCGS(y) && isCGS(z)) || (isSI(y) && isSI(z)))
        units = y.u + z.u
        tensor = PhysicalTensor(z.r, z.c, units)
        for i in 1:z.r
            for j in 1:z.c
                tensor[i,j] = y * z[i,j]
            end
        end
    elseif (isCGS(y) && isSI(z))
        w = toCGS(z)
        units = y.u + w.u
        tensor = PhysicalTensor(w.r, w.c, units)
        for i in 1:w.r
            for j in 1:w.c
                tensor[i,j] = y * w[i,j]
            end
        end
    elseif isSI(y) && isCGS(z)
        w = toCGS(y)
        units = w.u + z.u
        tensor = PhysicalTensor(z.r, z.c, units)
        for i in 1:z.r
            for j in 1:z.c
                tensor[i,j] = w * z[i,j]
            end
        end
    else
        msg = "Scalars and tensors must be dimensionless or have CGS or SI units."
        throw(ErrorException(msg))
    end
    return tensor
end

function Base.:*(y::Union{Real,MNumber}, z::PhysicalTensor)::PhysicalTensor
    tensor = PhysicalTensor(z.r, z.c, z.u)
    for i in 1:z.r
        for j in 1:z.c
            tensor[i,j] = y * z[i,j]
        end
    end
    return tensor
end

function Base.:/(y::PhysicalTensor, z::PhysicalScalar)::PhysicalTensor
    if ((isCGS(y) && isCGS(z)) || (isSI(y) && isSI(z)))
        units = y.u - z.u
        tensor = PhysicalTensor(y.r, y.c, units)
        for i in 1:y.r
            for j in 1:y.c
                tensor[i,j] = y[i,j] / z
            end
        end
    elseif (isCGS(y) && isSI(z))
        w = toCGS(z)
        units = y.u - w.u
        tensor = PhysicalTensor(y.r, y.c, units)
        for i in 1:y.r
            for j in 1:y.c
                tensor[i,j] = y[i,j] / w
            end
        end
    elseif (isSI(y) && isCGS(z))
        w = toCGS(y)
        units = w.u - z.u
        tensor = PhysicalTensor(w.r, w.c, units)
        for i in 1:w.r
            for j in 1:w.c
                tensor[i,j] = w[i,j] / z
            end
        end
    else
        msg = "Scalars and tensors must be dimensionless or have CGS or SI units."
        throw(ErrorException(msg))
    end
    return tensor
end

function Base.:/(y::PhysicalTensor, z::Union{Real,MNumber})::PhysicalTensor
    tensor = PhysicalTensor(y.r, y.c, y.u)
    for i in 1:y.r
        for j in 1:y.c
            tensor[i,j] = y[i,j] / z
        end
    end
    return tensor
end

function Base.:\(A::PhysicalTensor, b::PhysicalVector)::PhysicalVector
    if A.r ≠ b.l
        msg = "Solving a linear system of equations 'Ax=b' for vector 'x' requires\n"
        msg *= "the number of rows in matrix 'A' equal the length of vector 'b'."
        throw(DimensionMismatch(msg))
    end
    if ((isCGS(A) && isCGS(b)) || (isSI(A) && isSI(b)))
        units = b.u - A.u
        vector = A.m \ b.v
    elseif (isCGS(A) && isSI(b))
        w = toCGS(b)
        units = w.u - A.u
        vector = A.m \ w.v
    elseif (isSI(A) && isCGS(b))
        W = toCGS(A)
        units = b.u - W.u
        vector = W.m \ b.v
    else
        msg = "Vectors and tensors must be dimensionless or have CGS or SI units."
        throw(ErrorException(msg))
    end
    x = PhysicalVector(length(vector), units)
    for i in 1:x.l
        x.v[i] = vector[i]
    end
    return x
end

#=
--------------------------------------------------------------------------------
=#

function toMatrix(t::PhysicalTensor)::Matrix
    return deepcopy(t.m)
end

function LinearAlgebra.:(norm)(t::PhysicalTensor, p::Real=2)::PhysicalScalar
    value = norm(t.m, p)
    units = t.u
    return PhysicalScalar(value, units)
end

function tensorProduct(y::PhysicalVector, z::PhysicalVector)::PhysicalTensor
    if ((isCGS(y) && isCGS(z)) || (isSI(y) && isSI(z)))
        units = y.u + z.u
        tensor = PhysicalTensor(y.l, z.l, units)
        for i in 1:y.l
            for j in 1:z.l
                tensor[i,j] = y[i] * z[j]
            end
        end
    elseif (isCGS(y) && isSI(z))
        w = toCGS(z)
        units = y.u + w.u
        tensor = PhysicalTensor(y.l, w.l, units)
        for i in 1:y.l
            for j in 1:w.l
                tensor[i,j] = y[i] * w[j]
            end
        end
    elseif (isSI(y) && isCGS(z))
        w = toCGS(y)
        units = w.u + z.u
        tensor = PhysicalTensor(w.l, z.l, units)
        for i in 1:w.l
            for j in 1:z.l
                tensor[i,j] = w[i] * z[j]
            end
        end
    else
        msg = "Vectors must be dimensionless or have CGS or SI units."
        throw(ErrorException(msg))
    end
    return tensor
end

function Base.:(transpose)(t::PhysicalTensor)::PhysicalTensor
    units = t.u
    array = zeros(Float64, t.c, t.r)
    for i in 1:t.r
        for j in 1:t.c
            array[j,i] = t.m[i,j]
        end
    end
    return PhysicalTensor(t.c, t.r, array, units)
end

function LinearAlgebra.:(tr)(t::PhysicalTensor)::PhysicalScalar
    value = tr(t.m)
    units = t.u
    return PhysicalScalar(value, units)
end

function LinearAlgebra.:(det)(t::PhysicalTensor)::PhysicalScalar
    value = det(t.m)
    units = t.u
    i = 2
    while i ≤ t.r
        units = units + t.u
        i += 1
    end
    return PhysicalScalar(value, units)
end

function Base.:(inv)(t::PhysicalTensor)::PhysicalTensor
    matrix = inv(t.m)
    units  = -t.u
    (rows, cols) = size(matrix)
    tInv = PhysicalTensor(rows, cols, units)
    for i in 1:rows
        for j in 1:cols
            tInv.m[i,j] = matrix[i,j]
        end
    end
    return tInv
end

function LinearAlgebra.:(qr)(t::PhysicalTensor)::Tuple
    if ((t.r == 2) && (t.c == 2))
        f1 =[t.m[1,1], t.m[2,1]]
        f2 = [t.m[1,2], t.m[2,2]]
        mag = sqrt(f1[1]^2 + f1[2]^2)
        e1 = [f1[1]/mag, f1[2]/mag]
        e1dotf1 = e1[1] * f1[1] + e1[2] * f1[2]
        e1dotf2 = e1[1] * f2[1] + e1[2] * f2[2]
        x = f2[1] - e1dotf2 * e1[1]
        y = f2[2] - e1dotf2 * e1[2]
        mag = sqrt(x^2 + y^2)
        e2 = [x/mag, y/mag]
        e2dotf2 = e2[1] * f2[1] + e2[2] * f2[2]
        q = PhysicalTensor(2, 2, Dimensionless())
        for i in 1:2
            q.m[i,1] = e1[i]
            q.m[i,2] = e2[i]
        end
        r = PhysicalTensor(2, 2, t.u)
        r.m[1,1] = e1dotf1
        r.m[1,2] = e1dotf2
        r.m[2,2] = e2dotf2
    elseif ((t.r == 3) && (t.c == 3))
        f1 = [t.m[1,1], t.m[2,1], t.m[3,1]]
        f2 = [t.m[1,2], t.m[2,2], t.m[3,2]]
        f3 = [t.m[1,3], t.m[2,3], t.m[3,3]]
        mag = sqrt(f1[1]^2 + f1[2]^2 + f1[3]^2)
        e1 = [f1[1]/mag, f1[2]/mag, f1[3]/mag]
        e1dotf1 = e1[1] * f1[1] + e1[2] * f1[2] + e1[3] * f1[3]
        e1dotf2 = e1[1] * f2[1] + e1[2] * f2[2] + e1[3] * f2[3]
        e1dotf3 = e1[1] * f3[1] + e1[2] * f3[2] + e1[3] * f3[3]
        x = f2[1] - e1dotf2 * e1[1]
        y = f2[2] - e1dotf2 * e1[2]
        z = f2[3] - e1dotf2 * e1[3]
        mag = sqrt(x^2 + y^2 + z^2)
        e2 = [x/mag, y/mag, z/mag]
        e2dotf2 = e2[1] * f2[1] + e2[2] * f2[2] + e2[3] * f2[3]
        e2dotf3 = e2[1] * f3[1] + e2[2] * f3[2] + e2[3] * f3[3]
        x = f3[1] - e1dotf3 * e1[1] - e2dotf3 * e2[1]
        y = f3[2] - e1dotf3 * e1[2] - e2dotf3 * e2[2]
        z = f3[3] - e1dotf3 * e1[3] - e2dotf3 * e2[3]
        mag = sqrt(x^2 + y^2 + z^2)
        e3 = [x/mag, y/mag, z/mag]
        e3dotf3 = e3[1] * f3[1] + e3[2] * f3[2] + e3[3] * f3[3]
        q = PhysicalTensor(3, 3, Dimensionless())
        for i in 1:3
            q.m[i,1] = e1[i]
            q.m[i,2] = e2[i]
            q.m[i,3] = e3[i]
        end
        r = PhysicalTensor(3, 3, t.u)
        r.m[1,1] = e1dotf1
        r.m[1,2] = e1dotf2
        r.m[1,3] = e1dotf3
        r.m[2,2] = e2dotf2
        r.m[2,3] = e2dotf3
        r.m[3,3] = e3dotf3
    else
        (Q, R) = qr(t.m)
        (rowsQ, colsQ) = size(Q)
        (rowsR, colsR) = size(R)
        q = PhysicalTensor(rowsQ, colsQ, Dimensionless())
        for i in 1:rowsQ
            for j in 1:colsQ
                q.m[i,j] = Q[i,j]
            end
        end
        r = PhysicalTensor(rowsR, colsR, t.u)
        for i in 1:rowsR
            for j in 1:colsR
                r.m[i,j] = R[i,j]
            end
        end
    end
    return (q, r)
end

function LinearAlgebra.:(lq)(y::PhysicalTensor)::Tuple
    yᵀ = transpose(y)
    (qᵀ, lᵀ) = qr(yᵀ)
    l = transpose(lᵀ)
    q = transpose(qᵀ)
    return (l, q)
end
