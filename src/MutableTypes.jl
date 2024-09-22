# MutableTypes

#=
Note: Types MVector, MMatrix and MArray exported here are distinct from those
      with like names exported from module StaticArrays. Like the StaticArrays
      types, those here are of fixed size. Unlike the StaticArrays types, those
      here are dynamically allocated arrays, whereas those with like names
      exported from StaticArrays are statically allocated arrays.
=#

#=
-------------------------------------------------------------------------------
=#

# Exported base types with mutable values.

"""
# MNumber

An abstract type for mutable numbers.
```julia
    abstract type MNumber <: Number end
```
"""
abstract type MNumber <: Number end

# All constructors are internal constructors.

"""
# MBoolean

A mutable boolean type.
```julia
    mutable struct MBoolean
        b::Bool     # Bool <: Integer <: Real <: Number
    end
```
Type `MBoolean` is to be used for a boolean field in an otherwise immutable data `struct` whose value may need to be changed during runtime.

## Constructors

```julia
    function MBoolean()
```
assigns a default value of `false` to an instance of type `MBoolean`.

```julia
    function MBoolean(b::Bool)
```
assigns the boolean value `b` to an instance of type `MBoolean`.

### Type Casting

```julia
    function Bool(mb::MBoolean)::Bool
```

## Overloaded Operators

Enable instances of type `MBoolean` to interact with instances of type `Bool` in a seamless way.

### Unary

```julia
    !
```

### Binary

```julia
    == and ≠
```

## Methods

```julia
    function get(y::MBoolean)::Bool
    function set!(y::MBoolean, x::Bool)
    function copy(y::MBoolean)::MBoolean
    function toFile(y::MBoolean, json_stream::IOStream)
    function fromFile(::Type{MBoolean}, json_stream::IOStream)::MBoolean
    function toString(y::MBoolean)::String
```
"""
mutable struct MBoolean
    b::Bool  # Bool <: Integer <: Real <: Number

    # constructors

    function MBoolean()
        new(false)
    end

    function MBoolean(b::Bool)
        new(b)
    end
end

"""
# MInteger

A mutable integer type.
```julia
    mutable struct MInteger <: MNumber
        n::Int64    # Int64 <: Signed <: Integer <: Real <: Number
    end
```
Type `MInteger` is to be used for an integer field in an otherwise immutable data `struct` whose value may need to be changed during runtime.

## Constructors

```julia
    function MInteger()
```
assigns a default value of 0 to an instance of type `MInteger`.

```julia
    function MInteger(i::Integer)
```
assigns an integer value `i` to an instance of type `MInteger`.

### Type Casting

```julia
    function    Integer(mi::MInteger)::Integer
```

## Overloaded Operators

Enable instances of type `MInteger` to interact with instances of type `Integer` in a seamless way.

### Unary

```julia
    + and -
```
    
### Binary

#### Logic operators

```julia
    ==, ≠, <, ≤, ≥ and >
```
    
#### Arithmetic operators

```julia
    +, -, *, ÷, %, / and ^
```

## Methods

```julia
    function get(y::MInteger)::Integer
    function set!(y::MInteger, x::Integer)
    function copy(y::MInteger)::MInteger
    function toFile(y::MInteger, json_stream::IOStream)
    function fromFile(::Type{MInteger}, json_stream::IOStream)::MInteger
    function toString(y::MInteger)::String
```

## Math Functions

```julia
    abs, sign, sin, cos, tan, sinh, cosh, tanh, asin, acos, atan, asinh, acosh, atanh, log, log2, log10, exp, exp2, exp10 and sqrt
```
"""
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

"""
# MReal

A mutable real type.
```julia
    mutable struct MReal <: MNumber
        n::Float64  # Float64 <: AbstractFloat <: Real <: Number
    end
```
Type `MReal` is to be used for a real field in an otherwise immutable data `struct` whose value may need to be changed during runtime.

## Constructors

```julia
    function MReal()
```
assigns a default value of 0.0 to an instance of type `MReal`.

```julia
    function MReal(r::Real)
```
assigns a real value `r` to an instance of type `MReal`.

### Type Casting

```julia
    function Real(mr::MReal)::Real
```

## Overloaded Operators

Enable instances of type `MReal` to interact with instances of type `Real` in a seamless way.

### Unary

```julia
    + and -
```
    
### Binary

#### Logic operators

```julia
    ==, ≈, ≠, <, ≤, ≥ and >
```
    
#### Arithmetic operators

```julia
    `+`, `-`, `*`, `/` and `^`
```

## Methods

```julia
    function get(y::MReal)::Real
    function set!(y::MReal, x::Real)
    function copy(y::MReal)::MReal
    function toFile(y::MReal, json_stream::IOStream)
    function fromFile(::Type{MReal}, json_stream::IOStream)::MReal
    function toString(y::MReal)::String
```

## Math Functions

```julia
    abs, round, ceil, floor, sign, sin, cos, tan, sinh, cosh, tanh, asin, acos, atan, asinh, acosh, atanh, log, log2, log10, exp, exp2, exp10 and sqrt
```
"""
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

#=
-------------------------------------------------------------------------------
=#

# Exported arrays with mutable values, i.e., mutable array entries.

"""
# MVector

Instances of this type are vectors with a fixed length whose elements are dynamically allocated and assignable.
```julia
    struct MVector
        len::UInt32
        vec::Vector{Float64}
    end
```

## Constructors
    
```julia
    function MVector(length::Integer)
```
creates an instance of type `MVector` with a fixed `length` whose elements are all zeros.

```julia
    function MVector(vector::Vector{<:Real})
```
creates an instance of type `MVector` whose elements are those of `vector`.

```julia
    function MVector(length::Integer, vector::Vector{<:Real})
```
creates an instance of type `MVector` of `length` whose elements are those of `vector`.

### Type Casting

```julia
    function Vector(mv::MVector)::Vector{<:Real}
```

## Overloaded Operators

Enable instances of type `MVector` to interact with instances of types `Vector` and `Real` in a seamless way.

### Unary

```julia
    + and -
```
    
### Binary

#### Logic operators

```julia
    ==, ≈, ≠
```
    
#### Arithmetic operators

```julia
    `+`, `-`, `*`, `/` and `^`
```

## Methods

```julia
    function getindex(y::MVector, index::Integer)::Real
    function setindex!(y::MVector, value::Real, index::Integer)
    function copy(y::MVector)::MVector
    function length(y::MVector)::Integer
    function size(y::MVector)::Tuple
    function toFile(y::MVector, json_stream::IOStream)
    function fromFile(::Type{MVector}, json_stream::IOStream)::MVector
    function toString(v::MVector)::String
```

## Math Functions

```julia
    function norm(y::MVector, p::Real=2)::Real
    function unitVector(y::Vector{<:Real})::Vector{<:Real}
    function unitVector(y::MVector)::MVector
    function cross(y::MVector, z::MVector)::MVector
    function cross(y::Vector{<:Real}, z::MVector)::MVector
    function cross(y::MVector, z::Vector{<:Real})::MVector
```
"""
struct MVector
    len::UInt32             # A vector's length, which is fixed.
    vec::Vector{Float64}    # A column vector with mutable elements.

    # constructors

    function MVector(length::Integer)
        len = convert(UInt32, length)
        vec = zeros(Float64, len)
        new(len, vec)
    end

    function MVector(vector::Vector{<:Real})
        len = convert(UInt32, length(vector))
        if eltype(vector) == Float64
            vec = vector
        else
            vec = Vector{Float64}(undef, len)
            for i in 1:len
                vec[i] = convert(Float64, vector[i])
            end
        end
        new(len, vec)
    end

    function MVector(length::Integer, vector::Vector{<:Real})
        if length ≠ Base.length(vector)
            msg = "Assigned length doesn't equal the vector's length."
            throw(DimensionMismatch(msg))
        end
        if length isa UInt32
            len = length
        else
            len = convert(UInt32, length)
        end
        if eltype(vector) == Float64
            vec = vector
        else
            vec = Vector{Float64}(undef, len)
            for i in 1:len
                vec[i] = convert(Float64, vector[i])
            end
        end
        new(len, vec)
    end
end # MVector

