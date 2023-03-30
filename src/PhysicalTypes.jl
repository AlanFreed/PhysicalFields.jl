# PhysicalTypes

abstract type PhysicalField end

struct PhysicalScalar <: PhysicalField
    x::MReal            # value of the scalar in its specified system of units
    u::PhysicalUnits    # the scalar's physical units
end

struct PhysicalVector <: PhysicalField
    l::UInt8            # length of the vector
    v::StaticVector     # values of the vector in its specified system of units
    u::PhysicalUnits    # the vector's physical units
end

struct PhysicalTensor <: PhysicalField
    r::UInt8            # rows in the matrix representation of the tensor
    c::UInt8            # columns in the matrix representation of the tensor
    m::StaticMatrix     # values of the tensor in its specified system of units
    u::PhysicalUnits    # the tensor's physical units
end

struct ArrayOfPhysicalScalars
    e::UInt32           # number of entries or elements held in the array
    a::Array            # array holding values of a physical scalar
    u::PhysicalUnits    # units of this physical scalar
end

struct ArrayOfPhysicalVectors
    e::UInt32           # number of entries or elements held in the array
    l::UInt8            # length of each physical vector held in the array
    a::Array            # array of vectors holding values of a physical vector
    u::PhysicalUnits    # units of this physical vector
end

struct ArrayOfPhysicalTensors
    e::UInt32           # number of entries or elements held in the array
    r::UInt8            # rows in each physical tensor held in the array
    c::UInt8            # columns in each physical tensor held in the array
    a::Array            # array of matrices holding values of a physical tensor
    u::PhysicalUnits    # units of this physical tensor
end

# Their Constructors

function newPhysicalScalar(units::PhysicalUnits)::PhysicalScalar
    if isa(units, CGS) || isa(units, SI)
        return PhysicalScalar(MReal(0.0), units)
    else
        msg = "Scalar `units` must be a subtype of PhysicalUnits."
        throw(ErrorException(msg))
    end
end

function newPhysicalVector(len::Integer, units::PhysicalUnits)::PhysicalVector
    if (len < 1) || (len > typemax(UInt8))
        msg = string("A vector can only have lengths ∈ [1…255].")
        throw(ErrorException(msg))
    end
    if isa(units, CGS) || isa(units, SI)
        vec = @MVector zeros(Float64, Int64(len))
        return PhysicalVector(UInt16(len), vec, units)
    else
        msg = "Vector `units` must be a subtype of PhysicalUnits."
        throw(ErrorException(msg))
    end
end

function newPhysicalTensor(rows::Integer, cols::Integer, units::PhysicalUnits)::PhysicalTensor
    if (((rows < 1) || (rows > typemax(UInt8))) ||
        ((cols < 1) || (cols > typemax(UInt8))))
        msg = string("A tensor can only have rows and columns ∈ [1…255].")
        throw(ErrorException(msg))
    end
    if isa(units, CGS) || isa(units, SI)
        mtx = @MMatrix zeros(Float64, Int64(rows), Int64(cols))
        return PhysicalTensor(UInt8(rows), UInt8(cols), mtx, units)
    else
        msg = "Tensor `units` must be a subtype of PhysicalUnits."
        throw(ErrorException(msg))
    end
end

function newArrayOfPhysicalScalars(len::Integer, s₁::PhysicalScalar)::ArrayOfPhysicalScalars
    if (len < 1) || (len > typemax(UInt32))
        msg = string("An array can only have lengths ∈ [1…4,294,967,295].")
        throw(ErrorException(msg))
    end
    if isa(s₁.u, CGS) || isa(s₁.u, SI)
        vec = zeros(Float64, len)
        vec[1] = get(s₁)
        return ArrayOfPhysicalScalars(UInt32(len), vec, s₁.u)
    else
        msg = "An array of scalars must have either CGS or SI units."
        throw(ErrorException(msg))
    end
end

function newArrayOfPhysicalVectors(len::Integer, v₁::PhysicalVector)::ArrayOfPhysicalVectors
    if (len < 1) || (len > typemax(UInt32))
        msg = string("An array can only have lengths ∈ [1…4,294,967,295].")
        throw(ErrorException(msg))
    end
    if isa(v₁.u, CGS) || isa(v₁.u, SI)
        mtx = zeros(Float64, (len, v₁.l))
        mtx[1,:] = v₁.v[:]
        return ArrayOfPhysicalVectors(UInt32(len), UInt8(v₁.l), mtx, v₁.u)
    else
        msg = "An array of vectors must have either CGS or SI units."
        throw(ErrorException(msg))
    end
