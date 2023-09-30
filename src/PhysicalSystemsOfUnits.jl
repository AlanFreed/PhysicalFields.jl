# PhysicalSystemsOfUnits

# Exported type
struct PhysicalUnits
    system::String
    length::Integer
    mass::Integer
    amount_of_substance::Integer
    time::Integer
    temperature::Integer
    electric_current::Integer
    light_intensity::Integer

    # constructor

    function PhysicalUnits(system::String, length::Integer, mass::Integer, amount_of_substance::Integer, time::Integer, temperature::Integer, electric_current::Integer, light_intensity::Integer)
        return new(system, length, mass, amount_of_substance, time, temperature, electric_current, light_intensity)
    end
end

#=
-------------------------------------------------------------------------------
=#

# Type testing

"""
    isDimensionless(y::PhysicalUnits)::Bool

Returns `true` if `y` is without physical dimension; otherwise, it returns `false`.
"""
function isDimensionless(y::PhysicalUnits)::Bool
    if ((y.length == 0) &&
        (y.mass == 0) &&
        (y.amount_of_substance == 0) &&
        (y.time == 0) &&
        (y.temperature == 0) &&
        (y.electric_current == 0) &&
        (y.light_intensity == 0))
        return true
    else
        return false
    end
end


"""
    isSI(y::PhysicalUnits)::Bool

Returns `true` if `y` has SI units; otherwise, it returns `false`.
"""
function isSI(y::PhysicalUnits)::Bool
    if (y.system == "SI") || isDimensionless(y)
        return true
    else
        return false
    end
end

"""
    isCGS(y::PhysicalUnits)::Bool

Returns `true` if `y` has CGS units; otherwise, it returns `false`.
"""
function isCGS(y::PhysicalUnits)::Bool
    if (y.system == "CGS") || isDimensionless(y)
        return true
    else
        return false
    end
end

"""
    areEquivalent(y::PhysicalUnits, z::PhysicalUnits)::Bool

Returns `true` if `y` and `z` are the same kind of unit, but possibly belong to different systems of units; otherwise, returns `false`.
"""
function areEquivalent(y::PhysicalUnits, z::PhysicalUnits)::Bool
    if ((y.length == z.length) &&
        (y.mass == z.mass) &&
        (y.amount_of_substance == z.amount_of_substance) &&
        (y.time == z.time) &&
        (y.temperature == z.temperature) &&
        (y.electric_current == z.electric_current) &&
        (y.light_intensity == z.light_intensity))
        return true
    else
        return false
    end
end

"""
    toSI(y::PhysicalUnits)::PhysicalUnits

Converts the system of units held in `y` to the SI system.
"""
function toSI(y::PhysicalUnits)::PhysicalUnits
    if y.system == "SI"
        return y
    else
        return PhysicalUnits("SI", y.length, y.mass, y.amount_of_substance, y.time, y.temperature, y.electric_current, y.light_intensity)
    end
end

"""
    toCGS(y::PhysicalUnits)::PhysicalUnits

Converts the system of units held in `y` to the CGS system.
"""
function toCGS(y::PhysicalUnits)::PhysicalUnits
    if y.system == "CGS"
        return y
    else
        return PhysicalUnits("CGS", y.length, y.mass, y.amount_of_substance, y.time, y.temperature, y.electric_current, y.light_intensity)
    end
end

#=
--------------------------------------------------------------------------------
=#

# Overloaded these operators: logical: ==, ≠
#                             unary:   +, -
#                             binary:  +, -

function Base.:(==)(y::PhysicalUnits, z::PhysicalUnits)::Bool
    if (y.system == z.system) && areEquivalent(y, z)
        return true
    else
        return false
    end
end

function Base.:≠(y::PhysicalUnits, z::PhysicalUnits)::Bool
    return !(y == z)
end

function Base.:+(y::PhysicalUnits)::PhysicalUnits
    return y
end

function Base.:-(y::PhysicalUnits)::PhysicalUnits
    return PhysicalUnits(y.system, -y.length, -y.mass, -y.amount_of_substance, -y.time, -y.temperature, -y.electric_current, -y.light_intensity)
end

