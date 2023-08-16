# PhysicalTypes

# exported types

abstract type PhysicalField end

struct PhysicalScalar <: PhysicalField
    x::MReal            # value of a scalar in its specified system of units
    u::PhysicalUnits    # physical units of the scalar

    # constructors

    function PhysicalScalar(units::PhysicalUnits)
        new(MReal(), units)
    end

    function PhysicalScalar(value::Number, units::PhysicalUnits)
        if isa(value, MReal)
            new(value, units)
        elseif isa(value, Real)
            new(MReal(value), units)
        else
            new(MReal(convert(Float64, value)), units)
        end
    end
end

struct PhysicalVector <: PhysicalField
    l::UInt8            # length of a vector
    v::Vector           # values of a vector in its specified system of units
    u::PhysicalUnits    # physical units of the vector

    # constructors

    function PhysicalVector(len::Integer, units::PhysicalUnits)
        if (len < 1) || (len > typemax(UInt8))
            msg = "A physical vector can only have a length from [1…255]."
            throw(ErrorException(msg))
        end
        vec = zeros(Float64, Int64(len))
        new(UInt8(len), vec, units)
    end

    function PhysicalVector(len::Integer, vector::Vector, units::PhysicalUnits)
        if (len < 1) || (len > typemax(UInt8))
            msg = "A physical vector can only have a length from [1…255]."
            throw(ErrorException(msg))
        end
        if len ≠ length(vector)
            msg = "The assigned length does not equal the vector's length."
            throw(ErrorException(msg))
        end
        if isa(vector, Vector)
            vec = vector
        else
            vec = zeros(Float64, Int64(len))
            for i in 1:len
                vec[i] = convert(Float64, vector[i])
            end
        end
        new(UInt8(len), vec, units)
    end
end

struct PhysicalTensor <: PhysicalField
    r::UInt8            # rows in the matrix representation of a tensor
    c::UInt8            # columns in the matrix representation of a tensor
    m::Matrix           # values of a tensor in its specified system of units
    u::PhysicalUnits    # physical units of the tensor

    # constructors

    function PhysicalTensor(rows::Integer, cols::Integer, units::PhysicalUnits)
        mtx = zeros(Float64, Int64(rows), Int64(cols))
        new(UInt8(rows), UInt8(cols), mtx, units)
    end

    function PhysicalTensor(rows::Integer, cols::Integer, matrix::Matrix, units::PhysicalUnits)
        if (rows, cols) ≠ size(matrix)
            msg = "The assigned size does not equal the matrix's size."
            throw(ErrorException(msg))
        end
        if ((rows < 1) || (rows > typemax(UInt8)) ||
            (cols < 1) || (cols > typemax(UInt8)))
            msg = "Physical tensors can only be sized at [1…255, 1…255]."
            throw(ErrorException(msg))
        end
        if isa(matrix, Matrix)
            mtx = matrix
        else
            mtx = zeros(Float64, Int64(rows), Int64(cols))
            for i in 1:rows
                for j in 1:cols
                    mtx[i,j] = convert(Float64, matrix[i,j])
                end
            end
        end
        new(UInt8(rows), UInt8(cols), mtx, units)
    end
end

struct ArrayOfPhysicalScalars
    e::UInt32           # number of entries or elements held in the array
    a::Vector           # array holding values of a physical scalar
    u::PhysicalUnits    # physical units of the scalar array

    # constructors

    function ArrayOfPhysicalScalars(arr_len::Integer, units::PhysicalUnits)
        if (arr_len < 1) || (arr_len > typemax(UInt32))
            msg = string("An array can only have [1…4,294,967,295] entries.")
            throw(ErrorException(msg))
        end
        arr = zeros(Float64, Int64(arr_len))
        new(UInt32(arr_len), arr, units)
    end

    function ArrayOfPhysicalScalars(arr_len::Integer, sca_vals::Vector, units::PhysicalUnits)
        if (arr_len < 1) || (arr_len > typemax(UInt32))
            msg = string("An array can only have [1…4,294,967,295] entries.")
            throw(ErrorException(msg))
        end
        if arr_len ≠ length(sca_vals)
            msg = "The assigned length does not equal the array's length."
            throw(ErrorException(msg))
        end
        if isa(sca_vals, Vector)
            arr = sca_vals
        else
            arr = zeros(Float64, Int64(arr_len))
            for i in 1:arr_len
                arr[i] = convert(Float64, sca_vals[i])
            end
        end
        new(UInt32(arr_len), arr, units)
    end
