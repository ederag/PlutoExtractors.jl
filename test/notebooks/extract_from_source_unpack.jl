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

# ╔═╡ ef466826-81b7-4f9d-a0e8-f48f0dc63d2f
using Parameters  # until #11 is fixed

# ╔═╡ 640d5a61-0e23-4614-96d7-6d79e015eee3
using PlutoExtractors

# ╔═╡ 63066171-c4e6-46e6-8e63-eb50f6c70ed1
using LinearAlgebra: dot  # `dot` is needed for the test

# ╔═╡ 5d55d8df-ba97-4ebc-9d96-35ff9cd11bd4
import PlutoDependencyExplorer as PDE

# ╔═╡ 9f58ade4-c81b-45fb-a497-4f7503b94e13
import PlutoTest

# ╔═╡ 6fc87b31-9206-4ccc-87a6-ad37b0d25415
EEE = PDE.ExpressionExplorerExtras

# ╔═╡ 88334e90-1486-40e2-84d5-8f49eda045fe
root_dir = pkgdir(PlutoExtractors)

# ╔═╡ d5a36c7c-95bf-4bd3-96d7-1b2392eeec94
source_nb_file = joinpath(root_dir, "test", "notebooks", "source_unpack.jl")

# ╔═╡ f3ee4c34-3c96-4254-aa07-34d67efaedc3
utp = load_updated_topology(source_nb_file)

# ╔═╡ 155b072a-d32f-4062-ad4e-1ab9792614ae
typeof(utp.codes)

# ╔═╡ 8411b188-54d9-43fd-9d47-6bd6d7f5ed86
md"""
# Tests
"""

# ╔═╡ 53c808e9-a4bc-4fbc-b186-41532f54e7f8
md"## Regular

`a` and `c` are defined through `@unpack` in the source file
"

# ╔═╡ 21f86448-721a-4ffe-a098-1482071de585
@nb_extract(
	utp,
	function fun1()
		return a, c
	end
)

# ╔═╡ 737782bb-ea44-41b4-b467-da42793fd616
PlutoTest.@test fun1() == (1, 3)

# ╔═╡ d3341aee-be88-4f4c-a25b-7f2342a98591
md"""
## Debug
"""

# ╔═╡ 198d4900-9ae1-456f-b1cf-3c26a2d8249a
unpack_ac_cell = filter(
	c -> contains(c.code, "@unpack a, c ="),
	PDE.all_cells(utp)
) |> only

# ╔═╡ 1f19f8ec-46e5-48d7-a557-15db25bc12ff
unpack_ac_node = utp.nodes[unpack_ac_cell]

# ╔═╡ d011ab60-c791-43e4-babc-675be0a8b709
# true (but should not be part of the test suite)
unpack_ac_node.definitions == Set([:a, :c])

# ╔═╡ 79d78476-d048-4b1a-8e55-5c978697bff8
unpack_ac_code = utp.codes[unpack_ac_cell]

# ╔═╡ bde5735f-1fd0-4298-8e12-5fd4eced5b48
EEE.pretransform_pluto(unpack_ac_code.parsedcode)

# ╔═╡ Cell order:
# ╠═51df9d39-7d35-49e1-bac3-7354882bb141
# ╠═67aa154f-a294-41ce-aea5-36cf5ddcf1de
# ╠═ef466826-81b7-4f9d-a0e8-f48f0dc63d2f
# ╠═5d55d8df-ba97-4ebc-9d96-35ff9cd11bd4
# ╠═640d5a61-0e23-4614-96d7-6d79e015eee3
# ╠═9f58ade4-c81b-45fb-a497-4f7503b94e13
# ╠═63066171-c4e6-46e6-8e63-eb50f6c70ed1
# ╠═6fc87b31-9206-4ccc-87a6-ad37b0d25415
# ╠═88334e90-1486-40e2-84d5-8f49eda045fe
# ╠═d5a36c7c-95bf-4bd3-96d7-1b2392eeec94
# ╠═f3ee4c34-3c96-4254-aa07-34d67efaedc3
# ╠═155b072a-d32f-4062-ad4e-1ab9792614ae
# ╠═8411b188-54d9-43fd-9d47-6bd6d7f5ed86
# ╠═53c808e9-a4bc-4fbc-b186-41532f54e7f8
# ╠═21f86448-721a-4ffe-a098-1482071de585
# ╠═737782bb-ea44-41b4-b467-da42793fd616
# ╠═d3341aee-be88-4f4c-a25b-7f2342a98591
# ╠═198d4900-9ae1-456f-b1cf-3c26a2d8249a
# ╠═1f19f8ec-46e5-48d7-a557-15db25bc12ff
# ╠═d011ab60-c791-43e4-babc-675be0a8b709
# ╠═79d78476-d048-4b1a-8e55-5c978697bff8
# ╠═bde5735f-1fd0-4298-8e12-5fd4eced5b48
