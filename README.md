# PhysicalFields

A physical field is comprised of a numeric value---viz., a number (scalar), an array (vector), or a matrix (tensor)---plus the physical units in terms of which its numeric value has meaning. Temperature is an example for a scalar. Force is an example for a vector. Stress is an example for a tensor. This module creates such fields in a manner that they are readily adaptable for analysis.

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

1. [Mutable Types](./README_MutableTypes.md)

This part of the module provides mutable boolean, integer, rational, real and complex types. Their arithmetic operators are overloaded. Methods have also been written that extend the common math functions for these types.

The intended purpose of mutable types is for their use in immutable data structures that contain a field or fields that may need to have the capability of changing their values during runtime. For example, a data structure that holds material properties may include a boolean field *ruptured* that would get turned on (converted from false to true) after a rupture event has occurred, thereafter allowing different values to associate with its material properties during the remaining runtime.

2. [Physical Units](./README_PhysicalUnits.md)

This part of the module introduces the physical systems of units that a physical field may have. Implemented systems of units include: Dimensionless, CGS (Centimeter, Gram, Second), and SI (International System of Units, viz., meter, kilogram and second). Also included is a physical unit for temperature. Not included are the physical units for: amount of substance, luminous intensity, and electric current.

The CGS system of units is the default system of units, as these units are the most intuitive units for scientists working in the interdisciplinary field of biomechanics, as is the case for the authors of this software.

3. [Physical Scalars](./README_PhysicalScalars.md)

A physical scalar has a numeric quantity represented as a number whose value depends upon the system of units in which it is evaluated in. Arrays of physical scalars are useful as containers, e.g., holding values for a scalar field gathered along a solution path.

4. [Physical Vectors](./README_PhysicalVectors.md)

A physical vector has a numeric quantity represented as a one-dimensional array of numbers whose values depend upon the system of units in which the array is evaluated in. Arrays of physical vectors are useful as containers, e.g., holding values for a vector field gathered along a solution path.

5. [Physical Tensors](./README_PhysicalTensors.md)

A physical tensor has a numeric quantity represented as a matrix or two-dimensional array of numbers whose values depend upon the system of units in which the matrix is evaluated in. Arrays of physical tensors are useful as containers, e.g., holding values for a tensor field gathered along a solution path.

### Writers and Readers

#### Writing to Strings

There is a method that coverts the objects exported by this module into strings for human consumption, i.e., the method `toString.` No reciprocal method for parsing is included, as the intention here is to provide an interface to the user.

#### Writing and Reading To and From JSON Files

There are also methods that write and read objects exported by this module from and/or to a file, thereby enabling their data to become persistent, viz., methods `toFile` and `fromFile.` JSON (JavaScript Object Notation) files are used for this purpose. JSON files store data in key-value pairs, and is therefore an ideal format for storing julia `struct` types to file, too. JSON files are lightweight, text-based, human-readable, and can even be edited using a standard text editor.

To open an existing JSON file for reading, one can call
```
function openJSONReader(my_dir_path::String, my_file_name::String)::IOStream
```
e.g., `json_stream = openJSONReader("home/my_dir", "my_file.json").` This reader attaches to a file located in directory `my_dir_path` whose name is `my_file_name` ending with a `.json` extension. The file is opened in read-only mode. This reader initially points to the beginning of the file.

To create a new, or open an existing JSON file for writing, one can call
```
function openJSONWriter(my_dir_path::String, my_file_name::String)::IOStream
```
e.g., `json_stream = openJSONWriter("home/my_dir", "my_file.json").` This writer attaches to a file located in directory `my_dir_path` whose name is `my_file_name` ending with a `.json` extension. If this file does not exist, it will be created. The file is opened in write-create-append mode. This writer initially points to the beginning of the file, whether it already exists or is to be newly created.

To close the file to which a JSON stream is attached, simply call
```
function closeJSONStream(json_stream::IOStream)
```

The methods that have been created for converting into strings, and for reading and writing from and/or to a file, take advantage of the multiple dispatch capability of the julia compiler. The chosen protocal requires that one knows the type belonging to an object to be read in before it can actually be read in. As implemented, these JSON streams do not store type information; they store the fields of a type.

[Next Page](.\README_MutableTypes.md)

## Version History

### Version 1.1

There have been two fundamental changes made to the API in this release.

First, all constructors are now internal. No external constructors are provided; they have been depreciated. This will affect existing code, but being that the author is presently the only one currently using this code, there should be no impact on other users as they come on board. 

Second, methods have been introduced into the API that enable reading and writing of instances for the various data types introduced in this package from and to a JSON file. Also provided are functions to open and close an IOStream attached to JSON files. This addition required all static arrays held by the various data structures to be converted to dynamic arrays.

### Version 1.0

This is the first formal release of this software. It incorporates the above separate parts into a cohesive single module: `PhysicalFields`.

### Versions 0.1-0.2 

In these developmental versions, the individual parts (viz., mutable types, physical units, scalars, vectors and tensors) were developed separately, tested and refined over a period of time.
