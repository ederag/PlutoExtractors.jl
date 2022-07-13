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
	@testset "try" begin
	    include("try.jl")
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

	@testset "Extract from source_structs.jl" begin
		include("notebooks/extract_from_source_structs.jl")
	end
end
