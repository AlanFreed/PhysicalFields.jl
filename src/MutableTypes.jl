# MutableTypes

abstract type MType <: Number end

abstract type MNumber <: MType end

mutable struct MBool <: MType
    n::Bool  # Bool <: Integer <: Real <: Number
end

mutable struct MInteger <: MNumber
    n::Int64  # Int64 <: Signed <: Integer <: Real <: Number
end

mutable struct MRational <: MNumber
    n::Rational{Int64}  # Rational <: Real <: Number
end

mutable struct MReal <: MNumber
    n::Float64  # Float64 <: AbstractFloat <: Real <: Number
end

mutable struct MComplex <: MType
    n::Complex{Float64}  # Complex <: Number
end

#=
--------------------------------------------------------------------------------
=#

# Method get

function Base.:(get)(y::MBool)::Bool
    return y.n
end

function Base.:(get)(y::MInteger)::Integer
    return y.n
end

function Base.:(get)(y::MRational)::Rational
    return y.n
end

function Base.:(get)(y::MReal)::Real
    return y.n
end

function Base.:(get)(y::MComplex)::Complex
    return y.n
end

# Method set!.

function set!(y::MBool, x::Bool)
    y.n = x
    return nothing
end

function set!(y::MInteger, x::Integer)
    y.n = convert(Int64, x)
    return nothing
end

function set!(y::MRational, x::Rational)
    y.n = convert(Rational{Int64}, x)
    return nothing
end

function set!(y::MReal, x::Real)
    y.n = convert(Float64, x)
    return nothing
end

function set!(y::MComplex, x::Complex)
    y.n = convert(Complex{Float64}, x)
    return nothing
end

#=
--------------------------------------------------------------------------------
=#

# Method toString

function toString(y::Bool; aligned::Bool=false)::String
    s = string(y)
    if aligned && (y == true)
        return string(' ', s)
    else
        return s
    end
end

function toString(y::Integer; aligned::Bool=false)::String
    s = string(y)
    if aligned && (y ≥ 0)
        return string(' ', s)
    else
        return s
    end
end

function toString(y::Rational; aligned::Bool=false)::String
    s = string(y)
    if aligned && (y ≥ 0)
        return string(" ", s)
    else
        return s
    end
end

function toString(y::Real;
                  format::Char='E',
                  precision::Int=5,
                  aligned::Bool=false)::String
    if y == -0.0 || y == 0.0
        if format == 'e'
            if precision == 7
                s = "0.000000e+00"
            elseif precision == 6
                s = "0.00000e+00"
            elseif precision == 5
                s = "0.0000e+00"
            elseif precision == 4
                s = "0.000e+00"
            else
                s = "0.00e+00"
            end
        elseif format == 'E'
            if precision == 7
                s = "0.000000E+00"
            elseif precision == 6
                s = "0.00000E+00"
            elseif precision == 5
                s = "0.0000E+00"
            elseif precision == 4
                s = "0.000E+00"
            else
                s = "0.00E+00"
            end
        else  # format = 'f' or 'F'
            if precision == 7
                s = "0.000000"
            elseif precision == 6
                s = "0.00000"
            elseif precision == 5
                s = "0.0000"
            elseif precision == 4
                s = "0.000"
            else
                s = "0.00"
            end
        end
    elseif isnan(y)
        if format == 'e' || format == 'E'
            if precision == 7
                s = "NaN         "
            elseif precision == 6
                s = "NaN        "
            elseif precision == 5
                s = "NaN       "
            elseif precision == 4
                s = "NaN      "
            else
                s = "NaN     "
            end
        else # format = 'f' or 'F'
            if precision == 7
                s = "NaN     "
            elseif precision == 6
                s = "NaN    "
            elseif precision == 5
                s = "NaN   "
            elseif precision == 4
                s = "NaN  "
            else
                s = "NaN "
            end
        end
    elseif isinf(y)
        if format == 'e' || format == 'E'
            if precision == 7
                s = "Inf         "
            elseif precision == 6
                s = "Inf        "
            elseif precision == 5
                s = "Inf       "
            elseif precision == 4
                s = "Inf      "
            else
                s = "Inf     "
            end
        else # format = 'f' or 'F'
            if precision == 7
                s = "Inf     "
            elseif precision == 6
                s = "Inf    "
            elseif precision == 5
                s = "Inf   "
            elseif precision == 4
                s = "Inf  "
            else
                s = "Inf "
            end
        end
        if y < 0.0
            s = string("-", s)
        end
    else
        if format == 'e'
            if precision == 7
                s = @sprintf "%0.6e" y;
            elseif precision == 6
                s = @sprintf "%0.5e" y;
            elseif precision == 5
                s = @sprintf "%0.4e" y;
            elseif precision == 4
                s = @sprintf "%0.3e" y;
            else
                s = @sprintf "%0.2e" y;
            end
        elseif format == 'E'
            if precision == 7
                s = @sprintf "%0.6E" y;
            elseif precision == 6
                s = @sprintf "%0.5E" y;
            elseif precision == 5
                s = @sprintf "%0.4E" y;
            elseif precision == 4
                s = @sprintf "%0.3E" y;
            else
                s = @sprintf "%0.2E" y;
            end
        else  # format = 'f' or 'F'
            if precision == 7
                s = @sprintf "%0.6f" y;
            elseif precision == 6
                s = @sprintf "%0.5f" y;
            elseif precision == 5
                s = @sprintf "%0.4f" y;
            elseif precision == 4
                s = @sprintf "%0.3f" y;
            else
                s = @sprintf "%0.2f" y;
            end
        end
    end
    if aligned && ((y ≥ -0.0) || isnan(y))
        s = string(" ", s)
    end
    return s
