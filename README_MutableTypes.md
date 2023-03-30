

[Return to Main Document](.\README.md)

# MutableTypes

## Abstract Types

Mutable core types are based upon two abstract types. The first is the abstract type that is the super (or parent) type for all mutable types, viz.,

```
abstract type MType <: Number end
```

while the second abstract type is a subtype of `MType` and includes numeric types that can be sorted, e.g., smallest to largest.

```
abstract type MNumber <: MType end
```


## Concrete Types

Mutable booleans belong to type

```
mutable struct MBool <: MType
    n::Bool  # Bool <: Integer <: Real <: Number
end
```

Mutable integers belong to type

```
mutable struct MInteger <: MNumber
    n::Int64  # Int64 <: Signed <: Integer <: Real <: Number
end
```

Mutable rationals belong to type

```
mutable struct MRational <: MNumber
    n::Rational{Int64}  # Rational <: Real <: Number
end
```

Mutable reals belong to type

```
mutable struct MReal <: MNumber
    n::Float64  # Float64 <: AbstractFloat <: Real <: Number
end
```

Mutable complex belong to type

```
mutable struct MComplex <: MType
    n::Complex{Float64}  # Complex <: Number
end
```

### Constructors

All mutable types have constructors that look like a type casting, e.g., 

```
	b = MBool(true)
	i = MInteger(-4)
	r = MRational(3//4)
	x = MReal(2.5)
	z = MComplex(-2.5 + 3.9im)
```

### Methods

#### get

Methods that retrieve the fundamental value of field `n` belonging to a mutable object `y` include: 

```
function Base.:(get)(y::MBool)::Bool
```

```
function Base.:(get)(y::MInteger)::Integer
```

```
function Base.:(get)(y::MRational)::Rational
```

```
function Base.:(get)(y::MReal)::Real
```

```
function Base.:(get)(y::MComplex)::Complex
```

#### set!

Methods that assign a fundamental value `x` to field `n` belonging to a mutable object `y` include:

```
function set!(y::MBool, x::Bool)
```

```
function set!(y::MInteger, x::Integer)
```

```
function set!(y::MRational, x::Rational)
```

```
function set!(y::MReal, x::Real)
```

```
function set!(y::MComplex, x::Complex)
```


#### copy

Methods that make shallow copies of mutable types include:

```
function Base.:(copy)(y::MBool)::MBool
```

```
function Base.:(copy)(y::MInteger)::MInteger
```

```
function Base.:(copy)(y::MRational)::MRational
```

```
function Base.:(copy)(y::MReal)::MReal
```

```
function Base.:(copy)(y::MComplex)::MComplex
```

#### deepcopy

Methods that make deep copies of mutable types include:

```
function Base.:(deepcopy)(y::MBool)::MBool
```

```
function Base.:(deepcopy)(y::MInteger)::MInteger
```

```
function Base.:(deepcopy)(y::MRational)::MRational
```

```
function Base.:(deepcopy)(y::MReal)::MReal
```

```
function Base.:(deepcopy)(y::MComplex)::MComplex
```

#### toString

Methods that convert numeric objects into strings include:

```
function toString(y::Bool; aligned::Bool=false)::String
```

```
function toString(y::Integer; aligned::Bool=false)::String
```

```
function toString(y::Rational; aligned::Bool=false)::String
```

```
function toString(y::Real;
                  format::Char='E',
                  precision::Int=5,
                  aligned::Bool=false)::String
```

```
function toString(y::Complex;
                  format::Char='E',
                  precision::Int=5,
                  aligned::Bool=false)::String
```
 
Methods that convert mutable objects into strings include:

```
function toString(y::MBool; aligned::Bool=false)::String
```

```
function toString(y::MInteger; aligned::Bool=false)::String
```

```
function toString(y::MRational; aligned::Bool=false)::String
```

```
function toString(y::MReal;
                  format::Char='E',
                  precision::Int=5,
                  aligned::Bool=false)::String
```

```
function toString(y::MComplex;
                  format::Char='E',
                  precision::Int=5,
                  aligned::Bool=false)::String
```

For the various `toString` methods listed above, their parameters are given default values that can be overwritten. Specifically, 

* `format`: An exponential or scientific output will be written whenever `format` is set to `e` or `E`; otherwise, the output will be written in a fixed-point notation.

* `precision`: The number of significant figures to be used in a numeric representation, precision ∈ {3, …, 7}.

* `aligned`: If `true`, a white space will appear before `true` when converting a `MBool` to string, or a white space will appear before the first digit whenever its value is non-negative. Aligning is useful, e.g., when stacking outputs like when writing a matrix to string.

### Overloaded Operators

  * `MBool`: ==, ≠, \!

  * `MInteger`: ==, ≠, \<, ≤, ≥, \>, \+, \-, \*, ÷, %, ^

  * `MRational`: ==, ≠, \<, ≤, ≥, \>, \+, \-, \*, //, /

  * `MReal`: ==, ≠, ≈, \<, ≤, ≥, \>, \+, \-, \*, /, ^

  * `MComplex`: ==, ≠, ≈, \+, \-, \*, /, ^

