# Persistence

# This file contains methods for writing data to a file, and then reading it
# back in again. A JSON (Java Script Object Notation) file format is adopted,
# supplied by the Julia package JSON3.jl. Objects that are handled include 
# the builtin types of String, Dict, Real and Vector{<:Real}, where the 
# primative types of abstract type Real are: Bool, Int8, Int16, Int32, Int64,
# Int128, BigInt, UInt8, UInt16, UInt32, UInt64, UInt128, Float16, Float32,
# Float64 and BigFloat. Information for the primative type is stored along 
# with its value so that when read in from file the correct type for the 
# value is restored, i.e., the 'lazy' feature of JSON3 is overcome.

# Also included in this file are methods that write representations of these
# objects to string. Values, vectors of values, and matrices of values can be
# represented as strings. These need not be exact representations, as they are
# intended for use in the REPL, etc., to assess matters of concern/interest.

# See ./test/testPersistence.jl as an example for how to use these methods.

#=
-------------------------------------------------------------------------------
=#

# Opening and closing of IO streams attached to JSON files.

"""
# openJSONReader

```julia
json_stream = openJSONReader(my_dir_path::String, my_file_name::String)::IOStream
```
Returns a JSON (Java Script Object Notation) stream `json_stream` attached to a file that is opened in read-only mode. The file is located in directory `my_dir_path` with a name of `my_file_name`, including a `.json` extension.
"""
function openJSONReader(my_dir_path::String, my_file_name::String)::IOStream
    if !isdir(my_dir_path)
        error("The specified directory path is not a valid directory.")
    end
    (name, extension) = splitext(my_file_name)
    file_name = string(name, ".json")
    my_file = string(my_dir_path, file_name)
    if isfile(my_file)
        json_stream = open(my_file; lock=true, read=true, write=false, create=false, truncate=false, append=false)
    else
        error("The specified file does not exist in the specified directory.")
    end
    return json_stream
end

"""
# openJSONWriter

```julia
json_stream = openJSONWriter(my_dir_path::String, my_file_name::String)::IOStream
```
Returns a JSON (Java Script Object Notation) stream `json_stream` attached to a file that is opened in write, create and append mode. The file is located in directory `my_dir_path` with a name of `my_file_name`, including a `.json` extension. If the file does not exisit, it is created.
"""
function openJSONWriter(my_dir_path::String, my_file_name::String)::IOStream
    if !isdir(my_dir_path)
        error("The specified directory path is not a valid directory.")
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
# closeJSONStream

```julia
closeJSONStream(json_stream::IOStream)
```
Flushes the `json_stream` and then closes the file that this IO stream is attached to.
"""
function closeJSONStream(json_stream::IOStream)
    if isopen(json_stream)
        flush(json_stream)
        close(json_stream)
    end
    return nothing
end

#=
-------------------------------------------------------------------------------
=#

# Serializing to a JSON file.

# built-in types

"""
# toFile

Calls to this method must satisfy one of the following interfaces:
```julia
    toFile(y::String, json_stream::IOStream)
    toFile(y::Dict, json_stream::IOStream)
    toFile(y::Real, json_stream::IOStream)
    toFile(y::Vector{<:Real}, json_stream::IOStream)
```
where methods `openJSONReader`, `openJSONWriter` and `closeJSONStream` can be called upon to open and close the `IOStream` that is a `json_stream`.

The primative types that implement abstract type `Real` are: `Bool`, `Int8`, `Int16`, `Int32`, `Int64`, `Int128`, `BigInt`, `UInt8`, `UInt16`, `UInt32`, `UInt64`, `UInt128`, `Float16`, `Float32`, `Float64` and `BigFloat`.

All primative types of `Real` are handled by method `toFile(y::Real, json_stream::IOStream)`, e.g., `toFile(true, json_stream)` writes boolean `true` to file, while `toFile(1, json_stream)` writes integer `1` to file as an instance of type `Int`; likewise, vectors of these primative types are handled by method `toFile(y::Vector{<:Real}, json_stream::IOStream)`.

