### A Pluto.jl notebook ###
# v0.19.9

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
using PlutoExtracters

# ╔═╡ 780d2266-5ca3-413c-b354-6fb8c782bb30
import PlutoTest

# ╔═╡ 23e9bd17-9d56-4a4d-a76c-03095b959465
root_dir = pkgdir(PlutoExtracters)

# ╔═╡ 35bab28c-477c-43dd-b339-13cfdbf2f33e
source_nb_file = joinpath(root_dir, "test", "notebooks", "source_basic.jl")

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
	function fun_out_a()
		return a
	end
)

# ╔═╡ b2b5d93a-faff-4d9f-92da-40bf95efcff6
fun_out_a()

# ╔═╡ 4c009a24-8098-4803-9396-43598e2c382d
PlutoTest.@test fun_out_a() == 1

# ╔═╡ 4bb38b42-207f-4219-b1eb-3ca9a0c792d1
md"""
## Named tuple output
"""

# ╔═╡ aada1eb9-5887-4c4f-a796-45217ff8ece7
@nb_extract(
	nb,
	function fun_out_nt_a_c()
		return (; a = a, c = c)
	end
)

# ╔═╡ 00c3138b-e775-4873-954f-787cec13ec41
fun_out_nt_a_c()

# ╔═╡ df373231-1b35-4838-bbfc-8ecb564e0bb1
PlutoTest.@test fun_out_nt_a_c() == (; a = 1, c = 4)

# ╔═╡ d5d0a2d5-233e-4896-9afa-e34dbf78318c
md"""
## One input
"""

# ╔═╡ abfcb9bd-8c20-47a9-9f1c-12e75426d6df
@nb_extract(
	nb,
	function fun_a_out_nt_b_c(a)
		return (; b = b, c = c)
	end
)

# ╔═╡ 8adbfdd7-a8bb-48a0-bbfa-8a66d80d45da
fun_a_out_nt_b_c(2)

# ╔═╡ aba92ba2-cd8d-4f87-ad81-892dceed3aa6
PlutoTest.@test fun_a_out_nt_b_c(2) == (; b = 4, c = 8)

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
# ╠═b2b5d93a-faff-4d9f-92da-40bf95efcff6
# ╠═4c009a24-8098-4803-9396-43598e2c382d
# ╟─4bb38b42-207f-4219-b1eb-3ca9a0c792d1
# ╠═aada1eb9-5887-4c4f-a796-45217ff8ece7
# ╠═00c3138b-e775-4873-954f-787cec13ec41
# ╠═df373231-1b35-4838-bbfc-8ecb564e0bb1
# ╠═d5d0a2d5-233e-4896-9afa-e34dbf78318c
# ╠═abfcb9bd-8c20-47a9-9f1c-12e75426d6df
# ╠═8adbfdd7-a8bb-48a0-bbfa-8a66d80d45da
# ╠═aba92ba2-cd8d-4f87-ad81-892dceed3aa6
