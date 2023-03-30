[Return to Main Document](.\README.md)

# PhysicalTensors

## Concrete Types

For a tensor field

```
struct PhysicalTensor <: PhysicalField
    r::UInt8            # rows in the matrix representation of the tensor
    c::UInt8            # columns in the matrix representation of the tensor
    m::StaticMatrix     # values of the tensor in its specified system of units
    u::PhysicalUnits    # the tensor's physical units
end
```

and for an array of a tensor field

```
struct ArrayOfPhysicalTensors
    e::UInt32           # number of entries or elements held in the array
    r::UInt8            # rows in each physical tensor held in the array
    c::UInt8            # columns in each physical tensor held in the array
    a::Array            # array of matrices holding values of a physical tensor
    u::PhysicalUnits    # units of this physical tensor
end
```

where all entries in the array have the same physical units.

### Constructors

Constructor

```
function newPhysicalTensor(rows::Integer, cols::Integer, units::PhysicalUnits)::PhysicalTensor
```

supplies a new tensor of dimension `rows` by `cols` whose values are set to `0.0` and whose physical units are those supplied by the argument `units`, while constructor

```
unction newArrayOfPhysicalTensors(len::Integer, m₁::PhysicalTensor)::ArrayOfPhysicalTensors
```

supplies a new array of physical tensors where `m₁` is the first entry in this array of tensors. The array has a length of `len` ∈ \{1, …, 4294967295\}.

## Methods

### Get and Set!

These methods are to be used to retrieve and assign a `PhysicalScalar` from/to an element in a `PhysicalTensor`.

```
function Base.:(getindex)(y::PhysicalTensor, idx::Integer)::PhysicalScalar
function Base.:(setindex!)(y::PhysicalTensor, val::PhysicalScalar, idx::Integer)
```

While these methods are to be used to retrieve and assign a `PhysicalTensor` from/to an `ArrayOfPhysicalTensors`.

```
function Base.:(getindex)(y::ArrayOfPhysicalTensors, idx::Integer)::PhysicalTensor
function Base.:(setindex!)(y::ArrayOfPhysicalTensors, val::PhysicalTensor, idx::Integer)
```

Because these methods extend the `Base` functions `getindex` and `setindex!`, the bracket notation `[,]` can be used to *i)* retrieve and assign scalar fields belonging to an instance of `PhysicalTensor`, and *ii)* retrieve and assign tensor fields belonging to an instance of `ArrayOfPhysicalTensors`.

## Copy

For making shallow copies, use

```
function Base.:(copy)(s::PhysicalTensor)::PhysicalTensor
function Base.:(copy)(as::ArrayOfPhysicalTensors)::ArrayOfPhysicalTensors
```

and for making deep copies, use

```
function Base.:(deepcopy)(s::PhysicalTensor)::PhysicalTensor
function Base.:(deepcopy)(as::ArrayOfPhysicalTensors)::ArrayOfPhysicalTensors
```

## Type conversions

Conversion to a string is provided for instances of `PhysicalTensor` by the method

```
function toString(t::PhysicalTensor; format::Char='E')::String
```

where the keyword `format` is a character that, whenever its value is 'E' or 'e', represents the tensor components in a scientific notation; otherwise, they will be represented in a fixed-point notation.

Conversion to a matrix of the values held by a tensor is provided by
```
function toMatrix(t::PhysicalTensor)::StaticMatrix
```

Converting a tensor field between CGS and SI units is accomplished via

```
function toCGS(s::PhysicalTensor)::PhysicalTensor
function toSI(s::PhysicalTensor)::PhysicalTensor
```

and to convert an array of tensors between CGS and SI units, use

```
function toCGS(as::ArrayOfPhysicalTensors)::ArrayOfPhysicalTensors
function toSI(as::ArrayOfPhysicalTensors)::ArrayOfPhysicalTensors
```

## Unit Testing

```
function isDimensionless(s::PhysicalTensor)::Bool
function isDimensionless(as::ArrayOfPhysicalTensors)::Bool
```

```
function isCGS(s::PhysicalTensor)::Bool
function isCGS(as::ArrayOfPhysicalTensors)::Bool
```

```
function isSI(s::PhysicalTensor)::Bool
function isSI(as::ArrayOfPhysicalTensors)::Bool
```

## Operators

The following operators have been overloaded so that they can handle objects of type `PhysicalTensor`, whenever such operations make sense, e.g., one cannot add two tensors with different units or different dimensions. 

The overloaded logical operators include: `==`, `≠` and `≈`. 

The overloaded unary operators include: `+` and `-`. 

The overloaded binary operators include: `+`, `-`, `*`, `/` and `\`, 

where the latter solves a linear system of equations, e.g., **Ax** = **b** solved for **x**, which is written in code as `x = A\b`.

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

[Home Page](.\README.md)

[Previous Page](.\README_PhysicalVectors.md)