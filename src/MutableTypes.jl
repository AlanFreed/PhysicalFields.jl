# MutableTypes

#=
JSON files, as implemented by JSON3.jl in Julia, handle the core types:
    Object, Array, String, Number, Bool and Null
where a Number is either a 64-bit integer of a 64-bit floating point number.
A JSON3.Object is an immutable Dict type, while a JSON3.Array is an immutable
Vector type. Command copy(JSON3.Object) will return a mutable Dict object,
while command copy(JSON3.Array) will return a mutable Vector object.

To work with JSON files, the following set of types are exported:
    MBoolean, MInteger, MReal, MVector, MMatrix and MArray.
Values held by these types are mutable, hence the 'M'.

Note: The types MVector, MMatrix and MArray exported here are distinct from
      those with like names exported from module StaticArrays. The arrays held
      here by these three exported types are dynamically allocated arrays,
      whereas those with like names exported from StaticArrays are statically
      allocated arrays.
=#

#=
-------------------------------------------------------------------------------
=#

# Exported base types with mutable values.

abstract type MNumber <: Number end

# All constructors are internal constructors.

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

struct MVector
    len::Int64              # A vector's length, which is fixed.
    vec::Vector{Float64}    # A column vector with mutable elements.

    # constructors

    function MVector(length::Int64)
        if length > 0
            vector = zeros(Float64, length)
        else
            msg = "The vector's length must be positive valued."
            throw(ErrorException(msg))
        end
        new(length, vector)
    end

    function MVector(vector::Vector{Float64})
        length = convert(Int64, Base.length(vector))
        new(length, vector)
    end

    function MVector(length::Int64, vector::Vector{Float64})
        if length ≠ Base.length(vector)
            msg = "The assigned length doesn't equal the vector's length."
            throw(DimensionMismatch(msg))
        end
        new(length, vector)
    end
end # MVector

struct MMatrix
    rows::Int64             # Rows in a matrix, which is fixed.
    cols::Int64             # Columns in a matrix, which is fixed.
    vec::Vector{Float64}    # A matrix reshaped as a column vector with mutable elements.

    # constructors

    function MMatrix(rows::Int64, columns::Int64)
        if (rows > 0) && (columns > 0)
            length = rows * columns
            vector = zeros(Float64, length)
        else
            msg = "The rows and columns of a matrix must be positive valued."
            throw(ExceptionError(msg))
        end
        new(rows, columns, vector)
    end

    function MMatrix(matrix::Matrix{Float64})
        (rows, columns) = size(matrix)
        vector = Base.vec(matrix)
        new(rows, columns, vector)
    end

    function MMatrix(rows::Int64, columns::Int64, vector::Vector{Float64})
        if rows*columns ≠ Base.length(vector)
            msg = "Matrix size dimensions don't equate with the vector's length."
            throw(DimensionMismatch(msg))
        end
        new(rows, columns, vector)
    end
end # MMatrix

struct MArray
    pgs::Int64              # Pages in an array, which is fixed.
                            #    Each page contains a rows×cols matrix.
    rows::Int64             # Matrix rows in each page, which is fixed.
    cols::Int64             # Matrix columns in each page, which is fixed.
    vec::Vector{Float64}    # An array reshaped as a column vector with mutable elements.

    # constructors

    function MArray(pages::Int64, rows::Int64, columns::Int64)
        if (pages > 0) && (rows > 0) && (columns > 0)
            length = pages * rows * columns
            vector = zeros(Float64, length)
        else
            msg = "The size dimensions of an array must be positive."
            throw(ErrorException(msg))
        end
        new(pages, rows, columns, vector)
    end

    function MArray(array::Array{Float64,3})
        (pages, rows, columns) = size(array)
        vector = Base.vec(array)
        new(pages, rows, columns, vector)
    end

    function MArray(pages::Int64, rows::Int64, columns::Int64, vector::Vector{Float64})
        if (pages < 1) || (rows < 1) || (columns < 1)
            msg = "The size dimensions of an array must be positive."
            throw(ErrorException(msg))
        end
        if pages*rows*columns ≠ Base.length(vector)
            msg = "Assigned size dimensions don't equate with the vector's length."
            throw(DimensionMismatch(msg))
        end
        new(pages, rows, columns, vector)
    end
end # MArray

#=
-------------------------------------------------------------------------------
=#

# Type-casting methods that return the raw type of a mutable field.

function Base.:(Bool)(mb::MBoolean)::Bool
    return deepcopy(mb.b)
end

function Base.:(Integer)(mi::MInteger)::Integer
    return deepcopy(mi.n)
end

function Base.:(Real)(mr::MReal)::Real
    return deepcopy(mr.n)
end

function Base.:(Vector)(mv::MVector)::Vector{Float64}
    return deepcopy(mv.vec)
end

function Base.:(Matrix)(mm::MMatrix)::Matrix{Float64}
    vec = deepcopy(mm.vec)
    mtx = reshape(vec, (mm.rows, mm.cols))
    return mtx
end

function Base.:(Array)(ma::MArray)::Array{Float64,3}
    vec = deepcopy(ma.vec)
    arr = reshape(vec, (ma.pgs, ma.rows, ma.cols))
    return arr
end

#=
-------------------------------------------------------------------------------
=#

# Method toString for built-in boolean types.

function toString(y::Bool; aligned::Bool=false)::String
    if aligned && (y == true)
        s = " "
    else
        s = ""
    end
    s *= string(y)
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
            s *= string(' ', toString(v[i]))
        end
    else
        for i in 2:len-2
            s *= string(' ', toString(v[i]))
        end
        s *= string(" ⋯ ", toString(v[v_len]))
    end
    s *= string("}ᵀ")
    return s
end

function toString(m::Matrix{Bool})::String
    aligned = true
    (m_rows, m_cols) = size(m)
    # Establish how many rows are to be printed out.
    if m_rows < 12
        rows = m_rows
    else
        rows = 12
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
            s *= toString(m[row,1]; aligned)
            for col in 2:cols-2
                s *= string(' ', toString(m[row,col]; aligned))
            end
            if cols == m_cols
                s *= string(' ', toString(m[row,cols-1]; aligned), ' ')
            else
                s *= " ⋯ "
            end
            s *= toString(m[row,m_cols]; aligned)
        else # rows < m_rows
            if row < rows-1
                s *= toString(m[row,1]; aligned)
                for col in 2:cols-2
                    s *= string(' ', toString(m[row,col]; aligned))
                end
                if cols == m_cols
                    s *= string(' ', toString(m[row,cols-1]; aligned), ' ')
                else
                    s *= " ⋯ "
                end
                s *= toString(m[row,m_cols]; aligned)
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
                s *= toString(m[m_rows,1]; aligned)
                for col in 2:cols-2
                    s *= string(' ', toString(m[m_rows,col]; aligned))
                end
                if cols == m_cols
                    s *= string(' ', toString(m[m_rows,cols-1]; aligned), ' ')
                else
                    s *= " ⋯ "
                end
                s *= toString(m[m_rows,m_cols]; aligned)
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