end

function newArrayOfPhysicalTensors(len::Integer, m₁::PhysicalTensor)::ArrayOfPhysicalTensors
    if (len < 1) || (len > typemax(UInt32))
        msg = string("An array can only have lengths ∈ [1…4,294,967,295].")
        throw(ErrorException(msg))
    end
    if isa(m₁.u, CGS) || isa(m₁.u, SI)
        mtx = zeros(Float64, (len, m₁.r, m₁.c))
        mtx[1,:,:] = m₁.m[:,:]
        return ArrayOfPhysicalTensors(UInt32(len), UInt8(m₁.r), UInt8(m₁.c), mtx, m₁.u)
    else
        msg = "An array of tensors must have either CGS or SI units."
        throw(ErrorException(msg))
    end
end

# Define the get and set! functions to retrieve and assign values.

function Base.:(get)(y::PhysicalScalar)::Real
    return get(y.x)
end

function set!(y::PhysicalScalar, x::Real)
    set!(y.x, x)
    return nothing
end

function Base.:(getindex)(y::PhysicalVector, idx::Integer)::PhysicalScalar
    if (idx < 1) || (idx > y.l)
        msg = string("Admissible vector indices are ∈ [1…", y.l, "].")
        throw(ErrorException(msg))
    end
    s = newPhysicalScalar(y.u)
    set!(s, y.v[idx])
    return s
end

function Base.:(setindex!)(y::PhysicalVector, val::PhysicalScalar, idx::Integer)
    if (idx < 1) || (idx > y.l)
        msg = string("Admissible vector indices are ∈ [1…", y.l, "].")
        throw(ErrorException(msg))
    end
    if y.u == val.u
        y.v[idx] = get(val)
    else
        msg = string("The units of the sent scalar, ", toString(val.u))
        msg *= string(", differ from those of the vector, ", toString(y.u))
        msg *= ", in an [] assignment to this physical vector."
        throw(ErrorException(msg))
    end
    return nothing
end

function Base.:(getindex)(y::PhysicalTensor, row::Integer, col::Integer)::PhysicalScalar
    if ((row < 1) || (row > y.r)) || ((col < 1) || (col > y.c))
        msg = string("Admissible tensor indices are ∈ [1…", string(y.r), ", 1…", string(y.c), "].")
        throw(ErrorException(msg))
    end
    s = newPhysicalScalar(y.u)
    set!(s, y.m[row,col])
    return s
end

function Base.:(setindex!)(y::PhysicalTensor, val::PhysicalScalar, row::Integer, col::Integer)
    if ((row < 1) || (row > y.r)) || ((col < 1) || (col > y.c))
        msg = string("Admissible tensor indices are ∈ [1…", string(y.r), ", 1…", string(y.c), "].")
        throw(ErrorException(msg))
    end
    if y.u == val.u
        y.m[row,col] = get(val)
    else
        msg = string("The units of the sent scalar, ", toString(val.u))
        msg *= string(", differ from those of the tensor, ", toString(y.u))
        msg *= ", in an [] assignment to this physical tensor."
        throw(ErrorException(msg))
    end
    return nothing
end

function Base.:(getindex)(y::ArrayOfPhysicalScalars, idx::Integer)::PhysicalScalar
    if (idx < 1) || (idx > y.e)
        msg = string("Admissible array indices are ∈ [1…", string(y.e), "].")
        throw(ErrorException(msg))
    end
    s = newPhysicalScalar(y.u)
    set!(s, y.a[idx])
    return s
end

function Base.:(setindex!)(y::ArrayOfPhysicalScalars, val::PhysicalScalar, idx::Integer)
    if (idx < 1) || (idx > y.e)
        msg = string("Admissible array indices are ∈ [1…", string(y.e), "].")
        throw(ErrorException(msg))
    end
    if val.u == y.u
        y.a[idx] = get(val)
    else
        msg = string("The units of the sent scalar, ", toString(val.u))
        msg *= string(", differ from those of the array, ", toString(y.u))
        msg *= ", in a set [] assignment to this array of physical scalars."
        throw(ErrorException(msg))
    end
    return nothing
end

