

[Return to Main Document](.\README.md)

# PhysicalScalars

## Concrete Types

For a scalar field

```
struct PhysicalScalar <: PhysicalField
    x::MReal            # value of the scalar in its specified system of units
    u::PhysicalUnits    # the scalar's physical units
end
```

and for an array of a scalar field

```
struct ArrayOfPhysicalScalars
    e::UInt32           # number of entries or elements held in the array
    a::Array            # array holding values of a physical scalar
    u::PhysicalUnits    # units of this physical scalar
end
```

where all entries in an array have the same physical units.

## Constructors

Constructor

```
function newPhysicalScalar(units::PhysicalUnits)::PhysicalScalar
```

supplies a new scalar whose value is 0.0 and whose physical units are those supplied by the argument `units`, and

```
function newArrayOfPhysicalScalars(len::Integer, s₁::PhysicalScalar)::ArrayOfPhysicalScalars
```

supplies a new array of scalers where `s₁` is the first entry in this array of scalars. The array has a length of `len` ∈ \{1, …, 4294967295\}.

# Methods
## Get and Set!

These functions are to be used to retrieve and assign `Real` values from/to a `PhysicalScalar`.

```
function Base.:(get)(y::PhysicalScalar)::Real
function set!(y::PhysicalScalar, x::Real)
```

While these functions are to be used to retrieve and assign a `PhysicalScalar` from/to an `ArrayOfPhysicalScalars`.

```
function Base.:(getindex)(y::ArrayOfPhysicalScalars, idx::Integer)::PhysicalScalar
function Base.:(setindex!)(y::ArrayOfPhysicalScalars, val::PhysicalScalar, idx::Integer)

```

Because these extend the `Base` functions `getindex` and `setindex!`, the bracket notation `[]` can be used to retrieve and assign individual scalar fields belonging to an instance of `ArrayOfPhysicalScalars`.

## Copy

For making shallow copies, use

```
function Base.:(copy)(s::PhysicalScalar)::PhysicalScalar
function Base.:(copy)(as::ArrayOfPhysicalScalars)::ArrayOfPhysicalScalars
```

and for making deep copies, use

```
function Base.:(deepcopy)(s::PhysicalScalar)::PhysicalScalar
function Base.:(deepcopy)(as::ArrayOfPhysicalScalars)::ArrayOfPhysicalScalars
```

## Type conversions

Conversion of a scalar field into a string is provided for by the method

```
function toString(y::PhysicalScalar;
                  format::Char='E',
                  precision::Int=5,
                  aligned::Bool=false)::String
```

where the keyword `format` is a character that, whenever its value is 'E' or 'e', represents the scalar in a scientific notation; otherwise, it will be represented in a fixed-point notation. Keyword `precision` specifies the number of significant digits to be represented in the string, which can accept values from the set \{3…7\}. Keyword `aligned`, when set to `true`, will add a white space in front of any non-negative scalar string representation, e.g., this could be useful when printing out a matrix of scalars; otherwise, there is no leading white space in its string representation, which is the default.

Retrieving the real number held by a scalar is done by

```
function toReal(s::PhysicalScalar)::Real
```

Converting a scalar field between CGS and SI units is accomplished via

```
function toCGS(s::PhysicalScalar)::PhysicalScalar
function toSI(s::PhysicalScalar)::PhysicalScalar
```

and to convert an array of scalars between CGS and SI units, use

```
function toCGS(as::ArrayOfPhysicalScalars)::ArrayOfPhysicalScalars
function toSI(as::ArrayOfPhysicalScalars)::ArrayOfPhysicalScalars
```

## Unit Testing

```
function isDimensionless(s::PhysicalScalar)::Bool
function isDimensionless(as::ArrayOfPhysicalScalars)::Bool
```

```
function isCGS(s::PhysicalScalar)::Bool
function isCGS(as::ArrayOfPhysicalScalars)::Bool
```

```
function isSI(s::PhysicalScalar)::Bool
function isSI(as::ArrayOfPhysicalScalars)::Bool
```


## Operators

The following operators have been overloaded so that they can handle objects of type `PhysicalScalar`, whenever such operations make sense, e.g., one cannot add two scalars with different units; however, one can multiply them. 

The overloaded logical operators include: `==`, `≠`, `≈`, `<`, `≤`, `≥` and `>`. 

The overloaded unary operators include: `+` and `-`. 

The overloaded binary operators include: `+`, `-`, `*`, `/` and `^`.

## Math functions for PhysicalScalar

The following methods are math functions that return a physical scalar and can handle arguments that are scalars with physical dimensions.

```
function Base.:(abs)(s::PhysicalScalar)::PhysicalScalar
```
```
function Base.:(round)(y::PhysicalScalar)::PhysicalScalar
```
```
function Base.:(ceil)(y::PhysicalScalar)::PhysicalScalar
```
```
function Base.:(floor)(y::PhysicalScalar)::PhysicalScalar
```
```
function Base.:(sqrt)(y::PhysicalScalar)::PhysicalScalar
```
where taking the square root of a scalar requires the powers of its physical units be divisible by 2.

The following methods are math functions that return a real number whose arguments are physical scalars.

```
function Base.:(sign)(y::PhysicalScalar)::Real
```
```
function Base.:(atan)(y::PhysicalScalar, x::PhysicalScalar)::Real
```

provided that rise `y` has the same units as run `x`.

The following methods are math functions that return a real number whose scalar argument is dimensionless.

```
function Base.:(sin)(y::PhysicalScalar)::Real
```
```
function Base.:(cos)(y::PhysicalScalar)::Real
```
```
function Base.:(tan)(y::PhysicalScalar)::Real
```
```
function Base.:(asin)(y::PhysicalScalar)::Real
```
```
function Base.:(acos)(y::PhysicalScalar)::Real
```
```
function Base.:(atan)(y::PhysicalScalar)::Real
```
```
function Base.:(sinh)(y::PhysicalScalar)::Real
```
```
function Base.:(cosh)(y::PhysicalScalar)::Real
```
```
function Base.:(tanh)(y::PhysicalScalar)::Real
```
```
function Base.:(asinh)(y::PhysicalScalar)::Real
```
```
function Base.:(acosh)(y::PhysicalScalar)::Real
```
```
function Base.:(atanh)(y::PhysicalScalar)::Real
```
```
function Base.:(log)(y::PhysicalScalar)::Real
```
```
function Base.:(log2)(y::PhysicalScalar)::Real
```
```
function Base.:(log10)(y::PhysicalScalar)::Real
```
```
function Base.:(exp)(y::PhysicalScalar)::Real
```
```
function Base.:(exp2)(y::PhysicalScalar)::Real
```
```
function Base.:(exp10)(y::PhysicalScalar)::Real
```

[Home Page](.\README.md)

[Previous Page](.\README_PhysicalUnits.md)

[Next Page](.\README_PhysicalVectors.md)