function Base.:+(y::PhysicalUnits, z::PhysicalUnits)::PhysicalUnits
    if y.system == z.system
        length = y.length + z.length
        mass = y.mass + z.mass
        amount_of_substance = y.amount_of_substance + z.amount_of_substance
        time = y.time + z.time
        temperature = y.temperature + z.temperature
        electric_current = y.electric_current + z.electric_current
        light_intensity = y.light_intensity + z.light_intensity
        return PhysicalUnits(y.system, length, mass, amount_of_substance, time, temperature, electric_current, light_intensity)
    else
        msg = "The two sets of units belong to different systems of units."
        throw(ErrorException(msg))
    end
end

function Base.:-(y::PhysicalUnits, z::PhysicalUnits)::PhysicalUnits
    if y.system == z.system
        length = y.length - z.length
        mass = y.mass - z.mass
        amount_of_substance = y.amount_of_substance - z.amount_of_substance
        time = y.time - z.time
        temperature = y.temperature - z.temperature
        electric_current = y.electric_current - z.electric_current
        light_intensity = y.light_intensity - z.light_intensity
        return PhysicalUnits(y.system, length, mass, amount_of_substance, time, temperature, electric_current, light_intensity)
    else
        msg = "The two sets of units belong to different systems of units."
        throw(ErrorException(msg))
    end
end

#=
-------------------------------------------------------------------------------
=#

# Methods extending their base methods.

function Base.:(copy)(y::PhysicalUnits)::PhysicalUnits
    system = copy(y.system)
    length = copy(y.length)
    mass = copy(y.mass)
    amount_of_substance = copy(y.amount_of_substance)
    time = copy(y.time)
    temperature = copy(y.temperature)
    electric_current = copy(y.electric_current)
    light_intensity = copy(y.light_intensity)
    return PhysicalUnits(y.system, length, mass, amount_of_substance, time, temperature, electric_current, light_intensity)
end

function Base.:(deepcopy)(y::PhysicalUnits)::PhysicalUnits
    system = deepcopy(y.system)
    length = deepcopy(y.length)
    mass = deepcopy(y.mass)
    amount_of_substance = deepcopy(y.amount_of_substance)
    time = deepcopy(y.time)
    temperature = deepcopy(y.temperature)
    electric_current = deepcopy(y.electric_current)
    light_intensity = deepcopy(y.light_intensity)
    return PhysicalUnits(y.system, length, mass, amount_of_substance, time, temperature, electric_current, light_intensity)
end

#=
--------------------------------------------------------------------------------
=#

# Methods that convert a system of units into a string.