end

struct ArrayOfPhysicalVectors
    e::UInt32           # number of entries or elements held in the array
    l::UInt8            # length for each physical vector held in the array
    a::Matrix           # array of vectors holding values of a physical vector
    u::PhysicalUnits    # physical units of the vector array

    # constructors

    function ArrayOfPhysicalVectors(arr_len::Integer, vec_len::Integer, units::PhysicalUnits)
        if (arr_len < 1) || (arr_len > typemax(UInt32))
            msg = string("An array can only have [1…4,294,967,295] entries.")
            throw(ErrorException(msg))
        end
        if (vec_len < 1) || (vec_len > typemax(UInt8))
            msg = "A physical vector can only have a length from [1…255]."
            throw(ErrorException(msg))
        end
        arr = zeros(Float64, Int64(arr_len), Int64(vec_len))
        new(UInt32(arr_len), UInt8(vec_len), arr, units)
    end

    function ArrayOfPhysicalVectors(arr_len::Integer, vec_len::Integer, vec_vals::Matrix, units::PhysicalUnits)
        if (arr_len < 1) || (arr_len > typemax(UInt32))
            msg = string("An array can only have [1…4,294,967,295] entries.")
            throw(ErrorException(msg))
        end
        if (vec_len < 1) || (vec_len > typemax(UInt8))
            msg = "A physical vector can only have a length from [1…255]."
            throw(ErrorException(msg))
        end
        if (arr_len, vec_len) ≠ size(vec_vals)
            msg = "The assigned size does not equal the array's size."
            throw(ErrorException(msg))
        end
        if isa(vec_vals, Matrix)
            arr = vec_vals
        else
            arr = zeros(Float64, Int64(arr_len), Int64(vec_len))
            for i in 1:arr_len
                for j in 1:vec_len
                    arr[i,j] = convert(Float64, vec_vals[i,j])
                end
            end
        end
        new(UInt32(arr_len), UInt8(vec_len), arr, units)
    end
end

struct ArrayOfPhysicalTensors
    e::UInt32           # number of entries or elements held in the array
    r::UInt8            # rows for each physical tensor held in the array
    c::UInt8            # columns for each physical tensor held in the array
    a::Array            # array of matrices holding values of a physical tensor
    u::PhysicalUnits    # physical units of the tensor array

    # constructors

    function ArrayOfPhysicalTensors(arr_len::Integer, ten_rows::Integer, ten_cols::Integer, units::PhysicalUnits)
        if (arr_len < 1) || (arr_len > typemax(UInt32))
            msg = string("An array can only have [1…4,294,967,295] entries.")
            throw(ErrorException(msg))
        end
        if ((ten_rows < 1) || (ten_rows > typemax(UInt8)) ||
            (ten_cols < 1) || (ten_cols > typemax(UInt8)))
            msg = "Physical tensors can only be sized at [1…255, 1…255]."
            throw(ErrorException(msg))
        end
        arr = zeros(Float64, Int64(arr_len), Int64(ten_rows), Int64(ten_cols))
        new(UInt32(arr_len), UInt8(ten_rows), UInt8(ten_cols), arr, units)
    end

    function ArrayOfPhysicalTensors(arr_len::Integer, ten_rows::Integer, ten_cols::Integer, ten_vals::Array, units::PhysicalUnits)
        if (arr_len < 1) || (arr_len > typemax(UInt32))
            msg = string("An array can only have [1…4,294,967,295] entries.")
            throw(ErrorException(msg))
        end
        if ((ten_rows < 1) || (ten_rows > typemax(UInt8)) ||
            (ten_cols < 1) || (ten_cols > typemax(UInt8)))
            msg = "Physical tensors can only be sized at [1…255, 1…255]."
            throw(ErrorException(msg))
        end
        if (arr_len, ten_rows, ten_cols) ≠ size(ten_vals)
            msg = "The assigned array size does not equal the array's size."
            throw(ErrorException(msg))
        end
        if isa(ten_vals, Array)
            mtx = ten_vals
        else
            mtx = zeros(Float64, Int64(arr_len), Int64(ten_rows), Int64(ten_cols))
            for i in 1:arr_len
                for j in 1:ten_rows
                    for k in 1:ten_cols
                        mtx[i,j,k] = convert(Float64, ten_vals[i,j,k])
                    end
                end
            end
        end
        new(UInt32(arr_len), UInt8(ten_rows), UInt8(ten_cols), mtx, units)
    end
end

#=
-------------------------------------------------------------------------------
=#

