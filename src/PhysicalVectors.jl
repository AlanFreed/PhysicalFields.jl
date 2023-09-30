# PhysicalVectors

# Methods for testing the kind of system of units.

function isDimensionless(v::PhysicalVector)::Bool
    return isDimensionless(v.units)
end

function isDimensionless(av::ArrayOfPhysicalVectors)::Bool
    return isDimensionless(av.units)
end

function isSI(v::PhysicalVector)::Bool
    return isSI(v.units)
end

function isSI(av::ArrayOfPhysicalVectors)::Bool
    return isSI(av.units)
end

function isCGS(v::PhysicalVector)::Bool
    return isCGS(v.units)
end

function isCGS(av::ArrayOfPhysicalVectors)::Bool
    return isCGS(av.units)
end

# Methods for converting between systems of units.

function toSI(v::PhysicalVector)::PhysicalVector
    if isDimensionless(v) || isSI(v)
        return v
    elseif isCGS(v)
        units = PhysicalUnits("SI", v.units.length, v.units.mass, v.units.amount_of_substance, v.units.time, v.units.temperature, v.units.electric_current, v.units.light_intensity)
        factor = 100.0^(-v.units.length) * 1000.0^(-v.units.mass)
        vector = PhysicalVector(v.vector.len, units)
        for i in 1:v.vector.len
            vector.vector[i] = factor * v.vector[i]
        end
        return vector
    else
        msg = "Vectors must be dimensionless or have either CGS or SI units."
        throw(ErrorException(msg))
    end
end

function toSI(av::ArrayOfPhysicalVectors)::ArrayOfPhysicalVectors
    if isDimensionless(av) || isSI(av)
        return av
    elseif isCGS(av)
        units = PhysicalUnits("SI", av.units.length, av.units.mass, av.units.amount_of_substance, av.units.time, av.units.temperature, av.units.electric_current, av.units.light_intensity)
        factor = 100.0^(-av.units.length) * 1000.0^(-av.units.mass)
        vecArr = ArrayOfPhysicalVectors(av.matrix.rows, av.matrix.cols, units)
        for i in 1:av.matrix.rows
            for j in 1:av.matrix.cols
                vecArr.array[i,j] = factor * av.array[i,j]
            end
        end
        return vecArr
    else
        msg = "Vector arrays must be dimensionless or have CGS or SI units."
        throw(ErrorException(msg))
    end
end

function toCGS(v::PhysicalVector)::PhysicalVector
    if isDimensionless(v) || isCGS(v)
        return v
    elseif isSI(v)
        units = PhysicalUnits("CGS", v.units.length, v.units.mass, v.units.amount_of_substance, v.units.time, v.units.temperature, v.units.electric_current, v.units.light_intensity)
        factor = 100.0^v.units.length * 1000.0^v.units.mass
        vector = PhysicalVector(v.vector.len, units)
        for i in 1:v.vector.len
            vector.vector[i] = factor * v.vector[i]
        end
        return vector
    else
        msg = "Vectors must be dimensionless or have either CGS or SI units."
        throw(ErrorException(msg))
    end
end

function toCGS(av::ArrayOfPhysicalVectors)::ArrayOfPhysicalVectors
    if isDimensionless(av) || isCGS(av)
        return av
    elseif isSI(av)
        units = PhysicalUnits("CGS", av.units.length, av.units.mass, av.units.amount_of_substance, av.units.time, av.units.temperature, av.units.electric_current, av.units.light_intensity)
        factor = 100.0^av.units.length * 1000.0^av.units.mass
        vecArr = ArrayOfPhysicalVectors(av.matrix.rows, av.matrix.cols, units)
        for i in 1:av.matrix.rows
            for j in 1:av.matrix.cols
                vecArr.array[i,j] = factor * av.array[i,j]
            end
        end
        return vecArr
    else
        msg = "Vector arrays must be dimensionless or have CGS or SI units."
        throw(ErrorException(msg))
    end
end

#=
--------------------------------------------------------------------------------
=#

function Base.:(copy)(y::PhysicalVector)::PhysicalVector
    vector = copy(y.vector)
    units  = copy(y.units)
    return PhysicalVector(vector, units)
end

function Base.:(copy)(y::ArrayOfPhysicalVectors)::ArrayOfPhysicalVectors
    array   = copy(y.array)
    units   = copy(y.units)
    return ArrayOfPhysicalVectors(array, units)
