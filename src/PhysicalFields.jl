#=
Created on Thu 01 Oct 2020
Updated on Sun 21 Mar 2021
--------------------------------------------------------------------------------
This software, like the language it is written in, is published under the MIT
License, https://opensource.org/licenses/MIT.

Copyright (c) 2021: Alan Freed, Shahla Zamani, and John Clayton

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--------------------------------------------------------------------------------
=#
"""
Module:                                                                       \n
    PhysicalFields                                                            \n
A field is any physical property that has a value and units.  These values may
be numbers or arrays.  An arithmetic exists between the following types:      \n
    PhysicalScalar      a mutable real/floating-point number with units       \n
    PhysicalVector      a mutable real/floating-point vector with units       \n
    PhysicalMatrix      a mutable real/floating-point matrix with units       \n
which are comprised of the following more primative types:                    \n
    MBool               a type for mutable booleans                           \n
    MInteger            a type for mutable integer numbers                    \n
    MReal               a type for mutable real/floating-point numbers        \n
    PhysicalUnits       a type for units using the CGS system of units.
"""
module PhysicalFields

using
    Base,
    LinearAlgebra,
    Printf,
    StaticArrays

import
    Base.:(==)
    Base.:≠
    Base.:!
    Base.:<
    Base.:≤
    Base.:≥
    Base.:>
    Base.:+
    Base.:-
    Base.:*
    Base.:÷
    Base.:%
    Base.:/
    Base.:\
    Base.:^
    Base.:(abs)
    Base.:(copy)
    Base.:(deepcopy)
    Base.:(getindex)
    Base.:(setindex!)
    Base.:(inv)
    Base.:(transpose)

    LinearAlgebra.:(cross)
    LinearAlgebra.:(det)
    LinearAlgebra.:(lq)
    LinearAlgebra.:(norm)
    LinearAlgebra.:(qr)
    LinearAlgebra.:(tr)

export
    # Types
    MBool,             # A mutable boolean
    MInteger,          # A mutable integer number
    MReal,             # A mutable real/floating-point number
    PhysicalUnits,     # Implementation of the CGS system of units.
    PhysicalScalar,    # A real number with units.
    PhysicalVector,    # A real vector of specified length with units.
    PhysicalMatrix,    # A real matrix of specified dimension with units.
    # Overloaded opeartors: MBool:           ==, ≠, !
    # Overloaded operators: MInteger:        ==, ≠, <, ≤, ≥, >, +, -, *, ÷, %, ^
    # Overloaded operators: MReal:           ==, ≠, <, ≤, ≥, >, +, -, *, /, ^
    # Overloaded operators: PhysicalUnits:   ==, ≠, +, -
    # Overloaded operators: PhysicalScalar:  ==, ≠, <, ≤, ≥, >, +, -, *, /, ^
    # Overloaded operators: PhysicalVector:  [], ==, ≠, +, -, *, /
    # Overloaded operators: PhysicalMatrix:  [], ==, ≠, +, -, *, /, \
    # Type convertors
    toBool,
    toInteger,
    toReal,
    # Constructors
    newScalar,
    newVector,
    newMatrix,
    # Methods: common to all types
    copy,
    deepcopy,
    toString,
    # Method: common to all numeric types
    abs,
    # Method: common to all array types
    norm,
    # Extra functions: PhysicalVector
    cross,
    unitVector,
    # Extra functions: PhysicalMatrix
    tensorProduct,
    transpose,
    tr,
    det,
    inv,
    qr,
    lq,
    # Constants: PhysicalUnits
    ACCELERATION,
    AREA,
    BARYE,
    CENTIMETER,
    COMPLIANCE,
    DIMENSIONLESS,
    DISPLACEMENT,
    DYNE,
    ENERGY,
    ERG,
    FORCE,
    GRAM,
    LENGTH,
    MASS,
    MASSDENSITY,
    MODULUS,
    POWER,
    SECOND,
    STRAIN,
    STRAINRATE,
    STRESS,
    STRETCH,
    TIME,
    VELOCITY,
    VOLUME
#=
--------------------------------------------------------------------------------
=#
"""
Type:                                                                         \n
    MBool                                                                     \n
        n   a boolean                                                         \n
Returns a new instance of type 'MBool'.  To be used in an immutable struct
whenever a boolean field is to be mutable.
"""
mutable struct MBool
    n::Bool  # an instance of type Bool
end

# Overloaded these operators: binary: ==, ≠, !

"""
Operator:                                                                     \n
    y == z                                                                    \n
Returns true if the two integers are equal; otherwise, it returns false.
Values 'y' and 'z' may be of types MBool and/or Bool.
"""
function Base.:(==)(y, z::MBool)::Bool
    if y.n == z.n
        return true
    else
        return false
    end
end

function Base.:(==)(y::Bool, z::MBool)::Bool
    if y == z.n
        return true
    else
        return false
    end
end

function Base.:(==)(y::MBool, z::Bool)::Bool
    if y.n == z
        return true
    else
        return false
    end
end

"""
Operator:                                                                     \n
    y ≠ z                                                                     \n
Returns true if the two booleans are not equal; otherwise, it returns false.
Values 'y' and 'z' may be of types MBool and/or Bool.
"""
function Base.:≠(y, z::MBool)::Bool
    if y.n ≠ z.n
        return true
    else
        return false
    end
end

function Base.:≠(y::Bool, z::MBool)::Bool
    if y ≠ z.n
        return true
    else
        return false
    end
end

function Base.:≠(y::MBool, z::Bool)::Bool
    if y.n ≠ z
        return true
    else
        return false
    end
end

"""
Operator:                                                                     \n
    !y                                                                        \n
If y is true it returns false, and if y is false it returns true.
"""
function Base.:!(b::MBool)::Bool
    return !b.n
end

# Functions of type MBool.

"""
Function:                                                                     \n
    c = copy(b)                                                               \n
Returns a shallow copy 'c' of the original mutable boolean 'b'.
"""
function Base.:(copy)(b::MBool)::MBool
    c = b
    return c
end

"""
Function:                                                                     \n
    c = deepcopy(b)                                                           \n
Returns a deep copy 'c' of the original mutable boolean 'b'.
"""
function Base.:(deepcopy)(b::MBool)::MBool
    return MBool(b.n)
end

"""
Function:                                                                     \n
    s = toString(b)                                                           \n
Returns a string 's' representation for the mutable boolean 'b'.
"""
function toString(b::MBool)::String
    return string(b.n)
end

"""
Function:                                                                     \n
    truth = toBool(b)                                                         \n
Returns the boolean 'truth' value held by the object 'b'.
"""
function toBool(b::MBool)::Bool
    return b.n
end

#=
--------------------------------------------------------------------------------
=#
"""
Type:                                                                         \n
    MInteger                                                                  \n
        n   a signed integer                                                  \n
Returns a new instance of type 'MInteger'.  To be used in an immutable struct
whenever an integer field is to be mutable.
"""
mutable struct MInteger
    n::Integer  # an instance of the general type Integer
end

# Overloaded these operators: binary: ==, ≠, <, ≤, ≥, >
#                             unary:  -
#                             binary: +, -, *, ÷, %, ^

"""
Operator:                                                                     \n
    y == z                                                                    \n
Returns true if the two integers are equal; otherwise, it returns false.
Values 'y' and 'z' may be of types MInteger and/or Integer.
"""
function Base.:(==)(y, z::MInteger)::Bool
    if y.n == z.n
        return true
    else
        return false
    end
end

function Base.:(==)(y::Integer, z::MInteger)::Bool
    if y == z.n
        return true
    else
        return false
    end
end

function Base.:(==)(y::MInteger, z::Integer)::Bool
    if y.n == z
        return true
    else
        return false
    end
end

"""
Operator:                                                                     \n
    y ≠ z                                                                     \n
Returns true if the two integers are not equal; otherwise, it returns false.
Values 'y' and 'z' may be of types MInteger and/or Integer.
"""
function Base.:≠(y, z::MInteger)::Bool
    if y.n ≠ z.n
        return true
    else
        return false
    end
end

function Base.:≠(y::Integer, z::MInteger)::Bool
    if y ≠ z.n
        return true
    else
        return false
    end
end

function Base.:≠(y::MInteger, z::Integer)::Bool
    if y.n ≠ z
        return true
    else
        return false
    end
end

"""
Operator:                                                                     \n
    y < z                                                                     \n
Returns true if the value for 'y' is less than the value for 'z'; otherwise,
it returns false.  Values 'y' and 'z' may be of types MInteger and/or Integer.
"""
function Base.:<(y, z::MInteger)::Bool
    if y.n < z.n
        return true
    else
        return false
    end
end

function Base.:<(y::Integer, z::MInteger)::Bool
    if y < z.n
        return true
    else
        return false
    end
end

function Base.:<(y::MInteger, z::Integer)::Bool
    if y.n < z
        return true
    else
        return false
    end
end

"""
Operator:                                                                     \n
    y ≤ z                                                                     \n
Returns true if the value for 'y' is less than or equal to 'z'; otherwise,
it returns false.  Values 'y' and 'z' may be of types MInteger and/or Integer.
"""
function Base.:≤(y, z::MInteger)::Bool
    if y.n ≤ z.n
        return true
    else
        return false
    end
end

function Base.:≤(y::Integer, z::MInteger)::Bool
    if y ≤ z.n
        return true
    else
        return false
    end
end

function Base.:≤(y::MInteger, z::Integer)::Bool
    if y.n ≤ z
        return true
    else
        return false
    end
end

"""
Operator:                                                                     \n
    y > z                                                                     \n
Returns true if the value for 'y' is greater than the value for 'z'; otherwise,
it returns false.  Values 'y' and 'z' may be of types MInteger and/or Integer.
"""
function Base.:>(y, z::MInteger)::Bool
    if y.n > z.n
        return true
    else
        return false
    end
end

function Base.:>(y::Integer, z::MInteger)::Bool
    if y > z.n
        return true
    else
        return false
    end
end

function Base.:>(y::MInteger, z::Integer)::Bool
    if y.n > z
        return true
    else
        return false
    end
end

"""
Operator:                                                                     \n
    y ≥ z                                                                     \n
Returns true if the value for 'y' is greater than or equal to 'z'; otherwise,
it returns false.  Values 'y' and 'z' may be of types MInteger and/or Integer.
"""
function Base.:≥(y, z::MInteger)::Bool
    if y.n ≥ z.n
        return true
    else
        return false
    end
end

function Base.:≥(y::Integer, z::MInteger)::Bool
    if y ≥ z.n
        return true
    else
        return false
    end
end

function Base.:≥(y::MInteger, z::Integer)::Bool
    if y.n ≥ z
        return true
    else
        return false
    end
end

"""
Operator:                                                                     \n
    -y                                                                        \n
Returns the negative of 'y', which is of type MInteger.
"""
function Base.:-(y::MInteger)::MInteger
    return MInteger(-y.n)
end

"""
Operator:                                                                     \n
    y + z                                                                     \n
Returns the sum of integers 'y' and 'z', which may be of types MInteger and/or
Integer.
"""
function Base.:+(y, z::MInteger)::MInteger
    n = y.n + z.n
    return MInteger(n)
end

function Base.:+(y::MInteger, z::Integer)::MInteger
    n = y.n + z
    return MInteger(n)
end

function Base.:+(y::Integer, z::MInteger)::MInteger
    n = y + z.n
    return MInteger(n)
end

"""
Operator:                                                                     \n
    y - z                                                                     \n
Returns the difference between two integers 'y' and 'z', which may be of types
MInteger and/or Integer.
"""
function Base.:-(y, z::MInteger)::MInteger
    n = y.n - z.n
    return MInteger(n)
