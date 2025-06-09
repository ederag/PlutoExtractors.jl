### A Pluto.jl notebook ###
# v0.20.8

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    #! format: off
    return quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
    #! format: on
end

# ╔═╡ 52a54f2e-33f7-45f0-b251-59c476c17994
import Pkg

# ╔═╡ a1be466e-5d31-4024-8c05-6afd5ede7840
# avoid julia version clashes during testing
Pkg.activate(Base.current_project())

# ╔═╡ 3c5861f7-9ee8-4bc9-9bef-0cf961e009c1
using PlutoUI

# ╔═╡ 52ae84f7-d232-4e2c-9b56-e4a270c995f7
@bind a PlutoUI.Slider(1:5; default = 3, show_value = true)

# ╔═╡ 2c2a73dc-a60a-46b4-89f2-84656445a4f5
b = 2a

# ╔═╡ 7b792265-63a8-4f11-a782-97950356118a
@bind c PlutoUI.Slider(1:5; default = 5, show_value = true)

# ╔═╡ f002a445-02c5-4c38-b602-2e43279eaf45
d = 5

# ╔═╡ 6e1462cb-ac4c-4674-a2f0-1d861adf62ea
se = @bind xe PlutoUI.Slider(1:10; default = 6, show_value = true)

# ╔═╡ 27a89450-7f86-4604-99cd-d2b7cba94d0c


# ╔═╡ Cell order:
# ╠═52a54f2e-33f7-45f0-b251-59c476c17994
# ╠═a1be466e-5d31-4024-8c05-6afd5ede7840
# ╠═3c5861f7-9ee8-4bc9-9bef-0cf961e009c1
# ╠═52ae84f7-d232-4e2c-9b56-e4a270c995f7
# ╠═2c2a73dc-a60a-46b4-89f2-84656445a4f5
# ╠═7b792265-63a8-4f11-a782-97950356118a
# ╠═f002a445-02c5-4c38-b602-2e43279eaf45
# ╠═6e1462cb-ac4c-4674-a2f0-1d861adf62ea
# ╠═27a89450-7f86-4604-99cd-d2b7cba94d0c
