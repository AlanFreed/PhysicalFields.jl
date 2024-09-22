
[Return to Main Document](.\README.md)

# MutableTypes

This part of the package provides mutable boolean, integer and real types, plus mutable 1D vector, 2D matrix, and 3D array types. Their arithmetic and indexing operators are overloaded. The package also exports wrappers for the more common math functions. These mutable types form a foundation upon which all other types exported by this module are built upon.

The intent of mutable types is for their use in immutable data structures that contain a field or fields that need the capability to have their values changed during a runtime. For example, a data structure that holds material properties may include a boolean field *ruptured* that would get turned on (converted from *false* to *true*) after a rupture event has occurred, thereafter enabling a change in material properties to occur moving forward.

## Abstract Type

Mutable numeric types are sub-types to abstract type:

```
abstract type MNumber <: Number end
```

## Concrete Types

Mutable types are wrappers around basic, numeric, Julia types.

Mutable boolean values belong to the type:
```
mutable struct MBoolean
    b::Bool    # Bool <: Integer <: Real <: Number
end
```

Mutable integer numbers belong to the type:
```
mutable struct MInteger <: MNumber
    n::Int64    # Int64 <: Signed <: Integer <: Real <: Number
end
```

Mutable real numbers belong to the type:
```
mutable struct MReal <: MNumber
    n::Float64    # Float64 <: AbstractFloat <: Real <: Number
end
```

