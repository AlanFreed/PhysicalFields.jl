
[Return to Main Document](.\README.md)

# MutableTypes

This part of the package provides mutable boolean, integer and real types, plus mutable 1D vector, 2D matrix, and 3D array types. Their arithmetic and indexing operators are overloaded. The package also exports wrappers for the more common math functions.

These mutable types form the foundation upon which all other types exported by this module are built upon. Persistence (the ability to be written-to and read-from a file) is considered a necessary property for `PhysicalField` objects to have, and all of the mutable types introduced here are persistent.

The intent of these mutable types is for their use in immutable data structures that contain a field or fields that need the capability to have their values changed during a runtime. For example, a data structure that holds material properties may include a boolean field *ruptured* that would get turned on (converted from false to true) after a rupture event has occurred, thereafter enabling a change in material properties to occur moving forward.

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
    b::Bool  # Bool <: Integer <: Real <: Number
end
```

Mutable integer numbers belong to the type:
```
mutable struct MInteger <: MNumber
    n::Int64  # Int64 <: Signed <: Integer <: Real <: Number
end
```

Mutable real numbers belong to the type:
```
mutable struct MReal <: MNumber
    n::Float64  # Float64 <: AbstractFloat <: Real <: Number
end
```

Mutable vectors (1D arrays) belong to the type:
```
struct MVector
    len::Integer            # The vector's length, which is not mutable.
    vec::Vector{Float64}    # A column vector whose entries are mutable.
end
```

Mutable matrices (2D arrays) belong to the type:
```
struct MMatrix
    rows::Integer           # Rows in a matrix, which is not mutable.
    cols::Integer           # Columns in a matrix, which is not mutable.
    vec::Vector{Float64}    # The matrix reshaped as a mutable column vector.
end
```
where vector `vec` indexes along the matrix's column vectors according to
```
index = row + (column - 1)*rows
```
so that, e.g., `matrix[row, column]` returns `matrix.vec[index].` All indexing is handled internally.

Mutable 3D arrays belong to the type:
```
struct MArray
    pgs::Integer            # Pages in an array, which is not mutable.
                            #    Each page contains a rows×cols matrix.
    rows::Integer           # Matrix rows in each page, which is not mutable.
    cols::Integer           # Matrix columns in each page, which is not mutable.
    vec::Vector{Float64}    # The 3D array reshaped as a mutable column vector.
end
```
where vector `vec` indexes along the array's columns according to
```
index = page + (row - 1)*pgs + (column - 1)*pgs*rows
```
so that, e.g., `array[page, row, column]` returns `array.vec[index].` All indexing is handled internally.

Mutable matrices and 3D arrays contain their components in a 1D format, viz., field `vec,` so that their data can be made persistent using the interface of package `JSON3.jl.`

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

For the mutable array types, there are constructors with one argument, e.g.,
```
    vec = MVector(vector::Vector{Float64})
    mtx = MMatrix(matrix::Matrix{Float64})
    arr = MArray(array::Array{Float64,3})
```
which take upon the appearance of a type casting.

There are also constructors containing only dimensioning arguments, e.g.,
```
   vec = MVector(length::Integer)
   mtx = MMatrix(rows::Integer, columns::Integer)
   arr = MArray(pages::Integer, rows::Integer, columns::Integer)
```
And, for JSON file structure compatibility, there are constructors
```
   vec = MVector(length::Integer, vector::Vector{Float64})
   mtx = MMatrix(rows::Integer, columns::Integer, vector::Vector{Float64})
   arr = MArray(pages::Integer, rows::Integer, columns::Integer, vector::Vector{Float64})
