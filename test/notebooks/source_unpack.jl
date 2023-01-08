### A Pluto.jl notebook ###
# v0.19.19

using Markdown
using InteractiveUtils

# ╔═╡ 7697635f-d048-4e0e-aeed-0229164026de
using Parameters: @unpack

# ╔═╡ c2ecf80f-11cb-4228-b7fd-7db4643c1eb5
using PlutoTest

# ╔═╡ 5460ab14-ea6f-11ec-083c-339d0912f969
@unpack a, c = (; a = 1, b = 2, c = 3)

# ╔═╡ 028686a2-bf16-48ce-bdae-eea640322d97
PlutoTest.@test a == 1

# ╔═╡ 7bfed1e8-054e-475e-92b6-f926bf5c2855
PlutoTest.@test !@isdefined b

# ╔═╡ d424a685-7296-419f-8b18-7b6170d4ee36
PlutoTest.@test c == 3

# ╔═╡ 195bf3b0-67cd-4d9c-9159-5acea798fb59
# just to check regular extracts
d = 4

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Parameters = "d96e819e-fc66-5662-9728-84c9c7592b0a"
PlutoTest = "cb4044da-4d16-4ffa-a6a3-8cad7f73ebdc"

[compat]
Parameters = "~0.12.3"
PlutoTest = "~0.2.2"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.3"
manifest_format = "2.0"
project_hash = "8ac9c9dcc103e2f3349aeb32533abe158f664549"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[deps.Parameters]]
deps = ["OrderedCollections", "UnPack"]
git-tree-sha1 = "34c0e9ad262e5f7fc75b10a9952ca7692cfc5fbe"
uuid = "d96e819e-fc66-5662-9728-84c9c7592b0a"
version = "0.12.3"

[[deps.PlutoTest]]
deps = ["HypertextLiteral", "InteractiveUtils", "Markdown", "Test"]
git-tree-sha1 = "17aa9b81106e661cffa1c4c36c17ee1c50a86eda"
uuid = "cb4044da-4d16-4ffa-a6a3-8cad7f73ebdc"
version = "0.2.2"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.Tricks]]
git-tree-sha1 = "6bac775f2d42a611cdfcd1fb217ee719630c4175"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.6"

[[deps.UnPack]]
git-tree-sha1 = "387c1f73762231e86e0c9c5443ce3b4a0a9a0c2b"
uuid = "3a884ed6-31ef-47d7-9d2a-63182c4928ed"
version = "1.0.2"
"""

# ╔═╡ Cell order:
# ╠═7697635f-d048-4e0e-aeed-0229164026de
# ╠═c2ecf80f-11cb-4228-b7fd-7db4643c1eb5
# ╠═5460ab14-ea6f-11ec-083c-339d0912f969
# ╠═028686a2-bf16-48ce-bdae-eea640322d97
# ╠═7bfed1e8-054e-475e-92b6-f926bf5c2855
# ╠═d424a685-7296-419f-8b18-7b6170d4ee36
# ╠═195bf3b0-67cd-4d9c-9159-5acea798fb59
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
