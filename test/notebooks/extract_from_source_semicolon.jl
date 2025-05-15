### A Pluto.jl notebook ###
# v0.20.8

using Markdown
using InteractiveUtils

# ╔═╡ 64f6372a-eff1-11ec-2395-31d68eda5f3a
import Pkg

# ╔═╡ 0758f6c1-f7e0-4f9e-911a-c5d21f4b0d50
# ╠═╡ skip_as_script = true
#=╠═╡
begin
	Pkg.activate(Base.current_project())
	using Revise  # just to be sure Revise is called first (is it necessary ?)
end
  ╠═╡ =#

# ╔═╡ ca7520d3-c140-411d-b80d-c9cb03c7724d
using PlutoExtractors

# ╔═╡ 82342dfb-118c-44d4-9c94-04bd57c8faad
import PlutoDependencyExplorer as PDE

# ╔═╡ 780d2266-5ca3-413c-b354-6fb8c782bb30
import PlutoTest

# ╔═╡ becbb9c2-384a-4f8d-9200-b34f248c7aa0
EEE = PDE.ExpressionExplorerExtras

# ╔═╡ 23e9bd17-9d56-4a4d-a76c-03095b959465
root_dir = pkgdir(PlutoExtractors)

# ╔═╡ 35bab28c-477c-43dd-b339-13cfdbf2f33e
source_nb_file = joinpath(root_dir, "test", "notebooks", "source_semicolon.jl")

# ╔═╡ 89dd6ff4-2495-4bd1-96ef-8962f8041cf3
md"""
# Tests
"""

# ╔═╡ 214a48ea-1769-45c8-b113-bb17a1a766b7
md"## Just one variable"

# ╔═╡ b9e09fd4-f34a-4c72-b979-09bb1b1b57e7
utp = load_updated_topology(source_nb_file)

# ╔═╡ a8ac792a-d83b-48ea-a98b-79c43ef76c2e
@nb_extract(
	utp,
	function fun1()
		return b
	end
)

# ╔═╡ b2b5d93a-faff-4d9f-92da-40bf95efcff6
fun1_b = fun1()

# ╔═╡ 8ffeb150-6cbc-470b-947a-c094ab0bddfc
@code_typed fun1()

# ╔═╡ 4c009a24-8098-4803-9396-43598e2c382d
PlutoTest.@test fun1_b == 2

# ╔═╡ 343b1d66-2801-4c31-81f9-1c252bb4d337
md"""
# Debug
"""

# ╔═╡ 1dce7e48-e607-4d03-acdb-37010d72c758
b_cell = filter(
	c -> contains(c.code, "b ="),
	PDE.all_cells(utp)
) |> only

# ╔═╡ 0cc44f46-f5ab-45c2-a20b-1fb1d610697b
b_node = utp.nodes[b_cell]

# ╔═╡ d118c09b-d70f-4f24-be30-122a3c18abd6
# true (but should not be part of the test suite)
b_node.definitions == Set([:b])

# ╔═╡ 30f9606c-134c-4717-82d4-9b6b031116bb
b_code = utp.codes[b_cell]

# ╔═╡ af63b9bf-9deb-43c9-b9ae-65a74e7fe8e7
EEE.pretransform_pluto(b_code.parsedcode)

# ╔═╡ 1d54eab5-af3a-400d-90d8-97be0cffe35b
PlutoExtractors.nb_extractor_body(utp, given=[], outputs=[:b])

# ╔═╡ Cell order:
# ╠═64f6372a-eff1-11ec-2395-31d68eda5f3a
# ╠═0758f6c1-f7e0-4f9e-911a-c5d21f4b0d50
# ╠═82342dfb-118c-44d4-9c94-04bd57c8faad
# ╠═ca7520d3-c140-411d-b80d-c9cb03c7724d
# ╠═780d2266-5ca3-413c-b354-6fb8c782bb30
# ╠═becbb9c2-384a-4f8d-9200-b34f248c7aa0
# ╠═23e9bd17-9d56-4a4d-a76c-03095b959465
# ╠═35bab28c-477c-43dd-b339-13cfdbf2f33e
# ╟─89dd6ff4-2495-4bd1-96ef-8962f8041cf3
# ╟─214a48ea-1769-45c8-b113-bb17a1a766b7
# ╠═b9e09fd4-f34a-4c72-b979-09bb1b1b57e7
# ╠═a8ac792a-d83b-48ea-a98b-79c43ef76c2e
# ╠═b2b5d93a-faff-4d9f-92da-40bf95efcff6
# ╠═8ffeb150-6cbc-470b-947a-c094ab0bddfc
# ╠═4c009a24-8098-4803-9396-43598e2c382d
# ╠═343b1d66-2801-4c31-81f9-1c252bb4d337
# ╠═1dce7e48-e607-4d03-acdb-37010d72c758
# ╠═0cc44f46-f5ab-45c2-a20b-1fb1d610697b
# ╠═d118c09b-d70f-4f24-be30-122a3c18abd6
# ╠═30f9606c-134c-4717-82d4-9b6b031116bb
# ╠═af63b9bf-9deb-43c9-b9ae-65a74e7fe8e7
# ╠═1d54eab5-af3a-400d-90d8-97be0cffe35b
