### A Pluto.jl notebook ###
# v0.19.22

using Markdown
using InteractiveUtils

# ╔═╡ a9d0dc94-7c75-431a-b25d-7d89d2a3a9be
import Pkg

# ╔═╡ 89e763c1-1a08-4b40-9fbf-b03b400ead5d
# avoid julia version clashes during testing
Pkg.activate(Base.current_project())

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

# ╔═╡ Cell order:
# ╠═a9d0dc94-7c75-431a-b25d-7d89d2a3a9be
# ╠═89e763c1-1a08-4b40-9fbf-b03b400ead5d
# ╠═8c9967cf-9e6d-47c9-b7fd-558c78246562
# ╠═51d30d68-ec90-4df7-9542-88066d689e80
# ╠═ddaac278-e77d-4347-bff0-8ae4f8bc1cb8
# ╠═c8e6ea08-4018-4ab4-bc1a-1126e5fa4e28
