# This file is a part of Julia. License is MIT: https://julialang.org/license

using Test
import TOML1: tryparsefile

# These tests need to be updated if the error strings change

tmp = tempname()

@testset "error printing" begin

	# Special printing for invalid bare key character
	write(tmp, "fooα = 3")
	p = tryparsefile(tmp)
	err = sprint(Base.showerror, p)
	@test contains(err,
		"""$tmp:1:4 error: invalid bare key character: 'α'\n  fooα = 3\n     ^""")

	# Error is at EOF
	write(tmp, "foo = [1, 2,")
	p = tryparsefile(tmp)
	err = sprint(Base.showerror, p)
	@test contains(err,
		"""$tmp:1:12 error: unexpected end of file, expected a value\n  foo = [1, 2,\n              ^""")
	# A bit of unicode
	write(tmp, "\"fαβ\" = [1.2, 1.2.3]")
	p = tryparsefile(tmp)
	err = sprint(Base.showerror, p)
	@test contains(err,
		"""$tmp:1:18 error: failed to parse value\n  "fαβ" = [1.2, 1.2.3]\n                   ^""")

end # testset
