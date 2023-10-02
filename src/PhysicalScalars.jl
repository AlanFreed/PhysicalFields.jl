# PhysicalScalars

# Methods for testing the kind of system of units.

function isDimensionless(s::PhysicalScalar)::Bool
    return isDimensionless(s.units)
end

function isDimensionless(as::ArrayOfPhysicalScalars)::Bool
    return isDimensionless(as.units)
end

function isCGS(s::PhysicalScalar)::Bool
    return isCGS(s.units)
end

function isCGS(as::ArrayOfPhysicalScalars)::Bool
    return isCGS(as.units)
end

function isSI(s::PhysicalScalar)::Bool
    return isSI(s.units)
end

function isSI(as::ArrayOfPhysicalScalars)::Bool
    return isSI(as.units)
end

# Methods for converting between systems of units.

function toSI(s::PhysicalScalar)::PhysicalScalar
    if isDimensionless(s) || isSI(s)
        return s
    elseif isCGS(s)
        units = PhysicalUnits("SI", s.units.length, s.units.mass, s.units.amount_of_substance, s.units.time, s.units.temperature, s.units.electric_current, s.units.light_intensity)
        value = s.value * 100.0^(-s.units.length) * 1000.0^(-s.units.mass)
        return PhysicalScalar(value, units)
    else
        msg = "Scalars must be dimensionless or have either CGS or SI units."
        throw(ErrorException(msg))
    end
end

function toSI(as::ArrayOfPhysicalScalars)::ArrayOfPhysicalScalars
    if isDimensionless(as) || isSI(as)
        return as
    elseif isCGS(as)
        units = PhysicalUnits("SI", as.units.length, as.units.mass, as.units.amount_of_substance, as.units.time, as.units.temperature, as.units.electric_current, as.units.light_intensity)
        pa = ArrayOfPhysicalScalars(as.vector.len, units)
        for i in 1:as.vector.len
            value = as.array[i] * 100.0^(-as.units.length) * 1000.0^(-as.units.mass)
            pa[i] = PhysicalScalar(value, units)
        end
        return pa
    else
        msg = "Scalar arrays must be dimensionless or have either CGS or SI units."
        throw(ErrorException(msg))
    end
end

function toCGS(s::PhysicalScalar)::PhysicalScalar
    if isDimensionless(s) || isCGS(s)
        return s
    elseif isSI(s)
        units = PhysicalUnits("CGS", s.units.length, s.units.mass, s.units.amount_of_substance, s.units.time, s.units.temperature, s.units.electric_current, s.units.light_intensity)
        value = s.value * 100.0^s.units.length * 1000.0^s.units.mass
        return PhysicalScalar(value, units)
    else
        msg = "Scalars must be dimensionless or have either CGS or SI units."
        throw(ErrorException(msg))
    end
end

function toCGS(as::ArrayOfPhysicalScalars)::ArrayOfPhysicalScalars
    if isDimensionless(as) || isCGS(as)
        return as
    elseif isSI(as)
        units = PhysicalUnits("CGS", as.units.length, as.units.mass, as.units.amount_of_substance, as.units.time, as.units.temperature, as.units.electric_current, as.units.light_intensity)
        pa = ArrayOfPhysicalScalars(as.vector.len, units)
        for i in 1:as.array.len
            value = as.array[i] * 100.0^as.units.length * 1000.0^as.units.mass
            pa[i] = PhysicalScalar(value, units)
        end
        return pa
    else
        msg = "Scalar arrays must be dimensionless or have either CGS or SI units."
        throw(ErrorException(msg))
    end
end

function toReal(s::PhysicalScalar)::Real
    return Real(s.value)
end

#=
--------------------------------------------------------------------------------
=#

function Base.:(copy)(s::PhysicalScalar)::PhysicalScalar
    value = copy(s.value)
    units = copy(s.units)
    return PhysicalScalar(value, units)
end

function Base.:(copy)(as::ArrayOfPhysicalScalars)::ArrayOfPhysicalScalars
    array = copy(as.array)
    units = copy(as.units)
    return ArrayOfPhysicalScalars(array, units)
end

function Base.:(deepcopy)(s::PhysicalScalar)::PhysicalScalar
    value = deepcopy(s.value)
    units = deepcopy(s.units)
    return PhysicalScalar(value, units)
end

