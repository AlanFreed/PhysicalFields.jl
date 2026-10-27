# PhysicalTypes

# exported types

abstract type PhysicalField end

abstract type ArrayOfPhysicalFields end

struct PhysicalScalar <: PhysicalField
    value::MReal            # value of scalar in its specified system of units
    units::PhysicalUnits    # physical units of the scalar

    # constructors

    function PhysicalScalar(units::PhysicalUnits)
        new(MReal(), units)
    end

    function PhysicalScalar(value::Real, units::PhysicalUnits)
        new(MReal(value), units)
    end

    function PhysicalScalar(value::MReal, units::PhysicalUnits)
        new(value, units)
    end
end

struct PhysicalVector <: PhysicalField
    vector::MVector         # values of vector in its specified system of units
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
    matrix::MMatrix         # values of tensor in its specified system of units
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

struct ArrayOfPhysicalScalars <: ArrayOfPhysicalFields
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

struct ArrayOfPhysicalVectors <: ArrayOfPhysicalFields
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

struct ArrayOfPhysicalTensors <: ArrayOfPhysicalFields
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

struct VectorOfPhysicalScalars <: ArrayOfPhysicalFields
    values::MVector                 # vector of physical values
    units::VectorOfPhysicalUnits    # vector of physical units
    
    # constructors
    
    function VectorOfPhysicalScalars(length::Integer)
        values = MVector(length)
        units  = VectorOfPhysicalUnits(length)
        
        new(values, units)
    end
    
    function VectorOfPhysicalScalars(values::MVector, units::VectorOfPhysicalUnits)
        if values.len ≠ units.len
            error("Vector dimensions for 'values' and 'units' are not equivalent.")
        end
        
        new(values, units)
    end
    
    function VectorOfPhysicalScalars(values::Vector{<:Real}, units::VectorOfPhysicalUnits)
        if length(values) ≠ units.len
            error("Vector dimensions for 'values' and 'units' are not equivalent.")
        end
        vecValues = MVector(values)
        
        new(vecValues, units)
    end
end

struct MatrixOfPhysicalScalars <: ArrayOfPhysicalFields
    values::MMatrix                 # matrix of physical values
    units::MatrixOfPhysicalUnits    # matrix of physical units
    
    # constructors
    
    function MatrixOfPhysicalScalars(rows::Integer, columns::Integer)
        values = MMatrix(rows, columns)
        units  = MatrixOfPhysicalUnits(rows, columns)
        
        new(values, units)
    end
    
    function MatrixOfPhysicalScalars(values::MMatrix, units::MatrixOfPhysicalUnits)
        if values.rows ≠ units.rows || values.cols ≠ units.cols
            error("Matrix dimensions for 'values' and 'units' are not equivalent.")
        end
        
        new(values, units)
    end
    
    function MatrixOfPhysicalScalars(values::Matrix{<:Real}, units::MatrixOfPhysicalUnits)
        (rows, columns) = size(values)
        if rows ≠ units.rows || columns ≠ units.cols
            error("Matrix dimensions for 'values' and 'units' are not equivalent.")
        end
        mtxValues = MMatrix(values)
        
        new(mtxValues, units)
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

function Base.:(getindex)(y::VectorOfPhysicalScalars, index::Integer)::PhysicalScalar
    if index < 1 || index > y.values.len
        error("Admissible vector indices are ∈ [1…" + string(y.values.len) + "].")
    end
    
    return PhysicalScalar(y.values[index], y.units[index])
end

function Base.:(setindex!)(y::VectorOfPhysicalScalars, scalar::PhysicalScalar, index::Integer)
    if index < 1 || index > y.values.len
        error("Admissible vector indices are ∈ [1…" + string(y.values.len) + "].")
    end
    
    y.values[index] = scalar.value
    y.units[index]  = scalar.units
    
    return nothing
end

function Base.:(getindex)(y::MatrixOfPhysicalScalars, 
                          row::Integer, column::Integer)::PhysicalScalar
    if (row < 1 || row > y.values.rows || column < 1 || column > y.values.cols)
        msg = "Admissible matrix indices are ∈ [1…" + string(y.values.rows)
        msg = msg + ", 1…" + string(y.values.cols) + "]."
        error(msg)
    end
    
    return PhysicalScalar(y.values[row,column], y.units[row,column])
end