end

function Base.:-(y::MInteger, z::Integer)::MInteger
    n = y.n - z
    return MInteger(n)
end

function Base.:-(y::Integer, z::MInteger)::MInteger
    n = y - z.n
    return MInteger(n)
end

"""
Operator:                                                                     \n
    y * z                                                                     \n
Returns the product between two integers 'y' and 'z', which may be of types
MInteger and/or Integer.
"""
function Base.:*(y, z::MInteger)::MInteger
    n = y.n * z.n
    return MInteger(n)
end

function Base.:*(y::MInteger, z::Integer)::MInteger
    n = y.n * z
    return MInteger(n)
end

function Base.:*(y::Integer, z::MInteger)::MInteger
    n = y * z.n
    return MInteger(n)
end

"""
Operator:                                                                     \n
    y ÷ z                                                                     \n
Returns the ratio between two integers 'y' and 'z', which may be of types
MInteger and/or Integer.  This is integer division.
"""
function Base.:÷(y, z::MInteger)::MInteger
    if z.n > 0
        n = y.n ÷ z.n
    elseif z.n < 0
        n = (-y.n) ÷ (-z.n)
    else
        msg = "Integer division by zero."
        throw(ErrorException(msg))
    end
    return MInteger(n)
end

function Base.:÷(y::MInteger, z::Integer)::MInteger
    if z > 0
        n = y.n ÷ z
    elseif z < 0
        n = (-y.n) ÷ (-z)
    else
        msg = "Integer division by zero."
        throw(ErrorException(msg))
    end
    return MInteger(n)
end

function Base.:÷(y::Integer, z::MInteger)::MInteger
    if z.n > 0
        n = y ÷ z.n
    elseif z.n < 0
        n = (-y) ÷ (-z.n)
    else
        msg = "Integer division by zero."
        throw(ErrorException(msg))
    end
    return MInteger(n)
end

"""
Operator:                                                                     \n
    y % z                                                                     \n
Returns the remainder between two integers 'y' and 'z', which may be of types
MInteger and/or Integer.  This is integer division.
"""
function Base.:%(y, z::MInteger)::MInteger
    if z.n > 0
        n = y.n % z.n
    elseif z.n < 0
        n = (-y.n) % (-z.n)
    else
        msg = "Integer division by zero."
        throw(ErrorException(msg))
    end
    return MInteger(n)
end

function Base.:%(y::MInteger, z::Integer)::MInteger
    if z > 0
        n = y.n % z
    elseif z < 0
        n = (-y.n) % (-z)
    else
        msg = "Integer division by zero."
        throw(ErrorException(msg))
    end
    return MInteger(n)
end

function Base.:%(y::Integer, z::MInteger)::MInteger
    if z.n > 0
        n = y % z.n
    elseif z.n < 0
        n = (-y) % (-z.n)
    else
        msg = "Integer division by zero."
        throw(ErrorException(msg))
    end
    return MInteger(n)
end

"""
Operator:                                                                     \n
    y ^ z                                                                     \n
Returns integer 'y' raised to the power of integer 'z', which may be of types
MInteger and/or Integer.
"""
function Base.:^(y, z::MInteger)::MInteger
    n = y.n ^ z.n
    return MInteger(n)
end

function Base.:^(y::MInteger, z::Integer)::MInteger
    n = y.n ^ z
    return MInteger(n)
end

function Base.:^(y::Integer, z::MInteger)::MInteger
    n = y ^ z.n
    return MInteger(n)
end

# Functions of type MInteger.

"""
Function:                                                                     \n
    absy = abs(y)                                                             \n
Returns the absolute value of mutable integer 'y'
"""
function Base.:(abs)(y::MInteger)::MInteger
    return MInteger(abs(y.n))
end

"""
Function:                                                                     \n
    c = copy(y)                                                               \n
Returns a shallow copy 'c' of the original mutable integer 'y'.
"""
function Base.:(copy)(y::MInteger)::MInteger
    c = y
    return c
end

"""
Function:                                                                     \n
    c = deepcopy(u)                                                           \n
Returns a deep copy 'c' of the original mutable integer 'y'.
"""
function Base.:(deepcopy)(y::MInteger)::MInteger
    return MInteger(y.n)
end

"""
Function:                                                                     \n
    s = toString(y)                                                           \n
Returns a string 's' representation for the mutable integer 'y'.
"""
function toString(y::MInteger)::String
    return string(y.n)
end

"""
Function:                                                                     \n
    i = toInteger(y)                                                          \n
Returns the integer value 'i' held by object 'y'.
"""
function toInteger(y::MInteger)::Integer
    return y.n
end
#=
--------------------------------------------------------------------------------
=#
"""
Type:                                                                         \n
    MReal                                                                     \n
        n   a real number approximated as a floating-point number             \n
Returns a new instance of type 'MReal'.  To be used in an immutable struct
whenever a real field is to be mutable.
"""
mutable struct MReal
    n::Real     # any instance belonging to the general type Real.
end

# Overloaded these operators: binary: ==, ≠, <, ≤, ≥, >
#                             unary:  -
#                             binary: +, -, *, /, ^

"""
Operator:                                                                     \n
    y == z                                                                    \n
Returns true if their numbers are equal; otherwise, it returns false.
Values 'y' and 'z' may be of types MReal, MInteger, and/or Real ⊃ Integer.
"""
function Base.:(==)(y, z::MReal)::Bool
    if y.n == z.n
        return true
    else
        return false
    end
end

function Base.:(==)(y::Real, z::MReal)::Bool
    if y == z.n
        return true
    else
        return false
    end
end

function Base.:(==)(y::MReal, z::Real)::Bool
    if y.n == z
        return true
    else
        return false
    end
end

function Base.:(==)(y::MInteger, z::MReal)::Bool
    if Real(y.n) == z.n
        return true
    else
        return false
    end
end

function Base.:(==)(y::MReal, z::MInteger)::Bool
    if y.n == Real(z.n)
        return true
    else
        return false
    end
end

"""
Operator:                                                                     \n
    y ≠ z                                                                     \n
Returns true if the numbers are not equal; otherwise, it returns false.
Values 'y' and 'z' may be of types MReal, MInteger, and/or Real ⊃ Integer.
"""
function Base.:≠(y, z::MReal)::Bool
    if y.n ≠ z.n
        return true
    else
        return false
    end
end

function Base.:≠(y::Real, z::MReal)::Bool
    if y ≠ z.n
        return true
    else
        return false
    end
end

function Base.:≠(y::MReal, z::Real)::Bool
    if y.n ≠ z
        return true
    else
        return false
    end
end

function Base.:≠(y::MReal, z::MInteger)::Bool
    if y.x ≠ Real(z.n)
        return true
    else
        return false
    end
end

function Base.:≠(y::MInteger, z::MReal)::Bool
    if Real(y.n) ≠ z.n
        return true
    else
        return false
    end
end

"""
Operator:                                                                     \n
    y < z                                                                     \n
Returns true if 'y' is less than 'z'; otherwise, it returns false.
Values 'y' and 'z' may be of types MReal, MInteger, and/or Real ⊃ Integer.
"""
function Base.:<(y, z::MReal)::Bool
    if y.n < z.n
        return true
    else
        return false
    end
end

function Base.:<(y::Real, z::MReal)::Bool
    if y < z.n
        return true
    else
        return false
    end
end

function Base.:<(y::MReal, z::Real)::Bool
    if y.n < z
        return true
    else
        return false
    end
end

function Base.:<(y::MInteger, z::MReal)::Bool
    if Real(y.n) < z.n
        return true
    else
        return false
    end
end

function Base.:<(y::MReal, z::MInteger)::Bool
    if y.n < Real(z.n)
        return true
    else
        return false
    end
end

"""
Operator:                                                                     \n
    y ≤ z                                                                     \n
Returns true if 'y' is less than or equal to 'z'; otherwise, it returns false.
Values 'y' and 'z' may be of types MReal, MInteger, and/or Real ⊃ Integer.
"""
function Base.:≤(y, z::MReal)::Bool
    if y.n ≤ z.n
        return true
    else
        return false
    end
end

function Base.:≤(y::Real, z::MReal)::Bool
    if y ≤ z.n
        return true
    else
        return false
    end
end

function Base.:≤(y::MReal, z::Real)::Bool
    if y.n ≤ z
        return true
    else
        return false
    end
end

function Base.:≤(y::MInteger, z::MReal)::Bool
    if Real(y.n) ≤ z.n
        return true
    else
        return false
    end
end

function Base.:≤(y::MReal, z::MInteger)::Bool
    if y.n ≤ Real(z.n)
        return true
    else
        return false
    end
end

"""
Operator:                                                                     \n
    y > z                                                                     \n
Returns true if 'y' is greater than 'z'; otherwise, it returns false.
    Values 'y' and 'z' may be of types MReal, MInteger, and/or Real ⊃ Integer.
"""
function Base.:>(y, z::MReal)::Bool
    if y.n > z.n
        return true
    else
        return false
    end
end

function Base.:>(y::Real, z::MReal)::Bool
    if y > z.n
        return true
    else
        return false
    end
end

function Base.:>(y::MReal, z::Real)::Bool
    if y.n > z
        return true
    else
        return false
    end
end

function Base.:>(y::MInteger, z::MReal)::Bool
    if Real(y.n) > z.n
        return true
    else
        return false
    end
end

function Base.:>(y::MReal, z::MInteger)::Bool
    if y.n > Real(z.n)
        return true
    else
        return false
    end
end

"""
Operator:                                                                     \n
    y ≥ z                                                                     \n
Returns true if 'y' is greater than or equal to 'z'; otherwise, returns false.
Values 'y' and 'z' may be of types MReal, MInteger, and/or Real ⊃ Integer.
"""
function Base.:≥(y, z::MReal)::Bool
    if y.n ≥ z.n
        return true
    else
        return false
    end
end

function Base.:≥(y::Real, z::MReal)::Bool
    if y ≥ z.n
        return true
    else
        return false
    end
end

function Base.:≥(y::MReal, z::Real)::Bool
    if y.n ≥ z
        return true
    else
        return false
    end
end

function Base.:≥(y::MInteger, z::MReal)::Bool
    if Real(y.n) ≥ z.n
        return true
    else
        return false
    end
end

function Base.:≥(y::MReal, z::MInteger)::Bool
    if y.n ≥ Real(z.n)
        return true
    else
        return false
    end
end

"""
Operator:                                                                     \n
    -y                                                                        \n
Returns the negative of 'y', which is of type MReal.
"""
function Base.:-(y::MReal)::MReal
    return MReal(-y.n)
end

"""
Operator:                                                                     \n
    y + z                                                                     \n
Returns the sum of reals 'y' and 'z', which may be of types.
"""
function Base.:+(y, z::MReal)::MReal
    n = y.n + z.n
    return MReal(n)
end

function Base.:+(y::MReal, z::Real)::MReal
    n = y.n + z
    return MReal(n)
end

function Base.:+(y::Real, z::MReal)::MReal
    n = y + z.n
    return MReal(n)
end

function Base.:+(y::MReal, z::MInteger)::MReal
    n = y.n + Real(z.n)
    return MReal(n)
end

function Base.:+(y::MInteger, z::MReal)::MReal
    n = Real(y.n) + z.n
    return MReal(n)
end

"""
Operator:                                                                     \n
    y - z                                                                     \n
Returns the difference between two reals 'y' and 'z', which may be of types
MReal, MInteger, and Real ⊃ Integer.
"""
function Base.:-(y, z::MReal)::MReal
    n = y.n - z.n
    return MReal(n)
end

function Base.:-(y::MReal, z::Real)::MReal
    n = y.n - z
    return MReal(n)
