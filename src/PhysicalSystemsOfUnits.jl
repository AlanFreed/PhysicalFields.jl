# PhysicalSystemsOfUnits

# Exported types

abstract type PhysicalUnits end

struct Dimensionless <: PhysicalUnits
    len::Int8   # exponent for the unit of length
    mass::Int8  # exponent for the unit of mass
    time::Int8  # exponent for the unit of time
    temp::Int8  # exponent for the unit of temperature

    # constructor

    function Dimensionless()
        new(convert(Int8, 0),
            convert(Int8, 0),
            convert(Int8, 0),
            convert(Int8, 0))
    end
end

struct CGS <: PhysicalUnits
    cm::Int8  # exponent for the unit of length:      centimeters
    g::Int8   # exponent for the unit of mass:        grams
    s::Int8   # exponent for the unit of time:        seconds
    C::Int8   # exponent for the unit of temperature: degrees centigrade

    # constructor

    function CGS(cm::Integer, g::Integer, s::Integer, C::Integer)
        new(convert(Int8, cm),
            convert(Int8, g),
            convert(Int8, s),
            convert(Int8, C))
    end
end

struct SI <: PhysicalUnits
    m::Int8   # exponent for the unit of length:      meters
    kg::Int8  # exponent for the unit of mass:        kilograms
    s::Int8   # exponent for the unit of time:        seconds
    K::Int8   # exponent for the unit of temperature: Kelvin

    # constructor

    function SI(m::Integer, kg::Integer, s::Integer, K::Integer)
        new(convert(Int8, m),
            convert(Int8, kg),
            convert(Int8, s),
            convert(Int8, K))
    end
end

#=
-------------------------------------------------------------------------------
=#

# A helper type for reading and writing from or to a JSON file.

struct LowerUnits
    system::String  # system of physical units
    len::Int64      # exponent for the unit of length
    mass::Int64     # exponent for the unit of mass
    time::Int64     # exponent for the unit of time
    temp::Int64     # exponent for the unit of temperature

    # constructors

    function LowerUnits(system::String, len::Integer, mass::Integer, time::Integer, temp::Integer)
        len    = convert(Int64, len)
        mass   = convert(Int64, mass)
        time   = convert(Int64, time)
        temp   = convert(Int64, temp)
        new(system, len, mass, time, temp)
    end

    function LowerUnits(u::Dimensionless)
        system = "Dimensionless"
        len    = convert(Int64, 0)
        mass   = convert(Int64, 0)
        time   = convert(Int64, 0)
        temp   = convert(Int64, 0)
        new(system, len, mass, time, temp)
    end

    function LowerUnits(u::CGS)
        system = "CGS"
        len    = convert(Int64, u.cm)
        mass   = convert(Int64, u.g)
        time   = convert(Int64, u.s)
        temp   = convert(Int64, u.C)
        new(system, len, mass, time, temp)
    end

    function LowerUnits(u::SI)
        system = "SI"
        len    = convert(Int64, u.m)
        mass   = convert(Int64, u.kg)
        time   = convert(Int64, u.s)
        temp   = convert(Int64, u.K)
        new(system, len, mass, time, temp)
    end
end

# Method required to serialize (write to file) instances of these types.

function PhysicalUnits(lu::LowerUnits)::PhysicalUnits
    if lu.system == "Dimensionless"
        u = Dimensionless()
    elseif lu.system == "CGS"
        if (lu.len == 0) && (lu.mass == 0) && (lu.time == 0) && (lu.temp == 0)
            u = Dimensionless()
        else
            u = CGS(lu.len, lu.mass, lu.time, lu.temp)
        end
    elseif lu.system == "SI"
        if (lu.len == 0) && (lu.mass == 0) && (lu.time == 0) && (lu.temp == 0)
            u = Dimensionless()
        else
            u = SI(lu.len, lu.mass, lu.time, lu.temp)
        end
    else
        msg = "Unknown system of physical units."
        throw(ErrorException(msg))
    end
    return u
end

#=
-------------------------------------------------------------------------------
=#

# Type testing