function Base.:(deepcopy)(as::ArrayOfPhysicalScalars)::ArrayOfPhysicalScalars
    array = deepcopy(as.array)
    units = deepcopy(as.units)
    return ArrayOfPhysicalScalars(array, units)
end

#=
--------------------------------------------------------------------------------
=#

# Overloaded these operators: logical: ==, ≠, ≈, <, ≤, ≥, >
#                             unary:   +, -
#                             binary:  +, -, *, /

function Base.:(==)(y::PhysicalScalar, z::PhysicalScalar)::Bool
    if areEquivalent(y.units, z.units)
        if ((isDimensionless(y) && isDimensionless(z)) ||
            (isCGS(y) && isCGS(z)) || (isSI(y) && isSI(z)))
            if y.value == z.value
                return true
            else
                return false
            end
        elseif isCGS(y) && isSI(z)
            w = toSI(y)
            if w.value == z.value
                return true
            else
                return false
            end
        elseif isSI(y) && isCGS(z)
            w = toSI(z)
            if y.value == w.value
                return true
            else
                return false
            end
        else
            msg = "Scalars must be dimensionless or have either CGS or SI units."
            throw(ErrorException(msg))
        end
    else
        return false
    end
end

function Base.:(==)(y::Union{Real, MNumber}, z::PhysicalScalar)::Bool
    if isDimensionless(z)
        if y == z.value
            return true
        else
            return false
        end
    else
        msg = "Testing for == requires the PhysicalScalar to be dimensionless."
        throw(ErrorException(msg))
    end
end

function Base.:(==)(y::PhysicalScalar, z::Union{Real, MNumber})::Bool
    if isDimensionless(y)
        if y.value == z
            return true
        else
            return false
        end
    else
        msg = "Testing for == requires the PhysicalScalar to be dimensionless."
        throw(ErrorException(msg))
    end
end

function Base.:≈(y::PhysicalScalar, z::PhysicalScalar)::Bool
    if areEquivalent(y.units, z.units)
        if ((isDimensionless(y) && isDimensionless(z)) ||
            (isCGS(y) && isCGS(z)) || (isSI(y) && isSI(z)))
            if y.value ≈ z.value
                return true
            else
                return false
            end
        elseif isCGS(y) && isSI(z)
            w = toSI(y)
            if w.value ≈ z.value
                return true
            else
                return false
            end
        elseif isSI(y) && isCGS(z)
            w = toSI(z)
            if y.value ≈ w.value
                return true
            else
                return false
            end
        else
            msg = "Scalars must be dimensionless or have either CGS or SI units."
            throw(ErrorException(msg))
        end
    else
        return false
    end
end

function Base.:≈(y::Union{Real, MNumber}, z::PhysicalScalar)::Bool
    if isDimensionless(z)
        if y ≈ z.value
            return true
        else
            return false
        end
    else
        msg = "Testing for ≈ requires the PhysicalScalar to be dimensionless."
        throw(ErrorException(msg))
    end
end

function Base.:≈(y::PhysicalScalar, z::Union{Real, MNumber})::Bool
    if isDimensionless(y)
        if y.value ≈ z
            return true
        else
            return false
        end
    else
        msg = "Testing for ≈ requires the PhysicalScalar to be dimensionless."
        throw(ErrorException(msg))
    end
end

function Base.:≠(y::PhysicalScalar, z::PhysicalScalar)::Bool
    equals = (y == z)
    return !equals
end

function Base.:≠(y::Union{Real, MNumber}, z::PhysicalScalar)::Bool
    equals = (y == z)
    return !equals
end

function Base.:≠(y::PhysicalScalar, z::Union{Real, MNumber})::Bool
    equals = (y == z)
    return !equals
end

function Base.:<(y::PhysicalScalar, z::PhysicalScalar)::Bool
    if areEquivalent(y.units, z.units)
        if ((isDimensionless(y) && isDimensionless(z)) ||
            (isCGS(y) && isCGS(z)) || (isSI(y) && isSI(z)))
            if y.value < z.value
                return true
            else
                return false
            end
        elseif isCGS(y) && isSI(z)
            w = toSI(y)
            if w.value < z.value
                return true
            else
                return false
            end
        elseif isSI(y) && isCGS(z)
            w = toSI(z)
            if y.value < w.value
                return true
            else
                return false
            end
        else
            msg = "Scalars must be dimensionless or have either CGS or SI units."
            throw(ErrorException(msg))
        end
    else
        msg = "Testing for < requires PhysicalScalars to have equivalent units."
        throw(ErrorException(msg))
    end
