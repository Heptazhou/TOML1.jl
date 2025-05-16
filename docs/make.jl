# This file is a part of Julia. License is MIT: https://julialang.org/license

using Documenter
using TOML1: TOML1

makedocs(
	modules = [TOML1],
	sitename = "TOML1",
	checkdocs = :strict,
	doctest = true,
	pages = [
		"TOML1" => "index.md",
	],
)

deploydocs(repo = "github.com/Heptazhou/TOML1.jl.git")
