[Return to Main Document](.\README.md)

# PhysicalVectors

A physical vector, or vector field, is a one-dimensional array of numbers associated with a set of physical units, e.g., force.

## Concrete Types

For a vector field, use
```
struct PhysicalVector <: PhysicalField
    vector::MVector         # values of a vector in its specified system of units
    units::PhysicalUnits    # physical units of the vector
end
```
and for an array of vector fields, use
```
struct ArrayOfPhysicalVectors
    array::MMatrix          # array of row vectors holding values of a physical vector
    units::PhysicalUnits    # physical units of the vector array
end
```
where all entries in the array are vectors with the same length and the same physical system of units.

## Constructors

There are three internal constructors. The first assigns zeros to the vector field. The second assigns a raw array of 64-bit reals of the appropriate dimension. And the third assigns a mutable array of the appropriate dimension.

### PhysicalVector

Constructors
```
function PhysicalVector(length::Integer, units::PhysicalUnits)
function PhysicalVector(vector::Vector{Float64}, units::PhysicalUnits)
function PhysicalVector(vector::MVector, units::PhysicalUnits) units::PhysicalUnits)
```
These constructors will return a new vector object whose physical units are specified by argument `units.` The first constructor assigns numeric values of zero to each element of the vector field. The other two constructors assign numeric values to its vector field, as specified by argument `vector.`

### ArrayOfPhysicalVectors

Constructors
```
function ArrayOfPhysicalVectors(array_length::Integer, vector_length::Integer, units::PhysicalUnits)
function ArrayOfPhysicalVectors(array::Matrix{Float64}, units::PhysicalUnits)
function ArrayOfPhysicalVectors(array::MMatrix, units::PhysicalUnits)
```
These constructors will return a new array of vector objects of like length and physical units. The length of the array of vectors is specified by argument `array_length.` The length of each vector held by this array is the same and is specified by argument `vector_length.` The physical units for each of these vectors are the same, and is specified by argument `units.` The first constructor assigns numeric values of zero to each element of each vector field held in the array. The other two constructors assign numeric values to each vector field held in the array, as specified by argument `array,` which is a matrix of dimension `array_length`×`vector_length.`

## Methods

### Get and Set!

These methods are to be used to retrieve and assign a `PhysicalScalar` from/to an element in a `PhysicalVector.`

```
function Base.:(getindex)(y::PhysicalVector, index::Integer)::PhysicalScalar
function Base.:(setindex!)(y::PhysicalVector, scalar::PhysicalScalar, index::Integer)
```

While the following methods are to be used to retrieve and assign a `PhysicalVector` from/to an `ArrayOfPhysicalVectors.`

```
function Base.:(getindex)(y::ArrayOfPhysicalVectors, index::Integer)::PhysicalVector
function Base.:(setindex!)(y::ArrayOfPhysicalVectors, vector::PhysicalVector, index::Integer)
```

Because these methods extend the `Base` functions `getindex` and `setindex!,` the bracket notation `[]` can be used to *i)* retrieve and assign scalar fields belonging to an instance of `PhysicalVector`, and *ii)* retrieve and assign vector fields belonging to an instance of `ArrayOfPhysicalVectors`.

## Copy

For making shallow copies, use
```
function Base.:(copy)(y::PhysicalVector)::PhysicalVector
function Base.:(copy)(y::ArrayOfPhysicalVectors)::ArrayOfPhysicalVectors
```
and for making deep copies, use
```
function Base.:(deepcopy)(y::PhysicalVector)::PhysicalVector
function Base.:(deepcopy)(y::ArrayOfPhysicalVectors)::ArrayOfPhysicalVectors
```

## Readers and Writers

To write a vector or an array of vectors to a JSON file, one can call
```
function toFile(y::PhysicalVector, json_stream::IOStream)
function toFile(y::ArrayOfPhysicalVectors, json_stream::IOStream)
```
where argument `json_stream` comes from a call to `openJSONWriter` discussed on page [README.md](./README.md).

To read a vector or an array of vectors from a JSON file, one can call
```
function fromFile(::Type{PhysicalVector}, json_stream::IOStream)::PhysicalVector
function fromFile(::Type{ArrayOfPhysicalVectors}, json_stream::IOStream)::ArrayOfPhysicalVectors
```
where argument `json_stream` comes from a call to `openJSONReader` discussed on page [README.md](./README.md).

## Type conversions

Conversion to a string is provided for instances of `PhysicalVector` by the method

```
function toString(y::PhysicalVector; format::Char='E')::String
```

where the keyword `format` is a character that, whenever its value is 'E' or 'e', represents the vector components in a scientific notation; otherwise, they will be represented in a fixed-point notation.

Conversion to the raw array of numbers held by the vector is provided for by
```
function toVector(y::PhysicalVector)::Vector{Float64}
```

Converting a vector field between SI and CGS units is accomplished via
```
function toSI(y::PhysicalVector)::PhysicalVector
function toCGS(y::PhysicalVector)::PhysicalVector
```
and to convert an array of vectors between SI and CGS units, use
```
function toSI(y::ArrayOfPhysicalVectors)::ArrayOfPhysicalVectors
function toCGS(y::ArrayOfPhysicalVectors)::ArrayOfPhysicalVectors
```

## Unit Testing

To test a vector or an array of vectors to see if it is dimensionless, call
```
function isDimensionless(y::PhysicalVector)::Bool
function isDimensionless(y::ArrayOfPhysicalVectors)::Bool
```
To test a vector or an array of vectors to see if they has SI units, call
```
function isSI(y::PhysicalVector)::Bool
function isSI(y::ArrayOfPhysicalVectors)::Bool
```
and to test a vector or an array of vectors to see if they have CGS units, call
```
function isCGS(y::PhysicalVector)::Bool
function isCGS(y::ArrayOfPhysicalVectors)::Bool
```

## Operators

The following operators have been overloaded so that they can handle objects of type `PhysicalVector,` whenever such operations make sense, e.g., one cannot add two vectors with different units or different dimensions. 

The overloaded logical operators include: `==`, `≠` and `≈`. 

The overloaded unary operators include: `+` and `-`. 

The overloaded binary operators include: `+`, `-`, `*` and `/`.

## Math Functions for PhysicalVector

Method
```
function LinearAlgebra.:(norm)(y::PhysicalVector, p::Real=2)::PhysicalScalar
```
returns the p-norm of vector `y,` with the default being the Euclidean norm, i.e., `p`= 2. 

Function 
```
function unitVector(y::PhysicalVector)::PhysicalVector
```
returns a dimensionless Euclidean vector of length 1 pointing in the direction of vector `y.`

Method
```
function LinearAlgebra.:(cross)(y::PhysicalVector, z::PhysicalVector)::PhysicalVector
```
returns the cross product `y`×`z,` provided these two vectors each has a length (dimension) of 3.

[Home Page](.\README.md)

[Previous Page](.\README_PhysicalScalars.md)

[Next Page](.\README_PhysicalTensors.md)