function toString(y::PhysicalUnits)::String
    # Length units in numerator.
    if y.length > 0
        if y.system == "SI"
            if y.length == 1
                s1 = "m"
            elseif y.length == 2
                s1 = "m²"
            elseif y.length == 3
                s1 = "m³"
            elseif y.length == 4
                s1 = "m⁴"
            else
                s1 = string("m^", string(y.length))
            end
        elseif y.system == "CGS"
            if y.length == 1
                s1 = "cm"
            elseif y.length == 2
                s1 = "cm²"
            elseif y.length == 3
                s1 = "cm³"
            elseif y.length == 4
                s1 = "cm⁴"
            else
                s1 = string("cm^", string(y.length))
            end
        else
            msg = "The system of units is unknown."
            throw(ErrorException(msg))
        end
        if ((y.mass > 0) ||
            (y.amount_of_substance > 0) ||
            (y.time > 0) ||
            (y.temperature > 0) ||
            (y.electric_current > 0) ||
            (y.light_intensity > 0))
            s1 = string(s1, "⋅")
        end
    else
        s1 = ""
    end
    # Mass units in numerator.
    if y.mass > 0
        if y.system == "SI"
            if y.mass == 1
                s2 = "kg"
            elseif y.mass == 2
                s2 = "kg²"
            elseif y.mass == 3
                s2 = "kg³"
            elseif y.mass == 4
                s2 = "kg⁴"
            else
                s2 = string("kg^", string(y.mass))
            end
        elseif y.system == "CGS"
            if y.mass == 1
                s2 = "g"
            elseif y.mass == 2
                s2 = "g²"
            elseif y.mass == 3
                s2 = "g³"
            elseif y.mass == 4
                s2 = "g⁴"
            else
                s2 = string("g^", string(y.mass))
            end
        else
            msg = "The system of units is unknown."
            throw(ErrorException(msg))
        end
        if ((y.amount_of_substance > 0) ||
            (y.time > 0) ||
            (y.temperature > 0) ||
            (y.electric_current > 0) ||
            (y.light_intensity > 0))
            s2 = string(s2, "⋅")
        end
    else
        s2 = ""
    end
    # Molar units in numerator.
    if y.amount_of_substance > 0
        if (y.system == "SI") || (y.system == "CGS")
            if y.amount_of_substance == 1
                s3 = "mol"
            elseif y.amount_of_substance == 2
                s3 = "mol²"
            elseif y.amount_of_substance == 3
                s3 = "mol³"
            elseif y.amount_of_substance == 4
                s3 = "mol⁴"
            else
                s3 = string("mol^", string(y.amount_of_substance))
            end
        else
            msg = "The system of units is unknown."
            throw(ErrorException(msg))
        end
        if ((y.time > 0) ||
            (y.temperature > 0) ||
            (y.electric_current > 0) ||
            (y.light_intensity > 0))
            s3 = string(s3, "⋅")
        end
    else
        s3 = ""
    end
    # Time units in numerator.
    if y.time > 0
        if (y.system == "SI") || (y.system == "CGS")
            if y.time == 1
                s4 = "s"
            elseif y.time == 2
                s4 = "s²"
            elseif y.time == 3
                s4 = "s³"
            elseif y.time == 4
                s4 = "s⁴"
            else
                s4 = string("s^", string(y.time))
            end
        else
            msg = "The system of units is unknown."
            throw(ErrorException(msg))
        end
        if ((y.temperature > 0) ||
            (y.electric_current > 0) ||
            (y.light_intensity > 0))
            s4 = string(s4, "⋅")
        end
    else
        s4 = ""
    end
    # Temperature units in numerator.
    if y.temperature > 0
        if (y.system == "SI") || (y.system == "CGS")
            if y.temperature == 1
                s5 = "K"
            elseif y.temperature == 2
                s5 = "K²"
            elseif y.temperature == 3
                s5 = "K³"
            elseif y.temperature == 4
                s5 = "K⁴"
            else
                s5 = string("K^", string(y.temperature))
            end
        else
            msg = "The system of units is unknown."
            throw(ErrorException(msg))
        end
        if ((y.electric_current > 0) ||
            (y.light_intensity > 0))
            s5 = string(s5, "⋅")
        end
    else
        s5 = ""
    end
    # Electric current units in numerator.
    if y.electric_current > 0
        if (y.system == "SI") || (y.system == "CGS")
            if y.electric_current == 1
                s6 = "A"
            elseif y.electric_current == 2
                s6 = "A²"
            elseif y.electric_current == 3
                s6 = "A³"
            elseif y.electric_current == 4
                s6 = "A⁴"
            else
                s6 = string("A^", string(y.electric_current))
            end
        else
            msg = "The system of units is unknown."
            throw(ErrorException(msg))
        end
        if y.light_intensity > 0
            s6 = string(s6, "⋅")
        end
    else
        s6 = ""
    end
    # Light intensity units in numerator.
    if y.light_intensity > 0
        if (y.system == "SI") || (y.system == "CGS")
            if y.light_intensity == 1
                s7 = "cd"
            elseif y.light_intensity == 2
                s7 = "cd²"
            elseif y.light_intensity == 3
                s7 = "cd³"
            elseif y.light_intensity == 4
                s7 = "cd⁴"
            else
                s7 = string("cd^", string(y.light_intensity))
            end
        else
            msg = "The system of units is unknown."
            throw(ErrorException(msg))
        end
    else
        s7 = ""
    end
    # Transition from the numerator to the denominator.
    count = 0
    if y.length < 0
        count += 1
    end
    if y.mass < 0
        count += 1
    end
    if y.amount_of_substance < 0
        count += 1
    end
    if y.time < 0
        count += 1
    end
    if y.temperature < 0
        count += 1
    end
    if y.electric_current < 0
        count += 1
    end
    if y.light_intensity < 0
        count += 1
    end
    if count > 1
        if ((y.length < 1) &&
            (y.mass < 1) &&
            (y.amount_of_substance < 1) &&
            (y.time < 1) &&
            (y.temperature < 1) &&
            (y.electric_current < 1) &&
            (y.light_intensity < 1))
            s8 = "1/("
        else
            s8 = "/("
        end
    elseif count == 1
        if ((y.length < 1) &&
            (y.mass < 1) &&
            (y.amount_of_substance < 1) &&
            (y.time < 1) &&
            (y.temperature < 1) &&
            (y.electric_current < 1) &&
            (y.light_intensity < 1))
            s8 = "1/"
        else
            s8 = "/"
        end
    else
        s8 = ""
    end
    # Length units in demoninator.
    if y.length < 0
        if y.system == "SI"
            if y.length == -1
                s9 = "m"
            elseif y.length == -2
                s9 = "m²"
            elseif y.length == -3
                s9 = "m³"
            elseif y.length == -4
                s9 = "m⁴"
            else
                s9 = string("m^", string(-y.length))
            end
        elseif y.system == "CGS"
            if y.length == -1
                s9 = "cm"
            elseif y.length == -2
                s9 = "cm²"
            elseif y.length == -3
                s9 = "cm³"
            elseif y.length == -4
                s9 = "cm⁴"
            else
                s9 = string("cm^", string(-y.length))
            end
        else
            msg = "The system of units is unknown."
            throw(ErrorException(msg))
        end
        if ((y.mass < 0) ||
            (y.amount_of_substance < 0) ||
            (y.time < 0) ||
            (y.temperature < 0) ||
            (y.electric_current < 0) ||
            (y.light_intensity < 0))
            s9 = string(s9, "⋅")
        end
    else
        s9 = ""
    end
    # Mass units in demoninator.
    if y.mass < 0
        if y.system == "SI"
            if y.mass == -1
                s10 = "kg"
            elseif y.mass == -2
                s10 = "kg²"
            elseif y.mass == -3
                s10 = "kg³"
            elseif y.mass == -4
                s10 = "kg⁴"
            else
                s10 = string("kg^", string(-y.mass))
            end
        elseif y.system == "CGS"
            if y.mass == -1
                s10 = "g"
            elseif y.mass == -2
                s10 = "g²"
            elseif y.mass == -3
                s10 = "g³"
            elseif y.mass == -4
                s10 = "g⁴"
            else
                s10 = string("g^", string(-y.mass))
            end
        else
            msg = "The system of units is unknown."
            throw(ErrorException(msg))
        end
        if ((y.amount_of_substance < 0) ||
            (y.time < 0) ||
            (y.temperature < 0) ||
            (y.electric_current < 0) ||
            (y.light_intensity < 0))
            s10 = string(s10, "⋅")
        end
    else
        s10 = ""
    end
    # Molar units in demoninator.
    if y.amount_of_substance < 0
        if (y.system == "SI") || (y.system == "CGS")
            if y.amount_of_substance == -1
                s11 = "mol"
            elseif y.amount_of_substance == -2
                s11 = "mol²"
            elseif y.amount_of_substance == -3
                s11 = "mol³"
            elseif y.amount_of_substance == -4
                s11 = "mol⁴"
            else
                s11 = string("mol^", string(-y.amount_of_substance))
            end
        else
            msg = "The system of units is unknown."
            throw(ErrorException(msg))
        end
        if ((y.time < 0) ||
            (y.temperature < 0) ||
            (y.electric_current < 0) ||
            (y.light_intensity < 0))
            s11 = string(s11, "⋅")
        end
    else
        s11 = ""
    end
    # Time units in demoninator.
    if y.time < 0
        if (y.system == "SI") || (y.system == "CGS")
            if y.time == -1
                s12 = "s"
            elseif y.time == -2
                s12 = "s²"
            elseif y.time == -3
                s12 = "s³"
            elseif y.time == -4
                s12 = "s⁴"
            else
                s12 = string("s^", string(-y.time))
            end
        else
            msg = "The system of units is unknown."
            throw(ErrorException(msg))
        end
        if ((y.temperature < 0) ||
            (y.electric_current < 0) ||
            (y.light_intensity < 0))
            s12 = string(s12, "⋅")
        end
    else
        s12 = ""
    end
    # Temperature units in demoninator.
    if y.temperature < 0
        if (y.system == "SI") || (y.system == "CGS")
            if y.temperature == -1
                s13 = "K"
            elseif y.temperature == -2
                s13 = "K²"
            elseif y.temperature == -3
                s13 = "K³"
            elseif y.temperature == -4
                s13 = "K⁴"
            else
                s13 = string("K^", string(-y.temperature))
            end
        else
            msg = "The system of units is unknown."
            throw(ErrorException(msg))
        end
        if ((y.electric_current < 0) ||
            (y.light_intensity < 0))
            s13 = string(s13, "⋅")
        end
    else
        s13 = ""
    end
    # Electric current units in demoninator.
    if y.electric_current < 0
        if (y.system == "SI") || (y.system == "CGS")
            if y.electric_current == -1
                s14 = "A"
            elseif y.electric_current == -2
                s14 = "A²"
            elseif y.electric_current == -3
                s14 = "A³"
            elseif y.electric_current == -4
                s14 = "A⁴"
            else
                s14 = string("A^", string(-y.electric_current))
            end
        else
            msg = "The system of units is unknown."
            throw(ErrorException(msg))
        end
        if y.light_intensity < 0
            s14 = string(s14, "⋅")
        end
    else
        s14 = ""
    end
    # Light intensity units in demoninator.
    if y.light_intensity < 0
        if (y.system == "SI") || (y.system == "CGS")
            if y.light_intensity == -1
                s15 = "cd"
            elseif y.light_intensity == -2
                s15 = "cd²"
            elseif y.light_intensity == -3
                s15 = "cd³"
            elseif y.light_intensity == -4
                s15 = "cd⁴"
            else
                s15 = string("cd^", string(-y.light_intensity))
            end
        else
            msg = "The system of units is unknown."
            throw(ErrorException(msg))
        end
    else
        s15 = ""
    end
    # Close the denominator.
    if count > 1
        s16 = ")"
    else
        s16 = ""
    end
    s = string(s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16)
    return s
