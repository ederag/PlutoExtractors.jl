### A Pluto.jl notebook ###
# v0.19.9

using Markdown
using InteractiveUtils

# ╔═╡ 8c9967cf-9e6d-47c9-b7fd-558c78246562
abstract type AbstractPoint end

# ╔═╡ 51d30d68-ec90-4df7-9542-88066d689e80
struct Point{F<:Real} <: AbstractPoint
	x::F
	y::F
end

# ╔═╡ ddaac278-e77d-4347-bff0-8ae4f8bc1cb8
a = Point(1, 2)

# ╔═╡ c8e6ea08-4018-4ab4-bc1a-1126e5fa4e28
b = 2a.x

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.3"
manifest_format = "2.0"

[deps]
"""

# ╔═╡ Cell order:
# ╠═8c9967cf-9e6d-47c9-b7fd-558c78246562
# ╠═51d30d68-ec90-4df7-9542-88066d689e80
# ╠═ddaac278-e77d-4347-bff0-8ae4f8bc1cb8
# ╠═c8e6ea08-4018-4ab4-bc1a-1126e5fa4e28
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
