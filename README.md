# PhysicalFields

A physical field is comprised of a numeric value---viz., a number (scalar), an array (vector), or a matrix (tensor)---plus the physical units in terms of which its numeric value has meaning. Pressure is an example for a scalar. Force is an example for a vector. Stress is an example for a tensor. This module creates such fields in a manner that they are readily adaptable for analysis.

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

This part of the module provides mutable boolean, integer and real number types, plus mutable vector (1D array), matrix (2D array), and array (3D array) types. Their arithmetic operators are overloaded. Methods have also been written that extend the common math functions for the numeric, vector and matrix types.

This part of the module provides a low-level foundation upon which the remaining parts are built upon. Key to this construction is that all mutable types introduced here are persistent in that their values can be written-to and read-from data files. These files are written in a JSON (Java Script Object Notation) format, with the implied consequence that all integer values must be of type Int64 and all real values must be of type Float64.

The intended purpose of mutable types is for their use in immutable data structures that contain a field or fields that may need to have the capability of changing their values during runtime. For example, a data structure that holds material properties may include a boolean field *ruptured* that would get turned on (converted from false to true) after a rupture event has occurred, thereafter allowing different values to associate with its material properties during the remaining runtime.

2. [Physical Units](./README_PhysicalUnits.md)

This part of the module introduces the physical systems of units that a physical field may have. Implemented systems of units include: the SI (International System of Units, viz., meter, kilogram and second), and the CGS (Centimeter, Gram, Second) system of units. Other systems of units, e.g., the Imperial units, may be added in future updates of the code. All seven physical units are included: length, mass, amount of substance, time, temperature, electric current, and light intensity.

The SI system of units is taken as the default system of units.

3. [Physical Scalars](./README_PhysicalScalars.md)

A physical scalar has a numeric quantity represented as a number whose value depends upon the system of units in which it is evaluated in. Arrays of physical scalars are useful as containers, e.g., holding values for a scalar field gathered along a solution path.

4. [Physical Vectors](./README_PhysicalVectors.md)

A physical vector has a numeric quantity represented as a one-dimensional array of numbers whose values depend upon the system of units in which the array is evaluated in. Arrays of physical vectors are useful as containers, e.g., holding values for a vector field gathered along a solution path.

5. [Physical Tensors](./README_PhysicalTensors.md)

A physical tensor has a numeric quantity represented as a matrix or two-dimensional array of numbers whose values depend upon the system of units in which the matrix is evaluated in. Arrays of physical tensors are useful as containers, e.g., holding values for a tensor field gathered along a solution path.

### Writers and Readers

Methods have been created for converting into strings, and for reading from and writing to a file. These methods take advantage of the multiple dispatch capability of the Julia compiler. The chosen protocol requires that one knows the type belonging to an object that is to be read in before it can actually be read in. As implemented, these JSON streams do not store type information; they only store the fields of an object of specified type, not its meta data.

These methods can handle the more common built-in types of the Julia language upon which module `PhysicalFields` is built. They are listed below.

#### Writing Instances of Built-In Types to Strings

There is a method that coverts the objects exported by this module into strings for human consumption, i.e., the method `toString.` This method can also write instances of the more common built-in types of the Julia language to string, as listed below.

For boolean-based types:
```
function toString(y::Bool; aligned::Bool=false)::String
function toString(v::Vector{Bool})::String
function toString(m::Matrix{Bool})::String
```
where parameter `aligned` is set to *true*, e.g., when typesetting a matrix, as it will add a white space in front of *true* values so that column entries align, since *true* is 4 characters and *false* is 5.

For integer-based types:
```
function toString(y::Int64; digits::Int64=0)::String
function toString(v::Vector{Int64})::String
function toString(m::Matrix{Int64})::String
```
where parameter `digits` is used, e.g., when typesetting a matrix so that all integer values span strings of length *digits*, which will produce matrix columns that align.

And for real-based types:
```
function toString(y::Float64; format::Char='E', precision::Int=5, aligned::Bool=false)::String
function toString(y::Vector{Float64}; format::Char='E')::String
function toString(y::Matrix{Float64}; format::Char='E')::String
```
whose parameters allow assignments:

* `format:` An exponential or scientific output will be written whenever `format` is set to 'e' or 'E', the latter of which is the default; otherwise, the output will be written in a fixed-point notation.
* `precision:` The number of significant figures to be used in a numeric representation, precision ∈ {3, …, 7}, with 5 being the default, i.e., all floating point numbers are truncated to aid in their visual observation.
* `aligned:` If `true,` a white space will appear before the first digit in a number whenever its value is non-negative. Aligning is useful, e.g., when stacking outputs, like when printing out a matrix as a string. The default is `false.` 

