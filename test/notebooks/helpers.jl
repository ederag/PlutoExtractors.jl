### A Pluto.jl notebook ###
# v0.20.10

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

# ╔═╡ acaf0efa-c78f-469a-b5dd-4a2c6f3cbabf
using MacroTools

# ╔═╡ 640d5a61-0e23-4614-96d7-6d79e015eee3
using PlutoExtractors

# ╔═╡ 9f58ade4-c81b-45fb-a497-4f7503b94e13
import PlutoTest

# ╔═╡ a9193549-5d53-4d13-b0c5-3648c9357afe
import PlutoDependencyExplorer as PDE

# ╔═╡ 88334e90-1486-40e2-84d5-8f49eda045fe
root_dir = pkgdir(PlutoExtractors)

# ╔═╡ d5a36c7c-95bf-4bd3-96d7-1b2392eeec94
source_nb_file = joinpath(root_dir, "test", "notebooks", "source_types.jl")

# ╔═╡ 8411b188-54d9-43fd-9d47-6bd6d7f5ed86
md"""
# Tests
"""

# ╔═╡ f3ee4c34-3c96-4254-aa07-34d67efaedc3
utp = load_updated_topology(source_nb_file)

# ╔═╡ e7ea8a83-7b0f-4479-921d-fdc9ac80218a
template = :(
	function fun_1()
		return b
	end
)

# ╔═╡ 6f45c8aa-557c-4e08-8669-40029b60497e
(
	template_dict,
	given_symbols,
	needed_symbols
) = PlutoExtractors.template_analysis(template)

# ╔═╡ 1925349c-4afc-4d28-813c-9730e724d240
# Sets have unique elements. Not sure this is mandatory, but it feels safer.
PlutoTest.@test given_symbols isa Set

# ╔═╡ 847ee1f7-0687-467a-9101-ab37c650986e
PlutoTest.@test needed_symbols isa Set

# ╔═╡ b5e5cf07-df5b-4edd-9ef1-6ab38081133d
# like `gensym(:PlutoExtractors)`, but fixed
# Safe here, since there are no evaluations in this notebook.
module_sym = Symbol("##PlutoExtractors#337")

# ╔═╡ 847893f3-a0a6-4d09-a30c-9004b833b65c
fun_wrapper_expr = PlutoExtractors.fun_wrapper(
	template_dict,
	module_sym
)

# ╔═╡ d140e98b-721b-41e4-9d2d-5cd4db1b981d
# rm_all_lines, otherwise the LineNumberNodes would create differences
expected_fun_wrapper_expr = PlutoExtractors.rm_all_lines(
	:(function fun_1(; )
		(var"##PlutoExtractors#337").fun_1(; )
	end)
)

# ╔═╡ 61ded599-db04-43a5-a01a-ebf5892eef2b
PlutoTest.@test fun_wrapper_expr == expected_fun_wrapper_expr

# ╔═╡ 94b0b7e1-0a51-4cbd-92a1-ca8db5721312
header_expr = PlutoExtractors.collect_header_expressions(utp, [])

# ╔═╡ fb850d61-5795-4424-bcd2-7ae811d98c92
tpo = PDE.topological_order(utp)

# ╔═╡ bc7ebc67-cb09-4043-9ba1-d5786b183cd3
function is_sorted_in(cells, tpo::PDE.TopologicalOrder)
	issorted(indexin(cells, tpo.runnable))
end

# ╔═╡ 1f903163-f9f1-4d11-a57f-d67c88970d1c
needed_cells = PlutoExtractors.all_needed_cells(
	utp,
	given_symbols,
	needed_symbols
)

# ╔═╡ 6f71127e-a15c-4ec9-a6b7-d7016d52e390
PlutoTest.@test is_sorted_in(needed_cells, tpo)

# ╔═╡ Cell order:
# ╠═51df9d39-7d35-49e1-bac3-7354882bb141
# ╠═67aa154f-a294-41ce-aea5-36cf5ddcf1de
# ╠═acaf0efa-c78f-469a-b5dd-4a2c6f3cbabf
# ╠═640d5a61-0e23-4614-96d7-6d79e015eee3
# ╠═9f58ade4-c81b-45fb-a497-4f7503b94e13
# ╠═a9193549-5d53-4d13-b0c5-3648c9357afe
# ╠═88334e90-1486-40e2-84d5-8f49eda045fe
# ╠═d5a36c7c-95bf-4bd3-96d7-1b2392eeec94
# ╠═8411b188-54d9-43fd-9d47-6bd6d7f5ed86
# ╠═f3ee4c34-3c96-4254-aa07-34d67efaedc3
# ╠═e7ea8a83-7b0f-4479-921d-fdc9ac80218a
# ╠═6f45c8aa-557c-4e08-8669-40029b60497e
# ╠═1925349c-4afc-4d28-813c-9730e724d240
# ╠═847ee1f7-0687-467a-9101-ab37c650986e
# ╠═b5e5cf07-df5b-4edd-9ef1-6ab38081133d
# ╠═847893f3-a0a6-4d09-a30c-9004b833b65c
# ╠═d140e98b-721b-41e4-9d2d-5cd4db1b981d
# ╠═61ded599-db04-43a5-a01a-ebf5892eef2b
# ╠═94b0b7e1-0a51-4cbd-92a1-ca8db5721312
# ╠═fb850d61-5795-4424-bcd2-7ae811d98c92
# ╠═bc7ebc67-cb09-4043-9ba1-d5786b183cd3
# ╠═1f903163-f9f1-4d11-a57f-d67c88970d1c
# ╠═6f71127e-a15c-4ec9-a6b7-d7016d52e390
