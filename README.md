# PhysicalFields

A physical field is comprised of a numeric value---viz., a number (scalar), an array (vector) or a matrix (tensor)---plus the physical units in terms of which its numeric value has meaning. Temperature is an example of a scalar. Force is an example of a vector. Stress is an example of a tensor. This module creates such fields in a manner that they are readily adaptable for analysis.

To use this module, you will need to add it to your package:

```
using Pkg
Pkg.add(url = "https://github.com/AlanFreed/PhysicalFields.jl")
```

## Abstract Type

All physical fields, e.g., `PhysicalScalar`, are extensions of this super type.

```
abstract type PhysicalField end
```

## Implementation

1. [Mutable Types](./README_MutableTypes.md)

This part of the module provides mutable boolean, integer, rational, real and complex types. Their arithmetic operators are overloaded. Methods have also been written that extend the common math functions for these types.

The intended purpose of mutable types is for their use in immutable data structures that contain a field or fields that may need the capability to have their values changed during a runtime. For example, a data structure that holds material properties may include a boolean field *ruptured* that would get turned on (converted from false to true) after a rupture event has occurred, thereafter allowing different values to associate with its material properties during the remaining runtime.

2. [Physical Units](./README_PhysicalUnits.md)

This part of the module introduces the physical systems of units that a physical field may have. Implemented systems of units include: CGS (Centimeter, Gram, Second) and SI (International System of Units). Also included is the physical unit for temperature. Not included are the physical units for: amount of substance, luminous intensity, and electric current.

The CGS system of units is the default system of units, as these units are the most intuitive units for people of science interfacing with the interdisciplinary field of biomechanics.

3. [Physical Scalars](./README_PhysicalScalars.md)

A physical scalar has a numeric quantity represented as a number whose value depends upon the system of units in which it was evaluated in. Arrays of physical scalars are useful as containers holding values for a scalar field gathered along a solution path.

4. [Physical Vectors](./README_PhysicalVectors.md)

A physical vector has a numeric quantity represented as an array of numbers whose values depend upon the system of units in which the array was evaluated in. Arrays of physical vectors are useful as containers holding values for a vector field gathered along a solution path.

5. [Physical Tensors](./README_PhysicalTensors.md)

A physical tensor has a numeric quantity represented as a matrix of numbers whose values depend upon the system of units in which the matrix was evaluated in. Arrays of physical tensors are useful as containers holding values for a tensor field gathered along a solution path.

## Version History

### Version 1.0 
This is the first formal release of this software. It incorporates the above separate parts into a cohesive single module: `PhysicalFields`.

### Versions 0.1-0.2 

In these developmental versions, the individual parts (viz., mutable types, physical units, scalars, vectors and tensors) were developed separately, tested and refined over a period of time.