end

function Base.:(deepcopy)(y::PhysicalVector)::PhysicalVector
    vector = deepcopy(y.vector)
    units  = deepcopy(y.units)
    return PhysicalVector(vector, units)
end

function Base.:(deepcopy)(y::ArrayOfPhysicalVectors)::ArrayOfPhysicalVectors
    array   = deepcopy(y.array)
    units   = deepcopy(y.units)
    return ArrayOfPhysicalVectors(array, units)
end

#=
--------------------------------------------------------------------------------
=#

# Overloaded these operators: logical: ==, ≠, ≈
#                             unary:   +, -
#                             binary:  +, -, *, /

function Base.:≠(y::PhysicalVector, z::PhysicalVector)::Bool
    if y.vector.len ≠ z.vector.len
        return true
    end
    if areEquivalent(y.units, z.units)
        if ((isDimensionless(y) && isDimensionless(z)) ||
            (isCGS(y) && isCGS(z)) || (isSI(y) && isSI(z)))
            for i in 1:y.vector.len
                if y.vector[i] ≠ z.vector[i]
                    return true
                end
            end
        elseif (isCGS(y) && isSI(z))
            w = toSI(y)
            for i in 1:z.vector.len
                if w.vector[i] ≠ z.vector[i]
                    return true
                end
            end
        elseif (isSI(y) && isCGS(z))
            w = toSI(z)
            for i in 1:y.vector.len
                if y.vector[i] ≠ w.vector[i]
                    return true
                end
            end
        else
            msg = "Vectors must be dimensionless or have either CGS or SI units."
            throw(ErrorException(msg))
        end
    else
        return true
    end
    return false
end

function Base.:(==)(y::PhysicalVector, z::PhysicalVector)::Bool
    notEqual = (y ≠ z)
    return !notEqual
end

function Base.:≈(y::PhysicalVector, z::PhysicalVector)::Bool
    if y.vector.len ≠ z.vector.len
        return false
    end
    if areEquivalent(y.units, z.units)
        if ((isDimensionless(y) && isDimensionless(z)) ||
            (isCGS(y) && isCGS(z)) || (isSI(y) && isSI(z)))
            for i in 1:y.vector.len
                if !(y.vector[i] ≈ z.vector[i])
                    return false
                end
            end
        elseif (isCGS(y) && isSI(z))
            w = toSI(y)
            for i in 1:z.vector.len
                if !(w.vector[i] ≈ z.vector[i])
                    return false
                end
            end
        elseif (isSI(y) && isCGS(z))
            w = toSI(z)
            for i in 1:y.vector.len
                if !(y.vector[i] ≈ w.vector[i])
                    return false
                end
            end
        else
            msg = "Vectors must be dimensionless or have either CGS or SI units."
            throw(ErrorException(msg))
        end
    else
        return false
    end
    return true
end

function Base.:+(y::PhysicalVector)::PhysicalVector
    return copy(y)
end

function Base.:-(y::PhysicalVector)::PhysicalVector
    vector = PhysicalVector(y.vector.len, y.units)
    for i in 1:y.vector.len
        vector[i] = -y[i]
    end
    return vector
end

function Base.:+(y::PhysicalVector, z::PhysicalVector)::PhysicalVector
    if y.vector.len ≠ z.vector.len
        msg = "Vector addition requires vectors to have the same length."
        throw(DimensionMismatch(msg))
    end
    if areEquivalent(y.units, z.units)
        if isDimensionless(y) && isDimensionless(z)
            vector = PhysicalVector(y.vector.len, DIMENSIONLESS)
            for i in 1:y.vector.len
                vector[i] = y[i] + z[i]
            end
        elseif (isCGS(y) && isCGS(z)) || (isSI(y) && isSI(z))
            vector = PhysicalVector(y.vector.len, y.units)
            for i in 1:y.vector.len
                vector[i] = y[i] + z[i]
            end
        elseif (isCGS(y) && isSI(z))
            w = toSI(y)
            vector = PhysicalVector(z.vector.len, z.units)
            for i in 1:z.vector.len
                vector[i] = w[i] + z[i]
            end
        elseif (isSI(y) && isCGS(z))
            w = toSI(z)
            vector = PhysicalVector(y.vector.len, y.units)
            for i in 1:y.vector.len
                vector[i] = y[i] + w[i]
            end
        else
            msg = "Vectors must be dimensionless or have either CGS or SI units."
            throw(ErrorException(msg))
        end
    else
        msg = "Vector addition requires vectors to have equivalent units."
        throw(ErrorException(msg))
    end
    return vector
