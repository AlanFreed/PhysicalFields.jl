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

    function PhysicalUnits(system::String, length::Integer, mass::Integer, amount_of_substance::Integer, 
               time::Integer, temperature::Integer, electric_current::Integer, light_intensity::Integer)
        return new(system, length, mass, amount_of_substance, 
                   time, temperature, electric_current, light_intensity)
    end
end

#=
-------------------------------------------------------------------------------
=#

# Type testing.

"""
    isDimensionless(y::PhysicalUnits)::Bool

Returns `true` if `y` is without physical dimension; otherwise, it returns `false`.
"""
function isDimensionless(y::PhysicalUnits)::Bool
    if (y.length == 0 &&
        y.mass == 0 &&
        y.amount_of_substance == 0 &&
        y.time == 0 &&
        y.temperature == 0 &&
        y.electric_current == 0 &&
        y.light_intensity == 0)
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
    if y.system == "SI" || isDimensionless(y)
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
    if y.system == "CGS" || isDimensionless(y)
        return true
    else
        return false
    end
end

"""
    areEquivalent(y::PhysicalUnits, z::PhysicalUnits)::Bool

Returns `true` if `y` and `z` are the same kind of unit, 
but possibly belong to different systems of units; otherwise, 
returns `false`.
"""
function areEquivalent(y::PhysicalUnits, z::PhysicalUnits)::Bool
    if (y.length == z.length &&
        y.mass == z.mass &&
        y.amount_of_substance == z.amount_of_substance &&
        y.time == z.time &&
        y.temperature == z.temperature &&
        y.electric_current == z.electric_current &&
        y.light_intensity == z.light_intensity)
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
        return PhysicalUnits("SI", y.length, y.mass, y.amount_of_substance, 
              y.time, y.temperature, y.electric_current, y.light_intensity)
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
        return PhysicalUnits("CGS", y.length, y.mass, y.amount_of_substance, 
               y.time, y.temperature, y.electric_current, y.light_intensity)
    end
end

#=
--------------------------------------------------------------------------------
=#

# Overloaded these operators: logical: ==, ≠
#                             unary:   +, -
#                             binary:  +, -

function Base.:(==)(y::PhysicalUnits, z::PhysicalUnits)::Bool
    if ((isDimensionless(y) && isDimensionless(z)) ||
        ((y.system == z.system) && areEquivalent(y, z)))
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
    return PhysicalUnits(y.system, -y.length, -y.mass, -y.amount_of_substance, 
             -y.time, -y.temperature, -y.electric_current, -y.light_intensity)
end

function Base.:+(y::PhysicalUnits, z::PhysicalUnits)::PhysicalUnits
    if isDimensionless(y) && isDimensionless(z)
        if isCGS(y) && isCGS(z)
            return PhysicalUnits("CGS", 0, 0, 0, 0, 0, 0, 0)
        else
            return PhysicalUnits("SI", 0, 0, 0, 0, 0, 0, 0)
        end
    elseif y.system == z.system
        length = y.length + z.length
        mass = y.mass + z.mass
        amount_of_substance = y.amount_of_substance + z.amount_of_substance
        time = y.time + z.time
        temperature = y.temperature + z.temperature
        electric_current = y.electric_current + z.electric_current
        light_intensity = y.light_intensity + z.light_intensity
        return PhysicalUnits(y.system, length, mass, amount_of_substance, 
                    time, temperature, electric_current, light_intensity)
    else
        msg = "The two sets of units belong to different systems of units."
        throw(ErrorException(msg))
    end
end