end

function Base.:-(y::Real, z::MReal)::MReal
    n = y - z.n
    return MReal(n)
end

function Base.:-(y::MReal, z::MInteger)::MReal
    n = y.n - Real(z.n)
    return MReal(n)
end

function Base.:-(y::MInteger, z::MReal)::MReal
    n = Real(y.n) - z.n
    return MReal(n)
end

"""
Operator:                                                                     \n
    y * z                                                                     \n
Returns the product between two reals 'y' and 'z', which may be of types
MReal, MInteger, and Real ⊃ Integer.
"""
function Base.:*(y, z::MReal)::MReal
    n = y.n * z.n
    return MReal(n)
end

function Base.:*(y::MReal, z::Real)::MReal
    n = y.n * z
    return MReal(n)
end

function Base.:*(y::Real, z::MReal)::MReal
    n = y * z.n
    return MReal(n)
end

function Base.:*(y::MReal, z::MInteger)::MReal
    n = y.n * Real(z.n)
    return MReal(n)
end

function Base.:*(y::MInteger, z::MReal)::MReal
    n = Real(y.n) * z.n
    return MReal(n)
end

"""
Operator:                                                                     \n
    y / z                                                                     \n
Returns the ratio between two reals 'y' and 'z', which may be of types
MReal, MInteger, and Real ⊃ Integer.
"""
function Base.:/(y, z::MReal)::MReal
    n = y.n / z.n
    return MReal(n)
end

function Base.:/(y::MReal, z::Real)::MReal
    n = y.n / z
    return MReal(n)
end

function Base.:/(y::Real, z::MReal)::MReal
    n = y / z.n
    return MReal(n)
end

function Base.:/(y::MReal, z::MInteger)::MReal
    n = y.n / Real(z.n)
    return MReal(n)
end

function Base.:/(y::MInteger, z::MReal)::MReal
    n = Real(y.n) / z.n
    return MReal(n)
end

"""
Operator:                                                                     \n
    y ^ z                                                                     \n
Returns real 'y' raised to the power of 'z', which may be of types
MReal, MInteger, and Real ⊃ Integer.
"""
function Base.:^(y, z::MReal)::MReal
    n = y.n ^ z.n
    return MReal(n)
end

function Base.:^(y::MReal, z::Real)::MReal
    n = y.n ^ z
    return MReal(n)
end

function Base.:^(y::Real, z::MReal)::MReal
    n = y ^ z.n
    return MReal(n)
end

function Base.:^(y::MReal, z::MInteger)::MReal
    n = y.n ^ z.n
    return MReal(n)
end

function Base.:^(y::MInteger, z::MReal)::MReal
    n = Real(y.n) ^ z.n
    return MReal(n)
end

# Functions of type MReal.

"""
Function:                                                                     \n
    absy = abs(y)                                                             \n
Returns the absolute value of mutable real 'y'
"""
function Base.:(abs)(y::MReal)::MReal
    return MReal(abs(y.n))
end

"""
Function:                                                                     \n
    c = copy(y)                                                               \n
Returns a shallow copy 'c' of the original mutable real 'y'.
"""
function Base.:(copy)(y::MReal)::MReal
    c = y
    return c
end

"""
Function:                                                                     \n
    c = deepcopy(u)                                                           \n
Returns a deep copy 'c' of the original mutable real 'y'.
"""
function Base.:(deepcopy)(y::MReal)::MReal
    return MReal(y.n)
end

# Called locally for converting a real number into a string.
function _toString(x::Real, format::String)::String
    if x == -0.0
        if format == "e5"
            s = " 0.0000e+00"
        elseif format == "e4"
            s = " 0.000e+00"
        elseif format == "e3"
            s = " 0.00e+00"
        elseif format == "f5"
            s = " 0.0000"
        elseif format == "f4"
            s = " 0.000"
        else
            s = " 0.00"
        end
    else
        if format == "e5"
            sx = @sprintf "%0.4e" x;
        elseif format == "e4"
            sx = @sprintf "%0.3e" x;
        elseif format == "e3"
            sx = @sprintf "%0.2e" x;
        elseif format == "f5"
            sx = @sprintf "%0.4f" x;
        elseif format == "f4"
            sx = @sprintf "%0.3f" x;
        else
            sx = @sprintf "%0.2f" x;
        end
        if x ≥ 0.0
            # Insert a blank space in place of a minus sign.
            s = string(' ', sx)
        else
            s = sx
        end
    end
    return s
end

"""
Function:                                                                     \n
    s = toString(y, format='F')                                               \n
Returns a string 's' representation for the mutable real 'y' in scientific or
exponential notation whenever format = 'e' or 'E'.  The default is a fixed-point
notation, i.e., format = 'F'.
"""
function toString(y::MReal, format::Char='F')::String
    # Display 5 significant figures.
    if format == 'E' || format == 'e'
        return _toString(y.n, "e5")
    else # format == 'F'
        return _toString(y.n, "f5")
    end
end

"""
Function:                                                                     \n
    r = toReal(y)                                                             \n
Returns the real value 'r' held by object 'y'.
"""
function toReal(y::MReal)::Real
    return y.n
end
#=
--------------------------------------------------------------------------------
=#
"""
Type:                                                                         \n
    PhysicalUnits                                                             \n
        c   exponent on unit: centimeters                                     \n
        g   exponent on unit: grams                                           \n
        s   exponent on unit: seconds                                         \n
Returns a new instance of type 'PhysicalUnits' in the CGS system of units.
"""
struct PhysicalUnits
    c::Int8    # centimeters
    g::Int8    # grams
    s::Int8    # seconds
end

# Overloaded these operators: binary: ==, ≠
#                             unary:  -
#                             binary: +, -

"""
Operator:                                                                     \n
    y == z                                                                    \n
Returns true if the CGS units in 'y' equal those in 'z'; otherwise, it returns
false.
"""
function Base.:(==)(y, z::PhysicalUnits)::Bool
    if y.c == z.c && y.g == z.g && y.s == z.s
        return true
    else
        return false
    end
end

"""
Operator:                                                                     \n
    y ≠ z                                                                     \n
Returns true if the CGS units in 'y' do not equal those in 'z'; otherwise, it
returns false.
"""
function Base.:≠(y, z::PhysicalUnits)::Bool
    if y.c ≠ z.c || y.g ≠ z.g || y.s ≠ z.s
        return true
    else
        return false
    end
end

"""
Operator:                                                                     \n
    y + z                                                                     \n
Adds units 'y' with units 'z'. Handles units whenever two fields are multiplied.
"""
function Base.:+(y, z::PhysicalUnits)::PhysicalUnits
    c = y.c + z.c
    g = y.g + z.g
    s = y.s + z.s
    return PhysicalUnits(c, g, s)
end

"""
Operator:                                                                     \n
    y - z                                                                     \n
Subtracts units 'z' from units 'y'.  Handles units whenever a field associated
with units 'y' is being divided by another field whose units are 'z'.
"""
function Base.:-(y, z::PhysicalUnits)::PhysicalUnits
    c = y.c - z.c
    g = y.g - z.g
    s = y.s - z.s
    return PhysicalUnits(c, g, s)
end

"""
Operator:                                                                     \n
    -y                                                                        \n
Inverts units 'y'.  Handles units whenever a field is inverted.
"""
function Base.:-(y::PhysicalUnits)::PhysicalUnits
    c = -y.c
    g = -y.g
    s = -y.s
    return PhysicalUnits(c, g, s)
end

# Functions of type PhysicalUnits:

"""
Function:                                                                     \n
    c = copy(u)                                                               \n
Returns a shallow copy 'c' of the original set of units 'u'.
"""
function Base.:(copy)(u::PhysicalUnits)::PhysicalUnits
    c = u
    return c
end

"""
Function:                                                                     \n
    c = deepcopy(u)                                                           \n
Returns a deep copy 'c' of the original set of units 'u'.
"""
function Base.:(deepcopy)(u::PhysicalUnits)::PhysicalUnits
    return PhysicalUnits(u.c, u.g, u.s)
end

"""
Function:                                                                     \n
    s = toString(u)                                                           \n
Returns a string 's' representation for the physical units stored in 'u'.
"""
function toString(u::PhysicalUnits)::String
    if u.g > 1
        if u.c > 0 || u.s > 0
            if u.g == 2
                s1 = "g²⋅"
            elseif u.g == 3
                s1 = "g³⋅"
            else
                s1 = string("g^", string(u.g), "⋅")
            end
        else
            if u.g == 2
                s1 = "g²"
            elseif u.g == 3
                s1 = "g³"
            else
                s1 = string("g^", string(u.g))
            end
        end
    elseif u.g == 1
        if u.c > 0 || u.s > 0
            s1 = "g⋅"
        else
            s1 = "g"
        end
    else
        s1 = ""
    end
    if u.c > 1
        if u.s > 0
            if u.c == 2
                s2 = "cm²⋅"
            elseif u.c == 3
                s2 = "cm³⋅"
            else
                s2 = string("cm^", string(u.c), "⋅")
            end
        else
            if u.c == 2
                s2 = "cm²"
            elseif u.c == 3
                s2 = "cm³"
            else
                s2 = string("cm^", string(u.c))
            end
        end
    elseif u.c == 1
        if u.s > 0
            s2 = "cm⋅"
        else
            s2 = "cm"
        end
    else
        s2 = ""
    end
    if u.s > 1
        if u.s == 2
            s3 = "s²"
        elseif u.s == 3
            s3 = "s³"
        else
            s3 = string("s^", string(u.s))
        end
    elseif u.s == 1
        s3 = "s"
    else
        s3 = ""
    end
    count = 0
    if u.c < 0
        count += 1
    end
    if u.g < 0
        count += 1
    end
    if u.s < 0
        count += 1
    end
    if count > 1
        if u.c < 1 && u.g < 1 && u.s < 1
            s4 = "1/("
        else
            s4 = "/("
        end
    elseif count == 1
        if u.c < 1 && u.g < 1 && u.s < 1
            s4 = "1/"
        else
            s4 = "/"
        end
    else
        s4 = ""
    end
    if u.g < -1
        if u.c < 0 || u.s < 0
            if u.g == -2
                s5 = "g²⋅"
            elseif u.g == -3
                s5 = "g³⋅"
            else
                s5 = string("g^", string(-u.g), "⋅")
            end
        else
            if u.g == -2
                s5 = "g²"
            elseif u.g == -3
                s5 = "g³"
            else
                s5 = string("g^", string(-u.g))
            end
        end
    elseif u.g == -1
        if u.c < 0 || u.s < 0
            s5 = "g⋅"
        else
            s5 = "g"
        end
    else
        s5 = ""
    end
    if u.c < -1
        if u.s < 0
            if u.c == -2
                s6 = "cm²⋅"
            elseif u.c == -3
                s6 = "cm³⋅"
            else
                s6 = string("cm^", string(-u.c), "⋅")
            end
        else
            if u.c == -2
                s6 = "cm²"
            elseif u.c == -3
                s6 = "cm³"
            else
                s6 = string("cm^", string(-u.c))
            end
        end
    elseif u.c == -1
        if u.s < 0
            s6 = "cm⋅"
        else
            s6 = "cm"
        end
    else
        s6 = ""
    end
    if u.s < -1
        if u.s == -2
            s7 = "s²"
        elseif u.s == -3
            s7 = "s³"
        else
            s7 = string("s^", string(-u.s))
        end
    elseif u.s == -1
        s7 = "s"
    else
        s7 = ""
    end
    if count > 1
        s8 = ")"
    else
        s8 = ""
    end
    s = string(s1, s2, s3, s4, s5, s6, s7, s8)
end

