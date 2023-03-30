
[Return to Main Document](.\README.md)

# PhysicalUnits

## Abstract Type

The super (or parent) type for all physical systems of units.

```
abstract type PhysicalUnits end
```

## Concrete Types

The CGS (Centimeter, Gram, Second) system of units.

```
struct CGS <: PhysicalUnits
    cm::Int8   # centimeters
    g::Int8    # grams
    s::Int8    # seconds
    C::Int8    # degrees centigrade
end
```

The SI (International System of Units) system of units.

```
struct SI <: PhysicalUnits
    m::Int8    # meters
    kg::Int8   # kilograms
    s::Int8    # seconds
    K::Int8    # Kelvin
end
```

Not included in these implementations are units for amount of substance, luminous intensity, and electric current.

### Predefined Sets of Physical Units

A large number of physical units are exported for use. If the units you require are not amongst these, you can readily create them where the integer values stored in the data structure are the exponents pertaining to each unit, e.g.,

```
const ERG = CGS(2, 1, -2, 0)  # 1 erg = 1 g⋅cm²/s²
```
#### CGS physical constants: specific

* BARYE
* CENTIGRADE
* CENTIMETER
* DYNE
* ERG
* GRAM

#### CGS physical constants: general

* CGS_ACCELERATION
* CGS_AREA
* CGS_COMPLIANCE
* CGS_DAMPING
* CGS_DIMENSIONLESS
* CGS_DISPLACEMENT
* CGS_ENERGY
* CGS_ENERGYperMASS
* CGS_ENTROPY
* CGS_ENTROPYperMASS
* CGS_FORCE
* CGS_LENGTH
* CGS_MASS
* CGS_MASS_DENSITY
* CGS_MODULUS
* CGS_POWER
* CGS_RECIPROCAL_TIME
* CGS_SECOND
* CGS_STIFFNESS
* CGS_STRAIN
* CGS_STRAIN_RATE
* CGS_STRESS
* CGS_STRESS_RATE
* CGS_STRETCH
* CGS_STRETCH_RATE
* CGS_TEMPERATURE
* CGS_TEMPERATURE_RATE
* CGS_TIME
* CGS_VELOCITY
* CGS_VOLUME

#### SI physical constants: specific

* JOULE
* KELVIN
* KILOGRAM
* NEWTON
* METER
* PASCAL

#### SI physical constants: general

* SI_ACCELERATION
* SI_AREA
* SI_COMPLIANCE
* SI_DAMPING
* SI_DIMENSIONLESS
* SI_DISPLACEMENT
* SI_ENERGY
* SI_ENERGYperMASS
* SI_ENTROPY
* SI_ENTROPYperMASS
* SI_FORCE
* SI_LENGTH
* SI_MASS
* SI_MASS_DENSITY
* SI_MODULUS
* SI_POWER
* SI_RECIPROCAL_TIME
* SI_SECOND
* SI_STIFFNESS
* SI_STRAIN
* SI_STRAIN_RATE
* SI_STRESS
* SI_STRESS_RATE
* SI_STRETCH
* SI_STRETCH_RATE
* SI_TEMPERATURE
* SI_TEMPERATURE_RATE
* SI_TIME
* SI_VELOCITY
* SI_VOLUME

### Overloaded Operators

* ==, ≠, +, -

When multiplying two sets of units one adds their exponents, while when dividing two sets of units one subtracts their exponents.

### Methods

Methods that make shallow copies of units types include:

```
function Base.:(copy)(u::CGS)::CGS
```

```
function Base.:(copy)(u::SI)::SI
```

Methods that make deep copies of units types include:

```
function Base.:(deepcopy)(u::CGS)::CGS
```

```
function Base.:(deepcopy)(u::SI)::SI
```

Methods that convert objects into strings include:

```
function toString(u::CGS)::String
```

```
function toString(u::SI)::String
```

#### Type Testing

Test a set of units `u` to determine if they are CGS units.

```
function isCGS(u::PhysicalUnits)::Bool
```

Test a set of units `u` to determine if they are SI units.

```
function isSI(u::PhysicalUnits)::Bool
```

Test a set of units `u` to determine if they are dimensionless.

```
function isDimensionless(u::PhysicalUnits)::Bool
```

Test two sets of units `u` and `v` to determine if they represent the same physical unit, e.g., stress, but maybe they are called different names (e.g., `PASCAL` and `SI_STRESS`) or maybe they associated with different physical systems of units (e.g., `PASCAL` and `BARYE`).

```
function isEquivalent(u::PhysicalUnits, v::PhysicalUnits)::Bool
```

## Notes

Of the seven kinds of physical units that exist. Only four are implemented here; namely: length, mass, time and temperature. Not included are the physical units for electric current, amount of substance, and luminous intensity. There are other systems of units that could be introduced in future versions of this software, if needed, e.g., imperial (British) units.

Types `PhysicalScalar`, `PhysicalVector` and `PhysicalTensor`, also defined in this module, all have a field that specifies the `PhysicalUnits` in which they are evaluated.

I wrote this package for personal consumption, unbeknownst at the time of the existing package [Unitful.jl](https://github.com/PainterQubits/Unitful.jl), which is quite advanced and well supported. Even so, there remains value in implementations of type `PhysicalUnits`, as they are fields in my types (`PhysicalScalar`, `PhysicalVector` and `PhysicalTensor`) where units are handled ubiquitously, behind the scene, in all scalar, vector and tensor operations.

[Home Page](.\README.md)

[Previous Page](.\README_MutableTypes.md)

[Next Page](.\README_PhysicalScalars.md)