end

function toString(y::Complex;
                  format::Char='E',
                  precision::Int=5,
                  aligned::Bool=false)::String
    reS = toString(real(y); format, precision, aligned)
    if imag(y) ≥ -0.0
        imS = toString(imag(y); format, precision)
        str = string(reS, " + ", imS, "im")
    else
        imS = toString(abs(imag(y)); format, precision)
        str = string(reS, " - ", imS, "im")
    end
    return str
end

#=
--------------------------------------------------------------------------------
=#

function toString(y::MBool; aligned::Bool=false)::String
    return toString(y.n; aligned)
end

function toString(y::MInteger; aligned::Bool=false)::String
    return toString(y.n; aligned)
end

function toString(y::MRational; aligned::Bool=false)::String
    return toString(y.n; aligned)
end

function toString(y::MReal;
                  format::Char='E',
                  precision::Int=5,
                  aligned::Bool=false)::String
    return toString(y.n; format, precision, aligned)
end

function toString(y::MComplex;
                  format::Char='E',
                  precision::Int=5,
                  aligned::Bool=false)::String
    return toString(y.n; format, precision, aligned)
end

#=
--------------------------------------------------------------------------------
=#

# Method copy

function Base.:(copy)(y::MBool)::MBool
    return MBool(copy(y.n))
end

function Base.:(copy)(y::MInteger)::MInteger
    return MInteger(copy(y.n))
end

function Base.:(copy)(y::MRational)::MRational
    return MRational(copy(y.n))
end

function Base.:(copy)(y::MReal)::MReal
    return MReal(copy(y.n))
end

function Base.:(copy)(y::MComplex)::MComplex
    return MComplex(copy(y.n))
end

# Method deepcopy

function Base.:(deepcopy)(y::MBool)::MBool
    return MBool(deepcopy(y.n))
end

function Base.:(deepcopy)(y::MInteger)::MInteger
    return MInteger(deepcopy(y.n))
end

function Base.:(deepcopy)(y::MRational)::MRational
    return MRational(deepcopy(y.n))
end

function Base.:(deepcopy)(y::MReal)::MReal
    return MReal(deepcopy(y.n))
end

function Base.:(deepcopy)(y::MComplex)::MComplex
    return MComplex(deepcopy(y.n))
end

#=
--------------------------------------------------------------------------------
=#

# Overloaded operators belonging to instances of type MType are: ==, ≠, ≈, !
# Types Int64, Rational{Int64} and Float64 are all subtypes of type Real.