function Base.:-(y::PhysicalUnits, z::PhysicalUnits)::PhysicalUnits
    if isDimensionless(y) && isDimensionless(z)
        if isCGS(y) && isCGS(z)
            return PhysicalUnits("CGS", 0, 0, 0, 0, 0, 0, 0)
        else
            return PhysicalUnits("SI", 0, 0, 0, 0, 0, 0, 0)
        end
    elseif y.system == z.system
        length = y.length - z.length
        mass = y.mass - z.mass
        amount_of_substance = y.amount_of_substance - z.amount_of_substance
        time = y.time - z.time
        temperature = y.temperature - z.temperature
        electric_current = y.electric_current - z.electric_current
        light_intensity = y.light_intensity - z.light_intensity
        return PhysicalUnits(y.system, length, mass, amount_of_substance, 
                    time, temperature, electric_current, light_intensity)
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
    length              = copy(y.length)
    mass                = copy(y.mass)
    amount_of_substance = copy(y.amount_of_substance)
    time                = copy(y.time)
    temperature         = copy(y.temperature)
    electric_current    = copy(y.electric_current)
    light_intensity     = copy(y.light_intensity)
    return PhysicalUnits(y.system, length, mass, amount_of_substance, 
                time, temperature, electric_current, light_intensity)
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
            elseif y.length == 5
                s1 = "m⁵"
            elseif y.length == 6
                s1 = "m⁶"
            elseif y.length == 7
                s1 = "m⁷"
            elseif y.length == 8
                s1 = "m⁸"
            elseif y.length == 9
                s1 = "m⁹"
            else
                error("Physical unit for mⁿ lies outside range m⁻⁹…m⁹.")
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
            elseif y.length == 5
                s1 = "cm⁵"
            elseif y.length == 6
                s1 = "cm⁶"
            elseif y.length == 7
                s1 = "cm⁷"
            elseif y.length == 8
                s1 = "cm⁸"
            elseif y.length == 9
                s1 = "cm⁹"
            else
                error("Physical unit for cmⁿ lies outside range cm⁻⁹…cm⁹.")
            end
        else
            error("The system of units is unknown.")
        end
        if (y.mass > 0 ||
            y.amount_of_substance > 0 ||
            y.time > 0 ||
            y.temperature > 0 ||
            y.electric_current > 0 ||
            y.light_intensity > 0)
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
            elseif y.mass == 5
                s2 = "kg⁵"
            elseif y.mass == 6
                s2 = "kg⁶"
            elseif y.mass == 7
                s2 = "kg⁷"
            elseif y.mass == 8
                s2 = "kg⁸"
            elseif y.mass == 9
                s2 = "kg⁹"
            else
                error("Physical unit for kgⁿ lies outside range kg⁻⁹…kg⁹.")
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
            elseif y.mass == 5
                s2 = "g⁵"
            elseif y.mass == 6
                s2 = "g⁶"
            elseif y.mass == 7
                s2 = "g⁷"
            elseif y.mass == 8
                s2 = "g⁸"
            elseif y.mass == 9
                s2 = "g⁹"
            else
                error("Physical unit for gⁿ lies outside range g⁻⁹…g⁹.")
            end
        else
            error("The system of units is unknown.")
        end
        if (y.amount_of_substance > 0 ||
            y.time > 0 ||
            y.temperature > 0 ||
            y.electric_current > 0 ||
            y.light_intensity > 0)
            s2 = string(s2, "⋅")
        end
    else
        s2 = ""
    end
    # Molar units in numerator.
    if y.amount_of_substance > 0
        if y.system == "SI" || y.system == "CGS"
            if y.amount_of_substance == 1
                s3 = "mol"
            elseif y.amount_of_substance == 2
                s3 = "mol²"
            elseif y.amount_of_substance == 3
                s3 = "mol³"
            elseif y.amount_of_substance == 4
                s3 = "mol⁴"
            elseif y.amount_of_substance == 5
                s3 = "mol⁵"
            elseif y.amount_of_substance == 6
                s3 = "mol⁶"
            elseif y.amount_of_substance == 7
                s3 = "mol⁷"
            elseif y.amount_of_substance == 8
                s3 = "mol⁸"
            elseif y.amount_of_substance == 9
                s3 = "mol⁹"
            else
                error("Physical unit for molⁿ lies outside range mol⁻⁹…mol⁹.")
            end
        else
            error("The system of units is unknown.")
        end
        if (y.time > 0 ||
            y.temperature > 0 ||
            y.electric_current > 0 ||
            y.light_intensity > 0)
            s3 = string(s3, "⋅")
        end
    else
        s3 = ""
    end
    # Time units in numerator.
    if y.time > 0
        if y.system == "SI" || y.system == "CGS"
            if y.time == 1
                s4 = "s"
            elseif y.time == 2
                s4 = "s²"
            elseif y.time == 3
                s4 = "s³"
            elseif y.time == 4
                s4 = "s⁴"
            elseif y.time == 5
                s4 = "s⁵"
            elseif y.time == 6
                s4 = "s⁶"
            elseif y.time == 7
                s4 = "s⁷"
            elseif y.time == 8
                s4 = "s⁸"
            elseif y.time == 9
                s4 = "s⁹"
            else
                error("Physical unit for sⁿ lies outside range s⁻⁹…s⁹.")
            end
        else
            error("The system of units is unknown.")
        end
        if (y.temperature > 0 ||
            y.electric_current > 0 ||
            y.light_intensity > 0)
            s4 = string(s4, "⋅")
        end
    else
        s4 = ""
    end
    # Temperature units in numerator.
    if y.temperature > 0
        if y.system == "SI" || y.system == "CGS"
            if y.temperature == 1
                s5 = "K"
            elseif y.temperature == 2
                s5 = "K²"
            elseif y.temperature == 3
                s5 = "K³"
            elseif y.temperature == 4
                s5 = "K⁴"
            elseif y.temperature == 5
                s5 = "K⁵"
            elseif y.temperature == 6
                s5 = "K⁶"
            elseif y.temperature == 7
                s5 = "K⁷"
            elseif y.temperature == 8
                s5 = "K⁸"
            elseif y.temperature == 9
                s5 = "K⁹"
            else
                error("Physical unit for Kⁿ lies outside range K⁻⁹…K⁹.")
            end
        else
            error("The system of units is unknown.")
        end
        if (y.electric_current > 0 ||
            y.light_intensity > 0)
            s5 = string(s5, "⋅")
        end
    else
        s5 = ""
    end
    # Electric current units in numerator.
    if y.electric_current > 0
        if y.system == "SI" || y.system == "CGS"
            if y.electric_current == 1
                s6 = "A"
            elseif y.electric_current == 2
                s6 = "A²"
            elseif y.electric_current == 3
                s6 = "A³"
            elseif y.electric_current == 4
                s6 = "A⁴"
            elseif y.electric_current == 5
                s6 = "A⁵"
            elseif y.electric_current == 6
                s6 = "A⁶"
            elseif y.electric_current == 7
                s6 = "A⁷"
            elseif y.electric_current == 8
                s6 = "A⁸"
            elseif y.electric_current == 9
                s6 = "A⁹"
            else
                error("Physical unit for Aⁿ lies outside range A⁻⁹…A⁹.")
            end
        else
            error("The system of units is unknown.")
        end
        if y.light_intensity > 0
            s6 = string(s6, "⋅")
        end
    else
        s6 = ""
    end
    # Light intensity units in numerator.
    if y.light_intensity > 0
        if y.system == "SI" || y.system == "CGS"
            if y.light_intensity == 1
                s7 = "cd"
            elseif y.light_intensity == 2
                s7 = "cd²"
            elseif y.light_intensity == 3
                s7 = "cd³"
            elseif y.light_intensity == 4
                s7 = "cd⁴"
            elseif y.light_intensity == 5
                s7 = "cd⁵"
            elseif y.light_intensity == 6
                s7 = "cd⁶"
            elseif y.light_intensity == 7
                s7 = "cd⁷"
            elseif y.light_intensity == 8
                s7 = "cd⁸"
            elseif y.light_intensity == 9
                s7 = "cd⁹"
            else
                error("Physical unit for cdⁿ lies outside range cd⁻⁹…cd⁹.")
            end
        else
            error("The system of units is unknown.")
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
        if (y.length < 1 &&
            y.mass < 1 &&
            y.amount_of_substance < 1 &&
            y.time < 1 &&
            y.temperature < 1 &&
            y.electric_current < 1 &&
            y.light_intensity < 1)
            s8 = "1/("
        else
            s8 = "/("
        end
    elseif count == 1
        if (y.length < 1 &&
            y.mass < 1 &&
            y.amount_of_substance < 1 &&
            y.time < 1 &&
            y.temperature < 1 &&
            y.electric_current < 1 &&
            y.light_intensity < 1)
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
            elseif y.length == -5
                s9 = "m⁵"
            elseif y.length == -6
                s9 = "m⁶"
            elseif y.length == -7
                s9 = "m⁷"
            elseif y.length == -8
                s9 = "m⁸"
            elseif y.length == -9
                s9 = "m⁹"
            else
                error("Physical unit for mⁿ lies outside range m⁻⁹…m⁹.")
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
            elseif y.length == -5
                s9 = "cm⁵"
            elseif y.length == -6
                s9 = "cm⁶"
            elseif y.length == -7
                s9 = "cm⁷"
            elseif y.length == -8
                s9 = "cm⁸"
            elseif y.length == -9
                s9 = "cm⁹"
            else
                error("Physical unit for cmⁿ lies outside range cm⁻⁹…cm⁹.")
            end
        else
            error("The system of units is unknown.")
        end
        if (y.mass < 0 ||
            y.amount_of_substance < 0 ||
            y.time < 0 ||
            y.temperature < 0 ||
            y.electric_current < 0 ||
            y.light_intensity < 0)
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
            elseif y.mass == -5
                s10 = "kg⁵"
            elseif y.mass == -6
                s10 = "kg⁶"
            elseif y.mass == -7
                s10 = "kg⁷"
            elseif y.mass == -8
                s10 = "kg⁸"
            elseif y.mass == -9
                s10 = "kg⁹"
            else
                error("Physical unit for kgⁿ lies outside range kg⁻⁹…kg⁹.")
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
            elseif y.mass == -5
                s10 = "g⁵"
            elseif y.mass == -6
                s10 = "g⁶"
            elseif y.mass == -7
                s10 = "g⁷"
            elseif y.mass == -8
                s10 = "g⁸"
            elseif y.mass == -9
                s10 = "g⁹"
            else
                error("Physical unit for gⁿ lies outside range g⁻⁹…g⁹.")
            end
        else
            error("The system of units is unknown.")
        end
        if (y.amount_of_substance < 0 ||
            y.time < 0 ||
            y.temperature < 0 ||
            y.electric_current < 0 ||
            y.light_intensity < 0)
            s10 = string(s10, "⋅")
        end
    else
        s10 = ""
    end
    # Molar units in demoninator.
    if y.amount_of_substance < 0
        if y.system == "SI" || y.system == "CGS"
            if y.amount_of_substance == -1
                s11 = "mol"
            elseif y.amount_of_substance == -2
                s11 = "mol²"
            elseif y.amount_of_substance == -3
                s11 = "mol³"
            elseif y.amount_of_substance == -4
                s11 = "mol⁴"
            elseif y.amount_of_substance == -5
                s11 = "mol⁵"
            elseif y.amount_of_substance == -6
                s11 = "mol⁶"
            elseif y.amount_of_substance == -7
                s11 = "mol⁷"
            elseif y.amount_of_substance == -8
                s11 = "mol⁸"
            elseif y.amount_of_substance == -9
                s11 = "mol⁹"
            else
                error("Physical unit for molⁿ lies outside range mol⁻⁹…mol⁹.")
            end
        else
            error("The system of units is unknown.")
        end
        if (y.time < 0 ||
            y.temperature < 0 ||
            y.electric_current < 0 ||
            y.light_intensity < 0)
            s11 = string(s11, "⋅")
        end
    else
        s11 = ""
    end
    # Time units in demoninator.
    if y.time < 0
        if y.system == "SI" || y.system == "CGS"
            if y.time == -1
                s12 = "s"
            elseif y.time == -2
                s12 = "s²"
            elseif y.time == -3
                s12 = "s³"
            elseif y.time == -4
                s12 = "s⁴"
            elseif y.time == -5
                s12 = "s⁵"
            elseif y.time == -6
                s12 = "s⁶"
            elseif y.time == -7
                s12 = "s⁷"
            elseif y.time == -8
                s12 = "s⁸"
            elseif y.time == -9
                s12 = "s⁹"
            else
                error("Physical unit for sⁿ lies outside range s⁻⁹…s⁹.")
            end
        else
            error("The system of units is unknown.")
        end
        if (y.temperature < 0 ||
            y.electric_current < 0 ||
            y.light_intensity < 0)
            s12 = string(s12, "⋅")
        end
    else
        s12 = ""
    end
    # Temperature units in demoninator.
    if y.temperature < 0
        if y.system == "SI" || y.system == "CGS"
            if y.temperature == -1
                s13 = "K"
            elseif y.temperature == -2
                s13 = "K²"
            elseif y.temperature == -3
                s13 = "K³"
            elseif y.temperature == -4
                s13 = "K⁴"
            elseif y.temperature == -5
                s13 = "K⁵"
            elseif y.temperature == -6
                s13 = "K⁶"
            elseif y.temperature == -7
                s13 = "K⁷"
            elseif y.temperature == -8
                s13 = "K⁸"
            elseif y.temperature == -9
                s13 = "K⁹"
            else
                error("Physical unit for Kⁿ lies outside range K⁻⁹…K⁹.")
            end
        else
            error("The system of units is unknown.")
        end
        if (y.electric_current < 0 ||
            y.light_intensity < 0)
            s13 = string(s13, "⋅")
        end
    else
        s13 = ""
    end
    # Electric current units in demoninator.
    if y.electric_current < 0
        if y.system == "SI" || y.system == "CGS"
            if y.electric_current == -1
                s14 = "A"
            elseif y.electric_current == -2
                s14 = "A²"
            elseif y.electric_current == -3
                s14 = "A³"
            elseif y.electric_current == -4
                s14 = "A⁴"
            elseif y.electric_current == -5
                s14 = "A⁵"
            elseif y.electric_current == -6
                s14 = "A⁶"
            elseif y.electric_current == -7
                s14 = "A⁷"
            elseif y.electric_current == -8
                s14 = "A⁸"
            elseif y.electric_current == -9
                s14 = "A⁹"
            else
                error("Physical unit for Aⁿ lies outside range A⁻⁹…A⁹.")
            end
        else
            error("The system of units is unknown.")
        end
        if y.light_intensity < 0
            s14 = string(s14, "⋅")
        end
    else
        s14 = ""
    end
    # Light intensity units in demoninator.
    if y.light_intensity < 0
        if y.system == "SI" || y.system == "CGS"
            if y.light_intensity == -1
                s15 = "cd"
            elseif y.light_intensity == -2
                s15 = "cd²"
            elseif y.light_intensity == -3
                s15 = "cd³"
            elseif y.light_intensity == -4
                s15 = "cd⁴"
            elseif y.light_intensity == -5
                s15 = "cd⁵"
            elseif y.light_intensity == -6
                s15 = "cd⁶"
            elseif y.light_intensity == -7
                s15 = "cd⁷"
            elseif y.light_intensity == -8
                s15 = "cd⁸"
            elseif y.light_intensity == -9
                s15 = "cd⁹"
            else
                error("Physical unit for cdⁿ lies outside range cd⁻⁹…cd⁹.")
            end
        else
            error("The system of units is unknown.")
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
        error("The supplied JSON stream is not open.")
    end
    flush(json_stream)
    return nothing