Information establishing the primative type of an object being stored to file is written along with its value, so that when read back in from file the restored value will be assigned the actual type of the value that was originally saved to file. The *lazy* feature of `JSON3` is not adhered to.
"""
function toFile(y::String, json_stream::IOStream)
    if isopen(json_stream)
        JSON3.write(json_stream, y)
        write(json_stream, '\n')
        flush(json_stream)
    else
        error("The supplied JSON stream is not open.")
    end
    return nothing
end

function toFile(y::Dict, json_stream::IOStream)
    if isopen(json_stream)
        JSON3.write(json_stream, y)
        write(json_stream, '\n')
        flush(json_stream)
    else
        error("The supplied JSON stream is not open.")
    end
    return nothing
end

# numbers

function toFile(y::Real, json_stream::IOStream)
    if isopen(json_stream)
        JSON3.write(json_stream, string(typeof(y)))
        write(json_stream, '\n')
        JSON3.write(json_stream, y)
        write(json_stream, '\n')
        flush(json_stream)
    else
        error("The supplied JSON stream is not open.")
    end
    return nothing
end

# vectors

function toFile(y::Vector{<:Real}, json_stream::IOStream)
    if isopen(json_stream)
        JSON3.write(json_stream, string(typeof(y)))
        write(json_stream, '\n')
        JSON3.write(json_stream, y)
        write(json_stream, '\n')
        flush(json_stream)
    else
        error("The supplied JSON stream is not open.")
    end
    return nothing
end

#=
-------------------------------------------------------------------------------
=#

# Deserializing from a JSON file.

# built-in types

"""
# fromFile

Calls to this method must satisfy one of the following interfaces:
```julia
    s = fromFile(::Type{String}, json_stream::IOStream)::String
    d = fromFile(::Type{Dict},   json_stream::IOStream)::Dict
    x = fromFile(::Type{<:Real}, json_stream::IOStream)::Real
    v = fromFile(::Type{Vector}, json_stream::IOStream)::Vector
```
where methods `openJSONReader`, `openJSONWriter` and `closeJSONStream` can be called upon to open and close the `IOStream` that is a `json_stream`.