"""
    isDimensionless(u::PhysicalUnits)::Bool

Returns `true` if `u` is without physical dimension; otherwise, it returns `false`.
"""
function isDimensionless(u::PhysicalUnits)::Bool
    if isa(u, Dimensionless)
        return true
    elseif isa(u, CGS) && (u.cm == 0) && (u.g == 0) && (u.s == 0) & (u.C == 0)
        return true
    elseif isa(u, SI) && (u.m == 0) && (u.kg == 0) & (u.s == 0) & (u.K == 0)
        return true
    else
        return false
    end
end

"""
    isCGS(u::PhysicalUnits)::Bool

Returns `true` if `u` has CGS units; otherwise, it returns `false`.
"""
function isCGS(u::PhysicalUnits)::Bool
    if isDimensionless(u)
        return true
    else
        return isa(u, CGS)
    end
end

"""
    isSI(u::PhysicalUnits)::Bool

Returns `true` if `u` has SI units; otherwise, it returns `false`.
"""
function isSI(u::PhysicalUnits)::Bool
    if isDimensionless(u)
        return true
    else
        return isa(u, SI)
    end
end

"""
    areEquivalent(u::PhysicalUnits, v::PhysicalUnits)::Bool

Returns `true` if `u` and `v` are the same kind of unit; otherwise, returns `false`.
"""
function areEquivalent(u::PhysicalUnits, v::PhysicalUnits)::Bool
    if isDimensionless(u) 
        if isDimensionless(v)
            return true
        else
            return false
        end
    elseif isDimensionless(v)
        return false
    elseif isa(u, CGS)
        if isa(v, CGS)
            if (u.cm == v.cm) && (u.g == v.g) && (u.s == v.s) && (u.C == v.C)
                return true
            else
                return false
            end
        elseif isa(v, SI)
            if (u.cm == v.m) && (u.g == v.kg) && (u.s == v.s) && (u.C == v.K)
                return true
            else
                return false
            end
        else
            msg = "Units must be either Dimensionless, CGS or SI."
            throw(ErrorException(msg))
        end
    elseif isa(u, SI)
        if isa(v, SI)
            if (u.m == v.m) && (u.kg == v.kg) && (u.s == v.s) && (u.K == v.K)
                return true
            else
                return false
            end
        elseif isa(v, CGS)
            if (u.m == v.cm) && (u.kg == v.g) && (u.s == v.s) && (u.K == v.C)
                return true
            else
                return false
            end
        else
            msg = "Units must be either Dimensionless, CGS or SI."
            throw(ErrorException(msg))
        end
    else
        msg = "Units must be either Dimensionless, CGS or SI."
        throw(ErrorException(msg))
    end
end

#=
--------------------------------------------------------------------------------
=#

# Overloaded these operators: logical: ==, ≠
#                             unary:   +, -
#                             binary:  +, -

function Base.:(==)(y::Dimensionless, z::Dimensionless)::Bool
    return true
end

function Base.:(==)(y::Dimensionless, z::CGS)::Bool
    if (z.cm == 0) && (z.g == 0) && (z.s == 0) && (z.C == 0)
        return true
    else
        return false
    end
end

function Base.:(==)(y::Dimensionless, z::SI)::Bool
    if (z.m == 0) && (z.kg == 0) && (z.s == 0) && (z.K == 0)
        return true
    else
        return false
    end
end

function Base.:(==)(y::CGS, z::Dimensionless)::Bool
    if (y.cm == 0) && (y.g == 0) && (y.s == 0) && (y.C == 0)
        return true
    else
        return false
    end
end

function Base.:(==)(y::SI, z::Dimensionless)::Bool
    if (y.m == 0) && (y.kg == 0) && (y.s == 0) && (y.K == 0)
        return true
    else
        return false
    end
end

function Base.:(==)(y::CGS, z::CGS)::Bool
    if (y.cm == z.cm) && (y.g == z.g) && (y.s == z.s) && (y.C == z.C)
        return true
    else
        return false
    end
end

function Base.:(==)(y::SI, z::SI)::Bool
    if (y.m == z.m) && (y.kg == z.kg) && (y.s == z.s) && (y.K == z.K)
        return true
    else
        return false
    end
end

function Base.:(==)(y::CGS, z::SI)::Bool
    if isDimensionless(y) && isDimensionless(z)
        return true
    else
        return false
    end
end