"""
# MMatrix

Instances of this type are matrices with fixed dimensions, viz., fixed number of rows and columns, whose elements are dynamically allocated and assignable.
```julia
    struct MMatrix
        rows::UInt16
        cols::UInt16
        vec::Vector{Float64}
    end
```
where the matrix is stored as a reshaped column vector. Indexer [i,j] will point to the appropriate vector element `vec`[k] behind the scene.

## Constructors

```julia
    function MMatrix(rows::Integer, columns::Integer)
```
creates an instance of type `MMatrix` with fixed numbers of `rows` and `columns` whose elements are all zeros.

```julia
    function MMatrix(matrix::Matrix{<:Real})
```
creates an instance of type `MMatrix` whose elements are those of `matrix`.

```julia
    function MMatrix(rows::Integer, columns::Integer, vector::Vector{<:Real})
```
creates an instance of type `MMatrix` of dimension `rows`⨉`columns` whose elements have been reshaped into a column `vector`.

```julia
    function MMatrix(rows::Integer, columns::Integer, matrix::Matrix{<:Real})
```
creates an instance of type `MMatrix` of dimension `rows`⨉`columns` whose elements are those of `matrix`.

### Type Casting

```julia
    function Matrix(mm::MMatrix)::Matrix{<:Real
```

## Overloaded Operators

Enable instances of type `MMatrix` to interact with instances of types `Matrix`, `Vector` and `Real` in a seamless way.

### Unary

```julia
    + and -
```
    
### Binary

#### Logic operators

```julia
    ==, ≈, ≠
```
    
#### Arithmetic operators

```julia
    `+`, `-`, `*`, `/`, `\` and `^`
```

## Methods

```julia
    function getindex(y::MMatrix, row::Integer)::Vector{<:Real}
    function getindex(y::MMatrix, row::Integer, column::Integer)::Real
    function setindex!(y::MMatrix, value::Vector{<:Real}, row::Integer)
    function setindex!(y::MMatrix, value::Real, row::Integer, column::Integer)
    function copy(y::MMatrix)::MMatrix
    function size(y::MMatrix)::Tuple
    function toFile(y::MMatrix, json_stream::IOStream)
    function fromFile(::Type{MMatrix}, json_stream::IOStream)::MMatrix
    function toString(m::MMatrix)::String
```

## Math Functions

```julia
    function norm(y::MMatrix, p::Real=2)::Real
    function transpose(y::MMatrix)::MMatrix
    function tr(y::MMatrix)::Real
    function det(y::MMatrix)::Real
    function inv(y::MMatrix)::MMatrix
    function qr(y::Matrix{<:Real})::Tuple   # (Q, R) as instances of Matrix
    function qr(y::MMatrix)::Tuple          # (Q, R) as instances of MMatrix
    function lq(y::Matrix{<:Real})::Tuple   # (L, Q) as instances of Matrix
    function lq(y::MMatrix)::Tuple          # (L, Q) as instances of MMatrix
    function matrixProduct(y::Vector{<:Real}, z::Vector{<:Real})::Matrix{<:Real}
    function matrixProduct(y::MVector, z::MVector)::MMatrix
    function matrixProduct(y::Vector{<:Real}, z::MVector)::MMatrix
    function matrixProduct(y::MVector, z::Vector{<:Real})::MMatrix
```
"""
struct MMatrix
    rows::UInt16            # Rows in a matrix, which is fixed.
    cols::UInt16            # Columns in a matrix, which is fixed.
    vec::Vector{Float64}    # A matrix reshaped as a column vector with mutable elements.

    # constructors

    function MMatrix(rows::Integer, columns::Integer)
        if rows isa UInt16
            row = rows
        else
            row = convert(UInt16, rows)
        end
        if columns isa UInt16
            col = columns
        else
            col = convert(UInt16, columns)
        end
        len = convert(UInt32, rows*columns)
        vec = zeros(Float64, len)
        new(row, col, vec)
    end

    function MMatrix(matrix::Matrix{<:Real})
        (rows, columns) = size(matrix)
        row = convert(UInt16, rows)
        col = convert(UInt16, columns)
        vector = Base.vec(matrix)
        if eltype(vector) == Float64
            vec = vector
        else
            len = convert(UInt32, rows*columns)
            vec = Vector{Float64}(undef, len)
            for i in 1:len
                vec[i] = convert(Float64, vector[i])
            end
        end
        new(row, col, vec)
    end

    function MMatrix(rows::Integer, columns::Integer, vector::Vector{<:Real})
        if rows*columns ≠ Base.length(vector)
            msg = "Assigned dimensions don't equate with the vector's length."
            throw(DimensionMismatch(msg))
        end
        if rows isa UInt16
            row = rows
        else
            row = convert(UInt16, rows)
        end
        if columns isa UInt16
            col = columns
        else
            col = convert(UInt16, columns)
        end
        if eltype(vector) == Float64
            vec = vector
        else
            len = convert(UInt32, rows*columns)
            vec = Vector{Float64}(undef, len)
            for i in 1:len
                vec[i] = convert(Float64, vector[i])
            end
        end
        new(row, col, vec)
    end

    function MMatrix(rows::Integer, columns::Integer, matrix::Matrix{<:Real})
        (m_rows, m_cols) = size(matrix)
        if rows ≠ m_rows || cols ≠ m_cols
            msg = "Assigned dimensions don't match the matrix's dimensions."
            throw(DimensionMismatch(msg))
        end
        if rows isa UInt16
            row = rows
        else
            row = convert(UInt16, rows)
        end
        if columns isa UInt16
            col = columns
        else
            col = convert(UInt16, columns)
        end
        vector = Base.vec(matrix)
        if eltype(vector) == Float64
            vec = vector
        else
            len = convert(UInt32, rows*columns)
            vec = Vector{Float64}(undef, len)
            for i in 1:len
                vec[i] = convert(Float64, vector[i])
            end
        end
        new(row, col, vec)
    end
end # MMatrix

"""
# MArray

Instances of this type are three dimensional arrays whose dimensions are fixed, but whose elements are dynamically allocated and assignable. `MArray`s are intended for use as containers of data, and as such, do not have many of the features that types `MVector` and `MMatrix` possess.
```julia
    struct MArray
        pp::UInt16
        rows::UInt16
        cols::UInt16
        vec::Vector{Float64}
    end
```
where `pp` denotes the number of pages in the array, each of which contains a `rows`×`cols` matrix.

## Constructors

```julia
    function MArray(pages::Integer, rows::Integer, columns::Integer)
```
creates an instance of type `MArray` with fixed numbers of `pages`, `rows` and `columns` whose elements are all zeros.

```julia
    function MArray(array::Array{<:Real,3})
```
creates an instance of type `MArray` whose elements are those of the three dimensional `array`.

```julia
    function MArray(pages::Integer, rows::Integer, columns::Integer, vector::Vector{<:Real})
```
creates an instance of type `MArray` of dimension `pages`⨉`rows`⨉`columns` whose elements have been reshaped into a column `vector`.

## Methods

```julia
    function getindex(y::MArray, page::Integer)::Matrix{<:Real}
    function getindex(y::MArray, page::Integer, row::Integer, column::Integer)::Real
    function setindex!(y::MArray, value::Matrix{<:Real}, page::Integer)
    function setindex!(y::MArray, value::Real, page::Integer, row::Integer, column::Integer)
    function copy(y::MArray)::MArray
    function size(y::MArray)::Tuple
    function toFile(y::MArray, json_stream::IOStream)
    function fromFile(::Type{MArray}, json_stream::IOStream)::MArray
```
"""
struct MArray
    pp::UInt16              # Pages in an array, which is fixed.
                            #    Each page contains a rows×cols matrix.
    rows::UInt16            # Matrix rows in each page, which is fixed.
    cols::UInt16            # Matrix columns in each page, which is fixed.
    vec::Vector{Float64}    # Array reshaped as a vector with mutable elements.

    # constructors

    function MArray(pages::Integer, rows::Integer, columns::Integer)
        if pages isa UInt16
            pag = pages
        else
            pag = convert(UInt16, pages)
        end
        if rows isa UInt16
            row = rows
        else
            row = convert(UInt16, rows)
        end
        if columns isa UInt16
            col = columns
        else
            col = convert(UInt16, columns)
        end
        len = convert(UInt32, pages*rows*columns)
        vec = zeros(Float64, len)
        new(pag, row, col, vec)
    end

    function MArray(array::Array{<:Real,3})
        (pages, rows, columns) = size(array)
        pag = convert(UInt16, pages)
        row = convert(UInt16, rows)
        col = convert(UInt16, columns)
        vector = Base.vec(array)
        if eltype(vector) == Float64
            vec = vector
        else
            len = convert(UInt32, pages*rows*columns)
            vec = Vector{Float64}(undef, len)
            for i in 1:len
                vec[i] = convert(Float64, vector[i])
            end
        end
        new(pag, row, col, vec)
    end

    function MArray(pages::Integer, rows::Integer, columns::Integer, vector::Vector{<:Real})
        if pages*rows*columns ≠ Base.length(vector)
            msg = "Assigned dimensions don't equate with the vector's length."
            throw(DimensionMismatch(msg))
        end
        if pages isa UInt16
            pag = pages
        else
            pag = convert(UInt16, pages)
        end
        if rows isa UInt16
            row = rows
        else
            row = convert(UInt16, rows)
        end
        if columns isa UInt16
            col = columns
        else
            col = convert(UInt16, columns)
        end
        if eltype(vector) == Float64
            vec = vector
        else
            len = convert(UInt32, pages*rows*columns)
            vec = Vector{Float64}(undef, len)
            for i in 1:len
                vec[i] = convert(Float64, vector[i])
            end
        end
        new(pag, row, col, vec)
    end
end # MArray

#=
-------------------------------------------------------------------------------
=#

# Type-casting methods that return the raw type of a mutable field.

function Base.:(Bool)(mb::MBoolean)::Bool
    return copy(mb.b)
end

function Base.:(Integer)(mi::MInteger)::Integer
    return copy(mi.n)
end

function Base.:(Real)(mr::MReal)::Real
    return copy(mr.n)
end

function Base.:(Vector)(mv::MVector)::Vector{<:Real}
    return copy(mv.vec)
end

