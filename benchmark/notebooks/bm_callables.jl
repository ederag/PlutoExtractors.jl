### A Pluto.jl notebook ###
# v0.20.20

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

# ╔═╡ 57b17b5e-7c93-4d15-b5b9-033fd49e2998
using BenchmarkTools

# ╔═╡ 640d5a61-0e23-4614-96d7-6d79e015eee3
using PlutoExtractors

# ╔═╡ 9f58ade4-c81b-45fb-a497-4f7503b94e13
import PlutoTest

# ╔═╡ 88334e90-1486-40e2-84d5-8f49eda045fe
root_dir = pkgdir(PlutoExtractors)

# ╔═╡ d5a36c7c-95bf-4bd3-96d7-1b2392eeec94
source_nb_file = joinpath(root_dir, "test", "notebooks", "source_callables.jl")

# ╔═╡ 8411b188-54d9-43fd-9d47-6bd6d7f5ed86
md"""
# Tests
"""

# ╔═╡ e4837658-a2ef-4dfa-8cb0-f909eac426b6
md"""
## Without global
"""

# ╔═╡ 525f5fcc-efd1-48ef-8aeb-9c184e54a50d
@nb_extract(
	source_nb_file,
	function fun_1(x)
		return scaled_x
	end
)

# ╔═╡ 9cf1c8ea-6043-41cd-abdd-595ebf5254b2
PlutoTest.@test fun_1(5.0) == 15.0

# ╔═╡ b8cc866b-8dd3-434a-8ee9-f283e529490e
@benchmark fun_1(x)  setup = (x = rand())

# ╔═╡ 9768ce53-304b-4794-9de2-d09d6b39cf05
md"""
## With global
"""

# ╔═╡ 79059923-0737-40fb-80d9-5381bdece98a
@nb_extract(
	source_nb_file,
	function fun_2(x)
		return scaled_x_2
	end
)

# ╔═╡ 5e4d4b3a-aa18-425e-bc31-cf5a87d8a196
fun_2(3.0)

# ╔═╡ 2701ad20-1c64-4446-8c74-946ff3f9f9cd
@benchmark fun_2(x)  setup = (x = rand())

# ╔═╡ 5419c947-011c-449c-ba24-479d43fc6d2c
md"""
## Functions
"""

# ╔═╡ ace85006-e9c4-43c3-a004-6f2b818afd49
@nb_extract(
	source_nb_file,
	function fun_3(x)
		return fun_fun_long(x)
	end
)

# ╔═╡ ce8c6503-9475-4261-836a-61a0859b2cc6
PlutoTest.@test fun_3(3) == 27

# ╔═╡ 0316f703-5290-458c-9a6a-f8dd38578593
@benchmark fun_3(x)  setup = (x = rand())

# ╔═╡ 74986ddb-f85a-477b-b036-6a534ea65e56
@nb_extract(
	source_nb_file,
	function fun_4()
		return d
	end
)

# ╔═╡ e925b852-cf7b-4545-8bd3-5c3b0cb2fde4
PlutoTest.@test fun_4() == 64

# ╔═╡ 401f1ab9-21f6-4900-9294-0b460c996e3d
@benchmark fun_4()

# ╔═╡ f255eb1a-9fc1-4dfa-812e-faaaa42ed666
@nb_extract(
	source_nb_file,
	function fun_5()
		return fun_capt_a()
	end
)

# ╔═╡ fce2c7fb-f9be-45a7-9a46-211012ecae9d
PlutoTest.@test fun_5() == 2

# ╔═╡ 0ac829e6-d662-4774-9a62-305162ecc7c1
@benchmark fun_5()

# ╔═╡ 91f52bb6-036e-472f-98d5-8e5dedd236e6
@nb_extract(
	source_nb_file,
	function fun_6(a)
		return fun_capt_a()
	end
)

# ╔═╡ c04f2ae1-60e7-4edd-9f66-6155eb8a34d6
PlutoTest.@test fun_6(3) == 3

