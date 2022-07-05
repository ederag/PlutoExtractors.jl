### A Pluto.jl notebook ###
# v0.19.9

#> [frontmatter]
#> title = ""
#> description = ""

using Markdown
using InteractiveUtils

# ╔═╡ 83dbf999-dfdf-43c8-882b-f11e17e09a3a
using Pluto

# ╔═╡ 8037bbf1-fae0-47a3-a768-a089f21349a8
using MacroTools

# ╔═╡ 7e8a7524-1ae6-439d-98c6-5b2390014096
"""
    load_nb_with_topology(path)

Load a `Pluto` notebook, with topology and dependency cache filled.

See also [`@nb_extract`](@ref)
"""
function load_nb_with_topology(path::AbstractString)
	nb = Pluto.load_notebook_nobackup(String(path))
	old_tp = nb.topology
	new_tp = nb.topology = Pluto.updated_topology(old_tp, nb, nb.cells)
	Pluto.update_dependency_cache!(nb)
	nb
end

# ╔═╡ a8b197ad-765b-475e-9010-d73df9d24c13
function find_definition_cells(nb::Pluto.Notebook, symbols)
	filter(
		cell -> any(in(nb.topology.nodes[cell].definitions), symbols),
		nb.cells
	)
end

# ╔═╡ 447318b6-e302-4f16-b149-52108b4283fe
find_function_cells(nb::Pluto.Notebook, symbols) = filter(
	cell -> any(
		symbol -> (
			symbol in nb.topology.nodes[cell].funcdefs_with_signatures
			|| symbol in nb.topology.nodes[cell].funcdefs_without_signatures
		),
		symbols
	),
	nb.cells
)

# ╔═╡ 9fb50a81-390d-44bc-8819-e9ed97d1e0de
function symbols_defined(nb::Pluto.Notebook, cell)
	node = nb.topology.nodes[cell]
	union(
		node.definitions,
		node.funcdefs_with_signatures,
		node.funcdefs_without_signatures,
	)
end

# ╔═╡ 2300d1df-94cd-4f7e-bd0b-07bad790464f
find_symbols_cells(nb::Pluto.Notebook, symbols) = filter(
	# TODO: this can surely be simplified now
	cell -> any(
		symbol -> symbol in symbols_defined(nb, cell),
		symbols
	),
	nb.cells
)

# ╔═╡ efa1e893-34b0-4a14-a0e2-600a365eb717
function all_needed_cells(nb::Pluto.Notebook, cell; given=[])
	if all(in(given), symbols_defined(nb, cell))
		return Set{typeof(cell)}()
	end
	# upstream_cells_map is not recursive; it contains only the direct parents
	cells = Set([cell])

	# upstream_cell_map values contain the list of parent cells
	# TODO: looks like there is a Pluto.upstream_cells_map(cell)
	for up_deps in values(cell.cell_dependencies.upstream_cells_map)
		# each up_deps is a vector of cells
		for up_dep in up_deps
			union!(cells, all_needed_cells(nb, up_dep; given))
		end
	end
	cells
end

# ╔═╡ c71b4e52-5d6a-4a82-b465-b755217198e6
function nb_extracter_body(nb::Pluto.Notebook; given=[], outputs=[])
	output_cells = find_symbols_cells(nb, outputs)
	needed_cells = mapreduce(
		c -> all_needed_cells(nb, c; given),
		union,
		output_cells
	)
	body = Expr(:block)
	# runnable lists cells in the correct order
	# just keep only the needed ones
	tpo = topological_order(nb)
	# runnable first to keep its order
	for cell in tpo.runnable ∩ needed_cells
		# this returns a :toplevel expression
		cell_expr = Pluto.parse_custom(nb, cell)
		if !any(ex -> MacroTools.isexpr(ex, :using, :import), cell_expr.args)
			# `using` and `import` are not allowed in a function.
			# Just ignore, for now (TODO)
			append!(body.args, cell_expr.args)
		end
	end
	# get rid of const (not allowed in function body)
	body = MacroTools.postwalk(body) do x
		MacroTools.isexpr(x, :const) ? only(x.args) : x
	end
	return body
end

# ╔═╡ ea0ba472-50a3-4ab6-a221-0b710b361fca
function nb_extracter(nb::Pluto.Notebook; given=[], outputs=[])
	code = nb_extracter_code(nb; given, outputs)
	return eval(
		Meta.parse(code)
	)
end

# ╔═╡ ba256080-73fb-4de4-be72-101318c82029
strip_types(x::Symbol) = x

