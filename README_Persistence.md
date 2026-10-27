
[Return to Main Document](./README.md)

# Persistence

The ability to write an object to either a string or a file, plus the ability to read that object back in from a file. 

## toString

Method `toString` provides nicely formatted string representations for those builtin types that are sub-types to abstract types `Real`, `Vector{<:Real}` and `Matrix{<:Real}`. These need not be exact representations, because their intention is for displaying results in the **REPL**, etc., as a means of informing the user during a runtime. (Exact representations are often too lengthy, but can be gotten from the core method `string.)` Ellipses may appear in vector and matrix representations if their size is otherwise too large to fit onto a line or a printed page, respectively.

The primitive or concrete sub-types to abstract type `Integer` are: `Bool, Int8, Int16, Int32, Int64, Int128, UInt8, UInt16, UInt32, UInt64` and `UInt128,` while the primitive sub-types to abstract type `AbstractFloat` are: `Float16, Float32` and `Float64.` A call to method `toString` will convert any instance for any of these primitive types into a string, including vectors and matrices of these types.

For values:
```julia
    s = toString(y::Bool)::String
    s = toString(y::Integer)::String
    s = toString(y::AbstractFloat)::String
```
for vectors of values:
```julia
    s = toString(v::Vector{Bool})::String
    s = toString(v::Vector{<:Integer})::String
    s = toString(v::Vector{<:AbstractFloat})::String
```
and for matrices of values:
```julia
    s = toString(m::Matrix{Bool})::String
    s = toString(m::Matrix{<:Integer})::String
    s = toString(m::Matrix{<:AbstractFloat})::String
```

No reciprocal method for parsing a string is included, viz., there is no `fromString,` as the intention here is to provide a visual interface to the user at runtime. One could call `JSON.parse` as a workaround, if needed.

## Opening and Closing JSON Files

There are methods that write and read objects to and/or from a file that are exported by this module, thereby enabling their data to become persistent, viz., methods `toFile` and `fromFile.` JSON (JavaScript Object Notation) files are used for this purpose; specifically, the `JSON3.jl` module is used. JSON files store data in key-value pairs, which is an ideal format for storing objects of `Julia's` composite `struct` types to file, too. JSON files are lightweight, text-based, human-readable, and can even be edited using a standard text editor.

To open an existing JSON file for reading, one can call
```
function openJSONReader(my_dir_path::String, my_file_name::String)::IOStream
```
e.g., `json_stream = openJSONReader("home/my_dir/", "my_file.json").` 

This reader attaches to a file located in directory `my_dir_path` whose name is `my_file_name,` which is expected to end with a `.json` extension. The file is opened in read-only mode. This reader initially points to the beginning of the file.

To create a new, or open an existing JSON file for writing, one can call
```
function openJSONWriter(my_dir_path::String, my_file_name::String)::IOStream
```
e.g., `json_stream = openJSONWriter("home/my_dir/", "my_file.json").` 

This writer attaches to a file located in directory `my_dir_path` whose name is `my_file_name,` which is expected to end with a `.json` extension. If this directory and/or file does not exist, they will be created. The file is opened in write-create-append mode. This writer initially points to the beginning of the file, whether it already exists or is to be newly created.

To close a file to which a JSON stream is attached, one simply calls
```
function closeJSONStream(json_stream::IOStream)
```

### Writing Instances of Built-In Types to a JSON File

To write an object belonging to a built-in Julia type into a JSON file, one can call method `toFile.` The parametric type structure implemented in the `Julia` language allows for a very simple interface here.

Calls to this method can satisfy one of the following interfaces:
```julia
    toFile(y::String, json_stream::IOStream)
    toFile(y::Dict, json_stream::IOStream)
    toFile(y::Real, json_stream::IOStream)
    toFile(y::Vector{<:Real}, json_stream::IOStream)
```
where methods `openJSONReader`, `openJSONWriter` and `closeJSONStream` can be called upon to open and close the `IOStream` that is a `json_stream`.

The primitive types that implement abstract type `Real` are: `Bool, Int8, Int16, Int32, Int64, Int128, UInt8, UInt16, UInt32, UInt64, UInt128, Float16, Float32` and `Float64.`

All primitive types of `Real` are handled by method `toFile(y::Real, json_stream::IOStream)`, e.g., `toFile(true, json_stream)` writes boolean `true` to file, while `toFile(1, json_stream)` writes integer `1` to file as an instance of type `Int;` likewise, vectors of these primative types are handled by method `toFile(y::Vector{<:Real}, json_stream::IOStream)`.

Information establishing the primitive type of an object being stored to file is written along with its value, so that when read back in from file the restored value will be assigned the actual type of the value that was originally saved to file. The *lazy* feature of `JSON3` is not adhered to here.

### Reading Instances of Built-In Types from a JSON File

To read an object belonging to a built-in Julia type from a JSON file, one can call method `fromFile.` The parametric type structure implemented in the `Julia` language allows for a very simple interface here.

Calls to this method can satisfy one of the following interfaces. For strings and dictionaries:
```julia
    s = fromFile(::Type{String}, json_stream::IOStream)::String
    d = fromFile(::Type{Dict},   json_stream::IOStream)::Dict
```
for instances of abstract type `<:Real:`
```julia
    b = fromFile(::Type{Bool},    json_stream::IOStream)::Bool
    i = fromFile(::Type{Int8},    json_stream::IOStream)::Int8
    ⋮
    i = fromFile(::Type{Int128},  json_stream::IOStream)::Int128
    i = fromFile(::Type{UInt8},   json_stream::IOStream)::UInt8
    ⋮
    i = fromFile(::Type{UInt128}, json_stream::IOStream)::UInt128
    x = fromFile(::Type{Float16}, json_stream::IOStream)::Float16
    x = fromFile(::Type{Float32}, json_stream::IOStream)::Float32
    x = fromFile(::Type{Float64}, json_stream::IOStream)::Float64
```
and for instances of abstract type `<:Vector{<:Real}:`
```julia
    b = fromFile(::Type{Vector{Bool}},    json_stream::IOStream)::Vector{Bool}
    i = fromFile(::Type{Vector{Int8}},    json_stream::IOStream)::Vector{Int8}
    ⋮
    i = fromFile(::Type{Vector{Int128}},  json_stream::IOStream)::Vector{Int128}
    i = fromFile(::Type{Vector{UInt8}},   json_stream::IOStream)::Vector{UInt8}
    ⋮
    i = fromFile(::Type{Vector{UInt128}}, json_stream::IOStream)::Vector{UInt128}
    x = fromFile(::Type{Vector{Float16}}, json_stream::IOStream)::Vector{Float16}
    x = fromFile(::Type{Vector{Float32}}, json_stream::IOStream)::Vector{Float32}
    x = fromFile(::Type{Vector{Float64}}, json_stream::IOStream)::Vector{Float64}
```
where the Lazy printing strategy of the `JSON` package requires calls to `fromFile` to provide the precise type of the built-in field supplied to `toFile` in order to return the correct field.

Methods `openJSONReader`, `openJSONWriter` and `closeJSONStream` can be called upon to open and close an `IOStream` that is `json_stream`.

All primitive types of abstract type `Real` (viz., `Bool,` `Int8,` `Int16,` `Int32,` `Int64,` `Int128,` `UInt8,` `UInt16,` `UInt32,` `UInt64,` `UInt128,` `Float16,` `Float32` and `Float64)` can be handled. 

Objects that are matrices and higher-order arrays are stored to file in a column vector format in this module, which are then reshaped into their correct array structures when read back in from file.

[Prev Page](./README.md)
[Next Page](./README_MutableTypes.md)