function Base.:(setindex!)(y::MatrixOfPhysicalScalars, scalar::PhysicalScalar, 
                           row::Integer, column::Integer)
    if (row < 1 || row > y.values.rows || column < 1 || column > y.values.cols)
        msg = "Admissible matrix indices are ∈ [1…" + string(y.values.rows)
        msg = msg + ", 1…" + string(y.values.cols) + "]."
        error(msg)
    end
    
    y.values[row, column] = scalar.value
    y.units[row, column]  = scalar.units
    
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

function toFile(y::PhysicalScalar, json_stream::IOStream)
    if isopen(json_stream)
        (path, dotType) = splitext(string(typeof(y)))
        type = ""
        for i in 2:length(dotType)
            type = string(type, dotType[i])
        end
        toFile(type, json_stream)
        toFile(y.value, json_stream)
        toFile(y.units, json_stream)
    else
        error("The supplied JSON stream is not open.")
    end
    return nothing
end

function toFile(y::PhysicalVector, json_stream::IOStream)
    if isopen(json_stream)
        (path, dotType) = splitext(string(typeof(y)))
        type = ""
        for i in 2:length(dotType)
            type = string(type, dotType[i])
        end
        toFile(type, json_stream)
        toFile(y.vector, json_stream)
        toFile(y.units, json_stream)
    else
        error("The supplied JSON stream is not open.")
    end
    return nothing
end

function toFile(y::PhysicalTensor, json_stream::IOStream)
    if isopen(json_stream)
        (path, dotType) = splitext(string(typeof(y)))
        type = ""
        for i in 2:length(dotType)
            type = string(type, dotType[i])
        end
        toFile(type, json_stream)
        toFile(y.matrix, json_stream)
        toFile(y.units, json_stream)
    else
        error("The supplied JSON stream is not open.")
    end
    return nothing
end

function toFile(y::ArrayOfPhysicalScalars, json_stream::IOStream)
    if isopen(json_stream)
        (path, dotType) = splitext(string(typeof(y)))
        type = ""
        for i in 2:length(dotType)
            type = string(type, dotType[i])
        end
        toFile(type, json_stream)
        toFile(y.array, json_stream)
        toFile(y.units, json_stream)
    else
        error("The supplied JSON stream is not open.")
    end
    return nothing
end

function toFile(y::ArrayOfPhysicalVectors, json_stream::IOStream)
    if isopen(json_stream)
        (path, dotType) = splitext(string(typeof(y)))
        type = ""
        for i in 2:length(dotType)
            type = string(type, dotType[i])
        end
        toFile(type, json_stream)
        toFile(y.array, json_stream)
        toFile(y.units, json_stream)
    else
        error("The supplied JSON stream is not open.")
    end
    return nothing
end

function toFile(y::ArrayOfPhysicalTensors, json_stream::IOStream)
    if isopen(json_stream)
        (path, dotType) = splitext(string(typeof(y)))
        type = ""
        for i in 2:length(dotType)
            type = string(type, dotType[i])
        end
        toFile(type, json_stream)
        toFile(y.array, json_stream)
        toFile(y.units, json_stream)
    else
        error("The supplied JSON stream is not open.")
    end
    return nothing
end

function toFile(y::VectorOfPhysicalScalars, json_stream::IOStream)
    if isopen(json_stream)
        (path, dotType) = splitext(string(typeof(y)))
        type = ""
        for i in 2:length(dotType)
            type = string(type, dotType[i])
        end
        toFile(type, json_stream)
        toFile(y.values, json_stream)
        toFile(y.units, json_stream)
    else
        error("The supplied JSON stream is not open.")
    end
    return nothing
end

function toFile(y::MatrixOfPhysicalScalars, json_stream::IOStream)
    if isopen(json_stream)
        (path, dotType) = splitext(string(typeof(y)))
        type = ""
        for i in 2:length(dotType)
            type = string(type, dotType[i])
        end
        toFile(type, json_stream)
        toFile(y.values, json_stream)
        toFile(y.units, json_stream)
    else
        error("The supplied JSON stream is not open.")
    end
    return nothing
end

function fromFile(::Type{PhysicalScalar}, json_stream::IOStream)::PhysicalScalar
    if isopen(json_stream)
        type  = fromFile(String, json_stream)
        if !isequal(type, "PhysicalScalar")
            error("Expected to read in a PhysicalScalar from file.")
        end
        value = fromFile(MReal, json_stream)
        units = fromFile(PhysicalUnits, json_stream)
    else
        error("The supplied JSON stream is not open.")
    end
    return PhysicalScalar(value, units)
