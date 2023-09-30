# PhysicalTensors

# Methods for testing the kind of system of units.

function isDimensionless(t::PhysicalTensor)::Bool
    return isDimensionless(t.units)
end

function isDimensionless(at::ArrayOfPhysicalTensors)::Bool
    return isDimensionless(at.units)
end

function isCGS(t::PhysicalTensor)::Bool
    return isCGS(t.units)
end

function isCGS(at::ArrayOfPhysicalTensors)::Bool
    return isCGS(at.units)
end

function isSI(t::PhysicalTensor)::Bool
    return isSI(t.units)
end

function isSI(at::ArrayOfPhysicalTensors)::Bool
    return isSI(at.units)
end

# Methods for converting between systems of units.

function toSI(t::PhysicalTensor)::PhysicalTensor
    if isSI(t)
        return t
    elseif isCGS(t)
        units = PhysicalUnits("SI", t.units.length, t.units.mass, t.units.amount_of_substance, t.units.time, t.units.temperature, t.units.electric_current, t.units.light_intensity)
        factor = 100.0^(-t.units.length) * 1000.0^(-t.units.mass)
        tensor = PhysicalTensor(t.matrix.rows, t.matrix.cols, units)
        for i in 1:t.matrix.rows
            for j in 1:t.matrix.cols
                tensor.matrix[i,j] = factor * t.matrix[i,j]
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
        units = PhysicalUnits("SI", at.units.length, at.units.mass, at.units.amount_of_substance, at.units.time, at.units.temperature, at.units.electric_current, at.units.light_intensity)
        factor = 100.0^(-at.units.length) * 1000.0^(-at.units.mass)
        tenArr = ArrayOfPhysicalTensors(at.array.pgs, at.array.rows, at.array.cols, units)
        for i in 1:at.array.pgs
            for j in 1:at.array.rows
                for k in 1:at.array.cols
                    tenArr.array[i,j,k] = factor * at.array[i,j,k]
                end
            end
        end
        return tenArr
    else
        msg = "Tensor arrays must be dimensionless or have CGS or SI units."
        throw(ErrorException(msg))
    end
end

function toCGS(t::PhysicalTensor)::PhysicalTensor
    if isDimensionless(t) || isCGS(t)
        return t
    elseif isSI(t)
        units = PhysicalUnits("CGS", t.units.length, t.units.mass, t.units.amount_of_substance, t.units.time, t.units.temperature, t.units.electric_current, t.units.light_intensity)
        factor = 100.0^t.units.length * 1000.0^t.units.mass
        tensor = PhysicalTensor(t.matrix.rows, t.matrix.cols, units)
        for i in 1:t.matrix.rows
            for j in 1:t.matrix.cols
                tensor.matrix[i,j] = factor * t.matrix[i,j]
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
        units = PhysicalUnits("CGS", at.units.length, at.units.mass, at.units.amount_of_substance, at.units.time, at.units.temperature, at.units.electric_current, at.units.light_intensity)
        factor = 100.0^at.units.length * 1000.0^at.units.mass
        tenArr = ArrayOfPhysicalTensors(at.array.pgs, at.array.rows, at.array.cols, units)
        for i in 1:at.array.pgs
            for j in 1:at.array.rows
                for k in 1:at.array.cols
                    tenArr.array[i,j,k] = factor * at.array[i,j,k]
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
    matrix = copy(y.matrix)
    units  = copy(y.units)
    return PhysicalTensor(matrix, units)
end

function Base.:(copy)(y::ArrayOfPhysicalTensors)::ArrayOfPhysicalTensors
    array = copy(y.array)
    units = copy(y.units)
    return ArrayOfPhysicalTensors(array, units)
end

function Base.:(deepcopy)(y::PhysicalTensor)::PhysicalTensor
    matrix = deepcopy(y.matrix)
    units  = deepcopy(y.units)
    return PhysicalTensor(matrix, units)
end

function Base.:(deepcopy)(y::ArrayOfPhysicalTensors)::ArrayOfPhysicalTensors
    array = deepcopy(y.array)
    units = deepcopy(y.units)
    return ArrayOfPhysicalTensors(array, units)