Mutable vectors (1D arrays) belong to the type:
```
struct MVector
    len::UInt32             # Length of a vector, which is fixed.
    vec::Vector{Float64}    # Column vector with mutable elements.
end
```
whose whose elements `vec` are mutable, but whose dimension (length `len)` is immutable.

Mutable matrices (2D arrays) belong to the type:
```
struct MMatrix
    rows::UInt16            # Rows in a matrix, which is fixed.
    cols::UInt16            # Columns in a matrix, which is fixed.
    vec::Vector{Float64}    # Matrix reshaped as a column vector with mutable elements.
end
```
whose elements `vec` are mutable, but whose dimensions (rows `rows` and columns `cols)` are immutable. Vector `vec` indexes along the matrix's column vectors according to the mapping
```
index = row + (column - 1)*rows
```
so that, e.g., `matrix[row, column]` returns `matrix.vec[index].` All indexing is handled internally.

Mutable 3D arrays belong to the type:
```
struct MArray
    pp::UInt16              # Pages in an array, which is fixed.
    rows::UInt16            # Matrix rows in each page, which is fixed.
    cols::UInt16            # Matrix columns in each page, which is fixed.
    vec::Vector{Float64}    # Array reshaped as a vector with mutable elements.
end
```
whose elements `vec` are mutable, but whose dimensions (pages `pp,` rows `rows` and columns `cols)` are immutable. Each page contains a `rows`×`cols` matrix. Vector `vec` indexes along the array's columns according to the mapping
```
index = page + (row - 1)*pp + (column - 1)*pp*rows
```
so that, e.g., `array[page, row, column]` returns `array.vec[index].` All indexing is handled internally.

Mutable matrices and 3D arrays originally contained their components in a 1D format, viz., field `vec,` so that their data could be made persistent using the interface of package `JSON3.jl.` Since then `JSON3` has evolved into a much more robust package so this restriction is no longer necessary; nevertheless, matrices and 3D arrays used herein continue to be handled in memory in their column vector representations.

### Constructors

All mutable types have multiple inner constructors. No external constructors are provided.

For the basic mutable types, there are constructors without arguments, e.g.,
```
	b = MBoolean()     # b = false
	i = MInteger()     # i = 0
	x = MReal()        # x = 0.0
```
which assign values of zero to their respective types, with an `MBoolean` being assigning a value of `false.`

There are also constructors with a single argument, e.g., 
```
	b = MBoolean(y::Bool)
	i = MInteger(y::Integer)
	x = MReal(y::Real)
```
which take on the appearance of a type casting.

For the mutable array types, there are constructors that dimension the arrays and then initialize their entries with zeros, e.g.,
```
   vec = MVector(length::Integer)
   mtx = MMatrix(rows::Integer, columns::Integer)
   arr = MArray(pages::Integer, rows::Integer, columns::Integer)
```
There are also constructors that create mutable arrays from supplied arrays, viz.,
```
    vec = MVector(vector::Vector{<:Real})
    mtx = MMatrix(matrix::Matrix{<:Real})
    arr = MArray(array::Array{<:Real,3})
```
which take upon the appearance of a type casting, and there are the general constructors
```
   vec = MVector(length::Integer, vector::Vector{<:Real})
   mtx = MMatrix(rows::Integer, columns::Integer, vector::Vector{<:Real})
   arr = MArray(pages::Integer, rows::Integer, columns::Integer, vector::Vector{<:Real})
```
where `length(vec.vec) = length,` `length(mtx.vec) = rows*columns` and `length(arr.vec) = pages*rows*columns.`

#### Type Casting

Julia's built-in types can be gotten from their mutable counterparts via the following type castings:
```
function Base.:(Bool)(mb::MBoolean)::Bool
function Base.:(Integer)(mi::MInteger)::Integer
function Base.:(Real)(mr::MReal)::Real
function Base.:(Vector)(mv::MVector)::Vector{<:Real}
function Base.:(Matrix)(mm::MMatrix)::Matrix{<:Real}
function Base.:(Array)(ma::MArray)::Array{<:Real,3}
```
These methods, which are effectively constructors, are required internally to serialize and/or deserialize these objects when writing-to or reading-from a JSON file.

### Indexing

Instances of type `MVector` can be indexed for the purpose of getting or setting values at any element within the vector using standard notation, e.g., for getting `x = v[i]` and for setting `v[i] = x` where `x` is a real.

Instances of type `MMatrix` can be indexed in one of two ways. First, one can get or set a value from or to any element in the matrix, e.g., for getting a value `x = m[i,j]` and for setting a value `m[i,j] = x.` Second, one can get or set a row vector from or to any row in the matrix, e.g. for getting a row vector `v = m[i]` and setting a row vector `m[i] = v` provided that the length of row vector `v` equals the number of columns in the matrix. This is useful whenever an instance of `MMatrix` is used as a container to store a sequence of vectors, say gathered along some solution path.

Likewise, instances of type `MArray` can be indexed in one of two ways. First, one can get or set a value from or to any element in the array, e.g., for getting a value `x = a[i,j,k]` and for setting a value `a[i,j,k] = x.` Second, one can get or set a matrix from or to any page in the array, e.g. for getting a matrix `m = a[i]` and for setting a matrix `a[i] = m` provided that the dimensions of matrix `m` equal the number of rows and columns in the 3D array. This is useful whenever an instance of ` MArray` is used as a container to store a sequence of matrices, say gathered along some solution path.

### Readers and Writers

The methods of [Persistence](./README.Persistence.md) are extended here via the multiple dispatch capability of the `Julia` language.

#### Write to a String

A method that converts mutable objects into human readable strings is:
```
function toString(y::MBoolean)::String
function toString(y::MInteger)::String
function toString(y::MReal)::String
function toString(y::MVector)::String
function toString(y::MMatrix)::String
```

#### Write to a File

To write instances of the above mutable types to a JSON file, one can call the method
```
function toFile(y::MBoolean, json_stream::IOStream)
function toFile(y::MInteger, json_stream::IOStream)
function toFile(y::MReal, json_stream::IOStream)
function toFile(y::MVector, json_stream::IOStream)
function toFile(y::MMatrix, json_stream::IOStream)
function toFile(y::MArray, json_stream::IOStream)
```
Argument `json_stream` comes from a call to function `openJSONWriter` discussed [here](.\README_Persistence.md).

#### Read from a File

To read instances of the above mutable types from a JSON file, one can call the method
```
function fromFile(::Type{MBoolean}, json_stream::IOStream)::MBoolean
function fromFile(::Type{MInteger}, json_stream::IOStream)::MInteger
function fromFile(::Type{MReal}, json_stream::IOStream)::MReal
function fromFile(::Type{MVector}, json_stream::IOStream)::MVector
function fromFile(::Type{MMatrix}, json_stream::IOStream)::MMatrix
function fromFile(::Type{MArray}, json_stream::IOStream)::MArray
```
Argument `json_stream` comes from a call to function `openJSONReader` discussed [here](.\README_Persistence.md).

Methods `toFile` and `fromFile` can also handle many of the built-in types of the `Julia` language, see [here](.\README_Persistence.md).

## Basic Methods

The get, set, copy and dimensioning methods.

For MBoolean:
```julia
    function get(y::MBoolean)::Bool
    function set!(y::MBoolean, x::Bool)
    function copy(y::MBoolean)::MBoolean
```

For MInteger:
```julia
    function get(y::MInteger)::Integer
    function set!(y::MInteger, x::Integer)
    function copy(y::MInteger)::MInteger
```

For MReal:
```julia
    function get(y::MReal)::Real
    function set!(y::MReal, x::Real)
    function copy(y::MReal)::MReal
```

For MVector:
```julia
    function getindex(y::MVector, index::Integer)::Real
    function setindex!(y::MVector, value::Real, index::Integer)
    function copy(y::MVector)::MVector
    function length(y::MVector)::Integer
    function size(y::MVector)::Tuple
```

For MMatrix:
```julia
    function getindex(y::MMatrix, row::Integer)::Vector{<:Real}
    function getindex(y::MMatrix, row::Integer, column::Integer)::Real
    function setindex!(y::MMatrix, value::Vector{<:Real}, row::Integer)
    function setindex!(y::MMatrix, value::Real, row::Integer, column::Integer)
    function copy(y::MMatrix)::MMatrix
    function size(y::MMatrix)::Tuple
```

And for MArray:
```julia
    function getindex(y::MArray, page::Integer)::Matrix{<:Real}
    function getindex(y::MArray, page::Integer, row::Integer, column::Integer)::Real
    function setindex!(y::MArray, value::Matrix{<:Real}, page::Integer)
    function setindex!(y::MArray, value::Real, page::Integer, row::Integer, column::Integer)
    function copy(y::MArray)::MArray
    function size(y::MArray)::Tuple
```

## Overloaded Operators

Many operators have been overloaded; specifically:

  * `MBoolean:`		==, ≠, \!

  * `MInteger:`		==, ≠, \<, ≤, ≥, \>, \+, \-, \*, ÷, %, ^

  * `MReal:`		==, ≠, ≈, \<, ≤, ≥, \>, \+, \-, \*, /, ^

  * `MVector:`		==, ≠, ≈, \+, \-, \*, /

  * `MMatrix:`		==, ≠, ≈, \+, \-, \*, /, `\`

  * `MArray:`		==, ≠, ≈

where the last `MMatrix` operator solves a linear system of equations, e.g., given a matrix **A** and a vector **b**, the linear system of equations **Ax** = **b** is solved for vector **x**. This is written in code as `x = A\b`.


## Math Functions

These math functions extend their corresponding methods in `Base` and `LinearAlgebra.`

### Methods specific to the `MReal` type.

```
function round(y::MReal)::Integer
function ceil(y::MReal)::Integer
function floor(y::MReal)::Integer
```
which return instances of type `Integer,` not `MInteger,` because `MInteger`'s are intended to represent mutable fields in an immutable data `struct.`

### Methods common to both numeric mutable types, viz., `MInteger` and `MReal.`

```
function abs(y::MNumber)::Real
function sign(y::MNumber)::Real
function sqrt(y::MNumber)::Real
function sin(y::MNumber)::Real
function cos(y::MNumber)::Real
function tan(y::MNumber)::Real
function sinh(y::MNumber)::Real
function cosh(y::MNumber)::Real
function tanh(y::MNumber)::Real
function asin(y::MNumber)::Real
function acos(y::MNumber)::Real
function atan(y::MNumber)::Real
function atan(y::MNumber, x::MNumber)::Real
function atan(y::MNumber, x::Real)::Real
function atan(y::Real, x::MNumber)::Real
function asinh(y::MNumber)::Real
function acosh(y::MNumber)::Real
function atanh(y::MNumber)::Real
function log(y::MNumber)::Real
function log2(y::MNumber)::Real
function log10(y::MNumber)::Real
function exp(y::MNumber)::Real
function exp2(y::MNumber)::Real
function exp10(y::MNumber)::Real
```
which return instances of type `Real,` not `MReal,` because `MReal`'s are intended to represent mutable fields in an immutable data `struct.`
Trigonometrically speaking, `y` is the rise and `x` is the run in the `atan` method with two arguments.

### Methods for `MVector.`

To get the p-norm, which defaults to the Euclidean norm, call method:
```
function norm(y::MVector, p::Real=2)::Real
```

To get a unit vector, call method:
```
function unitVector(y::MVector)::MVector
function unitVector(y::Vector{<:Real})::MVector
```

To compute the cross product between two vectors, i.e., `y × z,` call method:
```
function cross(y::MVector, z::MVector)::MVector
function cross(y::Vector{<:Real}, z::MVector)::MVector
function cross(y::MVector, z::Vector{<:Real})::MVector
```
The cross product is only defined for vectors of length 3.

Functions on a `MVector` return a `MVector,` unlike functions on a `MInteger` or `MReal,` which return an `Integer` or a `Real`.

### Functions for `MMatrix`

To get the p-norm, which defaults to the Frobenius norm, call method:
```
function norm(y::MMatrix, p::Real=2)::Real
```

To get the transpose of a matrix, call method:
```
function transpose(y::MMatrix)::MMatrix
```

To get the trace of a matrix, call method:
```
function tr(y::MMatrix)::Real
```

To get the determinant of a matrix, call method:
```
function det(y::MMatrix)::Real
```

To get the inverse of a matrix, if it exists, call method:
```
function inv(y::MMatrix)::MMatrix
```

To get the **QR** or Gram-Schmidt decomposition of a matrix, call method:
```
function qr(y::Matrix{<:Real})::Tuple
function qr(y::MMatrix)::Tuple
```
For example, `(Q, R) = qr(matrix)` where matrix `Q` is orthogonal and matrix `R` is upper triangular.

To get the **LQ** decomposition of a matrix, call method:
```
function lq(y::Matrix{<:Real})::Tuple
unction lq(y::MMatrix)::Tuple
```
For example, `(L, Q) = lq(matrix)` where matrix `L` is lower triangular and matrix `Q` is orthogonal.

To construct a matrix as a product between two vectors, e.g., `m[i,j] = y[i] z[j],` call method:
```
function matrixProduct(y::Vector{<:Real}, z::Vector{<:Real})::Matrix{<:Real}
function matrixProduct(y::MVector, z::MVector)::MMatrix
function matrixProduct(y::Vector{<:Real}, z::MVector)::MMatrix
function matrixProduct(y::MVector, z::Vector{<:Real})::MMatrix
```

[Home Page](.\README.md)
[Prev Page](.\README_Persistence.md)
[Next Page](.\README_PhysicalUnits.md)
