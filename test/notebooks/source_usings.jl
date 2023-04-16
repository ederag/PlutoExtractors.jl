### A Pluto.jl notebook ###
# v0.19.22

using Markdown
using InteractiveUtils

# ╔═╡ 52a54f2e-33f7-45f0-b251-59c476c17994
import Pkg

# ╔═╡ a1be466e-5d31-4024-8c05-6afd5ede7840
# avoid julia version clashes during testing
Pkg.activate(Base.current_project())

# ╔═╡ d76267bc-917e-42a0-8576-33a0a84ad8e3
using LinearAlgebra:dot

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

# ╔═╡ Cell order:
# ╠═52a54f2e-33f7-45f0-b251-59c476c17994
# ╠═a1be466e-5d31-4024-8c05-6afd5ede7840
# ╠═d76267bc-917e-42a0-8576-33a0a84ad8e3
# ╠═56bc6498-f5f2-11ec-0723-e94eb89c7289
# ╠═b90ebfc8-bd7e-412a-90fc-8e2e9ecd7860
# ╠═98b0c017-9e5f-40b7-873a-a1067cb66031
# ╠═bb19b3d0-ad7d-4220-a117-fd6f60b0f2bc
# ╠═f5a959b0-372f-400c-ba67-31460ceb6447
