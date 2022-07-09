### A Pluto.jl notebook ###
# v0.19.9

using Markdown
using InteractiveUtils

# ╔═╡ 51df9d39-7d35-49e1-bac3-7354882bb141
import Pkg

# ╔═╡ 67aa154f-a294-41ce-aea5-36cf5ddcf1de
begin
	Pkg.activate(Base.current_project())
	using Revise  # just to be sure Revise is called first (is it necessary ?)
end

# ╔═╡ 640d5a61-0e23-4614-96d7-6d79e015eee3
using PlutoExtractors

# ╔═╡ 63066171-c4e6-46e6-8e63-eb50f6c70ed1
using LinearAlgebra: dot  # `dot` is needed for the test

# ╔═╡ 9f58ade4-c81b-45fb-a497-4f7503b94e13
import PlutoTest

# ╔═╡ 88334e90-1486-40e2-84d5-8f49eda045fe
root_dir = pkgdir(PlutoExtractors)

# ╔═╡ d5a36c7c-95bf-4bd3-96d7-1b2392eeec94
source_nb_file = joinpath(root_dir, "test", "notebooks", "source_usings.jl")

# ╔═╡ 8411b188-54d9-43fd-9d47-6bd6d7f5ed86
md"""
# Tests
"""

# ╔═╡ 53c808e9-a4bc-4fbc-b186-41532f54e7f8
md"## Just one variable"

# ╔═╡ f3ee4c34-3c96-4254-aa07-34d67efaedc3
nb = load_nb_with_topology(source_nb_file)

# ╔═╡ 525f5fcc-efd1-48ef-8aeb-9c184e54a50d
@nb_extract(
	nb,
	function fun_out_d_direct()
		return d_direct
	end
)

# ╔═╡ b8879c23-6aec-435a-a875-e30ebd1b4d5a
fun_out_d_direct()

# ╔═╡ 9cf1c8ea-6043-41cd-abdd-595ebf5254b2
PlutoTest.@test fun_out_d_direct() == 1

# ╔═╡ 58fd5a19-e13b-4ad5-aa20-d0665d42ca53


# ╔═╡ 32fce284-5a7b-497c-afaa-f52064d79d53
md"## Indirect with two inputs"

# ╔═╡ 75b6aae9-e013-4b6c-ac88-721e77822c97
@nb_extract(
	nb,
	function fun_v1_v2_out_d_indirect(v1, v2)
		return d_indirect
	end
)

# ╔═╡ e72e4973-e654-4901-81b8-11c935f53531
v1 = [2, 0, 4]

# ╔═╡ 24f70698-dd49-49e4-822b-92f6dfe2d026
v2 = [4, 0, 2]

# ╔═╡ e9486860-ca1c-4e1b-8044-d164a34da234
fun_v1_v2_out_d_indirect(v1, v2)

# ╔═╡ 83f08626-cd31-45b1-8b4e-dba7c40e4bf2
expected_v1_v2_out_d_indirect = dot(v1, v2)

# ╔═╡ 03542919-9804-485d-9be1-418ad3e88ac3
PlutoTest.@test fun_v1_v2_out_d_indirect(v1, v2) == expected_v1_v2_out_d_indirect

# ╔═╡ Cell order:
# ╠═51df9d39-7d35-49e1-bac3-7354882bb141
# ╠═67aa154f-a294-41ce-aea5-36cf5ddcf1de
# ╠═640d5a61-0e23-4614-96d7-6d79e015eee3
# ╠═9f58ade4-c81b-45fb-a497-4f7503b94e13
# ╠═63066171-c4e6-46e6-8e63-eb50f6c70ed1
# ╠═88334e90-1486-40e2-84d5-8f49eda045fe
# ╠═d5a36c7c-95bf-4bd3-96d7-1b2392eeec94
# ╠═8411b188-54d9-43fd-9d47-6bd6d7f5ed86
# ╠═53c808e9-a4bc-4fbc-b186-41532f54e7f8
# ╠═f3ee4c34-3c96-4254-aa07-34d67efaedc3
# ╠═525f5fcc-efd1-48ef-8aeb-9c184e54a50d
# ╠═b8879c23-6aec-435a-a875-e30ebd1b4d5a
# ╠═9cf1c8ea-6043-41cd-abdd-595ebf5254b2
# ╠═58fd5a19-e13b-4ad5-aa20-d0665d42ca53
# ╠═32fce284-5a7b-497c-afaa-f52064d79d53
# ╠═75b6aae9-e013-4b6c-ac88-721e77822c97
# ╠═e9486860-ca1c-4e1b-8044-d164a34da234
# ╠═e72e4973-e654-4901-81b8-11c935f53531
# ╠═24f70698-dd49-49e4-822b-92f6dfe2d026
# ╠═83f08626-cd31-45b1-8b4e-dba7c40e4bf2
# ╠═03542919-9804-485d-9be1-418ad3e88ac3
