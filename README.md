# PlutoExtractors

[![Build Status](https://github.com/ederag/PlutoExtractors.jl/actions/workflows/CI.yml/badge.svg?branch=master)](https://github.com/ederag/PlutoExtractors.jl/actions/workflows/CI.yml?query=branch%3Amaster)

## Feature

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

More examples can be found in the test/notebooks/extract_from_*.jl Pluto notebooks.

# About packages management

The destination notebook packages are always used.

So the best experience should be expected with running notebooks within the [“shared environment”](https://plutojl.org/en/docs/packages-advanced/) pattern,
e.g. with `Pkg.activate(Base.current_project())`.
This ensures that both source and destination share exactly the same packages versions.

In principle `@nb_extract` may be used with the standard Pluto package system, but then
1) The necessary `using` statements _must_ be copied manually to the destination notebook
   (otherwise they would be missing from the notebook project)
2) Something that used to work in the source _might_ fail in the destination just because packages versions differ.

## Status

This package is in alpha stage.
It works well here, but no doubt bugs will come up when used by others,
please file issues !

## Acknowledgments

Most of the work is done by
[Pluto.jl](https://github.com/fonsp/Pluto.jl) for the notebook loading,
as well as [ExpressionExplorer.jl](https://github.com/JuliaPluto/ExpressionExplorer.jl),
[PlutoDependencyExplorer.jl](https://github.com/JuliaPluto/PlutoDependencyExplorer.jl)
and [MacroTools.jl](https://github.com/FluxML/MacroTools.jl) for the analysis.