function Base.:(Matrix)(mm::MMatrix)::Matrix{<:Real}
    vec = copy(mm.vec)
    mtx = reshape(vec, (mm.rows, mm.cols))
    return mtx
end

function Base.:(Array)(ma::MArray)::Array{<:Real,3}
    vec = copy(ma.vec)
    arr = reshape(vec, (ma.pgs, ma.rows, ma.cols))
    return arr
end

#=
-------------------------------------------------------------------------------
=#

# copy, length and size methods

function Base.:(copy)(y::MBoolean)::MBoolean
    return MBoolean(copy(y.b))
end # copy

function Base.:(copy)(y::MInteger)::MInteger
    return MInteger(copy(y.n))
end # copy

function Base.:(copy)(y::MReal)::MReal
    return MReal(copy(y.n))
end # copy

function Base.:(copy)(y::MVector)::MVector
    return MVector(copy(y.len), copy(y.vec))
end # copy

function Base.:(copy)(y::MMatrix)::MMatrix
    return MMatrix(copy(y.rows), copy(y.cols), copy(y.vec))
end # copy

function Base.:(copy)(y::MArray)::MArray
    return MArray(copy(y.pp), copy(y.rows), copy(y.cols), copy(y.vec))
end # copy

function Base.:(length)(y::MVector)::Integer
    return Int(y.len)
end # length

function Base.:(size)(y::MVector)::Tuple
    return (Int(y.len),)
end # size

function Base.:(size)(y::MMatrix)::Tuple
    return (Int(y.rows), Int(y.cols))
end # size

function Base.:(size)(y::MArray)::Tuple
    return (Int(y.pp), Int(y.rows), Int(y.cols))
end # size

#=
-------------------------------------------------------------------------------
=#

# persistence

# Type declarations needed to work with JSON3 files.

StructTypes.StructType(::Type{MBoolean}) = StructTypes.Mutable()
StructTypes.StructType(::Type{MInteger}) = StructTypes.Mutable()
StructTypes.StructType(::Type{MReal})    = StructTypes.Mutable()

StructTypes.StructType(::Type{MVector})  = StructTypes.Struct()
StructTypes.StructType(::Type{MMatrix})  = StructTypes.Struct()
StructTypes.StructType(::Type{MArray})   = StructTypes.Struct()

# Write to a JSON file.

function toFile(y::MBoolean, json_stream::IOStream)
    if isopen(json_stream)
        JSON3.write(json_stream, y)
        write(json_stream, '\n')
    else
        error("The supplied JSON stream is not open.")
    end
    flush(json_stream)
    return nothing
end

function toFile(y::MInteger, json_stream::IOStream)
    if isopen(json_stream)
        JSON3.write(json_stream, y)
        write(json_stream, '\n')
    else
        error("The supplied JSON stream is not open.")
    end
    flush(json_stream)
    return nothing
end

function toFile(y::MReal, json_stream::IOStream)
    if isopen(json_stream)
        JSON3.write(json_stream, y)
        write(json_stream, '\n')
    else
        error("The supplied JSON stream is not open.")
    end
    flush(json_stream)
    return nothing
end

# Write the various mutable arrays to a JSON file.

function toFile(y::MVector, json_stream::IOStream)
    if isopen(json_stream)
        JSON3.write(json_stream, y)
        write(json_stream, '\n')
    else
        error("The supplied JSON stream is not open.")
    end
    flush(json_stream)
    return nothing
end

function toFile(y::MMatrix, json_stream::IOStream)
    if isopen(json_stream)
        JSON3.write(json_stream, y)
        write(json_stream, '\n')
    else
        error("The supplied JSON stream is not open.")
    end
    flush(json_stream)
    return nothing
end

function toFile(y::MArray, json_stream::IOStream)
    if isopen(json_stream)
        JSON3.write(json_stream, y)
        write(json_stream, '\n')
    else
        error("The supplied JSON stream is not open.")
    end
    flush(json_stream)
    return nothing
end

# Read from a JSON file.

function fromFile(::Type{MBoolean}, json_stream::IOStream)::MBoolean
    if isopen(json_stream)
        y = JSON3.read(readline(json_stream), MBoolean)
    else
        error("The supplied JSON stream is not open.")
    end
    return y
end

function fromFile(::Type{MInteger}, json_stream::IOStream)::MInteger
    if isopen(json_stream)
        y = JSON3.read(readline(json_stream), MInteger)
    else
        error("The supplied JSON stream is not open.")
    end
    return y
end

function fromFile(::Type{MReal}, json_stream::IOStream)::MReal
    if isopen(json_stream)
        y = JSON3.read(readline(json_stream), MReal)
    else
        error("The supplied JSON stream is not open.")
    end
    return y
end

function fromFile(::Type{MVector}, json_stream::IOStream)::MVector
    if isopen(json_stream)
        y = JSON3.read(readline(json_stream), MVector)
    else
        error("The supplied JSON stream is not open.")
    end
    return y
end

function fromFile(::Type{MMatrix}, json_stream::IOStream)::MMatrix
    if isopen(json_stream)
        y = JSON3.read(readline(json_stream), MMatrix)
    else
        error("The supplied JSON stream is not open.")
    end
    return y
end

function fromFile(::Type{MArray}, json_stream::IOStream)::MArray
    if isopen(json_stream)
        y = JSON3.read(readline(json_stream), MArray)
    else
        error("The supplied JSON stream is not open.")
    end
    return y
end

#=
-------------------------------------------------------------------------------
=#

# Method toString for the mutable number types.

function toString(y::MBoolean)::String
    return toString(y.b)
end

function toString(y::MInteger)::String
    return toString(y.n)
end

function toString(y::MReal)::String
    return toString(y.n)
end

# Method toString for mutable array types.

function toString(v::MVector)::String
    return toString(v.vec)
end

function toString(m::MMatrix)::String
    vec = copy(m.vec)
    mtx = reshape(vec, (m.rows, m.cols))
    return toString(mtx)
end

# MArrays are used as containers, and as such, no toString method is provided.

#=
-------------------------------------------------------------------------------
=#

# Methods get and getindex.

function Base.:(get)(y::MBoolean)::Bool
    return copy(y.b)
end

function Base.:(get)(y::MInteger)::Integer
    return copy(y.n)
end

function Base.:(get)(y::MReal)::Real
    return copy(y.n)
end

function Base.:(getindex)(y::MVector, index::Integer)::Real
    if index < 1 || index > y.len
        msg = string("Admissible vector indices are ∈ [1…", toString(y.len), "].")
        throw(DimensionMismatch(msg))
    end
    return copy(y.vec[index])
end

function Base.:(getindex)(y::MMatrix, row::Integer)::Vector{<:Real}
    if row < 1 || row > y.rows
        msg = string("Admissible row indices are ∈ [1…", toString(y.rows), "].")
        throw(DimensionMismatch(msg))
    end
    vec = Vector{Float64}(undef, y.cols)
    for i in 1:y.cols
        index = row + (i - 1)*y.rows
        vec[i] = copy(y.vec[index])
    end
    return vec
end

function Base.:(getindex)(y::MMatrix, row::Integer, column::Integer)::Real
    if row < 1 || row > y.rows || column < 1 || column > y.cols
        msg = string("Admissible matrix indices are ∈ [1…", toString(y.rows), ", 1…", toString(y.cols), "].")
        throw(DimensionMismatch(msg))
    end
    index = row + (column - 1)*y.rows
    return copy(y.vec[index])
end

function Base.:(getindex)(y::MArray, page::Integer)::Matrix{<:Real}
    if page < 1 || page > y.pp
        msg = string("Admissible page indices are ∈ [1…", toString(y.pp), "].")
        throw(DimensionMismatch(msg))
    end
    mtx = Matrix{Float64}(undef, y.rows, y.cols)
    for i in 1:y.rows
        for j in 1:y.cols
            index = page + (i - 1)*y.pp + (j - 1)*y.pp*y.rows
            mtx[i,j] = copy(y.vec[index])
        end
    end
    return mtx
end

function Base.:(getindex)(y::MArray, page::Integer, row::Integer, column::Integer)::Real
    if (page < 1 || page > y.pp || row < 1 || row > y.rows ||
        column < 1 || column > y.cols)
        msg = string("Admissible 3D array indices are ∈ [1…", toString(y.pp), ", 1…", toString(y.rows), ", 1…", toString(y.cols), "].")
        throw(DimensionMismatch(msg))
    end
    index = page + (row - 1)*y.pp + (column - 1)*y.pp*y.rows
    return copy(y.vec[index])
end

#=
-------------------------------------------------------------------------------
=#

# Methods set! and setindex!.

function set!(y::MBoolean, value::Bool)
    y.b = copy(value)
    return nothing
end

function set!(y::MInteger, value::Integer)
    if value isa Int64
        y.n = copy(value)
    else
        y.n = convert(Int64, value)
    end
    return nothing
end

function set!(y::MReal, value::Real)
    if value isa Float64
        y.n = copy(value)
    else
        y.n = convert(Float64, value)
    end
    return nothing
end