# Method toString for built-in 64-bit integer types.

function toString(y::Int64; digits::Int64=0)::String
    y_digits = ndigits(y)
    if y < 0
        y_digits += 1
    end
    s = ""
    for i in y_digits+1:digits
        s *= string(' ')
    end
    s *= @sprintf "%i" y;
    return s
end

function toString(v::Vector{Int64})::String
    v_len = length(v)
    # Establish how many entries are to be printed out.
    digits = 0
    is_neg = false
    for i in 1:v_len
        digits = max(digits, ndigits(v[i]))
        if !is_neg && (v[i] < 0)
            is_neg = true
        end
    end
    if !is_neg
        len = min(v_len, 72÷(digits+1))
    else
        len = min(v_len, 72÷(digits+2))
    end
    # Create a string representation for this vector.
    s = string('{', toString(v[1]))
    if len == v_len
        for i in 2:len
            s *= string(' ', toString(v[i]))
        end
    else
        for i in 2:len-2
            s *= string(' ', toString(v[i]))
        end
        s *= string(" ⋯ ", toString(v[v_len]))
    end
    s *= string("}ᵀ")
    return s
end

function toString(m::Matrix{Int64})::String
    (m_rows, m_cols) = size(m)
    # Determine the number of rows and columns to print out.
    digits = 0
    is_neg = false
    for row in 1:m_rows
        for col in 1:m_cols
            digits = max(digits, ndigits(m[row,col]))
            if !is_neg && (m[row,col] < 0)
                is_neg = true
            end
        end
    end
    if !is_neg
        cols = min(m_cols, 72÷(digits+1))
    else
        cols = min(m_cols, 72÷(digits+2))
    end
    rows = min(m_rows, cols)
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
            s *= toString(m[row,1]; digits)
            for col in 2:cols-2
                s *= string(' ', toString(m[row,col]; digits))
            end
            if cols == m_cols
                s *= string(' ', toString(m[row,cols-1]; digits), ' ')
            else
                s *= " ⋯ "
            end
            s *= toString(m[row,m_cols]; digits)
        else # rows < m_rows
            if row < rows-1
                s *= toString(m[row,1]; digits)
                for col in 2:cols-2
                    s *= string(' ', toString(m[row,col]; digits))
                end
                if cols == m_cols
                    s *= string(' ', toString(m[row,cols-1]; digits), ' ')
                else
                    s *= " ⋯ "
                end
                s *= toString(m[row,m_cols]; digits)
            elseif row == rows-1
                # Create the ellipses string for specified integer digits.
                # The first ellipses.
                s1 = ""
                for i in 1:digits-1
                    s1 *= ' '
                end
                s1 *= "⋮"
                # Create this row of ellipses.
                s *= s1
                for col in 2:cols-2
                    s *= string(' ', s1)
                end
                if cols == m_cols
                    s *= string(' ', s1, ' ')
                else
                    s *= " ⋱ "
                end
                s *= s1
            else # (m_rows > rows) && (row == m_rows)
                s *= toString(m[m_rows,1]; digits)
                for col in 2:cols-2
                    s *= string(' ', toString(m[m_rows,col]; digits))
                end
                if cols == m_cols
                    s *= string(' ', toString(m[m_rows,cols-1]; digits), ' ')
                else
                    s *= " ⋯ "
                end
                s *= toString(m[m_rows,m_cols]; digits)
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