# Operator ==

function Base.:(==)(y::MType, z::MType)::Bool
    if isequal(y.n, z.n)
        return true
    else
        return false
    end
end

function Base.:(==)(y::Union{Bool,Real,Complex}, z::MType)::Bool
    if isequal(y, z.n)
        return true
    else
        return false
    end
end

function Base.:(==)(y::MType, z::Union{Bool,Real,Complex})::Bool
    if isequal(y.n, z)
        return true
    else
        return false
    end
end

# Operator ≠

function Base.:≠(y::MType, z::MType)::Bool
    if isequal(y.n, z.n)
        return false
    else
        return true
    end
end

function Base.:≠(y::Union{Bool,Real,Complex}, z::MType)::Bool
    if isequal(y, z.n)
        return false
    else
        return true
    end
end

function Base.:≠(y::MType, z::Union{Bool,Real,Complex})::Bool
    if isequal(y.n, z)
        return false
    else
        return true
    end
end

# Operator ≈

function Base.:≈(y::MReal, z::MReal)::Bool
    if y.n ≈ z.n
        return true
    else
        return false
    end
end

function Base.:≈(y::Real, z::MReal)::Bool
    if y ≈ z.n
        return true
    else
        return false
    end
end

function Base.:≈(y::MReal, z::Real)::Bool
    if y.n ≈ z
        return true
    else
        return false
    end
end

function Base.:≈(y::MComplex, z::MComplex)::Bool
    if (real(y.n) ≈ real(z.n)) && (imag(y.n) ≈ imag(z.n))
        return true
    else
        return false
    end
end

function Base.:≈(y::Complex, z::MComplex)::Bool
    if (real(y) ≈ real(z.n)) && (imag(y) ≈ imag(z.n))
        return true
    else
        return false
    end
end

function Base.:≈(y::MComplex, z::Complex)::Bool
    if (real(y.n) ≈ real(z)) && (imag(y.n) ≈ imag(z))
        return true
    else
        return false
    end
end

# Operator !

function Base.:!(y::MBool)::Bool
    return !y.n
end

#=
--------------------------------------------------------------------------------
=#

# Overloaded operators belonging to instances of MNumber are: <, ≤, ≥, >
# Types Int64, Rational{Int64}, and Float64 are all subtypes of type Real.

# Operator <

function Base.:<(y::MNumber, z::MNumber)::Bool
    if isless(y.n, z.n)
        return true
    else
        return false
    end
end

function Base.:<(y::Real, z::MNumber)::Bool
    if isless(y, z.n)
        return true
    else
        return false
    end
end

function Base.:<(y::MNumber, z::Real)::Bool
    if isless(y.n, z)
        return true
    else
        return false
    end
end

# Operator ≤

function Base.:≤(y::MNumber, z::MNumber)::Bool
    if isless(y.n, z.n) || isequal(y.n, z.n)
        return true
    else
        return false
    end
end

function Base.:≤(y::Real, z::MNumber)::Bool
    if isless(y, z.n) || isequal(y, z.n)
        return true
    else
        return false
    end
end

function Base.:≤(y::MNumber, z::Real)::Bool
    if isless(y.n, z) || isequal(y.n, z)
        return true
    else
        return false
    end
end

# Operator ≥

function Base.:≥(y::MNumber, z::MNumber)::Bool
    if isless(y.n, z.n)
        return false
    else
        return true
    end
end

function Base.:≥(y::Real, z::MNumber)::Bool
    if isless(y, z.n)
        return false
    else
        return true
    end
end

function Base.:≥(y::MNumber, z::Real)::Bool
    if isless(y.n, z)
        return false
    else
        return true
    end
end

# Operator >

function Base.:>(y::MNumber, z::MNumber)::Bool
    if isless(y.n, z.n) || isequal(y.n, z.n)
        return false
    else
        return true
    end
end

function Base.:>(y::Real, z::MNumber)::Bool
    if isless(y, z.n) || isequal(y, z.n)
        return false
    else
        return true
    end
end

