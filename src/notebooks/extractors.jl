### A Pluto.jl notebook ###
# v0.20.13

#> [frontmatter]
#> title = ""
#> description = ""

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

# ╔═╡ 3e3102e5-9bbd-4592-a749-821ee5e42c7c
import Pkg

# ╔═╡ b96bc4ca-f8bf-45a4-bd71-cd30b94d0330
# ╠═╡ skip_as_script = true
#=╠═╡
# Make sure to use the project manifest
Pkg.activate(Base.current_project())
  ╠═╡ =#

# ╔═╡ 83dbf999-dfdf-43c8-882b-f11e17e09a3a
using Pluto

# ╔═╡ 8037bbf1-fae0-47a3-a768-a089f21349a8
using MacroTools

# ╔═╡ 0c9f04da-2e65-4b82-ac1e-1520391572a2
import ExpressionExplorer as EE

# ╔═╡ 4b54ac81-1dd1-45ad-b8f6-e2cddf7092c9
import PlutoDependencyExplorer as PDE

# ╔═╡ c196fae5-1d7c-4f73-af01-d9a8c21ac5bd
function load_nb_with_topology(path::AbstractString)
	throw("Dropped in v0.2.0. Please use `load_updated_topology` instead")
end

# ╔═╡ 7e8a7524-1ae6-439d-98c6-5b2390014096
"""
    load_updated_topology(
        path;
        get_code_str = c -> c.code,
        get_code_expr = c -> Meta.parse(c.code)
    )

Return the topology of a `Pluto` notebook found at `path`,
with references and definitions filled.
`get_code_str` and `get_code_expr` are passed to
[`PlutoDependencyExplorer.updated_topology`](@ref);
see that function doc for more details.

See also [`@nb_extract`](@ref)
"""
function load_updated_topology(
	path::AbstractString;
	get_code_str = c -> c.code,
	get_code_expr = c -> Meta.parse(c.code),
)
	nb = Pluto.load_notebook_nobackup(String(path))

	empty_topology = PDE.NotebookTopology{Pluto.Cell}()

	# cf. https://plutojl.org/en/docs/plutodependencyexplorer/
	PDE.updated_topology(
		empty_topology,  # old topology
		PDE.all_cells(nb.topology),  # notebook cells
		PDE.all_cells(nb.topology);  # cells to consider (they changed)
		get_code_str,
		get_code_expr,
    )
end

# ╔═╡ b129127a-d2dc-490c-8f38-b0f210d3070c
function template_analysis(template::Expr)
	dict = MacroTools.splitdef(template)

	# symbols that will be given by the caller
	given_symbols = Set{Symbol}()
	for arg in Iterators.flatten((dict[:args], dict[:kwargs]))
		name, _ = MacroTools.splitarg(arg)
		push!(given_symbols, name)
	end

	template_body = dict[:body]
	node = EE.compute_reactive_node(template_body)
	needed_symbols = filter(∉(given_symbols), node.references)
	dict, given_symbols, needed_symbols
end

# ╔═╡ ba256080-73fb-4de4-be72-101318c82029
strip_types(x::Symbol) = x

# ╔═╡ feadac3a-859c-4915-bfc6-8fa607d6b606
# This function is used to be able to strip types from the extracted arguments to forward the function call to the gensymed one
# We want to do something like `fun(a::Something) = MODULE.#xxx#fun(a)`
function strip_types(x::Expr)::Symbol
	(arg_name, arg_type, is_splat, default) = MacroTools.splitarg(x)
	arg_name
end

# ╔═╡ 5c15516e-e3e1-401b-97b5-f4ce60e3a234
function fun_wrapper(template_dict, module_sym::Symbol)
	# Wrapper to be evaluated in the caller scope,
	# that will call the module function
	# Adapted from https://fluxml.ai/MacroTools.jl/dev/utilities/
	wrapper_dict = copy(template_dict)
	wrapper_dict[:body] = :(
		$(module_sym).$(template_dict[:name])(
			$(strip_types.(template_dict[:args])...);
			$(strip_types.(template_dict[:kwargs])...)
		)
	)
	MacroTools.combinedef(wrapper_dict)
end

