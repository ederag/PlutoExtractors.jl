### A Pluto.jl notebook ###
# v0.19.18

using Markdown
using InteractiveUtils

# ╔═╡ 51df9d39-7d35-49e1-bac3-7354882bb141
import Pkg

# ╔═╡ 67aa154f-a294-41ce-aea5-36cf5ddcf1de
begin
	Pkg.activate(Base.current_project())
	using Revise  # just to be sure Revise is called first (is it necessary ?)
end

# ╔═╡ ef466826-81b7-4f9d-a0e8-f48f0dc63d2f
using Parameters  # until #11 is fixed

# ╔═╡ 640d5a61-0e23-4614-96d7-6d79e015eee3
using PlutoExtractors

# ╔═╡ 63066171-c4e6-46e6-8e63-eb50f6c70ed1
using LinearAlgebra: dot  # `dot` is needed for the test

# ╔═╡ 9f58ade4-c81b-45fb-a497-4f7503b94e13
import PlutoTest

# ╔═╡ 88334e90-1486-40e2-84d5-8f49eda045fe
root_dir = pkgdir(PlutoExtractors)

# ╔═╡ d5a36c7c-95bf-4bd3-96d7-1b2392eeec94
source_nb_file = joinpath(root_dir, "test", "notebooks", "source_unpack.jl")

# ╔═╡ f3ee4c34-3c96-4254-aa07-34d67efaedc3
nb = load_nb_with_topology(source_nb_file)

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
	nb,
	function fun1()
		return a, c
	end
)

# ╔═╡ 737782bb-ea44-41b4-b467-da42793fd616
PlutoTest.@test fun1() == (1, 3)

# ╔═╡ b8bb2593-70f3-4131-9f6c-a5ed559a80b9
md"""
## Workaround

`k` is first defined through a dummy assignment, and then through `@unpack`,
in the same cell.

This way a `k` definition is reckognized.
The subsequent failure occurs because `using Parameters` is not extracted yet.
"""

# ╔═╡ 525f5fcc-efd1-48ef-8aeb-9c184e54a50d
@nb_extract(
	nb,
	function fun2()
		return k
	end
)

# ╔═╡ b8879c23-6aec-435a-a875-e30ebd1b4d5a
fun1()

# ╔═╡ 9cf1c8ea-6043-41cd-abdd-595ebf5254b2
PlutoTest.@test fun2() == 11

# ╔═╡ 58fd5a19-e13b-4ad5-aa20-d0665d42ca53
PlutoExtractors.nb_extractor_body(nb; given=[], outputs=[:a])

# ╔═╡ 75bf02ea-251e-453a-a8f5-8b235fcd7cd1
PlutoExtractors.find_definition_cells(nb, [:a])

# ╔═╡ 8b8411aa-1aec-4ffb-940d-b987cb0396ec
unpack_cell = filter(c -> contains(c.code, "@unpack"), nb.cells) |> last

# ╔═╡ e71767af-fc31-4710-9dc6-b7caa4954156
nb.topology.nodes[unpack_cell].definitions

# ╔═╡ 37faddba-2ebf-41dc-8d0d-e762257ad3d8
nb.topology.nodes[unpack_cell].soft_definitions

# ╔═╡ 008899b8-4950-4994-88e2-6165ac12321f
nb.topology.nodes[unpack_cell].macrocalls

# ╔═╡ Cell order:
# ╠═51df9d39-7d35-49e1-bac3-7354882bb141
# ╠═67aa154f-a294-41ce-aea5-36cf5ddcf1de
# ╠═ef466826-81b7-4f9d-a0e8-f48f0dc63d2f
# ╠═640d5a61-0e23-4614-96d7-6d79e015eee3
# ╠═9f58ade4-c81b-45fb-a497-4f7503b94e13
# ╠═63066171-c4e6-46e6-8e63-eb50f6c70ed1
# ╠═88334e90-1486-40e2-84d5-8f49eda045fe
# ╠═d5a36c7c-95bf-4bd3-96d7-1b2392eeec94
# ╠═f3ee4c34-3c96-4254-aa07-34d67efaedc3
# ╠═8411b188-54d9-43fd-9d47-6bd6d7f5ed86
# ╠═53c808e9-a4bc-4fbc-b186-41532f54e7f8
# ╠═21f86448-721a-4ffe-a098-1482071de585
# ╠═737782bb-ea44-41b4-b467-da42793fd616
# ╠═b8bb2593-70f3-4131-9f6c-a5ed559a80b9
# ╠═525f5fcc-efd1-48ef-8aeb-9c184e54a50d
# ╠═b8879c23-6aec-435a-a875-e30ebd1b4d5a
# ╠═9cf1c8ea-6043-41cd-abdd-595ebf5254b2
# ╠═58fd5a19-e13b-4ad5-aa20-d0665d42ca53
# ╠═75bf02ea-251e-453a-a8f5-8b235fcd7cd1
# ╠═8b8411aa-1aec-4ffb-940d-b987cb0396ec
# ╠═e71767af-fc31-4710-9dc6-b7caa4954156
# ╠═37faddba-2ebf-41dc-8d0d-e762257ad3d8
# ╠═008899b8-4950-4994-88e2-6165ac12321f
