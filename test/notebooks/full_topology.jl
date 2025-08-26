### A Pluto.jl notebook ###
# v0.20.13

using Markdown
using InteractiveUtils

# ╔═╡ 51df9d39-7d35-49e1-bac3-7354882bb141
import Pkg

# ╔═╡ 67aa154f-a294-41ce-aea5-36cf5ddcf1de
# ╠═╡ skip_as_script = true
#=╠═╡
Pkg.activate(Base.current_project())
  ╠═╡ =#

# ╔═╡ 640d5a61-0e23-4614-96d7-6d79e015eee3
using PlutoExtractors

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

# ╔═╡ cc1cfa88-90d7-4445-8064-bf4b71456d4d
md"""
## Soft definitions
"""

# ╔═╡ 51a23f6a-f327-4fbe-a722-37b4bb9fe4b7
# We want the full topology to be complete
# even when Parameters is not used in the calling notebook
PlutoTest.@test !@isdefined Parameters

# ╔═╡ 987fd80c-a884-4828-8c5d-96c92d5f099a
utp = PlutoExtractors.@load_full_topology(source_nb_file)

# ╔═╡ efc5cf0b-20ff-4f1c-a99e-d9280959dba1
cell = filter(utp.cell_order) do cell
	startswith(cell.code, "using Parameters")
end |> only

# ╔═╡ 08c48966-25ff-43b6-a628-39e6ff6971dd
node = utp.nodes[cell]

# ╔═╡ 66bfc7d3-035f-46cf-bcfe-fe12e45a31a1
PlutoTest.@test !isempty(node.soft_definitions)

# ╔═╡ Cell order:
# ╠═51df9d39-7d35-49e1-bac3-7354882bb141
# ╠═67aa154f-a294-41ce-aea5-36cf5ddcf1de
# ╠═640d5a61-0e23-4614-96d7-6d79e015eee3
# ╠═9f58ade4-c81b-45fb-a497-4f7503b94e13
# ╠═88334e90-1486-40e2-84d5-8f49eda045fe
# ╠═d5a36c7c-95bf-4bd3-96d7-1b2392eeec94
# ╠═8411b188-54d9-43fd-9d47-6bd6d7f5ed86
# ╠═cc1cfa88-90d7-4445-8064-bf4b71456d4d
# ╠═51a23f6a-f327-4fbe-a722-37b4bb9fe4b7
# ╠═987fd80c-a884-4828-8c5d-96c92d5f099a
# ╠═efc5cf0b-20ff-4f1c-a99e-d9280959dba1
# ╠═08c48966-25ff-43b6-a628-39e6ff6971dd
# ╠═66bfc7d3-035f-46cf-bcfe-fe12e45a31a1
