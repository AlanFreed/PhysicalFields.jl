# PhysicalTypes

# exported types

abstract type PhysicalField end

struct PhysicalScalar <: PhysicalField
    value::MReal            # value of a scalar in its specified system of units
    units::PhysicalUnits    # physical units of the scalar

    # constructors

    function PhysicalScalar(units::PhysicalUnits)
        new(MReal(), units)
    end

    function PhysicalScalar(value::Real, units::PhysicalUnits)
        if value isa MReal
            new(value, units)
        elseif value isa Real
            new(MReal(value), units)
        else
            new(MReal(convert(Float64, value)), units)
        end
    end
end

struct PhysicalVector <: PhysicalField
    vector::MVector         # values of a vector in its specified system of units
    units::PhysicalUnits    # physical units of the vector

    # constructors

    function PhysicalVector(length::Integer, units::PhysicalUnits)
        new(MVector(length), units)
    end

    function PhysicalVector(vector::Vector{<:Real}, units::PhysicalUnits)
        new(MVector(vector), units)
    end

    function PhysicalVector(vector::MVector, units::PhysicalUnits)
        new(vector, units)
    end
end

struct PhysicalTensor <: PhysicalField
    matrix::MMatrix         # values of a tensor in its specified system of units
    units::PhysicalUnits    # physical units of the tensor

    # constructors

    function PhysicalTensor(rows::Integer, columns::Integer, units::PhysicalUnits)
        new(MMatrix(rows, columns), units)
    end

    function PhysicalTensor(matrix::Matrix{<:Real}, units::PhysicalUnits)
        new(MMatrix(matrix), units)
    end

    function PhysicalTensor(matrix::MMatrix, units::PhysicalUnits)
        new(matrix, units)
    end
end

struct ArrayOfPhysicalScalars
    array::MVector          # array holding values of a physical scalar
    units::PhysicalUnits    # physical units of the scalar array

    # constructors

    function ArrayOfPhysicalScalars(array_length::Integer, units::PhysicalUnits)
        new(MVector(array_length), units)
    end

    function ArrayOfPhysicalScalars(scalar_values::Vector{<:Real}, units::PhysicalUnits)
        new(MVector(scalar_values), units)
    end

    function ArrayOfPhysicalScalars(scalar_values::MVector, units::PhysicalUnits)
        new(scalar_values, units)
    end
end

struct ArrayOfPhysicalVectors
    array::MMatrix          # array of vectors holding values of a physical vector
    units::PhysicalUnits    # physical units of the vector array

    # constructors

    function ArrayOfPhysicalVectors(array_length::Integer, vector_length::Integer, units::PhysicalUnits)
        new(MMatrix(array_length, vector_length), units)
    end

    function ArrayOfPhysicalVectors(array::Matrix{<:Real}, units::PhysicalUnits)
        new(MMatrix(array), units)
    end

    function ArrayOfPhysicalVectors(array::MMatrix, units::PhysicalUnits)
        new(array, units)
    end
end

struct ArrayOfPhysicalTensors
    array::MArray           # array of matrices holding values of a physical tensor
    units::PhysicalUnits    # physical units of the tensor array

    # constructors

    function ArrayOfPhysicalTensors(array_length::Integer, tensor_rows::Integer, tensor_columns::Integer, units::PhysicalUnits)
        new(MArray(array_length, tensor_rows, tensor_columns), units)
    end

    function ArrayOfPhysicalTensors(array::Array{<:Real,3}, units::PhysicalUnits)
        new(MArray(array), units)
    end

    function ArrayOfPhysicalTensors(array::MArray, units::PhysicalUnits)
        new(array, units)
    end
end

#=
-------------------------------------------------------------------------------
=#

# Define the get and set! functions to retrieve and assign values.

function Base.:(get)(y::PhysicalScalar)::Real
    return get(y.value)
end

function set!(y::PhysicalScalar, value::Real)
    set!(y.value, value)
    return nothing
end

