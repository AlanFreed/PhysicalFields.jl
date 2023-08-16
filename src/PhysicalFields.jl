module PhysicalFields

import
    Base: ==, ≠, ≈, !, <, ≤, ≥, >, +, -, *, ÷, %, //, /, ^

import
    Base: abs, copy, deepcopy, get, getindex, setindex!, sign,
          denominator, numerator,                    # for rationals
          ceil, floor, round,                        # for reals
          abs2, angle, conj, imag, real,             # for complex
          cos, cosh, sin, sinh, tan, tanh, sqrt,     # trig functions
          acos, acosh, asin, asinh, atan, atanh,     # inverse trig functions
          log, log2, log10, exp, exp2, exp10         # log-exponential functions
    # Function atan can be either of the form atan(x) or of form atan(y,x).

import
    Printf: @sprintf

using
    JSON3,
    LinearAlgebra,
    StructTypes

export
    # abstract types

    MType,                   # <: Number,  the base type for mutable types.
    MNumber,                 # <: MType,   the base type for mutable numbers.

    PhysicalUnits,           # Abstract type for systems of physical units.

    PhysicalField,           # An abstract type for physical fields.

    # concrete types

    MBool,                   # <: MType,   a mutable boolean.
    MInteger,                # <: MNumber, a mutable integer number.
    MRational,               # <: MNumber, a mutable rational number.
    MReal,                   # <: MNumber, a mutable real/floating-point number.
    MComplex,                # <: MType,   a mutable complex number.

    Dimensionless,           # <: PhysicalUnits, an absence of physical units.
    CGS,                     # <: PhysicalUnits, Centimeter, Gram, Second units.
    SI,                      # <: PhysicalUnits, International System of units.
    #   units included are:  length, mass, time and temperature
    #   units absent are:    electric current, amount of substance, and
    #                        luminous intensity

    PhysicalScalar,          # <: PhysicalField,  A number with units.
    PhysicalVector,          # <: PhysicalField,  A vector (array)  with units.
    PhysicalTensor,          # <: PhysicalField,  A tensor (matrix) with units.
    ArrayOfPhysicalScalars,  # Array of scalars with the same set of units.
    ArrayOfPhysicalVectors,  # Array of vectors with the same length and units.
    ArrayOfPhysicalTensors,  # Array of tensors with the same size and units.

    # functions

    openJSONReader,
    openJSONWriter,
    closeJSONStream,

    # methods

    set!,

    fromFile,
    toFile,
    toString,

    isCGS,
    isSI,
    isDimensionless,
    areEquivalent,

    toCGS,
    toSI,
    toReal,
    toArray,
    toMatrix,

    norm,
    unitVector,
    cross,

    tensorProduct,
    transpose,
    tr,
    det,
    inv,
    qr,
    lq,

    # constants

    # CGS physical constants: specific
    BARYE,
    CENTIGRADE,
    CENTIMETER,
    DYNE,
    ERG,
    GRAM,
    # CGS physical constants: general
    CGS_ACCELERATION,
    CGS_AREA,
    CGS_COMPLIANCE,
    CGS_DAMPING,
    CGS_DIMENSIONLESS,
    CGS_DISPLACEMENT,
    CGS_ENERGY,
    CGS_ENERGYperMASS,
    CGS_ENTROPY,
    CGS_ENTROPYperMASS,
    CGS_FORCE,
    CGS_LENGTH,
    CGS_MASS,
    CGS_MASS_DENSITY,
    CGS_MODULUS,
    CGS_POWER,
    CGS_RECIPROCAL_TIME,
    CGS_SECOND,
    CGS_STIFFNESS,
    CGS_STRAIN,
    CGS_STRAIN_RATE,
    CGS_STRESS,
    CGS_STRESS_RATE,
    CGS_STRETCH,
    CGS_STRETCH_RATE,
    CGS_TEMPERATURE,
    CGS_TEMPERATURE_RATE,
    CGS_TIME,
    CGS_VELOCITY,
    CGS_VOLUME,
    # SI physical constants: specific
    JOULE,
    KELVIN,
    KILOGRAM,
    NEWTON,
    METER,
    PASCAL,
    # SI physical constants: general
    SI_ACCELERATION,
    SI_AREA,
    SI_COMPLIANCE,
    SI_DAMPING,
    SI_DIMENSIONLESS,
    SI_DISPLACEMENT,
    SI_ENERGY,
    SI_ENERGYperMASS,
    SI_ENTROPY,
    SI_ENTROPYperMASS,
    SI_FORCE,
    SI_LENGTH,
    SI_MASS,
    SI_MASS_DENSITY,
    SI_MODULUS,
    SI_POWER,
    SI_RECIPROCAL_TIME,
    SI_SECOND,
    SI_STIFFNESS,
    SI_STRAIN,
    SI_STRAIN_RATE,
    SI_STRESS,
    SI_STRESS_RATE,
    SI_STRETCH,
    SI_STRETCH_RATE,
    SI_TEMPERATURE,
    SI_TEMPERATURE_RATE,
    SI_TIME,
    SI_VELOCITY,
    SI_VOLUME

### source files

# mutable types
include("MutableTypes.jl")

# physical systems of units
include("PhysicalSystemsOfUnits.jl")

# physical types
include("PhysicalTypes.jl")

# physical scalars
include("PhysicalScalars.jl")

# physical vectors
include("PhysicalVectors.jl")

# physical tensors
include("PhysicalTensors.jl")

end # module PhysicalFields