function Base.:(setindex!)(y::MVector, value::Real, index::Integer)
    if index < 1 || index > y.len
        msg = string("Admissible vector indices are ∈ [1…", string(y.len), "].")
        throw(DimensionMismatch(msg))
    end
    if value isa Float64
        y.vec[index] = copy(value)
    else
        y.vec[index] = convert(Float64, value)
    end
    return nothing
end

function Base.:(setindex!)(y::MMatrix, value::Vector{<:Real}, row::Integer)
    if length(value) ≠ y.cols
        msg = "Dimensions for vector insertion into a matrix don't match."
        throw(DimensionMismatch(msg))
    end
    if row < 1 || row > y.rows
        msg = string("Admissible column indices are ∈ [1…", toString(y.rows), "].")
        throw(DimensionMismatch(msg))
    end
    for i in 1:y.cols
        index = row + (i - 1)*y.rows
        if eltype(value) == Float64
            y.vec[index] = copy(value[i])
        else
            y.vec[index] = convert(Float64, value[i])
        end
    end
    return nothing
end

function Base.:(setindex!)(y::MMatrix, value::Real, row::Integer, column::Integer)
    if row < 1 || row > y.rows || column < 1 || column > y.cols
        msg = string("Admissible matrix indices are ∈ [1…", toString(y.rows), ", 1…", toString(y.cols), "].")
        throw(DimensionMismatch(msg))
    end
    index = row + (column - 1)*y.rows
    if value isa Float64
        y.vec[index] = copy(value)
    else
        y.vec[index] = convert(Float64, value)
    end
    return nothing
end

function Base.:(setindex!)(y::MArray, value::Matrix{<:Real}, page::Integer)
    if page < 1 || page > y.pp
        msg = string("Admissible page indices are ∈ [1…", toString(y.pp), "].")
        throw(DimensionMismatch(msg))
    end
    (rows, cols) = size(value)
    if rows ≠ y.rows || cols ≠ y.cols
        msg = "Dimensions for matrix insertion into an array don't match."
        throw(DimensionMismatch(msg))
    end
    if i in 1:y.rows
        for j in 1:y.cols
            index = page + (i - 1)*y.pp + (j - 1)*y.pp*y.rows
            if eltype(value) == Float64
                y.vec[index] = copy(value[i,j])
            else
                y.vec[index] = convert(Float64, value[i,j])
            end
        end
    end
    return nothing
end

function Base.:(setindex!)(y::MArray, value::Real, page::Integer, row::Integer, column::Integer)
    if (page < 1 || page > y.pp || row < 1 || row > y.rows ||
        column < 1 || column > y.cols)
        msg = string("Admissible 3D array indices are ∈ [1…", toString(y.pp), ", 1…", toString(y.rows), ", 1…", toString(y.cols), "].")
        throw(DimensionMismatch(msg))
    end
    index = page + (row - 1)*y.pp + (column - 1)*y.pp*y.rows
    if value isa Float64
        y.vec[index] = copy(value)
    else
        y.vec[index] = convert(Float64, value)
    end
    return nothing
end

#=
-------------------------------------------------------------------------------
=#

# Overloaded the operators
#   ==, ≠, ≈, !

# Operator ==

function Base.:(==)(y::MBoolean, z::MBoolean)::Bool
    return isequal(y.b, z.b)
end

function Base.:(==)(y::MBoolean, z::Bool)::Bool
    return isequal(y.b, z)
end

function Base.:(==)(y::Bool, z::MBoolean)::Bool
    return isequal(y, z.b)
end

function Base.:(==)(y::MInteger, z::MInteger)::Bool
    return isequal(y.n, z.n)
end

function Base.:(==)(y::MInteger, z::Integer)::Bool
    return isequal(y.n, z)
end

function Base.:(==)(y::Integer, z::MInteger)::Bool
    return isequal(y, z.n)
end

function Base.:(==)(y::MReal, z::MReal)::Bool
    return isequal(y.n, z.n)
end

function Base.:(==)(y::MReal, z::MInteger)::Bool
    return isequal(y.n, z.n)
end

function Base.:(==)(y::MInteger, z::MReal)::Bool
    return isequal(y.n, z.n)
end

function Base.:(==)(y::MReal, z::Real)::Bool
    return isequal(y.n, z)
end

function Base.:(==)(y::Real, z::MReal)::Bool
    return isequal(y, z.n)
end

function Base.:(==)(y::MVector, z::MVector)::Bool
    if !isequal(y.len, z.len)
        return false
    end
    for i in 1:y.len
        if !isequal(y[i], z[i])
            return false
        end
    end
    return true
end

function Base.:(==)(y::MVector, z::Vector{<:Real})::Bool
    if !isequal(y.len, length(z))
        return false
    end
    for i in 1:y.len
        if !isequal(y[i], z[i])
            return false
        end
    end
    return true
end

function Base.:(==)(y::Vector{<:Real}, z::MVector)::Bool
    if !isequal(length(y), z.len)
        return false
    end
    for i in 1:z.len
        if !isequal(y[i], z[i])
            return false
        end
    end
    return true
end

function Base.:(==)(y::MMatrix, z::MMatrix)::Bool
    if !isequal(y.rows, z.rows) || !isequal(y.cols, z.cols)
        return false
    end
    for i in 1:y.rows*y.cols
        if !isequal(y.vec[i], z.vec[i])
            return false
        end
    end
    return true
end

function Base.:(==)(y::MMatrix, z::Matrix{<:Real})::Bool
    (z_rows, z_cols) = size(z)
    if !isequal(y.rows, z_rows) || !isequal(y.cols, z_cols)
        return false
    end
    for i in 1:y.rows
        for j in 1:y.cols
            if !isequal(y[i,j], z[i,j])
                return false
            end
        end
    end
    return true
end

function Base.:(==)(y::Matrix{<:Real}, z::MMatrix)::Bool
    (y_rows, y_cols) = size(y)
    if !isequal(y_rows, z.rows) || !isequal(y_cols, z.cols)
        return false
    end
    for i in 1:y_rows
        for j in 1:y_cols
            if !isequal(y[i,j], z[i,j])
                return false
            end
        end
    end
    return true
end

function Base.:(==)(y::MArray, z::MArray)::Bool
    if !isequal(y.pp, z.pp) || !isequal(y.rows, z.rows) || !isequal(y.cols, z.cols)
        return false
    end
    for i in 1:y.pp*y.rows*y.cols
        if !isequal(y.vec[i], z.vec[i])
            return false
        end
    end
    return true
end

function Base.:(==)(y::MArray, z::Array{<:Real,3})::Bool
    (z_pp, z_rows, z_cols) = size(z)
    if !isequal(y.pp, z_pp) || !isequal(y.rows, z_rows) || !isequal(y.cols, z_cols)
        return false
    end
    for i in 1:y.pp
        for j in 1:y.rows
            for k in 1:y.cols
                if !isequal(y[i,j,k], z[i,j,k])
                    return false
                end
            end
        end
    end
    return true
end

function Base.:(==)(y::Array{<:Real,3}, z::MArray)::Bool
    (y_pp, y_rows, y_cols) = size(y)
    if !isequal(y_pp, z.pp) || !isequal(y_rows, z.rows) || !isequal(y_cols, z.cols)
        return false
    end
    for i in 1:y_pp
        for j in 1:y_rows
            for k in 1:y_cols
                if !isequal(y[i,j,k], z[i,j,k])
                    return false
                end
            end
        end
    end
    return true
end

# Operator ≠

function Base.:≠(y::MBoolean, z::MBoolean)::Bool
    return !(y == z)
end

function Base.:≠(y::MBoolean, z::Bool)::Bool
    return !(y == z)
end

function Base.:≠(y::Bool, z::MBoolean)::Bool
    return !(y == z)
end

function Base.:≠(y::MInteger, z::MInteger)::Bool
    return !(y == z)
end

function Base.:≠(y::MInteger, z::Integer)::Bool
    return !(y == z)
end

function Base.:≠(y::Integer, z::MInteger)::Bool
    return !(y == z)
end

function Base.:≠(y::MReal, z::MReal)::Bool
    return !(y == z)
end

function Base.:≠(y::MReal, z::MInteger)::Bool
    return !(y == z)
end

function Base.:≠(y::MInteger, z::MReal)::Bool
    return !(y == z)
end

function Base.:≠(y::MReal, z::Real)::Bool
    return !(y == z)
end

function Base.:≠(y::Real, z::MReal)::Bool
    return !(y == z)
end

function Base.:≠(y::MVector, z::MVector)::Bool
    return !(y == z)
end

function Base.:≠(y::MVector, z::Vector{<:Real})::Bool
    return !(y == z)
end

function Base.:≠(y::Vector{<:Real}, z::MVector)::Bool
    return !(y == z)
end

function Base.:≠(y::MMatrix, z::MMatrix)::Bool
    return !(y == z)
end

function Base.:≠(y::MMatrix, z::Matrix{<:Real})::Bool
    return !(y == z)
end

function Base.:≠(y::Matrix{<:Real}, z::MMatrix)::Bool
    return !(y == z)
end

function Base.:≠(y::MArray, z::MArray)::Bool
    return !(y == z)
end

function Base.:≠(y::MArray, z::Array{<:Real,3})::Bool
    return !(y == z)
end

function Base.:≠(y::Array{<:Real,3}, z::MArray)::Bool
    return !(y == z)
