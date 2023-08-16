[Return to Main Document](.\README.md)

# PhysicalTensors

A physical tensor, or tensor field, is a matrix (a two-dimensional array) of numbers associated with a set of physical units, e.g., stress.

## Concrete Types

For a tensor field, use the type
```
struct PhysicalTensor <: PhysicalField
    r::UInt8            # rows in the matrix representation of a tensor
    c::UInt8            # columns in the matrix representation of a tensor
    m::Matrix           # values of a tensor in its specified system of units
    u::PhysicalUnits    # physical units of the tensor
end
```
while for an array of a tensor fields, use the type
```
struct ArrayOfPhysicalTensors
    e::UInt32           # number of entries or elements held in the array
    r::UInt8            # rows for each physical tensor held in the array
    c::UInt8            # columns for each physical tensor held in the array
    a::Array            # array of matrices holding values of a physical tensor
    u::PhysicalUnits    # physical units of the tensor array
end
```
where all tensor entries in the array have the same dimensions (rows by columns) and the same physical units.

## Constructors

There are two internal constructors. The first assumes the matrix values of its field are all zero, while the second assigns a matrix value to this field.

### PhysicalTensor

Constructors
```
function PhysicalTensor(rows::Integer, cols::Integer, units::PhysicalUnits)
function PhysicalTensor(rows::Integer, cols::Integer, matrix::Matrix, units::PhysicalUnits)
```
These constructors will return a new tensor object of dimension `rows`×`cols,` which must both be within the range of 1…255. The physical units of the tensor are specified by argument `units.` The first constructor assigns numeric values of zero to each element of the matrix field. The second constructor assigns numeric values to the matrix field, as specified by argument `matrix.`

Constructors
```
function ArrayOfPhysicalTensors(arr_len::Integer, ten_rows::Integer, ten_cols::Integer, units::PhysicalUnits)
function ArrayOfPhysicalTensors(arr_len::Integer, ten_rows::Integer, ten_cols::Integer, ten_vals::Array, units::PhysicalUnits)
```
These constructors will return a new array of tensor objects of like dimensions (rows × columns) and physical units. The length of the array of tensors is specified by argument `arr_len,` which must be within the range of 1…4,294,967,295. The dimensions of each tensor held by this array are the same, and are specified by arguments `ten_rows` and `ten_cols,` both of which must lie within the range of 1…255. The physical units for each of these tensors are the same, and is specified by argument `units.` The first constructor assigns numeric values of zero to each element of each matrix entry held in the array. The second constructor assigns numeric values to each matrix field held in the array, as specified by argument `ten_vals,` which is a matrix of dimension `arr_len`×`ten_rows`×`ten_cols.`

## Methods

### Get and Set!

These methods are to be used to retrieve and assign a `PhysicalScalar` from/to an element in a `PhysicalTensor.`

```
function Base.:(getindex)(y::PhysicalTensor, idx::Integer)::PhysicalScalar
function Base.:(setindex!)(y::PhysicalTensor, val::PhysicalScalar, idx::Integer)
```

While these methods are to be used to retrieve and assign a `PhysicalTensor` from/to an `ArrayOfPhysicalTensors.`

```
function Base.:(getindex)(y::ArrayOfPhysicalTensors, idx::Integer)::PhysicalTensor
function Base.:(setindex!)(y::ArrayOfPhysicalTensors, val::PhysicalTensor, idx::Integer)
```

Because these methods extend the `Base` functions `getindex` and `setindex!`, *i)* the bracket notation `[,]` can be used to retrieve and assign a scalar field at a matrix location belonging to an instance of `PhysicalTensor`, and *ii)* the bracket notation `[]` can be used to retrieve and assign a tensor field at an array location belonging to an instance of `ArrayOfPhysicalTensors.`

## Copy

For making shallow copies, use
```
function Base.:(copy)(t::PhysicalTensor)::PhysicalTensor
function Base.:(copy)(at::ArrayOfPhysicalTensors)::ArrayOfPhysicalTensors
```
and for making deep copies, use
```
function Base.:(deepcopy)(t::PhysicalTensor)::PhysicalTensor
function Base.:(deepcopy)(at::ArrayOfPhysicalTensors)::ArrayOfPhysicalTensors
```

## Readers and Writers