end

function Base.:-(y::PhysicalVector, z::PhysicalVector)::PhysicalVector
    if y.vector.len ≠ z.vector.len
        msg = "Vector subtraction requires vectors to have the same length."
        throw(DimensionMismatch(msg))
    end
    if areEquivalent(y.units, z.units)
        if isDimensionless(y) && isDimensionless(z)
            vector = PhysicalVector(y.vector.len, DIMENSIONLESS)
            for i in 1:y.vector.len
                vector[i] = y[i] - z[i]
            end
        elseif (isCGS(y) && isCGS(z)) || (isSI(y) && isSI(z))
            vector = PhysicalVector(y.vector.len, y.units)
            for i in 1:y.vector.len
                vector[i] = y[i] - z[i]
            end
        elseif (isCGS(y) && isSI(z))
            w = toSI(y)
            vector = PhysicalVector(z.vector.len, z.units)
            for i in 1:z.vector.len
                vector[i] = w[i] - z[i]
            end
        elseif (isSI(y) && isCGS(z))
            w = toSI(z)
            vector = PhysicalVector(y.vector.len, y.units)
            for i in 1:y.vector.len
                vector[i] = y[i] - w[i]
            end
        else
            msg = "Vectors must be dimensionless or have either CGS or SI units."
            throw(ErrorException(msg))
        end
    else
        msg = "Vector subtraction requires vectors to have equivalent units."
        throw(ErrorException(msg))
    end
    return vector
end

function Base.:*(y::PhysicalVector, z::PhysicalVector)::PhysicalScalar
    if y.vector.len ≠ z.vector.len
        msg = "A vector dot product requires vectors to have the same length."
        throw(DimensionMismatch(msg))
    end
    if isDimensionless(y)
        if isDimensionless(z)
            units = DIMENSIONLESS
        else
            units = z.units
        end
        value = LinearAlgebra.dot(y.vector.vec, z.vector.vec)
    elseif isDimensionless(z)
        units = y.units
        value = LinearAlgebra.dot(y.vector.vec, z.vector.vec)
    elseif (isCGS(y) && isCGS(z)) || (isSI(y) && isSI(z))
        units = y.units + z.units
        value = LinearAlgebra.dot(y.vector.vec, z.vector.vec)
    elseif (isCGS(y) && isSI(z))
        w = toSI(y)
        units = w.units + z.units
        value = LinearAlgebra.dot(w.vector.vec, z.vector.vec)
    elseif (isSI(y) && isCGS(z))
        w = toSI(z)
        units = y.units + w.units
        value = LinearAlgebra.dot(y.vector.vec, w.vector.vec)
    else
        msg = "Vectors must be dimensionless or have either CGS or SI units."
        throw(ErrorException(msg))
    end
    dotProduct = PhysicalScalar(value, units)
    return dotProduct
end

function Base.:*(y::PhysicalScalar, z::PhysicalVector)::PhysicalVector
    if isDimensionless(y)
        if isDimensionless(z)
            units = DIMENSIONLESS
        else
            units = z.units
        end
        scalarProduct = PhysicalVector(z.vector.len, units)
        for i in 1:z.vector.len
            scalarProduct[i] = y * z[i]
        end
    elseif isDimensionless(z)
        units = y.units
        scalarProduct = PhysicalVector(z.vector.len, units)
        for i in 1:z.vector.len
            scalarProduct[i] = y * z[i]
        end
    elseif (isCGS(y) && isCGS(z)) || (isSI(y) && isSI(z))
        units = y.units + z.units
        scalarProduct = PhysicalVector(z.vector.len, units)
        for i in 1:z.vector.len
            scalarProduct[i] = y * z[i]
        end
    elseif (isCGS(y) && isSI(z))
        w = toSI(y)
        units = w.units + z.units
        scalarProduct = PhysicalVector(z.vector.len, units)
        for i in 1:z.vector.len
            scalarProduct[i] = w * z[i]
        end
    elseif (isSI(y) && isCGS(z))
        w = toSI(z)
        units = y.units + w.units
        scalarProduct = PhysicalVector(w.vector.len, units)
        for i in 1:w.vector.len
            scalarProduct[i] = y * w[i]
        end
    else
        msg = "Scalars and vectors must be dimensionless or have either CGS or SI units."
        throw(ErrorException(msg))
    end
    return scalarProduct