# Constants of type PhysicalUnits in the CGS system of units.

const DIMENSIONLESS = PhysicalUnits(0, 0, 0)
const GRAM =          PhysicalUnits(0, 1, 0)
const MASS =          PhysicalUnits(0, 1, 0)
const CENTIMETER =    PhysicalUnits(1, 0, 0)
const LENGTH =        PhysicalUnits(1, 0, 0)
const AREA =          PhysicalUnits(2, 0, 0)
const VOLUME =        PhysicalUnits(3, 0, 0)
const SECOND =        PhysicalUnits(0, 0, 1)
const TIME =          PhysicalUnits(0, 0, 1)
const MASSDENSITY =   PhysicalUnits(-3, 1, 0)
const DISPLACEMENT =  PhysicalUnits(1, 0, 0)
const VELOCITY =      PhysicalUnits(1, 0, -1)
const ACCELERATION =  PhysicalUnits(1, 0, -2)
const DYNE =          PhysicalUnits(1, 1, -2)
const FORCE =         PhysicalUnits(1, 1, -2)
const ERG =           PhysicalUnits(2, 1, -2)
const ENERGY =        PhysicalUnits(2, 1, -2)
const POWER =         PhysicalUnits(2, 1, -3)
const BARYE =         PhysicalUnits(-1, 1, -2)
const STRESS =        PhysicalUnits(-1, 1, -2)
const COMPLIANCE =    PhysicalUnits(1, -1, 2)
const MODULUS =       PhysicalUnits(-1, 1, -2)
const STRETCH =       PhysicalUnits(0, 0, 0)
const STRAIN =        PhysicalUnits(0, 0, 0)
const STRAINRATE =    PhysicalUnits(0, 0, -1)
#=
--------------------------------------------------------------------------------
=#
"""
Type:                                                                         \n
    PhysicalScalar                                                            \n
        r    a mutable real number represented floating point number          \n
        u    the physical units associated with this scalar valued field      \n
Returns a new instance of type 'PhysicalScalar'.
"""
struct PhysicalScalar
    x::MReal            # value of the scalar
    u::PhysicalUnits    # units of the scalar
end

"""
Constructor:                                                                  \n
    s = newScalar(x, units)                                                   \n
Returns a new scalar 's' of type 'PhysicalScalar' with value 'x' having
physical units of 'units'.
"""
function newScalar(x::Real, u::PhysicalUnits)::PhysicalScalar
    return PhysicalScalar(MReal(x), u)
end

# Overloaded these operators: binary: ==, ≠, <, ≤, ≥, >
#                             unary:  -
#                             binary: +, -, *, /

"""
Operator:                                                                     \n
    y == z                                                                    \n
Returns true if the value at 'y.x' equals the value at 'z.x', and if the units
at 'y.u' equal the units at 'z.u'; otherwise, it returns false. If either 'y' or
'z' is of type Real, MInteger or MReal, then the scalar must be dimensionless.
"""
function Base.:(==)(y, z::PhysicalScalar)::Bool
    if y.u == z.u && y.x == z.x
        return true
    else
        return false
    end
end

function Base.:(==)(y::Real, z::PhysicalScalar)::Bool
    if z.u == DIMENSIONLESS && y == z.x
        return true
    else
        return false
    end
end

function Base.:(==)(y::PhysicalScalar, z::Real)::Bool
    if y.u == DIMENSIONLESS && y.x == z
        return true
    else
        return false
    end
end

function Base.:(==)(y::MReal, z::PhysicalScalar)::Bool
    if z.u == DIMENSIONLESS && y == z.x
        return true
    else
        return false
    end
end

function Base.:(==)(y::PhysicalScalar, z::MReal)::Bool
    if y.u == DIMENSIONLESS && y.x == z
        return true
    else
        return false
    end
end

function Base.:(==)(y::MInteger, z::PhysicalScalar)::Bool
    if z.u == DIMENSIONLESS && y == z.x
        return true
    else
        return false
    end
end

function Base.:(==)(y::PhysicalScalar, z::MInteger)::Bool
    if y.u == DIMENSIONLESS && y.x == z
        return true
    else
        return false
    end
end

"""
Operator:                                                                     \n
    y ≠ z                                                                     \n
Returns true if the value at 'y.x' does not equal the value at 'z.x', or if the
units at 'y.u' do not equal the units at 'z.u'; otherwise, it returns false.
If either 'y' or 'z' is of type Real, MInteger or MReal, then the scalar must be
dimensionless.
"""
function Base.:≠(y, z::PhysicalScalar)::Bool
    if y.u ≠ z.u || y.x ≠ z.x
        return true
    else
        return false
    end
end

function Base.:≠(y::Real, z::PhysicalScalar)::Bool
    if z.u ≠ DIMENSIONLESS || y ≠ z.x
        return true
    else
        return false
    end
end

function Base.:≠(y::PhysicalScalar, z::Real)::Bool
    if y.u ≠ DIMENSIONLESS || y.x ≠ z
        return true
    else
        return false
    end
end

function Base.:≠(y::MReal, z::PhysicalScalar)::Bool
    if z.u ≠ DIMENSIONLESS || y ≠ z.x
        return true
    else
        return false
    end
end

function Base.:≠(y::PhysicalScalar, z::MReal)::Bool
    if y.u ≠ DIMENSIONLESS || y.x ≠ z
        return true
    else
        return false
    end
end

function Base.:≠(y::MInteger, z::PhysicalScalar)::Bool
    if z.u ≠ DIMENSIONLESS || y ≠ z.x
        return true
    else
        return false
    end
end

function Base.:≠(y::PhysicalScalar, z::MInteger)::Bool
    if y.u ≠ DIMENSIONLESS || y.x ≠ z
        return true
    else
        return false
    end
end

"""
Operator:                                                                     \n
    y < z                                                                     \n
Returns true if 'y' and 'z' have the same units and their values obey y.x < z.x;
otherwise, it returns false.  If either 'y' or 'z' is of type Real, MInteger or
MReal, then the scalar must be dimensionless.
"""
function Base.:<(y, z::PhysicalScalar)::Bool
    if y.u ≠ z.u
        msg = "Scalar comparison '<' requires they have the same units."
        throw(ErrorException(msg))
    elseif y.x < z.x
        return true
    else
        return false
    end
end

function Base.:<(y::Real, z::PhysicalScalar)::Bool
    if z.u ≠ DIMENSIONLESS
        msg = "A comparison '<' between a real and a scalar requires the scalar"
        msg *= " to be dimensionless."
        throw(ErrorException(msg))
    elseif y < z.x
        return true
    else
        return false
    end
end

function Base.:<(y::PhysicalScalar, z::Real)::Bool
    if y.u ≠ DIMENSIONLESS
        msg = "A comparison '<' between a scalar and a real requires the scalar"
        msg *= " to be dimensionless."
        throw(ErrorException(msg))
    elseif y.x < z
        return true
    else
        return false
    end
end

function Base.:<(y::MReal, z::PhysicalScalar)::Bool
    if z.u ≠ DIMENSIONLESS
        msg = "A comparison '<' between a real and a scalar requires the scalar"
        msg *= " to be dimensionless."
        throw(ErrorException(msg))
    elseif y < z.x
        return true
    else
        return false
    end
end

function Base.:<(y::PhysicalScalar, z::MReal)::Bool
    if y.u ≠ DIMENSIONLESS
        msg = "A comparison '<' between a scalar and a real requires the scalar"
        msg *= " to be dimensionless."
        throw(ErrorException(msg))
    elseif y.x < z
        return true
    else
        return false
    end
end

function Base.:<(y::MInteger, z::PhysicalScalar)::Bool
    if z.u ≠ DIMENSIONLESS
        msg = "A comparison '<' between an integer and a scalar requires the"
        msg *= " scalar to be dimensionless."
        throw(ErrorException(msg))
    elseif y < z.x
        return true
    else
        return false
    end
end

function Base.:<(y::PhysicalScalar, z::MInteger)::Bool
    if y.u ≠ DIMENSIONLESS
        msg = "A comparison '<' between a scalar and an integer requires the"
        msg *= " scalar to be dimensionless."
        throw(ErrorException(msg))
    elseif y.x < z
        return true
    else
        return false
    end
end

"""
Operator:                                                                     \n
    y ≤ z                                                                     \n
Returns true if 'y' and 'z' have the same units and their values obey y.x ≤ z.x;
otherwise, it returns false.  If either 'y' or 'z' is of type Real, MInteger or
MReal, then the scalar must be dimensionless.
"""
function Base.:≤(y, z::PhysicalScalar)::Bool
    if y.u ≠ z.u
        msg = "Scalar comparison '≤' requires they have the same units."
        throw(ErrorException(msg))
    elseif y.x ≤ z.x
        return true
    else
        return false
    end
end

function Base.:≤(y::Real, z::PhysicalScalar)::Bool
    if z.u ≠ DIMENSIONLESS
        msg = "A comparison '≤' between a real and a scalar requires the scalar"
        msg *= " to be dimensionless."
        throw(ErrorException(msg))
    elseif y ≤ z.x
        return true
    else
        return false
    end
end

function Base.:≤(y::PhysicalScalar, z::Real)::Bool
    if y.u ≠ DIMENSIONLESS
        msg = "A comparison '≤' between a scalar and a real requires the scalar"
        msg*= " to be dimensionless."
        throw(ErrorException(msg))
    elseif y.x ≤ z
        return true
    else
        return false
    end
end

function Base.:≤(y::MReal, z::PhysicalScalar)::Bool
    if z.u ≠ DIMENSIONLESS
        msg = "A comparison '≤' between a real and a scalar requires the scalar"
        msg *= " to be dimensionless."
        throw(ErrorException(msg))
    elseif y ≤ z.x
        return true
    else
        return false
    end
end

function Base.:≤(y::PhysicalScalar, z::MReal)::Bool
    if y.u ≠ DIMENSIONLESS
        msg = "A comparison '≤' between a scalar and a real requires the scalar"
        msg*= " to be dimensionless."
        throw(ErrorException(msg))
    elseif y.x ≤ z
        return true
    else
        return false
    end
end

function Base.:≤(y::MInteger, z::PhysicalScalar)::Bool
    if z.u ≠ DIMENSIONLESS
        msg = "A comparison '≤' between an integer and a scalar requires the"
        msg *= " scalar to be dimensionless."
        throw(ErrorException(msg))
    elseif y ≤ z.x
        return true
    else
        return false
    end
end

function Base.:≤(y::PhysicalScalar, z::MInteger)::Bool
    if y.u ≠ DIMENSIONLESS
        msg = "A comparison '≤' between a scalar and an integer requires the"
        msg*= " scalar to be dimensionless."
        throw(ErrorException(msg))
    elseif y.x ≤ z
        return true
    else
        return false
    end
end

"""
Operator:                                                                     \n
    y > z                                                                     \n
Returns true if 'y' and 'z' have same units, and their values obey y.x > z.x;
otherwise, it returns false.  If either 'y' or 'z' is of type Real, MInteger or
MReal, then the scalar must be dimensionless.
"""
function Base.:>(y, z::PhysicalScalar)::Bool
    if y.u ≠ z.u
        msg = "Scalar comparison '>' requires they have the same units."
        throw(ErrorException(msg))
    elseif y.x > z.x
        return true
    else
        return false
    end
end

function Base.:>(y::Real, z::PhysicalScalar)::Bool
    if z.u ≠ DIMENSIONLESS
        msg = "A comparison '>' between a real and a scalar requires the scalar"
        msg *= " to be dimensionless."
        throw(ErrorException(msg))
    elseif y > z.x
        return true
    else
        return false
    end
end

