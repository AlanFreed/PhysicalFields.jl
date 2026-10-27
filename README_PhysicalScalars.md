[Return to Main Document](./README.md)

# PhysicalScalars

A physical scalar, or scalar field, is a number associated with a set of physical units, e.g., a temperature.

## A PhysicalScalar

For a scalar field, use the type
```
struct PhysicalScalar <: PhysicalField
    value::MReal            # value of a scalar in its specified system of units
    units::PhysicalUnits    # physical units of the scalar
end
```
The value held by a scalar is mutable.

### Constructors

There are three constructor options to choose from
```
function PhysicalScalar(units::PhysicalUnits)
function PhysicalScalar(value::Real, units::PhysicalUnits)
function PhysicalScalar(value::MReal, units::PhysicalUnits)
```
These constructors will return a new scalar object whose physical units are specified by argument `units.` The first constructor assigns a numeric value of zero to the scalar field, while the other two constructors assign to the scalar that numeric value specified by argument `value.`

## An ArrayOfPhysicalScalars

For an array of scalar fields, use the type
```
struct ArrayOfPhysicalScalars <: ArrayOfPhysicalFields
    array::MVector          # array holding values of a physical scalar
    units::PhysicalUnits    # physical units of the scalar array
end
```
where all entries in the array have the same physical units. These array entries are mutable. 

### Constructors

There are three constructors to choose from
```
function ArrayOfPhysicalScalars(array_length::Integer, units::PhysicalUnits)
function ArrayOfPhysicalScalars(scalar_values::Vector{<:Real}, units::PhysicalUnits)
function ArrayOfPhysicalScalars(scalar_values::MVector, units::PhysicalUnits)
```
These constructors will return a new array of scalars whose length is specified by argument `array_length,` wherein all elements of the array will have physical units specified by argument `units.` The first constructor creates an array with zero values, while the remaining constructors assign values to this internal array, as supplied by the vector argument `scalar_values,` which is an array of dimension `array_length.`

## A VectorOfPhysicalScalars

In many applications, e.g., thermodynamics, one collects an array of physical scalars, gathered as a vector, wherein each entry has its own set of physical units, in which case one would select the  type
```
struct VectorOfPhysicalScalars <: ArrayOfPhysicalFields
    values::MVector                 # vector of physical values
    units::VectorOfPhysicalUnits    # vector of physical units
end
```
where the value of a physical scalar, say `scalar.value,` is held as an element in vector `values,` while its units `scalar.units` are held as an element in vector `units,` both at the same location. 

### Constructors

There are three constructors to select from. They are
```
function VectorOfPhysicalScalars(length::Integer)
function VectorOfPhysicalScalars(values::Vector{<:Real}, units::VectorOfPhysicalUnits)
function VectorOfPhysicalScalars(values::MVector, units::VectorOfPhysicalUnits)
```
These constructors will return a new vector of scalars whose length is specified by argument `length,` wherein all elements of the vector have their own set of physical units specified by argument `units.` The first constructor creates a vector with dimensionless values, while the remaining constructors assign scalars to this internal vector whose `values` and `units` are supplied as separate vectors with dimension `length.`

A `VectorOfPhysicalScalars` is distinct from an `ArrayOfPhysicalScalars.` In the former, each element of the vector has its own set of physical units. In the latter, all elements have the same set of physical units.

## A MatrixOfPhysicalScalars

Whenever one collects an array of physical scalars, gathered as a matrix, e.g., a thermodynamic Jacobian, wherein each entry has its own set of physical units, then one would select the type
```
struct MatrixOfPhysicalScalars <: ArrayOfPhysicalFields
    values::MMatrix                 # matrix of physical values
    units::MatrixOfPhysicalUnits    # matrix of physical units
end
```
wherein a scalar field has its value stored in `values` and its physical units stored in `units,` both at the same location. 

### Constructors

There are three constructors to choose from
```
function MatrixOfPhysicalScalars(rows::Integer, columns::Integer)
function MatrixOfPhysicalScalars(values::Matrix{<:Real}, units::MatrixOfPhysicalUnits)
function MatrixOfPhysicalScalars(values::MMatrix, units::MatrixOfPhysicalUnits)
```
where the matrix has dimension `rows`×`columns.`

# Methods
## Get and Set!