end

function fromFile(::Type{PhysicalVector}, json_stream::IOStream)::PhysicalVector
    if isopen(json_stream)
        type  = fromFile(String, json_stream)
        if !isequal(type, "PhysicalVector")
            error("Expected to read in a PhysicalVector from file.")
        end
        vector = fromFile(MVector, json_stream)
        units  = fromFile(PhysicalUnits, json_stream)
    else
        error("The supplied JSON stream is not open.")
    end
    return PhysicalVector(vector, units)
end

function fromFile(::Type{PhysicalTensor}, json_stream::IOStream)::PhysicalTensor
    if isopen(json_stream)
        type  = fromFile(String, json_stream)
        if !isequal(type, "PhysicalTensor")
            error("Expected to read in a PhysicalTensor from file.")
        end
        matrix = fromFile(MMatrix, json_stream)
        units  = fromFile(PhysicalUnits, json_stream)
    else
        error("The supplied JSON stream is not open.")
    end
    return PhysicalTensor(matrix, units)
end

function fromFile(::Type{ArrayOfPhysicalScalars}, json_stream::IOStream)::ArrayOfPhysicalScalars
    if isopen(json_stream)
        type  = fromFile(String, json_stream)
        if !isequal(type, "ArrayOfPhysicalScalars")
            error("Expected to read in a ArrayOfPhysicalScalars from file.")
        end
        array = fromFile(MVector, json_stream)
        units = fromFile(PhysicalUnits, json_stream)
    else
        error("The supplied JSON stream is not open.")
    end
    return ArrayOfPhysicalScalars(array, units)
end

function fromFile(::Type{ArrayOfPhysicalVectors}, json_stream::IOStream)::ArrayOfPhysicalVectors
    if isopen(json_stream)
        type  = fromFile(String, json_stream)
        if !isequal(type, "ArrayOfPhysicalVectors")
            error("Expected to read in a ArrayOfPhysicalVectors from file.")
        end
        array = fromFile(MMatrix, json_stream)
        units = fromFile(PhysicalUnits, json_stream)
    else
        error("The supplied JSON stream is not open.")
    end
    return ArrayOfPhysicalVectors(array, units)
end

function fromFile(::Type{ArrayOfPhysicalTensors}, json_stream::IOStream)::ArrayOfPhysicalTensors
    if isopen(json_stream)
        type  = fromFile(String, json_stream)
        if !isequal(type, "ArrayOfPhysicalTensors")
            error("Expected to read in a ArrayOfPhysicalTensors from file.")
        end
        array = fromFile(MArray, json_stream)
        units = fromFile(PhysicalUnits, json_stream)
    else
        error("The supplied JSON stream is not open.")
    end
    return ArrayOfPhysicalTensors(array, units)
end
    
function fromFile(::Type{VectorOfPhysicalScalars}, json_stream::IOStream)::VectorOfPhysicalScalars
    if isopen(json_stream)
        type  = fromFile(String, json_stream)
        if !isequal(type, "VectorOfPhysicalScalars")
            error("Expected to read in a VectorOfPhysicalScalars from file.")
        end
        values = fromFile(MVector, json_stream)
        units  = fromFile(VectorOfPhysicalUnits, json_stream)
    else
        error("The supplied JSON stream is not open.")
    end
    return VectorOfPhysicalScalars(values, units)
end

function fromFile(::Type{MatrixOfPhysicalScalars}, json_stream::IOStream)::MatrixOfPhysicalScalars
    if isopen(json_stream)
        type  = fromFile(String, json_stream)
        if !isequal(type, "MatrixOfPhysicalScalars")
            error("Expected to read in a MatrixOfPhysicalScalars from file.")
        end
        values = fromFile(MMatrix, json_stream)
        units  = fromFile(MatrixOfPhysicalUnits, json_stream)
    else
        error("The supplied JSON stream is not open.")
    end
    return MatrixOfPhysicalScalars(values, units)
end

#=
-------------------------------------------------------------------------------
=#

# Overloaded operators: ==, ≈, ≠

function Base.:(==)(y::ArrayOfPhysicalScalars, z::ArrayOfPhysicalScalars)::Bool
    if y.array == z.array && y.units == z.units
        return true
    else
        return false
    end
end