end

function fromFile(::Type{PhysicalUnits}, json_stream::IOStream)::PhysicalUnits
    if isopen(json_stream)
        y = JSON3.read(readline(json_stream), PhysicalUnits)
    else
        error("The supplied JSON stream is not open.")
    end
    return y
end

#=
-------------------------------------------------------------------------------
=#

struct VectorOfPhysicalUnits
    len::UInt32                   # A vector's length, which is fixed.
    vec::Vector{PhysicalUnits}    # A column vector with mutable elements.

    # constructor

    function VectorOfPhysicalUnits(length::Integer)
        if length isa UInt32
            len = length
        else
            len = convert(UInt32, length)
        end
        
        vec = Vector{PhysicalUnits}[]
        # Initialize entries with dimensionless units.
        system              = "SI"
        length              = 0
        mass                = 0
        amount_of_substance = 0
        time                = 0
        temperature         = 0
        electric_current    = 0
        light_intensity     = 0
        for i in 1:len
            units = PhysicalUnits(system, length, mass, amount_of_substance, 
                       time, temperature, electric_current, light_intensity)
            push!(vec, units)
        end
        new(len, vec)
    end
end # VectorOfPhysicalUnits

# Methods extending their base methods.
    
function Base.:(getindex)(y::VectorOfPhysicalUnits, index::Integer)::PhysicalUnits
    if index < 1 || index > y.len
        msg = string("Admissible vector indices are ∈ [1…", toString(y.len), "].")
        throw(DimensionMismatch(msg))
    end
    return copy(y.vec[index])