function Base.:(getindex)(y::PhysicalVector, index::Integer)::PhysicalScalar
    if index < 1 || index > y.vector.len
        msg = string("Admissible vector indices are ∈ [1…", y.vector.len, "].")
        throw(ErrorException(msg))
    end
    return PhysicalScalar(y.vector[index], y.units)
end

function Base.:(setindex!)(y::PhysicalVector, scalar::PhysicalScalar, index::Integer)
    if index < 1 || index > y.vector.len
        msg = string("Admissible vector indices are ∈ [1…", y.vector.len, "].")
        throw(ErrorException(msg))
    end
    if y.units == scalar.units
        y.vector[index] = get(scalar)
    else
        msg = string("The units of the sent scalar, ", toString(scalar.units))
        msg *= string(", differ from those of the vector, ", toString(y.units))
        msg *= ", in an [] assignment to this physical vector."
        throw(ErrorException(msg))
    end
    return nothing
end

function Base.:(getindex)(y::PhysicalTensor, row::Integer, column::Integer)::PhysicalScalar
    if (row < 1 || row > y.matrix.rows ||
        column < 1 || column > y.matrix.cols)
        msg = string("Admissible tensor indices are ∈ [1…", string(y.matrix.rows), ", 1…", string(y.matrix.cols), "].")
        throw(ErrorException(msg))
    end
    return PhysicalScalar(y.matrix[row,column], y.units)
end

function Base.:(setindex!)(y::PhysicalTensor, scalar::PhysicalScalar, row::Integer, column::Integer)
    if (row < 1 || row > y.matrix.rows ||
        column < 1 || column > y.matrix.cols)
        msg = string("Admissible tensor indices are ∈ [1…", string(y.matrix.rows), ", 1…", string(y.matrix.cols), "].")
        throw(ErrorException(msg))
    end
    if y.units == scalar.units
        y.matrix[row,column] = get(scalar)
    else
        msg = string("The units of the sent scalar, ", toString(scalar.units))
        msg *= string(", differ from those of the tensor, ", toString(y.units))
        msg *= ", in an [] assignment to this physical tensor."
        throw(ErrorException(msg))
    end
    return nothing
end

function Base.:(getindex)(y::ArrayOfPhysicalScalars, index::Integer)::PhysicalScalar
    if index < 1 || index > y.array.len
        msg = string("Admissible array indices are ∈ [1…", string(y.array.len), "].")
        throw(ErrorException(msg))
    end
    return PhysicalScalar(y.array[index], y.units)
end

function Base.:(setindex!)(y::ArrayOfPhysicalScalars, scalar::PhysicalScalar, index::Integer)
    if index < 1 || index > y.array.len
        msg = string("Admissible array indices are ∈ [1…", string(y.array.len), "].")
        throw(ErrorException(msg))
    end
    if scalar.units == y.units
        y.array[index] = get(scalar)
    else
        msg = string("The units of the sent scalar, ", toString(scalar.units))
        msg *= string(", differ from those of the array, ", toString(y.units))
        msg *= ", in a set [] assignment to this array of physical scalars."
        throw(ErrorException(msg))
    end
    return nothing
end

function Base.:(getindex)(y::ArrayOfPhysicalVectors, index::Integer)::PhysicalVector
    if index < 1 || index > y.array.rows
        msg = string("Admissible row indices are ∈ [1…", string(y.array.rows), "].")
        throw(ErrorException(msg))
    end
    vector = PhysicalVector(y.array.cols, y.units)
    for i in 1:y.array.cols
        vector[i] = PhysicalScalar(y.array[index,i], y.units)
    end
    return vector
end

