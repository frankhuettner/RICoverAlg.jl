__precompile__()

module RICoverAlg


# package code goes here

export preprocessinput,convertInputsToFloats, cancelZeroStates, checkForTriviality, transform_utilities
export do_cover_iterations,cancel_zero_alternatives,run_cover_algorithm,compute_factor
export risolve, checkOptimalityOfp

include("preprocessinput.jl")
include("cover_algorithm.jl")

function checkOptimalityOfp(U,g,lmd,p)
      Z = exp.(U./lmd)
      ϵ_max = lmd * log(findmax(compute_factor(Z,g,p))[1])
      payoff = lmd * ((log.(p'*Z))*g)[1]
      return payoff, ϵ_max, payoff/(ϵ_max+payoff)
end

function risolve(U, g, lmd;
                  initialIterations::Int  = 10,
                  aTolSetChoiceProbToZero::Float64 = sqrt(eps()),
                  aTolerance4Stopping::Float64 = 0.0,
                  maxIterations::Int = 9999)
      # solution = (optimalProbabilityVector, Maximal Payoff, Number of Iterations, Message)
      ϵ_max = 0
      Z, g, shiftterm, solution = preprocessinput(U, g, lmd)

      if solution[4] == "Run Cover Algorithm"
            ## running cover algorithm
            solution = run_cover_algorithm(Z, g,
                                          initialIterations  = initialIterations,
                                          aTolSetChoiceProbToZero = aTolSetChoiceProbToZero,
                                          aTolerance4Stopping = aTolerance4Stopping,
                                          maxIterations = maxIterations)
            ## computing optimality bounds
            ϵ_max = lmd * log(findmax(compute_factor(Z,g,solution[1]))[1])
      end

      payoff = lmd*(solution[2])+shiftterm
      mention_if_beyond_maxIterations = ""
      if solution[3] >= maxIterations
            mention_if_beyond_maxIterations = ", i.e., we reached maxIterations so that we aborted"
      end
      output_message = solution[4] * "; Number of iterations: $(solution[3])"*
                        mention_if_beyond_maxIterations*
                        "; Resulting payoff $payoff is $(payoff/(ϵ_max+payoff))"*
                        " optimal (maximal payoff <= $(ϵ_max+payoff))"
      return (solution[1],payoff,output_message)
end

end # module


#### ## for developing stuff
# cd("C://Users//Frank_sPro//Nextcloud//my_JuliaDev//RICoverAlg")
# using Pkg
# Pkg.activate(".")
# using Revise
# using RICoverAlg