end

# Operator ≈

function Base.:≈(y::MReal, z::MReal)::Bool
    return (y.n ≈ z.n)
end

function Base.:≈(y::MReal, z::MInteger)::Bool
    return (y.n ≈ z.n)
end

function Base.:≈(y::MInteger, z::MReal)::Bool
    return (y.n ≈ z.n)
end

function Base.:≈(y::MReal, z::Real)::Bool
    return (y.n ≈ z)
end

function Base.:≈(y::Real, z::MReal)::Bool
    return (y ≈ z.n)
end

function Base.:≈(y::MVector, z::MVector)::Bool
    if !isequal(y.len, z.len)
        return false
    end
    for i in 1:y.len
        if !(y[i] ≈ z[i])
            return false
        end
    end
    return true
end

function Base.:≈(y::MVector, z::Vector{<:Real})::Bool
    if !isequal(y.len, length(z))
        return false
    end
    for i in 1:y.len
        if !(y[i] ≈ z[i])
            return false
        end
    end
    return true
end

function Base.:≈(y::Vector{<:Real}, z::MVector)::Bool
    if !isequal(length(y), z.len)
        return false
    end
    for i in 1:z.len
        if !(y[i] ≈ z[i])
            return false
        end
    end
    return true
end

function Base.:≈(y::MMatrix, z::MMatrix)::Bool
    if !isequal(y.rows, z.rows) || !isequal(y.cols, z.cols)
        return false
    end
    for i in 1:y.rows*y.cols
        if !(y.vec[i] ≈ z.vec[i])
            return false
        end
    end
    return true
end

function Base.:≈(y::MMatrix, z::Matrix{<:Real})::Bool
    (z_rows, z_cols) = size(z)
    if !isequal(y.rows, z_rows) || !isequal(y.cols, z_cols)
        return false
    end
    for i in 1:y.rows
        for j in 1:y.cols
            if !(y[i,j] ≈ z[i,j])
                return false
            end
        end
    end
    return true
end

function Base.:≈(y::Matrix{<:Real}, z::MMatrix)::Bool
    (y_rows, y_cols) = size(y)
    if !isequal(y_rows, z.rows) || !isequal(y_cols, z.cols)
        return false
    end
    for i in 1:y_rows
        for j in 1:y_cols
            if !(y[i,j] ≈ z[i,j])
                return false
            end
        end
    end
    return true
end

function Base.:≈(y::MArray, z::MArray)::Bool
    if !isequal(y.pp, z.pp) || !isequal(y.rows, z.rows) || !isequal(y.cols, z.cols)
        return false
    end
    for i in 1:y.pp
        for j in 1:y.rows
            for k in 1:y.cols
                if !(y[i,j,k] ≈ z[i,j,k])
                    return false
                end
            end
        end
    end
    return true
end

function Base.:≈(y::MArray, z::Array{<:Real,3})::Bool
    (z_pp, z_rows, z_cols) = size(z)
    if !isequal(y.pp, z_pp) || !isequal(y.rows, z_rows) || !isequal(y.cols, z_cols)
        return false
    end
    for i in 1:y.pp
        for j in 1:y.rows
            for k in 1:y.cols
                if !(y[i,j,k] ≈ z[i,j,k])
                    return false
                end
            end
        end
    end
    return true
end

function Base.:≈(y::Array{<:Real,3}, z::MArray)::Bool
    (y_pp, y_rows, y_cols) = size(y)
    if !isequal(y_pp, z.pp) || !isequal(y_rows, z.rows) || !isequal(y_cols, z.cols)
        return false
    end
    for i in 1:y_pp
        for j in 1:y_rows
            for k in 1:y_cols
                if !(y[i,j,k] ≈ z[i,j,k])
                    return false
                end
            end
        end
    end
    return true
end

# Operator !

function Base.:!(y::MBoolean)::Bool
    return !y.b
end

#=
-------------------------------------------------------------------------------
=#

# Overloaded operators belonging to instances of types IType and MType are:
#   <, ≤, ≥, >

# Operator <

function Base.:<(y::MInteger, z::MInteger)::Bool
    return isless(y.n, z.n)
end

function Base.:<(y::MInteger, z::Integer)::Bool
    return isless(y.n, z)
end

function Base.:<(y::Integer, z::MInteger)::Bool
    return isless(y, z.n)
end

function Base.:<(y::MReal, z::MReal)::Bool
    return isless(y.n, z.n)
end

function Base.:<(y::MReal, z::MInteger)::Bool
    return isless(y.n, z.n)
end

function Base.:<(y::MInteger, z::MReal)::Bool
    return isless(y.n, z.n)
end

function Base.:<(y::MReal, z::Real)::Bool
    return isless(y.n, z)
end

function Base.:<(y::Real, z::MReal)::Bool
    return isless(y, z.n)
end

# Operator >

function Base.:>(y::MInteger, z::MInteger)::Bool
    if isless(y.n, z.n) || isequal(y.n, z.n)
        return false
    else
        return true
    end
end

function Base.:>(y::MInteger, z::Integer)::Bool
    if isless(y.n, z) || isequal(y.n, z)
        return false
    else
        return true
    end
end

function Base.:>(y::Integer, z::MInteger)::Bool
    if isless(y, z.n) || isequal(y, z.n)
        return false
    else
        return true
    end
end

function Base.:>(y::MReal, z::MReal)::Bool
    if isless(y.n, z.n) || isequal(y.n, z.n)
        return false
    else
        return true
    end
end

function Base.:>(y::MReal, z::MInteger)::Bool
    if isless(y.n, z.n) || isequal(y.n, z.n)
        return false
    else
        return true
    end
end

function Base.:>(y::MInteger, z::MReal)::Bool
    if isless(y.n, z.n) || isequal(y.n, z.n)
        return false
    else
        return true
    end
end

function Base.:>(y::MReal, z::Real)::Bool
    if isless(y.n, z) || isequal(y.n, z)
        return false
    else
        return true
    end
end

function Base.:>(y::Real, z::MReal)::Bool
    if isless(y, z.n) || isequal(y, z.n)
        return false
    else
        return true
    end
end

# Operator ≤

function Base.:≤(y::MInteger, z::MInteger)::Bool
    return !(y.n > z.n)
end

function Base.:≤(y::MInteger, z::Integer)::Bool
    return !(y.n > z)
end

function Base.:≤(y::Integer, z::MInteger)::Bool
    return !(y > z.n)
end

function Base.:≤(y::MReal, z::MReal)::Bool
    return !(y.n > z.n)
end

function Base.:≤(y::MReal, z::MInteger)::Bool
    return !(y.n > z.n)
end

function Base.:≤(y::MInteger, z::MReal)::Bool
    return !(y.n > z.n)
end

function Base.:≤(y::MReal, z::Real)::Bool
    return !(y.n > z)
end

function Base.:≤(y::Real, z::MReal)::Bool
    return !(y > z.n)
end

# Operator ≥

function Base.:≥(y::MInteger, z::MInteger)::Bool
    return !(y.n < z.n)
end

function Base.:≥(y::MInteger, z::Integer)::Bool
    return !(y.n < z)
end

function Base.:≥(y::Integer, z::MInteger)::Bool
    return !(y < z.n)
end

function Base.:≥(y::MReal, z::MReal)::Bool
    return !(y.n < z.n)
end

function Base.:≥(y::MReal, z::MInteger)::Bool
    return !(y.n < z.n)
end

function Base.:≥(y::MInteger, z::MReal)::Bool
    return !(y.n < z.n)
end

function Base.:≥(y::MReal, z::Real)::Bool
    return !(y.n < z)
end

function Base.:≥(y::Real, z::MReal)::Bool
    return !(y < z.n)
end

# Arithmetic operators.
# (No arithmetic operators are given for MArray, as they are containers.)

# Unary operator +

function Base.:+(y::MInteger)::Integer
    return +y.n
end

function Base.:+(y::MReal)::Real
    return +y.n
end

function Base.:+(y::MVector)::MVector
    len = y.len
    vec = Vector{Float64}(undef, y.len)
    for i in 1:y.len
        vec[i] = +y[i]
    end
    return MVector(vec)
end

function Base.:+(y::MMatrix)::MMatrix
    rows = y.rows
    cols = y.cols
    mtx  = Matrix{Float64}(undef, rows, cols)
    for i in 1:rows
        for j in 1:cols
            mtx[i,j] = +y[i,j]
        end
    end
    return MMatrix(mtx)
end

# Binary operator +

function Base.:+(y::MInteger, z::MInteger)::Integer
    return (y.n + z.n)
end

function Base.:+(y::MInteger, z::Integer)::Integer
    return (y.n + z)
end

function Base.:+(y::Integer, z::MInteger)::Integer
    return (y + z.n)
end

function Base.:+(y::MReal, z::MReal)::Real
    return (y.n + z.n)
end

function Base.:+(y::MReal, z::MInteger)::Real
    return (y.n + z.n)
end

function Base.:+(y::MInteger, z::MReal)::Real
    return (y.n + z.n)
end

function Base.:+(y::MReal, z::Real)::Real
    return (y.n + z)
end

function Base.:+(y::Real, z::MReal)::Real
    return (y + z.n)
end