function Base.:>(y::MNumber, z::Real)::Bool
    if isless(y.n, z) || isequal(y.n, z)
        return false
    else
        return true
    end
end

# Arithmetic operators for all instances of MNumber and MComplex.
# Unary operator +

function Base.:+(y::MInteger)::Integer
    return +y.n
end

function Base.:+(y::MRational)::Rational
    return  +y.n
end

function Base.:+(y::MReal)::Real
    return +y.n
end

function Base.:+(y::MComplex)::Complex
    return +y.n
end

# Binary operator +

function Base.:+(y::MInteger, z::MInteger)::Integer
    return y.n + z.n
end

function Base.:+(y::MInteger, z::Integer)::Integer
    return  y.n + z
end

function Base.:+(y::Integer, z::MInteger)::Integer
    return y + z.n
end

function Base.:+(y::MRational, z::MRational)::Rational
    return y.n + z.n
end

function Base.:+(y::Union{Integer, Rational}, z::MRational)::Rational
    return y + z.n
end

function Base.:+(y::MRational, z::Union{Integer, Rational})::Rational
    return y.n + z
end

function Base.:+(y::MRational, z::MInteger)::Rational
    return  y.n + z.n
end

function Base.:+(y::MInteger, z::MRational)::Rational
    return y.n + z.n
end

function Base.:+(y::MReal, z::MReal)::Real
    return y.n + z.n
end

function Base.:+(y::MReal, z::Union{MInteger,MRational})::Real
    return y.n + convert(Float64, z.n)
end

function Base.:+(y::Union{MInteger,MRational}, z::MReal)::Real
    return convert(Float64, y.n) + z.n
end

function Base.:+(y::MReal, z::Real)::Real
    return y.n + z
end

function Base.:+(y::Real, z::MReal)::Real
    return y + z.n
end

function Base.:+(y::MComplex, z::MComplex)::Complex
    return y.n + z.n
end

function Base.:+(y::MComplex, z::Complex)::Complex
    return y.n + z
end

function Base.:+(y::Complex, z::MComplex)::Complex
    return y + z.n
end

function Base.:+(y::MComplex, z::MNumber)::Complex
    return y.n + convert(Complex{Float64}, z.n)
end

function Base.:+(y::MNumber, z::MComplex)::Complex
    return convert(Complex{Float64}, y.n) + z.n
end

function Base.:+(y::MComplex, z::Real)::Complex
    return y.n + convert(Complex{Float64}, z)
end

function Base.:+(y::Real, z::MComplex)::Complex
    return convert(Complex{Float64}, y) + z.n
end

# Unary operator -

function Base.:-(y::MInteger)::Integer
    return -y.n
end

function Base.:-(y::MRational)::Rational
    return  -y.n
end

function Base.:-(y::MReal)::Real
    return -y.n
end

function Base.:-(y::MComplex)::Complex
    return -y.n
end

# Binary operator -

function Base.:-(y::MInteger, z::MInteger)::Integer
    return y.n - z.n
end

function Base.:-(y::MInteger, z::Integer)::Integer
    return  y.n - z
end

function Base.:-(y::Integer, z::MInteger)::Integer
    return y - z.n
end

function Base.:-(y::MRational, z::MRational)::Rational
    return y.n - z.n
end

function Base.:-(y::Union{Integer, Rational}, z::MRational)::Rational
    return y - z.n
end

function Base.:-(y::MRational, z::Union{Integer, Rational})::Rational
    return y.n - z
end

function Base.:-(y::MRational, z::MInteger)::Rational
    return  y.n - z.n
end

function Base.:-(y::MInteger, z::MRational)::Rational
    return y.n - z.n
end

function Base.:-(y::MReal, z::MReal)::Real
    return y.n - z.n
end

function Base.:-(y::MReal, z::Real)::Real
    return y.n - z
end

function Base.:-(y::Real, z::MReal)::Real
    return y - z.n
end

function Base.:-(y::MReal, z::Union{MInteger,MRational})::Real
    return y.n - convert(Float64, z.n)
end