function Base.:(==)(y::SI, z::CGS)::Bool
    if isDimensionless(y) && isDimensionless(z)
        return true
    else
        return false
    end
end

function Base.:≠(y::Dimensionless, z::Dimensionless)::Bool
    return false
end

function Base.:≠(y::Dimensionless, z::CGS)::Bool
    return !(y == z)
end

function Base.:≠(y::Dimensionless, z::SI)::Bool
    return !(y == z)
end

function Base.:≠(y::CGS, z::Dimensionless)::Bool
    return !(y == z)
end

function Base.:≠(y::SI, z::Dimensionless)::Bool
    return !(y == z)
end

function Base.:≠(y::CGS, z::CGS)::Bool
    if (y.cm ≠ z.cm) || (y.g ≠ z.g) || (y.s ≠ z.s) || (y.C ≠ z.C)
        return true
    else
        return false
    end
end

function Base.:≠(y::SI, z::SI)::Bool
    if (y.m ≠ z.m) || (y.kg ≠ z.kg) || (y.s ≠ z.s) || (y.K ≠ z.K)
        return true
    else
        return false
    end
end

function Base.:≠(y::CGS, z::SI)::Bool
    if isDimensionless(y) && isDimensionless(z)
        return false
    else
        return true
    end
end

function Base.:≠(y::SI, z::CGS)::Bool
    if isDimensionless(y) && isDimensionless(z)
        return false
    else
        return true
    end
end

function Base.:+(y::Dimensionless)::Dimensionless
    return Dimensionless()
end

function Base.:+(y::CGS)::PhysicalUnits
    cm = +y.cm
    g  = +y.g
    s  = +y.s
    C  = +y.C
    if (cm == 0) && (g == 0) && (s == 0) && (C == 0)
        return Dimensionless()
    else
        return CGS(cm, g, s, C)
    end
end

function Base.:+(y::SI)::PhysicalUnits
    m  = +y.m
    kg = +y.kg
    s  = +y.s
    K  = +y.K
    if (m == 0) && (kg == 0) && (s == 0) && (K == 0)
        return Dimensionless()
    else
        return SI(m, kg, s, K)
    end
end

function Base.:-(y::Dimensionless)::Dimensionless
    return Dimensionless()
end

function Base.:-(y::CGS)::PhysicalUnits
    cm = -y.cm
    g  = -y.g
    s  = -y.s
    C  = -y.C
    if (cm == 0) && (g == 0) && (s == 0) && (C == 0)
        return Dimensionless()
    else
        return CGS(cm, g, s, C)
    end
end

function Base.:-(y::SI)::SI
    m  = -y.m
    kg = -y.kg
    s  = -y.s
    K  = -y.K
    if (m == 0) && (kg == 0) && (s == 0) && (K == 0)
        return Dimensionless()
    else
        return SI(m, kg, s, K)
    end
end

function Base.:+(y::Dimensionless, z::Dimensionless)::Dimensionless
    return Dimensionless()
end

function Base.:+(y::Dimensionless, z::CGS)::PhysicalUnits
    if isDimensionless(z)
        return Dimensionless()
    else
        return CGS(z.cm, z.g, z.s, z.C)
    end
end

function Base.:+(y::Dimensionless, z::SI)::PhysicalUnits
    if isDimensionless(z)
        return Dimensionless()
    else
        return SI(z.m, z.kg, z.s, z.K)
    end
end

function Base.:+(y::CGS, z::Dimensionless)::PhysicalUnits
    if isDimensionless(y)
        return Dimensionless()
    else
        return CGS(y.cm, y.g, y.s, y.C)
    end
end

function Base.:+(y::SI, z::Dimensionless)::PhysicalUnits
    if isDimensionless(y)
        return Dimensionless()
    else
        return SI(y.m, y.kg, y.s, y.K)
    end
end

function Base.:+(y::CGS, z::CGS)::PhysicalUnits
    cm = y.cm + z.cm
    g  = y.g + z.g
    s  = y.s + z.s
    C  = y.C + z.C
    if (cm == 0) && (g == 0) && (s == 0) && (C == 0)
        return Dimensionless()
    else
        return CGS(cm, g, s, C)
    end
end

