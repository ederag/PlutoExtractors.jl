### A Pluto.jl notebook ###
# v0.20.13

using Markdown
using InteractiveUtils

# ╔═╡ a9d0dc94-7c75-431a-b25d-7d89d2a3a9be
import Pkg

# ╔═╡ 89e763c1-1a08-4b40-9fbf-b03b400ead5d
# avoid julia version clashes during testing
Pkg.activate(Base.current_project())

# ╔═╡ 8ff0322b-f912-4e41-9650-9ba0e56b1331
md"""
## Point structure
"""

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

# ╔═╡ 7e0eb7d8-235c-4780-83b7-87ead99d26e4
md"""
## Parametric type assignments
"""

# ╔═╡ 197051cf-d9aa-481a-aba1-f8db31730f2d
# cf. https://github.com/fonsp/Pluto.jl/pull/521
Nullable{T} = Union{T, Nothing}

# ╔═╡ c9acd677-b8a0-401f-8cf4-c91873d2d045
fun_1(x::Nullable{Float64}) = isnothing(x) ? NaN : x^2

# ╔═╡ c59a7988-5a9a-47b8-b162-41503a56a2c5
x_1 = 2.0

# ╔═╡ 43479f3a-a3c9-4080-92ee-3f608aa0e300
res_1_nothing = fun_1(nothing)

# ╔═╡ 9bf33e28-a75e-41a6-af35-fcb927945079
res_1_2 = fun_1(x_1)

# ╔═╡ Cell order:
# ╠═a9d0dc94-7c75-431a-b25d-7d89d2a3a9be
# ╠═89e763c1-1a08-4b40-9fbf-b03b400ead5d
# ╠═8ff0322b-f912-4e41-9650-9ba0e56b1331
# ╠═8c9967cf-9e6d-47c9-b7fd-558c78246562
# ╠═51d30d68-ec90-4df7-9542-88066d689e80
# ╠═ddaac278-e77d-4347-bff0-8ae4f8bc1cb8
# ╠═c8e6ea08-4018-4ab4-bc1a-1126e5fa4e28
# ╠═7e0eb7d8-235c-4780-83b7-87ead99d26e4
# ╠═197051cf-d9aa-481a-aba1-f8db31730f2d
# ╠═c9acd677-b8a0-401f-8cf4-c91873d2d045
# ╠═c59a7988-5a9a-47b8-b162-41503a56a2c5
# ╠═43479f3a-a3c9-4080-92ee-3f608aa0e300
# ╠═9bf33e28-a75e-41a6-af35-fcb927945079