function Base.:-(y::Union{MInteger,MRational}, z::MReal)::Real
    return convert(Float64, y.n) - z.n
end

function Base.:-(y::MComplex, z::MComplex)::Complex
    return y.n - z.n
end

function Base.:-(y::MComplex, z::Complex)::Complex
    return y.n - z
end

function Base.:-(y::Complex, z::MComplex)::Complex
    return y - z.n
end

function Base.:-(y::MComplex, z::MNumber)::Complex
    return y.n - convert(Complex{Float64}, z.n)
end

function Base.:-(y::MNumber, z::MComplex)::Complex
    return convert(Complex{Float64}, y.n) - z.n
end

function Base.:-(y::MComplex, z::Real)::Complex
    return y.n - convert(Complex{Float64}, z)
end

function Base.:-(y::Real, z::MComplex)::Complex
    return convert(Complex{Float64}, y) - z.n
end

# Operator *

function Base.:*(y::MInteger, z::MInteger)::Integer
    return y.n * z.n
end

function Base.:*(y::MInteger, z::Integer)::Integer
    return  y.n * z
end

function Base.:*(y::Integer, z::MInteger)::Integer
    return y * z.n
end

function Base.:*(y::MRational, z::MRational)::Rational
    return y.n * z.n
end

function Base.:*(y::Union{Integer, Rational}, z::MRational)::Rational
    return y * z.n
end

function Base.:*(y::MRational, z::Union{Integer, Rational})::Rational
    return y.n * z
end

function Base.:*(y::MRational, z::MInteger)::Rational
    return  y.n * z.n
end

function Base.:*(y::MInteger, z::MRational)::Rational
    return y.n * z.n
end

function Base.:*(y::MReal, z::MReal)::Real
    return y.n * z.n
end

function Base.:*(y::MReal, z::Real)::Real
    return y.n * z
end

function Base.:*(y::Real, z::MReal)::Real
    return y * z.n
end

function Base.:*(y::MReal, z::Union{MInteger,MRational})::Real
    return y.n * convert(Float64, z.n)
end

function Base.:*(y::Union{MInteger,MRational}, z::MReal)::Real
    return convert(Float64, y.n) * z.n
end

function Base.:*(y::MComplex, z::MComplex)::Complex
    return y.n * z.n
end

function Base.:*(y::MComplex, z::Complex)::Complex
    return y.n * z
end

function Base.:*(y::Complex, z::MComplex)::Complex
    return y * z.n
end

function Base.:*(y::MComplex, z::MNumber)::Complex
    return y.n * convert(Complex{Float64}, z.n)
end

function Base.:*(y::MNumber, z::MComplex)::Complex
    return convert(Complex{Float64}, y.n) * z.n
end

function Base.:*(y::MComplex, z::Real)::Complex
    return y.n * convert(Complex{Float64}, z)
end

function Base.:*(y::Real, z::MComplex)::Complex
    return convert(Complex{Float64}, y) * z.n
end

# Operators ÷, %, //, /

function Base.:÷(y::MInteger, z::MInteger)::Integer
    return y.n ÷ z.n
end

function Base.:÷(y::MInteger, z::Integer)::Integer
    return  y.n ÷ z
end

function Base.:÷(y::Integer, z::MInteger)::Integer
    return y ÷ z.n
end

function Base.:%(y::MInteger, z::MInteger)::Integer
    return y.n % z.n
end

function Base.:%(y::MInteger, z::Integer)::Integer
    return  y.n % z
end

function Base.:%(y::Integer, z::MInteger)::Integer
    return y % z.n
end