function Base.:+(y::SI, z::SI)::PhysicalUnits
    m  = y.m + z.m
    kg = y.kg + z.kg
    s  = y.s + z.s
    K  = y.K + z.K
    if (m == 0) && (kg == 0) && (s == 0) && (K == 0)
        return Dimensionless()
    else
        return SI(m, kg, s, K)
    end
end

function Base.:-(y::Dimensionless, z::Dimensionless)::Dimensionless
    return Dimensionless()
end

function Base.:-(y::Dimensionless, z::CGS)::PhysicalUnits
    if isDimensionless(z)
        return Dimensionless()
    else
        return CGS(-z.cm, -z.g, -z.s, -z.C)
    end
end

function Base.:-(y::Dimensionless, z::SI)::PhysicalUnits
    if isDimensionless(z)
        return Dimensionless()
    else
        return SI(-z.m, -z.kg, -z.s, -z.K)
    end
end

function Base.:-(y::CGS, z::Dimensionless)::PhysicalUnits
    if isDimensionless(y)
        return Dimensionless()
    else
        return CGS(y.cm, y.g, y.s, y.C)
    end
end

function Base.:-(y::SI, z::Dimensionless)::PhysicalUnits
    if isDimensionless(y)
        return Dimensionless()
    else
        return SI(y.m, y.kg, y.s, y.K)
    end
end

function Base.:-(y::CGS, z::CGS)::PhysicalUnits
    cm = y.cm - z.cm
    g  = y.g - z.g
    s  = y.s - z.s
    C  = y.C - z.C
    if (cm == 0) && (g == 0) && (s == 0) && (C == 0)
        return Dimensionless()
    else
        return CGS(cm, g, s, C)
    end
end

function Base.:-(y::SI, z::SI)::PhysicalUnits
    m  = y.m - z.m
    kg = y.kg - z.kg
    s  = y.s - z.s
    K  = y.K - z.K
    if (m == 0) && (kg == 0) && (s == 0) && (K == 0)
        return Dimensionless()
    else
        return SI(m, kg, s, K)
    end
end

#=
-------------------------------------------------------------------------------
=#

# Methods extending their base methods.

function Base.:(copy)(u::Dimensionless)::Dimensionless
    c = u
    return c
end

function Base.:(copy)(u::CGS)::CGS
    c = u
    return c
end

function Base.:(copy)(u::SI)::SI
    c = u
    return c
end

function Base.:(deepcopy)(u::Dimensionless)::Dimensionless
    return Dimensionless()
end

function Base.:(deepcopy)(u::CGS)::CGS
    c = CGS(u.cm, u.g, u.s, u.C)
    return c
end

function Base.:(deepcopy)(u::SI)::SI
    c = SI(u.m, u.kg, u.s, u.K)
    return c
end
#=
--------------------------------------------------------------------------------
=#

# Methods that convert a system of units into a string.

function toString(u::Dimensionless)::String
    return ""
end