end

#=
--------------------------------------------------------------------------------
=#

# Reading and writing physical units from/to a JSON file.

StructTypes.StructType(::Type{PhysicalUnits}) = StructTypes.Struct()

function toFile(y::PhysicalUnits, json_stream::IOStream)
    if isopen(json_stream)
        JSON3.write(json_stream, y)
        write(json_stream, '\n')
    else
        msg = "The supplied JSON stream is not open."
        throw(ErrorException(msg))
    end
    flush(json_stream)
    return nothing
end

function fromFile(::Type{PhysicalUnits}, json_stream::IOStream)::PhysicalUnits
    if isopen(json_stream)
        y = JSON3.read(readline(json_stream), PhysicalUnits)
    else
        msg = "The supplied JSON stream is not open."
        throw(ErrorException(msg))
    end
    return y
end

#=
--------------------------------------------------------------------------------
=#

# Physical units specific to the SI system of units.

const JOULE    = PhysicalUnits("SI", 2, 1, 0, -2, 0, 0, 0)
const KILOGRAM = PhysicalUnits("SI", 0, 1, 0, 0, 0, 0, 0)
const METER    = PhysicalUnits("SI", 1, 0, 0, 0, 0, 0, 0)
const NEWTON   = PhysicalUnits("SI", 1, 1, 0, -2, 0, 0, 0)
const PASCAL   = PhysicalUnits("SI", -1, 1, 0, -2, 0, 0, 0)