end

function Base.:<(y::Union{Real, MNumber}, z::PhysicalScalar)::Bool
    if isDimensionless(z)
        if y < z.value
            return true
        else
            return false
        end
    else
        msg = "Testing for < requires the PhysicalScalar to be dimensionless."
        throw(ErrorException(msg))
    end
end

function Base.:<(y::PhysicalScalar, z::Union{Real, MNumber})::Bool
    if isDimensionless(y)
        if y.value < z
            return true
        else
            return false
        end
    else
        msg = "Testing for < requires the PhysicalScalar to be dimensionless."
        throw(ErrorException(msg))
    end
end

function Base.:≥(y::PhysicalScalar, z::PhysicalScalar)::Bool
    lessThan = (y < z)
    return !lessThan
end

function Base.:≥(y::Union{Real, MNumber}, z::PhysicalScalar)::Bool
    lessThan = (y < z)
    return !lessThan
end

function Base.:≥(y::PhysicalScalar, z::Union{Real, MNumber})::Bool
    lessThan = (y < z)
    return !lessThan
end

function Base.:>(y::PhysicalScalar, z::PhysicalScalar)::Bool
    if areEquivalent(y.units, z.units)
        if ((isDimensionless(y) && isDimensionless(z)) ||
            (isCGS(y) && isCGS(z)) || (isSI(y) && isSI(z)))
            if y.value > z.value
                return true
            else
                return false
            end
        elseif isCGS(y) && isSI(z)
            w = toSI(y)
            if w.value > z.value
                return true
            else
                return false
            end
        elseif isSI(y) && isCGS(z)
            w = toSI(z)
            if y.value > z.value
                return true
            else
                return false
            end
        else
            msg = "Scalars must be dimensionless or have either CGS or SI units."
            throw(ErrorException(msg))
        end
    else
        msg = "Testing for > requires PhysicalScalars to have equivalent units."
        throw(ErrorException(msg))
    end
end

function Base.:>(y::Union{Real, MNumber}, z::PhysicalScalar)::Bool
    if isDimensionless(z)
        if y > z.value
            return true
        else
            return false
        end
    else
        msg = "Testing for > requires the PhysicalScalar to be dimensionless."
        throw(ErrorException(msg))
    end
end

function Base.:>(y::PhysicalScalar, z::Union{Real, MNumber})::Bool
    if isDimensionless(y)
        if y.value > z
            return true
        else
            return false
        end
    else
        msg = "Testing for > requires the PhysicalScalar to be dimensionless."
        throw(ErrorException(msg))
    end
end

function Base.:≤(y::PhysicalScalar, z::PhysicalScalar)::Bool
    greaterThan = (y > z)
    return !greaterThan
end

function Base.:≤(y::Union{Real, MNumber}, z::PhysicalScalar)::Bool
    greaterThan = (y > z)
    return !greaterThan
end

function Base.:≤(y::PhysicalScalar, z::Union{Real, MNumber})::Bool
    greaterThan = (y > z)
    return !greaterThan
end

function Base.:+(y::PhysicalScalar)::PhysicalScalar
    return copy(y)
end

function Base.:-(y::PhysicalScalar)::PhysicalScalar
    value = -y.value
    units = y.units
    return PhysicalScalar(value, units)
end

function Base.:+(y::PhysicalScalar, z::PhysicalScalar)::PhysicalScalar
    if areEquivalent(y.units, z.units)
        if ((isDimensionless(y) && isDimensionless(z)) ||
            (isCGS(y) && isCGS(z)) || (isSI(y) && isSI(z)))
            units = y.units
            value = y.value + z.value
        elseif isCGS(y) && isSI(z)
            w = toSI(y)
            units = z.units
            value = w.value + z.value
        elseif isSI(y) && isCGS(z)
            w = toSI(z)
            units = y.units
            value = y.value + w.value
        else
            msg = "Scalar addition requires units to be dimensionless, CGS or SI."
            throw(ErrorException(msg))
        end
    else
        msg = "Scalar addition requires scalars to have equivalent units."
        throw(ErrorException(msg))
    end
    return PhysicalScalar(value, units)
end

function Base.:+(y::Union{Real, MNumber}, z::PhysicalScalar)::PhysicalScalar
    if isDimensionless(z)
        units = z.units
        value = y + z.value
    else
        msg = "Adding a number with a scalar requires the scalar to be dimensionless."
        throw(ErrorException(msg))
    end
    return PhysicalScalar(value, units)
