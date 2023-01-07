### A Pluto.jl notebook ###
# v0.19.18

using Markdown
using InteractiveUtils

# ╔═╡ eb7ecdc0-f6bb-403d-b46d-cb5a30266883
import Pkg

# ╔═╡ 49edca48-fd27-41b7-8bb3-c50fcdfd33fb
begin
	Pkg.activate(Base.current_project())
	using Revise  # just to be sure Revise is called first (is it necessary ?)
end

# ╔═╡ 0b7dcaf9-d9fc-4486-9e83-1d37936b02dd
using PlutoExtractors

# ╔═╡ ebc1d6b4-da04-4714-8f11-a4d22aad2aa2
using Pluto

# ╔═╡ 0813d5d4-2fcd-4216-aacb-23935591981c
using Parameters: @unpack

# ╔═╡ f36ff62d-1117-4940-adb1-4d04eadc6332
import PlutoTest

# ╔═╡ 636c6b5e-9ec3-4ff2-8436-594302ad1753
root_dir = pkgdir(PlutoExtractors)

# ╔═╡ 00e52dcd-aa72-457c-a287-f95b159daa91
md"""
# Tests

To be extracted by another notebook
(this should check cascading (recursive) extracts)
"""

# ╔═╡ 2cebe612-e3d9-4825-a48e-96d986e6d9f8
source_nb_file = joinpath(root_dir,
	"test", "notebooks", "source_unpack.jl"
)

# ╔═╡ 7e18aeca-0c46-4819-a0ad-99a2ad58da9d
sub_session = Pluto.ServerSession()

# ╔═╡ 18838f12-f734-494a-8eff-486228846220
begin
	nb = load_nb_with_topology(source_nb_file)

	Pluto.update_run!(sub_session, nb, nb.cells)

	old_workspace_name, _ = 
		Pluto.WorkspaceManager.bump_workspace_module((sub_session, nb))
	nb.topology = Pluto.resolve_topology(
		sub_session, nb, nb.topology, old_workspace_name;
		current_roots = nb.cells  # for now, all; maybe macros are enough ?
	)
	Pluto.update_dependency_cache!(nb)
	nb
end

# ╔═╡ b68a050b-39bd-4b8b-a343-c448441a974c
unpack_cell = filter(c -> contains(c.code, "@unpack a, c"), nb.cells) |> only

# ╔═╡ 14fd0302-b8a6-4aff-b97b-4a3741bc9e21
nb.topology.nodes[unpack_cell]

# ╔═╡ 212452a9-ca96-4fe2-8a0d-06315ea10b54
@nb_extract(
	nb,
	function fun1()
		return (; a = a, c = c)
	end
)

# ╔═╡ 2ac6aef7-03a9-4731-8b4a-1e2e8063b81a
@unpack a, c = fun1()

# ╔═╡ Cell order:
# ╠═eb7ecdc0-f6bb-403d-b46d-cb5a30266883
# ╠═49edca48-fd27-41b7-8bb3-c50fcdfd33fb
# ╠═0b7dcaf9-d9fc-4486-9e83-1d37936b02dd
# ╠═f36ff62d-1117-4940-adb1-4d04eadc6332
# ╠═636c6b5e-9ec3-4ff2-8436-594302ad1753
# ╠═00e52dcd-aa72-457c-a287-f95b159daa91
# ╠═2cebe612-e3d9-4825-a48e-96d986e6d9f8
# ╠═ebc1d6b4-da04-4714-8f11-a4d22aad2aa2
# ╠═7e18aeca-0c46-4819-a0ad-99a2ad58da9d
# ╠═18838f12-f734-494a-8eff-486228846220
# ╠═b68a050b-39bd-4b8b-a343-c448441a974c
# ╠═14fd0302-b8a6-4aff-b97b-4a3741bc9e21
# ╠═212452a9-ca96-4fe2-8a0d-06315ea10b54
# ╠═0813d5d4-2fcd-4216-aacb-23935591981c
# ╠═2ac6aef7-03a9-4731-8b4a-1e2e8063b81a