function Base.:>(y::PhysicalScalar, z::Real)::Bool
    if y.u ≠ DIMENSIONLESS
        msg = "A comparison '>' between a scalar and a real requires the scalar"
        msg *= " to be dimensionless."
        throw(ErrorException(msg))
    elseif y.x > z
        return true
    else
        return false
    end
end

function Base.:>(y::MReal, z::PhysicalScalar)::Bool
    if z.u ≠ DIMENSIONLESS
        msg = "A comparison '>' between a real and a scalar requires the scalar"
        msg *= " to be dimensionless."
        throw(ErrorException(msg))
    elseif y > z.x
        return true
    else
        return false
    end
end

function Base.:>(y::PhysicalScalar, z::MReal)::Bool
    if y.u ≠ DIMENSIONLESS
        msg = "A comparison '>' between a scalar and a real requires the scalar"
        msg *= " to be dimensionless."
        throw(ErrorException(msg))
    elseif y.x > z
        return true
    else
        return false
    end
end

function Base.:>(y::MInteger, z::PhysicalScalar)::Bool
    if z.u ≠ DIMENSIONLESS
        msg = "A comparison '>' between an integer and a scalar requires the"
        msg *= " scalar to be dimensionless."
        throw(ErrorException(msg))
    elseif y > z.x
        return true
    else
        return false
    end
end

function Base.:>(y::PhysicalScalar, z::MInteger)::Bool
    if y.u ≠ DIMENSIONLESS
        msg = "A comparison '>' between a scalar and an integer requires the"
        msg *= " scalar to be dimensionless."
        throw(ErrorException(msg))
    elseif y.x > z
        return true
    else
        return false
    end
end

"""
Operator:                                                                     \n
    y ≥ z                                                                     \n
Returns true if 'y' and 'z' have the same units and if their values obey
y.x ≥ z.x; otherwise, it returns false.  If either 'y' or 'z' is of type Real,
MInteger or MReal, then the scalar must be dimensionless.
"""
function Base.:≥(y, z::PhysicalScalar)::Bool
    if y.u ≠ z.u
        msg = "Scalar comparison '≥' requires they have the same units."
        throw(ErrorException(msg))
    elseif y.x ≥ z.x
        return true
    else
        return false
    end
end

function Base.:≥(y::Real, z::PhysicalScalar)::Bool
    if z.u ≠ DIMENSIONLESS
        msg = "A comparison '≥' between a real and a scalar requires the scalar"
        msg *= " to be dimensionless."
        throw(ErrorException(msg))
    elseif y ≥ z.x
        return true
    else
        return false
    end
end

function Base.:≥(y::PhysicalScalar, z::Real)::Bool
    if y.u ≠ DIMENSIONLESS
        msg = "A comparison '≥' between a scalar and a real requires the scalar"
        msg *= " to be dimensionless."
        throw(ErrorException(msg))
    elseif y.x ≥ z
        return true
    else
        return false
    end
end

function Base.:≥(y::MReal, z::PhysicalScalar)::Bool
    if z.u ≠ DIMENSIONLESS
        msg = "A comparison '≥' between a real and a scalar requires the scalar"
        msg *= " to be dimensionless."
        throw(ErrorException(msg))
    elseif y ≥ z.x
        return true
    else
        return false
    end
end

function Base.:≥(y::PhysicalScalar, z::MReal)::Bool
    if y.u ≠ DIMENSIONLESS
        msg = "A comparison '≥' between a scalar and a real requires the scalar"
        msg *= " to be dimensionless."
        throw(ErrorException(msg))
    elseif y.x ≥ z
        return true
    else
        return false
    end
end

function Base.:≥(y::MInteger, z::PhysicalScalar)::Bool
    if z.u ≠ DIMENSIONLESS
        msg = "A comparison '≥' between an integer and a scalar requires the"
        msg *= " to be dimensionless."
        throw(ErrorException(msg))
    elseif y ≥ z.x
        return true
    else
        return false
    end
end

function Base.:≥(y::PhysicalScalar, z::MInteger)::Bool
    if y.u ≠ DIMENSIONLESS
        msg = "A comparison '≥' between a scalar and an integer requires the"
        msg *= " scalar to be dimensionless."
        throw(ErrorException(msg))
    elseif y.x ≥ z
        return true
    else
        return false
    end
end

"""
Operator:                                                                     \n
    -y                                                                        \n
Returns the negative of scalar 'y'.
"""
function Base.:-(y::PhysicalScalar)::PhysicalScalar
    return PhysicalScalar(-y.x, y.u)
end

"""
Operator:                                                                     \n
    y + z                                                                     \n
Returns the sum of two scalars.  If either 'y' or 'z' is of type Real, MInteger
or MReal, then the scalar must be dimensionless.
"""
function Base.:+(y, z::PhysicalScalar)::PhysicalScalar
    if y.u ≠ z.u
        msg = "Scalar addition '+' requires they have the same units."
        throw(ErrorException(msg))
    end
    value = y.x + z.x
    return PhysicalScalar(value, y.u)
end

function Base.:+(y::Real, z::PhysicalScalar)::PhysicalScalar
    if z.u ≠ DIMENSIONLESS
        msg = "Adding '+' a real with a scalar requires the scalar to be "
        msg *= "dimensionless."
        throw(ErrorException(msg))
    end
    value = y + z.x
    return PhysicalScalar(value, DIMENSIONLESS)
end

function Base.:+(y::PhysicalScalar, z::Real)::PhysicalScalar
    if y.u ≠ DIMENSIONLESS
        msg = "Adding '+' a scalar with a real requires the scalar to be "
        msg = "dimensionless."
        throw(ErrorException(msg))
    end
    value = y.x + z
    return PhysicalScalar(value, DIMENSIONLESS)
end

function Base.:+(y::MReal, z::PhysicalScalar)::PhysicalScalar
    if z.u ≠ DIMENSIONLESS
        msg = "Adding '+' a real with a scalar requires the scalar to be "
        msg *= "dimensionless."
        throw(ErrorException(msg))
    end
    value = y + z.x
    return PhysicalScalar(value, DIMENSIONLESS)
end

function Base.:+(y::PhysicalScalar, z::MReal)::PhysicalScalar
    if y.u ≠ DIMENSIONLESS
        msg = "Adding '+' a scalar with a real requires the scalar to be "
        msg = "dimensionless."
        throw(ErrorException(msg))
    end
    value = y.x + z
    return PhysicalScalar(value, DIMENSIONLESS)
end

function Base.:+(y::MInteger, z::PhysicalScalar)::PhysicalScalar
    if z.u ≠ DIMENSIONLESS
        msg = "Adding '+' an integer with a scalar requires the scalar to be "
        msg *= "dimensionless."
        throw(ErrorException(msg))
    end
    value = y + z.x
    return PhysicalScalar(value, DIMENSIONLESS)
end

function Base.:+(y::PhysicalScalar, z::MInteger)::PhysicalScalar
    if y.u ≠ DIMENSIONLESS
        msg = "Adding '+' a scalar with an integer requires the scalar to be "
        msg = "dimensionless."
        throw(ErrorException(msg))
    end
    value = y.x + z
    return PhysicalScalar(value, DIMENSIONLESS)
end

"""
Operator:                                                                     \n
    y - z                                                                     \n
Returns the difference between two scalars.  If either 'y' or 'z' is of type
Real, MInteger or MReal, then the scalar must be dimensionless.
"""
function Base.:-(y, z::PhysicalScalar)::PhysicalScalar
    if y.u ≠ z.u
        msg = "Scalar subtraction '-' requires they have the same units."
        throw(ErrorException(msg))
    end
    value = y.x - z.x
    return PhysicalScalar(value, y.u)
end

function Base.:-(y::Real, z::PhysicalScalar)::PhysicalScalar
    if z.u ≠ DIMENSIONLESS
        msg = "Subtracting '-' a scalar from a real requires the scalar to be "
        msg *= "dimensionless."
        throw(ErrorException(msg))
    end
    value = y - z.x
    return PhysicalScalar(value, DIMENSIONLESS)
end

function Base.:-(y::PhysicalScalar, z::Real)::PhysicalScalar
    if y.u ≠ DIMENSIONLESS
        msg = "Subtracting '-' a real from a scalar requires the scalar to be "
        msg *= "dimensionless."
        throw(ErrorException(msg))
    end
    value = y.x - z
    return PhysicalScalar(value, DIMENSIONLESS)
end

function Base.:-(y::MReal, z::PhysicalScalar)::PhysicalScalar
    if z.u ≠ DIMENSIONLESS
        msg = "Subtracting '-' a scalar from a real requires the scalar to be "
        msg *= "dimensionless."
        throw(ErrorException(msg))
    end
    value = y - z.x
    return PhysicalScalar(value, DIMENSIONLESS)
end

function Base.:-(y::PhysicalScalar, z::MReal)::PhysicalScalar
    if y.u ≠ DIMENSIONLESS
        msg = "Subtracting '-' a real from a scalar requires the scalar to be "
        msg *= "dimensionless."
        throw(ErrorException(msg))
    end
    value = y.x - z
    return PhysicalScalar(value, DIMENSIONLESS)
end

function Base.:-(y::MInteger, z::PhysicalScalar)::PhysicalScalar
    if z.u ≠ DIMENSIONLESS
        msg = "Subtracting '-' a scalar from an integer requires the scalar"
        msg *= " to be dimensionless."
        throw(ErrorException(msg))
    end
    value = y - z.x
    return PhysicalScalar(value, DIMENSIONLESS)
end

function Base.:-(y::PhysicalScalar, z::MInteger)::PhysicalScalar
    if y.u ≠ DIMENSIONLESS
        msg = "Subtracting '-' an integer from a scalar requires the scalar"
        msg *= " to be dimensionless."
        throw(ErrorException(msg))
    end
    value = y.x - z
    return PhysicalScalar(value, DIMENSIONLESS)
end

"""
Operator:                                                                     \n
    y * z                                                                     \n
Returns the product of two scalars, or between a scalar and an integer or real.
"""
function Base.:*(y, z::PhysicalScalar)::PhysicalScalar
    value = y.x * z.x
    units = y.u + z.u
    return PhysicalScalar(value, units)
end

function Base.:*(y::Real, z::PhysicalScalar)::PhysicalScalar
    value = y * z.x
    return PhysicalScalar(value, z.u)
end

function Base.:*(y::PhysicalScalar, z::Real)::PhysicalScalar
    value = y.x * z
    return PhysicalScalar(value, y.u)
end

function Base.:*(y::MReal, z::PhysicalScalar)::PhysicalScalar
    value = y * z.x
    return PhysicalScalar(value, z.u)
end

function Base.:*(y::PhysicalScalar, z::MReal)::PhysicalScalar
    value = y.x * z
    return PhysicalScalar(value, y.u)
end

function Base.:*(y::MInteger, z::PhysicalScalar)::PhysicalScalar
    value = y * z.x
    return PhysicalScalar(value, z.u)
end

function Base.:*(y::PhysicalScalar, z::MInteger)::PhysicalScalar
    value = y.x * z
    return PhysicalScalar(value, y.u)
end

"""
Operator:                                                                     \n
    y / z                                                                     \n
Returns the ratio of two scalars, or a division between a scalar and an integer
or a real.
"""
function Base.:/(y, z::PhysicalScalar)::PhysicalScalar
    value = y.x / z.x
    units = y.u - z.u
    return PhysicalScalar(value, units)
end

function Base.:/(y::Real, z::PhysicalScalar)::PhysicalScalar
    value = y / z.x
    units = -z.u
    return PhysicalScalar(value, units)
end

function Base.:/(y::PhysicalScalar, z::Real)::PhysicalScalar
    value = y.x / z
    return PhysicalScalar(value, y.u)