# ╔═╡ c2f701da-aaa7-4af5-bada-5acb05465b3f
"""
    @nb_extract(utp, template)

Create a function out of a `Pluto` notebook updated topology,
based on a template.

The notebook updated topology `utp` is obtained
from [`load_updated_topology`](@ref).
This is a shallow first pass that will help determine the required packages.

The signature of the returned function is exactly the one of the `template`.
The arguments take precedence over the values defined in the notebook.

A second pass performed on `utp` and the template are then analyzed
to find the cells that are necessary to evaluate the template body
(the cells that define `b` and `c` in the example below).

Those cells code is prepended to the template body,
to complete the function body.

The result of the macro is this fleshed-out function,
just as if it had been typed by hand.
Preliminary benchmarks show no overhead.

Remark: `@nb_extract` can be used not only from a running Pluto notebook,
but from anywhere else (a script, the REPL, ...).

# Example
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

See also [`load_updated_topology`](@ref)
"""
macro nb_extract(utp, template)
	# will put the function definition inside a module,
	# so that the necessary packages are accessible
	# both for the macroexpansion phase (to determine dependencies)
	# and for the function
	module_sym = gensym(:PlutoExtract)

	(template_dict, given_symbols, needed_symbols) = template_analysis(template)

	# The wrapper expression has to be build beforehand,
	# to be put at the end of the quote,
	# to be evaluated in the local scope rather than in toplevel
	fun_wrapper_expr = fun_wrapper(
		template_dict,
		module_sym
	)

	# `nb_extractor_core` needs to know about the real notebook
	# so the following can only be done at runtime.
	# => Just prepare the expressions to be evaluated when the macro is executed.
	return quote
		let
			# utp is not complete yet, but enough to gather the module header
			header_expressions = collect_header_expressions($(esc(utp)), $(QuoteNode(given_symbols)))
			module_expr = get_module_expr(
				$(QuoteNode(module_sym)),
				$(esc(utp)),
				header_expressions,
			)
			m = $__module__.eval(module_expr)

			# Now can use the utp of the module
			# (more complete thanks to the macroexpansion,
			#  that succeeds because the packages are available inside the module)
			types_expr, fun_expr = nb_extractor_core(
				m.utp,
				$(QuoteNode(template_dict)),
				$(QuoteNode(given_symbols)),
				$(QuoteNode(needed_symbols))
			)

			# Put in the module the "types" expressions (`struct` for instance)
			# (not allowed in the function)
			for expr in types_expr
				Base.eval(m, expr)
			end

			Base.eval(m, fun_expr)
		end
		# This last expression will be evaluated in the caller's scope
		$(esc(fun_wrapper_expr))
	end
end


# ╔═╡ 7fe4dc9a-9821-4924-bacb-0cebae1e74bd
function fake_bind_expr()
	quote
		# Code reformatted from Pluto submodule PlutoRunner/src/bonds.jl fakebind
		# (the one that Pluto inserts in the .jl file)
		macro bind(def, element)
		    return quote
		        local iv = try
						Base.loaded_modules[
							Base.PkgId(
								Base.UUID("6e696c72-6542-2067-7265-42206c756150"),
								"AbstractPlutoDingetjes"
							)
						].Bonds.initial_value
					catch
						b -> missing
					end
		        local el = $(esc(element))
		        global $(esc(def)) = Core.applicable(Base.get, el) ?
					Base.get(el) :
					iv(el)
		        el
		    end
		end
	end
end

# ╔═╡ 56764600-5efa-45bd-bf9e-68dae3bde72c
function collect_header_expressions(utp, given)
	expressions = Expr[]
	for cell in utp.cell_order
		expr = Meta.parse(cell.code)
		node = utp.nodes[cell]

		# Pluto allows to write markdown strings
		# without an explicit `using Markdown`.
		if Symbol("@md_str") in node.macrocalls
			push!(expressions, :(using Markdown))
		end

		# Need all usings and imports
		# to create the full m.utp (with macroexpansion).
		usings_imports = EE.compute_usings_imports(expr)
		append!(expressions, usings_imports.usings)
		append!(expressions, usings_imports.imports)
	end
	# Needed for update_with_macroexpand to succeed, if any @bind
	expr = fake_bind_expr()
	push!(expressions, expr)
	expressions
end

# ╔═╡ 9194537f-8d42-422b-afa2-f86933522efc
function get_module_expr(module_name::Symbol, topology, header_expressions)
	Expr(
		:toplevel,
		:(
			module $(module_name)
				using PlutoExtractors
				$(header_expressions...)
				utp = PlutoExtractors.update_with_macroexpand(
					$(module_name),
					$(topology)
				)
			end
		)
	)
end

# ╔═╡ db0b5056-849c-40a1-b2f7-b9d89ba3ea75
get_cell_type(topology) = eltype(topology.cell_order)

# ╔═╡ 8b28bd70-e4d9-4b21-990b-0f072e6a8802
function update_with_macroexpand(_module, topology::PDE.NotebookTopology)
	cell_type = get_cell_type(topology)
	empty_topology = PDE.NotebookTopology{cell_type}()
	PDE.updated_topology(
		empty_topology,  # old topology
		PDE.all_cells(topology),  # notebook cells
		PDE.all_cells(topology);  # cells to consider (they changed)
		get_code_str = c -> c.code,
		get_code_expr = c -> macroexpand(
			_module,
			Meta.parse(c.code)
		)
    )
end