function Base.:(getindex)(y::ArrayOfPhysicalVectors, idx::Integer)::PhysicalVector
    if (idx < 1) || (idx > y.e)
        msg = string("Admissible array indices are ∈ [1…", string(y.e), "].")
        throw(ErrorException(msg))
    end
    vec = newPhysicalVector(y.l, y.u)
    for l in 1:y.l
        s = newPhysicalScalar(y.u)
        set!(s, y.a[idx,l])
        vec[l] = s
    end
    return vec
end

function Base.:(setindex!)(y::ArrayOfPhysicalVectors, val::PhysicalVector, idx::Integer)
    if (idx < 1) || (idx > y.e)
        msg = string("Admissible array indices are ∈ [1…", string(y.e), "].")
        throw(ErrorException(msg))
    end
    if y.l ≠ val.l
        msg = string("The reassigning/setting vector has the wrong length.")
        throw(ErrorException(msg))
    end
    if y.u == val.u
        y.a[idx,:] = val.v[:]
    else
        msg = string("The units of the sent vector, ", toString(val.u))
        msg *= string(", differ from those of the array, ", toString(y.u))
        msg *= ", in a set [] assignment to this array of physical vectors."
        throw(ErrorException(msg))
    end
    return nothing
end

function Base.:(getindex)(y::ArrayOfPhysicalTensors, idx::Integer)::PhysicalTensor
    if (idx < 1) || (idx > y.e)
        msg = string("Admissible array indices are ∈ [1…", string(y.e), "].")
        throw(ErrorException(msg))
    end
    mtx = newPhysicalTensor(y.r, y.c, y.u)
    for r in 1:y.r
        for c in 1:y.c
            s = newPhysicalScalar(y.u)
            set!(s, y.a[idx,r,c])
            mtx[r,c] = s
        end
    end
    return mtx
end

function Base.:(setindex!)(y::ArrayOfPhysicalTensors, val::PhysicalTensor, idx::Integer)
    if (idx < 1) || (idx > y.e)
        msg = string("Admissible array indices are ∈ [1…", string(y.e), "].")
        throw(ErrorException(msg))
    end
    if (y.r ≠ val.r) || (y.c ≠ val.c)
        msg = string("The reassigning/setting tensor has the wrong dimensions.")
        throw(ErrorException(msg))
    end
    if y.u == val.u
        y.a[idx,:,:] = val.m[:,:]
    else
        msg = string("The units of the sent tensor, ", toString(val.u))
        msg *= string(", differ from those of the array, ", toString(y.u))
        msg *= ", in a set [] assignment to this array of physical tensors."
        throw(ErrorException(msg))
    end
    return nothing
end

# String conversion for the three basic types of physical fields.

function toString(y::PhysicalScalar;
                  format::Char='E',
                  precision::Int=5,
                  aligned::Bool=false)::String
    s = toString(y.x; format, precision, aligned)
    if !isDimensionless(y.u)
        s *= string(' ', toString(y.u))
    end
    return s
end

# Extra formatting is needed to convert a vector into a string.

function VtoStringE(v::PhysicalVector; format::Char)::String
    aligned = true
    if v.l < 6
        precision = 5
    elseif v.l == 6
        precision = 4
    else
        precision = 3
    end
    s = string('{', toString(v.v[1]; format, precision, aligned))
    if v.l < 8
        for i in 2:v.l
            s *= string(' ', toString(v.v[i]; format, precision, aligned))
        end
    else
        for i in 2:5
            s *= string(' ', toString(v.v[i]; format, precision, aligned))
        end
        s *= string(" ⋯ ", toString(v.v[v.l]; format, precision, aligned))
    end
    s *= string("}ᵀ")
    if !isDimensionless(v.u)
        s *= string(' ', toString(v.u))
    end
    return s
end

function VtoStringF(v::PhysicalVector)::String
    format = 'F'
    aligned = true
    if v.l < 9
        precision = 5
    elseif v.l == 9
        precision = 4
    else
        precision = 3
    end
    s = string('{', toString(v.v[1]; format, precision, aligned))
    if v.l < 12
        for i in 2:v.l
            s *= string(' ', toString(v.v[i]; format, precision, aligned))
        end
    else
        for i in 2:9
            s *= string(' ', toString(v.v[i]; format, precision, aligned))
        end
        s *= string(" ⋯ ", toString(v.v[v.l]; format, precision, aligned))
    end
    s *= string("}ᵀ")
    if !isDimensionless(v.u)
        s *= string(' ', toString(v.u))
    end
    return s