function Base.:+(y::MVector, z::MVector)::MVector
    if y.len ≠ z.len
        msg = "Vector addition requires vectors with the same length."
        throw(DimensionMismatch(msg))
    end
    len = y.len
    vec = Vector{Float64}(undef, len)
    for i in 1:len
        vec[i] = y[i] + z[i]
    end
    return MVector(vec)
end

function Base.:+(y::MVector, z::Vector{<:Real})::MVector
    if y.len ≠ length(z)
        msg = "Vector addition requires vectors with the same length."
        throw(DimensionMismatch(msg))
    end
    len = y.len
    vec = Vector{Float64}(undef, len)
    for i in 1:len
        vec[i] = y[i] + z[i]
    end
    return MVector(vec)
end

function Base.:+(y::Vector{<:Real}, z::MVector)::MVector
    if length(y) ≠ z.len
        msg = "Vector addition requires vectors with the same length."
        throw(DimensionMismatch(msg))
    end
    len = z.len
    vec = Vector{Float64}(undef, len)
    for i in 1:len
        vec[i] = y[i] + z[i]
    end
    return MVector(vec)
end

function Base.:+(y::MMatrix, z::MMatrix)::MMatrix
    if y.rows ≠ z.rows || y.cols ≠ z.cols
        msg = "Matrix addition requires matrices with the same dimensions."
        throw(DimensionMismatch(msg))
    end
    rows = y.rows
    cols = y.cols
    mtx  = Matrix{Float64}(undef, rows, cols)
    for i in 1:rows
        for j in 1:cols
            mtx[i,j] = y[i,j] + z[i,j]
        end
    end
    return MMatrix(mtx)
end

function Base.:+(y::MMatrix, z::Matrix{<:Real})::MMatrix
    (z_rows, z_cols) = size(z)
    if y.rows ≠ z_rows || y.cols ≠ z_cols
        msg = "Matrix addition requires matrices with the same dimensions."
        throw(DimensionMismatch(msg))
    end
    rows = y.rows
    cols = y.cols
    mtx  = Matrix{Float64}(undef, rows, cols)
    for i in 1:rows
        for j in 1:cols
            mtx[i,j] = y[i,j] + z[i,j]
        end
    end
    return MMatrix(mtx)
end

function Base.:+(y::Matrix{<:Real}, z::MMatrix)::MMatrix
    (y_rows, y_cols) = size(y)
    if y_rows ≠ z.rows || y_cols ≠ z.cols
        msg = "Matrix addition requires matrices with the same dimensions."
        throw(DimensionMismatch(msg))
    end
    rows = z.rows
    cols = z.cols
    mtx  = Matrix{Float64}(undef, rows, cols)
    for i in 1:rows
        for j in 1:cols
            mtx[i,j] = y[i,j] + z[i,j]
        end
    end
    return MMatrix(mtx)
end

# Unary operator -

function Base.:-(y::MInteger)::Integer
    return -y.n
end

function Base.:-(y::MReal)::Real
    return -y.n
end

function Base.:-(y::MVector)::MVector
    len = y.len
    vec = Vector{Float64}(undef, len)
    for i in 1:len
        vec[i] = -y[i]
    end
    return MVector(vec)
end

function Base.:-(y::MMatrix)::MMatrix
    rows = y.rows
    cols = y.cols
    mtx  = Matrix{Float64}(undef, rows, cols)
    for i in 1:rows
        for j in 1:cols
            mtx[i,j] = -y[i,j]
        end
    end
    return MMatrix(mtx)
end

# Binary operator -

function Base.:-(y::MInteger, z::MInteger)::Integer
    return (y.n - z.n)
end

function Base.:-(y::MInteger, z::Integer)::Integer
    return (y.n - z)
end

function Base.:-(y::Integer, z::MInteger)::Integer
    return (y - z.n)
end

function Base.:-(y::MReal, z::MReal)::Real
    return (y.n - z.n)
end

function Base.:-(y::MReal, z::MInteger)::Real
    return (y.n - z.n)
end

function Base.:-(y::MInteger, z::MReal)::Real
    return (y.n - z.n)
end

function Base.:-(y::MReal, z::Real)::Real
    return (y.n - z)
end

function Base.:-(y::Real, z::MReal)::Real
    return (y - z.n)
end

function Base.:-(y::MVector, z::MVector)::MVector
    if y.len ≠ z.len
        msg = "Vector subtraction requires vectors with the same length."
        throw(DimensionMismatch(msg))
    end
    len = y.len
    vec = Vector{Float64}(undef, len)
    for i in 1:len
        vec[i] = y[i] - z[i]
    end
    return MVector(vec)
end

function Base.:-(y::MVector, z::Vector{<:Real})::MVector
    if y.len ≠ length(z)
        msg = "Vector subtraction requires vectors with the same length."
        throw(DimensionMismatch(msg))
    end
    len = y.len
    vec = Vector{Float64}(undef, len)
    for i in 1:len
        vec[i] = y[i] - z[i]
    end
    return MVector(vec)
end

function Base.:-(y::Vector{<:Real}, z::MVector)::MVector
    if length(y) ≠ z.len
        msg = "Vector subtraction requires vectors with the same length."
        throw(DimensionMismatch(msg))
    end
    len = z.len
    vec = Vector{Float64}(undef, len)
    for i in 1:len
        vec[i] = y[i] - z[i]
    end
    return MVector(vec)
end

function Base.:-(y::MMatrix, z::MMatrix)::MMatrix
    if y.rows ≠ z.rows || y.cols ≠ z.cols
        msg = "Matrix subtraction requires matrices with the same dimensions."
        throw(DimensionMismatch(msg))
    end
    rows = y.rows
    cols = y.cols
    mtx  = Matrix{Float64}(undef, rows, cols)
    for i in 1:rows
        for j in 1:cols
            mtx[i,j] = y[i,j] - z[i,j]
        end
    end
    return MMatrix(mtx)
end

function Base.:-(y::MMatrix, z::Matrix{<:Real})::MMatrix
    (z_rows, z_cols) = size(z)
    if y.rows ≠ z_rows || y.cols ≠ z_cols
        msg = "Matrix subtraction requires matrices with the same dimensions."
        throw(DimensionMismatch(msg))
    end
    rows = y.rows
    cols = y.cols
    mtx  = Matrix{Float64}(undef, rows, cols)
    for i in 1:rows
        for j in 1:cols
            mtx[i,j] = y[i,j] - z[i,j]
        end
    end
    return MMatrix(mtx)
end

function Base.:-(y::Matrix{<:Real}, z::MMatrix)::MMatrix
    (y_rows, y_cols) = size(y)
    if y_rows ≠ z.rows || y_cols ≠ z.cols
        msg = "Matrix subtraction requires matrices with the same dimensions."
        throw(DimensionMismatch(msg))
    end
    rows = z.rows
    cols = z.cols
    mtx  = Matrix{Float64}(undef, rows, cols)
    for i in 1:rows
        for j in 1:cols
            mtx[i,j] = y[i,j] - z[i,j]
        end
    end
    return MMatrix(mtx)
end

# Binary operator *

function Base.:*(y::MInteger, z::MInteger)::Integer
    return (y.n * z.n)
end

function Base.:*(y::MInteger, z::Integer)::Integer
    return (y.n * z)
end

function Base.:*(y::Integer, z::MInteger)::Integer
    return (y * z.n)
end

function Base.:*(y::MReal, z::MReal)::Real
    return (y.n * z.n)
end

function Base.:*(y::MReal, z::MInteger)::Real
    return (y.n * z.n)
end

function Base.:*(y::MInteger, z::MReal)::Real
    return (y.n * z.n)
end

function Base.:*(y::MReal, z::Real)::Real
    return (y.n * z)
end

function Base.:*(y::Real, z::MReal)::Real
    return (y * z.n)
end

function Base.:*(y::Real, z::MVector)::MVector
    len = z.len
    vec = Vector{Float64}(undef, len)
    for i in 1:len
        vec[i] = y * z[i]
    end
    return MVector(vec)
end

function Base.:*(y::MNumber, z::MVector)::MVector
    len = z.len
    vec = Vector{Float64}(undef, len)
    for i in 1:len
        vec[i] = y.n * z[i]
    end
    return MVector(vec)
end
function Base.:*(y::MNumber, z::Vector{<:Real})::Vector{<:Real}
    len = length(z)
    vec = Vector{Float64}(undef, len)
    for i in 1:len
        vec[i] = y.n * z[i]
    end
    return vec
end

function Base.:*(y::MVector, z::MVector)::Real
    if y.len ≠ z.len
        msg = "An inner product requires the vectors have the same length."
        throw(DimensionMismatch(msg))
    end
    dotProduct = LinearAlgebra.dot(y.vec, z.vec)
    return dotProduct
end

function Base.:*(y::MVector, z::Vector{<:Real})::Real
    if y.len ≠ length(z)
        msg = "An inner product requires the vectors have the same length."
        throw(DimensionMismatch(msg))
    end
    dotProduct = LinearAlgebra.dot(y.vec, z)
    return dotProduct
end