end

function Base.:+(y::PhysicalScalar, z::Union{Real, MNumber})::PhysicalScalar
    if isDimensionless(y)
        units = y.units
        value = y.value + z
    else
        msg = "Adding a scalar with a number requires the scalar to be dimensionless."
        throw(ErrorException(msg))
    end
    return PhysicalScalar(value, units)
end

function Base.:-(y::PhysicalScalar, z::PhysicalScalar)::PhysicalScalar
    if areEquivalent(y.units, z.units)
        if ((isDimensionless(y) && isDimensionless(z)) ||
            (isCGS(y) && isCGS(z)) || (isSI(y) && isSI(z)))
            units = y.units
            value = y.value - z.value
        elseif isCGS(y) && isSI(z)
            w = toSI(y)
            units = z.units
            value = w.value - z.value
        elseif isSI(y) && isCGS(z)
            w = toSI(z)
            units = y.units
            value = y.value - w.value
        else
            msg = "Scalar subtraction requires units to be dimensionless, CGS or SI."
            throw(ErrorException(msg))
        end
    else
        msg = "Scalar subtraction requires scalars to have equivalent units."
        throw(ErrorException(msg))
    end
    return PhysicalScalar(value, units)
end

function Base.:-(y::Union{Real, MNumber}, z::PhysicalScalar)::PhysicalScalar
    if isDimensionless(z)
        units = z.units
        value = y - z.value
    else
        msg = "Subtracting a number by a scalar requires the scalar to be dimensionless."
        throw(ErrorException(msg))
    end
    return PhysicalScalar(value, units)
end

function Base.:-(y::PhysicalScalar, z::Union{Real, MNumber})::PhysicalScalar
    if isDimensionless(y)
        units = y.units
        value = y.value - z
    else
        msg = "Subtracting a scalar by a number requires the scalar to be dimensionless."
        throw(ErrorException(msg))
    end
    return PhysicalScalar(value, units)
end

function Base.:*(y::PhysicalScalar, z::PhysicalScalar)::PhysicalScalar
    if (isCGS(y) && isCGS(z)) || (isSI(y) && isSI(z))
        value = y.value * z.value
        units = y.units + z.units
    elseif isCGS(y) && isSI(z)
        w = toSI(y)
        value = w.value * z.value
        units = w.units + z.units
    elseif isSI(y) && isCGS(z)
        w = toSI(z)
        value = y.value * w.value
        units = y.units + w.units
    else
        msg = "Scalar multiplication requires scalars have CGS or SI units."
        throw(ErrorException(msg))
    end
    return PhysicalScalar(value, units)
end

function Base.:*(y::Union{Real, MNumber}, z::PhysicalScalar)::PhysicalScalar
    value = y * z.value
    units = z.units
    return PhysicalScalar(value, units)
end

function Base.:*(y::PhysicalScalar, z::Union{Real, MNumber})::PhysicalScalar
    value = y.value * z
    units = y.units
    return PhysicalScalar(value, units)
end

function Base.:/(y::PhysicalScalar, z::PhysicalScalar)::PhysicalScalar
    if (isCGS(y) && isCGS(z)) || (isSI(y) && isSI(z))
        value = y.value / z.value
        units = y.units - z.units
    elseif isCGS(y) && isSI(z)
        w = toSI(y)
        value = w.value / z.value
        units = w.units - z.units
    elseif isSI(y) && isCGS(z)
        w = toCGS(z)
        value = y.value / w.value
        units = y.units - w.units
    else
        msg = "Scalar division requires scalars have CGS or SI units."
        throw(ErrorException(msg))
    end
    return PhysicalScalar(value, units)
end

function Base.:/(y::Union{Real, MNumber}, z::PhysicalScalar)::PhysicalScalar
    value = y / z.value
    units = -z.units
    return PhysicalScalar(value, units)
end

function Base.:/(y::PhysicalScalar, z::Union{Real, MNumber})::PhysicalScalar
    value = y.value / z
    units = y.units
    return PhysicalScalar(value, units)
end

