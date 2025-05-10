### A Pluto.jl notebook ###
# v0.20.8

#> [frontmatter]
#> title = ""
#> description = ""

using Markdown
using InteractiveUtils

# ╔═╡ 3e3102e5-9bbd-4592-a749-821ee5e42c7c
import Pkg

# ╔═╡ b96bc4ca-f8bf-45a4-bd71-cd30b94d0330
# ╠═╡ skip_as_script = true
#=╠═╡
# Make sure to use the project manifest
Pkg.activate(Base.current_project())
  ╠═╡ =#

# ╔═╡ 0c9f04da-2e65-4b82-ac1e-1520391572a2
using ExpressionExplorer

# ╔═╡ 83dbf999-dfdf-43c8-882b-f11e17e09a3a
using Pluto

# ╔═╡ 8037bbf1-fae0-47a3-a768-a089f21349a8
using MacroTools

# ╔═╡ 4b54ac81-1dd1-45ad-b8f6-e2cddf7092c9
import PlutoDependencyExplorer as PDE

# ╔═╡ c196fae5-1d7c-4f73-af01-d9a8c21ac5bd
function load_nb_with_topology(path::AbstractString)
	throw("Dropped in v0.2.0. Please use `load_updated_topology` instead")
end

# ╔═╡ 7e8a7524-1ae6-439d-98c6-5b2390014096
"""
    load_updated_topology(path)

Return the topology of a `Pluto` notebook found at `path`,
with references and definitions filled.

See also [`@nb_extract`](@ref)
"""
function load_updated_topology(path::AbstractString)
	nb = Pluto.load_notebook_nobackup(String(path))

	empty_topology = PDE.NotebookTopology{Pluto.Cell}()

	# cf. https://plutojl.org/en/docs/plutodependencyexplorer/
	PDE.updated_topology(
		empty_topology,  # old topology
		PDE.all_cells(nb.topology),  # notebook cells
		PDE.all_cells(nb.topology);  # cells to consider (they changed)
		get_code_str = c -> c.code,
		get_code_expr = c -> Meta.parse(c.code),
    )
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
function symbols_defined(utp::PDE.NotebookTopology, cell)
	node = utp.nodes[cell]
	union(
		node.definitions,
		node.funcdefs_with_signatures,
		node.funcdefs_without_signatures,
	)
end

# ╔═╡ 2300d1df-94cd-4f7e-bd0b-07bad790464f
find_symbols_cells(utp::PDE.NotebookTopology, symbols) = filter(
	# TODO: this can surely be simplified now
	cell -> any(
		symbol -> symbol in symbols_defined(utp, cell),
		symbols
	),
	PDE.all_cells(utp)
)

# ╔═╡ efa1e893-34b0-4a14-a0e2-600a365eb717
function all_needed_cells(utp::PDE.NotebookTopology, cell;
	given = [],
	visited = nothing
)
	if all(in(given), symbols_defined(utp, cell))
		return Set{typeof(cell)}()
	end
	# upstream_cells_map is not recursive; it contains only the direct parents
	cells = Set([cell])
	if isnothing(visited)
		visited = [cell]
	else
		push!(visited, cell)
	end

	node = utp.nodes[cell]
	for up_deps in PDE.where_assigned(utp, node.references)
		if up_deps isa Pluto.Cell
			up_deps = [up_deps]
		end
		for up_dep in up_deps
			up_dep in visited && continue
			union!(cells, all_needed_cells(utp, up_dep; given))
		end
	end
	cells
end

# ╔═╡ 63c26add-ac5a-4a2c-9779-bd6c9710fe1a
function remove_trailing_semicolon(str)
	rstrip(c -> c == ';' || isspace(c), str)
end

# ╔═╡ e4ecb782-85af-4e66-a7af-72eca79bd191
function has_usings_imports(ex)
	(; usings, imports) = compute_usings_imports(ex)
	!isempty(usings) || !isempty(imports)
end

# ╔═╡ c71b4e52-5d6a-4a82-b465-b755217198e6
function nb_extractor_body(utp::PDE.NotebookTopology; given=[], outputs=[])
	output_cells = find_symbols_cells(utp, outputs)
	isempty(output_cells) && error(
		"Unable to extract any definition for $outputs"
	)
	needed_cells = mapreduce(
		c -> all_needed_cells(utp, c; given),
		union,
		output_cells
	)
	body = Expr(:block)
	# runnable lists cells in the correct order
	# just keep only the needed ones
	tpo = PDE.topological_order(utp)
	# runnable first to keep its order
	for cell in tpo.runnable ∩ needed_cells
		# Fix "toplevel expression not at top level"
		code_str = remove_trailing_semicolon(cell.code)
		code_expr = Meta.parse(code_str)
		if !has_usings_imports(code_expr)
			# `using` and `import` are not allowed in a function.
			# Just ignore, for now (TODO)
			push!(body.args, code_expr)
		end
	end
	# get rid of const (not allowed in function body)
	body = MacroTools.postwalk(body) do x
		MacroTools.isexpr(x, :const) ? only(x.args) : x
	end
	# get rid of type definitions (not allowed in function body)
	body = MacroTools.postwalk(body) do x
		MacroTools.isexpr(x, :struct, :abstract, :primitive) ? nothing : x
	end
	return body
