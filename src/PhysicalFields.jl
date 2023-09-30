module PhysicalFields

import
    Base: ==, ≠, ≈, !, <, ≤, ≥, >, +, -, *, ÷, %, //, /, ^

import
    Base: abs, copy, deepcopy, get, getindex, setindex!, sign,
          denominator, gcd, numerator,               # for rationals
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

    MNumber,                 # <: Number,  base type for mutable numbers.
    PhysicalField,           # An abstract type for physical fields.

    # concrete types

    MBoolean,                #             a mutable boolean.
    MInteger,                # <: MNumber, a mutable integer number.
    MReal,                   # <: MNumber, a mutable real/floating-point number.

    MVector,                 # A vector with mutable elements.
    MMatrix,                 # A matrix with mutable elements.
    MArray,                  # A 3D array with mutable elements.

    PhysicalUnits,           # Type for systems of physical units.
    #   units included:        length, mass, amount of substance, time, temperature,
    #                          electric current, and luminous intensity

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
    toVector,
    toMatrix,

    norm,
    unitVector,
    cross,

    matrixProduct,
    tensorProduct,
    transpose,
    tr,
    det,
    inv,
    qr,
    lq,

    # constants

    # SI physical constants: specific
    JOULE,
    KILOGRAM,
    NEWTON,
    METER,
    PASCAL,

    # SI physical constants: general (the default physical system of units)
    ACCELERATION,
    AMPERE,
    AREA,
    CANDELA,
    COMPLIANCE,
    DAMPING,
    DIMENSIONLESS,
    DISPLACEMENT,
    ENERGY,
    ENERGYperMASS,
    ENTROPY,
    ENTROPYperMASS,
    FORCE,
    GRAM_MOLE,
    KELVIN,
    LENGTH,
    MASS,
    MASS_DENSITY,
    MODULUS,
    POWER,
    RECIPROCAL_TIME,
    SECOND,
    STIFFNESS,
    STRAIN,
    STRAIN_RATE,
    STRESS,
    STRESS_RATE,
    STRETCH,
    STRETCH_RATE,
    TEMPERATURE,
    TEMPERATURE_RATE,
    TIME,
    VELOCITY,
    VOLUME,

    # CGS physical constants: specific
    BARYE,
    CENTIMETER,
    DYNE,
    ERG,
    GRAM,

    # CGS physical constants: general
    CGS_ACCELERATION,
    CGS_AMPERE,
    CGS_AREA,
    CGS_CANDELA,
    CGS_COMPLIANCE,
    CGS_DAMPING,
    CGS_DIMENSIONLESS,
    CGS_DISPLACEMENT,
    CGS_ENERGY,
    CGS_ENERGYperMASS,
    CGS_ENTROPY,
    CGS_ENTROPYperMASS,
    CGS_FORCE,
    CGS_GRAM_MOLE,
    CGS_KELVIN,
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
    CGS_VOLUME

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
