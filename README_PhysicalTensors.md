[Return to Main Document](.\README.md)

# PhysicalTensors

A physical tensor, or tensor field, is a matrix (a two-dimensional array) of numbers associated with a set of physical units, e.g., stress.

## Concrete Types

For a tensor field, use the type
```
struct PhysicalTensor <: PhysicalField
    matrix::MMatrix         # values of a tensor in its specified system of units
    units::PhysicalUnits    # physical units of the tensor
end
```
while for an array of a tensor fields, use the type
```
struct ArrayOfPhysicalTensors
    array::MArray           # array of matrices holding values of a physical tensor
    units::PhysicalUnits    # physical units of the tensor array
end
```
where all tensor entries in the array have the same dimensions (rows by columns) and the same physical units.

## Constructors

There are three internal constructors. The first assigns zeros to the array field. The second assigns a raw array of 64-bit reals of the appropriate dimension. And the third assigns a mutable array of the appropriate dimension.

### PhysicalTensor

Constructors
```
function PhysicalTensor(rows::Integer, columns::Integer, units::PhysicalUnits)
function PhysicalTensor(matrix::Matrix{Float64}, units::PhysicalUnits)
function PhysicalTensor(matrix::MMatrix, units::PhysicalUnits)
```
These constructors will return a new tensor object of dimension `rows`×`columns.` The physical units of the tensor are specified by argument `units.` The first constructor assigns numeric values of zero to each element of the matrix field. The other two constructors assign numeric values to their matrix field, as specified by argument `matrix.`

Constructors
```
function ArrayOfPhysicalTensors(array_length::Integer, tensor_rows::Integer, tensor_columns::Integer, units::PhysicalUnits)
function ArrayOfPhysicalTensors(array::Array{Float64,3}, units::PhysicalUnits)
function ArrayOfPhysicalTensors(array::MArray, units::PhysicalUnits)
```
These constructors will return a new array of tensor objects of like dimensions (rows × columns) and physical units. The length of the array of tensors is specified by argument `array_length.` The dimensions of each tensor held by this array are the same, and are specified by arguments `tensor_rows` and `tensor_columns.` The physical units for each of these tensors are the same, and is specified by argument `units.` The first constructor assigns numeric values of zero to each element of each matrix entry held in the array. The other two constructors assign numeric values to each matrix field held in the array, as specified by argument `array,` which is a matrix of dimension `array_length`×`tensor_rows`×`tensor_columns.`

## Methods

### Get and Set!

These methods are to be used to retrieve and assign a `PhysicalScalar` from/to an element in a `PhysicalTensor`
```
function Base.:(getindex)(y::PhysicalTensor, index::Integer)::PhysicalScalar
function Base.:(setindex!)(y::PhysicalTensor, scalar::PhysicalScalar, index::Integer)
```
while the following methods are to be used to retrieve and assign a `PhysicalTensor` from/to an `ArrayOfPhysicalTensors.`
```
function Base.:(getindex)(y::ArrayOfPhysicalTensors, index::Integer)::PhysicalTensor
function Base.:(setindex!)(y::ArrayOfPhysicalTensors, tensor::PhysicalTensor, index::Integer)
```

Because these methods extend the `Base` functions `getindex` and `setindex!`, *i)* the bracket notation `[,]` can be used to retrieve and assign a scalar field at a matrix location belonging to an instance of `PhysicalTensor`, and *ii)* the bracket notation `[]` can be used to retrieve and assign a tensor field at an array location belonging to an instance of `ArrayOfPhysicalTensors.`

## Copy

For making shallow copies, use
```
function Base.:(copy)(y::PhysicalTensor)::PhysicalTensor
function Base.:(copy)(y::ArrayOfPhysicalTensors)::ArrayOfPhysicalTensors
```
and for making deep copies, use
```
function Base.:(deepcopy)(y::PhysicalTensor)::PhysicalTensor
function Base.:(deepcopy)(y::ArrayOfPhysicalTensors)::ArrayOfPhysicalTensors
```

## Readers and Writers

To write a tensor or an array of tensors to a JSON file, one can call
```
function toFile(y::PhysicalTensor, json_stream::IOStream)
function toFile(y::ArrayOfPhysicalTensors, json_stream::IOStream)
```
where argument `json_stream` comes from a call to `openJSONWriter`  discussed on page [README.md](./README.md).

