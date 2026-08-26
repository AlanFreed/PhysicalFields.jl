module PhysicalFields

import
    Base: ==, ≠, ≈, !, <, ≤, ≥, >, +, -, *, ÷, %, /, ^

import
    Base: abs, copy, deepcopy, get, getindex, setindex!, sign,
          ceil, floor, round,
          cos, cosh, sin, sinh, tan, tanh, sqrt,
          acos, acosh, asin, asinh, atan, atanh,
          log, log2, log10, exp, exp2, exp10,
          inv, transpose
    # Function atan can be either of the form atan(x) or of form atan(y,x).

import
    Printf: @sprintf

using
    JSON3,
    LinearAlgebra,
    StructTypes

export
    # abstract types

    MNumber,                # <: Number,  base type for mutable numbers.
    PhysicalField,          # An abstract type for physical fields.
    ArrayOfPhysicalFields,  # An abstract type for an array of physical fields.
                            
    # concrete types

    MBoolean,               #             a mutable boolean.
    MInteger,               # <: MNumber, a mutable integer number.
    MReal,                  # <: MNumber, a mutable real/floating-point number.

    MVector,                # A fixed dimension vector with mutable elements.
    MMatrix,                # A fixed dimension matrix with mutable elements.
    MArray,                 # A fixed dimension 3D array with mutable elements.
    
    Bool,                   # Type casting from MBoolean to Bool.
    Integer,                # Type casting from MInteger to Integer.
    Real,                   # Type casting from MReal to Real.
    Vector,                 # Type casting from MVector to Vector.
    Matrix,                 # Type casting from MMatrix to Matrix.
    Array,                  # Type casting from MArray to Array.
    
    PhysicalUnits,          # Type for systems of physical units.
    #   units included:     # length, mass, amount of substance, time,
                            # temperature, electric current, and luminous
                            # intensity

    PhysicalScalar,         # <: PhysicalField,  A number with units.
    PhysicalVector,         # <: PhysicalField,  A vector (array)  with units.
    PhysicalTensor,         # <: PhysicalField,  A tensor (matrix) with units.
    ArrayOfPhysicalScalars, # <: ArrayOfPhysicalFields, scalars with same set of units.
    ArrayOfPhysicalVectors, # <: ArrayOfPhysicalFields, vectors with same length and units.
    ArrayOfPhysicalTensors, # <: ArrayOfPhysicalFields, tensors with same size and units.

    # functions

    openJSONReader,
    openJSONWriter,
    closeJSONStream,

    # methods

    get,
    getindex,
    set!,
    setindex!,

    fromFile,
    toFile,
    toString,
    toReal,
    toVector,
    toMatrix,

    isCGS,
    isSI,
    isDimensionless,
    areEquivalent,

    toCGS,
    toSI,

    abs,
    round,
    ceil,
    floor,
    sign,
    sin,
    cos,
    tan,
    sinh,
    cosh,
    tanh,
    asin,
    acos,
    atan,
    asinh,
    acosh,
    atanh,
    log,
    log2,
    log10,
    exp,
    exp2,
    exp10,
    sqrt,
    
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

# persistence to file and string
include("Persistence.jl")

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