end

function Base.:(setindex!)(y::VectorOfPhysicalUnits, value::PhysicalUnits, index::Integer)
    if index < 1 || index > y.len
        msg = string("Admissible vector indices are ∈ [1…", string(y.len), "].")
        throw(DimensionMismatch(msg))
    end
    y.vec[index] = copy(value)
    return nothing
end

function Base.:(copy)(y::VectorOfPhysicalUnits)::VectorOfPhysicalUnits
    vec = VectorOfPhysicalUnits(y.len)
    for index in 1:len
        setindex!(vec, getindex(y, index), index)
    end
    return vec
end

# Reading and writing vector of physical units from/to a JSON file.

StructTypes.StructType(::Type{VectorOfPhysicalUnits}) = StructTypes.Struct()

function toFile(y::VectorOfPhysicalUnits, json_stream::IOStream)
    if isopen(json_stream)
        JSON3.write(json_stream, y.len)
        write(json_stream, '\n')
        for i in 1:y.len
            JSON3.write(json_stream, y.vec[i])
            write(json_stream, '\n')
            if i % 5 == 0
                flush(json_stream)
            end
        end
    else
        error("The supplied JSON stream is not open.")
    end
    flush(json_stream)
    return nothing
end

function fromFile(::Type{VectorOfPhysicalUnits},
                  json_stream::IOStream)::VectorOfPhysicalUnits
    if isopen(json_stream)
        len = JSON3.read(readline(json_stream), Integer)
        vec = VectorOfPhysicalUnits(len)
        for i in 1:len
            vec.vec[i] = JSON3.read(readline(json_stream), PhysicalUnits)
        end
    else
        error("The supplied JSON stream is not open.")
    end
    return vec