function Base.:(setindex!)(y::ArrayOfPhysicalVectors, vector::PhysicalVector, index::Integer)
    if index < 1 || index > y.array.rows
        msg = string("Admissible row indices are ∈ [1…", string(y.array.rows), "].")
        throw(ErrorException(msg))
    end
    if y.array.cols ≠ vector.vector.len
        msg = string("The reassigning/setting vector has the wrong length.")
        throw(ErrorException(msg))
    end
    if y.units == vector.units
        for i in 1:y.array.cols
            y.array[index,i] = get(vector[i])
        end
    else
        msg = string("The units of the sent vector, ", toString(vector.units))
        msg *= string(", differ from those of the array, ", toString(y.units))
        msg *= ", in a set [] assignment to this array of physical vectors."
        throw(ErrorException(msg))
    end
    return nothing
end

function Base.:(getindex)(y::ArrayOfPhysicalTensors, index::Integer)::PhysicalTensor
    if index < 1 || index > y.array.pp
        msg = string("Admissible page indices are ∈ [1…", string(y.array.pp), "].")
        throw(ErrorException(msg))
    end
    matrix = PhysicalTensor(y.array.rows, y.array.cols, y.units)
    for i in 1:y.array.rows
        for j in 1:y.array.cols
            matrix[i,j] = PhysicalScalar(y.array[index,i,j], y.units)
        end
    end
    return matrix
end

function Base.:(setindex!)(y::ArrayOfPhysicalTensors, tensor::PhysicalTensor, index::Integer)
    if index < 1 || index > y.array.pp
        msg = string("Admissible page indices are ∈ [1…", string(y.array.pp), "].")
        throw(ErrorException(msg))
    end
    if (y.array.rows ≠ tensor.matrix.rows || 
        y.array.cols ≠ tensor.matrix.cols)
        msg = string("The reassigning/setting tensor has the wrong dimensions.")
        throw(ErrorException(msg))
    end
    if y.units == tensor.units
        for i in 1:y.array.rows
            for j in 1:y.array.cols
                y.array[index,i,j] = get(tensor[i,j])
            end
        end
    else
        msg = string("The units of the sent tensor, ", toString(tensor.units))
        msg *= string(", differ from those of the array, ", toString(y.units))
        msg *= ", in a set [] assignment to this array of physical tensors."
        throw(ErrorException(msg))
    end
    return nothing
end

#=
-------------------------------------------------------------------------------
=#

# String conversion for the three basic types of physical fields.

function toString(y::PhysicalScalar)::String
    s = toString(y.value)
    if !isDimensionless(y.units)
        s *= string(' ', toString(y.units))
    end
    return s
end

function toString(v::PhysicalVector)::String
    s = toString(v.vector)
    if !isDimensionless(v.units)
        s *= string(' ', toString(v.units))
    end
    return s
end

# Extra formatting is needed to convert a tensor into a string.

function toString(t::PhysicalTensor)::String
    (m_rows, m_cols) = size(t.matrix)
    # Determine the number of rows and columns to print out.
    chars = 0
    for row in 1:m_rows
        for col in 1:m_cols
            chars = max(chars, length(toString(t.matrix[row,col];aligned=true)))
        end
    end
    cols = min(m_cols, 70÷(chars+1))
    rows = min(m_rows, 36)
    half_chars = chars ÷ 2
    extra_char = chars % 2
    unitsInRow = 1 + rows ÷ 2
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
                s *= toString(t.matrix[i,j];aligned=true,digits=chars)
                s *= ' '
            end
            if m_cols > cols
                s *= " ⋯ "
            else
                s *= toString(t.matrix[i,cols-1];aligned=true,digits=chars)
                s *= ' '
            end
            s *= toString(t.matrix[i,m_cols];aligned=true,digits=chars)
        end
        if i == 1
            s *= '⌉'
        elseif i < rows
            s *= '|'
        else
            s *= '⌋'
        end
        if i == unitsInRow
            if !isDimensionless(t.units)
                s *= string(' ', toString(t.units))
            end
        end
        if i < rows
            s *= "\n"
        end
    end
    return s
end

#=
-------------------------------------------------------------------------------
=#

# Reading from and writing to a JSON file.
StructTypes.StructType(::Type{PhysicalScalar}) = StructTypes.Struct()
StructTypes.StructType(::Type{PhysicalVector}) = StructTypes.Struct()
StructTypes.StructType(::Type{PhysicalTensor}) = StructTypes.Struct()