function Base.:(==)(y::ArrayOfPhysicalVectors, z::ArrayOfPhysicalVectors)::Bool
    if y.array == z.array && y.units == z.units
        return true
    else
        return false
    end
end

function Base.:(==)(y::ArrayOfPhysicalTensors, z::ArrayOfPhysicalTensors)::Bool
    if y.array == z.array && y.units == z.units
        return true
    else
        return false
    end
end

function Base.:(==)(y::VectorOfPhysicalScalars, z::VectorOfPhysicalScalars)::Bool
    if y.values == z.values && y.units == z.units
        return true
    else
        return false
    end
end

function Base.:(==)(y::MatrixOfPhysicalScalars, z::MatrixOfPhysicalScalars)::Bool
    if y.values == z.values && y.units == z.units
        return true
    else
        return false
    end
end

function Base.:≈(y::ArrayOfPhysicalScalars, z::ArrayOfPhysicalScalars)::Bool
    if y.array ≈ z.array && y.units == z.units
        return true
    else
        return false
    end
end

function Base.:≈(y::ArrayOfPhysicalVectors, z::ArrayOfPhysicalVectors)::Bool
    if y.array ≈ z.array && y.units == z.units
        return true
    else
        return false
    end
end

function Base.:≈(y::ArrayOfPhysicalTensors, z::ArrayOfPhysicalTensors)::Bool
    if y.array ≈ z.array && y.units == z.units
        return true
    else
        return false
    end
end

function Base.:≈(y::VectorOfPhysicalScalars, z::VectorOfPhysicalScalars)::Bool
    if y.values ≈ z.values && y.units == z.units
        return true
    else
        return false
    end
end

function Base.:≈(MatrixOfPhysicalScalars, z::MatrixOfPhysicalScalars)::Bool
    if y.values ≈ z.values && y.units == z.units
        return true
    else
        return false
    end
end

function Base.:≠(y::ArrayOfPhysicalScalars, z::ArrayOfPhysicalScalars)::Bool
    if y.array ≠ z.array || y.units ≠ z.units
        return true
    else
        return false
    end
end

function Base.:≠(y::ArrayOfPhysicalVectors, z::ArrayOfPhysicalVectors)::Bool
    if y.array ≠ z.array || y.units ≠ z.units
        return true
    else
        return false
    end
end

function Base.:≠(y::ArrayOfPhysicalTensors, z::ArrayOfPhysicalTensors)::Bool
    if y.array ≠ z.array || y.units ≠ z.units
        return true
    else
        return false
    end
end

function Base.:≠(y::VectorOfPhysicalScalars, z::VectorOfPhysicalScalars)::Bool
    if y.values ≠ z.values || y.units ≠ z.units
        return true
    else
        return false
    end
end

function Base.:≠(y::MatrixOfPhysicalScalars, z::MatrixOfPhysicalScalars)::Bool
    if y.values ≠ z.values || y.units ≠ z.units
        return true
    else
        return false
    end
end

# Overloaded operators: +, -, *

function Base.:+(y::VectorOfPhysicalScalars, z::VectorOfPhysicalScalars)::VectorOfPhysicalScalars
    if y.values.len ≠ z.values.len
        msg = "Vector addition requires vectors with the same length."
        throw(DimensionMismatch(msg))
    end
    if y.units ≠ z.units
        error("Vector addition requires vectors with the same units.")
    end
    
    len = y.values.len
    vec = VectorOfPhysicalScalars(len)
    for i in 1:len
        vec.values[i] = y.values[i] + z.values[i]
        vec.units[i]  = y.units[i]
    end
    
    return vec
end

function Base.:+(y::MatrixOfPhysicalScalars, z::MatrixOfPhysicalScalars)::MatrixOfPhysicalScalars
    if y.values.rows ≠ z.values.rows || y.values.cols ≠ z.values.cols
        msg = "Matrix addition requires matrices with the same dimensions."
        throw(DimensionMismatch(msg))
    end
    if y.units ≠ z.units
        error("Matrix addition requires matrices with the same units.")
    end
    
    rows = y.values.rows
    cols = y.values.cols
    mtx  = MatrixOfPhysicalScalars(rows, cols)
    for i in 1:rows
        for j in 1:cols
            mtx.values[i,j] = y.values[i,j] + z.values[i,j]
            mtx.units[i,j]  = y.units[i,j]
        end
    end
    
    return mtx
end