end

#=
--------------------------------------------------------------------------------
=#

# Overloaded these operators: logical: ==, ≠, ≈
#                             unary:   +, -
#                             binary:  +, -, *, /, \

function Base.:≠(y::PhysicalTensor, z::PhysicalTensor)::Bool
    if (y.matrix.rows ≠ z.matrix.rows) || (y.matrix.cols ≠ z.matrix.cols)
        return true
    end
    if areEquivalent(y.units, z.units)
        if ((isDimensionless(y) && isDimensionless(z)) ||
            (isCGS(y) && isCGS(z)) || (isSI(y) && isSI(z)))
            for i in 1:y.matrix.rows
                for j in 1:y.matrix.cols
                    if y.matrix[i,j] ≠ z.matrix[i,j]
                        return true
                    end
                end
            end
        elseif (isCGS(y) && isSI(z))
            w = toSI(y)
            for i in 1:z.matrix.rows
                for j in 1:z.matrix.cols
                    if w.matrix[i,j] ≠ z.matrix[i,j]
                        return true
                    end
                end
            end
        elseif (isSI(y) && isCGS(z))
            w = toSI(z)
            for i in 1:y.matrix.rows
                for j in 1:y.matrix.cols
                    if y.matrix[i,j] ≠ w.matrix[i,j]
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
    if (y.matrix.rows ≠ z.matrix.rows) || (y.matrix.cols ≠ z.matrix.cols)
        return false
    end
    if areEquivalent(y.units, z.units)
        if ((isDimensionless(y) && isDimensionless(z)) ||
            (isCGS(y) && isCGS(z)) || (isSI(y) && isSI(z)))
            for i in 1:y.matrix.rows
                for j in 1:y.matrix.cols
                    if !(y.matrix[i,j] ≈ z.matrix[i,j])
                        return false
                    end
                end
            end
        elseif (isCGS(y) && isSI(z))
            w = toSI(y)
            for i in 1:z.matrix.rows
                for j in 1:z.matrix.cols
                    if !(w.matrix[i,j] ≈ z.matrix[i,j])
                        return false
                    end
                end
            end
        elseif (isSI(y) && isCGS(z))
            w = toSI(z)
            for i in 1:y.matrix.rows
                for j in 1:y.matrix.cols
                    if !(y.matrix[i,j] ≈ w.matrix[i,j])
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
    return copy(y)
end

function Base.:-(y::PhysicalTensor)::PhysicalTensor
    tensor = PhysicalTensor(y.matrix.rows, y.matrix.cols, y.units)
    for i in 1:y.matrix.rows
        for j in 1:y.matrix.cols
            tensor[i,j] = -y[i,j]
        end
    end
    return tensor
end

