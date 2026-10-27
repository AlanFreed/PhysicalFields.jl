# Persistence

# This file contains methods for writing data to a file, and then reading it
# back in again. A JSON (Java Script Object Notation) file format is adopted,
# supplied by the Julia package JSON.jl. Objects that are handled include 
# the builtin types of String, Dict, Real and Vector{<:Real}, where the 
# primative types of abstract type Real are: Bool, Int8, Int16, Int32, Int64,
# UInt8, UInt16, UInt32, UInt64, Float16, Float32 and Float64. Information 
# for the primative type is stored along with its value so that when read in
# from file the correct type for the value is restored, i.e., the 'lazy'
# feature of JSON is overcome.

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
        json_stream = open(my_file; lock=true, read=true, write=false,
                           create=false, truncate=false, append=false)
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
        json_stream = open(my_file; lock=true, read=false, write=true,
                           create=false, truncate=true, append=true)
    else
        json_stream = open(my_file; lock=true, read=false, write=true,
                           create=true, truncate=true, append=true)
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

#= Serializing to a JSON file.
```julia
    toFile(y::String, json_stream::IOStream)
    toFile(y::Dict, json_stream::IOStream)
    toFile(y::Real, json_stream::IOStream)
    toFile(y::Vector{<:Real}, json_stream::IOStream)
```
where methods `openJSONReader`, `openJSONWriter` and `closeJSONStream` can be called upon to open and close the `IOStream` that is a `json_stream`.

The primative types that implement abstract type `Real` are: `Bool`, `Int8`, `Int16`, `Int32`, `Int64`, `UInt8`, `UInt16`, `UInt32`, `UInt64`, `Float16`, `Float32` and `Float64`.

All primative types of `Real` are handled by method `toFile(y::Real, json_stream::IOStream)`, e.g., `toFile(true, json_stream)` writes boolean `true` to file, while `toFile(1, json_stream)` writes integer `1` to file as an instance of type `Int`; likewise, vectors of these primative types are handled by method `toFile(y::Vector{<:Real}, json_stream::IOStream)`.

Information establishing the primative type of an object being stored to file is written along with its value, so that when read back in from file the restored value will be assigned the actual type of the value that was originally saved to file. The *lazy* feature of `JSON3` is not adhered to.
=#

function toFile(y::String, json_stream::IOStream)
    if isopen(json_stream)
        JSON.json(json_stream, y)
        write(json_stream, '\n')
        flush(json_stream)
    else
        error("The supplied JSON stream is not open.")
    end
    return nothing
end

function toFile(y::Dict, json_stream::IOStream)
    if isopen(json_stream)
        JSON.json(json_stream, y)
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
        JSON.json(json_stream, y)
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
        JSON.json(json_stream, y)
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

#= Deserializing from a JSON file.
```julia
    s = fromFile(::Type{String}, json_stream::IOStream)::String
    d = fromFile(::Type{Dict},   json_stream::IOStream)::Dict
    x = fromFile(::Type{<:Real}, json_stream::IOStream)::Real
    v = fromFile(::Type{Vector}, json_stream::IOStream)::Vector
```
where methods `openJSONReader`, `openJSONWriter` and `closeJSONStream` can be called upon to open and close the `IOStream` that is a `json_stream`.

All primitive types of abstract type `Real` (viz., `Bool`, `Int8`, `Int16`, `Int32`, `Int64`, `Int128`, `UInt8`, `UInt16`, `UInt32`, `UInt64`, `UInt128`, `Float16`, `Float32` and `Float64`) are handled. Singleton values are handled via a call to `fromFile(::Type{<:Real}, json_stream::IOStream)`, e.g., if a boolean was stored to a file, then a boolean will be read back in by either a call to `fromFile(Real, json_stream)` or a call to `fromFile(Bool, json_stream)`. Vector values are handled by a call to `fromFile(Vector, json_stream)` with the type of vector being restored coming from information stored to file.
=#

