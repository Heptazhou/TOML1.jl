# TOML

TOML.jl is a Julia standard library for parsing and writing [TOML
v1.0](https://toml.io/en/) files.

## Parsing TOML data

```jldoctest
julia> using TOML1

julia> data = """
           [database]
           server = "192.168.1.1"
           ports = [ 8001, 8001, 8002 ]
       """;

julia> TOML1.parse(data)
Dict{String, Any} with 1 entry:
  "database" => Dict{String, Any}("server"=>"192.168.1.1", "ports"=>[8001, 8001…
```

To parse a file, use [`TOML1.parsefile`](@ref). If the file has a syntax error,
an exception is thrown:

```jldoctest
julia> using TOML1

julia> TOML1.parse("""
           value = 0.0.0
       """)
ERROR: TOML Parser error:
none:1:16 error: failed to parse value
      value = 0.0.0
                 ^
[...]
```

There are other versions of the parse functions ([`TOML1.tryparse`](@ref)
and [`TOML1.tryparsefile`](@ref)) that instead of throwing exceptions on parser error
returns a [`TOML1.ParserError`](@ref) with information:

```jldoctest
julia> using TOML1

julia> err = TOML1.tryparse("""
           value = 0.0.0
       """);

julia> err.type
ErrGenericValueError::ErrorType = 14

julia> err.line
1

julia> err.column
16
```


## Exporting data to TOML file

The [`TOML1.print`](@ref) function is used to print (or serialize) data into TOML
format.

```jldoctest
julia> using TOML1

julia> data = Dict(
          "names" => ["Julia", "Julio"],
          "age" => [10, 20],
       );

julia> TOML1.print(data)
names = ["Julia", "Julio"]
age = [10, 20]

julia> fname = tempname();

julia> open(fname, "w") do io
           TOML1.print(io, data)
       end

julia> TOML1.parsefile(fname)
Dict{String, Any} with 2 entries:
  "names" => ["Julia", "Julio"]
  "age"   => [10, 20]
```

Keys can be sorted according to some value

```jldoctest
julia> using TOML1

julia> TOML1.print(Dict(
       "abc"  => 1,
       "ab"   => 2,
       "abcd" => 3,
       ); sorted=true, by=length)
ab = 2
abc = 1
abcd = 3
```

For custom structs, pass a function that converts the struct to a supported
type

```jldoctest
julia> using TOML1

julia> struct MyStruct
           a::Int
           b::String
       end

julia> TOML1.print(Dict("foo" => MyStruct(5, "bar"))) do x
           x isa MyStruct && return [x.a, x.b]
           error("unhandled type $(typeof(x))")
       end
foo = [5, "bar"]
```


## References
```@docs
TOML1.parse
TOML1.parsefile
TOML1.tryparse
TOML1.tryparsefile
TOML1.print
TOML1.Parser
TOML1.ParserError
```