end

function Base.:/(y::MReal, z::PhysicalScalar)::PhysicalScalar
    value = y / z.x
    units = -z.u
    return PhysicalScalar(value, units)
end

function Base.:/(y::PhysicalScalar, z::MReal)::PhysicalScalar
    value = y.x / z
    return PhysicalScalar(value, y.u)
end

function Base.:/(y::MInteger, z::PhysicalScalar)::PhysicalScalar
    value = y / z.x
    units = -z.u
    return PhysicalScalar(value, units)
end

function Base.:/(y::PhysicalScalar, z::MInteger)::PhysicalScalar
    value = y.x / z
    return PhysicalScalar(value, y.u)
end

function Base.:^(y::PhysicalScalar, z::Real)::PhysicalScalar
    if y.u ≠ DIMENSIONLESS
        msg = "Scalars raised to powers must be dimensionless."
        throw(ErrorException(msg))
    end
    value = y.x^z
    return PhysicalScalar(value, y.u)
end

function Base.:^(y::PhysicalScalar, z::MReal)::PhysicalScalar
    if y.u ≠ DIMENSIONLESS
        msg = "Scalars raised to powers must be dimensionless."
        throw(ErrorException(msg))
    end
    value = y.x^z
    return PhysicalScalar(value, y.u)
end

function Base.:^(y::PhysicalScalar, z::MInteger)::PhysicalScalar
    if y.u ≠ DIMENSIONLESS
        msg = "Scalars raised to powers must be dimensionless."
        throw(ErrorException(msg))
    end
    value = y.x^z
    return PhysicalScalar(value, y.u)
end

# Functions of type PhysicalScalar:

"""
Function:                                                                     \n
    abss = abs(s)                                                             \n
Returns the absolute value of a scalar 's'.
"""
function Base.:(abs)(s::PhysicalScalar)::PhysicalScalar
    return PhysicalScalar(abs(s.x), s.u)
end

"""
Function:                                                                     \n
    c = copy(s)                                                               \n
Returns a shallow copy 'c' of the original scalar 's'.
"""
function Base.:(copy)(s::PhysicalScalar)::PhysicalScalar
    c = s
    return c
end

"""
Function:                                                                     \n
    c = deepcopy(s)                                                           \n
Returns a deep copy 'c' of the original scalar 's'.
"""
function Base.:(deepcopy)(s::PhysicalScalar)::PhysicalScalar
    x = deepcopy(s.x)
    u = deepcopy(s.u)
    return PhysicalScalar(x, u)
end

"""
Function:                                                                     \n
    str = toString(s, format='F')                                             \n
Returns a string 'str' representation for the physical scalar 's' in scientific
notation whenever format = 'e' or 'E'.  The default is a fixed-point notation,
i.e., format = 'F'.
"""
function toString(s::PhysicalScalar, format::Char='F')::String
    sx = toString(s.x, format)
    if s.u ≠ DIMENSIONLESS
        return string(sx, ' ', toString(s.u))
    else
        return sx
    end
end
#=
--------------------------------------------------------------------------------
=#
"""
Type:                                                                         \n
    PhysicalVector                                                            \n
        l    the vector's length                                              \n
        v    the vector's values: a static array of length 'n'                \n
        u    the vector's units: an instance of PhysicalUnits                 \n
Returns a new instance of type 'PhysicalVector'.
"""
struct PhysicalVector
    l::Integer          # immutable length of the vector
    v::StaticVector     # array of values establishing the vector
    u::PhysicalUnits    # units for the vector
end

"""
Constructor:                                                                  \n
    v = newVector(len, units)                                                 \n
Returns a new vector 'v' of type 'PhysicalVector' with a length of 'len' and
with physical units of 'units'.
"""
function newVector(len::Integer, units::PhysicalUnits)::PhysicalVector
    if len < 1
        msg = string("A vector cannot have a length of ", string(len), ".")
        throw(DomainError(len, msg))
    end
    vec = @MVector zeros(Float64, len)
    return PhysicalVector(len, vec, units)
end

# Define the get and set functions to assign and retrieve a vector's elements.

function Base.:(getindex)(y::PhysicalVector, idx::Integer)::PhysicalScalar
    if idx < 1 || idx > y.l
        msg = string("Index ", string(idx), " lies outside the admissible ")
        msg *= string("range of [1,", string(y.l), "] for this vector.")
        throw(DomainError(idx, msg))
    end
    return newScalar(y.v[idx], y.u)
end

function Base.:(setindex!)(y::PhysicalVector, val::PhysicalScalar, idx::Integer)
    if idx < 1 || idx > y.l
        msg = string("Index ", string(idx), " lies outside the admissible ")
        msg *= string("range of [1,", string(y.l), "] for this vector.")
        throw(DomainError(idx, msg))
    end
    if y.u ≠ val.u
        msg = string("The units of the sent scalar, ", toString(val.u))
        msg *= string(", differ from those of the vector, ", toString(y.u))
        msg *= ", in the [] assignment for this physical vector."
        throw(ErrorException(msg))
    end
    y.v[idx] = val.x.n
    return nothing
end

# Overloaded these operators: binary: ==, ≠
#                             unary:  -
#                             binary: +, -, *, /

"""
Operator:                                                                     \n
    y == z                                                                    \n
Returns true if the vectors have the same length, and if their entries are
equal, and if their units are the same; otherwise, it returns false.
"""
function Base.:(==)(y, z::PhysicalVector)::Bool
    notEqual = (y ≠ z)
    return !notEqual
end

"""
Operator:                                                                     \n
    y ≠ z                                                                     \n
Returns true if the vectors have different lengths, or if their entries are
different, or if they have different units; otherwise, it returns false.
"""
function Base.:≠(y, z::PhysicalVector)::Bool
    if y.u ≠ z.u || y.l ≠ z.l
        return true
    end
    for i in 1:y.l
        if y.v[i] ≠ z.v[i]
            return true
        end
    end
    return false
end

"""
Operator:                                                                     \n
    -y                                                                        \n
Returns the negative of vector 'y'.
"""
function Base.:-(y::PhysicalVector)::PhysicalVector
    vec = newVector(y.l, y.u)
    vec.v[:] = -y.v[:]
    return vec
end

"""
Operator:                                                                     \n
    y + z                                                                     \n
Returns the sum of two physical vectors.
"""
function Base.:+(y, z::PhysicalVector)::PhysicalVector
    if y.u ≠ z.u
        msg = "Vector addition '+' requires vectors with the same units."
        throw(ErrorException(msg))
    end
    if y.l ≠ z.l
        msg = "Vector addition '+' requires vectors to have the same length."
        throw(DimensionMismatch(msg))
    end
    vec = newVector(y.l, y.u)
    vec.v[:] = y.v[:] + z.v[:]
    return vec
end

"""
Operator:                                                                     \n
    y - z                                                                     \n
Returns the difference between two physical vectors.
"""
function Base.:-(y, z::PhysicalVector)::PhysicalVector
    if y.u ≠ z.u
        msg = "Vector subtraction '-' requires vectors with the same units."
        throw(ErrorException(msg))
    end
    if y.l ≠ z.l
        msg = "Vector subtraction '-' requires vectors to have the same length."
        throw(DimensionMismatch(msg))
    end
    vec = newVector(y.l, y.u)
    vec.v[:] = y.v[:] - z.v[:]
    return vec
end

"""
Operator:                                                                     \n
    y * z                                                                     \n
Returns the (dot) product between two physical vectors, or the multiplication of
a physical vector by either a scalar or an integer or a real.
"""
function Base.:*(y, z::PhysicalVector)::PhysicalScalar
    if y.l ≠ z.l
        msg = "Vector dot product '*' requires vectors to have the same length."
        throw(DimensionMismatch(msg))
    end
    units = y.u + z.u
    value = LinearAlgebra.dot(y.v, z.v)
    return newScalar(value, units)
end

function Base.:*(y::PhysicalScalar, z::PhysicalVector)::PhysicalVector
    units = y.u + z.u
    vec = newVector(z.l, units)
    vec.v[:] = y.x.n * z.v[:]
    return vec
end

function Base.:*(y::Real, z::PhysicalVector)::PhysicalVector
    vec = newVector(z.l, z.u)
    vec.v[:] = y * z.v[:]
    return vec
end

function Base.:*(y::MReal, z::PhysicalVector)::PhysicalVector
    vec = newVector(z.l, z.u)
    vec.v[:] = y.n * z.v[:]
    return vec
end

function Base.:*(y::MInteger, z::PhysicalVector)::PhysicalVector
    vec = newVector(z.l, z.u)
    vec.v[:] = Real(y.n) * z.v[:]
    return vec
end

"""
Operator:                                                                     \n
    y / z                                                                     \n
Returns the physical vector 'y' being divided by either a scalar or an integer
or a real 'z'.
"""
function Base.:/(y::PhysicalVector, z::PhysicalScalar)::PhysicalVector
    units = y.u - z.u
    vec = newVector(y.l, units)
    vec.v[:] = y.v[:] / z.x.n
    return vec
end

function Base.:/(y::PhysicalVector, z::Real)::PhysicalVector
    vec = newVector(y.l, y.u)
    vec.v[:] = y.v[:] / z
    return vec
end

function Base.:/(y::PhysicalVector, z::MReal)::PhysicalVector
    vec = newVector(y.l, y.u)
    vec.v[:] = y.v[:] / z.n
    return vec
end


function Base.:/(y::PhysicalVector, z::MInteger)::PhysicalVector
    vec = newVector(y.l, y.u)
    vec.v[:] = y.v[:] / Real(z.n)
    return vec
end

# Functions of type PhysicalVector:

"""
Function:                                                                     \n
    c = copy(y)                                                               \n
Returns a shallow copy 'c' of the original vector 'y'.
"""
function Base.:(copy)(y::PhysicalVector)::PhysicalVector
    c = y
    return c
end

"""
Function:                                                                     \n
    c = deepcopy(y)                                                           \n
Returns a deep copy 'c' of the original vector 'y'.
"""
function Base.:(deepcopy)(y::PhysicalVector)::PhysicalVector
    vec = newVector(y.l, y.u)
    vec.v[:] = y.v[:]
    return vec
end

# Extra formating needed to convert a vector into a string.

function _toStringE(v::PhysicalVector)::String
    if v.l < 6
        format = "e5"
    elseif v.l == 6
        format = "e4"
    else
        format = "e3"
    end
    s = string('{', _toString(v.v[1], format))
    if v.l < 8
        for i in 2:v.l
            s *= string(' ', _toString(v.v[i], format))
        end
    else
        for i in 2:5
            s *= string(' ', _toString(v.v[i], format))
        end
        s *= string(" ⋯ ", _toString(v.v[v.l], format))
    end
    s *= string("}ᵀ ", toString(v.u))
    return s
end

function _toStringF(v::PhysicalVector)::String
    if v.l < 9
        format = "f5"
    elseif v.l == 9
        format = "f4"
    else
        format = "f3"
    end
    s = string('{', _toString(v.v[1], format))
    if v.l < 12
        for i in 2:v.l
            s *= string(' ', _toString(v.v[i], format))
        end
    else
        for i in 2:9
            s *= string(' ', _toString(v.v[i], format))
        end
        s *= string(" ⋯ ", _toString(v.v[v.l], format))
    end
    s *= string("}ᵀ ", toString(v.u))
    return s
end

"""
Function:                                                                     \n
    s = toString(y, format='F')                                               \n
Returns a string 's' representation for the physical vector 'y' formated in
scientific or exponential notation whenever format = 'e' or 'E'.  The default
is a fixed-point notation, i.e., format = 'F'.
"""
function toString(y::PhysicalVector, format::Char='F')::String
    if format == 'e' || format == 'E'
        return _toStringE(y)
    else
        return _toStringF(y)
    end
