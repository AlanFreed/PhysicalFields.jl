[Return to Main Document](.\README.md)


# PhysicalVectors

## Concrete Types

For a vector field

```

struct PhysicalVector <: PhysicalField
    l::UInt8            # length of the vector
    v::StaticVector     # values of the vector in its specified system of units
    u::PhysicalUnits    # the vector's physical units
end
```

and for an array of a vector field

```
struct ArrayOfPhysicalVectors
    e::UInt32           # number of entries or elements held in the array
    l::UInt8            # length of each physical vector held in the array
    a::Array            # array of vectors holding values of a physical vector
    u::PhysicalUnits    # units of this physical vector
end
```

where all entries in the array have the same physical units.

### Constructors

Constructor

```
function newPhysicalVector(len::Integer, units::PhysicalUnits)::PhysicalVector
```

supplies a new physical vector of dimension `len` whose values are set to `0.0` and whose physical units are those supplied by the argument `units`, while constructor

```
function newArrayOfPhysicalVectors(len::Integer, v₁::PhysicalVector)::ArrayOfPhysicalVectors
```

supplies a new array of physical vectors where `v₁` is the first entry in this array of vectors. The array has a length of `len` ∈ \{1, …, 4294967295\}.

## Methods

### Get and Set!

These methods are to be used to retrieve and assign a `PhysicalScalar` from/to an element in a `PhysicalVector`.

```
function Base.:(getindex)(y::PhysicalVector, idx::Integer)::PhysicalScalar
function Base.:(setindex!)(y::PhysicalVector, val::PhysicalScalar, idx::Integer)
```

While these methods are to be used to retrieve and assign a `PhysicalVector` from/to an `ArrayOfPhysicalVectors`.

```
function Base.:(getindex)(y::ArrayOfPhysicalVectors, idx::Integer)::PhysicalVector
function Base.:(setindex!)(y::ArrayOfPhysicalVectors, val::PhysicalVector, idx::Integer)
```

Because these methods extend the `Base` functions `getindex` and `setindex!`, the bracket notation `[]` can be used to *i)* retrieve and assign scalar fields belonging to an instance of `PhysicalVector`, and *ii)* retrieve and assign vector fields belonging to an instance of `ArrayOfPhysicalVectors`.

## Copy

For making shallow copies, use

```
function Base.:(copy)(s::PhysicalVector)::PhysicalVector
function Base.:(copy)(as::ArrayOfPhysicalVectors)::ArrayOfPhysicalVectors
```

and for making deep copies, use

```
function Base.:(deepcopy)(s::PhysicalVector)::PhysicalVector
function Base.:(deepcopy)(as::ArrayOfPhysicalVectors)::ArrayOfPhysicalVectors
```

## Type conversions

Conversion to a string is provided for instances of `PhysicalVector` by the method

```
function toString(v::PhysicalVector; format::Char='E')::String
```

where the keyword `format` is a character that, whenever its value is 'E' or 'e', represents the vector components in a scientific notation; otherwise, they will be represented in a fixed-point notation.

Conversion to the raw array of numbers held by the vector is provided for by

```
function toArray(v::PhysicalVector)::StaticVector
```

Converting a vector field between CGS and SI units is accomplished via

```
function toCGS(s::PhysicalVector)::PhysicalVector
function toSI(s::PhysicalVector)::PhysicalVector
```

and to convert an array of vectors between CGS and SI units, use

```
function toCGS(as::ArrayOfPhysicalVectors)::ArrayOfPhysicalVectors
function toSI(as::ArrayOfPhysicalVectors)::ArrayOfPhysicalVectors
```

## Unit Testing

```
function isDimensionless(s::PhysicalVector)::Bool
function isDimensionless(as::ArrayOfPhysicalVectors)::Bool
```

```
function isCGS(s::PhysicalVector)::Bool
function isCGS(as::ArrayOfPhysicalVectors)::Bool
```

```
function isSI(s::PhysicalVector)::Bool
function isSI(as::ArrayOfPhysicalVectors)::Bool
```

## Operators

The following operators have been overloaded so that they can handle objects of type `PhysicalVector`, whenever such operations make sense, e.g., one cannot add two vectors with different units or different dimensions. 

The overloaded logical operators include: `==`, `≠` and `≈`. 

The overloaded unary operators include: `+` and `-`. 

The overloaded binary operators include: `+`, `-`, `*` and `/`.

## Math Functions for PhysicalVector

Method
```
function LinearAlgebra.:(norm)(y::PhysicalVector, p::Real=2)::PhysicalScalar
```
returns the p-norm of vector `y`, with the default being the Euclidean norm, i.e., `p` = 2. 

Function 
```
function unitVector(y::PhysicalVector)::PhysicalVector
```
returns a dimensionless vector of length 1 pointing in the direction of vector `y`. 

Method
```
function LinearAlgebra.:(cross)(y::PhysicalVector, z::PhysicalVector)::PhysicalVector
```
returns the cross product `y` × `z`, provided these two vectors have lengths (dimensions) of 3.

[Home Page](.\README.md)

[Previous Page](.\README_PhysicalScalars.md)

[Next Page](.\README_PhysicalTensors.md)