function Base.:+(y::PhysicalTensor, z::PhysicalTensor)::PhysicalTensor
    if (y.matrix.rows ≠ z.matrix.rows) || (y.matrix.cols ≠ z.matrix.cols)
        msg = "Tensor addition requires their matrices to have the same dimensions."
        throw(DimensionMismatch(msg))
    end
    if areEquivalent(y.units, z.units)
        if ((isDimensionless(y) && isDimensionless(z)) ||
            (isCGS(y) && isCGS(z)) || (isSI(y) && isSI(z)))
            tensor = PhysicalTensor(y.matrix.rows, y.matrix.cols, y.units)
            for i in 1:y.matrix.rows
                for j in 1:y.matrix.cols
                    tensor[i,j] = y[i,j] + z[i,j]
                end
            end
        elseif (isCGS(y) && isSI(z))
            w = toSI(y)
            tensor = PhysicalTensor(z.matrix.rows, z.matrix.cols, z.units)
            for i in 1:z.matrix.rows
                for j in 1:z.matrix.cols
                    tensor[i,j] = w[i,j] + z[i,j]
                end
            end
        elseif (isSI(y) && isCGS(z))
            w = toSI(z)
            tensor = PhysicalTensor(y.matrix.rows, y.matrix.cols, y.units)
            for i in 1:y.matrix.rows
                for j in 1:y.matrix.cols
                    tensor[i,j] = y[i,j] + w[i,j]
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
    if (y.matrix.rows ≠ z.matrix.rows) || (y.matrix.cols ≠ z.matrix.cols)
        msg = "Tensor subtraction requires their matrices have the same dimensions."
        throw(DimensionMismatch(msg))
    end
    if areEquivalent(y.units, z.units)
        if ((isDimensionless(y) && isDimensionless(z)) ||
            (isCGS(y) && isCGS(z)) || (isSI(y) && isSI(z)))
            tensor = PhysicalTensor(y.matrix.rows, y.matrix.cols, y.units)
            for i in 1:y.matrix.rows
                for j in 1:y.matrix.cols
                    tensor[i,j] = y[i,j] - z[i,j]
                end
            end
        elseif (isCGS(y) && isSI(z))
            w = toSI(y)
            tensor = PhysicalTensor(z.matrix.rows, z.matrix.cols, z.units)
            for i in 1:z.matrix.rows
                for j in 1:z.matrix.cols
                    tensor[i,j] = w[i,j] - z[i,j]
                end
            end
        elseif (isSI(y) && isCGS(z))
            w = toSI(z)
            tensor = PhysicalTensor(y.matrix.rows, y.matrix.cols, y.units)
            for i in 1:y.matrix.rows
                for j in 1:y.matrix.cols
                    tensor[i,j] = y[i,j] - w[i,j]
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
    if y.matrix.cols ≠ z.matrix.rows
        msg = "Tensor multiplication requires the columns of the first"
        msg *= " tensor equal the rows of the second tensor."
        throw(DimensionMismatch(msg))
    end
    if ((isCGS(y) && isCGS(z)) || (isSI(y) && isSI(z)))
        units = y.units + z.units
        tensor = PhysicalTensor(y.matrix.rows, z.matrix.cols, units)
        for i in 1:y.matrix.rows
            for j in 1:z.matrix.cols
                scalar = PhysicalScalar(units)
                for k in 1:y.matrix.cols
                    scalar = scalar + y[i,k]*z[k,j]
                end
                tensor[i,j] = scalar
            end
        end
    elseif (isCGS(y) && isSI(z))
        w = toSI(y)
        units = w.units + z.units
        tensor = PhysicalTensor(w.matrix.rows, z.matrix.cols, units)
        for i in 1:w.matrix.rows
            for j in 1:z.matrix.cols
                scalar = PhysicalScalar(units)
                for k in 1:w.matrix.cols
                    scalar = scalar + w[i,k]*z[k,j]
                end
                tensor[i,j] = scalar
            end
        end
    elseif (isSI(y) && isCGS(z))
        w = toSI(z)
        units = y.units + w.units
        tensor = PhysicalTensor(y.matrix.rows, w.matrix.cols, units)
        for i in 1:y.matrix.rows
            for j in 1:w.matrix.cols
                scalar = PhysicalScalar(units)
                for k in 1:y.matrix.cols
                    scalar = scalar + y[i,k]*w[k,j]
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
    if y.matrix.cols ≠ z.vector.len
        msg = "Tensor-vector multiplication requires the columns of the"
        msg *= " tensor equals the length of the vector."
        throw(DimensionMismatch(msg))
    end
    if ((isCGS(y) && isCGS(z)) || (isSI(y) && isSI(z)))
        units = y.units + z.units
        vector = PhysicalVector(y.matrix.rows, units)
        for i in 1:y.matrix.rows
            scalar = PhysicalScalar(units)
            for j in 1:y.matrix.cols
                scalar = scalar + y[i,j]*z[j]
            end
            vector[i] = scalar
        end
    elseif (isCGS(y) && isSI(z))
        w = toSI(y)
        units = w.units + z.units
        vector = PhysicalVector(w.matrix.rows, units)
        for i in 1:w.matrix.rows
            scalar = PhysicalScalar(units)
            for j in 1:w.matrix.cols
                scalar = scalar + w[i,j]*z[j]
            end
            vector[i] = scalar
        end
    elseif (isSI(y) && isCGS(z))
        w = toSI(z)
        units = y.units + w.units
        vector = PhysicalVector(y.matrix.rows, units)
        for i in 1:y.matrix.rows
            scalar = PhysicalScalar(units)
            for j in 1:y.matrix.cols
                scalar = scalar + y[i,j]*w[j]
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
        units = y.units + z.units
        tensor = PhysicalTensor(z.matrix.rows, z.matrix.cols, units)
        for i in 1:z.matrix.rows
            for j in 1:z.matrix.cols
                tensor[i,j] = y * z[i,j]
            end
        end
    elseif (isCGS(y) && isSI(z))
        w = toSI(y)
        units = w.units + z.units
        tensor = PhysicalTensor(z.matrix.rows, z.matrix.cols, units)
        for i in 1:z.matrix.rows
            for j in 1:z.matrix.cols
                tensor[i,j] = w * z[i,j]
            end
        end
    elseif isSI(y) && isCGS(z)
        w = toSI(z)
        units = y.units + w.units
        tensor = PhysicalTensor(w.matrix.rows, w.matrix.cols, units)
        for i in 1:w.matrix.rows
            for j in 1:w.matrix.cols
                tensor[i,j] = y * w[i,j]
            end
        end
    else
        msg = "Scalars and tensors must be dimensionless or have CGS or SI units."
        throw(ErrorException(msg))
    end
    return tensor
