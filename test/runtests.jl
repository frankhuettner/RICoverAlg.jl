using RICoverAlg
using Test


@testset "Testing Preprocessing" begin include("preprocessinput_test.jl") end
@testset "Testing algorithm" begin include("cover_algorithm_test.jl") end
@testset "Testing whole package" begin include("RICoverAlg_test.jl") end
@testset "Is the package still fast" begin include("benchmarking.jl") end