# ╔═╡ 68af943e-a9ed-44e0-85a7-452fc62411ea
# non-recursive version,
# finds exactly the cells defining the symbols that are not in given_symbols
function needed_cells_1(utp::PDE.NotebookTopology, given_symbols, needed_symbols)
	needed_symbols = filter(∉(given_symbols), needed_symbols)
	PDE.where_assigned(utp, needed_symbols)
end

# ╔═╡ efa1e893-34b0-4a14-a0e2-600a365eb717
function all_needed_cells(
	utp::PDE.NotebookTopology,
	given_symbols,
	needed_symbols
)::AbstractVector
	needed = needed_cells_1(utp, given_symbols, needed_symbols)
	to_visit = copy(needed)
	while !isempty(to_visit)
		current_cell = pop!(to_visit)
		# We are only visiting needed cells
		current_cell ∉ needed && push!(needed, current_cell)
		current_node = utp.nodes[current_cell]
		for cell in needed_cells_1(utp, given_symbols, current_node.references)
			# not in needed => not visited yet
			cell ∉ needed && push!(to_visit, cell)
		end
	end
	tpo = PDE.topological_order(utp)
	# runnable first to keep its order
	tpo.runnable ∩ needed
end

# ╔═╡ 63c26add-ac5a-4a2c-9779-bd6c9710fe1a
function remove_trailing_semicolon(str)
	rstrip(c -> c == ';' || isspace(c), str)
end

# ╔═╡ da3fb260-a858-457f-8430-c6a124d1d1e5
function gather_bind_symbols(ex)
	symbols = Symbol[]
	to_visit = Expr[ex]
	while !isempty(to_visit)
		ex = pop!(to_visit)
		if ex.head === :macrocall && ex.args[1] === Symbol("@bind")
			# args[2] is the LineNumberNode
			symbol = ex.args[3]
			push!(symbols, symbol)
		elseif ex isa Expr
			for arg in ex.args
				arg isa Expr && push!(to_visit, arg)
			end
		end
	end
	symbols
end

# ╔═╡ f4b031d7-8039-4b5b-9eca-89a2338c6b94
function check_safe_bind(code_expr, given_symbols)
	# Pluto handles @bind specially, without modules
	# Can't just look for @bind in node.references,
	# because @bind was macroexpanded during the creation of m.utp.
	bind_symbols = gather_bind_symbols(code_expr)
	for bind_symbol in bind_symbols
		# Better error for now, because if the source notebook is opened,
		# then one might be surprised that the default value is used,
		# in stead of the current value of the slider.
		if bind_symbol ∉ given_symbols
			bind_name = string(bind_symbol)
			error("""
			Encountered a `@bind` macro.
			The variable `$(bind_name)` can't be extracted without ambiguity.
			Please add `$(bind_name)` to the given arguments.
			""")
		end
	end
end

# ╔═╡ e4ecb782-85af-4e66-a7af-72eca79bd191
function has_usings_imports(ex)
	(; usings, imports) = EE.compute_usings_imports(ex)
	!isempty(usings) || !isempty(imports)
end

# ╔═╡ d2c81f1c-2756-4877-809f-5cc7b827ce9d
function defines_type(ex::Expr)
	if MacroTools.isexpr(ex, :struct, :abstract, :primitive)
		return true
	else
		return any(defines_type, ex.args)
	end
end

# ╔═╡ aaa4c1e6-bf01-4843-a168-1bd8b252f749
# fallback (for e.g. Symbol, LineNumberNode)
defines_type(x) = false

# ╔═╡ 89abc58d-366a-484e-a723-f20a364574d4
function split_destinations(
	utp::PDE.NotebookTopology,
	given_symbols,
	needed_symbols
)
	cell_type = get_cell_type(utp)
	destinations = Dict{cell_type, Symbol}()
	needed_cells = all_needed_cells(utp, given_symbols, needed_symbols)
	# First pass: find the cells that must be in the module toplevel
	for cell in needed_cells
		code_str = cell.code
		code_expr = Meta.parse(code_str)
		if has_usings_imports(code_expr) || defines_type(code_expr)
			destinations[cell] = :module
		end
	end
	# Second pass: find the cells that depend on the given symbols,
	# and thus must be in the function.
	# Relies on needed_cells following the topological order.
	dynamic_symbols = copy(given_symbols)
	for cell in needed_cells
		code_str = remove_trailing_semicolon(cell.code)
		code_expr = Meta.parse(code_str)
		node = utp.nodes[cell]
		if any(in(dynamic_symbols), node.references)
			get(destinations, cell, :none) === :module && error("""
				This cell code must be put in the module, but it references
				$(collect(node.references))
				that may utimately depend on some of the template arguments
				$(collect(given_symbols)).
				""")
			destinations[cell] = :function
			union!(
				dynamic_symbols,
				node.definitions,
				node.funcdefs_without_signatures
			)
		end
	end
	needed_cells, destinations