end

function toString(v::PhysicalVector; format::Char='E')::String
    if (format == 'e') || (format == 'E')
        return VtoStringE(v; format)
    else
        return VtoStringF(v)
    end
end

# Extra formatting is needed to convert a matrix into a string.

function TtoStringE(t::PhysicalTensor; format::Char)::String
    aligned = true
    # Establish how many rows are to be printed out.
    if t.r < 6
        rows = t.r
    else
        rows = 6
    end
    unitsInRow = 1 + rows ÷ 2
    # Establish how many columns are to be printed out.
    if t.c < 5
        cols = t.c
        precision = 5
    elseif t.c == 5
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
        if t.r > rows && i == 5
            if cols < 5
                s *= "     ⋮     "
                for j in 2:cols-2
                    s *= "      ⋮     "
                end
                if t.c > cols
                    s *= "  ⋱       ⋮     "
                else
                    s *= "      ⋮           ⋮     "
                end
            elseif cols == 5
                s *= "    ⋮     "
                for j in 2:cols-2
                    s *= "     ⋮     "
                end
                if t.c > cols
                    s *= "  ⋱     ⋮     "
                else
                    s *= "     ⋮          ⋮     "
                end
            else
                s *= "    ⋮    "
                for j in 2:cols-2
                    s *= "     ⋮    "
                end
                if t.c > cols
                    s *= "  ⋱     ⋮    "
                else
                    s *= "     ⋮         ⋮    "
                end
            end
        else
            for j in 1:cols-2
                s *= string(toString(t.m[i,j]; format, precision, aligned), ' ')
            end
            if t.c > cols
                s *= " ⋯ "
            else
                s *= string(toString(t.m[i,cols-1]; format, precision, aligned), ' ')
            end
            s *= toString(t.m[i,t.c]; format, precision, aligned)
        end
        if i == 1
            s *= '⌉'
        elseif i < rows
            s *= '|'
        else
            s *= '⌋'
        end
        if i == unitsInRow
            if !isDimensionless(t.u)
                s *= string(' ', toString(t.u))
            end
        end
        if i < rows
            s *= "\n"
        end
    end
    return s
end

function TtoStringF(t::PhysicalTensor)::String
    format = 'F'
    aligned = true
    # Establish how many rows are to be printed out.
    if t.r < 11
        rows = t.r
    else
        rows = 10
    end
    unitsInRow = 1 + rows ÷ 2
    # Establish how many columns are to be printed out.
    if t.c < 9
        cols = t.c
        precision = 5
    elseif t.c == 9
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
        if t.r > rows && i == 9
            if cols < 9
                s *= "   ⋮   "
                for j in 2:cols-2
                    s *= "    ⋮   "
                end
                if t.c > cols
                    s *= "  ⋱     ⋮   "
                else
                    s *= "    ⋮       ⋮   "
                end
            elseif cols == 9
                s *= "  ⋮   "
                for j in 2:cols-2
                    s *= "   ⋮   "
                end
                if t.c > cols
                    s *= "  ⋱    ⋮   "
                else
                    s *= "   ⋮     ⋮   "
                end
            else
                s *= "  ⋮  "
                for j in 2:cols-2
                    s *= "   ⋮  "
                end
                if t.c > cols
                    s *= "  ⋱   ⋮  "
                else
                    s *= "   ⋮     ⋮  "
                end
            end
        else
            for j in 1:cols-2
                s *= string(toString(t.m[i,j]; format, precision, aligned), ' ')
            end
            if t.c > cols
                s *= " ⋯ "
            else
                s *= string(toString(t.m[i,cols-1]; format, precision, aligned), ' ')
            end
            s *= toString(t.m[i,t.c]; format, precision, aligned)
        end
        if i == 1
            s *= '⌉'
        elseif i < rows
            s *= '|'
        else
            s *= '⌋'
        end
        if i == unitsInRow
            if !isDimensionless(t.u)
                s *= string(' ', toString(t.u))
            end
        end
        if i < rows
            s *= "\n"
        end
    end
    return s
end

function toString(t::PhysicalTensor; format::Char='E')::String
    if format == 'e' || format == 'E'
        return TtoStringE(t; format)
    else
        return TtoStringF(t)
    end
end
