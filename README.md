# RICoverAlg

[![Build Status](https://travis-ci.com/FrankHuettner/RICoverAlg.jl.svg?branch=main)](https://travis-ci.com/FrankHuettner/RICoverAlg.jl)
[![Build Status](https://ci.appveyor.com/api/projects/status/github/FrankHuettner/RICoverAlg.jl?svg=true)](https://ci.appveyor.com/project/FrankHuettner/RICoverAlg-jl)
[![Coverage](https://codecov.io/gh/FrankHuettner/RICoverAlg.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/FrankHuettner/RICoverAlg.jl)
[![Coverage](https://coveralls.io/repos/github/FrankHuettner/RICoverAlg.jl/badge.svg?branch=main)](https://coveralls.io/github/FrankHuettner/RICoverAlg.jl?branch=main)


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

## Example
The code below creates Figure 1 of Matejka and McKay (2015, http://dx.doi.org/10.1257/aer.20130047):

    using RICoverAlg
    using PyPlot
    UtilTable = [0 1 0 1;
        0 0 1 1;
        1/2 1/2 1/2 1/2]
    λ = 0.4
    ρ = 0
    res = []
    for ρ=-1:0.1:1
        g = [1+ρ; 1-ρ; 1-ρ; 1+ρ]./4
        result = risolve(UtilTable, g, λ)
        push!(res,result[1][1])
    end

    plot(-1:.1:1, res, label="λ=0.4", c=:purple, marker=:square, alpha=0.6,
        xlabel="ρ", ylabel="Unconditional Choice Probability")
    plot!(-1:.1:1, 0.5:-0.0125:0.25, label="λ=0", c=:black, marker=:o, alpha=0.6)
    savefig("MM_RBT.png") 	
![alt text](doc/img/MM_RBT.png "Figure 1 of Majetka and McKay (2015) -- computation done with the package RICoverAlg")
