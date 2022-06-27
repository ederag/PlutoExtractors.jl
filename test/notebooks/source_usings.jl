### A Pluto.jl notebook ###
# v0.19.9

using Markdown
using InteractiveUtils

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

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.3"
manifest_format = "2.0"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
"""

# ╔═╡ Cell order:
# ╠═d76267bc-917e-42a0-8576-33a0a84ad8e3
# ╠═56bc6498-f5f2-11ec-0723-e94eb89c7289
# ╠═b90ebfc8-bd7e-412a-90fc-8e2e9ecd7860
# ╠═98b0c017-9e5f-40b7-873a-a1067cb66031
# ╠═bb19b3d0-ad7d-4220-a117-fd6f60b0f2bc
# ╠═f5a959b0-372f-400c-ba67-31460ceb6447
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