function toString(u::CGS)::String
    if u.g > 1
        if (u.cm > 0) || (u.s > 0) || (u.C > 0)
            if u.g == 2
                s1 = "g²⋅"
            elseif u.g == 3
                s1 = "g³⋅"
            elseif u.g == 4
                s1 = "g⁴⋅"
            else
                s1 = string("g^", string(u.g), "⋅")
            end
        else
            if u.g == 2
                s1 = "g²"
            elseif u.g == 3
                s1 = "g³"
            elseif u.g == 4
                s1 = "g⁴"
            else
                s1 = string("g^", string(u.g))
            end
        end
    elseif u.g == 1
        if (u.cm > 0) || (u.s > 0) || (u.C > 0)
            s1 = "g⋅"
        else
            s1 = "g"
        end
    else
        s1 = ""
    end
    if u.cm > 1
        if (u.s > 0) || (u.C > 0)
            if u.cm == 2
                s2 = "cm²⋅"
            elseif u.cm == 3
                s2 = "cm³⋅"
            elseif u.cm == 4
                s2 = "cm⁴⋅"
            else
                s2 = string("cm^", string(u.cm), "⋅")
            end
        else
            if u.cm == 2
                s2 = "cm²"
            elseif u.cm == 3
                s2 = "cm³"
            elseif u.cm == 4
                s2 = "cm⁴"
            else
                s2 = string("cm^", string(u.cm))
            end
        end
    elseif u.cm == 1
        if (u.s > 0) || (u.C > 0)
            s2 = "cm⋅"
        else
            s2 = "cm"
        end
    else
        s2 = ""
    end
    if u.s > 1
        if u.C > 0
            if u.s == 2
                s3 = "s²⋅"
            elseif u.s == 3
                s3 = "s³⋅"
            elseif u.s == 4
                s3 = "s⁴⋅"
            else
                s3 = string("s^", string(u.s), "⋅")
            end
        else
            if u.s == 2
                s3 = "s²"
            elseif u.s == 3
                s3 = "s³"
            elseif u.s == 4
                s3 = "s⁴"
            else
                s3 = string("s^", string(u.s))
            end
        end
    elseif u.s == 1
        if u.C > 0
            s3 = "s⋅"
        else
            s3 = "s"
        end
    else
        s3 = ""
    end
    if u.C > 1
        if u.C == 2
            s4 = "°C²"
        elseif u.C == 3
            s4 = "°C³"
        elseif u.C == 4
            s4 = "°C⁴"
        else
            s4 = string("°C^", string(u.C))
        end
    elseif u.C == 1
        s4 = "°C"
    else
        s4 = ""
    end
    count = 0
    if u.cm < 0
        count += 1
    end
    if u.g < 0
        count += 1
    end
    if u.s < 0
        count += 1
    end
    if u.C < 0
        count += 1
    end
    if count > 1
        if (u.cm < 1) && (u.g < 1) && (u.s < 1) && (u.C < 1)
            s5 = "1/("
        else
            s5 = "/("
        end
    elseif count == 1
        if (u.cm < 1) && (u.g < 1) && (u.s < 1) && (u.C < 1)
            s5 = "1/"
        else
            s5 = "/"
        end
    else
        s5 = ""
    end
    if u.g < -1
        if (u.cm < 0) || (u.s < 0) || (u.C < 0)
            if u.g == -2
                s6 = "g²⋅"
            elseif u.g == -3
                s6 = "g³⋅"
            elseif u.g == -4
                s6 = "g⁴⋅"
            else
                s6 = string("g^", string(-u.g), "⋅")
            end
        else
            if u.g == -2
                s6 = "g²"
            elseif u.g == -3
                s6 = "g³"
            elseif u.g == -4
                s6 = "g⁴"
            else
                s6 = string("g^", string(-u.g))
            end
        end
    elseif u.g == -1
        if (u.cm < 0) || (u.s < 0) || (u.C < 0)
            s6 = "g⋅"
        else
            s6 = "g"
        end
    else
        s6 = ""
    end
    if u.cm < -1
        if (u.s < 0) || (u.C < 0)
            if u.cm == -2
                s7 = "cm²⋅"
            elseif u.cm == -3
                s7 = "cm³⋅"
            elseif u.cm == -4
                s7 = "cm⁴⋅"
            else
                s7 = string("cm^", string(-u.cm), "⋅")
            end
        else
            if u.cm == -2
                s7 = "cm²"
            elseif u.cm == -3
                s7 = "cm³"
            elseif u.cm == -4
                s7 = "cm⁴"
            else
                s7 = string("cm^", string(-u.cm))
            end
        end
    elseif u.cm == -1
        if (u.s < 0) || (u.C < 0)
            s7 = "cm⋅"
        else
            s7 = "cm"
        end
    else
        s7 = ""
    end
    if u.s < -1
        if u.C < 0
            if u.s == -2
                s8 = "s²⋅"
            elseif u.s == -3
                s8 = "s³⋅"
            elseif u.s == -4
                s8 = "s⁴⋅"
            else
                s8 = string("s^", string(-u.s), "⋅")
            end
        else
            if u.s == -2
                s8 = "s²"
            elseif u.s == -3
                s8 = "s³"
            elseif u.s == -4
                s8 = "s⁴"
            else
                s8 = string("s^", string(-u.s))
            end
        end
    elseif u.s == -1
        if (u.C < 0)
            s8 = "s⋅"
        else
            s8 = "s"
        end
    else
        s8 = ""
    end
    if u.C < -1
        if u.C == -2
            s9 = "°C²"
        elseif u.C == -3
            s9 = "°C³"
        elseif u.C == -4
            s9 = "°C⁴"
        else
            s9 = string("°C^", string(-u.C))
        end
    elseif u.C == -1
        s9 = "°C"
    else
        s9 = ""
    end
    if count > 1
        s10 = ")"
    else
        s10 = ""
    end
    s = string(s1, s2, s3, s4, s5, s6, s7, s8, s9, s10)
    return s