end

"""
Function:                                                                     \n
    p-norm = norm(y, p=2)                                                     \n
Returns the p-norm 'p-norm' of physical vector 'y'.  The default case returns
the Euclidean norm.
"""
function LinearAlgebra.:(norm)(y::PhysicalVector, p::Real=2)::PhysicalScalar
    value = norm(y.v, p)
    return newScalar(value, y.u)
end

"""
Function:                                                                     \n
    v = cross(y, z)                                                           \n
Returns the cross product  v = y × z  between two dimensionless vectors 'y' and
'z' that have lengths of 3.
"""
function LinearAlgebra.:(cross)(y, z::PhysicalVector)::PhysicalVector
    if y.u ≠ DIMENSIONLESS || z.u ≠ DIMENSIONLESS
        msg = "Vector cross product is only defined for dimensionless vectors."
        throw(ErrorException(msg))
    end
    if y.l ≠ 3 || z.l ≠ 3
        msg = "Vector cross product is only defined for 3 dimensional vectors."
        throw(ErrorException(msg))
    end
    x = cross(y.v, z.v)
    vec = newVector(y.l, DIMENSIONLESS)
    vec.v[:] = x[:]
    return vec
end

"""
Function:                                                                     \n
    e = unitVector(y)                                                         \n
Returns a dimensionless unit vector 'e' pointing in the direction of vector 'y'.
"""
function unitVector(y::PhysicalVector)::PhysicalVector
    mag = norm(y.v)  # This is the Euclidean norm.
    vec = newVector(y.l, DIMENSIONLESS)
    vec.v[:] = y.v[:] / mag
    return vec
end
#=
--------------------------------------------------------------------------------
=#
"""
Type:                                                                         \n
    PhysicalMatrix                                                            \n
        r    the number of rows in the matrix                                 \n
        c    the number of columns in the matrix                              \n
        m    the matrice's values: a static matrix of size 'r'x'c'            \n
        u    the matrice's units: an instance of PhysicalUnits                \n
Returns a new instance of type 'PhysicalMatrix'.
"""
struct PhysicalMatrix
    r::Integer          # immutable number of rows
    c::Integer          # immutable number of columns
    m::StaticMatrix     # values or entries of the matrix
    u::PhysicalUnits    # units for the matrix
end

"""
Constructor:                                                                  \n
    mtx = newMatrix(rows, cols, units)                                        \n
Returns a new matrix 'mtx' of type 'PhysicalMatrix' with zeros for entries, a
size or dimension of 'rows'x'cols', with units 'units' of type 'PhysicalUnits'.
"""
function newMatrix(rows, cols::Integer, units::PhysicalUnits)::PhysicalMatrix
    if rows < 1 || cols < 1
        msg = string("A matrix cannot have a size of ", string(rows))
        msg *= string("x", string(cols), ".")
        if rows < 1
            throw(DomainError(rows, msg))
        else
            throw(DomainError(cols, msg))
        end
    end
    mtx = @MMatrix zeros(Float64, rows, cols)
    return PhysicalMatrix(rows, cols, mtx, units)
end

# Define the get and set functions to assign and retrieve a matrix's elements.

function Base.:(getindex)(y::PhysicalMatrix, row, col::Int)::PhysicalScalar
    if row < 1 || row > y.r
        msg = "Row index " * string(row) * " lies outside its admissible range "
        msg *= string("[1,", string(y.r), "] for this physical matrix.")
        throw(DomainError(row, msg))
    end
    if col < 1 || col > y.c
        msg = "Column index " * string(col) * " lies outside its admissible "
        msg *= string("range [1,", string(y.c), "] for this physical matrix.")
        throw(DomainError(col, msg))
    end
    return newScalar(y.m[row,col], y.u)
end

function Base.:(setindex!)(y::PhysicalMatrix, val::PhysicalScalar,
                            row, col::Integer)
    if y.u ≠ val.u
        msg = string("The units of the sent scalar, ", toString(val.u))
        msg *= string(", differ from those of the matrix, ", toString(y.u))
        msg *= ", in the [] assignment for this physical matrix."
        throw(ErrorException(msg))
    end
    y.m[row,col] = val.x.n
    return nothing
end

# Overloaded these operators: binary: ==, ≠
#                             unary:  -
#                             binary: +, -, *, /, \

"""
Operator:                                                                     \n
    y == z                                                                    \n
Returns true if the dimensions of matrix 'y' equal those of matrix 'z', and if
the entries of matrix 'y.m' equal the entries of matrix 'z.m' elementwise, and
if the units at 'y.u' equal the units at 'z.u'; otherwise, it returns false.
"""
function Base.:(==)(y, z::PhysicalMatrix)::Bool
    notEqual = (y ≠ z)
    return !notEqual
end

"""
Operator:                                                                     \n
    y ≠ z                                                                     \n
Returns true if the dimensions of 'y' and 'z' differ, or if an entry of matrix
'y.m' does not equal its entry in matrix 'z.m', or if the units at 'y.u' do not
equal the units at 'z.u'; otherwise, it returns false.
"""
function Base.:≠(y, z::PhysicalMatrix)::Bool
    if y.u ≠ z.u || y.r ≠ z.r || y.c ≠ z.c
        return true
    end
    for i in 1:y.r
        for j in 1:y.c
            if y.m[i,j] ≠ z.m[i,j]
                return true
            end
        end
    end
    return false
end

"""
Operator:                                                                     \n
    -y                                                                        \n
Returns the negative of physical matrix 'y'.
"""
function Base.:-(y::PhysicalMatrix)::PhysicalMatrix
    mtx = newMatrix(y.r, y.c, y.u)
    mtx.m[:,:] = -y.m[:,:]
    return mtx
end

"""
Operator:                                                                     \n
    y + z                                                                     \n
Returns the sum of two physical matrices.
"""
function Base.:+(y, z::PhysicalMatrix)::PhysicalMatrix
    if y.u ≠ z.u
        msg = "Matrix addition '+' requires the units of physical matrix 'y' to"
        msg *= " equal those of physical matrix 'z'."
        throw(ErrorException(msg))
    end
    if y.r ≠ z.r || y.c ≠ z.c
        msg = "Matrix addition '+' requires the size of physical matrix 'y' to"
        msg *= " equal the size of physical matrix 'z'."
        throw(ErrorException(msg))
    end
    mtx = newMatrix(y.r, y.c, y.u)
    mtx.m[:,:] = y.m[:,:] + z.m[:,:]
    return mtx
end

"""
Operator:                                                                     \n
    y - z                                                                     \n
Returns the difference between two physical matrices.
"""
function Base.:-(y, z::PhysicalMatrix)::PhysicalMatrix
    if y.u ≠ z.u
        msg = "Matrix subtration '-' requires the units of physical matrix 'y'"
        msg *= " to equal those of physical matrix 'z'."
        throw(ErrorException(msg))
    end
    if y.r ≠ z.r || y.c ≠ z.c
        msg = "Matrix subtraction '-' requires the size of physical matrix 'y'"
        msg *= " to equal the size of physical matrix 'z'."
        throw(ErrorException(msg))
    end
    mtx = newMatrix(y.r, y.c, y.u)
    mtx.m[:,:] = y.m[:,:] - z.m[:,:]
    return mtx
end

"""
Operator:                                                                     \n
    y * z                                                                     \n
Returns the contraction of a physical matrix with another physical matrix,
or with a physical vector, or with a scalar or a real.
"""
function Base.:*(y, z::PhysicalMatrix)::PhysicalMatrix
    if y.c ≠ z.r
        msg = "Matrix multiplication '*' requires the columns in the first"
        msg *= " matrix to equal the rows in the second matrix."
        throw(DimensionMismatch(msg))
    end
    units = y.u + z.u
    matrix = y.m * z.m
    mtx = newMatrix(y.r, z.c, units)
    mtx.m[:,:] = matrix[:,:]
    return mtx
end

function Base.:*(y::PhysicalMatrix, z::PhysicalVector)::PhysicalVector
    if y.c ≠ z.l
        msg = "Matrix*vector multiplication '*' requires the columns in the"
        msg *= " matrix to equal the length of the vector."
        throw(ErrorException(msg))
    end
    units = y.u + z.u
    vec = newVector(y.r, units)
    for i in 1:y.r
        value = 0.0
        for j in 1:y.c
            value += y.m[i,j] * z.v[j]
        end
        vec.v[i] = value
    end
    return vec
end

function Base.:*(y::PhysicalScalar, z::PhysicalMatrix)::PhysicalMatrix
    units = y.u + z.u
    matrix = newMatrix(z.r, z.c, units)
    matrix.m[:,:] = y.x.n * z.m[:,:]
    return matrix
end

function Base.:*(y::Real, z::PhysicalMatrix)::PhysicalMatrix
    matrix = newMatrix(z.r, z.c, z.u)
    matrix.m[:,:] = y * z.m[:,:]
    return matrix
end

function Base.:*(y::MReal, z::PhysicalMatrix)::PhysicalMatrix
    matrix = newMatrix(z.r, z.c, z.u)
    matrix.m[:,:] = y.n * z.m[:,:]
    return matrix
end

function Base.:*(y::MInteger, z::PhysicalMatrix)::PhysicalMatrix
    matrix = newMatrix(z.r, z.c, z.u)
    matrix.m[:,:] = Real(y.n) * z.m[:,:]
    return matrix
end

"""
Operator:                                                                     \n
    y / z                                                                     \n
Returns the physical matrix 'y' being divided by either a scalar or a real 'z'.
"""
function Base.:/(y::PhysicalMatrix, z::PhysicalScalar)::PhysicalMatrix
    units = y.u - z.u
    matrix = newMatrix(y.r, y.c, units)
    matrix.m[:,:] = y.m[:,:] / z.x.n
    return matrix
end

function Base.:/(y::PhysicalMatrix, z::Real)::PhysicalMatrix
    matrix = newMatrix(y.r, y.c, y.u)
    matrix.m[:,:] = y.m[:,:] / z
    return matrix
end

function Base.:/(y::PhysicalMatrix, z::MReal)::PhysicalMatrix
    matrix = newMatrix(y.r, y.c, y.u)
    matrix.m[:,:] = y.m[:,:] / z.n
    return matrix
end

function Base.:/(y::PhysicalMatrix, z::MInteger)::PhysicalMatrix
    matrix = newMatrix(y.r, y.c, y.u)
    matrix.m[:,:] = y.m[:,:] / Real(z.n)
    return matrix
end

"""
Operator:                                                                     \n
    x = A backslash b                                                         \n
Returns that physical vector 'x' which solves the linear system A*x = b.
"""
function Base.:\(A::PhysicalMatrix, b::PhysicalVector)::PhysicalVector
    if A.r ≠ b.l
        msg = "Solving a linear system of equations requires the number of rows"
        msg *= " in matrix A to equal the length of vector b."
        throw(DimensionMismatch(msg))
    end
    units = b.u - A.u
    vector = A.m \ b.v
    vec = newVector(length(vector), units)
    vec.v[:] = vector[:]
    return vec
end

# Functions of type PhysicalMatrix:

"""
Function:                                                                     \n
    c = copy(y)                                                               \n
Returns a shallow copy 'c' of the original physical matrix 'y'.
"""
function Base.:(copy)(y::PhysicalMatrix)::PhysicalMatrix
    c = y
    return c
end

