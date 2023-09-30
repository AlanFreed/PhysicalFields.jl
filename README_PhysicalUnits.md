[Return to Main Document](.\README.md)

# PhysicalUnits

Physical fields have units, e.g., bodies have a mass. Such units are handled here in an unambiguous way. Two systems of units are introduced. The `SI` system of physical units, which is the default system in this implementation, and the `CGS` system of physical units. Other systems may be added in future releases.

## Concrete Type

The type handling physical systems of units is:
```
struct PhysicalUnits
    system::String
    length::Integer
    mass::Integer
    amount_of_substance::Integer
    time::Integer
    temperature::Integer
    electric_current::Integer
    light_intensity::Integer
end
```
where the integer values that hold the exponents for the respective field.
A dimensionless object has exponents of 0 for each of its seven fields.

### Constructor

Only one internal constructor is provided. It is the default constructor.
```
function PhysicalUnits(system::String, length::Integer, mass::Integer, amount_of_substance::Integer, time::Integer, temperature::Integer, electric_current::Integer, light_intensity::Integer)
```
To create a dimensionless object, one can call either call `PhysicalUnits("SI", 0, 0, 0, 0, 0, 0, 0)` or `PhysicalUnits("CGS", 0, 0, 0, 0, 0, 0, 0).` Both are treated the same, viz., being dimensionless is independent of one's choice for a physical system of units.

## Writers and Readers

To convert a system of units into a string for human consumption, one can call
```
function toString(y::PhysicalUnits)::String
```
which will produce outputs like g/(cm⋅s²) for denoting stress in the CGS system of units. This is likely the method one will use most often from the physical units section of module `PhysicalFields.`

To write a system of units to a JSON file, one can call
```
function toFile(y::PhysicalUnits, json_stream::IOStream)
```
where argument `json_stream` comes from a call to `openJSONWriter` discussed in [README.md](.\README.md).

To read a system of units from a JSON file, one can call
```
function fromFile(::Type{PhysicalUnits}, json_stream::IOStream)::PhysicalUnits
```
where argument `json_stream` comes from a call to `openJSONReader` discussed in [README.md](.\README.md).

## Predefined Sets of Physical Units

A large number of physical units are exported for use. If the units you require are not among these, you can readily create them where the integer values stored in the data structure are the exponents pertaining to each unit, e.g.,

```
ERG = PhysicalUnits("CGS", 2, 1, 0, -2, 0, 0, 0)  # 1 erg = 1 cm²⋅g/s²
```


### Physical units specific to the SI system of units.

* JOULE
* KILOGRAM
* NEWTON
* METER
* PASCAL

### Physical units implemented for the (default) SI system of units.

* ACCELERATION
* AMPERE
* AREA
* CANDELA
* COMPLIANCE
* DAMPING
* DIMENSIONLESS
* DISPLACEMENT
* ENERGY
* ENERGYperMASS
* ENTROPY
* ENTROPYperMASS
* FORCE
* GRAM_MOLE
* KELVIN
* LENGTH
* MASS
* MASS_DENSITY
* MODULUS
* POWER
* RECIPROCAL_TIME
* SECOND
* STIFFNESS
* STRAIN
* STRAIN_RATE
* STRESS
* STRESS_RATE
* STRETCH
* STRETCH_RATE
* TEMPERATURE
* TEMPERATURE_RATE
* TIME
* VELOCITY
* VOLUME

### Physical units specific to the CGS system of units.

* BARYE
* CENTIMETER
* DYNE
* ERG
* GRAM

### Physical units implemented for the CGS system of units.

* CGS_ACCELERATION
* CGS_AMPERE
* CGS_AREA
* CGS_CANDELA
* CGS_COMPLIANCE
* CGS_DAMPING
* CGS_DIMENSIONLESS
* CGS_DISPLACEMENT
* CGS_ENERGY
* CGS_ENERGYperMASS
* CGS_ENTROPY
* CGS_ENTROPYperMASS
* CGS_FORCE
* CGS_GRAM_MOLE
* CGS_KELVIN
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

### Overloaded Operators

* ==, ≠, +, -

When multiplying two physical fields the exponents of their units will add, while when dividing one physical field by another the exponents of their units will subtract.

### Methods

A method that makes shallow copies of unit types.
```
function Base.:(copy)(y::PhysicalUnits)::PhysicalUnits
```

A method that makes deep copies of unit types.
```
function Base.:(deepcopy)(y::PhysicalUnits)::PhysicalUnits
```

#### Type Testing

Test a set of physical units `y` to determine if they are dimensionless.
```
function isDimensionless(y::PhysicalUnits)::Bool
```

Test a set of physical units `y` to determine if they are SI units.
```
function isSI(y::PhysicalUnits)::Bool
```

Test a set of physical units `y` to determine if they are CGS units.
```
function isCGS(y::PhysicalUnits)::Bool
```

Test two sets of units `y` and `z` to determine if they represent the same physical unit, but possibly from a different systems of units.
```
function areEquivalent(y::PhysicalUnits, z::PhysicalUnits)::Bool
```
For example, consider stress; they may be called different names (e.g., `PASCAL` and `STRESS`), or they may associate with different physical systems of units (e.g., `PASCAL` and `BARYE`). In either case, this comparison would return `true.`

## Notes

There are other systems of units that could be introduced in future versions of this software, if needed, e.g., Imperial (British) units.

Types `PhysicalScalar,` `PhysicalVector` and `PhysicalTensor,` also defined in this module, all have a field that specifies the `PhysicalUnits` in which they are evaluated.

I wrote this package for personal consumption, unbeknownst at the time of an existing package [Unitful.jl](https://github.com/PainterQubits/Unitful.jl), which is quite advanced and well supported. Even so, there remains value in the implementation of type `PhysicalUnits,` as they are fields in my physical types (`PhysicalScalar,` `PhysicalVector` and `PhysicalTensor`) where units are handled ubiquitously, behind the scene, in scalar, vector and tensor operations.

Over the years I've written similar packages in different languages. This is by far the most elaborate implementation that I've written. When I was a student, I was taught to check my solutions by first checking their units. Existing scientific software has been wanting in this regard; hence, my creation of this capability here. 

[Home Page](.\README.md)

[Previous Page](.\README_MutableTypes.md)

[Next Page](.\README_PhysicalScalars.md)


