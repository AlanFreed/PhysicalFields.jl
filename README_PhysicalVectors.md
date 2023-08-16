[Return to Main Document](.\README.md)

# PhysicalVectors

A physical vector, or vector field, is a one-dimensional array of numbers associated with a set of physical units, e.g., force.

## Concrete Types

For a vector field, use
```
struct PhysicalVector <: PhysicalField
    l::UInt8            # length of a vector
    v::Vector           # values of a vector in its specified system of units
    u::PhysicalUnits    # physical units of the vector
end
```
and for an array of vector fields, use
```
struct ArrayOfPhysicalVectors
    e::UInt32           # number of entries or elements held in the array
    l::UInt8            # length for each physical vector held in the array
    a::Matrix           # array of vectors holding values of a physical vector
    u::PhysicalUnits    # physical units of the vector array
end
```
where all entries in the array are vectors with the same length and the same physical system of units.

## Constructors

There are two internal constructors. The first assumes that the values of its field are zero, while the second assigns values to this field.

### PhysicalVector

Constructors
```
function PhysicalVector(len::Integer, units::PhysicalUnits)
function PhysicalVector(len::Integer, vector::Vector, units::PhysicalUnits)
```
These constructors will return a new vector object of length `len,` which must be within the range of 1…255, whose physical units are specified by argument `units.` The first constructor assigns numeric values of zero to each element of the vector field. The second constructor assigns numeric values to its vector field, as specified by argument `vector.`

### ArrayOfPhysicalVectors

Constructors
```
function ArrayOfPhysicalVectors(arr_len::Integer, vec_len::Integer, units::PhysicalUnits)
function ArrayOfPhysicalVectors(arr_len::Integer, vec_len::Integer, vec_vals::Matrix, units::PhysicalUnits)
```
These constructors will return a new array of vector objects of like length and physical units. The length of the array of vectors is specified by argument `arr_len,` which must be within the range of 1…4,294,967,295. The length of each vector held by this array is the same and is specified by argument `vec_len,` which must be within the range of 1…255. The physical units for each of these vectors are the same, and is specified by argument `units.` The first constructor assigns numeric values of zero to each element of each vector field held in the array. The second constructor assigns numeric values to each vector field held in the array, as specified by argument `vec_vals,` which is a matrix of dimension `arr_len`×`vec_len.`

## Methods

### Get and Set!

These methods are to be used to retrieve and assign a `PhysicalScalar` from/to an element in a `PhysicalVector.`

```
function Base.:(getindex)(y::PhysicalVector, idx::Integer)::PhysicalScalar
function Base.:(setindex!)(y::PhysicalVector, val::PhysicalScalar, idx::Integer)
```

While these methods are to be used to retrieve and assign a `PhysicalVector` from/to an `ArrayOfPhysicalVectors.`

```
function Base.:(getindex)(y::ArrayOfPhysicalVectors, idx::Integer)::PhysicalVector
function Base.:(setindex!)(y::ArrayOfPhysicalVectors, val::PhysicalVector, idx::Integer)
```

Because these methods extend the `Base` functions `getindex` and `setindex!,` the bracket notation `[]` can be used to *i)* retrieve and assign scalar fields belonging to an instance of `PhysicalVector`, and *ii)* retrieve and assign vector fields belonging to an instance of `ArrayOfPhysicalVectors`.

## Copy

For making shallow copies, use
```
function Base.:(copy)(v::PhysicalVector)::PhysicalVector
function Base.:(copy)(av::ArrayOfPhysicalVectors)::ArrayOfPhysicalVectors
```
and for making deep copies, use
```
function Base.:(deepcopy)(v::PhysicalVector)::PhysicalVector
function Base.:(deepcopy)(av::ArrayOfPhysicalVectors)::ArrayOfPhysicalVectors
```

## Readers and Writers

To write a vector or an array of vectors to a JSON file, one can call
```
function toFile(y::PhysicalVector, json_stream::IOStream)
function toFile(y::ArrayOfPhysicalVectors, json_stream::IOStream)
```
where argument `json_stream` comes from a call to `openJSONWriter.` 

To read a vector or an array of vectors from a JSON file, one can call
```
function fromFile(::Type{PhysicalVector}, json_stream::IOStream)::PhysicalVector
function fromFile(::Type{ArrayOfPhysicalVectors}, json_stream::IOStream)::ArrayOfPhysicalVectors
```
where argument `json_stream` comes from a call to `openJSONReader.` 

## Type conversions

Conversion to a string is provided for instances of `PhysicalVector` by the method

```
function toString(v::PhysicalVector; format::Char='E')::String
```

where the keyword `format` is a character that, whenever its value is 'E' or 'e', represents the vector components in a scientific notation; otherwise, they will be represented in a fixed-point notation.

Conversion to the raw array of numbers held by the vector is provided for by
```
function toArray(v::PhysicalVector)::Vector
```

Converting a vector field between CGS and SI units is accomplished via
```
function toCGS(v::PhysicalVector)::PhysicalVector
function toSI(v::PhysicalVector)::PhysicalVector
```
and to convert an array of vectors between CGS and SI units, use
```
function toCGS(av::ArrayOfPhysicalVectors)::ArrayOfPhysicalVectors
function toSI(av::ArrayOfPhysicalVectors)::ArrayOfPhysicalVectors
```

## Unit Testing

To test a vector or an array of vectors to see if they are dimensionless, call
```
function isDimensionless(v::PhysicalVector)::Bool
function isDimensionless(av::ArrayOfPhysicalVectors)::Bool
```
To test a vector or an array of vectors to see if they have CGS units, call
```
function isCGS(v::PhysicalVector)::Bool
function isCGS(av::ArrayOfPhysicalVectors)::Bool
```
To test a vector or an array of vectors to see if they have SI units, call
```
function isSI(v::PhysicalVector)::Bool
function isSI(av::ArrayOfPhysicalVectors)::Bool
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
returns the cross product `y`×`z`, provided these two vectors each has a length (dimension) of 3.

[Home Page](.\README.md)

[Previous Page](.\README_PhysicalScalars.md)

[Next Page](.\README_PhysicalTensors.md)
