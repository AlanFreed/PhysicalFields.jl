# MutableTypes

# Helper types used for reading and writing objects from/to a JSON3.jl file.
# These lower types are not intended for general use.

mutable struct LowerRational
    num::Int64  # Int64 <: Signed <: Integer <: Real <: Number
    den::Int64  # Int64 <: Signed <: Integer <: Real <: Number

    # constructors

    function LowerRational()
        new(convert(Int64, 0), convert(Int64, 1))
    end

    function LowerRational(r::Rational)
        new(convert(Int64, numerator(r)), convert(Int64, denominator(r)))
    end

    function LowerRational(num::Integer, den::Integer)
        num = convert(Int64, num)
        den = convert(Int64, den)
        # Code came from a Case Study of Constructors at docs.JuliaLang.org.
        if num == 0 && den == 0
            msg = "invalid rational: 0//0"
            throw(ErrorException(msg))
        end
        num = flipsign(num, den)
        den = flipsign(den, den)
        g   = gcd(num, den)
        num = div(num, g)
        den = div(den, g)
        new(num, den)
    end
end

mutable struct LowerComplex
    real_part::Float64  # Float64 <: AbstractFloat <: Real <: Number
    imag_part::Float64  # Float64 <: AbstractFloat <: Real <: Number

    # constructors

    function LowerComplex()
        new(convert(Float64, 0.0), convert(Float64, 0.0))
    end

    function LowerComplex(c::Complex)
        new(convert(Float64, real(c)), convert(Float64, imag(c)))
    end

    function LowerComplex(real_part::Real, imag_part::Real)
        real_part = convert(Float64, real_part)
        imag_part = convert(Float64, imag_part)
        new(real_part, imag_part)
    end
end

#=
-------------------------------------------------------------------------------
=#

# Exported types

abstract type MType <: Number end

abstract type MNumber <: MType end

# All constructors are internal for instances of MType.

mutable struct MBool <: MType
    n::Bool  # Bool <: Integer <: Real <: Number

    # constructors

    function MBool()
        new(false)
    end

    function MBool(b::Bool)
        new(b)
    end
end

mutable struct MInteger <: MNumber
    n::Int64  # Int64 <: Signed <: Integer <: Real <: Number

    # constructors

    function MInteger()
        new(convert(Int64, 0))
    end

    function MInteger(i::Integer)
        new(convert(Int64, i))
    end
end