function Base.:^(y::PhysicalScalar, z::Union{Real, MNumber})::PhysicalScalar
    if (typeof(z) == Integer) || (typeof(z) == MInteger)
        value = y.value ^ z
        if isDimensionless(y)
            units = y.units
        elseif isCGS(y)
            units = PhysicalUnits("CGS", y.units.length*z, y.units.mass*z, y.units.amount_of_substance*z, y.units.time*z, y.units.temperature*z, y.units.electric_current*z, y.units.light_intensity*z)
        elseif isSI(y)
            units = PhysicalUnits("SI", y.units.length*z, y.units.mass*z, y.units.amount_of_substance*z, y.units.time*z, y.units.temperature*z, y.units.electric_current*z, y.units.light_intensity*z)
        else
            msg = "Scalars raised to integer powers require the scalar to have CGS or SI units."
            throw(ErrorException(msg))
        end
    elseif isDimensionless(y)
        value = y.value ^ z
        units = y.units
    else
        msg = "Scalars raised to real powers require the scalar to be dimensionless."
        throw(ErrorException(msg))
    end
    return PhysicalScalar(value, units)
end

#=
--------------------------------------------------------------------------------
=#

# Math functions

function Base.:(abs)(s::PhysicalScalar)::PhysicalScalar
    value = abs(s.value)
    units = s.units
    return PhysicalScalar(value, units)
end

function Base.:(round)(y::PhysicalScalar)::PhysicalScalar
    value = round(y.value)
    units = y.units
    return PhysicalScalar(value, units)
end

function Base.:(ceil)(y::PhysicalScalar)::PhysicalScalar
    value = ceil(y.value)
    units = y.units
    return PhysicalScalar(value, units)
end

function Base.:(floor)(y::PhysicalScalar)::PhysicalScalar
    value = floor(y.value)
    units = y.units
    return PhysicalScalar(value, units)
end

function Base.:(sqrt)(y::PhysicalScalar)::PhysicalScalar
    if isSI(y)
        if ((y.units.length%2 == 0) &&
            (y.units.mass%2 == 0) &&
            (y.units.amount_of_substance%2 == 0) &&
            (y.units.time%2 == 0) &&
            (y.units.temperature%2 == 0) &&
            (y.units.electric_current%2 == 0) &&
            (y.units.light_intensity%2 == 0))
            units = PhysicalUnits("SI", y.units.length÷2, y.units.mass÷2, y.units.amount_of_substance÷2, y.units.time÷2, y.units.temperature÷2, y.units.electric_current÷2, y.units.light_intensity÷2)
        else
            msg = "The SI dimensions of y do not permit taking its square root."
            throw(ErrorException(msg))
        end
    elseif isCGS(y)
        if ((y.units.length%2 == 0) &&
            (y.units.mass%2 == 0) &&
            (y.units.amount_of_substance%2 == 0) &&
            (y.units.time%2 == 0) &&
            (y.units.temperature%2 == 0) &&
            (y.units.electric_current%2 == 0) &&
            (y.units.light_intensity%2 == 0))
            units = PhysicalUnits("CGS", y.units.length÷2, y.units.mass÷2, y.units.amount_of_substance÷2, y.units.time÷2, y.units.temperature÷2, y.units.electric_current÷2, y.units.light_intensity÷2)
        else
            msg = "The CGS dimensions of y do not permit taking its square root."
            throw(ErrorException(msg))
        end
    else
        msg = "Function sqrt() requires its argument to be dimensionless, CGS or SI."
        throw(ErrorException(msg))
    end
    value = sqrt(y.value)
    return PhysicalScalar(value, units)
end

function Base.:(sign)(y::PhysicalScalar)::Real
    return sign(y.value)
end

function Base.:(sin)(y::PhysicalScalar)::Real
    if isDimensionless(y)
        n = sin(y.value)
    else
        msg = "The argument must be dimensionless when calling sin()."
        throw(ErrorException(msg))
    end
    return n
end

function Base.:(cos)(y::PhysicalScalar)::Real
    if isDimensionless(y)
        n = cos(y.value)
    else
        msg = "The argument must be dimensionless when calling cos()."
        throw(ErrorException(msg))
    end
    return n
end

function Base.:(tan)(y::PhysicalScalar)::Real
    if isDimensionless(y)
        n = tan(y.value)
    else
        msg = "The argument must be dimensionless when calling tan()."
        throw(ErrorException(msg))
    end
    return n
end

function Base.:(sinh)(y::PhysicalScalar)::Real
    if isDimensionless(y)
        n = sinh(y.value)
    else
        msg = "The argument must be dimensionless when calling sinh()."
        throw(ErrorException(msg))
    end
    return n
