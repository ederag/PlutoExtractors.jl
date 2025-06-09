### A Pluto.jl notebook ###
# v0.20.8

using Markdown
using InteractiveUtils

# ╔═╡ a9d0dc94-7c75-431a-b25d-7d89d2a3a9be
import Pkg

# ╔═╡ 89e763c1-1a08-4b40-9fbf-b03b400ead5d
# avoid julia version clashes during testing
Pkg.activate(Base.current_project())

# ╔═╡ 03c7b89c-0797-454a-984e-d096de6acacf
md"""
# Data
"""

# ╔═╡ 57aa982b-8cf7-4e00-b9f7-44f48a57a3e0
a = 2

# ╔═╡ 9df142ea-cf46-4e08-ac9b-c27163d3d1ae
md"""
# Function
"""

# ╔═╡ 4a2e6cb9-fee8-43f7-b228-ad3daf3020d1
md"""
## Without global
"""

# ╔═╡ c5b084df-8141-4f0e-8326-0374d574bab7
fun_short(x) = x^2

# ╔═╡ a8528330-3f1a-4708-9576-327d55d33640
b = fun_short(a)

# ╔═╡ c6d9849b-d704-4aab-b315-cc82957fd874
function fun_long(x)
	x^3
end

# ╔═╡ d95c30ec-260c-4bfe-b418-002cba4587d8
c = fun_long(b)

# ╔═╡ 12c92a4a-ef97-45ad-a8c5-6bb17734be60
function fun_fun_long(x)
	fun_long(x)
end

# ╔═╡ d858d299-a94c-4c01-932d-80d8b0c7d205
d = fun_fun_long(b)

# ╔═╡ 7a94736e-0513-4ebd-b5b5-e04c6266f965
md"""
## With global
"""

# ╔═╡ 419d6b53-101b-4056-a8a5-c68d39f8cdf2
md"""
### Simple
"""

# ╔═╡ 93f72410-5b8f-4f42-a861-18af5fa7ce2c
fun_capt_a() = a

# ╔═╡ 48f418ec-0a3a-457a-9984-0c003404a429
fun_capt_a()

# ╔═╡ 2517df0b-0018-41d3-9663-dec7345c0514
fun_capt_a_b() = a + b

# ╔═╡ 6a6801f3-9822-4772-ad36-14a30e0e8b8f
fun_capt_a_b()

# ╔═╡ 5c3890ea-9f48-4730-9de7-4ecfa739901d
md"""
### Chain
"""

# ╔═╡ 9239722f-49f5-4eaa-989e-53016d224f87
fun_chain() = fun_capt_a()

# ╔═╡ db49d6e8-0ea5-4fb1-a570-f90076a72fc9
md"""
# Callable Struct

https://docs.julialang.org/en/v1/manual/methods/#Function-like-objects
"""

# ╔═╡ 92d272d3-8572-4638-a8ec-d19310fd6a6d
md"""
## Without any global
"""

# ╔═╡ 356e0ffa-55d9-47f9-bf00-fe69132c9a05
# Need a begin...end block, cf. https://github.com/fonsp/Pluto.jl/issues/7
begin
struct Scaler{F}
	factor::F
end
(sc::Scaler)(x) = x * sc.factor
end

# ╔═╡ 7574fcd2-ff3d-44d3-9811-6654e63e3f14
sc = Scaler(3.0)

# ╔═╡ 1f3bd476-16eb-44d6-a621-0cba7e729b7f
x = 4.0

# ╔═╡ a1208157-a3f3-4c73-adec-450c1e95712c
scaled_x = sc(x)  # should be 12.0

# ╔═╡ f40af99e-a4e0-4349-9345-328b4711c6fb
md"""
## With global
"""

# ╔═╡ 7dec8a20-0c48-4957-8344-3846ace9c15c
# global, notebook-wise
offset = 6.0

# ╔═╡ bd646149-b7e6-49af-b6be-f18476394eae
# Need a begin...end block, cf. https://github.com/fonsp/Pluto.jl/issues/7
begin
struct Scaler2{F}
	factor::F
end
# note the use of the global offset (unclean, but may happen)
(sc::Scaler2)(x) = x * sc.factor + offset
end

# ╔═╡ 93496e06-680c-424a-9320-bbcf7613b1c6
sc_2 = Scaler2(3.0)

# ╔═╡ 2a0ac8d5-4085-48aa-8d6c-7cde042a4260
scaled_x_2 = sc_2(x)

# ╔═╡ Cell order:
# ╠═a9d0dc94-7c75-431a-b25d-7d89d2a3a9be
# ╠═89e763c1-1a08-4b40-9fbf-b03b400ead5d
# ╠═03c7b89c-0797-454a-984e-d096de6acacf
# ╠═57aa982b-8cf7-4e00-b9f7-44f48a57a3e0
# ╠═9df142ea-cf46-4e08-ac9b-c27163d3d1ae
# ╠═4a2e6cb9-fee8-43f7-b228-ad3daf3020d1
# ╠═c5b084df-8141-4f0e-8326-0374d574bab7
# ╠═a8528330-3f1a-4708-9576-327d55d33640
# ╠═c6d9849b-d704-4aab-b315-cc82957fd874
# ╠═d95c30ec-260c-4bfe-b418-002cba4587d8
# ╠═12c92a4a-ef97-45ad-a8c5-6bb17734be60
# ╠═d858d299-a94c-4c01-932d-80d8b0c7d205
# ╠═7a94736e-0513-4ebd-b5b5-e04c6266f965
# ╠═419d6b53-101b-4056-a8a5-c68d39f8cdf2
# ╠═93f72410-5b8f-4f42-a861-18af5fa7ce2c
# ╠═48f418ec-0a3a-457a-9984-0c003404a429
# ╠═2517df0b-0018-41d3-9663-dec7345c0514
# ╠═6a6801f3-9822-4772-ad36-14a30e0e8b8f
# ╠═5c3890ea-9f48-4730-9de7-4ecfa739901d
# ╠═9239722f-49f5-4eaa-989e-53016d224f87
# ╠═db49d6e8-0ea5-4fb1-a570-f90076a72fc9
# ╠═92d272d3-8572-4638-a8ec-d19310fd6a6d
# ╠═356e0ffa-55d9-47f9-bf00-fe69132c9a05
# ╠═7574fcd2-ff3d-44d3-9811-6654e63e3f14
# ╠═1f3bd476-16eb-44d6-a621-0cba7e729b7f
# ╠═a1208157-a3f3-4c73-adec-450c1e95712c
# ╠═f40af99e-a4e0-4349-9345-328b4711c6fb
# ╠═7dec8a20-0c48-4957-8344-3846ace9c15c
# ╠═bd646149-b7e6-49af-b6be-f18476394eae
# ╠═93496e06-680c-424a-9320-bbcf7613b1c6
# ╠═2a0ac8d5-4085-48aa-8d6c-7cde042a4260