```
where `length(vec.vec) = length,` `length(mtx.vec) = rows*columns,` and `length(arr.vec) = pages*rows*columns.`

#### Type Casting

Julia's built-in types can be gotten from their mutable counterparts via the following type castings:
```
function Base.:(Bool)(mb::MBoolean)::Bool
function Base.:(Integer)(mi::MInteger)::Integer
function Base.:(Real)(mr::MReal)::Real
function Base.:(Vector)(mv::MVector)::Vector{Float64}
function Base.:(Matrix)(mm::MMatrix)::Matrix{Float64}
function Base.:(Array)(ma::MArray)::Array{Float64,3}
```
These methods, which are effectively constructors, are required internally to serialize and/or deserialize these objects when writing-to or reading-from a JSON file.

### Indexing

Instances of type `MVector` can be indexed for the purpose of getting or setting values at any element within the vector using standard notation, e.g., for getting `x = v[i]` and for setting `v[i] = x` where `x` is a real.

Instances of type `MMatrix` can be indexed in one of two ways. First, one can get or set a value from/to any element in the matrix, e.g., for getting a value `x = m[i,j]` and for setting a value `m[i,j] = x.` Second, one can get or set a row vector from/to any row in the matrix, e.g. for getting a row vector `v = m[i]` and setting a row vector `m[i] = v` provided that the length of row vector `v` equals the number of columns in the matrix. This is useful whenever an instance of `MMatrix` is used as a container to store a sequence of vectors, say gathered along some solution path.

Likewise, instances of type `MArray` can be indexed in one of two ways. First, one can get or set a value from/to any element in the array, e.g., for getting a value `x = a[i,j,k]` and for setting a value `a[i,j,k] = x.` Second, one can get or set a matrix from/to any page in the array, e.g. for getting a matrix `m = a[i]` and for setting a matrix `a[i] = m` provided that the dimensions of matrix `m` equal the number of rows and columns in the 3D array. This is useful whenever an instance of ` MArray` is used as a container to store a sequence of matrices, say gathered along some solution path.

### Readers and Writers

Methods have been created that write an object to its string representation for human consumption, and that read and write objects from and to a file for persistence. These methods take advantage of the multiple dispatch capability of the Julia compiler.

The chosen protocol for persistence requires that one knows the type belonging to an object to be read in before it can actually be read in. As implemented, these JSON streams do not store type information, i.e., meta data; they only store the fields of an object.

#### Write to a String

A method that converts mutable objects into human readable strings is:
```
function toString(y::MBoolean;
                  aligned::Bool=false)::String
function toString(y::MInteger;
                  aligned::Bool=false)::String
function toString(y::MReal;
                  format::Char='E',
                  precision::Int=5,
                  aligned::Bool=false)::String
function toString(mv::MVector;
                  format::Char='E')::String
function toString(y::MMatrix;
                  format::Char='E')::String
