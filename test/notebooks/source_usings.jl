### A Pluto.jl notebook ###
# v0.20.13

using Markdown
using InteractiveUtils

# ╔═╡ 52a54f2e-33f7-45f0-b251-59c476c17994
import Pkg

# ╔═╡ a1be466e-5d31-4024-8c05-6afd5ede7840
# avoid julia version clashes during testing
Pkg.activate(Base.current_project())

# ╔═╡ d76267bc-917e-42a0-8576-33a0a84ad8e3
using LinearAlgebra:dot

# ╔═╡ cadd5316-6ab0-44af-ac47-db0827059247
using Parameters  # exports type2dict (so to Pluto this is a soft definition)

# ╔═╡ 56bc6498-f5f2-11ec-0723-e94eb89c7289
v1 = [0, 1, 2]

# ╔═╡ b90ebfc8-bd7e-412a-90fc-8e2e9ecd7860
v2 = [2, 1, 0]

# ╔═╡ 98b0c017-9e5f-40b7-873a-a1067cb66031
d_direct = dot(v1, v2)

# ╔═╡ bb19b3d0-ad7d-4220-a117-fd6f60b0f2bc
d_fun(x, y) = dot(x, y)

# ╔═╡ f5a959b0-372f-400c-ba67-31460ceb6447
d_indirect = d_fun(v1, v2)

# ╔═╡ 562d4f72-d91a-4b3a-8afc-3169aad665b3
struct Options{F}
	a::F
	b::F
end

# ╔═╡ 0d074e32-08af-41da-aa4d-e5bc9992c2ff
option_a = 1.0

# ╔═╡ 9d95d185-6220-4eb3-ade7-0bab44045031
option_b = 2.0

# ╔═╡ 46c4c752-927f-4251-905c-1c3fb7348fb6
options_struct = Options(option_a, option_b)

# ╔═╡ 65605220-5ea2-4e1d-82c5-e9d7a2677e19
options_dict = type2dict(options_struct)

# ╔═╡ Cell order:
# ╠═52a54f2e-33f7-45f0-b251-59c476c17994
# ╠═a1be466e-5d31-4024-8c05-6afd5ede7840
# ╠═d76267bc-917e-42a0-8576-33a0a84ad8e3
# ╠═56bc6498-f5f2-11ec-0723-e94eb89c7289
# ╠═b90ebfc8-bd7e-412a-90fc-8e2e9ecd7860
# ╠═98b0c017-9e5f-40b7-873a-a1067cb66031
# ╠═bb19b3d0-ad7d-4220-a117-fd6f60b0f2bc
# ╠═f5a959b0-372f-400c-ba67-31460ceb6447
# ╠═cadd5316-6ab0-44af-ac47-db0827059247
# ╠═562d4f72-d91a-4b3a-8afc-3169aad665b3
# ╠═0d074e32-08af-41da-aa4d-e5bc9992c2ff
# ╠═9d95d185-6220-4eb3-ade7-0bab44045031
# ╠═46c4c752-927f-4251-905c-1c3fb7348fb6
# ╠═65605220-5ea2-4e1d-82c5-e9d7a2677e19
