using PlutoExtractors
using Test
using Pluto

# header adapted from
# https://github.com/JuliaPluto/PlutoHooks.jl/blob/main/test/with_pluto.jl


function noerror(cell)
    errored = cell.errored
    if errored
        @show cell.output
    end
    !errored
end


server_session = Pluto.ServerSession()
server_session.options.evaluation.workspace_use_distributed = false

fakeclient = Pluto.ClientSession(:fake, nothing)
server_session.connected_clients[fakeclient.id] = fakeclient


@testset "PlutoExtractors.jl" begin
	@testset "Helpers" begin
		include("notebooks/helpers.jl")
	end

	@testset "Extract from source_basic.jl" begin
		include("notebooks/extract_from_source_basic.jl")
	end
	
	@testset "Extract from source_usings.jl" begin
		include("notebooks/extract_from_source_usings.jl")
	end

	@testset "Extract from source_consts.jl" begin
		include("notebooks/extract_from_source_consts.jl")
	end

	@testset "Extract from source_types.jl" begin
		include("notebooks/extract_from_source_types.jl")
	end
	
	@testset "Extract from source_unpack.jl" begin
		include("notebooks/extract_from_source_unpack.jl")
	end
	
	@testset "Extract from source_markdown.jl" begin
		include("notebooks/extract_from_source_markdown.jl")
	end
	
	@testset "Extract from source_bind.jl" begin
		include("notebooks/extract_from_source_bind.jl")
	end

	@testset "Live" begin
	    include("live.jl")
	end
end