# ╔═╡ feadac3a-859c-4915-bfc6-8fa607d6b606
# This function is used to be able to strip types from the extracted arguments to forward the function call to the gensymed one
# We want to do something like `fun(a::Something) = MODULE.#xxx#fun(a)`
function strip_types(x::Expr)::Symbol
	if Meta.isexpr(x, :(::))
		return x.args[1] # In case of expr of type x::Something, just return x
	else
		error("This function should only receive either symbols or Expr of the type `x::Something`. Instead `$x` was given as input")
	end
end

# ╔═╡ c2f701da-aaa7-4af5-bada-5acb05465b3f
"""
    @nb_extract(nb, template)

Create a function out of a `Pluto` notebook, based on a template.

The notebook `nb` must be a `Pluto.Notebook`,
with up-to-date topology and dependency cache
(for instance from [`load_nb_with_topology`](@ref)).

The signature of the returned function is exactly the one of the `template`.
The argument names must match symbols defined in the notebook.
The arguments values will be used instead of the source notebook ones
in the evaluation.

The return value of this function is found in the `template` body.
This body must consist of a single `return` statement.
The return value can be a single variable (e.g. ` return c`),
a tuple (e.g. `return (b, c)`), or a named tuple (e.g. `return (; b = b, whatever = c)`).

The notebook `nb` is then analyzed to find the cells that are necessary
to evaluate the return value
(the cells that define `a` and `b` in the last examples).

Those cells code is used as the core of the function body.

The result of the macro is this fleshed-out function,
just as if it had been typed by hand.
Preliminary benchmarks show no overhead.

Remark: `@nb_extract` can be used not only from a running Pluto notebook,
but from anywhere else (a script, the REPL, ...).

# Examples
Say in the source notebook there are three cells: `a = 1`, `b = 2a`, `c = 2b`,
here is how to make a function that return the value `c` from any given `a`:
```jldoctest
julia> using PlutoExtracters: load_nb_with_topology, @nb_extract
julia> source_path = pkgdir(PlutoExtracters,
	"test", "notebooks", "source_basic.jl"
)  # to be replaced with the path of your source notebook
julia> nb = load_nb_with_topology(source_path);
julia> @nb_extract(
	nb,
	function fun(a)
		return c
	end
)
julia> fun(2)
8
```

See also [`load_nb_with_topology`](@ref)
"""
macro nb_extract(nb, template)
	# analysis of the function signature and body
	d = MacroTools.splitdef(template)

	# symbols that will be given by the caller
	given = []
	for arg in Iterators.flatten((d[:args], d[:kwargs]))
		name, _ = MacroTools.splitarg(arg)
		push!(given, name)
	end

	# symbols that will be required to build the return
	outputs = []
	# template body, where the return symbols must be found
	body = d[:body]
	# @info MacroTools.rmlines(body)
	# note: those `return` are part of the template, not of this macro
	if MacroTools.@capture(
		body,
		return (; kws__)  # template to return a NamedTuple
	)
		for kw in kws
			@capture(kw, key_ = val_)
			push!(outputs, val)
		end
	elseif MacroTools.@capture(
		body,
		return (symbols__,)  # template to return a Tuple
	)
		for symbol in symbols
			push!(outputs, symbol)
		end
	elseif MacroTools.@capture(
		body,
		return symbol_  # template to return a single variable
	)
		push!(outputs, symbol)
	else
		throw(ErrorException("""
			No acceptable return statement found in '''
			$body
			'''
			"""))
	end

	# We gensym the name of the function to be evaluated so it's not easibly accessible directly, in order to make the macro also in let blocks without polluting the global scope
	gensym_name = gensym(d[:name])
	# We already create the expression that will be evaluated to map the gensymed function evaluated in the module to the non-gensymed name. This is also useful to trigger Pluto reactivity.
	expr = let dict = d # Adapted from https://fluxml.ai/MacroTools.jl/dev/utilities/
		rtype = get(dict, :rtype, :Any)
		:(function $(dict[:name])($(dict[:args]...);
		                          $(dict[:kwargs]...))::$rtype where {$(dict[:whereparams]...)}
		  $(__module__).$(gensym_name)($(strip_types.(dict[:args])...);
		                          $(strip_types.(dict[:kwargs])...))
		end)
	end
	# We assign the gensym_name to the function name in the dict
	d[:name] = gensym_name
	# `nb_extracter_body` needs to know about the real notebook
	# so the following can only be done at runtime.
	# => Just prepare the expressions to be evaluated when the macro is executed.
	return quote
		let
			extracted_block = nb_extracter_body(
				$(esc(nb));
				given=$given,
				outputs=$outputs
			)
			prepend!($d[:body].args, extracted_block.args)
			$__module__.eval(MacroTools.combinedef($d))
		end
		$(esc(expr))
	end
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
MacroTools = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
Pluto = "c3e4b0f8-55cb-11ea-2926-15256bba5781"