# ╔═╡ d4a81a85-3d4f-4a5d-a77a-cc9b0444483a
@benchmark fun_6(x)  setup = (x = rand())

# ╔═╡ 52cd299d-7e5c-4342-aedb-81a55a5253b1
@nb_extract(
	source_nb_file,
	function fun_7(b)
		return fun_capt_a_b()
	end
)

# ╔═╡ d5661bd4-6cfe-4a0f-a4a4-db60d5dd3c73
PlutoTest.@test fun_7(3) == 5

# ╔═╡ 15588f9f-909a-411d-ac71-b5ecdcdb951a
@benchmark fun_7(x)  setup = (x = rand())

# ╔═╡ 2386b27f-1c20-4884-9898-2acd57205e54
@nb_extract(
	source_nb_file,
	function fun_8(a)
		return fun_chain()
	end
)

# ╔═╡ 99e54bbc-535b-4b5e-87b6-9df5fbebb3e2
fun_8(2)

# ╔═╡ 2e593068-b7cb-4a4c-be06-cb9540ee265f
@benchmark fun_8(x)  setup = (x = rand())

# ╔═╡ Cell order:
# ╠═51df9d39-7d35-49e1-bac3-7354882bb141
# ╠═67aa154f-a294-41ce-aea5-36cf5ddcf1de
# ╠═57b17b5e-7c93-4d15-b5b9-033fd49e2998
# ╠═640d5a61-0e23-4614-96d7-6d79e015eee3
# ╠═9f58ade4-c81b-45fb-a497-4f7503b94e13
# ╠═88334e90-1486-40e2-84d5-8f49eda045fe
# ╠═d5a36c7c-95bf-4bd3-96d7-1b2392eeec94
# ╠═8411b188-54d9-43fd-9d47-6bd6d7f5ed86
# ╠═e4837658-a2ef-4dfa-8cb0-f909eac426b6
# ╠═525f5fcc-efd1-48ef-8aeb-9c184e54a50d
# ╠═9cf1c8ea-6043-41cd-abdd-595ebf5254b2
# ╠═b8cc866b-8dd3-434a-8ee9-f283e529490e
# ╠═9768ce53-304b-4794-9de2-d09d6b39cf05
# ╠═79059923-0737-40fb-80d9-5381bdece98a
# ╠═5e4d4b3a-aa18-425e-bc31-cf5a87d8a196
# ╠═2701ad20-1c64-4446-8c74-946ff3f9f9cd
# ╠═5419c947-011c-449c-ba24-479d43fc6d2c
# ╠═ace85006-e9c4-43c3-a004-6f2b818afd49
# ╠═ce8c6503-9475-4261-836a-61a0859b2cc6
# ╠═0316f703-5290-458c-9a6a-f8dd38578593
# ╠═74986ddb-f85a-477b-b036-6a534ea65e56
# ╠═e925b852-cf7b-4545-8bd3-5c3b0cb2fde4
# ╠═401f1ab9-21f6-4900-9294-0b460c996e3d
# ╠═f255eb1a-9fc1-4dfa-812e-faaaa42ed666
# ╠═fce2c7fb-f9be-45a7-9a46-211012ecae9d
# ╠═0ac829e6-d662-4774-9a62-305162ecc7c1
# ╠═91f52bb6-036e-472f-98d5-8e5dedd236e6
# ╠═c04f2ae1-60e7-4edd-9f66-6155eb8a34d6
# ╠═d4a81a85-3d4f-4a5d-a77a-cc9b0444483a
# ╠═52cd299d-7e5c-4342-aedb-81a55a5253b1
# ╠═d5661bd4-6cfe-4a0f-a4a4-db60d5dd3c73
# ╠═15588f9f-909a-411d-ac71-b5ecdcdb951a
# ╠═2386b27f-1c20-4884-9898-2acd57205e54
# ╠═99e54bbc-535b-4b5e-87b6-9df5fbebb3e2
# ╠═2e593068-b7cb-4a4c-be06-cb9540ee265f
