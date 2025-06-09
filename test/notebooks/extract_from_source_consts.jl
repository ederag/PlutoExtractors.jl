### A Pluto.jl notebook ###
# v0.20.8

using Markdown
using InteractiveUtils

# ╔═╡ 5e4a33a4-ddc3-4042-bde0-a7f8ba7c10b4
import Pkg

# ╔═╡ 5777e9cd-9feb-40a5-add3-bc983fe9833e
# ╠═╡ skip_as_script = true
#=╠═╡
begin
	Pkg.activate(Base.current_project())
	using Revise  # just to be sure Revise is called first (is it necessary ?)
end
  ╠═╡ =#

# ╔═╡ e9956baf-c12b-4f45-8e65-c03b9cc70d77
using PlutoExtractors

# ╔═╡ 85aa7d19-b432-423c-9124-2ec8d8a1f24e
import PlutoTest

# ╔═╡ 15bb49ff-61f0-40f4-ae45-b9a709bd5c57
root_dir = pkgdir(PlutoExtractors)

# ╔═╡ 818ce446-5aaf-4b71-8068-bf26b86a61f9
source_nb_file = joinpath(root_dir, "test", "notebooks", "source_consts.jl")

# ╔═╡ 6cd98e90-6332-4fad-b57c-3868a4ce7479
md"""
# Tests
"""

# ╔═╡ 77e340fc-40d7-48d6-b220-da20dac99572
md"## Just one variable"

# ╔═╡ a946286a-cef8-49e3-a98c-f87721f3d80d
utp = load_updated_topology(source_nb_file)

# ╔═╡ f064422c-b72a-4450-844f-4cb7172bd753
@nb_extract(
	utp,
	function fun_out_a()
		return a
	end
)

# ╔═╡ 37043d8c-e840-4043-8375-dc1083f5aa89
fun_out_a()

# ╔═╡ 295c54c2-7697-43cb-a474-634ff6523a60
PlutoTest.@test fun_out_a() == 1

# ╔═╡ Cell order:
# ╠═5e4a33a4-ddc3-4042-bde0-a7f8ba7c10b4
# ╠═5777e9cd-9feb-40a5-add3-bc983fe9833e
# ╠═e9956baf-c12b-4f45-8e65-c03b9cc70d77
# ╠═85aa7d19-b432-423c-9124-2ec8d8a1f24e
# ╠═15bb49ff-61f0-40f4-ae45-b9a709bd5c57
# ╠═818ce446-5aaf-4b71-8068-bf26b86a61f9
# ╠═6cd98e90-6332-4fad-b57c-3868a4ce7479
# ╠═77e340fc-40d7-48d6-b220-da20dac99572
# ╠═a946286a-cef8-49e3-a98c-f87721f3d80d
# ╠═f064422c-b72a-4450-844f-4cb7172bd753
# ╠═37043d8c-e840-4043-8375-dc1083f5aa89
# ╠═295c54c2-7697-43cb-a474-634ff6523a60