# Helper types used for reading and writing objects from/to a JSON3.jl file.
# These lower types are not intended for general use.

struct LowerVector
    lv::Vector{Float64}

    # constructor

    function LowerVector(vector::AbstractVector)
        len = length(vector)
        vec = zeros(Float64, len)
        for i in 1:len
            vec[i] = convert(Float64, vector[i])
        end
        new(vec)
    end
end

struct LowerMatrix
    lr::Int64
    lc::Int64
    lv::LowerVector

    # constructors

    function LowerMatrix(rows::Integer, cols::Integer, vector::AbstractVector)
        if rows*cols ≠ length(vector)
            msg = "Matrix dimensions do not match those of the vector."
            throw(ErrorException(msg))
        end
        new(Int64(rows), Int64(cols), LowerVector(vector))
    end

    function LowerMatrix(rows::Integer, cols::Integer, vector::LowerVector)
        if rows*cols ≠ length(vector.lv)
            msg = "Matrix dimensions do not match those of the vector."
            throw(ErrorException(msg))
        end
        new(Int64(rows), Int64(cols), vector)
    end
end

struct LowerArray
    le::Int64
    lr::Int64
    lc::Int64
    lv::LowerVector

    # constructor

    function LowerArray(entries::Integer, rows::Integer, cols::Integer, vector::AbstractVector)
        if entries*rows*cols ≠ length(vector)
            msg = "Array dimensions do not match those of the vector."
            throw(ErrorException(msg))
        end
        new(Int64(entries), Int64(rows), Int64(cols), LowerVector(vector))
    end

    function LowerArray(entries::Integer, rows::Integer, cols::Integer, vector::LowerVector)
        if entries*rows*cols ≠ length(vector)
            msg = "Array dimensions do not match those of the vector."
            throw(ErrorException(msg))
        end
        new(Int64(entries), Int64(rows), Int64(cols), vector)
    end
end

struct LowerPhySca
    lx::Float64
    lu::LowerUnits

    # constructor

    function LowerPhySca(s::PhysicalScalar)
        lx = get(s)
        lu = LowerUnits(s.u)
        new(lx, lu)
    end

    function LowerPhySca(x::Real, lu::LowerUnits)
        lx = convert(Float64, x)
        new(lx, lu)
    end
end

struct LowerPhyVec
    lv::LowerVector
    lu::LowerUnits

    # constructor

    function LowerPhyVec(pv::PhysicalVector)
        new(LowerVector(pv.v), LowerUnits(pv.u))
    end

    function LowerPhyVec(lv::LowerVector, lu::LowerUnits)
        new(lv, lu)
    end
end

struct LowerPhyTen
    lm::LowerMatrix
    lu::LowerUnits

    # constructors

    function LowerPhyTen(pt::PhysicalTensor)
        lm = LowerMatrix(pt.r, pt.c, LowerVector(vec(pt.m)))
        lu = LowerUnits(pt.u)
        new(lm, lu)
    end

    function LowerPhyTen(lm::LowerMatrix, lu::LowerUnits)
        new(lm, lu)
    end
end

struct LowerArrPhySca
    lv::LowerVector
    lu::LowerUnits

    # constructors

    function LowerArrPhySca(aps::ArrayOfPhysicalScalars)
        lv = LowerVector(aps.a)
        lu = LowerUnits(aps.u)
        new(lv, lu)
    end

    function LowerArrPhySca(lv::LowerVector, lu::LowerUnits)
        new(lv, lu)
    end
end

struct LowerArrPhyVec
    lm::LowerMatrix
    lu::LowerUnits

    # constructors

    function LowerArrPhyVec(apv::ArrayOfPhysicalVectors)
        lm = LowerMatrix(apv.e, apv.l, LowerVector(vec(apv.a)))
        lu = LowerUnits(apv.u)
        new(lm, lu)
    end

    function LowerArrPhyVec(lm::LowerMatrix, lu::LowerUnits)
        new(lm, lu)
    end
end

struct LowerArrPhyTen
    la::LowerArray
    lu::LowerUnits

    # constructors

    function LowerArrPhyTen(apt::ArrayOfPhysicalTensors)
        la = LowerArray(apt.e, apt.r, apt.c, LowerVector(vec(apt.a)))
        lu = LowerUnits(apt.u)
        new(la, lu)
    end

    function LowerArrPhyTen(la::LowerArray, lu::LowerUnits)
        new(la, lu)
    end
end

# Methods required to serialize (write to file) instances of these types.