function fromFile(::Type{String}, json_stream::IOStream)::String
    if isopen(json_stream)
        return JSON.parse(readline(json_stream), String)
    else
        error("The supplied JSON stream is not open.")
    end
end

function fromFile(::Type{Dict}, json_stream::IOStream)::Dict
    if isopen(json_stream)
        y = JSON.parse(readline(json_stream), Dict)
    else
        error("The supplied JSON stream is not open.")
    end
    # y is an immutable dictionary. 
    # copy(y) returns y as a mutable dictionary.
    return copy(y)
end

# numbers

function fromFile(::Type{Bool}, json_stream::IOStream)::Bool
    if isopen(json_stream)
        return JSON.parse(readline(json_stream), Bool)
    else
        error("The supplied JSON stream is not open.")
    end
end

function fromFile(::Type{Int8}, json_stream::IOStream)::Int8
    if isopen(json_stream)
        return JSON.parse(readline(json_stream), Int8)
    else
        error("The supplied JSON stream is not open.")
    end
end

function fromFile(::Type{Int16}, json_stream::IOStream)::Int16
    if isopen(json_stream)
        return JSON.parse(readline(json_stream), Int16)
    else
        error("The supplied JSON stream is not open.")
    end
end

function fromFile(::Type{Int32}, json_stream::IOStream)::Int32
    if isopen(json_stream)
        return JSON.parse(readline(json_stream), Int32)
    else
        error("The supplied JSON stream is not open.")
    end
end

function fromFile(::Type{Int64}, json_stream::IOStream)::Int64
    if isopen(json_stream)
        return JSON.parse(readline(json_stream), Int64)
    else
        error("The supplied JSON stream is not open.")
    end
end

function fromFile(::Type{Int128}, json_stream::IOStream)::Int128
    if isopen(json_stream)
        return JSON.parse(readline(json_stream), Int128)
    else
        error("The supplied JSON stream is not open.")
    end
end

function fromFile(::Type{UInt8}, json_stream::IOStream)::UInt8
    if isopen(json_stream)
        return JSON.parse(readline(json_stream), UInt8)
    else
        error("The supplied JSON stream is not open.")
    end
end

function fromFile(::Type{UInt16}, json_stream::IOStream)::UInt16
    if isopen(json_stream)
        return JSON.parse(readline(json_stream), UInt16)
    else
        error("The supplied JSON stream is not open.")
    end
end

function fromFile(::Type{UInt32}, json_stream::IOStream)::UInt32
    if isopen(json_stream)
        return JSON.parse(readline(json_stream), UInt32)
    else
        error("The supplied JSON stream is not open.")
    end
end

function fromFile(::Type{UInt64}, json_stream::IOStream)::UInt64
    if isopen(json_stream)
        return JSON.parse(readline(json_stream), UInt64)
    else
        error("The supplied JSON stream is not open.")
    end
end

function fromFile(::Type{UInt128}, json_stream::IOStream)::UInt128
    if isopen(json_stream)
        return JSON.parse(readline(json_stream), UInt128)
    else
        error("The supplied JSON stream is not open.")
    end
end

function fromFile(::Type{Float16}, json_stream::IOStream)::Float16
    if isopen(json_stream)
        return JSON.parse(readline(json_stream), Float16)
    else
        error("The supplied JSON stream is not open.")
    end
end

function fromFile(::Type{Float32}, json_stream::IOStream)::Float32
    if isopen(json_stream)
        return JSON.parse(readline(json_stream), Float32)
    else
        error("The supplied JSON stream is not open.")
    end
end

function fromFile(::Type{Float64}, json_stream::IOStream)::Float64
    if isopen(json_stream)
        return JSON.parse(readline(json_stream), Float64)
    else
        error("The supplied JSON stream is not open.")
    end
end

# vectors 

function fromFile(::Type{Vector{Bool}}, json_stream::IOStream)::Vector{Bool}
    if isopen(json_stream)
        return JSON.parse(readline(json_stream), Vector{Bool})
    else
        error("The supplied JSON stream is not open.")
    end