# Physical units specific to the CGS system of units.

const BARYE      = PhysicalUnits("CGS", -1, 1, 0, -2, 0, 0, 0)
const CENTIMETER = PhysicalUnits("CGS", 1, 0, 0, 0, 0, 0, 0)
const DYNE       = PhysicalUnits("CGS", 1, 1, 0, -2, 0, 0, 0)
const ERG        = PhysicalUnits("CGS", 2, 1, 0, -2, 0, 0, 0)
const GRAM       = PhysicalUnits("CGS", 0, 1, 0, 0, 0, 0, 0)

# Physical units implemented for the (default) SI system of units.

const ACCELERATION     = PhysicalUnits("SI", 1, 0, 0, -2, 0, 0, 0)
const AMPERE           = PhysicalUnits("SI", 0, 0, 0, 0, 0, 1, 0)
const AREA             = PhysicalUnits("SI", 2, 0, 0, 0, 0, 0, 0)
const CANDELA          = PhysicalUnits("SI", 0, 0, 0, 0, 0, 0, 1)
const COMPLIANCE       = PhysicalUnits("SI", 1, -1, 0, 2, 0, 0, 0)
const DAMPING          = PhysicalUnits("SI", 0, 1, 0, -1, 0, 0, 0)
const DIMENSIONLESS    = PhysicalUnits("SI", 0, 0, 0, 0, 0, 0, 0)
const DISPLACEMENT     = PhysicalUnits("SI", 1, 0, 0, 0, 0, 0, 0)
const ENERGY           = PhysicalUnits("SI", 2, 1, 0, -2, 0, 0, 0)
const ENERGYperMASS    = PhysicalUnits("SI", 2, 0, 0, -2, 0, 0, 0)
const ENTROPY          = PhysicalUnits("SI", 2, 1, 0, -2, -1, 0, 0)
const ENTROPYperMASS   = PhysicalUnits("SI", 2, 0, 0, -2, -1, 0, 0)
const FORCE            = PhysicalUnits("SI", 1, 1, 0, -2, 0, 0, 0)
const GRAM_MOLE        = PhysicalUnits("SI", 0, 0, 1, 0, 0, 0, 0)
const KELVIN           = PhysicalUnits("SI", 0, 0, 0, 0, 1, 0, 0)
const LENGTH           = PhysicalUnits("SI", 1, 0, 0, 0, 0, 0, 0)
const MASS             = PhysicalUnits("SI", 0, 1, 0, 0, 0, 0, 0)
const MASS_DENSITY     = PhysicalUnits("SI", -3, 1, 0, 0, 0, 0, 0)
const MODULUS          = PhysicalUnits("SI", -1, 1, 0, -2, 0, 0, 0)
const POWER            = PhysicalUnits("SI", 2, 1, 0, -3, 0, 0, 0)
const RECIPROCAL_TIME  = PhysicalUnits("SI", 0, 0, 0, -1, 0, 0, 0)
const SECOND           = PhysicalUnits("SI", 0, 0, 0, 1, 0, 0, 0)
const STIFFNESS        = PhysicalUnits("SI", 0, 1, 0, -2, 0, 0, 0)
const STRAIN           = PhysicalUnits("SI", 0, 0, 0, 0, 0, 0, 0)
const STRAIN_RATE      = PhysicalUnits("SI", 0, 0, 0, -1, 0, 0, 0)
const STRESS           = PhysicalUnits("SI", -1, 1, 0, -2, 0, 0, 0)
const STRESS_RATE      = PhysicalUnits("SI", -1, 1, 0, -3, 0, 0, 0)
const STRETCH          = PhysicalUnits("SI", 0, 0, 0, 0, 0, 0, 0)
const STRETCH_RATE     = PhysicalUnits("SI", 0, 0, 0, -1, 0, 0, 0)
const TEMPERATURE      = PhysicalUnits("SI", 0, 0, 0, 0, 1, 0, 0)
const TEMPERATURE_RATE = PhysicalUnits("SI", 0, 0, 0, -1, 1, 0, 0)
const TIME             = PhysicalUnits("SI", 0, 0, 0, 1, 0, 0, 0)
const VELOCITY         = PhysicalUnits("SI", 1, 0, 0, -1, 0, 0, 0)
const VOLUME           = PhysicalUnits("SI",3 , 0, 0, 0, 0, 0, 0)

