### A Pluto.jl notebook ###
# v0.20.20

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
source_path = joinpath(root_dir, "test", "notebooks", "source_comments.jl")

# ╔═╡ 89dd6ff4-2495-4bd1-96ef-8962f8041cf3
md"""
# Tests
"""

# ╔═╡ 214a48ea-1769-45c8-b113-bb17a1a766b7
md"## Just one variable"

# ╔═╡ 2dff3de8-3643-4e30-8c18-5dbc54c123fd
VERSION

# ╔═╡ b9e09fd4-f34a-4c72-b979-09bb1b1b57e7
if VERSION > v"1.12"
	PlutoTest.@test_broken load_updated_topology(source_path)
else
	utp = load_updated_topology(source_path)
	@nb_extract(
		source_path,
		function fun1()
			return a
		end
	)
	PlutoTest.@test fun1() == 1

	@nb_extract(
		source_path,
		function fun2()
			return b
		end
	)
	# b definition is commented out, so
	PlutoTest.@test_throws UndefVarError(:b) fun2() == 2
end

# ╔═╡ 2a62a946-1ca4-486a-a0b3-bbf9b251c373


# ╔═╡ 343b1d66-2801-4c31-81f9-1c252bb4d337
md"""
# Debug
"""

# ╔═╡ 3570c682-0461-4908-b908-f0bc2cb4a1b4
# ╠═╡ skip_as_script = true
#=╠═╡
load_updated_topology(source_path,
	get_code_expr = c -> (@debug(c.code); Meta.parse(c.code))
)
  ╠═╡ =#

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
# ╠═2dff3de8-3643-4e30-8c18-5dbc54c123fd
# ╠═b9e09fd4-f34a-4c72-b979-09bb1b1b57e7
# ╠═2a62a946-1ca4-486a-a0b3-bbf9b251c373
# ╠═343b1d66-2801-4c31-81f9-1c252bb4d337
# ╠═3570c682-0461-4908-b908-f0bc2cb4a1b4