function Base.:(length)(lv::LowerVector)::Integer
    return length(lv.lv)
end

function Base.:(iterate)(lv::LowerVector)
    iterate(lv.lv)
end

function Base.:(iterate)(lv::LowerVector, i::Int64)
    iterate(lv.lv, i)
end

function Vector(lv::LowerVector)::Vector
    return lv.lv
end

function Matrix(lm::LowerMatrix)::Matrix
    mtx = zeros(Float64, lm.lr, lm.lc)
    row = 1
    col = 1
    for i in 1:lm.lr*lm.lc
        mtx[row,col] = lm.lv.lv[i]
        if row < lm.lr
            row += 1
        else
            row = 1
            col += 1
        end
    end
    return mtx
end

function Array(la::LowerArray)::Array
    arr = zeros(Float64, la.le, la.lr, la.lc)
    ent = 1
    row = 1
    col = 1
    for i in 1:la.le*la.lr*la.lc
        arr[ent,row,col] = la.lv.lv[i]
        if ent < la.le
            ent += 1
        elseif row < la.lr
            ent = 1
            row += 1
        else
            ent = 1
            row = 1
            col += 1
        end
    end
    return arr
end

function PhysicalScalar(ls::LowerPhySca)::PhysicalScalar
    px = MReal(ls.lx)
    pu = PhysicalUnits(ls.lu)
    return PhysicalScalar(px, pu)
end

function PhysicalVector(lv::LowerPhyVec)::PhysicalVector
    pl = length(lv.lv)
    pv = Vector(lv.lv)
    pu = PhysicalUnits(lv.lu)
    return PhysicalVector(pl, pv, pu)
end

function PhysicalTensor(lt::LowerPhyTen)::PhysicalTensor
    pr = lt.lm.lr
    pc = lt.lm.lc
    pm = Matrix(lt.lm)
    pu = PhysicalUnits(lt.lu)
    return PhysicalTensor(pr, pc, pm, pu)
end

function ArrayOfPhysicalScalars(las::LowerArrPhySca)::ArrayOfPhysicalScalars
    al = length(las.lv.lv)
    sa = Vector(las.lv)
    su = PhysicalUnits(las.lu)
    return ArrayOfPhysicalScalars(al, sa, su)
end

function ArrayOfPhysicalVectors(lav::LowerArrPhyVec)::ArrayOfPhysicalVectors
    al = lav.lm.lr
    vl = lav.lm.lc
    va = Matrix(lav.lm)
    vu = PhysicalUnits(lav.lu)
    return ArrayOfPhysicalVectors(al, vl, va, vu)
end

function ArrayOfPhysicalTensors(lat::LowerArrPhyTen)::ArrayOfPhysicalTensors
    al = lat.la.le
    tr = lat.la.lr
    tc = lat.la.lc
    ta = Array(lat.la)
    tu = PhysicalUnits(lat.lu)
    return ArrayOfPhysicalTensors(al, tr, tc, ta, tu)
end

#=
-------------------------------------------------------------------------------
=#

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
    return PhysicalScalar(y.v[idx], y.u)
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
    return PhysicalScalar(y.m[row,col], y.u)
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
    return PhysicalScalar(y.a[idx], y.u)
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
    vec = PhysicalVector(y.l, y.u)
    for l in 1:y.l
        vec[l] = PhysicalScalar(y.a[idx,l], y.u)
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
    mtx = PhysicalTensor(y.r, y.c, y.u)
    for r in 1:y.r
        for c in 1:y.c
            mtx[r,c] = PhysicalScalar(y.a[idx,r,c], y.u)
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

#=
-------------------------------------------------------------------------------
=#

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

#=
-------------------------------------------------------------------------------
=#

# Reading from and writing to a JSON file.
StructTypes.StructType(::Type{LowerVector}) = StructTypes.ArrayType()
StructTypes.StructType(::Type{LowerMatrix}) = StructTypes.Struct()
StructTypes.StructType(::Type{LowerArray})  = StructTypes.Struct()

StructTypes.StructType(::Type{LowerPhySca}) = StructTypes.Struct()
StructTypes.StructType(::Type{LowerPhyVec}) = StructTypes.Struct()
StructTypes.StructType(::Type{LowerPhyTen}) = StructTypes.Struct()

StructTypes.StructType(::Type{LowerArrPhySca}) = StructTypes.Struct()
StructTypes.StructType(::Type{LowerArrPhyVec}) = StructTypes.Struct()
StructTypes.StructType(::Type{LowerArrPhyTen}) = StructTypes.Struct()