```
For the various `toString` interfaces listed above, their keywords are given default values that can be overwritten. Specifically, 

* `format`: An exponential or scientific output will be written whenever `format` is set to 'e' or 'E', the latter of which is the default; otherwise, the output will be written in a fixed-point notation.
* `precision`: The number of significant figures to be used in a numeric representation, precision ∈ {3, …, 7}, with 5 being the default, i.e., floating point numbers are truncated as a visual aid to the user.
* `aligned`: If `true,` a white space will appear before `true` when converting a `Bool` or `MBoolean` to string, or a white space will appear before the first digit in a number whenever its value is non-negative. Aligning is useful, e.g., when stacking outputs, like when printing out a matrix as a string. The default is `false.`

Method `toString` can also handle many of the built-in types of the Julia language. See method `toString` discussed in [README.md](.\README.md).

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
Argument `json_stream` comes from a call to function `openJSONReader` discussed in [README.md](.\README.md).

These methods require the object being read in be of known type, fore which a call to this method returns an object of the specified type. Meta programming is not used here.

#### Write to a File

To write instances the above mutable types to a JSON file, one can call the method
```
function toFile(y:MBoolean, json_stream::IOStream)
function toFile(y::MInteger, json_stream::IOStream)
function toFile(y::MReal, json_stream::IOStream)
function toFile(y::MVector, json_stream::IOStream)
function toFile(y::MMatrix, json_stream::IOStream)
function toFile(y::MArray, json_stream::IOStream)
```
Argument `json_stream` comes from a call to function `openJSONWriter` discussed in [README.md](.\README.md).

Methods `fromFile` and `toFile` can also handle many of the built-in types of the Julia language. These methods are discussed in [README.md](.\README.md).

## Methods

### get

A method that retrieves the fundamental value held by a field belonging to a basic mutable object:
```
function Base.:(get)(y::MBoolean)::Bool
function Base.:(get)(y::MInteger)::Integer
function Base.:(get)(y::MReal)::Real
```
Method `getindex` has been overloaded so that mutable vectors, matrices and 3D arrays, viz., `MVector,` `MMatrix` and `MArray,` can be indexed for retrieval via the standard [] notation. See the `Indexing` section above.

### set!

A method that assigns a fundamental value to a field belonging to a basic mutable object:
```
function set!(y::MBoolean, x::Bool)
function set!(y::MInteger, x::Integer)
function set!(y::MReal, x::Real)
```
Method `setindex!` has been overloaded so that mutable vectors, matrices and 3D arrays, viz., `MVector,` `MMatrix` and `MArray,` can be indexed for assignment via the standard [] notation. See the `Indexing` section above.

### copy

A method that makes shallow copies of mutable types:
```
function Base.:(copy)(y::MBoolean)::MBoolean
function Base.:(copy)(y::MInteger)::MInteger
function Base.:(copy)(y::MReal)::MReal
function Base.:(copy)(y::MVector)::MVector
function Base.:(copy)(y::MMatrix)::MMatrix
function Base.:(copy)(y::MArray)::MArray
```

### deepcopy

A method that makes deep copies of mutable types:
```
function Base.:(deepcopy)(y::MBoolean)::MBoolean
function Base.:(deepcopy)(y::MInteger)::MInteger
function Base.:(deepcopy)(y::MReal)::MReal
function Base.:(deepcopy)(y::MVector)::MVector
function Base.:(deepcopy)(y::MMatrix)::MMatrix
function Base.:(deepcopy)(y::MArray)::MArray
```

## Overloaded Operators

Many operators have been overloaded; specifically:

  * `MBoolean:`		==, ≠, \!

  * `MInteger:`		==, ≠, \<, ≤, ≥, \>, \+, \-, \*, ÷, %, ^

  * `MReal:`		==, ≠, ≈, \<, ≤, ≥, \>, \+, \-, \*, /, ^

  * `MVector:`		==, ≠, ≈, \+, \-, \*, /

  * `MMatrix:`		==, ≠, ≈, \+, \-, \*, /, `\`

where the last operator solves a linear system of equations, e.g., given a matrix **A** and a vector **b**, the linear system of equations **Ax** = **b** is solved for vector **x**. This is written in code as `x = A\b`.

  * `MArray:`		==, ≠, ≈


## Math Functions

### Methods specific to the `MReal` type.

```
function Base.:(round)(y::MReal)::Real
function Base.:(ceil)(y::MReal)::Real
function Base.:(floor)(y::MReal)::Real
```

### Methods common to both numeric mutable types, viz., `MInteger` and `MReal.`

```
function Base.:(abs)(y::MNumber)::Real
function Base.:(sign)(y::MNumber)::Real
function Base.:(sqrt)(y::MNumber)::Real
function Base.:(sin)(y::MNumber)::Real
function Base.:(cos)(y::MNumber)::Real
function Base.:(tan)(y::MNumber)::Real
function Base.:(sinh)(y::MNumber)::Real
function Base.:(cosh)(y::MNumber)::Real
function Base.:(tanh)(y::MNumber)::Real
function Base.:(asin)(y::MNumber)::Real
function Base.:(acos)(y::MNumber)::Real
function Base.:(atan)(y::MNumber)::Real
function Base.:(atan)(y::MNumber, x::MNumber)::Real
function Base.:(atan)(y::MNumber, x::Real)::Real
function Base.:(atan)(y::Real, x::MNumber)::Real
function Base.:(asinh)(y::MNumber)::Real
function Base.:(acosh)(y::MNumber)::Real
function Base.:(atanh)(y::MNumber)::Real
function Base.:(log)(y::MNumber)::Real
function Base.:(log2)(y::MNumber)::Real
function Base.:(log10)(y::MNumber)::Real
function Base.:(exp)(y::MNumber)::Real
function Base.:(exp2)(y::MNumber)::Real
function Base.:(exp10)(y::MNumber)::Real
```
where, trigonometrically speaking, `y` is the rise and `x` is the run in the `atan` methods with two arguments.

### Methods for `MVector.`

To get the p-norm, which defaults to the Euclidean norm, call method:
```
function LinearAlgebra.:(norm)(y::MVector, p::Real=2)::Real
```

To get a unit vector, call method:
```
function unitVector(y::MVector)::Vector{Float64}
function unitVector(y::Vector{Float64})::Vector{Float64}
```

To compute the cross product between two vectors, i.e., `y × z,` call method:
```
function LinearAlgebra.:(cross)(y::MVector, z::MVector)::Vector{Float64}
function LinearAlgebra.:(cross)(y::Vector{Float64}, z::MVector)::Vector{Float64}
function LinearAlgebra.:(cross)(y::MVector, z::Vector{Float64})::Vector{Float64}
```
The cross product is only defined for vectors of length 3.

### Functions for `MMatrix`

To get the p-norm, which defaults to the Frobenius norm, call method:
```
function LinearAlgebra.:(norm)(y::MMatrix, p::Real=2)::Real
```

To get the transpose of a matrix, call method:
```
function Base.:(transpose)(y::MMatrix)::Matrix{Float64}
```

To get the trace of a matrix, call method:
```
function LinearAlgebra.:(tr)(y::MMatrix)::Real
```

To get the determinant of a matrix, call method:
```
function LinearAlgebra.:(det)(y::MMatrix)::Real
```

To get the inverse of a matrix, if it exists, call method:
```
function Base.:(inv)(y::MMatrix)::Matrix{Float64}
```

To get the QR or Gram-Schmidt decomposition of a matrix, call method:
```
function qr(y::Matrix{Float64})::Tuple
function qr(y::MMatrix)::Tuple
```
For example, `(Q, R) = qr(matrix)` where matrix `Q` is orthogonal and matrix `R` is upper triangular.

To get the LQ decomposition of a matrix, call method:
```
function lq(y::Matrix{Float64})::Tuple
unction lq(y::MMatrix)::Tuple
```
For example, `(L, Q) = lq(matrix)` where matrix `L` is lower triangular and matrix `Q` is orthogonal.

To construct a matrix as a product between two vectors, e.g., `m[i,j] = y[i] z[j],` call method:
```
function matrixProduct(y::Vector{Float64}, z::Vector{Float64})::Matrix{Float64}
function matrixProduct(y::MVector, z::MVector)::Matrix{Float64}
function matrixProduct(y::Vector{Float64}, z::MVector)::Matrix{Float64}
function matrixProduct(y::MVector, z::Vector{Float64})::Matrix{Float64}
```

## Note

All methods, operators and math functions pertaining to these types (except for `copy` and `deepcopy`) return instances belonging to their associated core types: viz., `Bool,` `Integer,` `Real,` `Vector{Float64},` `Matrix{Float64}` or `Array{Float64,3}.` This is because their intended use is to permit mutable fields to be incorporated into what are otherwise immutable data structures; thereby, allowing such fields to have a potential to change their values. As such, mutable fields belonging to immutable data structures will have the necessary infrastructure to be able to be used seamlessly in simple mathematical formulae outside their defining data structures.

[Home Page](.\README.md)

[Next Page](.\README_PhysicalUnits.md)