function Base.:*(y::Vector{<:Real}, z::MVector)::Real
    if length(y) ≠ z.len
        msg = "An inner product requires the vectors have the same length."
        throw(DimensionMismatch(msg))
    end
    dotProduct = LinearAlgebra.dot(y, z.vec)
    return dotProduct
end

function Base.:*(y::Real, z::MMatrix)::MMatrix
    rows = z.rows
    cols = z.cols
    mtx  = Matrix{Float64}(undef, rows, cols)
    for i in 1:rows
        for j in 1:cols
            mtx[i,j] = y * z[i,j]
        end
    end
    return MMatrix(mtx)
end

function Base.:*(y::MNumber, z::MMatrix)::MMatrix
    rows = z.rows
    cols = z.cols
    mtx  = Matrix{Float64}(undef, rows, cols)
    for i in 1:rows
        for j in 1:cols
            mtx[i,j] = y.n * z[i,j]
        end
    end
    return MMatrix(mtx)
end

function Base.:*(y::MNumber, z::Matrix{<:Real})::MMatrix
    (rows, cols) = size(z)
    mtx  = Matrix{Float64}(undef, rows, cols)
    for i in 1:rows
        for j in 1:cols
            mtx[i,j] = y.n * z[i,j]
        end
    end
    return MMatrix(mtx)
end

function Base.:*(y::MMatrix, z::MVector)::MVector
    if y.cols ≠ z.len
        msg = "Dimensions are not applicable for matrix multiplication."
        throw(DimensionMismatch(msg))
    end
    len = y.rows
    vec = Vector{Float64}(undef, len)
    for i in 1:len
        sum = 0.0
        for j in 1:y.cols
            sum += y[i,j] * z[j]
        end
        vec[i] = sum
    end
    return MVector(vec)
end

function Base.:*(y::MMatrix, z::Vector{<:Real})::MVector
    if y.cols ≠ length(z)
        msg = "Dimensions are not applicable for matrix multiplication."
        throw(DimensionMismatch(msg))
    end
    len = y.rows
    vec = Vector{Float64}(undef, len)
    for i in 1:len
        sum = 0.0
        for j in 1:y.cols
            sum += y[i,j] * z[j]
        end
        vec[i] = sum
    end
    return MVector(vec)
end

function Base.:*(y::Matrix{<:Real}, z::MVector)::MVector
    (rows, cols) = size(y)
    if cols ≠ z.len
        msg = "Dimensions are not applicable for matrix multiplication."
        throw(DimensionMismatch(msg))
    end
    len = rows
    vec = Vector{Float64}(undef, len)
    for i in 1:len
        sum = 0.0
        for j in 1:cols
            sum += y[i,j] * z[j]
        end
        vec[i] = sum
    end
    return MVector(vec)
end

function Base.:*(y::MMatrix, z::MMatrix)::MMatrix
    if y.cols ≠ z.rows
        msg = "Dimensions are not applicable for matrix multiplication."
        throw(DimensionMismatch(msg))
    end
    rows = y.rows
    cols = z.cols
    mtx  = Matrix{Float64}(undef, rows, cols)
    for i in 1:rows
        for j in 1:cols
            sum = 0.0
            for k in 1:y.cols
                sum += y[i,k] * z[k,j]
            end
            mtx[i,j] = sum
        end
    end
    return MMatrix(mtx)
end

function Base.:*(y::Matrix{<:Real}, z::MMatrix)::MMatrix
    (y_rows, y_cols) = size(y)
    if y_cols ≠ z.rows
        msg = "Dimensions are not applicable for matrix multiplication."
        throw(DimensionMismatch(msg))
    end
    rows = y_rows
    cols = z.cols
    mtx  = Matrix{Float64}(undef, rows, cols)
    for i in 1:rows
        for j in 1:cols
            sum = 0.0
            for k in 1:y_cols
                sum += y[i,k] * z[k,j]
            end
            mtx[i,j] = sum
        end
    end
    return MMatrix(mtx)
end

function Base.:*(y::MMatrix, z::Matrix{<:Real})::MMatrix
    (z_rows, z_cols) = size(z)
    if y.cols ≠ z_rows
        msg = "Dimensions are not applicable for matrix multiplication."
        throw(DimensionMismatch(msg))
    end
    rows = y.rows
    cols = z_cols
    mtx  = Matrix{Float64}(undef, rows, cols)
    for i in 1:rows
        for j in 1:cols
            sum = 0.0
            for k in 1:y.cols
                sum += y[i,k] * z[k,j]
            end
            mtx[i,j] = sum
        end
    end
    return MMatrix(mtx)
end

# Operators ÷, %, /, ^, \

# Operator ÷

function Base.:÷(y::MInteger, z::MInteger)::Integer
    return (y.n ÷ z.n)
end

function Base.:÷(y::MInteger, z::Integer)::Integer
    return (y.n ÷ z)
end

function Base.:÷(y::Integer, z::MInteger)::Integer
    return (y ÷ z.n)
end

# Operator %

function Base.:%(y::MInteger, z::MInteger)::Integer
    return (y.n % z.n)
end

function Base.:%(y::MInteger, z::Integer)::Integer
    return (y.n % z)
end

function Base.:%(y::Integer, z::MInteger)::Integer
    return (y % z.n)
end

# Operator /

function Base.:/(y::MInteger, z::MInteger)::Real
    return (y.n / z.n)
end

function Base.:/(y::MInteger, z::Integer)::Real
    return (y.n / z)
end

function Base.:/(y::Integer, z::MInteger)::Real
    return (y / z.n)
end

function Base.:/(y::MReal, z::MReal)::Real
    return (y.n / z.n)
end

function Base.:/(y::MReal, z::MInteger)::Real
    return (y.n / z.n)
end

function Base.:/(y::MInteger, z::MReal)::Real
    return (y.n / z.n)
end

function Base.:/(y::MReal, z::Real)::Real
    return (y.n / z)
end

function Base.:/(y::Real, z::MReal)::Real
    return (y / z.n)
end

function Base.:/(y::MVector, z::Real)::MVector
    len = y.len
    vec = Vector{Float64}(undef, len)
    for i in 1:len
        vec[i] = y[i] / z
    end
    return MVector(len, vec)
end

function Base.:/(y::MVector, z::MNumber)::MVector
    len = y.len
    vec = Vector{Float64}(undef, len)
    for i in 1:len
        vec[i] = y[i] / z.n
    end
    return MVector(vec)
end

function Base.:/(y::Vector{<:Real}, z::MNumber)::MVector
    len = length(y)
    vec = Vector{Float64}(undef, len)
    for i in 1:len
        vec[i] = y[i] / z.n
    end
    return MVector(vec)
end

function Base.:/(y::MMatrix, z::Real)::MMatrix
    rows = y.rows
    cols = y.cols
    mtx  = Matrix{Float64}(undef, rows, cols)
    for i in 1:rows
        for j in 1:cols
            mtx[i,j] = y[i,j] / z
        end
    end
    return MMatrix(mtx)
end

function Base.:/(y::MMatrix, z::MNumber)::MMatrix
    rows = y.rows
    cols = y.cols
    mtx  = Matrix{Float64}(undef, rows, cols)
    for i in 1:rows
        for j in 1:cols
            mtx[i,j] = y[i,j] / z.n
        end
    end
    return MMatrix(mtx)
end

function Base.:/(y::Matrix{<:Real}, z::MNumber)::MMatrix
    (rows, cols) = size(y)
    mtx  = Matrix{Float64}(undef, rows, cols)
    for i in 1:rows
        for j in 1:cols
            mtx[i,j] = y[i,j] / z.n
        end
    end
    return MMatrix(mtx)
end

# Operator ^

function Base.:^(y::MInteger, z::MInteger)::Integer
    return (y.n ^ z.n)
end

function Base.:^(y::MInteger, z::Integer)::Integer
    return (y.n ^ z)
end

function Base.:^(y::Integer, z::MInteger)::Integer
    return (y ^ z.n)
end

function Base.:^(y::MReal, z::MReal)::Real
    return (y.n ^ z.n)
end

function Base.:^(y::MReal, z::MInteger)::Real
    return (y.n ^ z.n)
end

function Base.:^(y::MInteger, z::MReal)::Real
    return (y.n ^ z.n)
end

function Base.:^(y::MNumber, z::Real)::Real
    return (y.n ^ z)
end

function Base.:^(y::Real, z::MNumber)::Real
    return (y ^ z.n)
end

# Operator \

function Base.:\(A::MMatrix, b::MVector)::MVector
    if A.rows ≠ b.len
        msg = "Solving the linear system of equations 'Ax=b' for vector 'x'\n"
        msg *= "requires the rows in matrix 'A' equals the length of vector 'b'."
        throw(DimensionMismatch(msg))
    end
    vec = Vector(b)
    mtx = Matrix(A)
    x   = mtx \ vec
    return MVector(x)
end

function Base.:\(A::MMatrix, b::Vector{<:Real})::MVector
    if A.rows ≠ length(b)
        msg = "Solving the linear system of equations 'Ax=b' for vector 'x'\n"
        msg *= "requires the rows in matrix 'A' equals the length of vector 'b'."
        throw(DimensionMismatch(msg))
    end
    vec = copy(b)
    mtx = Matrix(A)
    x   = mtx \ vec
    return MVector(x)
end

