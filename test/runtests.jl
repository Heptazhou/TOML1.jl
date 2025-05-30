# This file is a part of Julia. License is MIT: https://julialang.org/license

using Test
using Dates

using Base: IdSet
using Exts
using TOML1: TOML1 as TOML, parse, tryparse, ParserError, Internals, print

function roundtrip(data)
	mktemp() do file, io
		data_parsed = TOML.parse(data)
		TOML.print(io, data_parsed)
		close(io)
		data_roundtrip = TOML.parsefile(file)
		return isequal(data_parsed, data_roundtrip)
	end
end

include("readme.jl")
include("utils/utils.jl")
include("toml_test.jl")
include("values.jl")
include("invalids.jl")
include("error_printing.jl")
include("print.jl")
include("parse.jl")

@inferred TOML.parse("foo = 3")

@testset "Docstrings" begin
	@test isempty(Docs.undocumented_names(TOML)) skip = VERSION ≤ v"1.11-0"
end