StructTypes.StructType(::Type{ArrayOfPhysicalScalars}) = StructTypes.Struct()
StructTypes.StructType(::Type{ArrayOfPhysicalVectors}) = StructTypes.Struct()
StructTypes.StructType(::Type{ArrayOfPhysicalTensors}) = StructTypes.Struct()

function toFile(y::PhysicalScalar, json_stream::IOStream)
    if isopen(json_stream)
        JSON3.write(json_stream, y)
        write(json_stream, '\n')
    else
        error("The supplied JSON stream is not open.")
    end
    flush(json_stream)
    return nothing
end

function toFile(y::PhysicalVector, json_stream::IOStream)
    if isopen(json_stream)
        JSON3.write(json_stream, y)
        write(json_stream, '\n')
    else
        error("The supplied JSON stream is not open.")
    end
    flush(json_stream)
    return nothing
end

function toFile(y::PhysicalTensor, json_stream::IOStream)
    if isopen(json_stream)
        JSON3.write(json_stream, y)
        write(json_stream, '\n')
    else
        error("The supplied JSON stream is not open.")
    end
    flush(json_stream)
    return nothing
end

function toFile(y::ArrayOfPhysicalScalars, json_stream::IOStream)
    if isopen(json_stream)
        JSON3.write(json_stream, y)
        write(json_stream, '\n')
    else
        error("The supplied JSON stream is not open.")
    end
    flush(json_stream)
    return nothing
end

function toFile(y::ArrayOfPhysicalVectors, json_stream::IOStream)
    if isopen(json_stream)
        JSON3.write(json_stream, y)
        write(json_stream, '\n')
    else
        error("The supplied JSON stream is not open.")
    end
    flush(json_stream)
    return nothing
end

function toFile(y::ArrayOfPhysicalTensors, json_stream::IOStream)
    if isopen(json_stream)
        JSON3.write(json_stream, y)
        write(json_stream, '\n')
    else
        error("The supplied JSON stream is not open.")
    end
    flush(json_stream)
    return nothing
end

function fromFile(::Type{PhysicalScalar}, json_stream::IOStream)::PhysicalScalar
    if isopen(json_stream)
        ps = JSON3.read(readline(json_stream), PhysicalScalar)
    else
        error("The supplied JSON stream is not open.")
    end
    return ps
end

function fromFile(::Type{PhysicalVector}, json_stream::IOStream)::PhysicalVector
    if isopen(json_stream)
        pv = JSON3.read(readline(json_stream), PhysicalVector)
    else
        error("The supplied JSON stream is not open.")
    end
    return pv
end

function fromFile(::Type{PhysicalTensor}, json_stream::IOStream)::PhysicalTensor
    if isopen(json_stream)
        pt = JSON3.read(readline(json_stream), PhysicalTensor)
    else
        error("The supplied JSON stream is not open.")
    end
    return pt
end

function fromFile(::Type{ArrayOfPhysicalScalars}, json_stream::IOStream)::ArrayOfPhysicalScalars
    if isopen(json_stream)
        aps = JSON3.read(readline(json_stream), ArrayOfPhysicalScalars)
    else
        error("The supplied JSON stream is not open.")
    end
    return aps
end

function fromFile(::Type{ArrayOfPhysicalVectors}, json_stream::IOStream)::ArrayOfPhysicalVectors
    if isopen(json_stream)
        apv = JSON3.read(readline(json_stream), ArrayOfPhysicalVectors)
    else
        error("The supplied JSON stream is not open.")
    end
    return apv
end

function fromFile(::Type{ArrayOfPhysicalTensors}, json_stream::IOStream)::ArrayOfPhysicalTensors
    if isopen(json_stream)
        apt = JSON3.read(readline(json_stream), ArrayOfPhysicalTensors)
    else
        error("The supplied JSON stream is not open.")
    end
    return apt
end