function Base.:\(A::Matrix{<:Real}, b::MVector)::MVector
    (rows, cols) = size(A)
    if rows ≠ b.len
        msg = "Solving the linear system of equations 'Ax=b' for vector 'x'\n"
        msg *= "requires the rows in matrix 'A' equals the length of vector 'b'."
        throw(DimensionMismatch(msg))
    end
    vec = Vector(b)
    mtx = Matrix(A)
    x   = mtx \ vec
    return MVector(x)
end

# Methods specific to type MReal.

function Base.:(round)(y::MReal)::Integer
    return convert(Int64, round(y.n))
end

function Base.:(ceil)(y::MReal)::Integer
    return convert(Int64, ceil(y.n))
end

function Base.:(floor)(y::MReal)::Integer
    return convert(Int64, floor(y.n))
end

# Functions for both mutable number types.

function Base.:(abs)(y::MNumber)::Real
    if y.n isa Integer
        return convert(Int64, abs(y.n))
    else
        return abs(y.n)
    end
end

function Base.:(sign)(y::MNumber)::Integer
    return Int(sign(y.n))
end

# Method arctan(rise,run), a.k.a. arctan2(y,x).

function Base.:(atan)(y::MNumber, x::MNumber)::Real
    return atan(y.n, x.n)
end

function Base.:(atan)(y::MNumber, x::Real)::Real
    return atan(y.n, x)
end

function Base.:(atan)(y::Real, x::MNumber)::Real
    return atan(y, x.n)
end

# Basic math functions for mutable number types.

function Base.:(sin)(y::MNumber)::Real
    return sin(y.n)
end

function Base.:(cos)(y::MNumber)::Real
    return cos(y.n)
end

function Base.:(tan)(y::MNumber)::Real
    return tan(y.n)
end

function Base.:(sinh)(y::MNumber)::Real
    return sinh(y.n)
end

function Base.:(cosh)(y::MNumber)::Real
    return cosh(y.n)
end

function Base.:(tanh)(y::MNumber)::Real
    return tanh(y.n)
end

function Base.:(asin)(y::MNumber)::Real
    return asin(y.n)
end

function Base.:(acos)(y::MNumber)::Real
    return acos(y.n)
end

function Base.:(atan)(y::MNumber)::Real
    return atan(y.n)
end

function Base.:(asinh)(y::MNumber)::Real
    return asinh(y.n)
end

function Base.:(acosh)(y::MNumber)::Real
    return acosh(y.n)
end

function Base.:(atanh)(y::MNumber)::Real
    return atanh(y.n)
end

function Base.:(log)(y::MNumber)::Real
    return log(y.n)
end

function Base.:(log2)(y::MNumber)::Real
    return log2(y.n)
end

function Base.:(log10)(y::MNumber)::Real
    return log10(y.n)
end

function Base.:(exp)(y::MNumber)::Real
    return exp(y.n)
end

function Base.:(exp2)(y::MNumber)::Real
    return exp2(y.n)
end

function Base.:(exp10)(y::MNumber)::Real
    return exp10(y.n)
end

function Base.:(sqrt)(y::MNumber)::Real
    if y.n == -0.0
        return 0.0
    else
        return sqrt(y.n)
    end
end

# Functions for vectors.

function norm(y::MVector, p::Real=2)::Real
    return LinearAlgebra.norm(y.vec, p)
end

function unitVector(y::MVector)::MVector
    unitVec = y / norm(y)
    return unitVec
end

function unitVector(y::Vector{<:Real})::Vector{<:Real}
    len = length(y)
    if eltype(y) isa BigFloat
        unitVec = Vector{BigFloat}(undef, len)
    elseif eltype(y) isa Float64
        unitVec = Vector{Float64}(undef, len)
    elseif eltype(y) isa Float32
        unitVec = Vector{Float32}(undef, len)
    else
        unitVec = Vector{Float16}(undef, len)
    end
    unitVec = y / norm(y)
    return unitVec
end

function cross(y::MVector, z::MVector)::MVector
    if (y.len ≠ 3) || (z.len ≠ 3)
        msg = "Vector cross product is only defined for 3 dimensional vectors."
        throw(DimensionMismatch(msg))
    end
    crossprod = LinearAlgebra.cross(y.vec, z.vec)
    return MVector(crossprod)
end

function cross(y::Vector{<:Real}, z::MVector)::MVector
    if (length(y) ≠ 3) || (z.len ≠ 3)
        msg = "Vector cross product is only defined for 3 dimensional vectors."
        throw(DimensionMismatch(msg))
    end
    crossprod = LinearAlgebra.cross(y, z.vec)
    return MVector(crossprod)
end

function cross(y::MVector, z::Vector{<:Real})::MVector
    if (y.len ≠ 3) || (length(z) ≠ 3)
        msg = "Vector cross product is only defined for 3 dimensional vectors."
        throw(DimensionMismatch(msg))
    end
    crossprod = LinearAlgebra.cross(y.vec, z)
    return MVector(crossprod)
end

# Functions for matrices.

function norm(y::MMatrix, p::Real=2)::Real
    mtx = Matrix(y)
    return LinearAlgebra.norm(mtx, p)
end

function Base.:(transpose)(y::MMatrix)::MMatrix
    ytranspose = MMatrix(y.cols, y.rows)
    for i in 1:y.rows
        for j in 1:y.cols
            ytranspose[j,i] = y[i,j]
        end
    end
    return ytranspose
end

function tr(y::MMatrix)::Real
    mtx = Matrix(y)
    return LinearAlgebra.tr(mtx)
end

function det(y::MMatrix)::Real
    mtx = Matrix(y)
    return LinearAlgebra.det(mtx)
end

function Base.:(inv)(y::MMatrix)::MMatrix
    mtx  = Matrix(y)
    minv = Base.inv(mtx)
    return MMatrix(minv)
end

function qr(y::Matrix{<:Real})::Tuple  # (Q, R) as instances of Matrix
    F = LinearAlgebra.qr(y)
    # Unpack Q and R from F.
    (rows, cols) = size(F.Q)
    q = Matrix{Float64}(undef, rows, cols)
    for i in 1:rows
        for j in 1:cols
            q[i,j] = F.Q[i,j]
        end
    end
    (rows, cols) = size(F.R)
    r = Matrix{Float64}(undef, rows, cols)
    for i in 1:rows
        for j in 1:cols
            r[i,j] = F.R[i,j]
        end
    end
    return (q, r)
end

function qr(y::MMatrix)::Tuple  # (Q, R) as instances of MMatrix
    mtx = Matrix(y)
    (q, r) = qr(mtx)
    return (MMatrix(q), MMatrix(r))
end

function lq(y::Matrix{<:Real})::Tuple  # (L, Q) as instances of Matrix
    S = LinearAlgebra.lq(y)
    # Unpack L and Q from S.
    (rows, cols) = size(S.L)
    l = Matrix{Float64}(undef, rows, cols)
    for i in 1:rows
        for j in 1:cols
            l[i,j] = S.L[i,j]
        end
    end
    (rows, cols) = size(S.Q)
    q = Matrix{Float64}(undef, rows, cols)
    for i in 1:rows
        for j in 1:cols
            q[i,j] = S.Q[i,j]
        end
    end
    return (l, q)
end

function lq(y::MMatrix)::Tuple  # (L, Q) as instances of MMatrix
    mtx = Matrix(y)
    (l, q) = lq(mtx)
    return (MMatrix(l), MMatrix(q))
end

function matrixProduct(y::Vector{<:Real}, z::Vector{<:Real})::Matrix{<:Real}
    rows = length(y)
    cols = length(z)
    if eltype(y) isa BigFloat || eltype(z) isa BigFloat
        mtx = Matrix{BigFloat}(undef, rows, cols)
    elseif eltype(y) isa Float64 || eltype(z) isa Float64
        mtx = Matrix{Float64}(undef, rows, cols)
    elseif eltype(y) isa Float32 || eltype(z) isa Float32
        mtx = Matrix{Float32}(undef, rows, cols)
    else
        mtx = Matrix{Float16}(undef, rows, cols)
    end
    for i in 1:rows
        for j in 1:cols
            mtx[i,j] = y[i] * z[j]
        end
    end
    return mtx
end

function matrixProduct(y::MVector, z::MVector)::MMatrix
    rows = y.len
    cols = z.len
    mtx  = Matrix{Float64}(undef, rows, cols)
    for i in 1:rows
        for j in 1:cols
            mtx[i,j] = y[i] * z[j]
        end
    end
    return MMatrix(mtx)
end

function matrixProduct(y::Vector{<:Real}, z::MVector)::MMatrix
    rows = length(y)
    cols = z.len
    mtx  = Matrix{Float64}(undef, rows, cols)
    for i in 1:rows
        for j in 1:cols
            mtx[i,j] = y[i] * z[j]
        end
    end
    return MMatrix(mtx)
end

function matrixProduct(y::MVector, z::Vector{<:Real})::MMatrix
    rows = y.len
    cols = length(z)
    mtx  = Matrix{Float64}(undef, rows, cols)
    for i in 1:rows
        for j in 1:cols
            mtx[i,j] = y[i] * z[j]
        end
    end
    return MMatrix(mtx)
end

# end MutableTypes
