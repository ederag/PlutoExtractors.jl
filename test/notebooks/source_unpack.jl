### A Pluto.jl notebook ###
# v0.19.22

using Markdown
using InteractiveUtils

# ╔═╡ 0493f36f-42d4-483a-b891-4f1f3002d977
import Pkg

# ╔═╡ f58794b8-d83c-43a6-afbd-e887c0306182
# avoid julia version clashes during testing
Pkg.activate(Base.current_project())

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

# ╔═╡ Cell order:
# ╠═0493f36f-42d4-483a-b891-4f1f3002d977
# ╠═f58794b8-d83c-43a6-afbd-e887c0306182
# ╠═7697635f-d048-4e0e-aeed-0229164026de
# ╠═c2ecf80f-11cb-4228-b7fd-7db4643c1eb5
# ╠═5460ab14-ea6f-11ec-083c-339d0912f969
# ╠═028686a2-bf16-48ce-bdae-eea640322d97
# ╠═7bfed1e8-054e-475e-92b6-f926bf5c2855
# ╠═d424a685-7296-419f-8b18-7b6170d4ee36
# ╠═195bf3b0-67cd-4d9c-9159-5acea798fb59