function Base.:-(y::VectorOfPhysicalScalars, z::VectorOfPhysicalScalars)::VectorOfPhysicalScalars
    if y.values.len ≠ z.values.len
        msg = "Vector subtraction requires vectors with the same length."
        throw(DimensionMismatch(msg))
    end
    if y.units ≠ z.units
        error("Vector subtraction requires vectors with the same units.")
    end
    
    len = y.values.len
    vec = VectorOfPhysicalScalars(len)
    for i in 1:len
        vec.values[i] = y.values[i] - z.values[i]
        vec.units[i]  = y.units[i]
    end
    
    return vec
end

function Base.:-(y::MatrixOfPhysicalScalars, z::MatrixOfPhysicalScalars)::MatrixOfPhysicalScalars
    if y.values.rows ≠ z.values.rows || y.values.cols ≠ z.values.cols
        msg = "Matrix subtraction requires matrices with the same dimensions."
        throw(DimensionMismatch(msg))
    end
    if y.units ≠ z.units
        error("Matrix subtraction requires matrices with the same units.")
    end
    
    rows = y.values.rows
    cols = y.values.cols
    mtx  = MatrixOfPhysicalScalars(rows, cols)
    for i in 1:rows
        for j in 1:cols
            mtx.values[i,j] = y.values[i,j] - z.values[i,j]
            mtx.units[i,j]  = y.units[i,j]
        end
    end
    
    return mtx
end

function Base.:*(y::Real, z::VectorOfPhysicalScalars)::VectorOfPhysicalScalars
    len = z.values.len
    vec = VectorOfPhysicalScalars(len)
    for i in 1:len
        vec.values[i] = y * z.values[i]
        vec.units[i]  = z.units[i]
    end
    
    return vec
end

function Base.:*(y::Real, z::MatrixOfPhysicalScalars)::MatrixOfPhysicalScalars
    rows = z.values.rows
    cols = z.values.cols
    mtx  = MatrixOfPhysicalScalars(rows, cols)
    for i in 1:rows
        for j in 1:cols
            mtx.values[i,j] = y * z.values[i,j]
            mtx.units[i,j]  = z.units[i,j]
        end
    end
    
    return mtx
end

function Base.:*(y::PhysicalScalar, z::VectorOfPhysicalScalars)::VectorOfPhysicalScalars
    len = z.values.len
    vec = VectorOfPhysicalScalars(len)
    for i in 1:len
        vec.values[i] = y.value * z.values[i]
        vec.units[i]  = y.units + z.units[i]
    end
    
    return vec
end

function Base.:*(y::PhysicalScalar, z::MatrixOfPhysicalScalars)::MatrixOfPhysicalScalars
    rows = z.values.rows
    cols = z.values.cols
    mtx  = MatrixOfPhysicalScalars(rows, cols)
    for i in 1:rows
        for j in 1:cols
            mtx.values[i,j] = y.value * z.values[i,j]
            mtx.units[i,j]  = y.units + z.units[i,j]
        end
    end
    
    return mtx
end

function Base.:*(y::MatrixOfPhysicalScalars, z::VectorOfPhysicalScalars)::VectorOfPhysicalScalars
    if y.values.cols ≠ z.values.len
        msg = "Dimensions are not compatible for a matrix-vector contraction."
        throw(DimensionMismatch(msg))
    end
    
    rows = y.values.rows
    cols = y.values.cols
    vec  = VectorOfPhysicalScalars(rows)
    for i in 1:rows
        vec.units[i] = y.units[i,i] + z.units[i]
        sum = 0.0
        for j in 1:cols
            sum += y.values[i,j] * z.values[j]
            if i ≠ j
                if vec.units[i] ≠ y.units[i,j] + z.units[j]
                    msg = "Units are not compatible for a matrix-vector contraction."
                    throw(DimensionMismatch(msg))
                end
            end
        end
        vec.values[i] = sum
    end
    
    return vec
end

function Base.:(inv)(y::MatrixOfPhysicalScalars)::MatrixOfPhysicalScalars
    rows = y.values.rows
    cols = y.values.cols

    mtxInv = MatrixOfPhysicalScalars(cols, rows)
    valInv = inv(y.values)
    for i in 1:cols
        for j in 1:rows
            mtxInv.values[i,j] = valInv[i,j]
            mtxInv.units[i,j]  = -y.units[j,i]
        end
    end
    
    return mtxInv
end