end

# Overloaded these operators: logical: ==, ≠

function Base.:(==)(y::VectorOfPhysicalUnits, z::VectorOfPhysicalUnits)::Bool
    if !isequal(y.len, z.len)
        return false
    end
    for i in 1:y.len
        if y.vec[i] ≠ z.vec[i]
            return false
        end
    end
    return true
end

function Base.:≠(y::VectorOfPhysicalUnits, z::VectorOfPhysicalUnits)::Bool
    return !(y == z)
end

#=
-------------------------------------------------------------------------------
=#

struct MatrixOfPhysicalUnits
    rows::UInt16                  # Rows in a matrix, which is fixed.
    cols::UInt16                  # Columns in a matrix, which is fixed.
    vec::Vector{PhysicalUnits}    # Matrix reshaped as column vector with mutable elements.
    
    # constructors

    function MatrixOfPhysicalUnits(rows::Integer, columns::Integer)
        if rows isa UInt16
            row = rows
        else
            row = convert(UInt16, rows)
        end
        if columns isa UInt16
            col = columns
        else
            col = convert(UInt16, columns)
        end
        
        len = convert(UInt32, rows*columns)
        vec = Vector{PhysicalUnits}[]
        # Initialize entries with dimensionless units.
        system              = "SI"
        length              = 0
        mass                = 0
        amount_of_substance = 0
        time                = 0
        temperature         = 0
        electric_current    = 0
        light_intensity     = 0
        for i in 1:len
            units = PhysicalUnits(system, length, mass, amount_of_substance, 
                       time, temperature, electric_current, light_intensity)
            push!(vec, units)
        end
        
        new(row, col, vec)
    end