These functions are to be used to retrieve and assign `Real` values from/to a `PhysicalScalar.`

```
function get(y::PhysicalScalar)::Real
function set!(y::PhysicalScalar, x::Real)
```
The following functions are to be used to retrieve and assign a `PhysicalScalar` from/to an `ArrayOfPhysicalScalars.`
```
function getindex(y::ArrayOfPhysicalScalars, index::Integer)::PhysicalScalar
function setindex!(y::ArrayOfPhysicalScalars, scalar::PhysicalScalar, index::Integer)
```
while the following functions retrieve and assign a `PhysicalScalar` from/to a `VectorOfPhysicalScalars` via
```
function getindex(y::VectorOfPhysicalScalars, index::Integer)::PhysicalScalar
function setindex!(y::VectorOfPhysicalScalars, scalar::PhysicalScalar, index::Integer)
```
or retrieve and assign a `PhysicalScalar` from/to a `MatrixOfPhysicalScalars` via
```
function getindex(y::MatrixOfPhysicalScalars, row::Integer, column::Integer)::PhysicalScalar
function setindex!(y::MatrixOfPhysicalScalars, scalar::PhysicalScalar, row::Integer, column::Integer)
```

Because these extend the `Base` functions `getindex` and `setindex!`, the bracket notation `[]` can be used to retrieve and assign individual scalar fields belonging to instances of `ArrayOfPhysicalScalars,` `VectorOfPhysicalScalars` and `MatrixOfPhysicalScalars.`

## Copy

For making a copy, use
```
function copy(y::PhysicalScalar)::PhysicalScalar
function copy(y::ArrayOfPhysicalScalars)::ArrayOfPhysicalScalars
function copy(y::VectorOfPhysicalScalars)::VectorOfPhysicalScalars
function copy(y::MatrixOfPhysicalScalars)::MatrixOfPhysicalScalars
```

## Readers and Writers

Conversion of a scalar field into a string is provided for by the method
```
function toString(y::PhysicalScalar)::String
```
No parser is provided here.

To write a scalar or an array of scalars to a JSON file, one can call
```
function toFile(y::PhysicalScalar, json_stream::IOStream)
function toFile(y::ArrayOfPhysicalScalars, json_stream::IOStream)
function toFile(y::VectorOfPhysicalScalars, json_stream::IOStream)
function toFile(y::MatrixOfPhysicalScalars, json_stream::IOStream)
```
where argument `json_stream` comes from a call to `openJSONWriter` found in [README.md](.\README.md).

To read a scalar or an array of scalars from a JSON file, one can call
```
function fromFile(::Type{PhysicalScalar}, json_stream::IOStream)::PhysicalScalar
function fromFile(::Type{ArrayOfPhysicalScalars}, json_stream::IOStream)::ArrayOfPhysicalScalars
function fromFile(::Type{VectorOfPhysicalScalars}, json_stream::IOStream)::VectorOfPhysicalScalars
function fromFile(::Type{MatrixOfPhysicalScalars}, json_stream::IOStream)::MatrixOfPhysicalScalars
```
where argument `json_stream` comes from a call to `openJSONReader` found [here](.\README_Persistence.md).

## Type Conversions

Retrieving the real number held by a scalar is done by
```
function toReal(s::PhysicalScalar)::Real
```

Convert a scalar field between CGS and SI units by calling
```
function toSI(y::PhysicalScalar)::PhysicalScalar
function toCGS(y::PhysicalScalar)::PhysicalScalar
```
and convert an array of scalars between CGS and SI units by calling
```
function toSI(y::ArrayOfPhysicalScalars)::ArrayOfPhysicalScalars
function toCGS(y::ArrayOfPhysicalScalars)::ArrayOfPhysicalScalars
```
convert a vector of scalars between CGS and SI units by calling
```
function toSI(y::VectorOfPhysicalScalars)::VectorOfPhysicalScalars
function toCGS(y::VectorOfPhysicalScalars)::VectorOfPhysicalScalars
```
while converting a matrix of scalars between CGS and SI units by calling
```
function toSI(y::MatrixOfPhysicalScalars)::MatrixOfPhysicalScalars
function toCGS(y::MatrixOfPhysicalScalars)::MatrixOfPhysicalScalars
```