end

function Base.:*(y::Union{Real,MNumber}, z::PhysicalTensor)::PhysicalTensor
    tensor = PhysicalTensor(z.matrix.rows, z.matrix.cols, z.units)
    for i in 1:z.matrix.rows
        for j in 1:z.matrix.cols
            tensor[i,j] = y * z[i,j]
        end
    end
    return tensor
end

function Base.:/(y::PhysicalTensor, z::PhysicalScalar)::PhysicalTensor
    if ((isCGS(y) && isCGS(z)) || (isSI(y) && isSI(z)))
        units = y.units - z.units
        tensor = PhysicalTensor(y.matrix.rows, y.matrix.cols, units)
        for i in 1:y.matrix.rows
            for j in 1:y.matrix.cols
                tensor[i,j] = y[i,j] / z
            end
        end
    elseif (isCGS(y) && isSI(z))
        w = toSI(y)
        units = w.units - z.units
        tensor = PhysicalTensor(w.matrix.rows, w.matrix.cols, units)
        for i in 1:w.matrix.rows
            for j in 1:w.matrix.cols
                tensor[i,j] = w[i,j] / z
            end
        end
    elseif (isSI(y) && isCGS(z))
        w = toSI(z)
        units = y.units - w.units
        tensor = PhysicalTensor(y.matrix.rows, y.matrix.cols, units)
        for i in 1:y.matrix.rows
            for j in 1:y.matrix.cols
                tensor[i,j] = y[i,j] / w
            end
        end
    else
        msg = "Scalars and tensors must be dimensionless or have CGS or SI units."
        throw(ErrorException(msg))
    end
    return tensor
end

function Base.:/(y::PhysicalTensor, z::Union{Real,MNumber})::PhysicalTensor
    tensor = PhysicalTensor(y.matrix.rows, y.matrix.cols, y.units)
    for i in 1:y.matrix.rows
        for j in 1:y.matrix.cols
            tensor[i,j] = y[i,j] / z
        end
    end
    return tensor
end

function Base.:\(A::PhysicalTensor, b::PhysicalVector)::PhysicalVector
    if A.matrix.rows ≠ b.vector.len
        msg = "Solving a linear system of equations 'Ax=b' for vector 'x' requires\n"
        msg *= "the number of rows in matrix 'A' equal the length of vector 'b'."
        throw(DimensionMismatch(msg))
    end
    if ((isCGS(A) && isCGS(b)) || (isSI(A) && isSI(b)))
        units  = b.units - A.units
        vector = A.matrix \ b.vector
    elseif (isCGS(A) && isSI(b))
        W = toSI(A)
        units  = b.units - W.units
        vector = W.matrix \ b.vector
    elseif (isSI(A) && isCGS(b))
        w = toSI(b)
        units  = w.units - A.units
        vector = A.matrix \ w.vector
    else
        msg = "Vectors and tensors must be dimensionless or have CGS or SI units."
        throw(ErrorException(msg))
    end
    x = PhysicalVector(vector, units)
    return x
