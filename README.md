# PlutoExtracters

## Feature

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

### Example
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

More examples can be found in the test/notebooks/extract_from_*.jl Pluto notebooks.


## Status

This is early alpha stage, for the adventurous, and for early feedback.
Work is under way to make it more robust.

The heavy work is done by
[MacroTools.jl](https://github.com/FluxML/MacroTools.jl)
and [Pluto.jl](https://github.com/fonsp/Pluto.jl) internals,
but we might need a finer granularity (at the symbol rather than the cell level),
to handle cases where the same cell defines two variables:
one that is given, and one that is needed.