All primitive types of abstract type `Real` (viz., `Bool`, `Int8`, `Int16`, `Int32`, `Int64`, `Int128`, `BigInt`, `UInt8`, `UInt16`, `UInt32`, `UInt64`, `UInt128`, `Float16`, `Float32`, `Float64` and `BigFloat`) are handled. Singleton values are handled via a call to `fromFile(::Type{<:Real}, json_stream::IOStream)`, e.g., if a boolean was stored to a file, then a boolean will be read back in by either a call to `fromFile(Real, json_stream)` or a call to `fromFile(Bool, json_stream)`. Vector values are handled by a call to `fromFile(Vector, json_stream)` with the type of vector being restored coming from information stored to file.
"""
function fromFile(::Type{String}, json_stream::IOStream)::String
    if isopen(json_stream)
        return JSON3.read(readline(json_stream), String)
    else
        error("The supplied JSON stream is not open.")
    end
end

function fromFile(::Type{Dict}, json_stream::IOStream)::Dict
    if isopen(json_stream)
        y = JSON3.read(readline(json_stream), Dict)
    else
        error("The supplied JSON stream is not open.")
    end
    # y is an immutable dictionary. copy(y) returns y as a mutable dictionary.
    return copy(y)
end

# JSON3 adopts 'lazy' type setting. To overcome this, method convert is called.
function fromFile(::Type{<:Real}, json_stream::IOStream)::Real
    if isopen(json_stream)
        t = JSON3.read(readline(json_stream), String)
        if isequal(t, "Bool")
            x = JSON3.read(readline(json_stream), Bool)
            return convert(Bool, x)
        elseif isequal(t, "Float16")
            x = JSON3.read(readline(json_stream), Float16)
            return convert(Float16, x)
        elseif isequal(t, "Float32")
            x = JSON3.read(readline(json_stream), Float32)
            return convert(Float32, x)
        elseif isequal(t, "Float64")
            x = JSON3.read(readline(json_stream), Float64)
            return convert(Float64, x)
        elseif isequal(t, "BigFloat")
            x = JSON3.read(readline(json_stream), BigFloat)
            return convert(BigFloat, x)
        elseif isequal(t, "Int8")
            x = JSON3.read(readline(json_stream), Int8)
            return convert(Int8, x)
        elseif isequal(t, "Int16")
            x = JSON3.read(readline(json_stream), Int16)
            return convert(Int16, x)
        elseif isequal(t, "Int32")
            x = JSON3.read(readline(json_stream), Int32)
            return convert(Int32, x)
        elseif isequal(t, "Int64")
            x = JSON3.read(readline(json_stream), Int64)
            return convert(Int64, x)
        elseif isequal(t, "Int128")
            x = JSON3.read(readline(json_stream), Int128)
            return convert(Int128, x)
        elseif isequal(t, "BigInt")
            x = JSON3.read(readline(json_stream), BigInt)
            return convert(BigInt, x)
        elseif isequal(t, "UInt8")
            x = JSON3.read(readline(json_stream), UInt8)
            return convert(UInt8, x)
        elseif isequal(t, "UInt16")
            x = JSON3.read(readline(json_stream), UInt16)
            return convert(UInt16, x)
        elseif isequal(t, "UInt32")
            x = JSON3.read(readline(json_stream), UInt32)
            return convert(UInt32, x)
        elseif isequal(t, "UInt64")
            x = JSON3.read(readline(json_stream), UInt64)
            return convert(UInt64, x)
        elseif isequal(t, "UInt128")
            x = JSON3.read(readline(json_stream), UInt128)
            return convert(UInt128, x)
        else
            error("Unknown concrete type of abstract type Real.")
        end
    else
        error("The supplied JSON stream is not open.")
    end
end # fromFile

# vectors

# These type casting functions not only ensure the correct type,
# but also enable the elements of these vectors to be mutable,
# as JSON3 returns vectors whose elements are immutable.

function _convertBoolVec(v::Vector{<:Real})::Vector{Bool}
    if eltype(v) == Bool
        return copy(v)
    else
        len = length(v)
        vec = Vector{Bool}(undef, len)
        for i in 1:len
            vec[i] = convert(Bool, v[i])
        end
        return vec
    end
end # _convertBoolVec

function _convertInt8Vec(v::Vector{<:Real})::Vector{Int8}
    if eltype(v) == Int8
        return copy(v)
    else
        len = length(v)
        vec = Vector{Int8}(undef, len)
        for i in 1:len
            vec[i] = convert(Int8, v[i])
        end
        return vec
    end
end # _convertInt8Vec

function _convertInt16Vec(v::Vector{<:Real})::Vector{Int16}
    if eltype(v) == Int16
        return copy(v)
    else
        len = length(v)
        vec = Vector{Int16}(undef, len)
        for i in 1:len
            vec[i] = convert(Int16, v[i])
        end
        return vec
    end
end # _convertInt16Vec

function _convertInt32Vec(v::Vector{<:Real})::Vector{Int32}
    if eltype(v) == Int32
        return copy(v)
    else
        len = length(v)
        vec = Vector{Int32}(undef, len)
        for i in 1:len
            vec[i] = convert(Int32, v[i])
        end
        return vec
    end
end # _convertInt32Vec

function _convertInt64Vec(v::Vector{<:Real})::Vector{Int64}
    if eltype(v) == Int64
        return copy(v)
    else
        len = length(v)
        vec = Vector{Int64}(undef, len)
        for i in 1:len
            vec[i] = convert(Int64, v[i])
        end
        return vec
    end
end # _convertInt64Vec

function _convertInt128Vec(v::Vector{<:Real})::Vector{Int128}
    if eltype(v) == Int128
        return copy(v)
    else
        len = length(v)
        vec = Vector{Int128}(undef, len)
        for i in 1:len
            vec[i] = convert(Int128, v[i])
        end
        return vec
    end
end # _convertInt128Vec

function _convertBigIntVec(v::Vector{<:Real})::Vector{BigInt}
    if eltype(v) == BigInt
        return copy(v)
    else
        len = length(v)
        vec = Vector{BigInt}(undef, len)
        for i in 1:len
            vec[i] = convert(BigInt, v[i])
        end
        return vec
    end
end # _convertBigIntVec

function _convertUInt8Vec(v::Vector{<:Real})::Vector{UInt8}
    if eltype(v) == UInt8
        return copy(v)
    else
        len = length(v)
        vec = Vector{UInt8}(undef, len)
        for i in 1:len
            vec[i] = convert(UInt8, v[i])
        end
        return vec
    end
end # _convertUInt8Vec

function _convertUInt16Vec(v::Vector{<:Real})::Vector{UInt16}
    if eltype(v) == UInt16
        return copy(v)
    else
        len = length(v)
        vec = Vector{UInt16}(undef, len)
        for i in 1:len
            vec[i] = convert(UInt16, v[i])
        end
        return vec
    end
end # _convertUInt16Vec

function _convertUInt32Vec(v::Vector{<:Real})::Vector{UInt32}
    if eltype(v) == UInt32
        return copy(v)
    else
        len = length(v)
        vec = Vector{UInt32}(undef, len)
        for i in 1:len
            vec[i] = convert(UInt32, v[i])
        end
        return vec
    end
end # _convertUInt32Vec

function _convertUInt64Vec(v::Vector{<:Real})::Vector{UInt64}
    if eltype(v) == UInt64
        return copy(v)
    else
        len = length(v)
        vec = Vector{UInt64}(undef, len)
        for i in 1:len
            vec[i] = convert(UInt64, v[i])
        end
        return vec
    end
end # _convertUInt64Vec

function _convertUInt128Vec(v::Vector{<:Real})::Vector{UInt128}
    if eltype(v) == UInt128
        return copy(v)
    else
        len = length(v)
        vec = Vector{UInt128}(undef, len)
        for i in 1:len
            vec[i] = convert(UInt128, v[i])
        end
        return vec
    end
end # _convertUInt128Vec

function _convertFloat16Vec(v::Vector{<:Real})::Vector{Float16}
    if eltype(v) == Float16
        return copy(v)
    else
        len = length(v)
        vec = Vector{Float16}(undef, len)
        for i in 1:len
            vec[i] = convert(Float16, v[i])
        end
        return vec
    end
end # _convertFloat16Vec

function _convertFloat32Vec(v::Vector{<:Real})::Vector{Float32}
    if eltype(v) == Float32
        return copy(v)
    else
        len = length(v)
        vec = Vector{Float32}(undef, len)
        for i in 1:len
            vec[i] = convert(Float32, v[i])
        end
        return vec
    end
end # _convertFloat32Vec

function _convertFloat64Vec(v::Vector{<:Real})::Vector{Float64}
    if eltype(v) == Float64
        return copy(v)
    else
        len = length(v)
        vec = Vector{Float64}(undef, len)
        for i in 1:len
            vec[i] = convert(Float64, v[i])
        end
        return vec
    end
end # _convertFloat64Vec

function _convertBigFloatVec(v::Vector{<:Real})::Vector{BigFloat}
    if eltype(v) == BigFloat
        return copy(v)
    else
        len = length(v)
        vec = Vector{BigFloat}(undef, len)
        for i in 1:len
            vec[i] = convert(BigFloat, v[i])
        end
        return vec
    end
end # _convertBigFloatVec

function fromFile(::Type{Vector}, json_stream::IOStream)::Vector
    if isopen(json_stream)
        t = JSON3.read(readline(json_stream), String)
        # v is an immutable vector. _convert... makes it a mutable vector.
        if isequal(t, "Vector{Bool}")
            v = JSON3.read(readline(json_stream), Vector{Bool})
            return _convertBoolVec(v)
        elseif isequal(t, "Vector{Float16}")
            v = JSON3.read(readline(json_stream), Vector{Float16})
            return _convertFloat16Vec(v)
        elseif isequal(t, "Vector{Float32}")
            v = JSON3.read(readline(json_stream), Vector{Float32})
            return _convertFloat32Vec(v)
        elseif isequal(t, "Vector{Float64}")
            v = JSON3.read(readline(json_stream), Vector{Float64})
            return _convertFloat64Vec(v)
        elseif isequal(t, "Vector{BigFloat}")
            v = JSON3.read(readline(json_stream), Vector{BigFloat})
            return _convertBigFloatVec(v)
        elseif isequal(t, "Vector{Int8}")
            v = JSON3.read(readline(json_stream), Vector{Int8})
            return _convertInt8Vec(v)
        elseif isequal(t, "Vector{Int16}")
            v = JSON3.read(readline(json_stream), Vector{Int16})
            return _convertInt16Vec(v)
        elseif isequal(t, "Vector{Int32}")
            v = JSON3.read(readline(json_stream), Vector{Int32})
            return _convertInt32Vec(v)
        elseif isequal(t, "Vector{Int64}")
            v = JSON3.read(readline(json_stream), Vector{Int64})
            return _convertInt64Vec(v)
        elseif isequal(t, "Vector{Int128}")
            v = JSON3.read(readline(json_stream), Vector{Int128})
            return _convertInt128Vec(v)
        elseif isequal(t, "Vector{BigInt}")
            v = JSON3.read(readline(json_stream), Vector{BigInt})
            return _convertBigIntVec(v)
        elseif isequal(t, "Vector{UInt8}")
            v = JSON3.read(readline(json_stream), Vector{UInt8})
            return _convertUInt8Vec(v)
        elseif isequal(t, "Vector{UInt16}")
            v = JSON3.read(readline(json_stream), Vector{UInt16})
            return _convertUInt16Vec(v)
        elseif isequal(t, "Vector{UInt32}")
            v = JSON3.read(readline(json_stream), Vector{UInt32})
            return _convertUInt32Vec(v)
        elseif isequal(t, "Vector{UInt64}")
            v = JSON3.read(readline(json_stream), Vector{UInt64})
            return _convertUInt64Vec(v)
        elseif isequal(t, "Vector{UInt128}")
            v = JSON3.read(readline(json_stream), Vector{UInt128})
            return _convertUInt128Vec(v)
        else
            error("Unknown concrete type of Vector{<:Real}.")
        end
    else
        error("The supplied JSON stream is not open.")
    end
end # fromFile

#=
-------------------------------------------------------------------------------
=#

# Method toString for built-in boolean types.

"""
# toString