end

function toString(u::SI)::String
    if u.kg > 1
        if (u.m > 0) || (u.s > 0) || (u.K > 0)
            if u.kg == 2
                s1 = "kg²⋅"
            elseif u.kg == 3
                s1 = "kg³⋅"
            elseif u.kg == 4
                s1 = "kg⁴⋅"
            else
                s1 = string("kg^", string(u.kg), "⋅")
            end
        else
            if u.kg == 2
                s1 = "kg²"
            elseif u.kg == 3
                s1 = "kg³"
            elseif u.kg == 4
                s1 = "kg⁴"
            else
                s1 = string("kg^", string(u.kg))
            end
        end
    elseif u.kg == 1
        if (u.m > 0) || (u.s > 0) || (u.K > 0)
            s1 = "kg⋅"
        else
            s1 = "kg"
        end
    else
        s1 = ""
    end
    if u.m > 1
        if (u.s > 0) || (u.K > 0)
            if u.m == 2
                s2 = "m²⋅"
            elseif u.m == 3
                s2 = "m³⋅"
            elseif u.m == 4
                s2 = "m⁴⋅"
            else
                s2 = string("m^", string(u.m), "⋅")
            end
        else
            if u.m == 2
                s2 = "m²"
            elseif u.m == 3
                s2 = "m³"
            elseif u.m == 4
                s2 = "m⁴"
            else
                s2 = string("m^", string(u.m))
            end
        end
    elseif u.m == 1
        if (u.s > 0) || (u.K > 0)
            s2 = "m⋅"
        else
            s2 = "m"
        end
    else
        s2 = ""
    end
    if u.s > 1
        if u.K > 0
            if u.s == 2
                s3 = "s²⋅"
            elseif u.s == 3
                s3 = "s³⋅"
            elseif u.s == 4
                s3 = "s⁴⋅"
            else
                s3 = string("s^", string(u.s), "⋅")
            end
        else
            if u.s == 2
                s3 = "s²"
            elseif u.s == 3
                s3 = "s³"
            elseif u.s == 4
                s3 = "s⁴"
            else
                s3 = string("s^", string(u.s))
            end
        end
    elseif u.s == 1
        if u.K > 0
            s3 = "s⋅"
        else
            s3 = "s"
        end
    else
        s3 = ""
    end
    if u.K > 1
        if u.K == 2
            s4 = "K²"
        elseif u.K == 3
            s4 = "K³"
        elseif u.K == 4
            s4 = "K⁴"
        else
            s4 = string("K^", string(u.K))
        end
    elseif u.K == 1
        s4 = "K"
    else
        s4 = ""
    end
    count = 0
    if u.m < 0
        count += 1
    end
    if u.kg < 0
        count += 1
    end
    if u.s < 0
        count += 1
    end
    if u.K < 0
        count += 1
    end
    if count > 1
        if (u.m < 1) && (u.kg < 1) && (u.s < 1) && (u.K < 1)
            s5 = "1/("
        else
            s5 = "/("
        end
    elseif count == 1
        if (u.m < 1) && (u.kg < 1) && (u.s < 1) && (u.K < 1)
            s5 = "1/"
        else
            s5 = "/"
        end
    else
        s5 = ""
    end
    if u.kg < -1
        if (u.m < 0) || (u.s < 0) || (u.K < 0)
            if u.kg == -2
                s6 = "kg²⋅"
            elseif u.kg == -3
                s6 = "kg³⋅"
            elseif u.kg == -4
                s6 = "kg⁴⋅"
            else
                s6 = string("kg^", string(-u.kg), "⋅")
            end
        else
            if u.kg == -2
                s6 = "kg²"
            elseif u.kg == -3
                s6 = "kg³"
            elseif u.kg == -4
                s6 = "kg⁴"
            else
                s6 = string("kg^", string(-u.kg))
            end
        end
    elseif u.kg == -1
        if (u.m < 0) || (u.s < 0) || (u.K < 0)
            s6 = "kg⋅"
        else
            s6 = "kg"
        end
    else
        s6 = ""
    end
    if u.m < -1
        if (u.s < 0) || (u.K < 0)
            if u.m == -2
                s7 = "m²⋅"
            elseif u.m == -3
                s7 = "m³⋅"
            elseif u.m == -4
                s7 = "m⁴⋅"
            else
                s7 = string("m^", string(-u.m), "⋅")
            end
        else
            if u.m == -2
                s7 = "m²"
            elseif u.m == -3
                s7 = "m³"
            elseif u.m == -4
                s7 = "m⁴"
            else
                s7 = string("m^", string(-u.m))
            end
        end
    elseif u.m == -1
        if (u.s < 0) || (u.K < 0)
            s7 = "m⋅"
        else
            s7 = "m"
        end
    else
        s7 = ""
    end
    if u.s < -1
        if u.K < 0
            if u.s == -2
                s8 = "s²⋅"
            elseif u.s == -3
                s8 = "s³⋅"
            elseif u.s == -4
                s8 = "s⁴⋅"
            else
                s8 = string("s^", string(-u.s), "⋅")
            end
        else
            if u.s == -2
                s8 = "s²"
            elseif u.s == -3
                s8 = "s³"
            elseif u.s == -4
                s8 = "s⁴"
            else
                s8 = string("s^", string(-u.s))
            end
        end
    elseif u.s == -1
        if u.K < 0
            s8 = "s⋅"
        else
            s8 = "s"
        end
    else
        s8 = ""
    end
    if u.K < -1
        if u.K == -2
            s9 = "K²"
        elseif u.K == -3
            s9 = "K³"
        elseif u.K == -4
            s9 = "K⁴"
        else
            s9 = string("K^", string(-u.K))
        end
    elseif u.K == -1
        s9 = "K"
    else
        s9 = ""
    end
    if count > 1
        s10 = ")"
    else
        s10 = ""
    end
    s = string(s1, s2, s3, s4, s5, s6, s7, s8, s9, s10)
    return s