function Base.:(//)(y::MInteger, z::MInteger)::Rational
    return y.n // z.n
end

function Base.:(//)(y::MInteger, z::Union{Integer, Rational})::Rational
    return  y.n // z
end

function Base.:(//)(y::Union{Integer, Rational}, z::MInteger)::Rational
    return y // z.n
end

function Base.:(//)(y::MRational, z::MRational)::Rational
    return y.n // z.n
end

function Base.:(//)(y::Rational, z::Union{MInteger, MRational})::Rational
    return y // z.n
end

function Base.:(//)(y::Union{MInteger, MRational}, z::Rational)::Rational
    return y.n // z
end

function Base.:(//)(y::MRational, z::Integer)::Rational
    return  y.n // z
end

function Base.:(//)(y::Integer, z::MRational)::Rational
    return y // z.n
end

function Base.:/(y::MReal, z::MReal)::Real
    return y.n / z.n
end

function Base.:/(y::MReal, z::Real)::Real
    return y.n / z
end

function Base.:/(y::Real, z::MReal)::Real
    return y / z.n
end

function Base.:/(y::MReal, z::Union{MInteger,MRational})::Real
    return y.n / convert(Float64, z.n)
end

function Base.:/(y::Union{MInteger,MRational}, z::MReal)::Real
    return convert(Float64, y.n) / z.n
end

function Base.:/(y::MComplex, z::MComplex)::Complex
    return y.n / z.n
end

function Base.:/(y::MComplex, z::Complex)::Complex
    return y.n / z
end

function Base.:/(y::Complex, z::MComplex)::Complex
    return y / z.n
end

function Base.:/(y::MComplex, z::MNumber)::Complex
    return y.n / convert(Complex{Float64}, z.n)
end

function Base.:/(y::MNumber, z::MComplex)::Complex
    return convert(Complex{Float64}, y.n) / z.n
end

function Base.:/(y::MComplex, z::Real)::Complex
    return y.n / convert(Complex{Float64}, z)
end

function Base.:/(y::Real, z::MComplex)::Complex
    return convert(Complex{Float64}, y) / z.n
end

# Operator ^

function Base.:^(y::MInteger, z::MInteger)::Integer
    return y.n ^ z.n
end

function Base.:^(y::MInteger, z::Integer)::Integer
    return  y.n ^ z
end

function Base.:^(y::Integer, z::MInteger)::Integer
    return y ^ z.n
end

function Base.:^(y::MReal, z::MReal)::Real
    return y.n ^ z.n
end

function Base.:^(y::MReal, z::Real)::Real
    return y.n ^ z
end

function Base.:^(y::Real, z::MReal)::Real
    return y ^ z.n
end

function Base.:^(y::MReal, z::Union{MInteger,MRational})::Real
    return y.n ^ z.n
end

function Base.:^(y::Union{MInteger,MRational}, z::MReal)::Real
    return convert(Float64, y.n) ^ z.n
end

function Base.:^(y::MComplex, z::MComplex)::Complex
    return y.n ^ z.n
end

function Base.:^(y::MComplex, z::Complex)::Complex
    return y.n ^ z
end

function Base.:^(y::Complex, z::MComplex)::Complex
    return y ^ z.n
end

function Base.:^(y::MComplex, z::MNumber)::Complex
    return y.n ^ z.n
end

function Base.:^(y::MNumber, z::MComplex)::Complex
    return convert(Complex{Float64}, y.n) ^ z.n
end

function Base.:^(y::MComplex, z::Real)::Complex
    return y.n ^ z
end

function Base.:^(y::Real, z::MComplex)::Complex
    return convert(Complex{Float64}, y) ^ z.n
end

# Method common to all numeric types.

function Base.:(abs)(y::MInteger)::Integer
    return abs(y.n)
end

function Base.:(abs)(y::MRational)::Rational
    return abs(y.n)
end

function Base.:(abs)(y::MReal)::Real
    return abs(y.n)
end

function Base.:(abs)(y::MComplex)::Complex
    return abs(y.n)
end

# Method common to all non-complex types.

function Base.:(sign)(y::MNumber)::Real
    return sign(y.n)
end

# Methods specific to type MRational.

function Base.:(numerator)(y::MRational)::Integer
    return numerator(y.n)
end

function Base.:(denominator)(y::MRational)::Integer
    return denominator(y.n)
end

# Methods specific to type MReal.

function Base.:(round)(y::MReal)::Real
    return round(y.n)
end

function Base.:(ceil)(y::MReal)::Real
    return ceil(y.n)
end

function Base.:(floor)(y::MReal)::Real
    return floor(y.n)
end

function Base.:(atan)(y::MNumber, x::MNumber)::Real
    return atan(y.n, x.n)
end

function Base.:(atan)(y::MNumber, x::Real)::Real
    return atan(y.n, x)
end

function Base.:(atan)(y::Real, x::MNumber)::Real
    return atan(y, x.n)
end

# Methods specific to type MComplex.

function Base.:(abs2)(y::MComplex)::Real
    return abs2(y.n)
end

function Base.:(real)(y::MComplex)::Real
    return real(y.n)
end

function Base.:(imag)(y::MComplex)::Real
    return imag(y.n)
end

function Base.:(conj)(y::MComplex)::Complex
    return conj(y.n)
end

function Base.:(angle)(y::MComplex)::Real
    return angle(y.n)
end

# Math functions for types MNumber and MComplex

function Base.:(sin)(y::MNumber)::Real
    return sin(y.n)
end

function Base.:(sin)(y::MComplex)::Complex
    return sin(y.n)
end

function Base.:(cos)(y::MNumber)::Real
    return cos(y.n)
end

function Base.:(cos)(y::MComplex)::Complex
    return cos(y.n)
end

function Base.:(tan)(y::MNumber)::Real
    return tan(y.n)
end

function Base.:(tan)(y::MComplex)::Complex
    return tan(y.n)
end

function Base.:(sinh)(y::MNumber)::Real
    return sinh(y.n)
end

function Base.:(sinh)(y::MComplex)::Complex
    return sinh(y.n)
end

function Base.:(cosh)(y::MNumber)::Real
    return cosh(y.n)
end

function Base.:(cosh)(y::MComplex)::Complex
    return cosh(y.n)
end

function Base.:(tanh)(y::MNumber)::Real
    return tanh(y.n)
end

function Base.:(tanh)(y::MComplex)::Complex
    return tanh(y.n)
end

function Base.:(asin)(y::MNumber)::Real
    return asin(y.n)
end

function Base.:(asin)(y::MComplex)::Complex
    return asin(y.n)
end

function Base.:(acos)(y::MNumber)::Real
    return acos(y.n)
end

function Base.:(acos)(y::MComplex)::Complex
    return acos(y.n)
end

function Base.:(atan)(y::MNumber)::Real
    return atan(y.n)
end

function Base.:(atan)(y::MComplex)::Complex
    return atan(y.n)
end

function Base.:(asinh)(y::MNumber)::Real
    return asinh(y.n)
end

function Base.:(asinh)(y::MComplex)::Complex
    return asinh(y.n)
end

function Base.:(acosh)(y::MNumber)::Real
    return acosh(y.n)
end

function Base.:(acosh)(y::MComplex)::Complex
    return acosh(y.n)
end

function Base.:(atanh)(y::MNumber)::Real
    return atanh(y.n)
end

function Base.:(atanh)(y::MComplex)::Complex
    return atanh(y.n)
end

function Base.:(log)(y::MNumber)::Real
    return log(y.n)
end

function Base.:(log)(y::MComplex)::Complex
    return log(y.n)
end

function Base.:(log2)(y::MNumber)::Real
    return log2(y.n)
end

function Base.:(log2)(y::MComplex)::Complex
    return log2(y.n)
end

function Base.:(log10)(y::MNumber)::Real
    return log10(y.n)
end

function Base.:(log10)(y::MComplex)::Complex
    return log10(y.n)
end

function Base.:(exp)(y::MNumber)::Real
    return exp(y.n)
end

function Base.:(exp)(y::MComplex)::Complex
    return exp(y.n)
end

function Base.:(exp2)(y::MNumber)::Real
    return exp2(y.n)
end

function Base.:(exp2)(y::MComplex)::Complex
    return exp2(y.n)
end

function Base.:(exp10)(y::MNumber)::Real
    return exp10(y.n)
end

function Base.:(exp10)(y::MComplex)::Complex
    return exp10(y.n)
end

function Base.:(sqrt)(y::MNumber)::Real
    return sqrt(y.n)
end

function Base.:(sqrt)(y::MComplex)::Complex
    return sqrt(y.n)
end