function toFile(y::PhysicalScalar, json_stream::IOStream)
    if isopen(json_stream)
        ls = LowerPhySca(y)
        JSON3.write(json_stream, ls)
        write(json_stream, '\n')
    else
        msg = "The supplied JSON stream is not open."
        throw(ErrorException(msg))
    end
    flush(json_stream)
    return nothing
end

function toFile(y::PhysicalVector, json_stream::IOStream)
    if isopen(json_stream)
        lv = LowerPhyVec(y)
        JSON3.write(json_stream, lv)
        write(json_stream, '\n')
    else
        msg = "The supplied JSON stream is not open."
        throw(ErrorException(msg))
    end
    flush(json_stream)
    return nothing
end

function toFile(y::PhysicalTensor, json_stream::IOStream)
    if isopen(json_stream)
        lt = LowerPhyTen(y)
        JSON3.write(json_stream, lt)
        write(json_stream, '\n')
    else
        msg = "The supplied JSON stream is not open."
        throw(ErrorException(msg))
    end
    flush(json_stream)
    return nothing
end

function toFile(y::ArrayOfPhysicalScalars, json_stream::IOStream)
    if isopen(json_stream)
        las = LowerArrPhySca(y)
        JSON3.write(json_stream, las)
        write(json_stream, '\n')
    else
        msg = "The supplied JSON stream is not open."
        throw(ErrorException(msg))
    end
    flush(json_stream)
    return nothing
end

function toFile(y::ArrayOfPhysicalVectors, json_stream::IOStream)
    if isopen(json_stream)
        lav = LowerArrPhyVec(y)
        JSON3.write(json_stream, lav)
        write(json_stream, '\n')
    else
        msg = "The supplied JSON stream is not open."
        throw(ErrorException(msg))
    end
    flush(json_stream)
    return nothing
end

function toFile(y::ArrayOfPhysicalTensors, json_stream::IOStream)
    if isopen(json_stream)
        lat = LowerArrPhyTen(y)
        JSON3.write(json_stream, lat)
        write(json_stream, '\n')
    else
        msg = "The supplied JSON stream is not open."
        throw(ErrorException(msg))
    end
    flush(json_stream)
    return nothing
end

function fromFile(::Type{PhysicalScalar}, json_stream::IOStream)::PhysicalScalar
    if isopen(json_stream)
        ls = JSON3.read(readline(json_stream), LowerPhySca)
        ps = PhysicalScalar(ls)
    else
        msg = "The supplied JSON stream is not open."
        throw(ErrorException(msg))
    end
    return ps
end

function fromFile(::Type{PhysicalVector}, json_stream::IOStream)::PhysicalVector
    if isopen(json_stream)
        lv = JSON3.read(readline(json_stream), LowerPhyVec)
        pv = PhysicalVector(lv)
    else
        msg = "The supplied JSON stream is not open."
        throw(ErrorException(msg))
    end
    return pv
end

function fromFile(::Type{PhysicalTensor}, json_stream::IOStream)::PhysicalTensor
    if isopen(json_stream)
        lt = JSON3.read(readline(json_stream), LowerPhyTen)
        pt = PhysicalTensor(lt)
    else
        msg = "The supplied JSON stream is not open."
        throw(ErrorException(msg))
    end
    return pt
end

function fromFile(::Type{ArrayOfPhysicalScalars}, json_stream::IOStream)::ArrayOfPhysicalScalars
    if isopen(json_stream)
        las = JSON3.read(readline(json_stream), LowerArrPhySca)
        aps = ArrayOfPhysicalScalars(las)
    else
        msg = "The supplied JSON stream is not open."
        throw(ErrorException(msg))
    end
    return aps
end

function fromFile(::Type{ArrayOfPhysicalVectors}, json_stream::IOStream)::ArrayOfPhysicalVectors
    if isopen(json_stream)
        lav = JSON3.read(readline(json_stream), LowerArrPhyVec)
        apv = ArrayOfPhysicalVectors(lav)
    else
        msg = "The supplied JSON stream is not open."
        throw(ErrorException(msg))
    end
    return apv
end

function fromFile(::Type{ArrayOfPhysicalTensors}, json_stream::IOStream)::ArrayOfPhysicalTensors
    if isopen(json_stream)
        lat = JSON3.read(readline(json_stream), LowerArrPhyTen)
        apt = ArrayOfPhysicalTensors(lat)
    else
        msg = "The supplied JSON stream is not open."
        throw(ErrorException(msg))
    end
    return apt
end