end

function fromFile(::Type{Vector{Int8}}, json_stream::IOStream)::Vector{Int8}
    if isopen(json_stream)
        return JSON.parse(readline(json_stream), Vector{Int8})
    else
        error("The supplied JSON stream is not open.")
    end
end

function fromFile(::Type{Vector{Int16}}, json_stream::IOStream)::Vector{Int16}
    if isopen(json_stream)
        return JSON.parse(readline(json_stream), Vector{Int16})
    else
        error("The supplied JSON stream is not open.")
    end
end

function fromFile(::Type{Vector{Int32}}, json_stream::IOStream)::Vector{Int32}
    if isopen(json_stream)
        return JSON.parse(readline(json_stream), Vector{Int32})
    else
        error("The supplied JSON stream is not open.")
    end
end

function fromFile(::Type{Vector{Int64}}, json_stream::IOStream)::Vector{Int64}
    if isopen(json_stream)
        return JSON.parse(readline(json_stream), Vector{Int64})
    else
        error("The supplied JSON stream is not open.")
    end
end

function fromFile(::Type{Vector{Int128}}, json_stream::IOStream)::Vector{Int128}
    if isopen(json_stream)
        return JSON.parse(readline(json_stream), Vector{Int128})
    else
        error("The supplied JSON stream is not open.")
    end
end

function fromFile(::Type{Vector{UInt8}}, json_stream::IOStream)::Vector{UInt8}
    if isopen(json_stream)
        return JSON.parse(readline(json_stream), Vector{UInt8})
    else
        error("The supplied JSON stream is not open.")
    end
end

function fromFile(::Type{Vector{UInt16}}, json_stream::IOStream)::Vector{UInt16}
    if isopen(json_stream)
        return JSON.parse(readline(json_stream), Vector{UInt16})
    else
        error("The supplied JSON stream is not open.")
    end
end

function fromFile(::Type{Vector{UInt32}}, json_stream::IOStream)::Vector{UInt32}
    if isopen(json_stream)
        return JSON.parse(readline(json_stream), Vector{UInt32})
    else
        error("The supplied JSON stream is not open.")
    end
end

function fromFile(::Type{Vector{UInt64}}, json_stream::IOStream)::Vector{UInt64}
    if isopen(json_stream)
        return JSON.parse(readline(json_stream), Vector{UInt64})
    else
        error("The supplied JSON stream is not open.")
    end
end

function fromFile(::Type{Vector{UInt128}}, json_stream::IOStream)::Vector{UInt128}
    if isopen(json_stream)
        return JSON.parse(readline(json_stream), Vector{UInt128})
    else
        error("The supplied JSON stream is not open.")
    end
end

function fromFile(::Type{Vector{Float16}}, json_stream::IOStream)::Vector{Float16}
    if isopen(json_stream)
        return JSON.parse(readline(json_stream), Vector{Float16})
    else
        error("The supplied JSON stream is not open.")
    end
end

function fromFile(::Type{Vector{Float32}}, json_stream::IOStream)::Vector{Float32}
    if isopen(json_stream)
        return JSON.parse(readline(json_stream), Vector{Float32})
    else
        error("The supplied JSON stream is not open.")
    end
end

function fromFile(::Type{Vector{Float64}}, json_stream::IOStream)::Vector{Float64}
    if isopen(json_stream)
        return JSON.parse(readline(json_stream), Vector{Float64})
    else
        error("The supplied JSON stream is not open.")
    end
end

#=
-------------------------------------------------------------------------------
=#

#= toString

Provides a string representation for built-in types that are subtypes to abstract types `Real`, `Vector{<:Real}` and `Matrix{<:Real}`. These need not be exact representations, because their intention is for displaying results in the REPL, etc., as a means of informing the user during a runtime. Ellipses may appear in vector and matrix representations if their size is otherwise too large to fit onto a line or a printed page, respectively.

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
=#

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
