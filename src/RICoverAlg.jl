__precompile__()

module RICoverAlg


# package code goes here

export preprocessinput,convertInputsToFloats, cancelZeroStates, checkForTriviality, transform_utilities
export do_cover_iterations,cancel_zero_alternatives,run_cover_algorithm
export risolve

include("preprocessinput.jl")
include("cover_algorithm.jl")

function risolve(U, g, lmd::Number)
      # solution = (optimalProbabilityVector, Maximal Payoff, Number of Iterations, Message)
      initialIterations::Int64  = 10
      aTolSetChoiceProbToZero::Float64 = 1e-10

      Z, g, shiftterm, solution = preprocessinput(U, g, lmd::Number)
      if solution[4] == "computation necessary"
            solution = run_cover_algorithm(Z, g, initialIterations=initialIterations)
      end
      return (solution[1],lmd*(solution[2])+shiftterm,solution[3],solution[4])
end

end # module


#### ## for developing stuff
# cd("C://Users//Frank_sPro//Nextcloud//my_JuliaDev//RICoverAlg")
# using Pkg
# Pkg.activate(".")
# using Revise
# using RICoverAlg