mutable struct MRational <: MNumber
    n::Rational{Int64}  # Rational <: Real <: Number

    # constructors

    function MRational()
        new(convert(Rational{Int64}, 0//1))
    end

    function MRational(r::Rational)
        new(convert(Rational{Int64}, r))
    end

    function MRational(lr::LowerRational)
        new(lr.num//lr.den)
    end

    function MRational(num::Integer, den::Integer)
        num = convert(Int64, num)
        den = convert(Int64, den)
        # Code came from a Case Study of Constructors at docs.JuliaLang.org.
        if num == 0 && den == 0
            msg = "invalid rational: 0//0"
            throw(ErrorException(msg))
        end
        num = flipsign(num, den)
        den = flipsign(den, den)
        g   = gcd(num, den)
        num = div(num, g)
        den = div(den, g)
        new(num//den)
    end
end

mutable struct MReal <: MNumber
    n::Float64  # Float64 <: AbstractFloat <: Real <: Number

    # constructors

    function MReal()
        new(convert(Float64, 0.0))
    end

    function MReal(r::Real)
        new(convert(Float64, r))
    end
end

mutable struct MComplex <: MType
    n::Complex{Float64}  # Complex <: Number

    # constructors

    function MComplex()
        new(convert(Complex{Float64}, 0.0))
    end

    function MComplex(c::Complex)
        new(convert(Complex{Float64}, c))
    end

    function MComplex(lc::LowerComplex)
        new(lc.real_part + im*lc.imag_part)
    end

    function MComplex(real_part::Real, imag_part::Real)
        real_part = convert(Float64, real_part)
        imag_part = convert(Float64, imag_part)
        new(real_part + im*imag_part)
    end
end

# Methods required to serialize (write to file) instances of these types.

function Base.:(Bool)(mb::MBool)::Bool
    return mb.n
end

function Base.:(Int64)(mi::MInteger)::Int64
    return mi.n
end

function Base.:(Rational)(lr::LowerRational)::Rational{Int64}
    return lr.num//lr.den
end

function Base.:(Rational)(mr::MRational)::Rational{Int64}
    return mr.n
end

function Base.:(Float64)(mr::MReal)::Float64
    return mr.n
end

function Base.:(Complex)(lc::LowerComplex)::Complex{Float64}
    return lc.real_part + im*lc.imag_part
end

function Base.:(Complex)(mc::MComplex)::Complex{Float64}
    return mc.n
end

function LowerRational(r::MRational)::LowerRational
    return LowerRational(numerator(r.n), denominator(r.n))
end

function LowerComplex(c::MComplex)::LowerComplex
    return LowerComplex(real(c.n), imag(c.n))
end

#=
-------------------------------------------------------------------------------
=#

# Type declarations needed to work with JSON3 files.

StructTypes.StructType(::Type{MBool}) = StructTypes.Mutable()

StructTypes.StructType(::Type{MInteger}) = StructTypes.Mutable()

StructTypes.StructType(::Type{MReal}) = StructTypes.Mutable()

StructTypes.StructType(::Type{LowerRational}) = StructTypes.Struct()
StructTypes.serializationname(::Type{LowerRational}) = ((:"num", :"num"), (:"den", :"den"))

StructTypes.StructType(::Type{Rational}) = StructTypes.CustomStruct()
StructTypes.lowertype(Rational) = LowerRational
StructTypes.lower(x::Rational) = LowerRational(numerator(x.n), denominator(x.n))
StructTypes.construct(Rational, num::Integer, den::Integer) = Rational(num, den)

StructTypes.StructType(::Type{MRational}) = StructTypes.CustomStruct()
StructTypes.lowertype(MRational) = LowerRational
StructTypes.lower(x::MRational) = LowerRational(numerator(x.n), denominator(x.n))
StructTypes.construct(MRational, num::Integer, den::Integer) = MRational(num, den)

StructTypes.StructType(::Type{LowerComplex}) = StructTypes.Struct()
StructTypes.serializationname(::Type{LowerComplex}) = ((:"real_part", :"real_part"), (:"imag_part", :"imag_part"))

StructTypes.StructType(::Type{Complex}) = StructTypes.CustomStruct()
StructTypes.lowertype(Complex) = LowerComplex
StructTypes.lower(x::Complex) = LowerComplex(real(x.n), imag(x.n))
StructTypes.construct(Complex, real_part::Real, imag_part::Real) = Complex(real_part, imag_part)

StructTypes.StructType(::Type{MComplex}) = StructTypes.CustomStruct()
StructTypes.lowertype(MComplex) = LowerComplex
StructTypes.lower(x::MComplex) = LowerComplex(real(x.n), imag(x.n))
StructTypes.construct(MComplex, real_part::Real, imag_part::Real) = MComplex(real_part, imag_part)

#=
-------------------------------------------------------------------------------
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
-------------------------------------------------------------------------------
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
-------------------------------------------------------------------------------
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
-------------------------------------------------------------------------------
=#

"""
    openJSONReader(my_dir_path::String, my_file_name::String)::IOStream

Returns a JSON stream attached to a file with a `.json` extension, opened in
read-only mode. The file is located at the directory `my_dir_path` with a name
of `my_file_name`, including a `.json` extension.
"""
function openJSONReader(my_dir_path::String, my_file_name::String)::IOStream
    if !isdir(my_dir_path)
        msg = "The specified directory path is not a valid directory."
        throw(ErrorException(msg))
    end
    (name, extension) = splitext(my_file_name)
    file_name = string(name, ".json")
    my_file = string(my_dir_path, file_name)
    if isfile(my_file)
        json_stream = open(my_file; lock=true, read=true, write=false, create=false, truncate=false, append=false)
    else
        msg = "The specified file does not exist in the specified directory."
        throw(ErrorException(msg))
    end
    return json_stream
end

"""
    openJSONWriter(my_dir_path::String, my_file_name::String)::IOStream

Rutruns a JSON stream attached to a file with a `.json` extension, opened in
write, create, append mode.  The file is located at directory `my_dir_path`
with a name of `my_file_name`, including a `.json` extension. If the file does
not exisit, it is created.
"""
function openJSONWriter(my_dir_path::String, my_file_name::String)::IOStream
    if !isdir(my_dir_path)
        msg = "The specified directory path is not a valid directory."
        throw(ErrorException(msg))
    end
    (name, extension) = splitext(my_file_name)
    file_name = string(name, ".json")
    my_file = string(my_dir_path, file_name)
    if isfile(my_file)
        json_stream = open(my_file; lock=true, read=false, write=true, create=false, truncate=true, append=true)
    else
        json_stream = open(my_file; lock=true, read=false, write=true, create=true, truncate=true, append=true)
    end
    seekstart(json_stream)
    return json_stream
end

"""
    closeJSONStream(json_stream::IOStream)

Flushes the `json_stream` and closes the file that it was attached to.
"""
function closeJSONStream(json_stream::IOStream)
    if isopen(json_stream)
        close(json_stream)
    end
    return nothing
end

# Write the built-in types in their 64-bit format to a JSON file.

function toFile(y::String, json_stream::IOStream)
    if isopen(json_stream)
        JSON3.write(json_stream, y)
        write(json_stream, '\n')
    else
        msg = "The supplied JSON stream is not open."
        throw(ErrorException(msg))
    end
    flush(json_stream)
    return nothing
end

function toFile(y::Bool, json_stream::IOStream)
    if isopen(json_stream)
        JSON3.write(json_stream, y)
        write(json_stream, '\n')
    else
        msg = "The supplied JSON stream is not open."
        throw(ErrorException(msg))
    end
    flush(json_stream)
    return nothing
end

function toFile(y::Integer, json_stream::IOStream)
    if isopen(json_stream)
        JSON3.write(json_stream, convert(Int64, y))
        write(json_stream, '\n')
    else
        msg = "The supplied JSON stream is not open."
        throw(ErrorException(msg))
    end
    flush(json_stream)
    return nothing
end

function toFile(y::Rational, json_stream::IOStream)
    if isopen(json_stream)
        lr = LowerRational(y)
        JSON3.write(json_stream, lr)
        write(json_stream, '\n')
    else
        msg = "The supplied JSON stream is not open."
        throw(ErrorException(msg))
    end
    flush(json_stream)
    return nothing
end

function toFile(y::Real, json_stream::IOStream)
    if isopen(json_stream)
        JSON3.write(json_stream, convert(Float64, y))
        write(json_stream, '\n')
    else
        msg = "The supplied JSON stream is not open."
        throw(ErrorException(msg))
    end
    flush(json_stream)
    return nothing
end

function toFile(y::Complex, json_stream::IOStream)
    if isopen(json_stream)
        lc = LowerComplex(y)
        JSON3.write(json_stream, lc)
        write(json_stream, '\n')
    else
        msg = "The supplied JSON stream is not open."
        throw(ErrorException(msg))
    end
    flush(json_stream)
    return nothing
end

# Write the mutable versions of these built-in types to a JSON file.

function toFile(y::MBool, json_stream::IOStream)
    if isopen(json_stream)
        JSON3.write(json_stream, y)
        write(json_stream, '\n')
    else
        msg = "The supplied JSON stream is not open."
        throw(ErrorException(msg))
    end
    flush(json_stream)
    return nothing
end

function toFile(y::MInteger, json_stream::IOStream)
    if isopen(json_stream)
        JSON3.write(json_stream, y)
        write(json_stream, '\n')
    else
        msg = "The supplied JSON stream is not open."
        throw(ErrorException(msg))
    end
    flush(json_stream)
    return nothing
end

function toFile(y::MRational, json_stream::IOStream)
    if isopen(json_stream)
        lr = LowerRational(y)
        JSON3.write(json_stream, lr)
        write(json_stream, '\n')
    else
        msg = "The supplied JSON stream is not open."
        throw(ErrorException(msg))
    end
    flush(json_stream)
    return nothing
end

function toFile(y::MReal, json_stream::IOStream)
    if isopen(json_stream)
        JSON3.write(json_stream, y)
        write(json_stream, '\n')
    else
        msg = "The supplied JSON stream is not open."
        throw(ErrorException(msg))
    end
    flush(json_stream)
    return nothing
end

function toFile(y::MComplex, json_stream::IOStream)
    if isopen(json_stream)
        lc = LowerComplex(y)
        JSON3.write(json_stream, lc)
        write(json_stream, '\n')
    else
        msg = "The supplied JSON stream is not open."
        throw(ErrorException(msg))
    end
    flush(json_stream)
    return nothing
end

# Read the built-in types from a JSON file.

function fromFile(::Type{String}, json_stream::IOStream)::String
    if isopen(json_stream)
        y = JSON3.read(readline(json_stream), String)
    else
        msg = "The supplied JSON stream is not open."
        throw(ErrorException(msg))
    end
    return y
end

function fromFile(::Type{Bool}, json_stream::IOStream)::Bool
    if isopen(json_stream)
        y = JSON3.read(readline(json_stream), Bool)
    else
        msg = "The supplied JSON stream is not open."
        throw(ErrorException(msg))
    end
    return y
end

function fromFile(::Type{Integer}, json_stream::IOStream)::Integer
    if isopen(json_stream)
        y = JSON3.read(readline(json_stream), Int64)
    else
        msg = "The supplied JSON stream is not open."
        throw(ErrorException(msg))
    end
    return y
end

function fromFile(::Type{Rational}, json_stream::IOStream)::Rational
    if isopen(json_stream)
        r = JSON3.read(readline(json_stream), LowerRational)
        y = Rational(r)
    else
        msg = "The supplied JSON stream is not open."
        throw(ErrorException(msg))
    end
    return y
end

function fromFile(::Type{Real}, json_stream::IOStream)::Real
    if isopen(json_stream)
        y = JSON3.read(readline(json_stream), Float64)
    else
        msg = "The supplied JSON stream is not open."
        throw(ErrorException(msg))
    end
    return y
end

function fromFile(::Type{Complex}, json_stream::IOStream)::Complex
    if isopen(json_stream)
        c = JSON3.read(readline(json_stream), LowerComplex)
        y = Complex(c)
    else
        msg = "The supplied JSON stream is not open."
        throw(ErrorException(msg))
    end
    return y
end

# Read the mutable versions of these built-in types from a JSON file.

function fromFile(::Type{MBool}, json_stream::IOStream)::MBool
    if isopen(json_stream)
        y = JSON3.read(readline(json_stream), MBool)
    else
        msg = "The supplied JSON stream is not open."
        throw(ErrorException(msg))
    end
    return y
end

function fromFile(::Type{MInteger}, json_stream::IOStream)::MInteger
    if isopen(json_stream)
        y = JSON3.read(readline(json_stream), MInteger)
    else
        msg = "The supplied JSON stream is not open."
        throw(ErrorException(msg))
    end
    return y
end

function fromFile(::Type{MRational}, json_stream::IOStream)::MRational
    if isopen(json_stream)
        r = JSON3.read(readline(json_stream), LowerRational)
        y = MRational(r)
    else
        msg = "The supplied JSON stream is not open."
        throw(ErrorException(msg))
    end
    return y
end

function fromFile(::Type{MReal}, json_stream::IOStream)::MReal
    if isopen(json_stream)
        y = JSON3.read(readline(json_stream), MReal)
    else
        msg = "The supplied JSON stream is not open."
        throw(ErrorException(msg))
    end
    return y
end

function fromFile(::Type{MComplex}, json_stream::IOStream)::MComplex
    if isopen(json_stream)
        c = JSON3.read(readline(json_stream), LowerComplex)
        y = MComplex(c)
    else
        msg = "The supplied JSON stream is not open."
        throw(ErrorException(msg))
    end
    return y
end

#=
-------------------------------------------------------------------------------
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
-------------------------------------------------------------------------------
=#

# Overloaded operators belonging to instances of type MType are: ==, ≠, ≈, !
# Types Int64, Rational{Int64} and Float64 are all sub-types of type Real.

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
-------------------------------------------------------------------------------
=#

# Overloaded operators belonging to instances of MNumber are: <, ≤, ≥, >
# Types Int64, Rational{Int64}, and Float64 are all sub-types of type Real.

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

# end MutableTypes