## Unit Testing

To test a scalar or an array of scalars to see if they are dimensionless, call
```
function isDimensionless(y::PhysicalScalar)::Bool
function isDimensionless(y::ArrayOfPhysicalScalars)::Bool
function isDimensionless(y::VectorOfPhysicalScalars)::Bool
function isDimensionless(y::MatrixOfPhysicalScalars)::Bool
```
To test a scalar or an array of scalars to see if they have SI units, call
```
function isSI(y::PhysicalScalar)::Bool
function isSI(y::ArrayOfPhysicalScalars)::Bool
function isSI(y::VectorOfPhysicalScalars)::Bool
function isSI(y::MatrixOfPhysicalScalars)::Bool
```
To test a scalar or an array of scalars to see if they have CGS units, call
```
function isCGS(y::PhysicalScalar)::Bool
function isCGS(y::ArrayOfPhysicalScalars)::Bool
function isCGS(y::VectorOfPhysicalScalars)::Bool
function isCGS(y::MatrixOfPhysicalScalars)::Bool
```

## Operators

The following operators have been overloaded so that they can handle objects of type `PhysicalScalar,` whenever such operations make sense, e.g., one cannot add two scalars with different units; however, one can multiply them. 

### PhysicalScalars

The overloaded logical operators include: `==`, `≠`, `≈`, `<`, `≤`, `≥` and `>`. 

The overloaded unary operators include: `+` and `-`. 

The overloaded binary operators include: `+`, `-`, `*`, `/` and `^`.

### ArrayOfPhysicalScalars

The overloaded logical operators include: `==`, `≠`, `≈`, `<`, `≤`, `≥` and `>`. 

The overloaded unary operators include: `+` and `-`. 

The overloaded binary operators include: `+`, `-`, `*`, `/` and `^`.

### VectorOfPhysicalScalars

The overloaded logical operators include: `==`, `≠` and `≈`. 

The overloaded binary operators include: `+`, `-` and `*`.

### MatrixOfPhysicalScalars

The overloaded logical operators include: `==`, `≠` and `≈`. 

The overloaded binary operators include: `+`, `-` and `*`.

## Math functions for PhysicalScalar

The following methods are math functions that return a physical scalar and can handle arguments that are scalars with physical dimensions.

```
function abs(s::PhysicalScalar)::PhysicalScalar
function round(y::PhysicalScalar)::PhysicalScalar
function ceil(y::PhysicalScalar)::PhysicalScalar
function floor(y::PhysicalScalar)::PhysicalScalar
function sqrt(y::PhysicalScalar)::PhysicalScalar
```
where taking the square root of a scalar requires the powers of its physical units be exactly divisible by 2.

The following methods are math functions that return a real number whose arguments are physical scalars.
```
function sign(y::PhysicalScalar)::Real
function atan(y::PhysicalScalar, x::PhysicalScalar)::Real
```
provided that the rise `y` has the same physical units as the run `x`.

The following methods are math functions that return a real number whose scalar argument is dimensionless.
```
function sin(y::PhysicalScalar)::Real
function cos(y::PhysicalScalar)::Real
function tan(y::PhysicalScalar)::Real
function asin(y::PhysicalScalar)::Real
function acos(y::PhysicalScalar)::Real
function atan(y::PhysicalScalar)::Real
function sinh(y::PhysicalScalar)::Real
function cosh(y::PhysicalScalar)::Real
function tanh(y::PhysicalScalar)::Real
function asinh(y::PhysicalScalar)::Real
function acosh(y::PhysicalScalar)::Real
function atanh(y::PhysicalScalar)::Real
function log(y::PhysicalScalar)::Real
function log2(y::PhysicalScalar)::Real
function log10(y::PhysicalScalar)::Real
function exp(y::PhysicalScalar)::Real
function exp2(y::PhysicalScalar)::Real
function exp10(y::PhysicalScalar)::Real
```
while a matrix of physical scalars inverts according to
```
function inv(y::MatrixOfPhysicalScalars)::MatrixOfPhysicalScalars
```

These are the same functions that have been extended for mutable numbers found [here](./README_MutableTypes.md).

[Home Page](./README.md)
[Prev Page](./README_PhysicalUnits.md)
[Next Page](./README_PhysicalVectors.md)