end

function Base.:(cosh)(y::PhysicalScalar)::Real
    if isDimensionless(y)
        n = cosh(y.value)
    else
        msg = "The argument must be dimensionless when calling cosh()."
        throw(ErrorException(msg))
    end
    return n
end

function Base.:(tanh)(y::PhysicalScalar)::Real
    if isDimensionless(y)
        n = tanh(y.value)
    else
        msg = "The argument must be dimensionless when calling tanh()."
        throw(ErrorException(msg))
    end
    return n
end

function Base.:(asin)(y::PhysicalScalar)::Real
    if isDimensionless(y)
        n = asin(y.value)
    else
        msg = "The argument must be dimensionless when calling asin()."
        throw(ErrorException(msg))
    end
    return n
end

function Base.:(acos)(y::PhysicalScalar)::Real
    if isDimensionless(y)
        n = acos(y.value)
    else
        msg = "The argument must be dimensionless when calling acos()."
        throw(ErrorException(msg))
    end
    return n
end

function Base.:(atan)(y::PhysicalScalar)::Real
    if isDimensionless(y)
        n = atan(y.value)
    else
        msg = "The argument must be dimensionless when calling atan()."
        throw(ErrorException(msg))
    end
    return n
end

function Base.:(atan)(y::PhysicalScalar, x::PhysicalScalar)::Real
    if y.units == x.units
        n = atan(y.value, x.value)
    else
        msg = "The arguments must have the same units when calling atan(y, x)."
        throw(ErrorException(msg))
    end
    return n
end

function Base.:(atan)(y::PhysicalScalar, x::Union{Real, MNumber})::Real
    if isDimensionless(y)
        n = atan(y.value, x)
    else
        msg = "The scalar argument must dimensionless when calling atan(y, x)."
        throw(ErrorException(msg))
    end
    return n
end

function Base.:(atan)(y::Union{Real, MNumber}, x::PhysicalScalar)::Real
    if isDimensionless(x)
        n = atan(y, x.value)
    else
        msg = "The scalar argument must dimensionless when calling atan(y, x)."
        throw(ErrorException(msg))
    end
    return n
end

function Base.:(asinh)(y::PhysicalScalar)::Real
    if isDimensionless(y)
        n = asinh(y.value)
    else
        msg = "The argument must be dimensionless when calling asinh()."
        throw(ErrorException(msg))
    end
    return n
end

function Base.:(acosh)(y::PhysicalScalar)::Real
    if isDimensionless(y)
        n = acosh(y.value)
    else
        msg = "The argument must be dimensionless when calling acosh()."
        throw(ErrorException(msg))
    end
    return n
end

function Base.:(atanh)(y::PhysicalScalar)::Real
    if isDimensionless(y)
        n = atanh(y.value)
    else
        msg = "The argument must be dimensionless when calling atanh()."
        throw(ErrorException(msg))
    end
    return n
end

function Base.:(log)(y::PhysicalScalar)::Real
    if isDimensionless(y)
        n = log(y.value)
    else
        msg = "The argument must be dimensionless when calling log()."
        throw(ErrorException(msg))
    end
    return n
end

function Base.:(log2)(y::PhysicalScalar)::Real
    if isDimensionless(y)
        n = log2(y.value)
    else
        msg = "The argument must be dimensionless when calling log2()."
        throw(ErrorException(msg))
    end
    return n
end

function Base.:(log10)(y::PhysicalScalar)::Real
    if isDimensionless(y)
        n = log10(y.value)
    else
        msg = "The argument must be dimensionless when calling log10()."
        throw(ErrorException(msg))
    end
    return n
end

function Base.:(exp)(y::PhysicalScalar)::Real
    if isDimensionless(y)
        n = exp(y.value)
    else
        msg = "The argument must be dimensionless when calling exp()."
        throw(ErrorException(msg))
    end
    return n
end

function Base.:(exp2)(y::PhysicalScalar)::Real
    if isDimensionless(y)
        n = exp2(y.value)
    else
        msg = "The argument must be dimensionless when calling exp2()."
        throw(ErrorException(msg))
    end
    return n
end

function Base.:(exp10)(y::PhysicalScalar)::Real
    if isDimensionless(y)
        n = exp10(y.value)
    else
        msg = "The argument must be dimensionless when calling exp10()."
        throw(ErrorException(msg))
    end
    return n
end
