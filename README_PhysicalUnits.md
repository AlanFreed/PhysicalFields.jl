[Return to Main Document](.\README.md)

# PhysicalUnits

Physical fields have units, e.g., bodies have a mass. Such units are handled here in an unambiguous way. Three systems of units are introduced. The trivial system `Dimensionless`, the `CGS` system (the default), and the `SI` system. Other systems could be added in future releases.

Not included in these implementations are units for amount of substance, luminous intensity, and electric current. One could also add these in future releases.

## Abstract Type

The super (or parent) type for all physical systems of units.

```
abstract type PhysicalUnits end
```

## Concrete Types

The Dimensionless system of units is.
```
struct Dimensionless <: PhysicalUnits
    len::Int8   # exponent for the unit of length,      len  = 0  
    mass::Int8  # exponent for the unit of mass,        mass = 0
    time::Int8  # exponent for the unit of time,        time = 0
    temp::Int8  # exponent for the unit of temperature, temp = 0
end
```
A dimensionless field has exponents of 0 for each of its qualities.

The CGS (Centimeter, Gram, Second) system of units (plus a temperature unit).
```
struct CGS <: PhysicalUnits
    cm::Int8  # exponent for the unit of length:      centimeters
    g::Int8   # exponent for the unit of mass:        grams
    s::Int8   # exponent for the unit of time:        seconds
    C::Int8   # exponent for the unit of temperature: degrees centigrade
end
```

The SI (International System of Units) system of units (plus a temperature unit).
```
struct SI <: PhysicalUnits
    m::Int8   # exponent for the unit of length:      meters
    kg::Int8  # exponent for the unit of mass:        kilograms
    s::Int8   # exponent for the unit of time:        seconds
    K::Int8   # exponent for the unit of temperature: Kelvin
end
```

### Constructors

Only internal constructors are provided.

#### Dimensionless Objects

To create a dimensionless object, one can call
```
function Dimensionless()
```
or one can either call `CGS(0, 0, 0, 0)` or `SI(0, 0, 0, 0).`

#### CGS Objects

To create an object belonging to the `CGS` system of units, call
```
function CGS(cm::Integer, g::Integer, s::Integer, C::Integer)::PhysicalUnits
```
which returns a new instance of type `CGS.`

#### SI Objects

To create an object belonging to the `SI` system of units, call
```
function SI(m::Integer, kg::Integer, s::Integer, K::Integer)::PhysicalUnits
```
which returns a new instance of type `SI.`

### Writers and Readers

To convert a system of units into a string for human consumption, one can call
```
function toString(u::Dimensionless)::String
function toString(u::CGS)::String
function toString(u::SI)::String
```
which will produce outputs like g/(cm⋅s²) for denoting stress in the CGS system of units.

To write a system of units to a JSON file, one can call
```
function toFile(y::Dimensionless, json_stream::IOStream)
function toFile(y::CGS, json_stream::IOStream)
function toFile(y::SI, json_stream::IOStream)
```
where argument `json_stream` comes from a call to `openJSONWriter.` 

To read a system of units from a JSON file, one can call
```
function fromFile(::Type{Dimensionless}, json_stream::IOStream)::Dimensionless
function fromFile(::Type{CGS}, json_stream::IOStream)::CGS
function fromFile(::Type{SI}, json_stream::IOStream)::SI
```
where argument `json_stream` comes from a call to `openJSONReader.` 

These methods require the type to be read in to be a known entity, fore which a call to this method returns an object of the specified type. Meta programming is not used here.

## Predefined Sets of Physical Units

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

When multiplying two physical fields the exponents of their units one add, while when dividing one physical field by another the exponents of their units subtract.

### Methods

A method that makes shallow copies of unit types.
```
function Base.:(copy)(u::CGS)::CGS
function Base.:(copy)(u::SI)::SI
```

A method that makes deep copies of unit types.
```
function Base.:(deepcopy)(u::CGS)::CGS
function Base.:(deepcopy)(u::SI)::SI
```

#### Type Testing

Test a set of units `u` to determine if they are dimensionless.
```
function isDimensionless(u::PhysicalUnits)::Bool
```

Test a set of units `u` to determine if they are CGS units.
```
function isCGS(u::PhysicalUnits)::Bool
```

Test a set of units `u` to determine if they are SI units.
```
function isSI(u::PhysicalUnits)::Bool
```

Test two sets of units `u` and `v` to determine if they represent the same physical unit, but possibly from a different systems of units.
```
function areEquivalent(u::PhysicalUnits, v::PhysicalUnits)::Bool
```
For example, consider stress; they may be called different names (e.g., `PASCAL` and `SI_STRESS`), or they may associate with different physical systems of units (e.g., `PASCAL` and `BARYE`). In either case, this comparison would return `true.`

## Notes

Of the seven kinds of physical units that exist. Only four are implemented here; namely: length, mass, time and temperature. Not included are the physical units for electric current, amount of substance, and luminous intensity. There are other systems of units that could be introduced in future versions of this software, if needed, e.g., imperial (British) units.

Types `PhysicalScalar,` `PhysicalVector` and `PhysicalTensor,` also defined in this module, all have a field that specifies the `PhysicalUnits` in which they are evaluated.

I wrote this package for personal consumption, unbeknownst at the time of an existing package [Unitful.jl](https://github.com/PainterQubits/Unitful.jl), which is quite advanced and well supported. Even so, there remains value in the implementation of type `PhysicalUnits,` as they are fields in my physical types (`PhysicalScalar,` `PhysicalVector` and `PhysicalTensor`) where units are handled ubiquitously, behind the scene, in all scalar, vector and tensor operations.

Over the years I've written similar packages in different languages. This is by far the most elaborate implementation that I've written. When I was a student, I was taught to check my solutions by first checking their units. Existing scientific software has been wanting in this regard; hence, my creation of this capability here. 

[Home Page](.\README.md)

[Previous Page](.\README_MutableTypes.md)

[Next Page](.\README_PhysicalScalars.md)