### Math Functions

#### A method for all numeric mutable types is:

```
function Base.:(abs)(y::MInteger)::Integer
```

```
function Base.:(abs)(y::MRational)::Rational
```

```
function Base.:(abs)(y::MReal)::Real
```

```
function Base.:(abs)(y::MComplex)::Complex
```

#### A method for all non-complex, numeric, mutable types is:

```
function Base.:(sign)(y::MNumber)::Real
```

#### Additional methods for the `MRational` type are:

```
function Base.:(numerator)(y::MRational)::Integer
```

```
function Base.:(denominator)(y::MRational)::Integer
```

#### Additional methods for the `MReal` type are:

```
function Base.:(round)(y::MReal)::Real
```

```
function Base.:(ceil)(y::MReal)::Real
```

```
function Base.:(floor)(y::MReal)::Real
```

```
function Base.:(atan)(y::MNumber, x::MNumber)::Real
```

```
function Base.:(atan)(y::MNumber, x::Real)::Real
```

```
function Base.:(atan)(y::Real, x::MNumber)::Real
```

where `y` is the rise and `x` is the run in these `atan` methods.

#### Additional methods for the `MComplex` type are:

```
function Base.:(abs2)(y::MComplex)::Real
```

```
function Base.:(real)(y::MComplex)::Real
```

```
function Base.:(imag)(y::MComplex)::Real
```

```
function Base.:(conj)(y::MComplex)::Complex
```

```
function Base.:(angle)(y::MComplex)::Real
```

#### Math functions whose arguments can be of types `MNumber` or `MComplex` include:

```
function Base.:(sqrt)(y::MNumber)::Real
```

```
function Base.:(sqrt)(y::MComplex)::Complex
```

```
function Base.:(sin)(y::MNumber)::Real
```

```
function Base.:(sin)(y::MComplex)::Complex
```

```
function Base.:(cos)(y::MNumber)::Real
```

```
function Base.:(cos)(y::MComplex)::Complex
```

```
function Base.:(tan)(y::MNumber)::Real
```

```
function Base.:(tan)(y::MComplex)::Complex
```

```
function Base.:(sinh)(y::MNumber)::Real
```

```
function Base.:(sinh)(y::MComplex)::Complex
```

```
function Base.:(cosh)(y::MNumber)::Real
```

```
function Base.:(cosh)(y::MComplex)::Complex
```

```
function Base.:(tanh)(y::MNumber)::Real
```

```
function Base.:(tanh)(y::MComplex)::Complex
```

```
function Base.:(asin)(y::MNumber)::Real
```

```
function Base.:(asin)(y::MComplex)::Complex
```

```
function Base.:(acos)(y::MNumber)::Real
```

```
function Base.:(acos)(y::MComplex)::Complex
```

```
function Base.:(atan)(y::MNumber)::Real
```

```
function Base.:(atan)(y::MComplex)::Complex
```

```
function Base.:(asinh)(y::MNumber)::Real
```

```
function Base.:(asinh)(y::MComplex)::Complex
```

```
function Base.:(acosh)(y::MNumber)::Real
```

```
function Base.:(acosh)(y::MComplex)::Complex
```

```
function Base.:(atanh)(y::MNumber)::Real
```

```
function Base.:(atanh)(y::MComplex)::Complex
```

```
function Base.:(log)(y::MNumber)::Real
```

```
function Base.:(log)(y::MComplex)::Complex
```

```
function Base.:(log2)(y::MNumber)::Real
```

```
function Base.:(log2)(y::MComplex)::Complex
```

```
function Base.:(log10)(y::MNumber)::Real
```

```
function Base.:(log10)(y::MComplex)::Complex
```

```
function Base.:(exp)(y::MNumber)::Real
```

```
function Base.:(exp)(y::MComplex)::Complex
```

```
function Base.:(exp2)(y::MNumber)::Real
```

```
function Base.:(exp2)(y::MComplex)::Complex
```

```
function Base.:(exp10)(y::MNumber)::Real
```

```
function Base.:(exp10)(y::MComplex)::Complex
```

### Notes

Methods, operators and math functions pertaining to these types (except for `copy` and `deepcopy`) return instances belonging to their associated core types: viz., `Bool`, `Integer`, `Rational`, `Real` or `Complex`. This is because their intended use is to permit mutable fields to be incorporated into what are otherwise immutable data structures; thereby, allowing such fields to have a potential to change their values. Mutable fields belonging to immutable data structures have the necessary infrastructure to be able to be used seamlessly in simple mathematical formulae outside the data structure itself.

[Previous Page](.\README.md)

[Next Page](.\README_PhysicalUnits.md)
