# to be included by ./runtests.jl
# where server_session is defined

@testset "Basic" begin
	source_path = pkgdir(PlutoExtractors, "test", "notebooks", "source_basic.jl")

	# "# expected" cells produce an output that the next cell should reproduce
	dest_notebook = Pluto.Notebook([
		Pluto.Cell("""using PlutoExtractors"""),
		Pluto.Cell("""
			@nb_extract("$(source_path)", 
				function fun(a)
					return c
				end
			)
			"""),
		Pluto.Cell("""8  # expected"""),
		Pluto.Cell("""fun(2)  # pass a = 2"""),
	])
	
	# search again, then ask why/if resetting path is needed
	original_pwd = pwd()
	Pluto.update_run!(server_session, dest_notebook, dest_notebook.cells)
	cd(original_pwd)

	cell(idx) = dest_notebook.cells[idx]
	@test cell(1) |> noerror
	@test cell(2) |> noerror
	#@test cell(3) |> noerror
	@test cell(4).output.body == cell(3).output.body
end