end # MatrixOfPhysicalUnits

# Methods extending their base methods.

function Base.:(getindex)(y::MatrixOfPhysicalUnits, row::Integer, column::Integer)::PhysicalUnits
    if row < 1 || row > y.rows || column < 1 || column > y.cols
        msg = string("Admissible matrix indices are ∈ [1…", toString(y.rows), ", 1…", toString(y.cols), "].")
        throw(DimensionMismatch(msg))
    end
    index = row + (column - 1)*y.rows
    return copy(y.vec[index])
end

function Base.:(setindex!)(y::MatrixOfPhysicalUnits, value::PhysicalUnits, row::Integer, column::Integer)
    if row < 1 || row > y.rows || column < 1 || column > y.cols
        msg = string("Admissible matrix indices are ∈ [1…", toString(y.rows), ", 1…", toString(y.cols), "].")
        throw(DimensionMismatch(msg))
    end
    index = row + (column - 1)*y.rows
    y.vec[index] = copy(value)
    return nothing
end

function Base.:(copy)(y::MatrixOfPhysicalUnits)::MatrixOfPhysicalUnits
    len = y.rows * y.cols
    mtx = MatrixOfPhysicalUnits(y.rows, y.cols)
    for index in 1:len
        setindex!(mtx, getindex(y.vec, index), index)
    end
    return mtx
