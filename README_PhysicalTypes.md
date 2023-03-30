# PhysicalFields.jl

This module provides the core types for physical fields, viz., scalars, vectors and tensors, along with array types as containers for scalars, vectors and tensors.


To use this module you will need to add the following Julia packages to yours:

```
using Pkg
Pkg.add(url = "https://github.com/AlanFreed/MutableTypes.jl")
Pkg.add(url = "https://github.com/AlanFreed/PhysicalSystemsOfUnits.jl")
Pkg.add(url = "https://github.com/AlanFreed/PhysicalFields.jl")
```

Physical fields are implementations of the abstract type

  * `PhysicalField`

```
abstract type PhysicalField end
```

whose concrete types are:

  * `PhysicalScalar`:   a mutable number with a set of immutable units

```
struct PhysicalScalar <: PhysicalField
    x::MReal            # value of the scalar in its specified system of units
    u::PhysicalUnits    # the scalar's physical units
end
```

  * `PhysicalVector`:   a vector of mutable entries with a common set of immutable units

```
struct PhysicalVector <: PhysicalField
    l::UInt16           # length of the vector
    v::StaticVector     # values of the vector in its specified system of units
    u::PhysicalUnits    # the vector's physical units
end
```

  * `PhysicalTensor`:   a matrix of mutable entries with a common set of immutable units

```
struct PhysicalTensor <: PhysicalField
    r::UInt16           # rows in the matrix representation of the tensor
    c::UInt16           # columns in the matrix representation of the tensor
    m::StaticMatrix     # values of the tensor in its specified system of units
    u::PhysicalUnits    # the tensor's physical units
end
```

where

```
const PhysicalUnits = PhysicalSystemsOfUnits.PhysicalSystemOfUnits
```

Objects of these types can be collected into arrays of said types via:

  * `ArrayOfPhysicalScalars`:   an array of scalars with the same set of units

```
struct ArrayOfPhysicalScalars
    e::UInt16           # number of entries or elements held in the array
    a::Array            # array holding values of a physical scalar
    u::PhysicalUnits    # units of this physical scalar
end
```

  * `ArrayIfPhysicalVectors`:   an array of vectors with the same set of units and length

```
struct ArrayOfPhysicalVectors
    e::UInt16           # number of entries or elements held in the array
    l::UInt16           # length of each physical vector held in the array
    a::Array            # array of vectors holding values of a physical vector
    u::PhysicalUnits    # units of this physical vector
end
```

  * `ArrayOfPhysicalTensors`:   an array of tensors with the same set of units and dimensions

```
struct ArrayOfPhysicalTensors
    e::UInt16           # number of entries or elements held in the array
    r::UInt16           # rows in each physical tensor held in the array
    c::UInt16           # columns in each physical tensor held in the array
    a::Array            # array of matrices holding values of a physical tensor
    u::PhysicalUnits    # units of this physical tensor
end
```

## Notes

Values held by each of these six types are mutable, but their units are immutable.

The three `ArrayOf<type>` objects can be used as containers, e.g., to hold values for a field of interest collected sequentially over time during an analysis.

The methods and functions pertaining to these types are provided in seperate modules, viz.: `PhysicalScalars`, `PhysicalVectors` and `PhysicalTensors`.

This module only defines these physical types, and also provides constructors with an interface of `new<typeName>({<dimensions>}, <units>)`. Each constructor returns an object whose values have been set to zero, appropriately dimensioned. Constructors for all physical types, except scalars, have a first argument that is a listing of their dimensions, as appropriate, and a final argument that specifies their units.

Constructors for all `ArrayOf<typeName>` objects have a first argument that specifies the length of the array and a second argument that is to be the first entry into this array, which allows its internal static array to be created.

Because all values pertaining to these types are mutable, components for the non-scalar types can be assigned and retrieved using the standard `[]` notation, where scalar fields are passed back and forth as the element entries for this operator. Ellipses, i.e., `..`, are not supported for indexing arrays in these types. All arrays are allowed dimensions within \[1…65535\].

Both `get(<scalarField>)` and `set!(<scalarField>, <value>)` functions are provided by which Real values can be retrieved from and assigned to a scalar field, as the bracket notation `[]` does not apply in this case.