end

function Base.:*(y::Union{Real,MNumber}, z::PhysicalVector)::PhysicalVector
    scalarProduct = PhysicalVector(z.vector.len, z.units)
    for i in 1:z.vector.len
        scalarProduct[i] = y * z[i]
    end
    return scalarProduct
end

function Base.:/(y::PhysicalVector, z::PhysicalScalar)::PhysicalVector
    if isDimensionless(y)
        if isDimensionless(z)
            units = DIMENSIONLESS
        else
            units = -z.units
        end
        scalarDivision = PhysicalVector(y.vector.len, units)
        for i in 1:y.vector.len
            scalarDivision[i] = y[i] / z
        end
    elseif isDimensionless(z)
        units = y.units
        scalarDivision = PhysicalVector(y.vector.len, units)
        for i in 1:y.vector.len
            scalarDivision[i] = y[i] / z
        end
    elseif (isCGS(y) && isCGS(z)) || (isSI(y) && isSI(z))
        units = y.units - z.units
        scalarDivision = PhysicalVector(y.vector.len, units)
        for i in 1:y.vector.len
            scalarDivision[i] = y[i] / z
        end
    elseif (isCGS(y) && isSI(z))
        w = toSI(y)
        units = w.units - z.units
        scalarDivision = PhysicalVector(w.vector.len, units)
        for i in 1:w.vector.len
            scalarDivision[i] = w[i] / z
        end
    elseif (isSI(y) && isCGS(z))
        w = toSI(z)
        units = y.units - w.units
        scalarDivision = PhysicalVector(y.vector.len, units)
        for i in 1:y.vector.len
            scalarDivision[i] = y[i] / w
        end
    else
        msg = "Scalars and vectors must be dimensionless or have either CGS or SI units."
        throw(ErrorException(msg))
    end
    return scalarDivision
end

function Base.:/(y::PhysicalVector, z::Union{Real,MNumber})::PhysicalVector
    scalarDivision = PhysicalVector(y.vector.len, y.units)
    for i in 1:y.vector.len
        scalarDivision[i] = y[i] / z
    end
    return scalarDivision
end

#=
--------------------------------------------------------------------------------
=#

# Functions of type PhysicalVector:

function toVector(v::PhysicalVector)::Vector{Float64}
    return Vector(v.vector)
end

function LinearAlgebra.:(norm)(y::PhysicalVector, p::Real=2)::PhysicalScalar
    value = norm(y.vector, p)
    units = y.units
    magnitude = PhysicalScalar(value, units)
    return magnitude
end

function unitVector(y::PhysicalVector)::PhysicalVector
    unitVec = y / norm(y, 2)
    return unitVec
end

function LinearAlgebra.:(cross)(y::PhysicalVector, z::PhysicalVector)::PhysicalVector
    if (y.vector.len ≠ 3) || (z.vector.len ≠ 3)
        msg = "Vector cross product is only defined for 3 dimensional vectors."
        throw(DimensionMismatch(msg))
    end
    if isDimensionless(y)
        if isDimensionless(z)
            units = DIMENSIONLESS
        else
            units = z.units
        end
        value = cross(y.vector, z.vector)
    elseif isDimensionless(z)
        units = y.units
        value = cross(y.vector, z.vector)
    elseif (isCGS(y) && isCGS(z)) || (isSI(y) && isSI(z))
        units = y.units + z.units
        value = cross(y.vector, z.vector)
    elseif (isSI(y) && isCGS(z))
        w = toSI(z)
        units = y.units + w.units
        value = cross(y.vector, w.vector)
    elseif (isCGS(y) && isSI(z))
        w = toSI(y)
        units = w.units + z.units
        value = cross(w.vector, z.vector)
    else
        msg = "Vectors must be dimensionless or have either CGS or SI units."
        throw(ErrorException(msg))
    end
    crossProduct = PhysicalVector(value, units)
    return crossProduct
end