end # copy

# Reading and writing matrix of physical units from/to a JSON file.

StructTypes.StructType(::Type{MatrixOfPhysicalUnits}) = StructTypes.Struct()

function toFile(y::MatrixOfPhysicalUnits, json_stream::IOStream)
    if isopen(json_stream)
        JSON3.write(json_stream, y.rows)
        write(json_stream, '\n')
        JSON3.write(json_stream, y.cols)
        write(json_stream, '\n')
        len = y.rows * y.cols
        for i in 1:len
            JSON3.write(json_stream, y.vec[i])
            write(json_stream, '\n')
            if i % 5 == 0
                flush(json_stream)
            end
        end
    else
        error("The supplied JSON stream is not open.")
    end
    flush(json_stream)
    return nothing
end

function fromFile(::Type{MatrixOfPhysicalUnits},
                  json_stream::IOStream)::MatrixOfPhysicalUnits
    if isopen(json_stream)
        rows = JSON3.read(readline(json_stream), Integer)
        cols = JSON3.read(readline(json_stream), Integer)
        mtx  = MatrixOfPhysicalUnits(rows, cols)
        len  = rows * cols
        for i in 1:len
            mtx.vec[i] = JSON3.read(readline(json_stream), PhysicalUnits)
        end
    else
        error("The supplied JSON stream is not open.")
    end
    return mtx
end

# Overloaded these operators: logical: ==, ≠
#                             binary:  +

function Base.:(==)(y::MatrixOfPhysicalUnits, z::MatrixOfPhysicalUnits)::Bool
    yLen = y.rows * y.cols
    zLen = z.rows * z.cols
    if !isequal(yLen, zLen)
        return false
    end
    for i in 1:yLen
        if y.vec[i] ≠ z.vec[i]
            return false
        end
    end
    return true
end

function Base.:≠(y::MatrixOfPhysicalUnits, z::MatrixOfPhysicalUnits)::Bool
    return !(y == z)
end

function Base.:+(y::MatrixOfPhysicalUnits, 
                 z::VectorOfPhysicalUnits)::VectorOfPhysicalUnits
    if y.cols ≠ z.len
        msg = "Matrix y and vector z are not dimensionally correct for computing x=y*z."
        throw(DimensionMismatch(msg))
    end
    x = VectorOfPhysicalUnits(y.rows)
    for i in 1:y.rows
        x[i] = y[i,i] + z[i]
        for j in 1:y.cols
            if i ≠ j
                if x[i] ≠ y[i,j] + z[j]
                    msg = "Physical units for matrix y and vector z "
                    msg = msg + "are not compatible for computing x=y*z."
                    error(msg)
                end
            end
        end
    end
    return x
end

#=
--------------------------------------------------------------------------------
=#

# Exported physical units specific to the SI system of units.

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

# end PhysicalSystemsOfUnits.jl