"""
Function:                                                                     \n
    c = deepcopy(y)                                                           \n
Returns a deep copy 'c' of the original physical matrix 'y'.
"""
function Base.:(deepcopy)(y::PhysicalMatrix)::PhysicalMatrix
    mtx = newMatrix(y.r, y.c, y.u)
    mtx.m[:,:] = y.m[:,:]
    return mtx
end

# Extra formatting required to convert a matrix to a string.

function _toStringE(y::PhysicalMatrix)::String
    # Establish how many rows are to be printed out.
    if y.r < 6
        rows = y.r
    else
        rows = 6
    end
    unitsInRow = 1 + rows ÷ 2
    # Establish how many columns are to be printed out.
    if y.c < 5
        cols = y.c
        format = "e5"
    elseif y.c == 5
        cols = 5
        format = "e4"
    else
        cols = 6
        format = "e3"
    end
    # Create the string representation for this matrix.
    s = ""
    for i in 1:rows
        if i == 1
            s *= '⌈'
        elseif i < rows
            s *= '|'
        else
            s *= '⌊'
        end
        if y.r > rows && i == 5
            if cols < 5
                s *= "     ⋮     "
                for j in 2:cols-2
                    s *= "      ⋮     "
                end
                if y.c > cols
                    s *= "  ⋱       ⋮     "
                else
                    s *= "      ⋮           ⋮     "
                end
            elseif cols == 5
                s *= "    ⋮     "
                for j in 2:cols-2
                    s *= "     ⋮     "
                end
                if y.c > cols
                    s *= "  ⋱     ⋮     "
                else
                    s *= "     ⋮          ⋮     "
                end
            else
                s *= "    ⋮    "
                for j in 2:cols-2
                    s *= "     ⋮    "
                end
                if y.c > cols
                    s *= "  ⋱     ⋮    "
                else
                    s *= "     ⋮         ⋮    "
                end
            end
        else
            for j in 1:cols-2
                s *= string(_toString(y.m[i,j], format), ' ')
            end
            if y.c > cols
                s *= " ⋯ "
            else
                s *= string(_toString(y.m[i,cols-1], format), ' ')
            end
            s *= _toString(y.m[i,y.c], format)
        end
        if i == 1
            s *= '⌉'
        elseif i < rows
            s *= '|'
        else
            s *= '⌋'
        end
        if i == unitsInRow
            s *= string(' ', toString(y.u))
        end
        if i < rows
            s *= "\n"
        end
    end
    return s
end

function _toStringF(y::PhysicalMatrix)::String
    # Establish how many rows are to be printed out.
    if y.r < 11
        rows = y.r
    else
        rows = 10
    end
    unitsInRow = 1 + rows ÷ 2
    # Establish how many columns are to be printed out.
    if y.c < 9
        cols = y.c
        format = "f5"
    elseif y.c == 9
        cols = 9
        format = "f4"
    else
        cols = 10
        format = "f3"
    end
    # Create the string representation for this matrix.
    s = ""
    for i in 1:rows
        if i == 1
            s *= '⌈'
        elseif i < rows
            s *= '|'
        else
            s *= '⌊'
        end
        if y.r > rows && i == 9
            if cols < 9
                s *= "   ⋮   "
                for j in 2:cols-2
                    s *= "    ⋮   "
                end
                if y.c > cols
                    s *= "  ⋱     ⋮   "
                else
                    s *= "    ⋮       ⋮   "
                end
            elseif cols == 9
                s *= "  ⋮   "
                for j in 2:cols-2
                    s *= "   ⋮   "
                end
                if y.c > cols
                    s *= "  ⋱    ⋮   "
                else
                    s *= "   ⋮     ⋮   "
                end
            else
                s *= "  ⋮  "
                for j in 2:cols-2
                    s *= "   ⋮  "
                end
                if y.c > cols
                    s *= "  ⋱   ⋮  "
                else
                    s *= "   ⋮     ⋮  "
                end
            end
        else
            for j in 1:cols-2
                s *= string(_toString(y.m[i,j], format), ' ')
            end
            if y.c > cols
                s *= " ⋯ "
            else
                s *= string(_toString(y.m[i,cols-1], format), ' ')
            end
            s *= _toString(y.m[i,y.c], format)
        end
        if i == 1
            s *= '⌉'
        elseif i < rows
            s *= '|'
        else
            s *= '⌋'
        end
        if i == unitsInRow
            s *= string(' ', toString(y.u))
        end
        if i < rows
            s *= "\n"
        end
    end
    return s
end

"""
Function:                                                                     \n
    s = toString(y, format='F')                                               \n
Returns a string 's' representation for the physical matrix 'y' in scientific or
exponential notation whenever format = 'e' or 'E'.  The default is a fixed-point
notation, i.e., format = 'F'.
"""
function toString(y::PhysicalMatrix, format::Char='F')::String
    if format == 'e' || format == 'E'
        return _toStringE(y)
    else
        return _toStringF(y)
    end
end

"""
Function:                                                                     \n
    p-norm = norm(y, p::Real=2)                                               \n
Returns the p-norm 'norm_F' of physical matrix 'y', where 'p-norm' is a physical
scalar with the same units as matrix 'y'.  The default case is Frobenius' norm.
"""
function LinearAlgebra.:(norm)(y::PhysicalMatrix, p::Real=2)::PhysicalScalar
    pnorm = norm(y.m, p)
    return newScalar(pnorm, y.u)
end

"""
Function:                                                                     \n
    t = tensorProduct(y, z)                                                   \n
Returns the tensor or outer product between two vectors to create a matrix.
"""
function tensorProduct(y, z::PhysicalVector)::PhysicalMatrix
    units = y.u + z.u
    mtx = newMatrix(y.l, z.l, units)
    for i in 1:y.l
        for j in 1:z.l
            mtx.m[i,j] = y.v[i] * z.v[j]
        end
    end
    return mtx
end

"""
Function:                                                                     \n
    yᵀ = transpose(y)                                                         \n
Returns the transpose 'yᵀ' of matrix 'y'.
"""
function Base.:(transpose)(y::PhysicalMatrix)::PhysicalMatrix
    matrix = transpose(y.m)
    mtx = newMatrix(y.c, y.r, y.u)
    mtx.m[:,:] = matrix[:,:]
    return mtx
end

"""
Function:                                                                     \n
    I = tr(y)                                                                 \n
Returns the trace of a physical matrix 'y'.
"""
function LinearAlgebra.:(tr)(y::PhysicalMatrix)::PhysicalScalar
    return newScalar(tr(y.m), y.u)
end

"""
Function:                                                                     \n
    III = det(y)                                                              \n
Returns the determinant of a physical matrix 'y'.
"""
function LinearAlgebra.:(det)(y::PhysicalMatrix)::PhysicalScalar
    units = y.u
    for i in 2:y.r
        units = units + y.u
    end
    return newScalar(det(y.m), units)
end

"""
Function:                                                                     \n
    y⁻¹ = inv(y)                                                              \n
Returns the inverse 'y⁻¹' of physical matrix 'y', if it exists.
"""
function Base.:(inv)(y::PhysicalMatrix)::PhysicalMatrix
    units = -y.u
    matrix = inv(y.m)
    (rows, cols) = size(matrix)
    yInv = newMatrix(rows, cols, units)
    yInv.m[:,:] = matrix[:,:]
    return yInv
end

"""
Function:                                                                     \n
    (q, r) = qr(pm)                                                           \n
Returns the QR (Gram-Schmidt) factorization of a physical matrix 'pm', where
Q is orthogonal and R is upper triangular.
"""
function LinearAlgebra.:(qr)(pm::PhysicalMatrix)::Tuple
    if pm.r == 2 && pm.c == 2
        f1 =[pm.m[1,1], pm.m[2,1]]
        f2 = [pm.m[1,2], pm.m[2,2]]
        mag = sqrt(f1[1]^2 + f1[2]^2)
        e1 = [f1[1]/mag, f1[2]/mag]
        e1dotf1 = e1[1] * f1[1] + e1[2] * f1[2]
        e1dotf2 = e1[1] * f2[1] + e1[2] * f2[2]
        x = f2[1] - e1dotf2 * e1[1]
        y = f2[2] - e1dotf2 * e1[2]
        mag = sqrt(x^2 + y^2)
        e2 = [x/mag, y/mag]
        e2dotf2 = e2[1] * f2[1] + e2[2] * f2[2]
        q = newMatrix(2, 2, DIMENSIONLESS)
        for i in 1:2
            q.m[i,1] = e1[i]
            q.m[i,2] = e2[i]
        end
        r = newMatrix(2, 2, pm.u)
        r.m[1,1] = e1dotf1
        r.m[1,2] = e1dotf2
        r.m[2,2] = e2dotf2
    elseif pm.r == 3 && pm.c == 3
        f1 = [pm.m[1,1], pm.m[2,1], pm.m[3,1]]
        f2 = [pm.m[1,2], pm.m[2,2], pm.m[3,2]]
        f3 = [pm.m[1,3], pm.m[2,3], pm.m[3,3]]
        mag = sqrt(f1[1]^2 + f1[2]^2 + f1[3]^2)
        e1 = [f1[1]/mag, f1[2]/mag, f1[3]/mag]
        e1dotf1 = e1[1] * f1[1] + e1[2] * f1[2] + e1[3] * f1[3]
        e1dotf2 = e1[1] * f2[1] + e1[2] * f2[2] + e1[3] * f2[3]
        e1dotf3 = e1[1] * f3[1] + e1[2] * f3[2] + e1[3] * f3[3]
        x = f2[1] - e1dotf2 * e1[1]
        y = f2[2] - e1dotf2 * e1[2]
        z = f2[3] - e1dotf2 * e1[3]
        mag = sqrt(x^2 + y^2 + z^2)
        e2 = [x/mag, y/mag, z/mag]
        e2dotf2 = e2[1] * f2[1] + e2[2] * f2[2] + e2[3] * f2[3]
        e2dotf3 = e2[1] * f3[1] + e2[2] * f3[2] + e2[3] * f3[3]
        x = f3[1] - e1dotf3 * e1[1] - e2dotf3 * e2[1]
        y = f3[2] - e1dotf3 * e1[2] - e2dotf3 * e2[2]
        z = f3[3] - e1dotf3 * e1[3] - e2dotf3 * e2[3]
        mag = sqrt(x^2 + y^2 + z^2)
        e3 = [x/mag, y/mag, z/mag]
        e3dotf3 = e3[1] * f3[1] + e3[2] * f3[2] + e3[3] * f3[3]
        q = newMatrix(3, 3, DIMENSIONLESS)
        for i in 1:3
            q.m[i,1] = e1[i]
            q.m[i,2] = e2[i]
            q.m[i,3] = e3[i]
        end
        r = newMatrix(3, 3, pm.u)
        r.m[1,1] = e1dotf1
        r.m[1,2] = e1dotf2
        r.m[1,3] = e1dotf3
        r.m[2,2] = e2dotf2
        r.m[2,3] = e2dotf3
        r.m[3,3] = e3dotf3
    else
        msg = "The QR factorization of a physical matrix whose size is "
        msg *= string(string(pm.r), 'x', string(pm.c))
        msg *= " has not been implemented."
        throw(ErrorException(msg))
    end
    return (q, r)
end

"""
Function:                                                                     \n
    (l, q) = lq(y)                                                            \n
Returns the LQ factorization of physical matrix 'y' where L is lower triangular
and Q is orthogonal.  This is the QR factorization of yᵀ.
"""
function LinearAlgebra.:(lq)(y::PhysicalMatrix)::Tuple
    yᵀ = transpose(y)
    (qᵀ, lᵀ) = qr(yᵀ)
    l = transpose(lᵀ)
    q = transpose(qᵀ)
    return (l, q)
end

end  #  module PhysicalFields
