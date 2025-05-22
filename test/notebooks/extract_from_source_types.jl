### A Pluto.jl notebook ###
# v0.20.8

using Markdown
using InteractiveUtils

# ╔═╡ 51df9d39-7d35-49e1-bac3-7354882bb141
import Pkg

# ╔═╡ 67aa154f-a294-41ce-aea5-36cf5ddcf1de
# ╠═╡ skip_as_script = true
#=╠═╡
begin
	Pkg.activate(Base.current_project())
	using Revise  # just to be sure Revise is called first (is it necessary ?)
end
  ╠═╡ =#

# ╔═╡ 640d5a61-0e23-4614-96d7-6d79e015eee3
using PlutoExtractors

# ╔═╡ 9f58ade4-c81b-45fb-a497-4f7503b94e13
import PlutoTest

# ╔═╡ 88334e90-1486-40e2-84d5-8f49eda045fe
root_dir = pkgdir(PlutoExtractors)

# ╔═╡ d5a36c7c-95bf-4bd3-96d7-1b2392eeec94
source_nb_file = joinpath(root_dir, "test", "notebooks", "source_types.jl")

# ╔═╡ 8411b188-54d9-43fd-9d47-6bd6d7f5ed86
md"""
# Tests
"""

# ╔═╡ 53c808e9-a4bc-4fbc-b186-41532f54e7f8
md"## Types
"

# ╔═╡ f3ee4c34-3c96-4254-aa07-34d67efaedc3
utp = load_updated_topology(source_nb_file)

# ╔═╡ fafc2698-d303-4ee8-a9d1-a8a1dc523d2b
md"""
#### Copied by hand (workaround)

Types will need some special handling, as they must be toplevel
(they can't be defined inside a function).
Until then, they have to be copied by hand.
"""

# ╔═╡ 90e0bfa8-9b4c-4be0-9733-e32a7e0ca5c9
abstract type AbstractPoint end

# ╔═╡ e67c92e5-26b6-4a8a-9f07-f23e94c83dbb
struct Point{F<:Real} <: AbstractPoint
	x::F
	y::F
end

# ╔═╡ e4837658-a2ef-4dfa-8cb0-f909eac426b6
md"""
### Tests
"""

# ╔═╡ 525f5fcc-efd1-48ef-8aeb-9c184e54a50d
@nb_extract(
	utp,
	function fun_1()
		return b
	end
)

# ╔═╡ b8879c23-6aec-435a-a875-e30ebd1b4d5a
fun_1()

# ╔═╡ 9cf1c8ea-6043-41cd-abdd-595ebf5254b2
PlutoTest.@test fun_1() == 2

# ╔═╡ 6f6178c8-9c47-4ccb-a8a6-bfb6ac79d30f
md"""
### Sub/supertypes

Sensitive to [Julia#50354](https://github.com/JuliaLang/julia/issues/50354) ?
"""

# ╔═╡ 919bd4ba-6fe2-4641-b7b7-1c184f97679d
#  Can't get the module yet, so test inside the function
@nb_extract(
	utp,
	function fun_2()
		sup_match = supertype(Point) === AbstractPoint
		return sup_match
	end
)

# ╔═╡ 175535b1-9599-45e5-a428-8282f99ee50d
PlutoTest.@test fun_2() === true

# ╔═╡ Cell order:
# ╠═51df9d39-7d35-49e1-bac3-7354882bb141
# ╠═67aa154f-a294-41ce-aea5-36cf5ddcf1de
# ╠═640d5a61-0e23-4614-96d7-6d79e015eee3
# ╠═9f58ade4-c81b-45fb-a497-4f7503b94e13
# ╠═88334e90-1486-40e2-84d5-8f49eda045fe
# ╠═d5a36c7c-95bf-4bd3-96d7-1b2392eeec94
# ╠═8411b188-54d9-43fd-9d47-6bd6d7f5ed86
# ╠═53c808e9-a4bc-4fbc-b186-41532f54e7f8
# ╠═f3ee4c34-3c96-4254-aa07-34d67efaedc3
# ╠═fafc2698-d303-4ee8-a9d1-a8a1dc523d2b
# ╠═90e0bfa8-9b4c-4be0-9733-e32a7e0ca5c9
# ╠═e67c92e5-26b6-4a8a-9f07-f23e94c83dbb
# ╠═e4837658-a2ef-4dfa-8cb0-f909eac426b6
# ╠═525f5fcc-efd1-48ef-8aeb-9c184e54a50d
# ╠═b8879c23-6aec-435a-a875-e30ebd1b4d5a
# ╠═9cf1c8ea-6043-41cd-abdd-595ebf5254b2
# ╠═6f6178c8-9c47-4ccb-a8a6-bfb6ac79d30f
# ╠═919bd4ba-6fe2-4641-b7b7-1c184f97679d
# ╠═175535b1-9599-45e5-a428-8282f99ee50d