end

# ╔═╡ 56254f07-abe3-4161-871a-f008db14a67a
function tweak_expression(ex, destination::Symbol)
	@assert destination in (:module, :function)
	if destination == :module
		if MacroTools.isexpr(ex, :(=))
			ex = Expr(:const, ex)
		elseif MacroTools.isexpr(ex, :block)
			ex.args .= tweak_expression.(ex.args, destination)
		end
	else
		# get rid of const (not allowed in function body)
		ex = MacroTools.postwalk(ex) do x
			MacroTools.isexpr(x, :const) ? only(x.args) : x
		end
	end
	ex
end

# ╔═╡ 58780697-0b89-420c-8b22-a31705ce45e4
function nb_extractor_core(
	utp,
	template_dict::Dict,
	given_symbols,
	needed_symbols
)
	template_body = template_dict[:body]
	node = EE.compute_reactive_node(template_body)
	needed_symbols = filter(∉(given_symbols), node.references)
	needed_cells, destinations = split_destinations(
		utp,
		given_symbols,
		needed_symbols
	)

	module_expressions = Expr[]
	body = Expr(:block)
	# runnable lists cells in the correct order
	# just keep only the needed ones
	tpo = PDE.topological_order(utp)
	# runnable first to keep its order
	for cell in tpo.runnable ∩ needed_cells
		# Fix "toplevel expression not at top level"
		code_str = remove_trailing_semicolon(cell.code)
		code_expr = Meta.parse(code_str)
		check_safe_bind(code_expr, given_symbols)
		# if not :function, than can be in the module toplevel by default
		destination = get(destinations, cell, :module)
		expressions = destination === :function ? body.args : module_expressions
		tweaked_expr = tweak_expression(code_expr, destination)
		push!(expressions, tweaked_expr)
	end

	append!(body.args, template_body.args)
	new_dict = copy(template_dict)
	new_dict[:body] = body
	fun_expr = MacroTools.combinedef(new_dict)
	
	return module_expressions, fun_expr
end

# ╔═╡ 20548484-991e-4b15-b6c5-8ea6b0bf69cb
"""
    rm_all_lines(ex)

Return the expression ex expurged from all LineNumberNodes.

Current limitation: does not propagate into `quote` ?
"""
rm_all_lines(ex) = MacroTools.prewalk(MacroTools.rmlines, ex)

# ╔═╡ Cell order:
# ╠═3e3102e5-9bbd-4592-a749-821ee5e42c7c
# ╠═b96bc4ca-f8bf-45a4-bd71-cd30b94d0330
# ╠═0c9f04da-2e65-4b82-ac1e-1520391572a2
# ╠═83dbf999-dfdf-43c8-882b-f11e17e09a3a
# ╠═4b54ac81-1dd1-45ad-b8f6-e2cddf7092c9
# ╠═8037bbf1-fae0-47a3-a768-a089f21349a8
# ╠═c196fae5-1d7c-4f73-af01-d9a8c21ac5bd
# ╠═7e8a7524-1ae6-439d-98c6-5b2390014096
# ╠═c2f701da-aaa7-4af5-bada-5acb05465b3f
# ╠═b129127a-d2dc-490c-8f38-b0f210d3070c
# ╠═5c15516e-e3e1-401b-97b5-f4ce60e3a234
# ╠═ba256080-73fb-4de4-be72-101318c82029
# ╠═feadac3a-859c-4915-bfc6-8fa607d6b606
# ╠═56764600-5efa-45bd-bf9e-68dae3bde72c
# ╠═7fe4dc9a-9821-4924-bacb-0cebae1e74bd
# ╠═9194537f-8d42-422b-afa2-f86933522efc
# ╠═8b28bd70-e4d9-4b21-990b-0f072e6a8802
# ╠═58780697-0b89-420c-8b22-a31705ce45e4
# ╠═89abc58d-366a-484e-a723-f20a364574d4
# ╠═db0b5056-849c-40a1-b2f7-b9d89ba3ea75
# ╠═efa1e893-34b0-4a14-a0e2-600a365eb717
# ╠═68af943e-a9ed-44e0-85a7-452fc62411ea
# ╠═63c26add-ac5a-4a2c-9779-bd6c9710fe1a
# ╠═f4b031d7-8039-4b5b-9eca-89a2338c6b94
# ╠═da3fb260-a858-457f-8430-c6a124d1d1e5
# ╠═e4ecb782-85af-4e66-a7af-72eca79bd191
# ╠═d2c81f1c-2756-4877-809f-5cc7b827ce9d
# ╠═aaa4c1e6-bf01-4843-a168-1bd8b252f749
# ╠═56254f07-abe3-4161-871a-f008db14a67a
# ╠═20548484-991e-4b15-b6c5-8ea6b0bf69cb