function toString(y::Float64;
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
        if !aligned
            s = "NaN"
        elseif format == 'e' || format == 'E'
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
        if y > 0.0
            if !aligned
                s = "Inf"
            elseif format == 'e' || format == 'E'
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
        else
            if !aligned
                s = "-Inf"
            elseif format == 'e' || format == 'E'
                if precision == 7
                    s = "-Inf        "
                elseif precision == 6
                    s = "-Inf       "
                elseif precision == 5
                    s = "-Inf      "
                elseif precision == 4
                    s = "-Inf     "
                else
                    s = "-Inf    "
                end
            else # format = 'f' or 'F'
                if precision == 7
                    s = "-Inf    "
                elseif precision == 6
                    s = "-Inf   "
                elseif precision == 5
                    s = "-Inf  "
                elseif precision == 4
                    s = "-Inf "
                else
                    s = "-Inf"
                end
            end
        end
    else
        if format == 'e'
            if precision == 7
                s = @sprintf "%.6e" y;
            elseif precision == 6
                s = @sprintf "%.5e" y;
            elseif precision == 5
                s = @sprintf "%.4e" y;
            elseif precision == 4
                s = @sprintf "%.3e" y;
            else
                s = @sprintf "%.2e" y;
            end
        elseif format == 'E'
            if precision == 7
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
        else  # format = 'f' or 'F'
            if precision == 7
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
    if aligned && (isnan(y) || (y ≥ -0.0))
        s = string(" ", s)
    end
    return s
end

function _VtoStringE(v::Vector{Float64}; format::Char)::String
    len = length(v)
    aligned = false
    if len < 6
        precision = 5
    elseif len == 6
        precision = 4
    else
        precision = 3
    end
    s = string('{', toString(v[1]; format, precision, aligned))
    if len < 8
        for i in 2:len
            s *= string(' ', toString(v[i]; format, precision, aligned))
        end
    else
        for i in 2:5
            s *= string(' ', toString(v[i]; format, precision, aligned))
        end
        s *= string(" ⋯ ", toString(v[len]; format, precision, aligned))
    end
    s *= string("}ᵀ")
    return s
end

function _VtoStringF(v::Vector{Float64})::String
    len = length(v)
    format = 'F'
    aligned = false
    if len < 9
        precision = 5
    elseif len == 9
        precision = 4
    else
        precision = 3
    end
    s = string('{', toString(v[1]; format, precision, aligned))
    if len < 12
        for i in 2:len
            s *= string(' ', toString(v[i]; format, precision, aligned))
        end
    else
        for i in 2:9
            s *= string(' ', toString(v[i]; format, precision, aligned))
        end
        s *= string(" ⋯ ", toString(v[len]; format, precision, aligned))
    end
    s *= string("}ᵀ")
    return s
end

function toString(v::Vector{Float64}; format::Char='E')::String
    if (format == 'e') || (format == 'E')
        return _VtoStringE(v; format)
    else
        return _VtoStringF(v)
    end
end

function _MtoStringE(m::Matrix{Float64}; format::Char)::String
    (m_rows, m_cols) = size(m)
    aligned = true
    # Establish how many rows are to be printed out.
    if m_rows < 6
        rows = m_rows
    else
        rows = 6
    end
    # Establish how many columns are to be printed out.
    if m_cols < 5
        cols = m_cols
        precision = 5
    elseif m_cols == 5
        cols = 5
        precision = 4
    else
        cols = 6
        precision = 3
    end
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
        if (m_rows > rows) && (i == 5)
            if cols < 5
                s *= "     ⋮     "
                for j in 2:cols-2
                    s *= "      ⋮     "
                end
                if m_cols > cols
                    s *= "  ⋱       ⋮     "
                else
                    s *= "      ⋮           ⋮     "
                end
            elseif cols == 5
                s *= "    ⋮     "
                for j in 2:cols-2
                    s *= "     ⋮     "
                end
                if m_cols > cols
                    s *= "  ⋱     ⋮     "
                else
                    s *= "     ⋮          ⋮     "
                end
            else
                s *= "    ⋮    "
                for j in 2:cols-2
                    s *= "     ⋮    "
                end
                if m_cols > cols
                    s *= "  ⋱     ⋮    "
                else
                    s *= "     ⋮         ⋮    "
                end
            end
        else
            for j in 1:cols-2
                s *= string(toString(m[i,j]; format, precision, aligned), ' ')
            end
            if m_cols > cols
                s *= " ⋯ "
            else
                s *= string(toString(m[i,cols-1]; format, precision, aligned), ' ')
            end
            s *= toString(m[i,m_cols]; format, precision, aligned)
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

function _MtoStringF(m::Matrix{Float64})::String
    (m_rows, m_cols) = size(m)
    format = 'F'
    aligned = true
    # Establish how many rows are to be printed out.
    if m_rows < 11
        rows = m_rows
    else
        rows = 10
    end
    # Establish how many columns are to be printed out.
    if m_cols < 9
        cols = m_cols
        precision = 5
    elseif m_cols == 9
        cols = 9
        precision = 4
    else
        cols = 10
        precision = 3
    end
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
        if (m_rows > rows) && (i == 9)
            if cols < 9
                s *= "   ⋮   "
                for j in 2:cols-2
                    s *= "    ⋮   "
                end
                if m_cols > cols
                    s *= "  ⋱     ⋮   "
                else
                    s *= "    ⋮       ⋮   "
                end
            elseif cols == 9
                s *= "  ⋮   "
                for j in 2:cols-2
                    s *= "   ⋮   "
                end
                if m_cols > cols
                    s *= "  ⋱    ⋮   "
                else
                    s *= "   ⋮     ⋮   "
                end
            else
                s *= "  ⋮  "
                for j in 2:cols-2
                    s *= "   ⋮  "
                end
                if m_cols > cols
                    s *= "  ⋱   ⋮  "
                else
                    s *= "   ⋮     ⋮  "
                end
            end
        else
            for j in 1:cols-2
                s *= string(toString(m[i,j]; format, precision, aligned), ' ')
            end
            if m_cols > cols
                s *= " ⋯ "
            else
                s *= string(toString(m[i,cols-1]; format, precision, aligned), ' ')
            end
            s *= toString(m[i,m_cols]; format, precision, aligned)
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

function toString(m::Matrix{Float64}; format::Char='E')::String
    if format == 'e' || format == 'E'
        return _MtoStringE(m; format)
    else
        return _MtoStringF(m)
    end
end

# Method toString does not exist for arrays in three dimensions or higher.

#=
-------------------------------------------------------------------------------
=#

# Method toString for the mutable number types.

function toString(y::MBoolean; aligned::Bool=false)::String
    return toString(y.b; aligned)
end

function toString(y::MInteger; digits::Int64=0)::String
    return toString(y.n; digits)
end

function toString(y::MReal;
                  format::Char='E',
                  precision::Int=5,
                  aligned::Bool=false)::String
    return toString(y.n; format, precision, aligned)
end

# Method toString for mutable array types.

function toString(mv::MVector; format::Char='E')::String
    if (format == 'e') || (format == 'E')
        return _VtoStringE(mv.vec; format)
    else
        return _VtoStringF(mv.vec)
    end
end

function toString(mm::MMatrix; format::Char='E')::String
    mtx = Matrix(mm)
    if format == 'e' || format == 'E'
        return _MtoStringE(mtx; format)
    else
        return _MtoStringF(mtx)
    end
end

# MArrays are used as containers, and as such, no toString method is provided.

#=
-------------------------------------------------------------------------------
=#

# Methods get and getindex.

function Base.:(get)(y::MBoolean)::Bool
    return deepcopy(y.b)
end

function Base.:(get)(y::MInteger)::Integer
    return deepcopy(y.n)
end

function Base.:(get)(y::MReal)::Real
    return deepcopy(y.n)
end

function Base.:(getindex)(y::MVector, index::Integer)::Real
    if (index < 1) || (index > y.len)
        msg = string("Admissible vector indices are ∈ [1…", toString(y.len), "].")
        throw(DimensionMismatch(msg))
    end
    return deepcopy(y.vec[index])
end

function Base.:(getindex)(y::MMatrix, row::Integer)::Vector{Float64}
    if (row < 1) || (row > y.rows)
        msg = string("Admissible row indices are ∈ [1…", toString(y.rows), "].")
        throw(DimensionMismatch(msg))
    end
    vec = Vector{Float64}(undef, y.cols)
    for i in 1:y.cols
        index = row + (i - 1)*y.rows
        vec[i] = y.vec[index]
    end
    return vec
end

function Base.:(getindex)(y::MMatrix, row::Integer, column::Integer)::Real
    if (row < 1) || (row > y.rows) || (column < 1) || (column > y.cols)
        msg = string("Admissible matrix indices are ∈ [1…", toString(y.rows), ", 1…", toString(y.cols), "].")
        throw(DimensionMismatch(msg))
    end
    index = row + (column - 1)*y.rows
    return deepcopy(y.vec[index])
end

function Base.:(getindex)(y::MArray, page::Integer)::Matrix{Float64}
    if (page < 1) || (page > y.pgs)
        msg = string("Admissible page indices are ∈ [1…", toString(y.pgs), "].")
        throw(DimensionMismatch(msg))
    end
    mtx = Matrix{Float64}(undef, y.rows, y.cols)
    for i in 1:y.rows
        for j in 1:y.cols
            index = page + (i - 1)*y.pgs + (j - 1)*y.pgs*y.rows
            mtx[i,j] = y.vec[index]
        end
    end
    return mtx
end

function Base.:(getindex)(y::MArray, page::Integer, row::Integer, column::Integer)::Real
    if (((page < 1) || (page > y.pgs)) ||
        ((row < 1) || (row > y.rows)) ||
        ((column < 1) || (column > y.cols)))
        msg = string("Admissible 3D array indices are ∈ [1…", toString(y.pgs), ", 1…", toString(y.rows), ", 1…", toString(y.cols), "].")
        throw(DimensionMismatch(msg))
    end
    index = page + (row - 1)*y.pgs + (column - 1)*y.pgs*y.rows
    return deepcopy(y.vec[index])
end

#=
-------------------------------------------------------------------------------
=#

# Methods set! and setindex!.

function set!(y::MBoolean, x::Bool)
    y.b = x
    return nothing
end

function set!(y::MInteger, x::Integer)
    y.n = convert(Int64, x)
    return nothing
end

function set!(y::MReal, x::Real)
    y.n = convert(Float64, x)
    return nothing
end

function Base.:(setindex!)(y::MVector, value::Real, index::Integer)
    if (index < 1) || (index > y.len)
        msg = string("Admissible vector indices are ∈ [1…", string(y.len), "].")
        throw(DimensionMismatch(msg))
    end
    y.vec[index] = convert(Float64, value)
    return nothing
end

function Base.:(setindex!)(y::MMatrix, value::Vector{Float64}, row::Integer)
    if length(value) ≠ y.cols
        msg = "The dimensions for vector insertion into a matrix don't match."
        throw(DimensionMismatch(msg))
    end
    if (row < 1) || (row > y.rows)
        msg = string("Admissible column indices are ∈ [1…", toString(y.rows), "].")
        throw(DimensionMismatch(msg))
    end
    for i in 1:y.cols
        index = row + (i - 1)*y.rows
        y.vec[index] = value[i]
    end
    return nothing
end

function Base.:(setindex!)(y::MMatrix, value::Real, row::Integer, column::Integer)
    if (row < 1) || (row > y.rows) || (column < 1) || (column > y.cols)
        msg = string("Admissible matrix indices are ∈ [1…", toString(y.rows), ", 1…", toString(y.cols), "].")
        throw(DimensionMismatch(msg))
    end
    index = row + (column - 1)*y.rows
    y.vec[index] = convert(Float64, value)
    return nothing
end

function Base.:(setindex!)(y::MArray, value::Matrix{Float64}, page::Integer)
    if (page < 1) || (page > y.pgs)
        msg = string("Admissible page indices are ∈ [1…", toString(y.pgs), "].")
        throw(DimensionMismatch(msg))
    end
    (rows, cols) = size(value)
    if (rows ≠ y.rows) || (cols ≠ y.cols)
        msg = "The dimensions for matrix insertion into an array don't match."
        throw(DimensionMismatch(msg))
    end
    if i in 1:y.rows
        for j in 1:y.cols
            index = page + (i - 1)*y.pgs + (j - 1)*y.pgs*y.rows
            y.vec[index] = value[i,j]
        end
    end
    return nothing
end

function Base.:(setindex!)(y::MArray, value::Real, page::Integer, row::Integer, column::Integer)
    if (((page < 1) || (page > y.pgs)) ||
        ((row < 1) || (row > y.rows)) ||
        ((column < 1) || (column > y.cols)))
        msg = string("Admissible 3D array indices are ∈ [1…", toString(y.pgs), ", 1…", toString(y.rows), ", 1…", toString(y.cols), "].")
        throw(DimensionMismatch(msg))
    end
    index = page + (row - 1)*y.pgs + (column - 1)*y.pgs*y.rows
    y.vec[index] = convert(Float64, value)
    return nothing
end

#=
-------------------------------------------------------------------------------
=#

"""
Function\n
    openJSONReader(my_dir_path::String, my_file_name::String)::IOStream\n
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
Function\n
    openJSONWriter(my_dir_path::String, my_file_name::String)::IOStream\n
Returns a JSON stream attached to a file with a `.json` extension, opened in
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
Function\n
    closeJSONStream(json_stream::IOStream)\n
Flushes the `json_stream` and closes the file that it was attached to.
"""
function closeJSONStream(json_stream::IOStream)
    if isopen(json_stream)
        close(json_stream)
    end
    return nothing
end

#=
-------------------------------------------------------------------------------
=#

# Type declarations needed to work with JSON3 files.

StructTypes.StructType(::Type{MBoolean}) = StructTypes.Mutable()

StructTypes.StructType(::Type{MInteger}) = StructTypes.Mutable()

StructTypes.StructType(::Type{MReal})    = StructTypes.Mutable()

StructTypes.StructType(::Type{MVector})  = StructTypes.Struct()

StructTypes.StructType(::Type{MMatrix})  = StructTypes.Struct()

StructTypes.StructType(::Type{MArray})   = StructTypes.Struct()

#=
-------------------------------------------------------------------------------
=#

# Write built-in types to a JSON file.

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

function toFile(y::Int64, json_stream::IOStream)
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

function toFile(y::Float64, json_stream::IOStream)
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

function toFile(y::Vector{Bool}, json_stream::IOStream)
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

function toFile(y::Vector{Int64}, json_stream::IOStream)
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

function toFile(y::Vector{Integer}, json_stream::IOStream)
    if isopen(json_stream)
        len = length(y)
        vec = Vector{Int64}(undef, len)
        for i in 1:len
            vec[i] = convert(Int64, y[i])
        end
        JSON3.write(json_stream, vec)
        write(json_stream, '\n')
    else
        msg = "The supplied JSON stream is not open."
        throw(ErrorException(msg))
    end
    flush(json_stream)
    return nothing
end

function toFile(y::Vector{Float64}, json_stream::IOStream)
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

function toFile(y::Vector{Real}, json_stream::IOStream)
    if isopen(json_stream)
        len = length(y)
        vec = Vector{Float64}(undef, len)
        for i in 1:len
            vec[i] = convert(Float64, y[i])
        end
        JSON3.write(json_stream, vec)
        write(json_stream, '\n')
    else
        msg = "The supplied JSON stream is not open."
        throw(ErrorException(msg))
    end
    flush(json_stream)
    return nothing
end

function toFile(y::Dict, json_stream::IOStream)
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

# Write the mutable versions of these built-in types to a JSON file.

function toFile(y::MBoolean, json_stream::IOStream)
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

# Write the various mutable arrays to a JSON file.

function toFile(y::MVector, json_stream::IOStream)
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

function toFile(y::MMatrix, json_stream::IOStream)
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

function toFile(y::MArray, json_stream::IOStream)
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

# Read built-in types from a JSON file.

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

function fromFile(::Type{Int64}, json_stream::IOStream)::Int64
    if isopen(json_stream)
        y = JSON3.read(readline(json_stream), Int64)
    else
        msg = "The supplied JSON stream is not open."
        throw(ErrorException(msg))
    end
    return y
end

function fromFile(::Type{Float64}, json_stream::IOStream)::Float64
    if isopen(json_stream)
        y = JSON3.read(readline(json_stream), Float64)
    else
        msg = "The supplied JSON stream is not open."
        throw(ErrorException(msg))
    end
    return y
end

function fromFile(::Type{Vector{Bool}}, json_stream::IOStream)::Vector{Bool}
    if isopen(json_stream)
        y = JSON3.read(readline(json_stream), Vector{Bool})
    else
        msg = "The supplied JSON stream is not open."
        throw(ErrorException(msg))
    end
    # y is an immutable array. copy(y) returns y as a mutable array.
    return copy(y)
end

function fromFile(::Type{Vector{Int64}}, json_stream::IOStream)::Vector{Int64}
    if isopen(json_stream)
        y = JSON3.read(readline(json_stream), Vector{Int64})
    else
        msg = "The supplied JSON stream is not open."
        throw(ErrorException(msg))
    end
    # y is an immutable array. copy(y) returns y as a mutable array.
    return copy(y)
end

function fromFile(::Type{Vector{Float64}}, json_stream::IOStream)::Vector{Float64}
    if isopen(json_stream)
        y = JSON3.read(readline(json_stream), Vector{Float64})
    else
        msg = "The supplied JSON stream is not open."
        throw(ErrorException(msg))
    end
    # y is an immutable array. copy(y) returns y as a mutable array.
    return copy(y)
end

function fromFile(::Type{Dict}, json_stream::IOStream)::Dict
    if isopen(json_stream)
        y = JSON3.read(readline(json_stream), Dict)
    else
        msg = "The supplied JSON stream is not open."
        throw(ErrorException(msg))
    end
    # y is an immutable dictionary. copy(y) returns y as a mutable dictionary.
    return copy(y)
end

# Read the mutable versions of these built-in types from a JSON file.

function fromFile(::Type{MBoolean}, json_stream::IOStream)::MBoolean
    if isopen(json_stream)
        y = JSON3.read(readline(json_stream), MBoolean)
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

function fromFile(::Type{MReal}, json_stream::IOStream)::MReal
    if isopen(json_stream)
        y = JSON3.read(readline(json_stream), MReal)
    else
        msg = "The supplied JSON stream is not open."
        throw(ErrorException(msg))
    end
    return y
end

function fromFile(::Type{MVector}, json_stream::IOStream)::MVector
    if isopen(json_stream)
        y = JSON3.read(readline(json_stream), MVector)
    else
        msg = "The supplied JSON stream is not open."
        throw(ErrorException(msg))
    end
    return y
end

function fromFile(::Type{MMatrix}, json_stream::IOStream)::MMatrix
    if isopen(json_stream)
        y = JSON3.read(readline(json_stream), MMatrix)
    else
        msg = "The supplied JSON stream is not open."
        throw(ErrorException(msg))
    end
    return y
end

function fromFile(::Type{MArray}, json_stream::IOStream)::MArray
    if isopen(json_stream)
        y = JSON3.read(readline(json_stream), MArray)
    else
        msg = "The supplied JSON stream is not open."
        throw(ErrorException(msg))
    end
    return y
end

#=
-------------------------------------------------------------------------------
=#

# Method copy for these mutable types.

function Base.:(copy)(y::MBoolean)::MBoolean
    return MBoolean(copy(y.b))
end

function Base.:(copy)(y::MInteger)::MInteger
    return MInteger(copy(y.n))
end

function Base.:(copy)(y::MReal)::MReal
    return MReal(copy(y.n))
end

function Base.:(copy)(y::MVector)::MVector
    return MVector(copy(y.len), copy(y.vec))
end

function Base.:(copy)(y::MMatrix)::MMatrix
    return MMatrix(copy(y.rows), copy(y.cols), copy(y.vec))
end

function Base.:(copy)(y::MArray)::MArray
    return MArray(copy(y.pgs), copy(y.rows), copy(y.cols), copy(y.vec))
end

#=
-------------------------------------------------------------------------------
=#

# Method deepcopy for these mutable types.

function Base.:(deepcopy)(y::MBoolean)::MBoolean
    return MBoolean(deepcopy(y.b))
end

function Base.:(deepcopy)(y::MInteger)::MInteger
    return MInteger(deepcopy(y.n))
end

function Base.:(deepcopy)(y::MReal)::MReal
    return MReal(deepcopy(y.n))
end

function Base.:(deepcopy)(y::MVector)::MVector
    return MVector(deepcopy(y.len), deepcopy(y.vec))
end

function Base.:(deepcopy)(y::MMatrix)::MMatrix
    return MMatrix(deepcopy(y.rows), deepcopy(y.cols), deepcopy(y.vec))
end

function Base.:(deepcopy)(y::MArray)::MArray
    return MArray(deepcopy(y.pgs), deepcopy(y.rows), deepcopy(y.cols), deepcopy(y.vec))
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

function Base.:(==)(y::MVector, z::Vector{Float64})::Bool
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

function Base.:(==)(y::Vector{Float64}, z::MVector)::Bool
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

function Base.:(==)(y::MMatrix, z::Matrix{Float64})::Bool
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

function Base.:(==)(y::Matrix{Float64}, z::MMatrix)::Bool
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
    if !isequal(y.pgs, z.pgs) || !isequal(y.rows, z.rows) || !isequal(y.cols, z.cols)
        return false
    end
    for i in 1:y.pgs*y.rows*y.cols
        if !isequal(y.vec[i], z.vec[i])
            return false
        end
    end
    return true
end

function Base.:(==)(y::MArray, z::Array{Float64,3})::Bool
    (z_pgs, z_rows, z_cols) = size(z)
    if !isequal(y.pgs, z_pgs) || !isequal(y.rows, z_rows) || !isequal(y.cols, z_cols)
        return false
    end
    for i in 1:y.pgs
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

function Base.:(==)(y::Array{Float64,3}, z::MArray)::Bool
    (y_pgs, y_rows, y_cols) = size(y)
    if !isequal(y_pgs, z.pgs) || !isequal(y_rows, z.rows) || !isequal(y_cols, z.cols)
        return false
    end
    for i in 1:y_pgs
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

function Base.:≠(y::MVector, z::Vector{Float64})::Bool
    return !(y == z)
end

function Base.:≠(y::Vector{Float64}, z::MVector)::Bool
    return !(y == z)
end

function Base.:≠(y::MMatrix, z::MMatrix)::Bool
    return !(y == z)
end

function Base.:≠(y::MMatrix, z::Matrix{Float64})::Bool
    return !(y == z)
end

function Base.:≠(y::Matrix{Float64}, z::MMatrix)::Bool
    return !(y == z)
end

function Base.:≠(y::MArray, z::MArray)::Bool
    return !(y == z)
end

function Base.:≠(y::MArray, z::Array{Float64,3})::Bool
    return !(y == z)
end

function Base.:≠(y::Array{Float64,3}, z::MArray)::Bool
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

function Base.:≈(y::MVector, z::Vector{Float64})::Bool
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

function Base.:≈(y::Vector{Float64}, z::MVector)::Bool
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

function Base.:≈(y::MMatrix, z::Matrix{Float64})::Bool
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

function Base.:≈(y::Matrix{Float64}, z::MMatrix)::Bool
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
    if !isequal(y.pgs, z.pgs) || !isequal(y.rows, z.rows) || !isequal(y.cols, z.cols)
        return false
    end
    for i in 1:y.pgs
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

function Base.:≈(y::MArray, z::Array{Float64,3})::Bool
    (z_pgs, z_rows, z_cols) = size(z)
    if !isequal(y.pgs, z_pgs) || !isequal(y.rows, z_rows) || !isequal(y.cols, z_cols)
        return false
    end
    for i in 1:y.pgs
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

function Base.:≈(y::Array{Float64,3}, z::MArray)::Bool
    (y_pgs, y_rows, y_cols) = size(y)
    if !isequal(y_pgs, z.pgs) || !isequal(y_rows, z.rows) || !isequal(y_cols, z.cols)
        return false
    end
    for i in 1:y_pgs
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

function Base.:+(y::MVector)::Vector{Float64}
    vec = Vector{Float64}(undef, y.len)
    for i in 1:y.len
        vec[i] = +y[i]
    end
    return vec
end

function Base.:+(y::MMatrix)::Matrix{Float64}
    rows = y.rows
    cols = y.cols
    mtx  = Matrix{Float64}(undef, rows, cols)
    for i in 1:rows
        for j in 1:cols
            mtx[i,j] = +y[i,j]
        end
    end
    return mtx
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

function Base.:+(y::MVector, z::MVector)::Vector{Float64}
    if y.len ≠ z.len
        msg = "Vector addition requires vectors with the same length."
        throw(DimensionMismatch(msg))
    end
    vec = Vector{Float64}(undef, y.len)
    for i in 1:y.len
        vec[i] = y[i] + z[i]
    end
    return vec
end

function Base.:+(y::MVector, z::Vector{Float64})::Vector{Float64}
    if y.len ≠ length(z)
        msg = "Vector addition requires vectors with the same length."
        throw(DimensionMismatch(msg))
    end
    vec = Vector{Float64}(undef, y.len)
    for i in 1:y.len
        vec[i] = y[i] + z[i]
    end
    return vec
end

function Base.:+(y::Vector{Float64}, z::MVector)::Vector{Float64}
    if length(y) ≠ z.len
        msg = "Vector addition requires vectors with the same length."
        throw(DimensionMismatch(msg))
    end
    vec = Vector{Float64}(undef, z.len)
    for i in 1:z.len
        vec[i] = y[i] + z[i]
    end
    return vec
end

function Base.:+(y::MMatrix, z::MMatrix)::Matrix{Float64}
    if (y.rows ≠ z.rows) || (y.cols ≠ z.cols)
        msg = "Matrix addition requires matrices with the same dimensions."
        throw(DimensionMismatch(msg))
    end
    mtx = Matrix{Float64}(undef, y.rows, y.cols)
    for i in 1:y.rows
        for j in 1:y.cols
            mtx[i,j] = y[i,j] + z[i,j]
        end
    end
    return mtx
end

function Base.:+(y::MMatrix, z::Matrix{Float64})::Matrix{Float64}
    (z_rows, z_cols) = size(z)
    if (y.rows ≠ z_rows) || (y.cols ≠ z_cols)
        msg = "Matrix addition requires matrices with the same dimensions."
        throw(DimensionMismatch(msg))
    end
    mtx  = Matrix{Float64}(undef, y.rows, y.cols)
    for i in 1:y.rows
        for j in 1:y.cols
            mtx[i,j] = y[i,j] + z[i,j]
        end
    end
    return mtx
end

function Base.:+(y::Matrix{Float64}, z::MMatrix)::Matrix{Float64}
    (y_rows, y_cols) = size(y)
    if (y_rows ≠ z.rows) || (y_cols ≠ z.cols)
        msg = "Matrix addition requires matrices with the same dimensions."
        throw(DimensionMismatch(msg))
    end
    mtx  = Matrix{Float64}(undef, z.rows, z.cols)
    for i in 1:z.rows
        for j in 1:z.cols
            mtx[i,j] = y[i,j] + z[i,j]
        end
    end
    return mtx
end

# Unary operator -

function Base.:-(y::MInteger)::Integer
    return -y.n
end

function Base.:-(y::MReal)::Real
    return -y.n
end

function Base.:-(y::MVector)::Vector{Float64}
    vec = Vector{Float64}(undef, y.len)
    for i in 1:y.len
        vec[i] = -y[i]
    end
    return vec
end

function Base.:-(y::MMatrix)::Matrix{Float64}
    mtx  = Matrix{Float64}(undef, y.rows, y.cols)
    for i in 1:y.rows
        for j in 1:y.cols
            mtx[i,j] = -y[i,j]
        end
    end
    return mtx
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

function Base.:-(y::MVector, z::MVector)::Vector{Float64}
    if y.len ≠ z.len
        msg = "Vector subtraction requires vectors with the same length."
        throw(DimensionMismatch(msg))
    end
    vec = Vector{Float64}(undef, y.len)
    for i in 1:y.len
        vec[i] = y[i] - z[i]
    end
    return vec
end

function Base.:-(y::MVector, z::Vector{Float64})::Vector{Float64}
    if y.len ≠ length(z)
        msg = "Vector subtraction requires vectors with the same length."
        throw(DimensionMismatch(msg))
    end
    vec = Vector{Float64}(undef, y.len)
    for i in 1:y.len
        vec[i] = y[i] - z[i]
    end
    return vec
end

function Base.:-(y::Vector{Float64}, z::MVector)::Vector{Float64}
    if length(y) ≠ z.len
        msg = "Vector subtraction requires vectors with the same length."
        throw(DimensionMismatch(msg))
    end
    vec = Vector{Float64}(undef, z.len)
    for i in 1:z.len
        vec[i] = y[i] - z[i]
    end
    return vec
end

function Base.:-(y::MMatrix, z::MMatrix)::Matrix{Float64}
    if (y.rows ≠ z.rows) || (y.cols ≠ z.cols)
        msg = "Matrix subtraction requires matrices with the same dimensions."
        throw(DimensionMismatch(msg))
    end
    mtx  = Matrix{Float64}(undef, y.rows, y.cols)
    for i in 1:y.rows
        for j in 1:y.cols
            mtx[i,j] = y[i,j] - z[i,j]
        end
    end
    return mtx
end

function Base.:-(y::MMatrix, z::Matrix{Float64})::Matrix{Float64}
    (z_rows, z_cols) = size(z)
    if (y.rows ≠ z_rows) || (y.cols ≠ z_cols)
        msg = "Matrix subtraction requires matrices with the same dimensions."
        throw(DimensionMismatch(msg))
    end
    mtx  = Matrix{Float64}(undef, y.rows, y.cols)
    for i in 1:y.rows
        for j in 1:y.cols
            mtx[i,j] = y[i,j] - z[i,j]
        end
    end
    return mtx
end

function Base.:-(y::Matrix{Float64}, z::MMatrix)::Matrix{Float64}
    (y_rows, y_cols) = size(y)
    if (y_rows ≠ z.rows) || (y_cols ≠ z.cols)
        msg = "Matrix subtraction requires matrices with the same dimensions."
        throw(DimensionMismatch(msg))
    end
    mtx  = Matrix{Float64}(undef, z.rows, z.cols)
    for i in 1:z.rows
        for j in 1:z.cols
            mtx[i,j] = y[i,j] - z[i,j]
        end
    end
    return mtx
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

function Base.:*(y::Real, z::MVector)::Vector{Float64}
    vec = Vector{Float64}(undef, z.len)
    for i in 1:z.len
        vec[i] = y * z[i]
    end
    return vec
end

function Base.:*(y::MNumber, z::MVector)::Vector{Float64}
    vec = Vector{Float64}(undef, z.len)
    for i in 1:z.len
        vec[i] = y.n * z[i]
    end
    return vec
end

function Base.:*(y::MNumber, z::Vector{Float64})::Vector{Float64}
    vec = Vector{Float64}(undef, length(z))
    for i in 1:length(z)
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

function Base.:*(y::MVector, z::Vector{Float64})::Real
    if y.len ≠ length(z)
        msg = "An inner product requires the vectors have the same length."
        throw(DimensionMismatch(msg))
    end
    dotProduct = LinearAlgebra.dot(y.vec, z)
    return dotProduct
end

function Base.:*(y::Vector{Float64}, z::MVector)::Real
    if length(y) ≠ z.len
        msg = "An inner product requires the vectors have the same length."
        throw(DimensionMismatch(msg))
    end
    dotProduct = LinearAlgebra.dot(y, z.vec)
    return dotProduct
end

function Base.:*(y::Real, z::MMatrix)::Matrix{Float64}
    mtx  = Matrix{Float64}(undef, z.rows, z.cols)
    for i in 1:z.rows
        for j in 1:z.cols
            mtx[i,j] = y * z[i,j]
        end
    end
    return mtx
end

function Base.:*(y::MNumber, z::MMatrix)::Matrix{Float64}
    mtx  = Matrix{Float64}(undef, z.rows, z.cols)
    for i in 1:z.rows
        for j in 1:z.cols
            mtx[i,j] = y.n * z[i,j]
        end
    end
    return mtx
end

function Base.:*(y::MNumber, z::Matrix{Float64})::Matrix{Float64}
    (rows, cols) = size(z)
    mtx  = Matrix{Float64}(undef, rows, cols)
    for i in 1:rows
        for j in 1:cols
            mtx[i,j] = y.n * z[i,j]
        end
    end
    return mtx
end

function Base.:*(y::MMatrix, z::MVector)::Vector{Float64}
    if y.cols ≠ z.len
        msg = "Dimensions are not applicable for matrix multiplication."
        throw(DimensionMismatch(msg))
    end
    vec = Vector{Float64}(undef, y.rows)
    for i in 1:y.rows
        sum = 0.0
        for j in 1:y.cols
            sum += y[i,j] * z[j]
        end
        vec[i] = sum
    end
    return vec
end

function Base.:*(y::MMatrix, z::Vector{Float64})::Vector{Float64}
    if y.cols ≠ length(z)
        msg = "Dimensions are not applicable for matrix multiplication."
        throw(DimensionMismatch(msg))
    end
    vec = Vector{Float64}(undef, y.rows)
    for i in 1:y.rows
        sum = 0.0
        for j in 1:y.cols
            sum += y[i,j] * z[j]
        end
        vec[i] = sum
    end
    return vec
end

function Base.:*(y::Matrix{Float64}, z::MVector)::Vector{Float64}
    (rows, cols) = size(y)
    if cols ≠ z.len
        msg = "Dimensions are not applicable for matrix multiplication."
        throw(DimensionMismatch(msg))
    end
    vec = Vector{Float64}(undef, rows)
    for i in 1:rows
        sum = 0.0
        for j in 1:cols
            sum += y[i,j] * z[j]
        end
        vec[i] = sum
    end
    return vec
end

function Base.:*(y::MMatrix, z::MMatrix)::Matrix{Float64}
    if y.cols ≠ z.rows
        msg = "Dimensions are not applicable for matrix multiplication."
        throw(DimensionMismatch(msg))
    end
    mtx  = Matrix{Float64}(undef, y.rows, z.cols)
    for i in 1:y.rows
        for j in 1:z.cols
            sum = 0.0
            for k in 1:y.cols
                sum += y[i,k] * z[k,j]
            end
            mtx[i,j] = sum
        end
    end
    return mtx
end

function Base.:*(y::Matrix{Float64}, z::MMatrix)::Matrix{Float64}
    (y_rows, y_cols) = size(y)
    if y_cols ≠ z.rows
        msg = "Dimensions are not applicable for matrix multiplication."
        throw(DimensionMismatch(msg))
    end
    mtx  = Matrix{Float64}(undef, y_rows, z.cols)
    for i in 1:y_rows
        for j in 1:z.cols
            sum = 0.0
            for k in 1:y_cols
                sum += y[i,k] * z[k,j]
            end
            mtx[i,j] = sum
        end
    end
    return mtx
end

function Base.:*(y::MMatrix, z::Matrix{Float64})::Matrix{Float64}
    (z_rows, z_cols) = size(z)
    if y.cols ≠ z_rows
        msg = "Dimensions are not applicable for matrix multiplication."
        throw(DimensionMismatch(msg))
    end
    mtx  = Matrix{Float64}(undef, y.rows, z_cols)
    for i in 1:y.rows
        for j in 1:z_cols
            sum = 0.0
            for k in 1:y.cols
                sum += y[i,k] * z[k,j]
            end
            mtx[i,j] = sum
        end
    end
    return mtx
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

function Base.:/(y::MVector, z::Real)::Vector{Float64}
    vec = Vector{Float64}(undef, y.len)
    for i in 1:y.len
        vec[i] = y[i] / z
    end
    return vec
end

function Base.:/(y::MVector, z::MNumber)::Vector{Float64}
    vec = Vector{Float64}(undef, y.len)
    for i in 1:y.len
        vec[i] = y[i] / z.n
    end
    return vec
end

function Base.:/(y::Vector{Float64}, z::MNumber)::Vector{Float64}
    vec = Vector{Float64}(undef, length(y))
    for i in 1:length(y)
        vec[i] = y[i] / z.n
    end
    return vec
end

function Base.:/(y::MMatrix, z::Real)::Matrix{Float64}
    mtx  = Matrix{Float64}(undef, y.rows, y.cols)
    for i in 1:y.rows
        for j in 1:y.cols
            mtx[i,j] = y[i,j] / z
        end
    end
    return mtx
end

function Base.:/(y::MMatrix, z::MNumber)::Matrix{Float64}
    mtx  = Matrix{Float64}(undef, y.rows, y.cols)
    for i in 1:y.rows
        for j in 1:y.cols
            mtx[i,j] = y[i,j] / z.n
        end
    end
    return mtx
end

function Base.:/(y::Matrix{Float64}, z::MNumber)::Matrix{Float64}
    (rows, cols) = size(y)
    mtx  = Matrix{Float64}(undef, rows, cols)
    for i in 1:rows
        for j in 1:cols
            mtx[i,j] = y[i,j] / z.n
        end
    end
    return mtx
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

function Base.:\(A::MMatrix, b::MVector)::Vector{Float64}
    if A.rows ≠ b.len
        msg = "Solving the linear system of equations 'Ax=b' for vector 'x'\n"
        msg *= "requires the rows in matrix 'A' equal the length of vector 'b'."
        throw(DimensionMismatch(msg))
    end
    vec = Vector(b)
    mtx = Matrix(A)
    x   = mtx \ vec
    return x
end

function Base.:\(A::MMatrix, b::Vector{Float64})::Vector{Float64}
    if A.rows ≠ length(b)
        msg = "Solving the linear system of equations 'Ax=b' for vector 'x'\n"
        msg *= "requires the rows in matrix 'A' equal the length of vector 'b'."
        throw(DimensionMismatch(msg))
    end
    vec = copy(b)
    mtx = Matrix(A)
    x   = mtx \ vec
    return x
end

function Base.:\(A::Matrix{Float64}, b::MVector)::Vector{Float64}
    if A.rows ≠ b.len
        msg = "Solving the linear system of equations 'Ax=b' for vector 'x'\n"
        msg *= "requires the rows in matrix 'A' equal the length of vector 'b'."
        throw(DimensionMismatch(msg))
    end
    vec = Vector(b)
    mtx = Matrix(A)
    x   = mtx \ vec
    return x
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

# Functions for both mutable number types.

function Base.:(abs)(y::MNumber)::Real
    return abs(y.n)
end

function Base.:(sign)(y::MNumber)::Real
    return sign(y.n)
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
    return sqrt(y.n)
end

# Functions for vectors.

function LinearAlgebra.:(norm)(y::MVector, p::Real=2)::Real
    return LinearAlgebra.norm(y.vec, p)
end

function unitVector(y::MVector)::Vector{Float64}
    unitVec = y / norm(y)
    return unitVec
end

function unitVector(y::Vector{Float64})::Vector{Float64}
    unitVec = y / norm(y)
    return unitVec
end

function LinearAlgebra.:(cross)(y::MVector, z::MVector)::Vector{Float64}
    if (y.len ≠ 3) || (z.len ≠ 3)
        msg = "Vector cross product is only defined for 3 dimensional vectors."
        throw(DimensionMismatch(msg))
    end
    return LinearAlgebra.cross(y.vec, z.vec)
end

function LinearAlgebra.:(cross)(y::Vector{Float64}, z::MVector)::Vector{Float64}
    if (length(y) ≠ 3) || (z.len ≠ 3)
        msg = "Vector cross product is only defined for 3 dimensional vectors."
        throw(DimensionMismatch(msg))
    end
    return LinearAlgebra.cross(y, z.vec)
end

function LinearAlgebra.:(cross)(y::MVector, z::Vector{Float64})::Vector{Float64}
    if (y.len ≠ 3) || (length(z) ≠ 3)
        msg = "Vector cross product is only defined for 3 dimensional vectors."
        throw(DimensionMismatch(msg))
    end
    return LinearAlgebra.cross(y.vec, z)
end

# Functions for matrices.

function LinearAlgebra.:(norm)(y::MMatrix, p::Real=2)::Real
    mtx = Matrix(y)
    return LinearAlgebra.norm(mtx, p)
end

function Base.:(transpose)(y::MMatrix)::Matrix{Float64}
    mtx = Matrix(y)
    return Base.transpose(mtx)
end

function LinearAlgebra.:(tr)(y::MMatrix)::Real
    mtx = Matrix(y)
    return LinearAlgebra.tr(mtx)
end

function LinearAlgebra.:(det)(y::MMatrix)::Real
    mtx = Matrix(y)
    return LinearAlgebra.det(mtx)
end

function Base.:(inv)(y::MMatrix)::Matrix{Float64}
    mtx = Matrix(y)
    return Base.inv(mtx)
end

function qr(y::Matrix{Float64})::Tuple  # (Q, R) as instances of Matrix
    F = LinearAlgebra.qr(y)
    Q, R = F
    # Unpack Q and R.
    (rows, cols) = size(Q)
    q = Matrix{Float64}(undef, rows, cols)
    for i in 1:rows
        for j in 1:cols
            q[i,j] = Q[i,j]
        end
    end
    (rows, cols) = size(R)
    r = Matrix{Float64}(undef, rows, cols)
    for i in 1:rows
        for j in 1:cols
            r[i,j] = R[i,j]
        end
    end
    # Return the unpacked qr matrices.
    return (q, r)
end

function qr(y::MMatrix)::Tuple  # (Q, R) as instances of Matrix
    mtx = Matrix(y)
    return qr(mtx)
end

function lq(y::Matrix{Float64})::Tuple  # (L, Q) as instances of Matrix
    S = LinearAlgebra.lq(y)
    L, Q = S
    # Unpack L and Q.
    (rows, cols) = size(L)
    l = Matrix{Float64}(undef, rows, cols)
    for i in 1:rows
        for j in 1:cols
            l[i,j] = L[i,j]
        end
    end
    (rows, cols) = size(Q)
    q = Matrix{Float64}(undef, rows, cols)
    for i in 1:rows
        for j in 1:cols
            q[i,j] = Q[i,j]
        end
    end
    # Return the unpacked lq matrices.
    return (l, q)
end

function lq(y::MMatrix)::Tuple  # (L, Q) as instances of Matrix
    mtx = Matrix(y)
    return lq(mtx)
end

function matrixProduct(y::Vector{Float64}, z::Vector{Float64})::Matrix{Float64}
    rows = length(y)
    cols = length(z)
    mtx  = Matrix{Float64}(undef, rows, cols)
    for i in 1:rows
        for j in 1:cols
            mtx[i,j] = y[i] * z[j]
        end
    end
    return mtx
end

function matrixProduct(y::MVector, z::MVector)::Matrix{Float64}
    rows = y.len
    cols = z.len
    mtx  = Matrix{Float64}(undef, rows, cols)
    for i in 1:rows
        for j in 1:cols
            mtx[i,j] = y[i] * z[j]
        end
    end
    return mtx
end

function matrixProduct(y::Vector{Float64}, z::MVector)::Matrix{Float64}
    rows = length(y)
    cols = z.len
    mtx  = Matrix{Float64}(undef, rows, cols)
    for i in 1:rows
        for j in 1:cols
            mtx[i,j] = y[i] * z[j]
        end
    end
    return mtx
end

function matrixProduct(y::MVector, z::Vector{Float64})::Matrix{Float64}
    rows = y.len
    cols = length(z)
    mtx  = Matrix{Float64}(undef, rows, cols)
    for i in 1:rows
        for j in 1:cols
            mtx[i,j] = y[i] * z[j]
        end
    end
    return mtx
end

# end MutableTypes