end

# ╔═╡ ea0ba472-50a3-4ab6-a221-0b710b361fca
function nb_extractor(nb::Pluto.Notebook; given=[], outputs=[])
	code = nb_extractor_code(nb; given, outputs)
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
	if Meta.isexpr(x, [:(::), :kw])
		return strip_types(x.args[1]) # We recursively call strip_types till we reach the symbol or we error
	else
		error("This function should only receive either symbols or Expr of the type `x::Something`, `x=something` or `x::Something=something`. Instead `$x` was given as input")
	end
end

# ╔═╡ c2f701da-aaa7-4af5-bada-5acb05465b3f
"""
    @nb_extract(utp, template)

Create a function out of a `Pluto` notebook updated topology,
based on a template.

The notebook updated topology `utp` must be a `PlutoDependencyExplorer.NotebookTopology{Pluto.Cell}`,
with up-to-date topology, filled with references and definitions
(for instance from [`load_updated_topology`](@ref)).

The signature of the returned function is exactly the one of the `template`.
The argument names must match symbols defined in the notebook.
The arguments values will be used instead of the source notebook ones
in the evaluation.

The return value of this function is found in the `template` body.
This body must consist of a single `return` statement.
The return value can be a single variable (e.g. ` return c`),
a tuple (e.g. `return (b, c)`), or a named tuple (e.g. `return (; b = b, whatever = c)`).

The updated topology `utp` is then analyzed to find the cells that are necessary
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
julia> using PlutoExtractors: load_updated_topology, @nb_extract
julia> source_path = pkgdir(PlutoExtractors,
	"test", "notebooks", "source_basic.jl"
)  # to be replaced with the path of your source notebook
julia> utp = load_updated_topology(source_path);
julia> @nb_extract(
	utp,
	function fun(a)
		return c
	end
)
julia> fun(2)
8
```

See also [`load_nb_with_topology`](@ref)
"""
macro nb_extract(utp, template)
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
	# `nb_extractor_body` needs to know about the real notebook
	# so the following can only be done at runtime.
	# => Just prepare the expressions to be evaluated when the macro is executed.
	return quote
		let
			extracted_block = nb_extractor_body(
				$(esc(utp));
				given=$given,
				outputs=$outputs
			)
			prepend!($d[:body].args, extracted_block.args)
			$__module__.eval(MacroTools.combinedef($d))
		end
		$(esc(expr))
	end
end

# ╔═╡ Cell order:
# ╠═3e3102e5-9bbd-4592-a749-821ee5e42c7c
# ╠═b96bc4ca-f8bf-45a4-bd71-cd30b94d0330
# ╠═0c9f04da-2e65-4b82-ac1e-1520391572a2
# ╠═83dbf999-dfdf-43c8-882b-f11e17e09a3a
# ╠═4b54ac81-1dd1-45ad-b8f6-e2cddf7092c9
# ╠═8037bbf1-fae0-47a3-a768-a089f21349a8
# ╠═c196fae5-1d7c-4f73-af01-d9a8c21ac5bd
# ╠═7e8a7524-1ae6-439d-98c6-5b2390014096
# ╠═a8b197ad-765b-475e-9010-d73df9d24c13
# ╠═447318b6-e302-4f16-b149-52108b4283fe
# ╠═9fb50a81-390d-44bc-8819-e9ed97d1e0de
# ╠═2300d1df-94cd-4f7e-bd0b-07bad790464f
# ╠═efa1e893-34b0-4a14-a0e2-600a365eb717
# ╠═c71b4e52-5d6a-4a82-b465-b755217198e6
# ╠═63c26add-ac5a-4a2c-9779-bd6c9710fe1a
# ╠═e4ecb782-85af-4e66-a7af-72eca79bd191
# ╠═ea0ba472-50a3-4ab6-a221-0b710b361fca
# ╠═ba256080-73fb-4de4-be72-101318c82029
# ╠═feadac3a-859c-4915-bfc6-8fa607d6b606
# ╠═c2f701da-aaa7-4af5-bada-5acb05465b3f