end

#=
--------------------------------------------------------------------------------
=#

# Reading and writing physical units from/to a JSON file.

StructTypes.StructType(::Type{LowerUnits}) = StructTypes.Struct()

function toFile(y::PhysicalUnits, json_stream::IOStream)
    if isopen(json_stream)
        lu = LowerUnits(y)
        JSON3.write(json_stream, lu)
        write(json_stream, '\n')
    else
        msg = "The supplied JSON stream is not open."
        throw(ErrorException(msg))
    end
    flush(json_stream)
    return nothing
end

function fromFile(::Type{PhysicalUnits}, json_stream::IOStream)::PhysicalUnits
    if isopen(json_stream)
        lu = JSON3.read(readline(json_stream), LowerUnits)
        pu = PhysicalUnits(lu)
    else
        msg = "The supplied JSON stream is not open."
        throw(ErrorException(msg))
    end
    return pu
end

#=
--------------------------------------------------------------------------------
=#

# Specific units for the CGS system of units.

const BARYE      = CGS(-1, 1, -2, 0)   # units of stress
const CENTIGRADE = CGS(0, 0, 0, 1)     # units of degrees centigrade
const CENTIMETER = CGS(1, 0, 0, 0)     # units of length
const DYNE       = CGS(1, 1, -2, 0)    # units of force
const ERG        = CGS(2, 1, -2, 0)    # units of energy
const GRAM       = CGS(0, 1, 0, 0)     # units of mass

# Generic units implemented in the CGS system of units.

