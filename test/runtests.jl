using RICoverAlg
using Test


@testset "Testing preprocessinput" begin include("preprocessinput_test.jl") end
@testset "Testing cover_algorithm" begin include("cover_algorithm_test.jl") end
@testset "Testing RICoverAlg" begin include("RICoverAlg_test.jl") end
# @testset "Is the package still fast" begin include("benchmarking.jl") end