[compat]
MacroTools = "~0.5.9"
Pluto = "~0.19.4"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[Configurations]]
deps = ["ExproniconLite", "OrderedCollections", "TOML"]
git-tree-sha1 = "ab9b7c51e8acdd20c769bccde050b5615921c533"
uuid = "5218b696-f38b-4ac9-8b61-a12ec717816d"
version = "0.17.3"

[[DataAPI]]
git-tree-sha1 = "fb5f5316dd3fd4c5e7c30a24d50643b73e37cd40"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.10.0"

[[DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[ExproniconLite]]
git-tree-sha1 = "8b08cc88844e4d01db5a2405a08e9178e19e479e"
uuid = "55351af7-c7e9-48d6-89ff-24e801d99491"
version = "0.6.13"

[[FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[FuzzyCompletions]]
deps = ["REPL"]
git-tree-sha1 = "efd6c064e15e92fcce436977c825d2117bf8ce76"
uuid = "fb4132e2-a121-4a70-b8a1-d5b831dcdcc2"
version = "0.5.0"

[[HTTP]]
deps = ["Base64", "Dates", "IniFile", "Logging", "MbedTLS", "NetworkOptions", "Sockets", "URIs"]
git-tree-sha1 = "0fa77022fe4b511826b39c894c90daf5fce3334a"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "0.9.17"

[[IniFile]]
git-tree-sha1 = "f550e6e32074c939295eb5ea6de31849ac2c9625"
uuid = "83e8ac13-25f8-5344-8a64-a9f2b223428f"
version = "0.5.1"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "3d3e902b31198a27340d0bf00d6ac452866021cf"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.9"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "Random", "Sockets"]
git-tree-sha1 = "1c38e51c3d08ef2278062ebceade0e46cefc96fe"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.0.3"

[[MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[MsgPack]]
deps = ["Serialization"]
git-tree-sha1 = "a8cbf066b54d793b9a48c5daa5d586cf2b5bd43d"
uuid = "99f44e22-a591-53d1-9472-aa23ef4bd671"
version = "1.1.0"

[[NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[Pluto]]
deps = ["Base64", "Configurations", "Dates", "Distributed", "FileWatching", "FuzzyCompletions", "HTTP", "InteractiveUtils", "Logging", "MIMEs", "Markdown", "MsgPack", "Pkg", "PrecompileSignatures", "REPL", "RelocatableFolders", "Sockets", "TOML", "Tables", "UUIDs"]
git-tree-sha1 = "79deea5ae703ab44e78cfc472f79e39750400cb2"
uuid = "c3e4b0f8-55cb-11ea-2926-15256bba5781"
version = "0.19.4"

[[PrecompileSignatures]]
git-tree-sha1 = "18ef344185f25ee9d51d80e179f8dad33dc48eb1"
uuid = "91cefc8d-f054-46dc-8f8c-26e11d7c5411"
version = "3.0.3"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "cdbd3b1338c72ce29d9584fdbe9e9b70eeb5adca"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "0.1.3"

[[SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[Scratch]]
deps = ["Dates"]
git-tree-sha1 = "0b4b7f1393cff97c33891da2a0bf69c6ed241fda"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.1.0"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "OrderedCollections", "TableTraits", "Test"]
git-tree-sha1 = "5ce79ce186cc678bbb5c5681ca3379d1ddae11a1"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.7.0"

[[Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[URIs]]
git-tree-sha1 = "97bbe755a53fe859669cd907f2d96aee8d2c1355"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.3.0"

[[UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"

[[nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
"""

# ╔═╡ Cell order:
# ╠═83dbf999-dfdf-43c8-882b-f11e17e09a3a
# ╠═8037bbf1-fae0-47a3-a768-a089f21349a8
# ╠═7e8a7524-1ae6-439d-98c6-5b2390014096
# ╠═a8b197ad-765b-475e-9010-d73df9d24c13
# ╠═447318b6-e302-4f16-b149-52108b4283fe
# ╠═9fb50a81-390d-44bc-8819-e9ed97d1e0de
# ╠═2300d1df-94cd-4f7e-bd0b-07bad790464f
# ╠═efa1e893-34b0-4a14-a0e2-600a365eb717
# ╠═c71b4e52-5d6a-4a82-b465-b755217198e6
# ╠═ea0ba472-50a3-4ab6-a221-0b710b361fca
# ╠═ba256080-73fb-4de4-be72-101318c82029
# ╠═feadac3a-859c-4915-bfc6-8fa607d6b606
# ╠═c2f701da-aaa7-4af5-bada-5acb05465b3f
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