end

#=
--------------------------------------------------------------------------------
=#

function toMatrix(t::PhysicalTensor)::Matrix{Float64}
    return Matrix(t.matrix)
end

function LinearAlgebra.:(norm)(t::PhysicalTensor, p::Real=2)::PhysicalScalar
    value = norm(t.matrix, p)
    units = t.units
    return PhysicalScalar(value, units)
end

function tensorProduct(y::PhysicalVector, z::PhysicalVector)::PhysicalTensor
    if ((isCGS(y) && isCGS(z)) || (isSI(y) && isSI(z)))
        units = y.units + z.units
        tensor = PhysicalTensor(y.vector.len, z.vector.len, units)
        for i in 1:y.vector.len
            for j in 1:z.vector.len
                tensor[i,j] = y[i] * z[j]
            end
        end
    elseif (isCGS(y) && isSI(z))
        w = toSI(y)
        units = w.units + z.units
        tensor = PhysicalTensor(w.vector.len, z.vector.len, units)
        for i in 1:w.vector.len
            for j in 1:z.vector.len
                tensor[i,j] = w[i] * z[j]
            end
        end
    elseif (isSI(y) && isCGS(z))
        w = toSI(z)
        units = y.units + w.units
        tensor = PhysicalTensor(y.vector.len, w.vector.len, units)
        for i in 1:y.vector.len
            for j in 1:w.vector.len
                tensor[i,j] = y[i] * w[j]
            end
        end
    else
        msg = "Vectors must be dimensionless or have CGS or SI units."
        throw(ErrorException(msg))
    end
    return tensor
end

function Base.:(transpose)(t::PhysicalTensor)::PhysicalTensor
    units  = t.units
    matrix = transpose(t.matrix)
    return PhysicalTensor(matrix, units)
end

function LinearAlgebra.:(tr)(t::PhysicalTensor)::PhysicalScalar
    units = t.units
    value = tr(t.matrix)
    return PhysicalScalar(value, units)
end

function LinearAlgebra.:(det)(t::PhysicalTensor)::PhysicalScalar
    units = t.units
    value = det(t.matrix)
    i = 2
    while i ≤ t.matrix.rows
        units = units + t.units
        i += 1
    end
    return PhysicalScalar(value, units)
end

function Base.:(inv)(t::PhysicalTensor)::PhysicalTensor
    units  = -t.units
    matrix = inv(t.matrix)
    return PhysicalTensor(matrix, units)
end

function qr(t::PhysicalTensor)::Tuple  # (Q, R) as instances of PhysicalTensor
    (Q, R) = qr(t.matrix)
    (rowsQ, colsQ) = size(Q)
    (rowsR, colsR) = size(R)
    if isSI(t)
        q = PhysicalTensor(rowsQ, colsQ, DIMENSIONLESS)
    else
        q = PhysicalTensor(rowsQ, colsQ, CGS_DIMENSIONLESS)
    end
    for i in 1:rowsQ
        for j in 1:colsQ
            q.matrix[i,j] = Q[i,j]
        end
    end
    r = PhysicalTensor(rowsR, colsR, t.units)
    for i in 1:rowsR
        for j in 1:colsR
            r.matrix[i,j] = R[i,j]
        end
    end
    return (q, r)
end

function lq(t::PhysicalTensor)::Tuple  # (L, Q) as instances of PhysicalTensor
    (L, Q) = lq(t.matrix)
    (rowsL, colsL) = size(L)
    (rowsQ, colsQ) = size(Q)
    l = PhysicalTensor(rowsL, colsL, t.units)
    for i in 1:rowsL
        for j in 1:colsL
            l.matrix[i,j] = L[i,j]
        end
    end
    if isSI(t)
        q = PhysicalTensor(rowsQ, colsQ, DIMENSIONLESS)
    else
        q = PhysicalTensor(rowsQ, colsQ, CGS_DIMENSIONLESS)
    end
    for i in 1:rowsQ
        for j in 1:colsQ
            q.matrix[i,j] = Q[i,j]
        end
    end
    return (l, q)
end
