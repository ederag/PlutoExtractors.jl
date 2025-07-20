### A Pluto.jl notebook ###
# v0.20.13

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

# ╔═╡ 3c63d43c-e2ee-4d18-8755-4809016e0fe4
# https://discourse.julialang.org/t/pluto-get-current-notebook-file-path/60543/3
notebookpath() = replace(@__FILE__, r"#==#.*" => "")

# ╔═╡ d5a36c7c-95bf-4bd3-96d7-1b2392eeec94
# Self-sourced, do not create cycles !
source_nb_file = notebookpath()

# ╔═╡ f3ee4c34-3c96-4254-aa07-34d67efaedc3
utp = load_updated_topology(source_nb_file)

# ╔═╡ 2a76c938-34a3-4539-9487-c691e16e69f8
md"""
# Definitions
"""

# ╔═╡ 88294f24-4876-4692-858b-c28c50986dea
a = 1

# ╔═╡ f158c8de-3769-4e18-97e2-dfcc841f9306
b= 2a

# ╔═╡ e190e2a5-48fa-4f7f-be65-35907b169931
begin
	c = a
	d = 3b
end

# ╔═╡ 8411b188-54d9-43fd-9d47-6bd6d7f5ed86
md"""
# Benchmarks
"""

# ╔═╡ e4837658-a2ef-4dfa-8cb0-f909eac426b6
md"""
## Basic
"""

# ╔═╡ 525f5fcc-efd1-48ef-8aeb-9c184e54a50d
@nb_extract(
	utp,
	function fun_1(a)
		return b
	end
)

# ╔═╡ 22e1fc30-77ae-49eb-8e06-b17610980322
PlutoTest.@test fun_1(2) == 4

# ╔═╡ 2e593068-b7cb-4a4c-be06-cb9540ee265f
@benchmark fun_1(x)  setup = (x = rand())

# ╔═╡ b92d2962-cd0e-4f07-9f8e-03d4ee082c49
md"""
## From block
"""

# ╔═╡ cf58a703-4215-4fa4-962a-b01ba86042ed
@nb_extract(
	utp,
	function fun_2(a)
		return d
	end
)

# ╔═╡ 446fb193-a336-4c3c-bf40-27b2aa7a19f8
@benchmark fun_2(x)  setup = (x = rand())

# ╔═╡ c0584984-4488-43dd-b2b8-396acabd3aaa
@nb_extract(
	utp,
	function fun_3(a)
		return sin(d)
	end
)

# ╔═╡ a9df9618-e0fc-4039-b283-9e6a58c9b110
# everything that depends on :a gets into the :function,
# so this should not allocate "naturally"
@benchmark fun_3(x)  setup = (x = rand())

# ╔═╡ 2566d59a-42e5-488d-aa13-8bafaf1ad13d
@nb_extract(
	utp,
	function fun_4()
		return sin(d)
	end
)

# ╔═╡ 701eaa3b-748a-4e39-aafb-29d3482c871f
# No argument at all => everything gets into the :module
# this would allocate if :const were not prepended properly (PR #22)
@benchmark fun_4()

# ╔═╡ Cell order:
# ╠═51df9d39-7d35-49e1-bac3-7354882bb141
# ╠═67aa154f-a294-41ce-aea5-36cf5ddcf1de
# ╠═57b17b5e-7c93-4d15-b5b9-033fd49e2998
# ╠═640d5a61-0e23-4614-96d7-6d79e015eee3
# ╠═9f58ade4-c81b-45fb-a497-4f7503b94e13
# ╠═88334e90-1486-40e2-84d5-8f49eda045fe
# ╠═3c63d43c-e2ee-4d18-8755-4809016e0fe4
# ╠═d5a36c7c-95bf-4bd3-96d7-1b2392eeec94
# ╠═f3ee4c34-3c96-4254-aa07-34d67efaedc3
# ╠═2a76c938-34a3-4539-9487-c691e16e69f8
# ╠═88294f24-4876-4692-858b-c28c50986dea
# ╠═f158c8de-3769-4e18-97e2-dfcc841f9306
# ╠═e190e2a5-48fa-4f7f-be65-35907b169931
# ╠═8411b188-54d9-43fd-9d47-6bd6d7f5ed86
# ╠═e4837658-a2ef-4dfa-8cb0-f909eac426b6
# ╠═525f5fcc-efd1-48ef-8aeb-9c184e54a50d
# ╠═22e1fc30-77ae-49eb-8e06-b17610980322
# ╠═2e593068-b7cb-4a4c-be06-cb9540ee265f
# ╠═b92d2962-cd0e-4f07-9f8e-03d4ee082c49
# ╠═cf58a703-4215-4fa4-962a-b01ba86042ed
# ╠═446fb193-a336-4c3c-bf40-27b2aa7a19f8
# ╠═c0584984-4488-43dd-b2b8-396acabd3aaa
# ╠═a9df9618-e0fc-4039-b283-9e6a58c9b110
# ╠═2566d59a-42e5-488d-aa13-8bafaf1ad13d
# ╠═701eaa3b-748a-4e39-aafb-29d3482c871f
