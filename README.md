# PhysicalFields

A physical field is comprised of a numeric value---viz., a number (scalar), an array (vector), or a matrix (tensor)---plus the physical units in terms of which its numeric value has meaning. Pressure is an example for a scalar. Force is an example for a vector. Stress is an example for a tensor. This module creates such fields in a manner that they are readily adoptable for analysis.

To use this module, you will need to add it to your package:

```
using Pkg
Pkg.add(url = "https://github.com/AlanFreed/PhysicalFields.jl")
```

## Abstract Type

All physical fields, e.g., `PhysicalScalar,` are extensions of this super type.

```
abstract type PhysicalField end
```

## Implementation

1. [Persistence](./README_Persistence.md)

This part of the module provides a low-level foundation upon which the remaining parts stand. Specifically, objects created from the types exported by this module are persistent in the sense that they can be written to a file and then recreated by reading them back in from that file. They therefore can have a life that extends beyond the program's run time. These files are written in a JSON (Java Script Object Notation) format. Furthermore, as an aid to the programmer, objects can also be written to a string for visual inspection in, say, the **REPL**.  These methods take advantage of the multiple dispatch capability of the Julia compiler.

2. [Mutable Types](./README_MutableTypes.md)

This part of the module provides mutable boolean, integer and real number types, plus vector (1D array), matrix (2D array) and array (3D array) types whose dimensions are fixed but whose elements are mutable. Their arithmetic operators are overloaded. Methods have also been written that extend the common math functions for the numeric, vector and matrix types.

The intended purpose of mutable types is for their use in immutable data structures that contain a field or fields that may need to have the capability of changing their values during runtime. For example, a data structure that holds material properties may include a boolean field *ruptured* that would get turned on (converted from *false* to *true*) after a rupture event has occurred, thereafter allowing different values to associate with its material properties during the remaining runtime.

3. [Physical Units](./README_PhysicalUnits.md)

This part of the module introduces the physical systems of units that a physical field may have. Implemented systems of units include: the SI (International System of Units, viz., meter, kilogram and second), and the CGS (Centimeter, Gram, Second) system of units. Other systems of units, e.g., the Imperial units, may be added in future updates of the code. All seven physical units are included: length, mass, amount of substance, time, temperature, electric current, and light intensity.

The SI system of units is taken as the default system of units.

4. [Physical Scalars](./README_PhysicalScalars.md)

A physical scalar has a numeric quantity represented as a number whose value depends upon the system of units in which it is evaluated in. Arrays of physical scalars are useful as containers, e.g., holding values for a scalar field gathered along a solution path.

5. [Physical Vectors](./README_PhysicalVectors.md)

A physical vector has a numeric quantity represented as a one-dimensional array of numbers whose values depend upon the system of units in which the array is evaluated in. Arrays of physical vectors are useful as containers, e.g., holding values for a vector field gathered along a solution path.

6. [Physical Tensors](./README_PhysicalTensors.md)

A physical tensor has a numeric quantity represented as a matrix or two-dimensional array of numbers whose values depend upon the system of units in which the matrix is evaluated in. Arrays of physical tensors are useful as containers, e.g., holding values for a tensor field gathered along a solution path.

[Next Page](.\README_Persistence.md)

## Version History

### Version 1.3.0

Moved all the low-level code dealing with persistence into a separate file--a cleaning the code operation. Also, type information is now stored to file when calling method `toFile`  that allows for the correct type to be recreated when retrieving said information using method `fromFile`.

### Version 1.2.5

Included methods for reading and writing vector types for boolean and integer arrays from and to a JSON file, and to a string.

Removed changes made in vs. 1.2.1 in favor of their earlier definitions.

### Version 1.2.1

With version 1.8 of Julia, fields specified by *const* in a mutable struct cannot be reassigned after object creation. This feature was added to the mutable data structures `MVector,` `MMatrix` and `MArray` for their dimension parameters.

### Version 1.2

Mutable 1D vectors, 2D matrices, and 3D arrays have been added. The 2D and 3D arrays are represented internally as 1D arrays whose index operator [] handles the mappings between them. This is done to allow them all to be written-to and read-from a JSON file in an efficient and robust manner.

Mutable types for rational and complex numbers have been removed, as they are not needed in the author's applications.  This greatly simplified the implementation.

Type `PhysicalUnits` has been completely reworked so that it is now a persistent type. Also, it to now includes all seven kinds of physical units belonging to the SI system of units. SI units are now default.

### Version 1.1

There have been two fundamental changes made to the API in this release.

First, all constructors are now internal. No external constructors are provided; they have been depreciated. This will affect existing code, but being that the author is presently the only one currently using this code, there should be no impact on other users as they come on board. 

Second, methods have been introduced into the API that enable reading and writing of instances for the various data types introduced in this package from and to a JSON file. Also provided are functions to open and close an IOStream attached to JSON files. This addition required all static arrays held by the various data structures to be converted to dynamic arrays.

### Version 1.0

This is the first formal release of this software. It incorporates the above separate parts into a cohesive single module: `PhysicalFields`.

### Versions 0.1-0.2 

In these developmental versions, the individual parts (viz., mutable types, physical units, scalars, vectors and tensors) were developed separately, tested and refined over a period of time.
