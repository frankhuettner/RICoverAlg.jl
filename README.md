# RICoverAlg
[![CI](https://github.com/frankhuettner/RICoverAlg.jl/actions/workflows/main.yml/badge.svg)](https://github.com/frankhuettner/RICoverAlg.jl/actions/workflows/main.yml)
[![Coverage](https://codecov.io/gh/FrankHuettner/RICoverAlg.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/FrankHuettner/RICoverAlg.jl)


This is a Julia repository to compute solutions for a discrecte rational inattention problem (Sims 2003, https://doi.org/10.1016/S0304-3932(03)00029-1) using the algorithm suggested by Thomas Cover (1984, https://doi.org/10.1109/TIT.1984.1056869).

## Installing this Package
Since this package is not registered yet, you must install it from GitHub. To add this package, execute: 

    import Pkg
    Pkg.add(url = "https://github.com/frankhuettner/RICoverAlg.jl")

## Usage
    using RICoverAlg
    risolve(UtilTable, g, λ)
where 'UtilTable' is a payoff matrix: the rows correspond to the actions, the columns to the states, and an entry is the payoff the decision maker gets in the particular combination of state and action;
'g' is vector of prior probabilities over the states;
'λ' is the unit cost of learning.

## Example (1)

	import Pkg
	Pkg.add(url = "https://github.com/frankhuettner/RICoverAlg.jl")
	using RICoverAlg
    
    UtilTable = [ 0   1   0   1;
                  0   0   1   1;
                 1/2 1/2 1/2 1/2]
    λ = 0.4
    g = [0.45, 0.05, 0.05, 0.45]
    result = risolve(UtilTable, g, λ)

    result[1][1]
    
This gives 0.27679620629020496, which is the unconditional probability of chosing action 1.
* [Here you find this code in a Pluto notebook](https://github.com/frankhuettner/RICoverAlg.jl/blob/main/doc/MM_RBT.jl).   
* You can also run the [notebook on binder](https://binder.plutojl.org/v0.16.4/open?url=https%253A%252F%252Fraw.githubusercontent.com%252Ffrankhuettner%252FRICoverAlg.jl%252Fmain%252Fdoc%252FMM_RBT.jl)


## Example (2)
The code below creates Figure 1 of Matejka and McKay (2015, http://dx.doi.org/10.1257/aer.20130047):

	import Pkg
	Pkg.add(url = "https://github.com/frankhuettner/RICoverAlg.jl")
	using RICoverAlg
    
    UtilTable = [ 0   1   0   1;
                  0   0   1   1;
                 1/2 1/2 1/2 1/2]
    λ = 0.4
    ρs = -1:0.1:1    res = []

    results = [risolve(UtilTable, [1+ρ; 1-ρ; 1-ρ; 1+ρ]./4, λ)[1][1] for ρ in ρs]

    using Plots
    plot(-1:.1:1, res, label="λ=0.4", c=:purple, marker=:square, alpha=0.6,
        xlabel="ρ", ylabel="Unconditional Choice Probability")
    plot!(-1:.1:1, 0.5:-0.0125:0.25, label="λ=0", c=:black, marker=:o, alpha=0.6)
    
![alt text](doc/img/MM_RBT.png "Figure 1 of Majetka and McKay (2015) -- computation done with the package RICoverAlg")


* [Here you find this code in a Pluto notebook](https://github.com/frankhuettner/RICoverAlg.jl/blob/main/doc/MM_RBT_plot.jl).   
* You can also run the [notebook on binder](https://binder.plutojl.org/v0.16.4/open?url=https%253A%252F%252Fraw.githubusercontent.com%252Ffrankhuettner%252FRICoverAlg.jl%252Fmain%252Fdoc%252FMM_RBT_plot.jl)