Provides a string representation for builtin types that are subtypes to types `Real`, `Vector{<:Real}` and `Matrix{<:Real}`. These need not be exact representations, because their intention is for displaying results in the REPL, etc., as a means of informing the user during a runtime. Ellipses may appear in vector and matrix representations if their size is otherwise too large to fit onto a line or a printed page, respectively.

A call to this method must satisfy one of the following interfaces or, via multiple dispatch, any other implementation of this method.

For values:
```julia
    s = toString(y::Bool)::String
    s = toString(y::Integer)::String
    s = toString(y::AbstractFloat)::String
```
for vectors of values:
```julia
    s = toString(v::Vector{Bool})::String
    s = toString(v::Vector{<:Integer})::String
    s = toString(v::Vector{<:AbstractFloat})::String
```
and for matrices of values:
```julia
    s = toString(m::Matrix{Bool})::String
    s = toString(m::Matrix{<:Integer})::String
    s = toString(m::Matrix{<:AbstractFloat})::String
```

This method is intended to provide a visual inspection of a field, e.g., for use in the REPL. It is not intended to be an accurate representation; consequently, there is no corresponding `fromString` method.
"""
function toString(y::Bool; aligned::Bool=false)::String
    if y == true
        if aligned
            s = " true"
        else
            s = "true"
        end
    else
        s = "false"
    end
    return s
end

function toString(v::Vector{Bool})::String
    v_len = length(v)
    # Establish how many entries are to be printed out.
    if v_len < 12
        len = v_len
    else
        len = 12
    end
    # Create a string representation for this vector.
    s = string('{', toString(v[1]))
    if len == v_len
        for i in 2:len
            s *= ' '
            s *= toString(v[i])
        end
    else
        for i in 2:len-2
            s *= ' '
            s *= toString(v[i])
        end
        s *= " ⋯ "
        s *= toString(v[v_len])
    end
    s *= string("}ᵀ")
    return s
end

function toString(m::Matrix{Bool})::String
    (m_rows, m_cols) = size(m)
    # Establish how many rows are to be printed out.
    if m_rows < 36
        rows = m_rows
    else
        rows = 36
    end
    # Establish how many columns are to be printed out.
    if m_cols < 12
        cols = m_cols
    else
        cols = 12
    end
    # Create a string representation for this matrix.
    s = ""
    for row in 1:rows
        if row == 1
            s *= '⌈'
        elseif row < rows
            s *= '|'
        else
            s *= '⌊'
        end
        if rows == m_rows
            s *= toString(m[row,1]; aligned=true)
            for col in 2:cols-2
                s *= ' '
                s *= toString(m[row,col]; aligned=true)
            end
            if cols == m_cols
                s *= ' '
                s *= toString(m[row,cols-1]; aligned=true)
            else
                s *= " ⋯"
            end
            s *= ' '
            s *= toString(m[row,m_cols]; aligned=true)
        else # rows < m_rows
            if row < rows-1
                s *= toString(m[row,1]; aligned=true)
                for col in 2:cols-2
                    s *= ' '
                    s *= toString(m[row,col]; aligned=true)
                end
                if cols == m_cols
                    s *= ' '
                    s *= toString(m[row,cols-1]; aligned=true)
                else
                    s *= " ⋯"
                end
                s *= ' '
                s *= toString(m[row,m_cols]; aligned=true)
            elseif row == rows-1
                s *= "  ⋮  "
                if cols == m_cols
                    for col in 2:cols
                        s *= "   ⋮  "
                    end
                else
                    for col in 2:cols-2
                        s *= "   ⋮  "
                    end
                    s *= " ⋱   ⋮  "
                end
            else # (m_rows > rows) && (row == m_rows)
                s *= toString(m[m_rows,1]; aligned=true)
                for col in 2:cols-2
                    s *= ' '
                    s *= toString(m[m_rows,col]; aligned=true)
                end
                if cols == m_cols
                    s *= ' '
                    s *= toString(m[m_rows,cols-1]; aligned=true)
                else
                    s *= " ⋯"
                end
                s *= ' '
                s *= toString(m[m_rows,m_cols]; aligned=true)
            end
        end
        if row == 1
            s *= '⌉'
        elseif row < rows
            s *= '|'
        else
            s *= '⌋'
        end
        if row < rows
            s *= "\n"
        end
    end
    return s
end

# Method toString for built-in integer types.

function toString(y::Integer; digits::Int=0)::String
    s = @sprintf "%i" abs(y);
    if y < 0
        s = string('-', s)
    end
    while length(s) < digits
        s = string(' ', s)
    end
    return s
end

function toString(v::Vector{<:Integer})::String
    v_len = length(v)
    chars = 0
    # Establish how many entries are to be printed out.
    if v[v_len] < 0
        chars += ndigits(v[v_len]) + 1
    else
        chars += ndigits(v[v_len])
    end
    len = 1
    for i in 1:v_len-1
        if v[i] < 0
            chars += ndigits(v[i]) + 2
        else
            chars += ndigits(v[i]) + 1
        end
        if chars > 69
            break
        end
        len += 1
    end
    # Create a string representation for this vector.
    s = "{"
    s *= toString(v[1])
    if len == v_len
        for i in 2:len
            s *= ' '
            s *= toString(v[i])
        end
    else
        for i in 2:len-2
            s *= ' '
            s *= toString(v[i])
        end
        s *= " ⋯ "
        s *= toString(v[v_len])
    end
    s *= "}ᵀ"
    return s
end

function toString(m::Matrix{<:Integer})::String
    (m_rows, m_cols) = size(m)
    # Determine the number of rows and columns to print out.
    is_neg = false
    chars = 0
    for row in 1:m_rows
        for col in 1:m_cols
            if !is_neg && m[row,col] < 0
                is_neg = true
            end
            chars = max(chars, ndigits(m[row,col]))
        end
    end
    if is_neg
        chars += 1
    end
    half_chars = chars ÷ 2
    extra_char = chars % 2
    cols = min(m_cols, 70÷(chars+1))
    rows = min(m_rows, 36)
    # Create a string representation for this matrix.
    s = ""
    for row in 1:rows
        if row == 1
            s *= '⌈'
        elseif row < rows
            s *= '|'
        else
            s *= '⌊'
        end
        if rows == m_rows
            s *= toString(m[row,1]; digits=chars)
            for col in 2:cols-2
                s *= ' '
                s *= toString(m[row,col]; digits=chars)
            end
            if cols == m_cols
                s *= ' '
                s *= toString(m[row,cols-1]; digits=chars)
            else
                s *= " ⋯"
            end
            s *= ' '
            s *= toString(m[row,m_cols]; digits=chars)
        else # rows < m_rows
            if row < rows-1
                s *= toString(m[row,1]; digits=chars)
                for col in 2:cols-2
                    s *= ' '
                    s *= toString(m[row,col]; digits=chars)
                end
                if cols == m_cols
                    s *= ' '
                    s *= toString(m[row,cols-1]; digits=chars)
                else
                    s *= " ⋯"
                end
                s *= ' '
                s *= toString(m[row,m_cols]; digits=chars)
            elseif row == rows-1
                if cols == m_cols
                    for j in 1:cols
                        for char in 1:half_chars
                            s *= ' '
                        end
                        s *= '⋮'
                        if extra_char == 1
                            for char in 1:half_chars
                                s *= ' '
                            end
                        else
                            for char in 1:half_chars-1
                                s *= ' '
                            end
                        end
                        if j < cols
                            s *= ' '
                        end
                    end
                else # cols < m_cols
                    for j in 1:cols-2
                        for char in 1:half_chars
                            s *= ' '
                        end
                        s *= '⋮'
                        if extra_char == 1
                            for char in 1:half_chars
                                s *= ' '
                            end
                        else
                            for char in 1:half_chars-1
                                s *= ' '
                            end
                        end
                        s *= ' '
                    end
                    s *= "⋱ "
                    for char in 1:half_chars
                        s *= ' '
                    end
                    s *= '⋮'
                    if extra_char == 1
                        for char in 1:half_chars
                            s *= ' '
                        end
                    else
                        for char in 1:half_chars-1
                            s *= ' '
                        end
                    end
                end
            else # m_rows > rows && row == m_rows
                s *= toString(m[m_rows,1]; digits=chars)
                for col in 2:cols-2
                    s *= ' '
                    s *= toString(m[m_rows,col]; digits=chars)
                end
                if cols == m_cols
                    s *= ' '
                    s *= toString(m[m_rows,cols-1]; digits=chars)
                else
                    s *= " ⋯"
                end
                s *= ' '
                s *= toString(m[m_rows,m_cols]; digits=chars)
            end
        end
        if row == 1
            s *= '⌉'
        elseif row < rows
            s *= '|'
        else
            s *= '⌋'
        end
        if row < rows
            s *= "\n"
        end
    end
    return s
end

# Method toString for built-in 64-bit floating point number types.

function toString(y::AbstractFloat; aligned::Bool=false, digits::Int=0)::String
    if y isa Float16
        precision = 3
        if y > -10.0 && y ≤ -0.01 || y ≥ 0.01 && y < 10.0
            format = 'F'
        else
            format = 'E'
        end
    elseif y isa Float32
        precision = 4
        if y > -10.0 && y ≤ -0.001 || y ≥ 0.001 && y < 10.0
            format = 'F'
        else
            format = 'E'
        end
    elseif y isa Float64
        precision = 6
        if y > -10.0 && y ≤ -0.00001 || y ≥ 0.00001 && y < 10.0
            format = 'F'
        else
            format = 'E'
        end
    elseif y isa BigFloat
        precision = 8
        if y > -10.0 && y ≤ -0.0000001 || y ≥ 0.0000001 && y < 10.0
            format = 'F'
        else
            format = 'E'
        end
    else
        error("Argument y in method toString is of unknown type.")
    end
    if isnan(y)
        s = "NaN"
    elseif isinf(y)
        if y > 0.0
            s = "Inf"
        else
            s = "-Inf"
        end
    elseif y == -0.0 || y == 0.0
        if precision == 8
            s = "0.0000000"
        elseif precision == 7
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
    else
        if format == 'E'
            if precision == 8
                s = @sprintf "%.7E" y;
            elseif precision == 7
                s = @sprintf "%.6E" y;
            elseif precision == 6
                s = @sprintf "%.5E" y;
            elseif precision == 5
                s = @sprintf "%.4E" y;
            elseif precision == 4
                s = @sprintf "%.3E" y;
            else
                s = @sprintf "%.2E" y;
            end
        else  # format = 'F'
            if precision == 8
                s = @sprintf "%.7f" y;
            elseif precision == 7
                s = @sprintf "%.6f" y;
            elseif precision == 6
                s = @sprintf "%.5f" y;
            elseif precision == 5
                s = @sprintf "%.4f" y;
            elseif precision == 4
                s = @sprintf "%.3f" y;
            else
                s = @sprintf "%.2f" y;
            end
        end
    end
    if aligned && (isnan(y) || y ≥ -0.0)
        s = string(' ', s)
    end
    for i in length(s)+1:digits
        s = string(s, ' ')
    end
    return s
end

function toString(v::Vector{<:AbstractFloat})::String
    # Determine the displayed length of the vector.
    v_len = length(v)
    chars = length(toString(v[v_len]))
    len = 1
    for i in 1:v_len-1
        chars += length(toString(v[i])) + 1
        if chars > 69
            break
        end
        len += 1
    end
    # Create the string.
    s = "{"
    s *= toString(v[1])
    if len == v_len
        for i in 2:len
            s *= ' '
            s *= toString(v[i])
        end
    else
        for i in 2:len-2
            s *= ' '
            s *= toString(v[i])
        end
        s *= " ⋯ "
        s *= toString(v[v_len])
    end
    s *= "}ᵀ"
    return s
end

function toString(m::Matrix{<:AbstractFloat})::String
    (m_rows, m_cols) = size(m)
    # Determine the number of rows and columns to print out.
    chars = 0
    for row in 1:m_rows
        for col in 1:m_cols
            chars = max(chars, length(toString(m[row,col];aligned=true)))
        end
    end
    cols = min(m_cols, 70÷(chars+1))
    rows = min(m_rows, 36)
    half_chars = chars ÷ 2
    extra_char = chars % 2
    # Create the string representation for this matrix.
    s = ""
    for i in 1:rows
        if i == 1
            s *= '⌈'
        elseif i < rows
            s *= '|'
        else
            s *= '⌊'
        end
        if m_rows > rows && i == rows-1
            if cols == m_cols
                for j in 1:cols
                    for char in 1:half_chars
                        s *= ' '
                    end
                    s *= '⋮'
                    if extra_char == 1
                        for char in 1:half_chars
                            s *= ' '
                        end
                    else
                        for char in 1:half_chars-1
                            s *= ' '
                        end
                    end
                    if j < cols
                        s *= ' '
                    end
                end
            else # cols < m_cols
                for j in 1:cols-2
                    for char in 1:half_chars
                        s *= ' '
                    end
                    s *= '⋮'
                    if extra_char == 1
                        for char in 1:half_chars
                            s *= ' '
                        end
                    else
                        for char in 1:half_chars-1
                            s *= ' '
                        end
                    end
                    s *= ' '
                end
                s *= " ⋱ "
                for char in 1:half_chars
                    s *= ' '
                end
                s *= '⋮'
                if extra_char == 1
                    for char in 1:half_chars
                        s *= ' '
                    end
                else
                    for char in 1:half_chars-1
                        s *= ' '
                    end
                end
            end
        else
            for j in 1:cols-2
                s *= toString(m[i,j];aligned=true,digits=chars)
                s *= ' '
            end
            if m_cols > cols
                s *= " ⋯ "
            else
                s *= toString(m[i,cols-1];aligned=true,digits=chars)
                s *= ' '
            end
            s *= toString(m[i,m_cols];aligned=true,digits=chars)
        end
        if i == 1
            s *= '⌉'
        elseif i < rows
            s *= '|'
        else
            s *= '⌋'
        end
        if i < rows
            s *= "\n"
        end
    end
    return s
end

# Method toString does not exist for arrays in three dimensions or higher.