To read a tensor or an array of tensors from a JSON file, one can call
```
function fromFile(::Type{PhysicalTensor}, json_stream::IOStream)::PhysicalTensor
function fromFile(::Type{ArrayOfPhysicalTensors}, json_stream::IOStream)::ArrayOfPhysicalTensors
```
where argument `json_stream` comes from a call to `openJSONReader`  discussed on page [README.md](./README.md).

## Type conversions

Conversion to a string is provided for instances of `PhysicalTensor` by the method
```
function toString(y::PhysicalTensor; format::Char='E')::String
```
where the keyword `format` is a character that, whenever its value is 'E' or 'e', represents the tensor components in a scientific notation; otherwise, they will be represented in a fixed-point notation.

Conversion to a matrix of the values held by a tensor is provided by
```
function toMatrix(y::PhysicalTensor)::Matrix{Float64}
```

Converting a tensor field between SI and CGS units is accomplished via
```
function toSI(y::PhysicalTensor)::PhysicalTensor
function toCGS(y::PhysicalTensor)::PhysicalTensor
```
and to convert an array of tensors between CGS and SI units, use
```
function toSI(y::ArrayOfPhysicalTensors)::ArrayOfPhysicalTensors
function toCGS(y::ArrayOfPhysicalTensors)::ArrayOfPhysicalTensors
```

## Unit Testing

To test a tensor or an array of tensors to see if they are dimensionless, call
```
function isDimensionless(y::PhysicalTensor)::Bool
function isDimensionless(y::ArrayOfPhysicalTensors)::Bool
```
To test a tensor or an array of tensors to see if they have SI units, call method
```
function isSI(y::PhysicalTensor)::Bool
function isSI(y::ArrayOfPhysicalTensors)::Bool
```
and to test a tensor or an array of tensors to see if they have CGS units, call method
```
function isCGS(y::PhysicalTensor)::Bool
function isCGS(y::ArrayOfPhysicalTensors)::Bool
```

## Operators

The following operators have been overloaded so that they can handle objects of type `PhysicalTensor,` whenever such operations make sense, e.g., one cannot add two tensors with different units or different dimensions. 

The overloaded logical operators include: `==`, `≠` and `≈`. 

The overloaded unary operators include: `+` and `-`. 

The overloaded binary operators include: `+`, `-`, `*`, `/` and `\`, 

where the last operator solves a linear system of equations, e.g., given a matrix **A** and a vector **b**, the linear system of equations **Ax** = **b** is solved for vector **x**. This is written in code as `x = A\b`.

## Math Functions for PhysicalTensor

Method
```
function LinearAlgebra.:(norm)(y::PhysicalTensor, p::Real=2)::PhysicalScalar
```
returns the p-norm of tensor `y,` with the default being the Frobenius norm, i.e., `p`= 2.

To construct a tensor product between two vectors, typically written as `t = y⊗z` or in component notation as `tᵢⱼ = yᵢzⱼ`, use function
```
function tensorProduct(y::PhysicalVector, z::PhysicalVector)::PhysicalTensor
```

To get the transpose of a tensor, call method
```
function Base.:(transpose)(y::PhysicalTensor)::PhysicalTensor
```

To get the trace of a tensor, call method
```
function LinearAlgebra.:(tr)(y::PhysicalTensor)::PhysicalScalar
```

To get the determinant of a tensor, call method
```
function LinearAlgebra.:(det)(y::PhysicalTensor)::PhysicalScalar
```

To get the inverse of a tensor, when it exists, call method
```
function Base.:(inv)(y::PhysicalTensor)::PhysicalTensor
```

To get the **QR** or Gram-Schmidt decomposition of a tensor, when it exists, call method
```
function LinearAlgebra.:(qr)(y::PhysicalTensor)::Tuple
```
e.g., written in code as
```
(Q, R) = qr(tensor)
```
where **Q** is an orthogonal Gram rotation matrix (a dimensionless tensor), and **R** is an upper-triangular (right) matrix (a tensor with the units of the passed field).

To get the **LQ** decomposition of a tensor, when it exists, call method
```
function LinearAlgebra.:(lq)(y::PhysicalTensor)::Tuple
```
e.g., written in code as
```
(L, Q) = lq(tensor)
```
where **L** is a lower-triangular (left) matrix (a tensor with units of the passed field), and **Q** is an orthogonal rotation matrix (a dimensionless tensor).

*Note:* The rotation matrix returned by a **QR** matrix decomposition of a tensor is, in general, not the same rotation matrix returned by an **LQ** decomposition of the tensor.

[Home Page](.\README.md)

[Previous Page](.\README_PhysicalVectors.md)