If a vector or matrix is too large, i.e., has rows that would otherwise exceed 72 characters, they will be truncated and ellipses will appear in the printed output. The arrays themselves are not altered, just their string representations.

No reciprocal method for parsing a string is included, as the intention here is to provide an interface to the user at runtime.

#### Opening and Closing JSON Files

There are also methods that write and read objects exported by this module from and/or to a file, thereby enabling their data to become persistent, viz., methods `toFile` and `fromFile.` JSON (JavaScript Object Notation) files are used for this purpose. JSON files store data in key-value pairs, and is therefore an ideal format for storing Julia `struct` types to file, too. JSON files are lightweight, text-based, human-readable, and can even be edited using a standard text editor.

To open an existing JSON file for reading, one can call
```
function openJSONReader(my_dir_path::String, my_file_name::String)::IOStream
```
e.g., `json_stream = openJSONReader("home/my_dir/", "my_file.json").` 

This reader attaches to a file located in directory `my_dir_path` whose name is `my_file_name` that is expected to end with a `.json` extension. The file is opened in read-only mode. This reader initially points to the beginning of the file.

To create a new, or open an existing JSON file for writing, one can call
```
function openJSONWriter(my_dir_path::String, my_file_name::String)::IOStream
```
e.g., `json_stream = openJSONWriter("home/my_dir/", "my_file.json").` 

This writer attaches to a file located in directory `my_dir_path` whose name is `my_file_name` that is expected to end with a `.json` extension. If this file does not exist, it will be created. The file is opened in write-create-append mode. This writer initially points to the beginning of the file, whether it already exists or is to be newly created.

To close a file to which a JSON stream is attached, one simply calls
```
function closeJSONStream(json_stream::IOStream)
```

#### Reading Instances of Built-In Types from a JSON File

To read an object belonging to a built-in Julia type from a JSON file, one can call the method `fromFile.` 

For reading in instances of the Sting type:
```
function fromFile(::Type{String}, json_stream::IOStream)::String
```
For reading in instances of the Bool type:
```
function fromFile(::Type{Bool}, json_stream::IOStream)::Bool
function fromFile(::Type{Vector{Bool}}, json_stream::IOStream)::Vector{Bool}
```
For reading in instances of the Int64 type:
```
function fromFile(::Type{Int64}, json_stream::IOStream)::Int64
function fromFile(::Type{Vector{Int64}}, json_stream::IOStream)::Vector{Int64}
```
For reading in instances of the Float64 type:
```
function fromFile(::Type{Float64}, json_stream::IOStream)::Float64
function fromFile(::Type{Vector{Float64}}, json_stream::IOStream)::Vector{Float64}
```
And for reading in instances of the Dict type:
```
function fromFile(::Type{Dict}, json_stream::IOStream)::Dict
```
where its `json_steam` comes from a call to `openJSONReader.` These are the built-in types upon which module `PhysicalFields` is built.

#### Writing Instances of Built-In Types to a JSON File

To write an object belonging to a Julia built-in type to a JSON file, one can call the method `toFile.`

For writing instances of the String type:
```
function toFile(y::String, json_stream::IOStream)
```
For writing instances of the Bool type:
```
function toFile(y::Bool, json_stream::IOStream)
function toFile(y::Vector{Bool}, json_stream::IOStream)
```
For writing instances of the Int64 type:
```
function toFile(y::Int64, json_stream::IOStream)
function toFile(y::Vector{Int64}, json_stream::IOStream)
```
For writing instances of the Float64 type:
```
function toFile(y::Float64, json_stream::IOStream)
function toFile(y::Vector{Float64}, json_stream::IOStream)
```
And for writing instances of the Dict type:
```
function toFile(y::Dict, json_stream::IOStream)
```
where its `json_stream` comes from a call to `openJSONWriter.`  These are the built-in types upon which module `PhysicalFields` is built.

All integer values are stored in JSON files as `Int64` objects, while all real values are stored as `Float64` objects.

JSON3 does not read or write arrays whose dimensional size is greater than 1. To write, e.g., an instance of type Matrix to a JSON stream, one will need to convert it to an equivalent instance of type Vector, which can then be written to file. See, for example, the implementations for reading/writing instances of types MMatrix and MArray from/to a JSON stream as illustrations of how this can be done.

[Next Page](.\README_MutableTypes.md)

## Version History

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
