### A Pluto.jl notebook ###
# v0.20.8

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    #! format: off
    return quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
    #! format: on
end

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
source_nb_file = joinpath(root_dir, "test", "notebooks", "source_bind.jl")

# ╔═╡ 89dd6ff4-2495-4bd1-96ef-8962f8041cf3
md"""
# Tests
"""

# ╔═╡ 214a48ea-1769-45c8-b113-bb17a1a766b7
md"""
# Notebook with @bind

Pluto treats @bind special
"""

# ╔═╡ b9e09fd4-f34a-4c72-b979-09bb1b1b57e7
utp = load_updated_topology(source_nb_file)

# ╔═╡ a8ac792a-d83b-48ea-a98b-79c43ef76c2e
PlutoTest.@test_throws ["Please add `a` to the function arguments"] @nb_extract(
	utp,
	function fun1()
		return b
	end
)

# ╔═╡ c23487ba-d2e9-4665-b57f-d661b2d16a25
@nb_extract(
	utp,
	function fun2(a)
		return b
	end
)

# ╔═╡ b2b5d93a-faff-4d9f-92da-40bf95efcff6
fun2_b = fun2(4)

# ╔═╡ 84f703bd-39d4-43a0-8062-34decd68c6bc
# The given `a` is 4, and `b = 2a`
PlutoTest.@test fun2_b == 8

# ╔═╡ Cell order:
# ╠═64f6372a-eff1-11ec-2395-31d68eda5f3a
# ╠═0758f6c1-f7e0-4f9e-911a-c5d21f4b0d50
# ╠═ca7520d3-c140-411d-b80d-c9cb03c7724d
# ╠═780d2266-5ca3-413c-b354-6fb8c782bb30
# ╠═23e9bd17-9d56-4a4d-a76c-03095b959465
# ╠═35bab28c-477c-43dd-b339-13cfdbf2f33e
# ╟─89dd6ff4-2495-4bd1-96ef-8962f8041cf3
# ╠═214a48ea-1769-45c8-b113-bb17a1a766b7
# ╠═b9e09fd4-f34a-4c72-b979-09bb1b1b57e7
# ╠═a8ac792a-d83b-48ea-a98b-79c43ef76c2e
# ╠═c23487ba-d2e9-4665-b57f-d661b2d16a25
# ╠═b2b5d93a-faff-4d9f-92da-40bf95efcff6
# ╠═84f703bd-39d4-43a0-8062-34decd68c6bc
