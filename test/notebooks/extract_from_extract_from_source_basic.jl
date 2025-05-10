### A Pluto.jl notebook ###
# v0.19.22

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

# ╔═╡ 780d2266-5ca3-413c-b354-6fb8c782bb30
import PlutoTest

# ╔═╡ 23e9bd17-9d56-4a4d-a76c-03095b959465
root_dir = pkgdir(PlutoExtractors)

# ╔═╡ 35bab28c-477c-43dd-b339-13cfdbf2f33e
source_nb_file = joinpath(root_dir, "test", "notebooks", "extract_from_source_basic.jl")

# ╔═╡ 89dd6ff4-2495-4bd1-96ef-8962f8041cf3
md"""
# Tests
"""

# ╔═╡ 214a48ea-1769-45c8-b113-bb17a1a766b7
md"## Just one variable"

# ╔═╡ b9e09fd4-f34a-4c72-b979-09bb1b1b57e7
nb = load_nb_with_topology(source_nb_file)

# ╔═╡ a8ac792a-d83b-48ea-a98b-79c43ef76c2e
@nb_extract(
	nb,
	function get_fun1_a()
		return fun1_a
	end
)

# ╔═╡ f49f8d22-2b0b-4884-b9be-368dd297fb34
get_fun1_a()

# ╔═╡ b2b5d93a-faff-4d9f-92da-40bf95efcff6
# fun1_a = Base.@invokelatest get_fun1_a()
fun1_a = get_fun1_a()

# ╔═╡ 4c009a24-8098-4803-9396-43598e2c382d
PlutoTest.@test fun1_a == 1

# ╔═╡ Cell order:
# ╠═64f6372a-eff1-11ec-2395-31d68eda5f3a
# ╠═0758f6c1-f7e0-4f9e-911a-c5d21f4b0d50
# ╠═ca7520d3-c140-411d-b80d-c9cb03c7724d
# ╠═780d2266-5ca3-413c-b354-6fb8c782bb30
# ╠═23e9bd17-9d56-4a4d-a76c-03095b959465
# ╠═35bab28c-477c-43dd-b339-13cfdbf2f33e
# ╟─89dd6ff4-2495-4bd1-96ef-8962f8041cf3
# ╟─214a48ea-1769-45c8-b113-bb17a1a766b7
# ╠═b9e09fd4-f34a-4c72-b979-09bb1b1b57e7
# ╠═a8ac792a-d83b-48ea-a98b-79c43ef76c2e
# ╠═f49f8d22-2b0b-4884-b9be-368dd297fb34
# ╠═b2b5d93a-faff-4d9f-92da-40bf95efcff6
# ╠═4c009a24-8098-4803-9396-43598e2c382d