To write a tensor or an array of tensors to a JSON file, one can call
```
function toFile(y::PhysicalTensor, json_stream::IOStream)
function toFile(y::ArrayOfPhysicalTensors, json_stream::IOStream)
```
where argument `json_stream` comes from a call to `openJSONWriter.` 

To read a tensor or an array of tensors from a JSON file, one can call
```
function fromFile(::Type{PhysicalTensor}, json_stream::IOStream)::PhysicalTensor
function fromFile(::Type{ArrayOfPhysicalTensors}, json_stream::IOStream)::ArrayOfPhysicalTensors
```
where argument `json_stream` comes from a call to `openJSONReader.` 

## Type conversions

Conversion to a string is provided for instances of `PhysicalTensor` by the method
```
function toString(t::PhysicalTensor; format::Char='E')::String
```
where the keyword `format` is a character that, whenever its value is 'E' or 'e', represents the tensor components in a scientific notation; otherwise, they will be represented in a fixed-point notation.

Conversion to a matrix of the values held by a tensor is provided by
```
function toMatrix(t::PhysicalTensor)::Matrix
```

Converting a tensor field between CGS and SI units is accomplished via
```
function toCGS(t::PhysicalTensor)::PhysicalTensor
function toSI(t::PhysicalTensor)::PhysicalTensor
```
and to convert an array of tensors between CGS and SI units, use
```
function toCGS(at::ArrayOfPhysicalTensors)::ArrayOfPhysicalTensors
function toSI(at::ArrayOfPhysicalTensors)::ArrayOfPhysicalTensors
```

## Unit Testing

To test a tensor or an array of tensors to see if they are dimensionless, call
```
function isDimensionless(t::PhysicalTensor)::Bool
function isDimensionless(at::ArrayOfPhysicalTensors)::Bool
```
To test a tensor or an array of tensors to see if they have CGS units, call
```
function isCGS(t::PhysicalTensor)::Bool
function isCGS(at::ArrayOfPhysicalTensors)::Bool
```
To test a tensor or an array of tensors to see if they have SI units, call
```
function isSI(t::PhysicalTensor)::Bool
function isSI(at::ArrayOfPhysicalTensors)::Bool
```

## Operators

The following operators have been overloaded so that they can handle objects of type `PhysicalTensor,` whenever such operations make sense, e.g., one cannot add two tensors with different units or different dimensions. 

The overloaded logical operators include: `==`, `≠` and `≈`. 

The overloaded unary operators include: `+` and `-`. 

The overloaded binary operators include: `+`, `-`, `*`, `/` and `\`, 

where the latter solves a linear system of equations, e.g., given a matrix **A** and a vector **b**, the linear system of equations **Ax** = **b** is solved for vector **x**. This is written in code as `x = A\b`.

## Math Functions for PhysicalTensor

To construct a tensor product between two vectors, typically written as `t = y⊗z` or in component notation as `tᵢⱼ = yᵢzⱼ`, use function
```
function tensorProduct(y::PhysicalVector, z::PhysicalVector)::PhysicalTensor
```

To get the transpose of a tensor, call method

```
function Base.:(transpose)(t::PhysicalTensor)::PhysicalTensor
```

To get the trace of a tensor, call method

```
function LinearAlgebra.:(tr)(t::PhysicalTensor)::PhysicalScalar
```

To get the determinant of a tensor, call method

```
function LinearAlgebra.:(det)(t::PhysicalTensor)::PhysicalScalar
```

To get the inverse of a tensor, when it exists, call method

```
function Base.:(inv)(t::PhysicalTensor)::PhysicalTensor
```

To get the **QR** or Gram-Schmidt decomposition of a tensor, when it exists, call method

```
function LinearAlgebra.:(qr)(t::PhysicalTensor)::Tuple
```
e.g., written in code as
```
(Q, R) = qr(t)
```
where **Q** is an orthogonal Gram rotation matrix, and **R** is an upper-triangular (right) matrix.

To get the **LQ** decomposition of a tensor, when it exists, call method
```
function LinearAlgebra.:(lq)(y::PhysicalMatrix)::Tuple
```
e.g., written in code as
```
(L, Q) = lq(t)
```
where **L** is a lower-triangular (left) matrix, and **Q** is an orthogonal rotation matrix.

*Note:* The rotation matrices returned by a **QR** matrix decomposition are not the same rotation matrices returned by an **LQ** matrix decomposition.

[Home Page](.\README.md)

[Previous Page](.\README_PhysicalVectors.md)