const CGS_ACCELERATION     = CGS(1, 0, -2, 0)
const CGS_AREA             = CGS(2, 0, 0, 0)
const CGS_COMPLIANCE       = CGS(1, -1, 2, 0)
const CGS_DAMPING          = CGS(0, 1, -1, 0)
const CGS_DIMENSIONLESS    = CGS(0, 0, 0, 0)
const CGS_DISPLACEMENT     = CGS(1, 0, 0, 0)
const CGS_ENERGY           = CGS(2, 1, -2, 0)
const CGS_ENERGYperMASS    = CGS(2, 0, -2, 0)
const CGS_ENTROPY          = CGS(2, 1, -2, -1)
const CGS_ENTROPYperMASS   = CGS(2, 0, -2, -1)
const CGS_FORCE            = CGS(1, 1, -2, 0)
const CGS_LENGTH           = CGS(1, 0, 0, 0)
const CGS_MASS             = CGS(0, 1, 0, 0)
const CGS_MASS_DENSITY     = CGS(-3, 1, 0, 0)
const CGS_MODULUS          = CGS(-1, 1, -2, 0)
const CGS_POWER            = CGS(2, 1, -3, 0)
const CGS_RECIPROCAL_TIME  = CGS(0, 0, -1, 0)
const CGS_SECOND           = CGS(0, 0, 1, 0)
const CGS_STIFFNESS        = CGS(0, 1, -2, 0)
const CGS_STRAIN           = CGS(0, 0, 0, 0)
const CGS_STRAIN_RATE      = CGS(0, 0, -1, 0)
const CGS_STRESS           = CGS(-1, 1, -2, 0)
const CGS_STRESS_RATE      = CGS(-1, 1, -3, 0)
const CGS_STRETCH          = CGS(0, 0, 0, 0)
const CGS_STRETCH_RATE     = CGS(0, 0, -1, 0)
const CGS_TEMPERATURE      = CGS(0, 0, 0, 1)
const CGS_TEMPERATURE_RATE = CGS(0, 0, -1, 1)
const CGS_TIME             = CGS(0, 0, 1, 0)
const CGS_VELOCITY         = CGS(1, 0, -1, 0)
const CGS_VOLUME           = CGS(3, 0, 0, 0)

# Specific units for the SI system of units.

const JOULE    = SI(2, 1, -2, 0)   # units of energy
const KELVIN   = SI(0, 0, 0, 1)    # units of temperature
const KILOGRAM = SI(0, 1, 0, 0)    # units of mass
const METER    = SI(1, 0, 0, 0)    # units of length
const NEWTON   = SI(1, 1, -2, 0)   # units of force
const PASCAL   = SI(-1, 1, -2, 0)  # units of stress

# Generic units implemented in the SI system of units.

const SI_ACCELERATION     = SI(1, 0, -2, 0)
const SI_AREA             = SI(2, 0, 0, 0)
const SI_COMPLIANCE       = SI(1, -1, 2, 0)
const SI_DAMPING          = SI(0, 1, -1, 0)
const SI_DIMENSIONLESS    = SI(0, 0, 0, 0)
const SI_DISPLACEMENT     = SI(1, 0, 0, 0)
const SI_ENERGY           = SI(2, 1, -2, 0)
const SI_ENERGYperMASS    = SI(2, 0, -2, 0)
const SI_ENTROPY          = SI(2, 1, -2, -1)
const SI_ENTROPYperMASS   = SI(2, 0, -2, -1)
const SI_FORCE            = SI(1, 1, -2, 0)
const SI_LENGTH           = SI(1, 0, 0, 0)
const SI_MASS             = SI(0, 1, 0, 0)
const SI_MASS_DENSITY     = SI(-3, 1, 0, 0)
const SI_MODULUS          = SI(-1, 1, -2, 0)
const SI_POWER            = SI(2, 1, -3, 0)
const SI_RECIPROCAL_TIME  = SI(0, 0, -1, 0)
const SI_SECOND           = SI(0, 0, 1, 0)
const SI_STIFFNESS        = SI(0, 1, -2, 0)
const SI_STRAIN           = SI(0, 0, 0, 0)
const SI_STRAIN_RATE      = SI(0, 0, -1, 0)
const SI_STRESS           = SI(-1, 1, -2, 0)
const SI_STRESS_RATE      = SI(-1, 1, -3, 0)
const SI_STRETCH          = SI(0, 0, 0, 0)
const SI_STRETCH_RATE     = SI(0, 0, -1, 0)
const SI_TEMPERATURE      = SI(0, 0, 0, 1)
const SI_TEMPERATURE_RATE = SI(0, 0, -1, 1)
const SI_TIME             = SI(0, 0, 1, 0)
const SI_VELOCITY         = SI(1, 0, -1, 0)
const SI_VOLUME           = SI(3, 0, 0, 0)

# end PhysicalSystemsOfUnits