# Physical units implemented for the CGS system of units.

const CGS_ACCELERATION     = PhysicalUnits("CGS", 1, 0, 0, -2, 0, 0, 0)
const CGS_AMPERE           = PhysicalUnits("CGS", 0, 0, 0, 0, 0, 1, 0)
const CGS_AREA             = PhysicalUnits("CGS", 2, 0, 0, 0, 0, 0, 0)
const CGS_CANDELA          = PhysicalUnits("CGS", 0, 0, 0, 0, 0, 0, 1)
const CGS_COMPLIANCE       = PhysicalUnits("CGS", 1, -1, 0, 2, 0, 0, 0)
const CGS_DAMPING          = PhysicalUnits("CGS", 0, 1, 0, -1, 0, 0, 0)
const CGS_DIMENSIONLESS    = PhysicalUnits("CGS", 0, 0, 0, 0, 0, 0, 0)
const CGS_DISPLACEMENT     = PhysicalUnits("CGS", 1, 0, 0, 0, 0, 0, 0)
const CGS_ENERGY           = PhysicalUnits("CGS", 2, 1, 0, -2, 0, 0, 0)
const CGS_ENERGYperMASS    = PhysicalUnits("CGS", 2, 0, 0, -2, 0, 0, 0)
const CGS_ENTROPY          = PhysicalUnits("CGS", 2, 1, 0, -2, -1, 0, 0)
const CGS_ENTROPYperMASS   = PhysicalUnits("CGS", 2, 0, 0, -2, -1, 0, 0)
const CGS_FORCE            = PhysicalUnits("CGS", 1, 1, 0, -2, 0, 0, 0)
const CGS_GRAM_MOLE        = PhysicalUnits("CGS", 0, 0, 1, 0, 0, 0, 0)
const CGS_KELVIN           = PhysicalUnits("CGS", 0, 0, 0, 0, 1, 0, 0)
const CGS_LENGTH           = PhysicalUnits("CGS", 1, 0, 0, 0, 0, 0, 0)
const CGS_MASS             = PhysicalUnits("CGS", 0, 1, 0, 0, 0, 0, 0)
const CGS_MASS_DENSITY     = PhysicalUnits("CGS", -3, 1, 0, 0, 0, 0, 0)
const CGS_MODULUS          = PhysicalUnits("CGS", -1, 1, 0, -2, 0, 0, 0)
const CGS_POWER            = PhysicalUnits("CGS", 2, 1, 0, -3, 0, 0, 0)
const CGS_RECIPROCAL_TIME  = PhysicalUnits("CGS", 0, 0, 0, -1, 0, 0, 0)
const CGS_SECOND           = PhysicalUnits("CGS", 0, 0, 0, 1, 0, 0, 0)
const CGS_STIFFNESS        = PhysicalUnits("CGS", 0, 1, 0, -2, 0, 0, 0)
const CGS_STRAIN           = PhysicalUnits("CGS", 0, 0, 0, 0, 0, 0, 0)
const CGS_STRAIN_RATE      = PhysicalUnits("CGS", 0, 0, 0, -1, 0, 0, 0)
const CGS_STRESS           = PhysicalUnits("CGS", -1, 1, 0, -2, 0, 0, 0)
const CGS_STRESS_RATE      = PhysicalUnits("CGS", -1, 1, 0, -3, 0, 0, 0)
const CGS_STRETCH          = PhysicalUnits("CGS", 0, 0, 0, 0, 0, 0, 0)
const CGS_STRETCH_RATE     = PhysicalUnits("CGS", 0, 0, 0, -1, 0, 0, 0)
const CGS_TEMPERATURE      = PhysicalUnits("CGS", 0, 0, 0, 0, 1, 0, 0)
const CGS_TEMPERATURE_RATE = PhysicalUnits("CGS", 0, 0, 0, -1, 1, 0, 0)
const CGS_TIME             = PhysicalUnits("CGS", 0, 0, 0, 1, 0, 0, 0)
const CGS_VELOCITY         = PhysicalUnits("CGS", 1, 0, 0, -1, 0, 0, 0)
const CGS_VOLUME           = PhysicalUnits("CGS", 3, 0, 0, 0, 0, 0, 0)

# end PhysicalSystemsOfUnits